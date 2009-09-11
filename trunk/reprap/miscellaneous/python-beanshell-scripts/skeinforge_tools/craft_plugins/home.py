"""
Home is a script to home the nozzle.

The default 'Activate Home' checkbox is on.  When it is on, the functions described below will work, when it is off, the functions
will not be called.

At the beginning of a each layer, home will add the commands of a gcode script with the name of the "Name of Homing File"
setting, if one exists.  The default name is homing.text.  Home does not care if the text file names are capitalized, but some file
systems do not handle file name cases properly, so to be on the safe side you should give them lower case names.  Home
looks for those files in the alterations folder in the .skeinforge folder in the home directory. If it doesn't find the file it then looks
in the alterations folder in the skeinforge_tools folder.  If it doesn't find anything there it looks in the craft_plugins folder.

To run home, in a shell which home is in type:
> python home.py

The following examples homes the files Screw Holder Bottom.gcode & Screw Holder Bottom.stl.  The examples are run in a
terminal in the folder which contains Screw Holder Bottom.gcode, Screw Holder Bottom.stl and home.py.  The home function
will home if the 'Activate Home' checkbox is on.  The functions writeOutput and getChainGcode check to see if the text
has been homed, if not they call the getChainGcode in fillet.py to fillet the text; once they have the
filleted text, then they home.


> python home.py
This brings up the dialog, after clicking 'Home', the following is printed:
File Screw Holder Bottom.stl is being chain homed.
The homed file is saved as Screw Holder Bottom_home.gcode


> python home.py Screw Holder Bottom.stl
File Screw Holder Bottom.stl is being chain homed.
The homed file is saved as Screw Holder Bottom_home.gcode


> python
Python 2.5.1 (r251:54863, Sep 22 2007, 01:43:31)
[GCC 4.2.1 (SUSE Linux)] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> import home
>>> home.main()
This brings up the home dialog.


>>> home.writeOutput()
File Screw Holder Bottom.stl is being chain homed.
The homed file is saved as Screw Holder Bottom_home.gcode

"""

from __future__ import absolute_import
#Init has to be imported first because it has code to workaround the python bug where relative imports don't work if the module is imported as a main module.
import __init__

from skeinforge_tools import polyfile
from skeinforge_tools.skeinforge_utilities import consecution
from skeinforge_tools.skeinforge_utilities import euclidean
from skeinforge_tools.skeinforge_utilities import gcodec
from skeinforge_tools.skeinforge_utilities import interpret
from skeinforge_tools.skeinforge_utilities import preferences
from skeinforge_tools.skeinforge_utilities.vector3 import Vector3
import math
import os
import sys


__author__ = "Enrique Perez (perez_enrique@yahoo.com)"
__date__ = "$Date: 2008/21/04 $"
__license__ = "GPL 3.0"


def getCraftedText( fileName, text, homePreferences = None ):
	"Home a gcode linear move file or text."
	return getCraftedTextFromText( gcodec.getTextIfEmpty( fileName, text ), homePreferences )

def getCraftedTextFromText( gcodeText, homePreferences = None ):
	"Home a gcode linear move text."
	if gcodec.isProcedureDoneOrFileIsEmpty( gcodeText, 'home' ):
		return gcodeText
	if homePreferences == None:
		homePreferences = preferences.getReadPreferences( HomePreferences() )
	if not homePreferences.activateHome.value:
		return gcodeText
	return HomeSkein().getCraftedGcode( gcodeText, homePreferences )

def getDisplayedPreferences():
	"Get the displayed preferences."
	return preferences.getDisplayedDialogFromConstructor( HomePreferences() )

def writeOutput( fileName = '' ):
	"Home a gcode linear move file.  Chain home the gcode if it is not already homed. If no fileName is specified, home the first unmodified gcode file in this folder."
	fileName = interpret.getFirstTranslatorFileNameUnmodified( fileName )
	if fileName == '':
		return
	consecution.writeChainText( fileName, ' is being chain homed.', 'The homed file is saved as ', 'home' )


class HomePreferences:
	"A class to handle the home preferences."
	def __init__( self ):
		"Set the default preferences, execute title & preferences fileName."
		#Set the default preferences.
		self.archive = []
		self.activateHome = preferences.BooleanPreference().getFromValue( 'Activate Home', True )
		self.archive.append( self.activateHome )
		self.fileNameInput = preferences.Filename().getFromFilename( interpret.getGNUTranslatorGcodeFileTypeTuples(), 'Open File to be Homed', '' )
		self.archive.append( self.fileNameInput )
		self.nameOfHomingFile = preferences.StringPreference().getFromValue( 'Name of Homing File:', 'homing.txt' )
		self.archive.append( self.nameOfHomingFile )
		#Create the archive, title of the execute button, title of the dialog & preferences fileName.
		self.executeTitle = 'Home'
		self.saveTitle = 'Save Preferences'
		preferences.setHelpPreferencesFileNameTitleWindowPosition( self, 'skeinforge_tools.craft_plugins.home.html' )

	def execute( self ):
		"Home button has been clicked."
		fileNames = polyfile.getFileOrDirectoryTypesUnmodifiedGcode( self.fileNameInput.value, interpret.getImportPluginFilenames(), self.fileNameInput.wasCancelled )
		for fileName in fileNames:
			writeOutput( fileName )


