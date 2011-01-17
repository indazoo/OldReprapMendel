package org.reprap.scanning.FeatureExtraction;
/******************************************************************************
* This program is free software; you can redistribute it and/or modify it under
* the terms of the GNU General Public License as published by the Free Software
* Foundation; either version 3 of the License, or (at your option) any later version.
* 
* This program is distributed in the hope that it will be useful, but WITHOUT
* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
* FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
* details.
* 
* The license can be found on the WWW at: http://www.fsf.org/copyleft/gpl.html
* 
* Or by writing to: Free Software Foundation, Inc., 59 Temple Place - Suite
* 330, Boston, MA 02111-1307, USA.
*  
* 
* If you make changes you think others would like, please contact one of the
* authors or someone at the reprap.org web site.
* 
* 				Author list
* 				===========
* 
* Reece Arnott	reece.arnott@gmail.com
* 
* Last modified by Reece Arnott 17 January 2011
*
*  TODO - should the pixel colours be stored as int and converted when needed?
*  		
* 	
* This samples a triangular patch using barycentric coordinates so the samples will fill the upper left triangle of a square grid.
*
****************************************************************************************************************************/
import org.reprap.scanning.DataStructures.*;
import org.reprap.scanning.Geometry.Point2d;
import org.reprap.scanning.Geometry.Point3d;
import org.reprap.scanning.Geometry.Coordinates;
public class TexturePatch {

	private PixelColour[] sampledtexturecolours; // Note that this is really a set of points in a 2d grid so could be a 2d array but as they form a triangle then half the array would be blank. Instead there is a private method to transform 2d coordinates into the array index 
	//private Point2d[] triangularvertices; // These are 3 points used as the anchor points with everything being transformed to and from barycentric coordinates relative to them. Currently not used outside of constructor
	private int squarewidth; // Set by constructor
	
	// Constructors
	public TexturePatch(Image image, Point3d a, Point3d b, Point3d c, int squaresize){
		// Set up the sampled texture colours array and initialise to blank. Note that the number of sample points will be a little over 1/2 the square of the length of the 2d grid. i.e. 1+2+3+...+n or (n*(n+1))/2
		squarewidth=squaresize;
		sampledtexturecolours=new PixelColour[(int)Math.round((squaresize*(squaresize+1)*0.5))];
		for (int i=0;i<sampledtexturecolours.length;i++) sampledtexturecolours[i]=new PixelColour(); 
		
		// Convert the 3d points to 2d points in the image
		Point2d[] triangularvertices;
		triangularvertices=new Point2d[3];
		triangularvertices[0]=image.getWorldtoImageTransform(a.ConvertPointTo4x1Matrix());
		triangularvertices[1]=image.getWorldtoImageTransform(b.ConvertPointTo4x1Matrix());
		triangularvertices[2]=image.getWorldtoImageTransform(c.ConvertPointTo4x1Matrix());
		
		init(triangularvertices,image);
	}
	public TexturePatch(int approxnumberofsamples, Image image, Point3d a, Point3d b, Point3d c){
		// Set up the sampled texture colours array and initialise to blank. Note that the number of sample points will be a little over 1/2 the square of the length of the 2d grid. i.e. 1+2+3+...+n or (n*(n+1))/2
		// using the quadratic formula we can work out n as we can rearrange n(n+1)/2=s to be
		// n^2+n-2s=0
		// so n=-1+/- sqrt(1+8s))/2, as we are only interested in the positive root and need to round to the nearest integer, this gives us
		squarewidth=(int)Math.round((Math.sqrt(1+(approxnumberofsamples*8))-1)*0.5);
		// Note that due to needing this to be a whole number the requested number of samples may not be quite what we end up with.
		sampledtexturecolours=new PixelColour[(int)Math.round((squarewidth*(squarewidth+1)*0.5))];
		for (int i=0;i<sampledtexturecolours.length;i++) sampledtexturecolours[i]=new PixelColour(); 
		
		// Convert the 3d points to 2d points in the image
		Point2d[] triangularvertices;
		triangularvertices=new Point2d[3];
		triangularvertices[0]=image.getWorldtoImageTransform(a.ConvertPointTo4x1Matrix());
		triangularvertices[1]=image.getWorldtoImageTransform(b.ConvertPointTo4x1Matrix());
		triangularvertices[2]=image.getWorldtoImageTransform(c.ConvertPointTo4x1Matrix());
		
		init(triangularvertices,image);
	}
	public TexturePatch(){squarewidth=0;sampledtexturecolours=new PixelColour[0];}

	// Clone method
	public TexturePatch clone(){
		TexturePatch returnvalue=new TexturePatch();
		returnvalue.squarewidth=squarewidth;
		returnvalue.sampledtexturecolours=new PixelColour[sampledtexturecolours.length];
		for (int i=0;i<sampledtexturecolours.length;i++) returnvalue.sampledtexturecolours[i]=sampledtexturecolours[i].clone();
		return returnvalue;
	}
	
	public int GetSquareGridSize(){return squarewidth;}
	
	// For display purposes the samples will be in the upper half triangle of the square with the lower half being black
	public PixelColour[][] ConvertTextureToSquareArrayOfColoursForDisplay(){
		PixelColour[][] returnvalue=new PixelColour[squarewidth][squarewidth];
		for (int x=0;x<squarewidth;x++)
			for (int y=0;y<squarewidth;y++)
				if ((squarewidth-x)>y) returnvalue[x][y]=sampledtexturecolours[ConvertToArrayCoordinates(x,y,squarewidth)].clone();
				else returnvalue[x][y]=new PixelColour();
		return returnvalue;
	}

	
	
	
	
	/************************************************************************************************************************************************
	 * 
	 * Private methods from here on down
	 * 
	 ************************************************************************************************************************************************/
	// Called from constructors
	private void init(Point2d[] triangularvertices, Image image){
		Coordinates point=new Coordinates(3);
		
		// Collect the samples
		for (int y=0;y<squarewidth;y++){
			for (int x=0;x<(squarewidth-y);x++){
			  // calculate the barycentric coordinates for this point
				// The order of these doesn't matter as long as it is consistent so make it so that when displaying the 2d grid point 0 is upper left, point 1 is upper right, point 2 is lower left (increasing the x or y barycentric coordinates give a point closer to b or c respectively)
				// This just makes it relatively easy to test by simply giving a triangle with similar orientation. There is no inherent reason for choosing one orientation over another though.  
				point.barycoordinates[1]=(double)x/(double)squarewidth;
				point.barycoordinates[2]=(double)y/(double)squarewidth;
				point.barycoordinates[0]=1-point.barycoordinates[1]-point.barycoordinates[2];
				// Now retrieve the colour of this point and insert it into the array
				point.CalculatePixelCoordinate(triangularvertices);
				sampledtexturecolours[ConvertToArrayCoordinates(x,y,squarewidth)]=image.InterpolatePixelColour(point.pixel);
				// Note that the ConvertToArrayCoordinates currently does the same as incrementing index would do within this loop but the calculation is farmed out so
				// can change the calculation if need be and still have set and get calls going to the same index within the 1d array.
			} // end for x
		} // end for y
	}

	
	private static int ConvertToArrayCoordinates(int x, int y, int maxx){
		// Note this doesn't take into account if (x,y) is outside the upper (left) triangle of the 2d grid. Checks for this need to be made before calling this 
		if (y==0) return x;
		else return ((y*maxx)-(int)Math.round((y*(y-1)*0.5))+x); 	
	}
	
}
