"""
Tower is a script to extrude a few layers up, then go across to other regions.

This script commands the fabricator to extrude a disconnected region for a few layers, then go to another disconnected region
and extrude there.  Its purpose is to reduce the number of stringers between a shape and reduce extruder travel.  The important
value for the tower preferences is "Maximum Tower Height (layers)" which is the maximum number of layers that the extruder
will extrude in one region before going to another.  When the value is zero tower will do nothing.  Because tower could result in
the extruder collidiing with an already extruded part of the shape and because extruding in one region for more than one layer
could result in the shape melting, the default is the safe value of zero.

Tower works by looking for islands in each layer and if it finds another island in the layer above, it goes to the next layer above
instead of going across to other regions on the original layer.  It checks for collision with shapes already extruded within a cone
from the nozzle tip.  The "Extruder Possible Collision Cone Angle (degrees)" preference is the angle of that cone.  Realistic
values for the cone angle range between zero and ninety.  The higher the angle, the less likely a collision with the rest of the
shape is, generally the extruder will stay in the region for only a few layers before a collision is detected with the wide cone.
The default angle is sixty degrees.

The "Tower Start Layer" is the layer which the script starts extruding towers.  It is best to not tower at least the first layer
because the temperature of the first layer should sometimes be different than that of the other layers.  The default preference is
three.  To run tower, in a shell type:
> python tower.py

To run tower, install python 2.x on your machine, which is avaliable from http://www.python.org/download/

To use the preferences dialog you'll also need Tkinter, which probably came with the python installation.  If it did not, look for it at:
www.tcl.tk/software/tcltk/

To export a GNU Triangulated Surface file from Art of Illusion, you can use the Export GNU Triangulated Surface script at:
http://members.axion.net/~enrique/Export%20GNU%20Triangulated%20Surface.bsh

To bring it into Art of Illusion, drop it into the folder ArtOfIllusion/Scripts/Tools/.

The GNU Triangulated Surface format is supported by Mesh Viewer, and it is described at:
http://gts.sourceforge.net/reference/gts-surfaces.html#GTS-SURFACE-WRITE

To turn an STL file into filled, towered gcode, first import the file using the STL import plugin in the import submenu of the file menu
of Art of Illusion.  Then from the Scripts submenu in the Tools menu, choose Export GNU Triangulated Surface and select the
imported STL shape.  Then type 'python slice.py' in a shell in the folder which slice & tower are in and when the dialog pops up, set
the parameters and click 'Save Preferences'.  Then type 'python fill.py' in a shell in the folder which fill is in and when the dialog
pops up, set the parameters and click 'Save Preferences'.  Then click 'Tower', choose the file which you exported in
Export GNU Triangulated Surface and the filled & towered file will be saved with the suffix '_tower'.

To write documentation for this program, open a shell in the tower.py directory, then type 'pydoc -w tower', then open 'tower.html' in
a browser or click on the '?' button in the dialog.  To write documentation for all the python scripts in the directory, type 'pydoc -w ./'.
To use other functions of tower, type 'python' in a shell to run the python interpreter, then type 'import tower' to import this program.

The computation intensive python modules will use psyco if it is available and run about twice as fast.  Psyco is described at:
http://psyco.sourceforge.net/index.html

The psyco download page is:
http://psyco.sourceforge.net/download.html

The following examples tower the files Hollow Square.gcode & Hollow Square.gts.  The examples are run in a terminal in the folder
which contains Hollow Square.gcode, Hollow Square.gts and tower.py.  The tower function will tower if 'Maximum Tower Layers' is
greater than zero, which can be set in the dialog or by changing the preferences file 'tower.csv' with a text editor or a spreadsheet
program set to separate tabs.  The functions towerChainFile and getTowerChainGcode check to see if the text has been towered,
if not they call the getFillChainGcode in fill.py to fill the text; once they have the filled text, then they tower.


> pydoc -w tower
wrote tower.html


> python tower.py
This brings up the dialog, after clicking 'Tower', the following is printed:
File Hollow Square.gts is being chain towered.
The towered file is saved as Hollow Square_tower.gcode


>python
Python 2.5.1 (r251:54863, Sep 22 2007, 01:43:31)
[GCC 4.2.1 (SUSE Linux)] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> import tower
>>> tower.main()
This brings up the tower dialog.


>>> tower.towerChainFile()
Hollow Square.gts
File Hollow Square.gts is being chain towered.
The towered file is saved as Hollow Square_tower.gcode


>>> tower.towerFile()
File Hollow Square.gcode is being towered.
The towered file is saved as Hollow Square_tower.gcode


>>> tower.getTowerGcode("
( GCode generated by May 8, 2008 slice.py )
( Extruder Initialization )
..
many lines of gcode
..
")


>>> tower.getTowerChainGcode("
( GCode generated by May 8, 2008 slice.py )
( Extruder Initialization )
..
many lines of gcode
..
")

"""

