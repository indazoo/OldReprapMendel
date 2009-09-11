"""
Stretch is a script to stretch the threads to partially compensate for filament shrinkage when extruded.

The default 'Activate Stretch' checkbox is off.  When it is on, the functions described below will work, when it is off, the functions
will not be called.

The important value for the stretch preferences is "Perimeter Maximum Stretch Over Extrusion Width (ratio)" which is the ratio of
the maximum amount the perimeter thread will be stretched compared to the extrusion width, the default is 0.3.  The higher the
value the more it will stretch the perimeter and the wider holes will be.  If the value is too small, the holes will have to be
drilled out after fabrication, if the value is too high, the holes will be too wide and the part will have to junked, so the default is
low.  The 'Loop Stretch Over Extrusion Width' is the ratio of the maximum amount the loop aka shell threads will be stretched
compared to the extrusion width, in general this value should be around half the Perimeter Maximum Stretch preference.  The
'Path Stretch Over Extrusion Width' is the ratio of the maximum amount the threads which are not loops, like the infill threads,
will be stretched compared to the extrusion width, the default is 0.

In general, stretch will widen holes and push corners out.  The algorithm works by checking at each turning point on the
extrusion path what the direction of the thread is at a distance of "Stretch from Distance over Extrusion Width (ratio)" times the
extrusion width, on both sides, and moves the thread in the opposite direction.  The magnitude of the stretch increases with the
amount that the direction of the two threads is similar and by the Stretch Over Extrusion Width ratio.  The script then also
stretches the thread at two locations on the path on close to the turning points.  In practice the filament contraction will be
similar but different from the algorithm, so even once the optimal parameters are determined, the stretch script will not be able
to eliminate the inaccuracies caused by contraction, but it should reduce them.  To run stretch, in a shell type:
> python stretch.py

The following examples stretch the files Screw Holder Bottom.gcode & Screw Holder Bottom.stl.  The examples are run in a terminal in the
folder which contains Screw Holder Bottom.gcode, Screw Holder Bottom.stl and stretch.py.  The functions writeOutput and
getChainGcode check to see if the text has been stretched, if not they call the getChainGcode in cool.py to cool the
text; once they have the cooled text, then they stretch.


> python stretch.py Screw Holder Bottom.stl
File Screw Holder Bottom.stl is being chain stretched.
The stretched file is saved as Screw Holder Bottom_stretch.gcode


> python stretch.py
This brings up the dialog, after clicking 'Stretch', the following is printed:
File Screw Holder Bottom.stl is being chain stretched.
The stretched file is saved as Screw Holder Bottom_stretch.gcode


> python
Python 2.5.1 (r251:54863, Sep 22 2007, 01:43:31)
[GCC 4.2.1 (SUSE Linux)] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> import stretch
>>> stretch.main()
This brings up the stretch dialog.


>>> stretch.writeOutput()
Screw Holder Bottom.stl
File Screw Holder Bottom.stl is being chain stretched.
The stretched file is saved as Screw Holder Bottom_stretch.gcode

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
from skeinforge_tools.skeinforge_utilities.vector3 import Vector3
from skeinforge_tools import polyfile
import sys


__author__ = "Enrique Perez (perez_enrique@yahoo.com)"
__date__ = "$Date: 2008/21/04 $"
__license__ = "GPL 3.0"


#maybe speed up feedrate option
def getCraftedText( fileName, text, stretchPreferences = None ):
	"Stretch a gcode linear move text."
	return getCraftedTextFromText( gcodec.getTextIfEmpty( fileName, text ), stretchPreferences )

def getCraftedTextFromText( gcodeText, stretchPreferences = None ):
	"Stretch a gcode linear move text."
	if gcodec.isProcedureDoneOrFileIsEmpty( gcodeText, 'stretch' ):
		return gcodeText
	if stretchPreferences == None:
		stretchPreferences = preferences.getReadPreferences( StretchPreferences() )
	if not stretchPreferences.activateStretch.value:
		return gcodeText
	return StretchSkein().getCraftedGcode( gcodeText, stretchPreferences )

def getDisplayedPreferences():
	"Get the displayed preferences."
	return preferences.getDisplayedDialogFromConstructor( StretchPreferences() )

def writeOutput( fileName = '' ):
	"Stretch a gcode linear move file.  Chain stretch the gcode if it is not already stretched.  If no fileName is specified, stretch the first unmodified gcode file in this folder."
	fileName = interpret.getFirstTranslatorFileNameUnmodified( fileName )
	if fileName == '':
		return
	consecution.writeChainText( fileName, ' is being chain stretched.', 'The stretched file is saved as ', 'stretch' )


class LineIteratorBackward:
	"Backward line iterator class."
	def __init__( self, isLoop, lineIndex, lines ):
		self.firstLineIndex = None
		self.isLoop = isLoop
		self.lineIndex = lineIndex
		self.lines = lines

	def getIndexBeforeNextDeactivate( self ):
		"Get index two lines before the deactivate command."
		for lineIndex in xrange( self.lineIndex + 1, len( self.lines ) ):
			line = self.lines[ lineIndex ]
			splitLine = line.split()
			firstWord = gcodec.getFirstWord( splitLine )
			if firstWord == 'M103':
				return lineIndex - 2
		print( 'This should never happen in stretch, no deactivate command was found for this thread.' )
		raise StopIteration, "You've reached the end of the line."

	def getNext( self ):
		"Get next line going backward or raise exception."
		while self.lineIndex > 3:
			if self.lineIndex == self.firstLineIndex:
				raise StopIteration, "You've reached the end of the line."
			if self.firstLineIndex == None:
				self.firstLineIndex = self.lineIndex
			nextLineIndex = self.lineIndex - 1
			line = self.lines[ self.lineIndex ]
			splitLine = line.split()
			firstWord = gcodec.getFirstWord( splitLine )
			if firstWord == 'M103':
				if self.isLoop:
					nextLineIndex = self.getIndexBeforeNextDeactivate()
				else:
					raise StopIteration, "You've reached the end of the line."
			if firstWord == 'G1':
				if self.isBeforeExtrusion():
					if self.isLoop:
						nextLineIndex = self.getIndexBeforeNextDeactivate()
					else:
						raise StopIteration, "You've reached the end of the line."
				else:
					self.lineIndex = nextLineIndex
					return line
			self.lineIndex = nextLineIndex
		raise StopIteration, "You've reached the end of the line."

	def isBeforeExtrusion( self ):
		"Determine if index is two or more before activate command."
		linearMoves = 0
		for lineIndex in xrange( self.lineIndex + 1, len( self.lines ) ):
			line = self.lines[ lineIndex ]
			splitLine = line.split()
			firstWord = gcodec.getFirstWord( splitLine )
			if firstWord == 'G1':
				linearMoves += 1
			if firstWord == 'M101':
				return linearMoves > 0
			if firstWord == 'M103':
				return False
		print( 'This should never happen in isBeforeExtrusion in stretch, no activate command was found for this thread.' )
		return False


class LineIteratorForward:
	"Forward line iterator class."
	def __init__( self, isLoop, lineIndex, lines ):
		self.firstLineIndex = None
		self.isLoop = isLoop
		self.lineIndex = lineIndex
		self.lines = lines

	def getIndexJustAfterActivate( self ):
		"Get index just after the activate command."
		for lineIndex in xrange( self.lineIndex - 1, 3, - 1 ):
			line = self.lines[ lineIndex ]
			splitLine = line.split()
			firstWord = gcodec.getFirstWord( splitLine )
			if firstWord == 'M101':
				return lineIndex + 1
		print( 'This should never happen in stretch, no activate command was found for this thread.' )
		raise StopIteration, "You've reached the end of the line."

	def getNext( self ):
		"Get next line or raise exception."
		while self.lineIndex < len( self.lines ):
			if self.lineIndex == self.firstLineIndex:
				raise StopIteration, "You've reached the end of the line."
			if self.firstLineIndex == None:
				self.firstLineIndex = self.lineIndex
			nextLineIndex = self.lineIndex + 1
			line = self.lines[ self.lineIndex ]
			splitLine = line.split()
			firstWord = gcodec.getFirstWord( splitLine )
			if firstWord == 'M103':
				if self.isLoop:
					nextLineIndex = self.getIndexJustAfterActivate()
				else:
					raise StopIteration, "You've reached the end of the line."
			self.lineIndex = nextLineIndex
			if firstWord == 'G1':
				return line
		raise StopIteration, "You've reached the end of the line."


class StretchPreferences:
	"A class to handle the stretch preferences."
	def __init__( self ):
		"Set the default preferences, execute title & preferences fileName."
		#Set the default preferences.
		self.archive = []
		self.activateStretch = preferences.BooleanPreference().getFromValue( 'Activate Stretch', False )
		self.archive.append( self.activateStretch )
		self.loopStretchOverExtrusionWidth = preferences.FloatPreference().getFromValue( 'Loop Stretch Over Extrusion Width (ratio):', 0.15 )
		self.archive.append( self.loopStretchOverExtrusionWidth )
		self.pathStretchOverExtrusionWidth = preferences.FloatPreference().getFromValue( 'Path Stretch Over Extrusion Width (ratio):', 0.0 )
		self.archive.append( self.pathStretchOverExtrusionWidth )
		self.fileNameInput = preferences.Filename().getFromFilename( interpret.getGNUTranslatorGcodeFileTypeTuples(), 'Open File to be Stretched', '' )
		self.archive.append( self.fileNameInput )
		self.stretchFromDistanceOverExtrusionWidth = preferences.FloatPreference().getFromValue( 'Stretch From Distance Over Extrusion Width (ratio):', 2.0 )
		self.archive.append( self.stretchFromDistanceOverExtrusionWidth )
		self.perimeterStretchOverExtrusionWidth = preferences.FloatPreference().getFromValue( 'Perimeter Maximum Stretch Over Extrusion Width (ratio):', 0.3 )
		self.archive.append( self.perimeterStretchOverExtrusionWidth )
		#Create the archive, title of the execute button, title of the dialog & preferences fileName.
		self.executeTitle = 'Stretch'
		self.saveTitle = 'Save Preferences'
		preferences.setHelpPreferencesFileNameTitleWindowPosition( self, 'skeinforge_tools.craft_plugins.stretch.html' )

	def execute( self ):
		"Stretch button has been clicked."
		fileNames = polyfile.getFileOrDirectoryTypesUnmodifiedGcode( self.fileNameInput.value, interpret.getImportPluginFilenames(), self.fileNameInput.wasCancelled )
		for fileName in fileNames:
			writeOutput( fileName )


class StretchSkein:
	"A class to stretch a skein of extrusions."
	def __init__( self ):
		self.distanceFeedRate = gcodec.DistanceFeedRate()
		self.extruderActive = False
		self.feedrateMinute = 959.0
		self.isLoop = False
		self.lineIndex = 0
		self.lines = None
		self.oldLocation = None
		self.perimeterWidth = 0.4

	def addAlongWayLine( self, alongWay, location ):
		"Add stretched gcode line, along the way from the location to the old location."
		alongWayLocation = euclidean.getIntermediateLocation( alongWay, location, self.oldLocation )
		alongWayLine = self.getStretchedLineFromIndexLocation( self.lineIndex - 1, self.lineIndex, alongWayLocation )
		self.distanceFeedRate.addLine( alongWayLine )

	def addStretchesBeforePoint( self, location ):
		"Get stretched gcode line."
		distanceToOld = location.distance( self.oldLocation )
		if distanceToOld == 0.0:
			print( 'This should never happen, stretch should never see two identical points in a row.' )
			print( location )
			return
		alongRatio = self.stretchFromDistance / distanceToOld
		if alongRatio > 0.7:
			return
		if alongRatio > 0.33333333333:
			alongRatio = 0.33333333333
		self.addAlongWayLine( 1.0 - alongRatio, location )
		self.addAlongWayLine( alongRatio, location )

	def getCraftedGcode( self, gcodeText, stretchPreferences ):
		"Parse gcode text and store the stretch gcode."
		self.lines = gcodec.getTextLines( gcodeText )
		self.stretchPreferences = stretchPreferences
		self.parseInitialization()
		for self.lineIndex in xrange( self.lineIndex, len( self.lines ) ):
			line = self.lines[ self.lineIndex ]
			self.parseStretch( line )
		return self.distanceFeedRate.output.getvalue()

	def getRelativeStretch( self, location, lineIndexRange ):
		"Get relative stretch for a location minus a point."
		locationComplex = location.dropAxis( 2 )
		lastLocationComplex = locationComplex
		oldTotalLength = 0.0
		pointComplex = locationComplex
		totalLength = 0.0
		while 1:
			try:
				line = lineIndexRange.getNext()
			except StopIteration:
				locationMinusPoint = locationComplex - pointComplex
				locationMinusPointLength = abs( locationMinusPoint )
				if locationMinusPointLength > 0.0:
					return locationMinusPoint / locationMinusPointLength
				return complex()
			splitLine = line.split()
			firstWord = splitLine[ 0 ]
			pointComplex = gcodec.getLocationFromSplitLine( self.oldLocation, splitLine ).dropAxis( 2 )
			locationMinusPoint = lastLocationComplex - pointComplex
			locationMinusPointLength = abs( locationMinusPoint )
			totalLength += locationMinusPointLength
			if totalLength >= self.stretchFromDistance:
				distanceFromRatio = ( self.stretchFromDistance - oldTotalLength ) / locationMinusPointLength
				totalPoint = distanceFromRatio * pointComplex + ( 1.0 - distanceFromRatio ) * lastLocationComplex
				locationMinusTotalPoint = locationComplex - totalPoint
				return locationMinusTotalPoint / self.stretchFromDistance
			lastLocationComplex = pointComplex
			oldTotalLength = totalLength

	def getStretchedLine( self, splitLine ):
		"Get stretched gcode line."
		location = gcodec.getLocationFromSplitLine( self.oldLocation, splitLine )
		self.feedrateMinute = gcodec.getFeedrateMinute( self.feedrateMinute, splitLine )
		if self.oldLocation != None:
			if self.extruderActive and self.threadMaximumAbsoluteStretch > 0.0:
				self.addStretchesBeforePoint( location )
		self.oldLocation = location
		if self.extruderActive and self.threadMaximumAbsoluteStretch > 0.0:
			return self.getStretchedLineFromIndexLocation( self.lineIndex - 1, self.lineIndex + 1, location )
		if self.isJustBeforeExtrusion() and self.threadMaximumAbsoluteStretch > 0.0:
			return self.getStretchedLineFromIndexLocation( self.lineIndex - 1, self.lineIndex + 1, location )
		return self.lines[ self.lineIndex ]

	def getStretchedLineFromIndexLocation( self, indexPreviousStart, indexNextStart, location ):
		"Get stretched gcode line from line index and location."
		nextRange = LineIteratorForward( self.isLoop, indexNextStart, self.lines )
		previousRange = LineIteratorBackward( self.isLoop, indexPreviousStart, self.lines )
		relativeStretch = self.getRelativeStretch( location, nextRange ) + self.getRelativeStretch( location, previousRange )
		relativeStretch *= 0.8
		relativeStretchLength = abs( relativeStretch )
		if relativeStretchLength > 1.0:
			relativeStretch /= relativeStretchLength
		absoluteStretch = relativeStretch * self.threadMaximumAbsoluteStretch
		stretchedPoint = location.dropAxis( 2 ) + absoluteStretch
		return self.distanceFeedRate.getLinearGcodeMovementWithFeedrate( self.feedrateMinute, stretchedPoint, location.z )

	def isJustBeforeExtrusion( self ):
		"Determine if activate command is before linear move command."
		for lineIndex in xrange( self.lineIndex + 1, len( self.lines ) ):
			line = self.lines[ lineIndex ]
			splitLine = line.split()
			firstWord = gcodec.getFirstWord( splitLine )
			if firstWord == 'G1' or firstWord == 'M103':
				return False
			if firstWord == 'M101':
				return True
		print( 'This should never happen in isJustBeforeExtrusion in stretch, no activate or deactivate command was found for this thread.' )
		return False

	def parseInitialization( self ):
		"Parse gcode initialization and store the parameters."
		for self.lineIndex in xrange( len( self.lines ) ):
			line = self.lines[ self.lineIndex ]
			splitLine = line.split()
			firstWord = gcodec.getFirstWord( splitLine )
			self.distanceFeedRate.parseSplitLine( firstWord, splitLine )
			if firstWord == '(<decimalPlacesCarried>':
				self.decimalPlacesCarried = int( splitLine[ 1 ] )
			elif firstWord == '(</extruderInitialization>)':
				self.distanceFeedRate.addLine( '(<procedureDone> stretch </procedureDone>)' )
				return
			elif firstWord == '(<perimeterWidth>':
				perimeterWidth = float( splitLine[ 1 ] )
				self.loopMaximumAbsoluteStretch = self.perimeterWidth * self.stretchPreferences.loopStretchOverExtrusionWidth.value
				self.pathAbsoluteStretch = self.perimeterWidth * self.stretchPreferences.pathStretchOverExtrusionWidth.value
				self.perimeterMaximumAbsoluteStretch = self.perimeterWidth * self.stretchPreferences.perimeterStretchOverExtrusionWidth.value
				self.stretchFromDistance = self.stretchPreferences.stretchFromDistanceOverExtrusionWidth.value * perimeterWidth
				self.threadMaximumAbsoluteStretch = self.pathAbsoluteStretch
			self.distanceFeedRate.addLine( line )

	def parseStretch( self, line ):
		"Parse a gcode line and add it to the stretch skein."
		splitLine = line.split()
		if len( splitLine ) < 1:
			return
		firstWord = splitLine[ 0 ]
		if firstWord == 'G1':
			line = self.getStretchedLine( splitLine )
		elif firstWord == 'M101':
			self.extruderActive = True
		elif firstWord == 'M103':
			self.extruderActive = False
			self.isLoop = False
			self.threadMaximumAbsoluteStretch = self.pathAbsoluteStretch
		elif firstWord == '(<loop>)':
			self.isLoop = True
			self.threadMaximumAbsoluteStretch = self.loopMaximumAbsoluteStretch
		elif firstWord == '(<perimeter>)':
			self.isLoop = True
			self.threadMaximumAbsoluteStretch = self.perimeterMaximumAbsoluteStretch
		self.distanceFeedRate.addLine( line )


def main():
	"Display the stretch dialog."
	if len( sys.argv ) > 1:
		writeOutput( ' '.join( sys.argv[ 1 : ] ) )
	else:
		getDisplayedPreferences().root.mainloop()

if __name__ == "__main__":
	main()
