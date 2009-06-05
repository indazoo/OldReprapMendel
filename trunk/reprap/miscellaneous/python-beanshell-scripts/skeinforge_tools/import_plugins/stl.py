"""
The stl.py script is an import translator plugin to get a carving from an stl file.

An import plugin is a script in the import_plugins folder which has the function getCarving.  It is meant to be run from the
interpret tool.  To ensure that the plugin works on platforms which do not handle file capitalization properly, give the plugin
a lower case name.

The getCarving function takes the file name of an stl file and returns the carving.

STL is an inferior triangle surface format, described at:
http://en.wikipedia.org/wiki/STL_(file_format)

A good triangle surface format is the GNU Triangulated Surface format which is described at:
http://gts.sourceforge.net/reference/gts-surfaces.html#GTS-SURFACE-WRITE

This example gets a carving for the stl file Screw Holder Bottom.stl.  This example is run in a terminal in the folder which
contains Screw Holder Bottom.stl and stl.py.


> python
Python 2.5.1 (r251:54863, Sep 22 2007, 01:43:31)
[GCC 4.2.1 (SUSE Linux)] on linux2
Type "help", "copyright", "credits" or "license" for more information.
>>> import stl
>>> stl.getCarving()
[11.6000003815, 10.6837882996, 7.80209827423
..
many more lines of the carving
..

"""


from __future__ import absolute_import
#Init has to be imported first because it has code to workaround the python bug where relative imports don't work if the module is imported as a main module.
import __init__

from skeinforge_tools.skeinforge_utilities.vector3 import Vector3
from skeinforge_tools.skeinforge_utilities import gcodec
from skeinforge_tools.skeinforge_utilities import triangle_mesh
from struct import unpack

__author__ = "Enrique Perez (perez_enrique@yahoo.com)"
__credits__ = 'Nophead <http://hydraraptor.blogspot.com/>\nArt of Illusion <http://www.artofillusion.org/>'
__date__ = "$Date: 2008/21/04 $"
__license__ = "GPL 3.0"


def addFacesGivenBinary( stlData, triangleMesh, vertexIndexTable ):
	"Add faces given stl binary."
	numberOfVertices = ( len( stlData ) - 84 ) / 50
	vertices = []
	for vertexIndex in xrange( numberOfVertices ):
		byteIndex = 84 + vertexIndex * 50
		vertices.append( getVertexGivenBinary( byteIndex + 12, stlData ) )
		vertices.append( getVertexGivenBinary( byteIndex + 24, stlData ) )
		vertices.append( getVertexGivenBinary( byteIndex + 36, stlData ) )
	addFacesGivenVertices( triangleMesh, vertexIndexTable, vertices )

def addFacesGivenText( stlText, triangleMesh, vertexIndexTable ):
	"Add faces given stl text."
	lines = gcodec.getTextLines( stlText )
	vertices = []
	for line in lines:
		if line.find( 'vertex' ) != - 1:
			vertices.append( getVertexGivenLine( line ) )
	addFacesGivenVertices( triangleMesh, vertexIndexTable, vertices )

def addFacesGivenVertices( triangleMesh, vertexIndexTable, vertices ):
	"Add faces given stl text."
	for vertexIndex in xrange( 0, len( vertices ), 3 ):
		triangleMesh.faces.append( getFaceGivenLines( triangleMesh, vertexIndex, vertexIndexTable, vertices ) )

def getFaceGivenLines( triangleMesh, vertexStartIndex, vertexIndexTable, vertices ):
	"Add face given line index and lines."
	face = triangle_mesh.Face()
	face.index = len( triangleMesh.faces )
	for vertexIndex in xrange( vertexStartIndex, vertexStartIndex + 3 ):
		vertex = vertices[ vertexIndex ]
		vertexUniqueIndex = len( vertexIndexTable )
		if str( vertex ) in vertexIndexTable:
			vertexUniqueIndex = vertexIndexTable[ str( vertex ) ]
		else:
			vertexIndexTable[ str( vertex ) ] = vertexUniqueIndex
			triangleMesh.vertices.append( vertex )
		face.vertexIndexes.append( vertexUniqueIndex )
	return face

def getFloatGivenBinary( byteIndex, stlData ):
	"Get vertex given stl vertex line."
	return unpack( 'f', stlData[ byteIndex : byteIndex + 4 ] )[ 0 ]

def getCarving( fileName = '' ):
	"Get the triangle mesh for the stl file."
	if fileName == '':
		unmodified = gcodec.getFilesWithFileTypeWithoutWords( 'stl' )
		if len( unmodified ) == 0:
			print( "There is no stl file in this folder." )
			return None
		fileName = unmodified[ 0 ]
	stlData = gcodec.getFileText( fileName, 'rb' )
	if stlData == '':
		return None
	triangleMesh = triangle_mesh.TriangleMesh()
	vertexIndexTable = {}
	numberOfVertexStrings = stlData.count( 'vertex' )
	requiredVertexStringsForText = max( 2, len( stlData ) / 8000 )
#	binarySolidworksHeaderErrorString = 'solid binary'
#	binarySolidworksHeaderError = stlData[ : len( binarySolidworksHeaderErrorString ) ] == binarySolidworksHeaderErrorString
#	if binarySolidworksHeaderError:
#		print( 'The solidworks file has the incorrect header:' )
#		print( binarySolidworksHeaderErrorString )
#		print( 'A binary stl should never start with the word "solid".  Because this error is common the file is been parsed as binary regardless.' )
	if numberOfVertexStrings > requiredVertexStringsForText:
		addFacesGivenText( stlData, triangleMesh, vertexIndexTable )
	else:
		addFacesGivenBinary( stlData, triangleMesh, vertexIndexTable )
	triangleMesh.setEdgesForAllFaces()
	return triangleMesh

def getVertexGivenBinary( byteIndex, stlData ):
	"Get vertex given stl vertex line."
	return Vector3( getFloatGivenBinary( byteIndex, stlData ), getFloatGivenBinary( byteIndex + 4, stlData ), getFloatGivenBinary( byteIndex + 8, stlData ) )

def getVertexGivenLine( line ):
	"Get vertex given stl vertex line."
	splitLine = line.split()
	return Vector3( float( splitLine[ 1 ] ), float( splitLine[ 2 ] ), float( splitLine[ 3 ] ) )