from vec3 import Vec3
import cStringIO
import euclidean
import fill
import gcodec
import intercircle
import math
import multifile
import preferences
import sys
import time
import vectorwrite


__author__ = "Enrique Perez (perez_enrique@yahoo.com)"
__date__ = "$Date: 2008/21/04 $"
__license__ = "GPL 3.0"

def getTowerChainGcode( gcodeText, towerPreferences = None ):
	"Tower a gcode linear move text.  Chain tower the gcode if it is not already towered."
	if not gcodec.isProcedureDone( gcodeText, 'fill' ):
		gcodeText = fill.getFillChainGcode( gcodeText )
	return getTowerGcode( gcodeText, towerPreferences )

def getTowerGcode( gcodeText, towerPreferences = None ):
	"Tower a gcode linear move text."
	if gcodeText == '':
		return ''
	if gcodec.isProcedureDone( gcodeText, 'tower' ):
		return gcodeText
	if towerPreferences == None:
		towerPreferences = TowerPreferences()
		preferences.readPreferences( towerPreferences )
	if towerPreferences.maximumTowerHeight.value < 1:
		return gcodeText
	skein = TowerSkein()
	skein.parseGcode( gcodeText, towerPreferences )
	return skein.output.getvalue()

def towerChainFile( filename = '' ):
	"""Tower a gcode linear move file.  Chain tower the gcode if it is not already towered.
	If no filename is specified, tower the first unmodified gcode file in this folder."""
	if filename == '':
		unmodified = gcodec.getGNUGcode()
		if len( unmodified ) == 0:
			print( "There are no unmodified gcode files in this folder." )
			return
		filename = unmodified[ 0 ]
	towerPreferences = TowerPreferences()
	preferences.readPreferences( towerPreferences )
	startTime = time.time()
	print( 'File ' + gcodec.getSummarizedFilename( filename ) + ' is being chain towered.' )
	gcodeText = gcodec.getFileText( filename )
	if gcodeText == '':
		return
	suffixFilename = filename[ : filename.rfind( '.' ) ] + '_tower.gcode'
	gcodec.writeFileText( suffixFilename, getTowerChainGcode( gcodeText, towerPreferences ) )
	print( 'The towered file is saved as ' + gcodec.getSummarizedFilename( suffixFilename ) )
	vectorwrite.writeSkeinforgeVectorFile( suffixFilename )
	print( 'It took ' + str( int( round( time.time() - startTime ) ) ) + ' seconds to tower the file.' )

def towerFile( filename = '' ):
	"""Tower a gcode linear move file.  If the maximum tower height preference is less than one, do nothing.
	If no filename is specified, tower the first unmodified gcode file in this folder."""
	if filename == '':
		unmodified = gcodec.getUnmodifiedGCodeFiles()
		if len( unmodified ) == 0:
			print( "There are no unmodified gcode files in this folder." )
			return
		filename = unmodified[ 0 ]
	towerPreferences = TowerPreferences()
	preferences.readPreferences( towerPreferences )
	if towerPreferences.maximumTowerHeight.value < 1:
		print( 'The maximum tower height preference is less than one, so nothing will be done.' )
		return
	print( 'File ' + gcodec.getSummarizedFilename( filename ) + ' is being towered.' )
	gcodeText = gcodec.getFileText( filename )
	if gcodeText == '':
		return
	suffixFilename = filename[ : filename.rfind( '.' ) ] + '_tower.gcode'
	gcodec.writeFileText( suffixFilename, getTowerGcode( gcodeText, towerPreferences ) )
	print( 'The towered file is saved as ' + suffixFilename )
	vectorwrite.writeSkeinforgeVectorFile( suffixFilename )

def transferFillLoops( fillLoops, surroundingLoop ):
	"Transfer fill loops."
	for innerSurrounding in surroundingLoop.innerSurroundings:
		transferFillLoopsToSurroundingLoops( fillLoops, innerSurrounding.innerSurroundings )
	surroundingLoop.extraLoops = euclidean.getTransferredPaths( fillLoops, surroundingLoop.boundary )

