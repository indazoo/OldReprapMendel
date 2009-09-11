"""
Cool is a script to cool the shape.

Allan Ecker aka The Masked Retriever's has written the following quicktip for cool.
"Skeinforge Quicktip: Cool" at: http://blog.thingiverse.com/2009/07/28/skeinforge-quicktip-cool/

The default 'Activate Cool' checkbox is on.  When it is on, the functions described below will work, when it is off, the functions
will not be called.

The important value for the cool preferences is "Minimum Layer Time (seconds)" which is the minimum amount of time the
extruder will spend on a layer.  If it takes less time to extrude the layer than the minimum layer time, cool adds orbits with the
extruder off to give the layer time to cool, so that the next layer is not extruded on a molten base.  The orbits will be around the
largest island on that layer.  If the area of the largest island is as large as the square of the "Minimum Orbital Radius" then the
orbits will be just within the island.  If the island is smaller, then the orbits will be in a square of the "Minimum Orbital Radius"
around the center of the island.

Before the orbits, if there is a file cool_start.txt, cool will add that to the start of the orbits. After it has added the orbits, it will
add the file cool_end.txt if it exists.  Cool does not care if the text file names are capitalized, but some file systems do not
handle file name cases properly, so to be on the safe side you should give them lower case names.  Cool looks for those files
in the alterations folder in the .skeinforge folder in the home directory. If it doesn't find the file it then looks in the alterations
folder in the skeinforge_tools folder. If it doesn't find anything there it looks in the skeinforge_tools folder.  The cool start and
end text idea is from:
http://makerhahn.blogspot.com/2008/10/yay-minimug.html

If the 'Turn Fan On at Beginning' preference is true, cool will turn the fan on at the beginning of the fabrication.  If the
'Turn Fan Off at Ending' preference is true, cool will turn the fan off at the ending of the fabrication.

To run cool, in a shell which cool is in type:
> python cool.py

The following examples cool the files Screw Holder Bottom.gcode & Screw Holder Bottom.stl.  The examples are run in a terminal in the
folder which contains Screw Holder Bottom.gcode, Screw Holder Bottom.stl and cool.py.  The cool function will cool if the 'Activate Cool'
checkbox is on.  The functions writeOutput and getChainGcode check to see if the text has been cooled, if not they
call the getChainGcode in clip.py to clip the text; once they have the clipped text, then they cool.


> python cool.py
This brings up the dialog, after clicking 'Cool', the following is printed:
File Screw Holder Bottom.stl is being chain cooled.
The extrusion fill density ratio is 0.853
The cooled file is saved as Screw Holder Bottom.gcode
The scalable vector graphics file is saved as Hollow_Square_cool.svg
It took 34 seconds to cool the file.


> python cool.py Screw Holder Bottom.stl
File Screw Holder Bottom.stl is being chain cooled.
The extrusion fill density ratio is 0.853
The cooled file is saved as Screw Holder Bottom.gcode
The scalable vector graphics file is saved as Hollow_Square_cool.svg
It took 34 seconds to cool the file.


> python
Python 2.5.1 (r251:54863, Sep 22 2007, 01:43:31)
[GCC 4.2.1 (SUSE Linux)] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> import cool
>>> cool.main()
This brings up the cool dialog.


>>> cool.writeOutput()
File Screw Holder Bottom.stl is being chain cooled.
The extrusion fill density ratio is 0.853
The cooled file is saved as Screw Holder Bottom.gcode
The scalable vector graphics file is saved as Hollow_Square_cool.svg
It took 34 seconds to cool the file.

"""

from __future__ import absolute_import
#Init has to be imported first because it has code to workaround the python bug where relative imports don't work if the module is imported as a main module.
import __init__

from skeinforge_tools.skeinforge_utilities import consecution
from skeinforge_tools.skeinforge_utilities import euclidean
from skeinforge_tools.skeinforge_utilities import gcodec
from skeinforge_tools.skeinforge_utilities import intercircle
from skeinforge_tools.skeinforge_utilities import interpret
from skeinforge_tools.skeinforge_utilities import preferences
from skeinforge_tools import polyfile
import math
import os
import sys


__author__ = "Enrique Perez (perez_enrique@yahoo.com)"
__date__ = "$Date: 2008/21/04 $"
__license__ = "GPL 3.0"


def getCraftedText( fileName, text, coolPreferences = None ):
	"Cool a gcode linear move text."
	return getCraftedTextFromText( gcodec.getTextIfEmpty( fileName, text ), coolPreferences )

