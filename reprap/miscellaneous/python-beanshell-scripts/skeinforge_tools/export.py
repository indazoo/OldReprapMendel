"""
Export is a script to pick an export plugin and optionally print the output to a file.

The default 'Activate Export' checkbox is on.  When it is on, the functions described below will work, when it is off, the functions
will not be called.

Export presents the user with a choice of the export plugins in the export_plugins folder.  The chosen plugin will then modify the
gcode or translate it into another format.  There is also the "Do Not Change Output" choice, which will not change the output.

To print the output to a file, add the file output name to the "Also Send Output To" field.  A common choice is sys.stdout to print
the output in the shell screen.  Another common choice is sys.stderr.  The default is nothing, in which case the output will not be
printed to a file.

If the "Delete M110 Gcode Line" checkbox is true, export will delete the M110 gcode line, whose only purpose is to indicate that
the gcode is generated by skeinforge.  The M110 gcode is not necessary to run a fabricator.

An export plugin is a script in the export_plugins folder which has the functions getOuput and writeOutput.

To run export, in a shell type:
> python export.py

The following examples export the files Hollow Square.gts.  The examples are run in a terminal in the folder which contains
Hollow Square.gts & export.py.  The function writeOutput checks to see if the text has been exported, if not they call
getFilletChainGcode in fillet.py to fillet the text; once they have the filleted text, then it exports.


> python export.py
This brings up the dialog, after clicking 'Export', the following is printed:
File Hollow Square.gts is being chain exported.
The exported file is saved as Hollow Square_export.gcode


>python
Python 2.5.1 (r251:54863, Sep 22 2007, 01:43:31)
[GCC 4.2.1 (SUSE Linux)] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> import export
>>> export.main()
This brings up the export dialog.


>>> export.writeOutput()
Hollow Square.gts
File Hollow Square.gts is being chain exported.
The exported file is saved as Hollow Square_export.gcode

"""

#Init has to be imported first because it has code to workaround the python bug where relative imports don't work if the module is imported as a main module.
import __init__

from skeinforge_tools.skeinforge_utilities import euclidean
from skeinforge_tools.skeinforge_utilities import gcodec
from skeinforge_tools.skeinforge_utilities import intercircle
from skeinforge_tools.skeinforge_utilities import preferences
from skeinforge_tools.skeinforge_utilities.vec3 import vec3
import analyze
import cStringIO
import fillet
import polyfile
import os
import sys
import time


__author__ = "Enrique Perez (perez_enrique@yahoo.com)"
__date__ = "$Date: 2008/21/04 $"
__license__ = "GPL 3.0"


def getExportGcode( gcodeText, exportPreferences = None ):
	"Export a gcode linear move text."
	if gcodeText == '':
		return ''
	if gcodec.isProcedureDone( gcodeText, 'export' ):
		return gcodeText
	if exportPreferences == None:
		exportPreferences = ExportPreferences()
		preferences.readPreferences( exportPreferences )
	if not exportPreferences.activateExport.value:
		return gcodeText
	skein = ExportSkein()
	skein.parseGcode( exportPreferences, gcodeText )
	return skein.output.getvalue()

def getSelectedPlugin( exportPreferences ):
	"Get the selected plugin."
	for plugin in exportPreferences.exportPlugins:
		if plugin.value:
			return plugin
	return None

def writeOutput( filename = '' ):
	"""Export a gcode linear move file.  Chain export the gcode if it is not already exported.
	If no filename is specified, export the first unmodified gcode file in this folder."""
	if filename == '':
		unmodified = gcodec.getGNUGcode()
		if len( unmodified ) == 0:
			print( "There are no unmodified gcode files in this folder." )
			return
		filename = unmodified[ 0 ]
	exportPreferences = ExportPreferences()
	preferences.readPreferences( exportPreferences )
	startTime = time.time()
	print( 'File ' + gcodec.getSummarizedFilename( filename ) + ' is being chain exported.' )
	gcodeText = gcodec.getFileText( filename )
	if gcodeText == '':
		return
	suffixFilename = filename[ : filename.rfind( '.' ) ] + '_export.gcode'
	if not gcodec.isProcedureDone( gcodeText, 'fillet' ):
		gcodeText = fillet.getFilletChainGcode( gcodeText )
	analyze.writeOutput( suffixFilename, gcodeText )
	exportChainGcode = getExportGcode( gcodeText, exportPreferences )
	pluginModule = None
	selectedPlugin = getSelectedPlugin( exportPreferences )
	if selectedPlugin != None:
		pluginModule = gcodec.getModule( selectedPlugin.name, 'export_plugins', __file__ )
		exportChainGcode = pluginModule.getOutput( exportChainGcode )
	if exportPreferences.alsoSendOutputTo.value != '':
		exec( 'print >> ' + exportPreferences.alsoSendOutputTo.value + ', exportChainGcode' )
	if selectedPlugin == None:
		gcodec.writeFileText( suffixFilename, exportChainGcode )
		print( 'The exported file is saved as ' + gcodec.getSummarizedFilename( suffixFilename ) )
	else:
		pluginModule.writeOutput( suffixFilename, exportChainGcode )
	print( 'It took ' + str( int( round( time.time() - startTime ) ) ) + ' seconds to export the file.' )