class HomeSkein:
	"A class to home a skein of extrusions."
	def __init__( self ):
		self.distanceFeedRate = gcodec.DistanceFeedRate()
		self.extruderActive = False
		self.highestZ = None
		self.homingText = ''
		self.lineIndex = 0
		self.lines = None
		self.oldLocation = None
		self.shouldHome = False
		self.travelFeedratePerMinute = 957.0

	def addFloat( self, begin, end ):
		"Add dive to the original height."
		beginEndDistance = begin.distance( end )
		alongWay = self.absolutePerimeterWidth / beginEndDistance
		closeToEnd = euclidean.getIntermediateLocation( alongWay, end, begin )
		closeToEnd.z = self.highestZ
		self.distanceFeedRate.addLine( self.distanceFeedRate.getLinearGcodeMovementWithFeedrate( self.travelFeedratePerMinute, closeToEnd.dropAxis( 2 ), closeToEnd.z ) )

	def addHopUp( self, location ):
		"Add hop to highest point."
		locationUp = Vector3( location.x, location.y, self.highestZ )
		self.distanceFeedRate.addLine( self.distanceFeedRate.getLinearGcodeMovementWithFeedrate( self.travelFeedratePerMinute, locationUp.dropAxis( 2 ), locationUp.z ) )

	def addHomeTravel( self, splitLine ):
		"Add the home travel gcode."
		location = gcodec.getLocationFromSplitLine( self.oldLocation, splitLine )
		self.highestZ = max( self.highestZ, location.z )
		if not self.shouldHome:
			return
		self.shouldHome = False
		if self.oldLocation == None:
			return
		if self.extruderActive:
			self.distanceFeedRate.addLine( 'M103' )
		self.addHopUp( self.oldLocation )
		self.distanceFeedRate.addLines( self.homingLines )
		self.addHopUp( self.oldLocation )
		self.addFloat( self.oldLocation, location )
		if self.extruderActive:
			self.distanceFeedRate.addLine( 'M101' )

	def getCraftedGcode( self, gcodeText, homePreferences ):
		"Parse gcode text and store the home gcode."
		self.lines = gcodec.getTextLines( gcodeText )
		self.homePreferences = homePreferences
		self.parseInitialization( homePreferences )
		self.homingText = preferences.getFileInGivenPreferencesDirectory( os.path.dirname( __file__ ), homePreferences.nameOfHomingFile.value )
		self.homingLines = gcodec.getTextLines( self.homingText )
		for self.lineIndex in xrange( self.lineIndex, len( self.lines ) ):
			line = self.lines[ self.lineIndex ]
			self.parseLine( line )
		return self.distanceFeedRate.output.getvalue()

	def parseInitialization( self, homePreferences ):
		"Parse gcode initialization and store the parameters."
		for self.lineIndex in xrange( len( self.lines ) ):
			line = self.lines[ self.lineIndex ]
			splitLine = line.split()
			firstWord = gcodec.getFirstWord( splitLine )
			self.distanceFeedRate.parseSplitLine( firstWord, splitLine )
			if firstWord == '(</extruderInitialization>)':
				self.distanceFeedRate.addLine( '(<procedureDone> home </procedureDone>)' )
				return
			elif firstWord == '(<perimeterWidth>':
				self.absolutePerimeterWidth = abs( float( splitLine[ 1 ] ) )
			elif firstWord == '(<travelFeedratePerSecond>':
				self.travelFeedratePerMinute = 60.0 * float( splitLine[ 1 ] )
			self.distanceFeedRate.addLine( line )

	def parseLine( self, line ):
		"Parse a gcode line and add it to the bevel gcode."
		splitLine = line.split()
		if len( splitLine ) < 1:
			return
		firstWord = splitLine[ 0 ]
		if firstWord == 'G1':
			self.addHomeTravel( splitLine )
			self.oldLocation = gcodec.getLocationFromSplitLine( self.oldLocation, splitLine )
		elif firstWord == '(<layer>':
			if self.homingText != '':
				self.shouldHome = True
		elif firstWord == 'M101':
			self.extruderActive = True
		elif firstWord == 'M103':
			self.extruderActive = False
		self.distanceFeedRate.addLine( line )


def main():
	"Display the home dialog."
	if len( sys.argv ) > 1:
		writeOutput( ' '.join( sys.argv[ 1 : ] ) )
	else:
		getDisplayedPreferences().root.mainloop()

if __name__ == "__main__":
	main()