def transferFillLoopsToSurroundingLoops( fillLoops, surroundingLoops ):
	"Transfer fill loops to surrounding loops."
	for surroundingLoop in surroundingLoops:
		transferFillLoops( fillLoops, surroundingLoop )

class TowerSkein:
	"A class to tower a skein of extrusions."
	def __init__( self ):
		self.beforeExtrusionLines = None
		self.extruderActive = False
		self.extrusionWidth = 0.4
		self.feedrateMinute = 960.0
		self.feedrateTable = {}
		self.islandLayers = []
		self.isLoop = False
		self.isPerimeter = False
		self.layerIndex = 0
		self.lineIndex = 0
		self.lines = None
		self.oldLayerIndex = None
		self.oldLocation = None
		self.oldOrderedLocation = Vec3()
		self.oldZ = - 999999999.0
		self.output = cStringIO.StringIO()
		self.shutdownLineIndex = sys.maxint
		self.surroundingLoop = None
		self.thread = None
		self.threadLayer = None
		self.threadLayers = []

	def addEntireLayer( self, layerIndex ):
		"Add entire thread layer."
		surroundingLoops = self.islandLayers[ layerIndex ]
		for line in self.threadLayers[ layerIndex ].beforeExtrusionLines:
			self.addLine( line )
		euclidean.addToThreadsRemoveFromSurroundings( self.oldOrderedLocation, surroundingLoops, self )

	def addGcodeFromThread( self, thread ):
		"Add a gcode thread to the output."
		if len( thread ) > 0:
			firstPoint = thread[ 0 ]
			if firstPoint.z < self.oldZ:
				self.addGcodeMovement( Vec3( firstPoint.x, firstPoint.y, self.oldZ ) )
			self.addGcodeMovement( firstPoint )
			self.oldZ = firstPoint.z
		else:
			print( "zero length vertex positions array which was skipped over, this should never happen" )
		if len( thread ) < 2:
			return
		self.addLine( 'M101' )
		for point in thread[ 1 : ]:
			self.addGcodeMovement( point )
		self.addLine( "M103" ) # Turn extruder off.

	def addGcodeMovement( self, point ):
		"Add a movement to the output."
		self.lastOutputPoint = point
		if point in self.feedrateTable:
			self.feedrateMinute = self.feedrateTable[ point ]
		self.output.write( "G1 X" + euclidean.getRoundedToThreePlaces( point.x ) + " Y" + euclidean.getRoundedToThreePlaces( point.y ) )
		self.addLine( " Z" + euclidean.getRoundedToThreePlaces( point.z ) + " F" + euclidean.getRoundedToThreePlaces( self.feedrateMinute ) )

	def addIfTravel( self, splitLine ):
		"Add travel move around loops if this the extruder is off."
		location = gcodec.getLocationFromSplitLine( self.oldLocation, splitLine )
		self.oldLocation = location

	def addIslandLayer( self, threadLayer ):
		"Add a layer of surrounding islands."
		surroundingLoops = euclidean.getOrderedSurroundingLoops( self.extrusionWidth, threadLayer.surroundingLoops )
		for surroundingLoop in surroundingLoops:
			surroundingLoop.boundingLoop = intercircle.BoundingLoop().getFromLoop( surroundingLoop.boundary )
		euclidean.transferPathsToSurroundingLoops( threadLayer.paths[ : ], surroundingLoops )
		transferFillLoopsToSurroundingLoops( threadLayer.loops[ : ], surroundingLoops )
		self.islandLayers.append( surroundingLoops )

	def addLayerLinesIfDifferent( self, layerIndex ):
		"Add gcode lines for the layer if it is different than the old bottom layer index."
		if layerIndex != self.oldLayerIndex:
			self.oldLayerIndex = layerIndex
			for line in self.threadLayers[ layerIndex ].beforeExtrusionLines:
				self.addLine( line )

	def addLine( self, line ):
		"Add a line of text and a newline to the output."
		self.output.write( line + "\n" )

	def addShutdownToOutput( self ):
		"Add shutdown gcode to the output."
		for line in self.lines[ self.shutdownLineIndex : ]:
			self.addLine( line )

	def addToExtrusion( self, location ):
		"Add a location to the thread."
		if self.oldLocation == None:
			return
		if self.surroundingLoop != None:
			if self.isPerimeter:
				if self.surroundingLoop.loop == None:
					self.surroundingLoop.loop = []
				self.surroundingLoop.loop.append( location )
				return
			elif self.thread == None:
				self.thread = [ self.oldLocation ]
				self.surroundingLoop.perimeterPaths.append( self.thread )
		if self.thread == None:
			self.thread = []
			if self.isLoop: #do not add to loops because a closed loop does not have to restate its beginning
				self.threadLayer.loops.append( self.thread )
			else:
				self.thread.append( self.oldLocation )
				self.threadLayer.paths.append( self.thread )
		self.thread.append( location )

	def addTowers( self ):
		"Add towers."
		bottomLayerIndex = self.getBottomLayerIndex()
		if bottomLayerIndex == None:
			return
		self.addLayerLinesIfDifferent( bottomLayerIndex )
		removedIsland = euclidean.getTransferClosestSurroundingLoop( self.oldOrderedLocation, self.islandLayers[ bottomLayerIndex ], self )
		while 1:
			self.climbTower( removedIsland )
			bottomLayerIndex = self.getBottomLayerIndex()
			if bottomLayerIndex == None:
				return
			self.addLayerLinesIfDifferent( bottomLayerIndex )
			removedIsland = euclidean.getTransferClosestSurroundingLoop( self.oldOrderedLocation, self.islandLayers[ bottomLayerIndex ], self )

	def climbTower( self, removedIsland ):
		"Climb up the island to any islands directly above."
		outsetDistance = 1.5 * self.extrusionWidth
		for step in range( self.towerPreferences.maximumTowerHeight.value ):
			aboveIndex = self.oldLayerIndex + 1
			if aboveIndex >= len( self.islandLayers ):
				return
			outsetRemovedLoop = removedIsland.boundingLoop.getOutsetBoundingLoop( outsetDistance )
			islandsWithin = []
			for island in self.islandLayers[ aboveIndex ]:
				if self.isInsideRemovedOutsideCone( island, outsetRemovedLoop, aboveIndex ):
					islandsWithin.append( island )
			if len( islandsWithin ) < 1:
				return
			self.addLayerLinesIfDifferent( aboveIndex )
			removedIsland = euclidean.getTransferClosestSurroundingLoop( self.oldOrderedLocation, islandsWithin, self )
			self.islandLayers[ aboveIndex ].remove( removedIsland )

	def getBottomLayerIndex( self ):
		"Get the index of the first island layer which has islands."
		for islandLayerIndex in range( len( self.islandLayers ) ):
			if len( self.islandLayers[ islandLayerIndex ] ) > 0:
				return islandLayerIndex
		return None

	def isInsideRemovedOutsideCone( self, island, removedBoundingLoop, untilLayerIndex ):
		"Determine if the island is entirely inside the removed bounding loop and outside the collision cone of the remaining islands."
		if not island.boundingLoop.isEntirelyInsideAnother( removedBoundingLoop ):
			return False
		bottomLayerIndex = self.getBottomLayerIndex()
		coneAngleTangent = math.tan( math.radians( self.towerPreferences.extruderPossibleCollisionConeAngle.value ) )
		for layerIndex in range( bottomLayerIndex, untilLayerIndex ):
			islands = self.islandLayers[ layerIndex ]
			outsetDistance = self.extrusionWidth * ( untilLayerIndex - layerIndex ) * coneAngleTangent + 0.5 * self.extrusionWidth
			for belowIsland in self.islandLayers[ layerIndex ]:
				outsetIslandLoop = belowIsland.boundingLoop.getOutsetBoundingLoop( outsetDistance )
				if island.boundingLoop.isOverlappingAnother( outsetIslandLoop ):
					return False
		return True

	def linearMove( self, splitLine ):
		"Add a linear move to the loop."
		location = gcodec.getLocationFromSplitLine( self.oldLocation, splitLine )
		self.feedrateMinute  = gcodec.getFeedrateMinute( self.feedrateMinute, splitLine )
		self.feedrateTable[ location ] = self.feedrateMinute
		if self.extruderActive:
			self.addToExtrusion( location )
		self.oldLocation = location

	def parseGcode( self, gcodeText, towerPreferences ):
		"Parse gcode text and store the tower gcode."
		self.lines = gcodec.getTextLines( gcodeText )
		self.towerPreferences = towerPreferences
		self.parseInitialization()
		self.oldLocation = None
		for lineIndex in range( self.lineIndex, len( self.lines ) ):
			self.parseLine( lineIndex )
		for threadLayer in self.threadLayers:
			self.addIslandLayer( threadLayer )
		for self.layerIndex in range( min( len( self.islandLayers ), towerPreferences.towerStartLayer.value ) ):
			self.addEntireLayer( self.layerIndex )
		self.addTowers()
		self.addShutdownToOutput()

	def parseInitialization( self ):
		"Parse gcode initialization and store the parameters."
		for self.lineIndex in range( len( self.lines ) ):
			line = self.lines[ self.lineIndex ]
			splitLine = line.split( ' ' )
			firstWord = ''
			if len( splitLine ) > 0:
				firstWord = splitLine[ 0 ]
			if firstWord == '(<extrusionStart>':
				self.addLine( '(<procedureDone> tower )' )
				self.addLine( line )
				return
			self.addLine( line )

	def parseLine( self, lineIndex ):
		"Parse a gcode line."
		line = self.lines[ lineIndex ]
		splitLine = line.split( ' ' )
		if len( splitLine ) < 1:
			return 0
		firstWord = splitLine[ 0 ]
		if firstWord == 'G1':
			self.linearMove( splitLine )
		if firstWord == 'M101':
			self.extruderActive = True
		elif firstWord == 'M103':
			self.extruderActive = False
			self.thread = None
			self.isLoop = False
			self.isPerimeter = False
		elif firstWord == '(<boundaryPoint>':
			location = gcodec.getLocationFromSplitLine( None, splitLine )
			self.surroundingLoop.boundary.append( location )
		elif firstWord == '(<extruderShutDown>':
			self.shutdownLineIndex = lineIndex
		elif firstWord == '(<extrusionWidth>':
			self.extrusionWidth = gcodec.getDoubleAfterFirstLetter( splitLine[ 1 ] )
		elif firstWord == '(<layerStart>':
			self.beforeExtrusionLines = []
			self.threadLayer = None
			self.thread = None
		elif firstWord == '(<loop>':
			self.isLoop = True
		elif firstWord == '(<perimeter>':
			self.isPerimeter = True
		elif firstWord == '(<surroundingLoop>':
			self.surroundingLoop = euclidean.SurroundingLoop()
			if self.threadLayer == None:
				self.threadLayer = ThreadLayer()
				if self.beforeExtrusionLines != None:
					self.threadLayer.beforeExtrusionLines = self.beforeExtrusionLines
					self.beforeExtrusionLines = None
				self.threadLayers.append( self.threadLayer )
			self.threadLayer.surroundingLoops.append( self.surroundingLoop )
			self.threadLayer.boundaries.append( self.surroundingLoop.boundary )
		elif firstWord == '(</surroundingLoop>':
			self.surroundingLoop = None
		if self.beforeExtrusionLines != None:
			self.beforeExtrusionLines.append( line )