class ExportSkein:
	"A class to export a skein of extrusions."
	def __init__( self ):
		self.decimalPlacesExported = 2
		self.output = cStringIO.StringIO()

	def addLine( self, line ):
		"Add a line of text and a newline to the output."
		self.output.write( line + '\n' )

	def getLineWithTruncatedNumber( self, character, line ):
		'Get a line with the number after the character truncated.'
		indexOfCharacter = line.find( character )
		if indexOfCharacter < 0:
			return line
		indexOfNumberEnd = line.find( ' ', indexOfCharacter )
		if indexOfNumberEnd < 0:
			indexOfNumberEnd = len( line )
		indexOfNumberStart = indexOfCharacter + 1
		numberString = line[ indexOfNumberStart : indexOfNumberEnd ]
		if numberString == '':
			return line
		roundedNumberString = euclidean.getRoundedToDecimalPlaces( self.decimalPlacesExported, float( numberString ) )
		return line[ : indexOfNumberStart ] + roundedNumberString + line[ indexOfNumberEnd : ]

	def parseGcode( self, exportPreferences, gcodeText ):
		"Parse gcode text and store the export gcode."
		lines = gcodec.getTextLines( gcodeText )
		for line in lines:
			self.parseLine( line, exportPreferences.deleteM110GcodeLine.value )

	def parseLine( self, line, removeM110GcodeLine ):
		"Parse a gcode line."
		splitLine = line.split( ' ' )
		if len( splitLine ) < 1:
			return
		firstWord = splitLine[ 0 ]
		if firstWord == 'M110' and removeM110GcodeLine:
			return
		if firstWord == '(<decimalPlacesCarried>':
			self.decimalPlacesExported = max( 1, int( splitLine[ 1 ] ) - 1 )
		elif firstWord == '(<extrusionStart>':
			self.addLine( '(<procedureDone> export )' )
		if firstWord != 'G1' and firstWord != 'G2' and firstWord != 'G3' :
			self.addLine( line )
			return
		line = self.getLineWithTruncatedNumber( 'X', line )
		line = self.getLineWithTruncatedNumber( 'Y', line )
		line = self.getLineWithTruncatedNumber( 'Z', line )
		line = self.getLineWithTruncatedNumber( 'I', line )
		line = self.getLineWithTruncatedNumber( 'J', line )
		line = self.getLineWithTruncatedNumber( 'R', line )
		self.addLine( line )


class ExportPreferences:
	"A class to handle the export preferences."
	def __init__( self ):
		"Set the default preferences, execute title & preferences filename."
		#Set the default preferences.
		self.archive = []
		self.activateExport = preferences.BooleanPreference().getFromValue( 'Activate Export', True )
		self.archive.append( self.activateExport )
		self.alsoSendOutputTo = preferences.StringPreference().getFromValue( 'Also Send Output To:', '' )
		self.archive.append( self.alsoSendOutputTo )
		self.deleteM110GcodeLine = preferences.BooleanPreference().getFromValue( 'Delete M110 Gcode Line', True )
		self.archive.append( self.deleteM110GcodeLine )
		exportPluginFilenames = gcodec.getPluginFilenames( 'export_plugins', __file__ )
		self.exportLabel = preferences.LabelDisplay().getFromName( 'Export Operations: ' )
		self.archive.append( self.exportLabel )
		self.exportOperations = []
		self.exportPlugins = []
		exportRadio = []
		self.doNotChangeOutput = preferences.RadioCapitalized().getFromRadio( 'Do Not Change Output', exportRadio, True )
		for exportPluginFilename in exportPluginFilenames:
			exportPlugin = preferences.RadioCapitalized().getFromRadio( exportPluginFilename, exportRadio, False )
			if exportPluginFilename == 'gcode_only':
				self.doNotChangeOutput.value = False
				exportPlugin.value = True
			self.exportPlugins.append( exportPlugin )
		self.exportOperations = [ self.doNotChangeOutput ]
		self.exportOperations += self.exportPlugins
		self.exportOperations.sort( key = preferences.RadioCapitalized.getLowerName )
#		self.exportOperations.sort( compareRadio ) first.name.lower()
		self.archive += self.exportOperations
		self.filenameInput = preferences.Filename().getFromFilename( [ ( 'GNU Triangulated Surface text files', '*.gts' ), ( 'Gcode text files', '*.gcode' ) ], 'Open File to be Exported', '' )
		self.archive.append( self.filenameInput )
		#Create the archive, title of the execute button, title of the dialog & preferences filename.
		self.executeTitle = 'Export'
		self.filenamePreferences = preferences.getPreferencesFilePath( 'export.csv' )
		self.filenameHelp = 'skeinforge_tools.export.html'
		self.saveTitle = 'Save Preferences'
		self.title = 'Export Preferences'

	def execute( self ):
		"Export button has been clicked."
		filenames = polyfile.getFileOrGNUUnmodifiedGcodeDirectory( self.filenameInput.value, self.filenameInput.wasCancelled )
		for filename in filenames:
			writeOutput( filename )


def main( hashtable = None ):
        if len(sys.argv) > 1:
                writeOutput(sys.argv[1])
        else:
                preferences.displayDialog( ExportPreferences() )

if __name__ == "__main__":
	main()