def getCraftedTextFromText( gcodeText, coolPreferences = None ):
	"Cool a gcode linear move text."
	if gcodec.isProcedureDoneOrFileIsEmpty( gcodeText, 'cool' ):
		return gcodeText
	if coolPreferences == None:
		coolPreferences = preferences.getReadPreferences( CoolPreferences() )
	if not coolPreferences.activateCool.value:
		return gcodeText
	return CoolSkein().getCraftedGcode( gcodeText, coolPreferences )

def getDisplayedPreferences():
	"Get the displayed preferences."
	return preferences.getDisplayedDialogFromConstructor( CoolPreferences() )

def writeOutput( fileName = '' ):
	"Cool a gcode linear move file.  Chain cool the gcode if it is not already cooled. If no fileName is specified, cool the first unmodified gcode file in this folder."
	fileName = interpret.getFirstTranslatorFileNameUnmodified( fileName )
	if fileName == '':
		return
	consecution.writeChainText( fileName, ' is being chain cooled.', 'The cooled file is saved as ', 'cool' )


class CoolPreferences:
	"A class to handle the cool preferences."
	def __init__( self ):
		"Set the default preferences, execute title & preferences fileName."
		#Set the default preferences.
		self.archive = []
		self.activateCool = preferences.BooleanPreference().getFromValue( 'Activate Cool', True )
		self.archive.append( self.activateCool )
		self.fileNameInput = preferences.Filename().getFromFilename( interpret.getGNUTranslatorGcodeFileTypeTuples(), 'Open File to be Cooled', '' )
		self.archive.append( self.fileNameInput )
		self.minimumLayerTime = preferences.FloatPreference().getFromValue( 'Minimum Layer Time (seconds):', 60.0 )
		self.archive.append( self.minimumLayerTime )
		self.minimumOrbitalRadius = preferences.FloatPreference().getFromValue( 'Minimum Orbital Radius (millimeters):', 10.0 )
		self.archive.append( self.minimumOrbitalRadius )
		self.turnFanOnAtBeginning = preferences.BooleanPreference().getFromValue( 'Turn Fan On at Beginning', True )
		self.archive.append( self.turnFanOnAtBeginning )
		self.turnFanOffAtEnding = preferences.BooleanPreference().getFromValue( 'Turn Fan Off at Ending', True )
		self.archive.append( self.turnFanOffAtEnding )
		#Create the archive, title of the execute button, title of the dialog & preferences fileName.
		self.executeTitle = 'Cool'
		self.saveTitle = 'Save Preferences'
		preferences.setHelpPreferencesFileNameTitleWindowPosition( self, 'skeinforge_tools.craft_plugins.cool.html' )

	def execute( self ):
		"Cool button has been clicked."
		fileNames = polyfile.getFileOrDirectoryTypesUnmodifiedGcode( self.fileNameInput.value, interpret.getImportPluginFilenames(), self.fileNameInput.wasCancelled )
		for fileName in fileNames:
			writeOutput( fileName )