class ThreadLayer:
	"A layer of loops and paths."
	def __init__( self ):
		"Thread layer constructor."
		self.boundaries = []
		self.loops = []
		self.paths = []
		self.surroundingLoops = []

	def __repr__( self ):
		"Get the string representation of this thread layer."
		return '%s, %s, %s' % ( self.rotation, self.surroundingLoops, self.boundaries )


class TowerPreferences:
	"A class to handle the tower preferences."
	def __init__( self ):
		"Set the default preferences, execute title & preferences filename."
		#Set the default preferences.
		self.extruderPossibleCollisionConeAngle = preferences.FloatPreference().getFromValue( 'Extruder Possible Collision Cone Angle (degrees):', 60.0 )
		self.maximumTowerHeight = preferences.IntPreference().getFromValue( 'Maximum Tower Height (layers):', 0 )
		self.towerStartLayer = preferences.IntPreference().getFromValue( 'Tower Start Layer (integer):', 3 )
		self.filenameInput = preferences.Filename().getFromFilename( [ ( 'GNU Triangulated Surface text files', '*.gts' ), ( 'Gcode text files', '*.gcode' ) ], 'Open File to be Towered', '' )
		#Create the archive, title of the execute button, title of the dialog & preferences filename.
		self.archive = [ self.extruderPossibleCollisionConeAngle, self.maximumTowerHeight, self.towerStartLayer, self.filenameInput ]
		self.executeTitle = 'Tower'
		self.filenamePreferences = preferences.getPreferencesFilePath( 'tower.csv' )
		self.filenameHelp = 'tower.html'
		self.title = 'Tower Preferences'

	def execute( self ):
		"Tower button has been clicked."
		filenames = multifile.getFileOrGNUUnmodifiedGcodeDirectory( self.filenameInput.value, self.filenameInput.wasCancelled )
		for filename in filenames:
			towerChainFile( filename )


def main( hashtable = None ):
	"Display the tower dialog."
	preferences.displayDialog( TowerPreferences() )

if __name__ == "__main__":
	main()