class CoolSkein:
	"A class to cool a skein of extrusions."
	def __init__( self ):
		self.boundaryLayer = None
		self.distanceFeedRate = gcodec.DistanceFeedRate()
		self.feedrateMinute = 960.0
		self.highestZ = - 99999999.9
		self.layerTime = 0.0
		self.lineIndex = 0
		self.lines = None
		self.oldLocation = None

	def addCoolOrbits( self, remainingOrbitTime ):
		"Add the minimum radius cool orbits."
		if len( self.boundaryLayer.loops ) < 1:
			return
		perimeterOutset = - 0.4 * self.perimeterWidth
		outsetBoundaryLoops = intercircle.getInsetLoopsFromLoops( perimeterOutset, self.boundaryLayer.loops )
		if len( outsetBoundaryLoops ) < 1:
			outsetBoundaryLoops = self.boundaryLayer.loops
		largestLoop = euclidean.getLargestLoop( outsetBoundaryLoops )
		loopArea = abs( euclidean.getPolygonArea( largestLoop ) )
		if loopArea < self.minimumArea:
			center = 0.5 * ( euclidean.getMaximumFromPoints( largestLoop ) + euclidean.getMinimumFromPoints( largestLoop ) )
			maximumCorner = center + self.halfCorner
			minimumCorner = center - self.halfCorner
			largestLoop = euclidean.getSquareLoop( minimumCorner, maximumCorner )
		pointComplex = euclidean.getXYComplexFromVector3( self.oldLocation )
		if pointComplex != None:
			largestLoop = euclidean.getLoopStartingNearest( self.perimeterWidth, pointComplex, largestLoop )
		intercircle.addOrbits( largestLoop, self, remainingOrbitTime, self.highestZ )

	def addGcodeFromFeedrateMovementZ( self, feedrateMinute, point, z ):
		"Add a movement to the output."
		self.distanceFeedRate.addLine( self.distanceFeedRate.getLinearGcodeMovementWithFeedrate( feedrateMinute, point, z ) )

	def getCraftedGcode( self, gcodeText, coolPreferences ):
		"Parse gcode text and store the cool gcode."
		self.coolPreferences = coolPreferences
		self.coolEndText = preferences.getFileInGivenPreferencesDirectory( os.path.dirname( __file__ ), 'Cool_End.txt' )
		self.coolEndLines = gcodec.getTextLines( self.coolEndText )
		self.coolStartText = preferences.getFileInGivenPreferencesDirectory( os.path.dirname( __file__ ), 'Cool_Start.txt' )
		self.coolStartLines = gcodec.getTextLines( self.coolStartText )
		self.halfCorner = complex( coolPreferences.minimumOrbitalRadius.value, coolPreferences.minimumOrbitalRadius.value )
		self.lines = gcodec.getTextLines( gcodeText )
		self.minimumArea = 4.0 * coolPreferences.minimumOrbitalRadius.value * coolPreferences.minimumOrbitalRadius.value
		self.parseInitialization()
		for self.lineIndex in xrange( self.lineIndex, len( self.lines ) ):
			line = self.lines[ self.lineIndex ]
			self.parseLine( line )
		if coolPreferences.turnFanOffAtEnding.value:
			self.distanceFeedRate.addLine( 'M107' )
		return self.distanceFeedRate.output.getvalue()

	def linearMove( self, splitLine ):
		"Add line to time spent on layer."
		self.feedrateMinute = gcodec.getFeedrateMinute( self.feedrateMinute, splitLine )
		location = gcodec.getLocationFromSplitLine( self.oldLocation, splitLine )
		if self.oldLocation != None:
			feedrateSecond = self.feedrateMinute / 60.0
			self.layerTime += location.distance( self.oldLocation ) / feedrateSecond
		self.highestZ = max( location.z, self.highestZ )
		self.oldLocation = location

	def parseInitialization( self ):
		"Parse gcode initialization and store the parameters."
		for self.lineIndex in xrange( len( self.lines ) ):
			line = self.lines[ self.lineIndex ]
			splitLine = line.split()
			firstWord = gcodec.getFirstWord( splitLine )
			self.distanceFeedRate.parseSplitLine( firstWord, splitLine )
			if firstWord == '(<perimeterWidth>':
				self.perimeterWidth = float( splitLine[ 1 ] )
				if self.coolPreferences.turnFanOnAtBeginning.value:
					self.distanceFeedRate.addLine( 'M106' )
			elif firstWord == '(</extruderInitialization>)':
				self.distanceFeedRate.addLine( '(<procedureDone> cool </procedureDone>)' )
				return
			elif firstWord == '(<orbitalFeedratePerSecond>':
				self.orbitalFeedratePerSecond = float( splitLine[ 1 ] )
			self.distanceFeedRate.addLine( line )

	def parseLine( self, line ):
		"Parse a gcode line and add it to the cool skein."
		splitLine = line.split()
		if len( splitLine ) < 1:
			return
		firstWord = splitLine[ 0 ]
		if firstWord == 'G1':
			self.linearMove( splitLine )
		elif firstWord == '(<boundaryPoint>':
			self.boundaryLoop.append( gcodec.getLocationFromSplitLine( None, splitLine ).dropAxis( 2 ) )
		elif firstWord == '(<layer>':
			self.distanceFeedRate.addLine( line )
			self.distanceFeedRate.addLines( self.coolStartLines )
			remainingOrbitTime = self.coolPreferences.minimumLayerTime.value - self.layerTime
			if remainingOrbitTime > 0.0 and self.boundaryLayer != None:
				self.addCoolOrbits( remainingOrbitTime )
			z = float( splitLine[ 1 ] )
			self.boundaryLayer = euclidean.LoopLayer( z )
			self.highestZ = z
			self.layerTime = 0.0
			self.distanceFeedRate.addLines( self.coolEndLines )
			return
		elif firstWord == '(<surroundingLoop>)':
			self.boundaryLoop = []
			self.boundaryLayer.loops.append( self.boundaryLoop )
		self.distanceFeedRate.addLine( line )


def main():
	"Display the cool dialog."
	if len( sys.argv ) > 1:
		writeOutput( ' '.join( sys.argv[ 1 : ] ) )
	else:
		getDisplayedPreferences().root.mainloop()

if __name__ == "__main__":
	main()
