package org.reprap.scanning.DataStructures;
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
 * Last modified by Reece Arnott 13th May 2010
 * 
 * These are methods that use the native image manipulation classes to read images into
 * memory as image intensity (greyscale) 2d arrays as well as some simple Matrix based coordinate conversions 
 * between real world and image coordinates and querying of optional metadata
 * 
 * TODO - do we want to use the BufferedImage to store the image rather than 2D byte array?
 * 
 *********************************************************************************/
//Image manipulation classes - may need to check that these work the same in different JRE versions
import javax.swing.JProgressBar;

import Jama.Matrix;
import org.reprap.scanning.Geometry.*;
import org.reprap.scanning.FeatureExtraction.*;
import org.reprap.scanning.Calibration.CalibrateImage;
import org.reprap.scanning.Calibration.LensDistortion;
import org.reprap.scanning.FileIO.ImageFile;


public class Image {
	public CalibrateImage calibration;
	private Matrix CameraMatrix;
	public boolean skipprocessing; // this is used flag whether or not the image should/can be used at all
	// Note that the WorldtoImageTransform variable should only be read via the getWorldtoImageTransform method
	// and set via the setWorldtoImageTransform method. 
	private boolean setWorldtoImageTransform=false;
	private Matrix WorldtoImageTransform; 
	public Point2d originofimagecoordinates; // This is only used so that the camera calibration class can use the assumption that the prinicipal point is at the origin (as it would be difficult to force the Image of the Absolute Conic to contain a specific prinicpal point of anything but the origin)
	 // and in the lens distortion class when calculating k1 as the centre of distortion is assumed to be at the origin.
	public PointPair2D[] matchingpoints; 
	private boolean[][] calibrationsheet;
	private EdgeExtraction2D edges;
	private float[] blur=new float[0]; // This is set when the file is read into memory and is filtering kernel. Could be a zero length array if there is no blurring 

	
	// The imagemap is a 2d greyscale representation of the image. May not need to be used once the blob finding routinue has finished 
	private byte[][] imagemap;
	 //The height and width parameters are read at the time the image is first accessed by the constructor
	//public int width;
	//public int height;
	public int width;
	public int height;
	
	public String filename="";
	
	// Constructors
	// Currently just used by clone method
	public Image(){
		calibrationsheet=new boolean[0][0];
		imagemap=new byte[0][0];
		originofimagecoordinates=new Point2d(0,0);
		width=0;
		height=0;
		filename="";
		setWorldtoImageTransform=false;
		// Set the camera matrix to be the identity matrix 
		CameraMatrix=new Matrix(3,3);
		CameraMatrix.set(0,0,1);
		CameraMatrix.set(1,1,1);
		CameraMatrix.set(2,2,1);
		skipprocessing=true;
		matchingpoints=new PointPair2D[0];
		calibration=new CalibrateImage();
		edges=new EdgeExtraction2D();
	//	distortion=new LensDistortion(); // creates a zero distortion class
	}
	// used to load in a image, convert it to greyscale but not additional filtering applied
	public Image(String imagename) {
		// Initialise the imagemap etc. and set to defaults then try and load from file
		// Then try and load preferences from file
		calibrationsheet=new boolean[0][0];
		setWorldtoImageTransform=false;
		imagemap=new byte[0][0];
		originofimagecoordinates=new Point2d(0,0);
		filename=imagename;
		width=0;
		height=0;
		matchingpoints=new PointPair2D[0];
		// Set the camera matrix to be the identity matrix 
		CameraMatrix=new Matrix(3,3);
		CameraMatrix.set(0,0,1);
		CameraMatrix.set(1,1,1);
		CameraMatrix.set(2,2,1);
		skipprocessing=true;
		calibration=new CalibrateImage();
		edges=new EdgeExtraction2D();
	//	distortion=new LensDistortion(); // creates zero distortion to begin with
		ReadImageFromFile(new float[0]); // read in the image but don't apply any filtering
	}
	// Read in the image and apply a filter
	public Image(String imagename, float[] kernel) {
		// Initialise the imagemap etc. and set to defaults then try and load from file
		// Then try and load the image from file
		calibrationsheet=new boolean[0][0];
		setWorldtoImageTransform=false;
		imagemap=new byte[0][0];
		originofimagecoordinates=new Point2d(0,0);
		filename=imagename;
		width=0;
		height=0;
		matchingpoints=new PointPair2D[0];
		// Set the camera matrix to be the identity matrix 
		CameraMatrix=new Matrix(3,3);
		CameraMatrix.set(0,0,1);
		CameraMatrix.set(1,1,1);
		CameraMatrix.set(2,2,1);
		skipprocessing=true;
		calibration=new CalibrateImage();
		edges=new EdgeExtraction2D();
	//	distortion=new LensDistortion(); // creates zero distortion to begin with 
		ReadImageFromFile(kernel);
	}
	// end of constructors
	
	

	public Image clone(){
		Image returnvalue=new Image();
		returnvalue.skipprocessing=skipprocessing;
		//returnvalue.distortion=distortion.clone();
		returnvalue.calibrationsheet=calibrationsheet.clone();
		if (!skipprocessing){
			returnvalue.setWorldtoImageTransform=setWorldtoImageTransform;
			if (setWorldtoImageTransform) returnvalue.WorldtoImageTransform=WorldtoImageTransform.copy();
			returnvalue.calibration=calibration.clone();
			returnvalue.CameraMatrix=CameraMatrix.copy();
			returnvalue.matchingpoints=matchingpoints.clone();
			returnvalue.edges=edges.clone();
		}
		returnvalue.width=width;
		returnvalue.height=height;
		returnvalue.filename=filename;
		returnvalue.imagemap=imagemap.clone();
		returnvalue.originofimagecoordinates=originofimagecoordinates.clone();
		returnvalue.blur=blur.clone();
		return returnvalue;
	} // end of clone method

	public void CopyCalibrationParameters(Image other){
		setWorldtoImageTransform=other.setWorldtoImageTransform;
		if (setWorldtoImageTransform) WorldtoImageTransform=other.WorldtoImageTransform.copy();
		calibration=other.calibration.clone();
		CameraMatrix=other.CameraMatrix.copy();
		matchingpoints=other.matchingpoints.clone();
		originofimagecoordinates=other.originofimagecoordinates.clone();
	}
	
	public void setCameraMatrix(Matrix M){
		CameraMatrix=M.copy();
	}
	
	public Matrix getCameraMatrix(){
		return CameraMatrix;
	}

	public byte[][] ExportImageMap(){
	byte[][]returnvalue=new byte[width][height];
	for (int x=0;x<width;x++)
		for (int y=0;y<height;y++)
			returnvalue[x][y]=InterpolatePixelBrightness(new Point2d(x,y));
	return returnvalue;
}

//	 This uses the InterpolatePixelBrightness to compare the pixel brightnesses and returns true if it is within a threshold
// The threshold should be between 0 and 255

public boolean CompareBrightness(Point2d left, Point2d right, int threshold){
		int leftbrightness;
		int rightbrightness;
		leftbrightness=(int)(InterpolatePixelBrightness(left,Math.sqrt(2)) & 0xff);
		rightbrightness=(int)(InterpolatePixelBrightness(right,Math.sqrt(2))& 0xff);
		return (Math.abs(rightbrightness-leftbrightness)<=threshold);
	}
public boolean CompareBrightness(Point2d left, int rightbrightness, int threshold){
	int leftbrightness;
	leftbrightness=(int)(InterpolatePixelBrightness(left,Math.sqrt(2)) & 0xff);
	return (Math.abs(rightbrightness-leftbrightness)<=threshold);
}

// 
public void setWorldtoImageTransformMatrix(){
	Matrix K=getCameraMatrix();
	Matrix R=calibration.getRotation();
	Matrix t=calibration.getTranslation();
	Matrix Z=calibration.getZscaleMatrix();
	//TODO add in if statement to deal with distortion matrix
	WorldtoImageTransform=new MatrixManipulations().WorldToImageTransformMatrix(K,R,t,Z);
	setWorldtoImageTransform=true;
}
public Matrix getWorldtoImageTransformMatrix(){
	if (!setWorldtoImageTransform) setWorldtoImageTransformMatrix();
	return WorldtoImageTransform;
}

// This assumes the point given is a 4x1 matrix representing a 3d point in homogeneous coordinates
public Point2d getWorldtoImageTransform(Matrix point){
	if (!setWorldtoImageTransform) setWorldtoImageTransformMatrix();
	MatrixManipulations manipulate=new MatrixManipulations();
	manipulate.SetWorldToImageTransform(WorldtoImageTransform);
	Point2d imagepoint=new Point2d(manipulate.WorldToImageTransform(point,originofimagecoordinates));
	return imagepoint;
}
public Point2d getWorldtoImageTransform(Point3d point){
	return getWorldtoImageTransform(new MatrixManipulations().ConvertPointTo4x1Matrix(point));
}

// Methods to pass information to and from the more complicated private variables
public Point2d[] GetEdgePoints(){
	return edges.GetEdgePoints(originofimagecoordinates);
}
public int GetNumberofEdgePoints(){
	return edges.GetEdgeCount();
}
public double GetEdgeResolution(){
	return edges.GetResolution();
}
public void SetEdges(EdgeExtraction2D edge){
	edges=edge.clone();
}
public void LimitEdgesToRaysThatIntersectAVolumeOfInterest(AxisAlignedBoundingBox boundingbox, AxisAlignedBoundingBox[] volumesofinterest){
	edges.LimitToEdgeRaysThatIntersectAVolumeOfInterest(boundingbox, volumesofinterest,getWorldtoImageTransformMatrix(),originofimagecoordinates);
}
public void SetCalibrationSheet(boolean[][] calibration){
	calibrationsheet=calibration.clone();
}
public boolean IsCalibrationSheet(Point3d worldpoint){
	return IsCalibrationSheet(new MatrixManipulations().ConvertPointTo4x1Matrix(worldpoint));
}

public boolean IsCalibrationSheet(Matrix worldpoint){
	Point2d imagepoint=getWorldtoImageTransform(worldpoint);
	int x=(int)imagepoint.x;
	int y=(int)imagepoint.y;
	boolean returnvalue=false;
	if ((x>=0) && (x<width) && (y>=0) && (y<height)) returnvalue=calibrationsheet[x][y];
	return returnvalue;
}

public void NegateLensDistortion(LensDistortion distortion, JProgressBar bar){
	
	bar.setMinimum(0);
	bar.setMaximum(height*2);
	bar.setValue(0);
	
	byte[][] newimage=new byte[width][height];
	if (distortion.UseDistortionFunction()){
		// The distortion function is not invertible so the easiest thing to do is to undistort all pixel points and store this mapping and resample
		// based on the closest mapped point. The best way would be to take a weighted average of the closest n points greyscale values but this distortion function
		// is only valid for small amounts of distortion so is it really worth the extra effort?
		Point2d[] lookuptable=new Point2d[width*height];
		for (int y=0;y<height;y++){
			bar.setValue(y);
			int index=y*width;
			for (int x=0;x<width;x++){
				lookuptable[index+x]=distortion.UndoDistortion(new Point2d(x,y));
			}
		}
		// To make things quicker we partition the array using a Uniform 2D Grid and just use the closest points to interpolate the new greyscale value
		// The number of cells in the uniform grid will be approximately the same as the number of pixels so it should be fairly efficient
		// The maximal number of cells queried will occur when the target cell and its immediate 8 surrounding cells are empty so the next layer out will be mined for points to sort leading to approximately 25 points to sort.
		// With severe distortion this could go up to even 49 cells/pixels to mine and sort but I highly doubt it would be more. With more distortion the distortion matrix should be being used instead.
		Uniform2DGrid grid=new Uniform2DGrid(lookuptable,width*height);
		for (int y=0;y<height;y++){
			bar.setValue(y+height);
			for (int x=0;x<width;x++){
				//Get the indexes in the grid cell closest to this point
				Point2d target=new Point2d(x,y);
				int [] indexes=grid.GetClosestPoints(target); 
				// this will return an empty list if the pixel is inside the distorted image bounding rectangle but with no pixels near, a list of length 1 and value -1 if the pixel is outside the distorted image bounding box entirely or a list of the nearest pixels if it is inside the image  
				if (indexes.length==0) {indexes=new int[1]; indexes[0]=-1;}  
				if (indexes[0]!=-1){
					int[] greyscales=new int[indexes.length];
					Point2d[] points=new Point2d[indexes.length];
					for (int i=0;i<indexes.length;i++){
						points[i]=lookuptable[indexes[i]].clone();
						int oldx=(indexes[i]%width);
						int oldy=(int)((double)(indexes[i]-oldx)/(double)width);
						greyscales[i]=((int)imagemap[oldx][oldy] & 0xff); 
						// note the & 0xff of the signed bit as otherwise direct conversion to int assumes it -128..127 not 0..255 
						// can't just add 128 as it is 2's complement so -1<->255, -2<->254 .. -127<->128 etc.
					}
					newimage[x][y]=InterpolatePixelBrightness(target,points,greyscales);
				}
				else newimage[x][y]=(byte)0;
				}
			}
		imagemap=newimage.clone();
	}
	else {
		// TODO If we aren't using the distortion function then distortion is estimated by a matrix so we should be able to invert it 
		// so we can easily resample the image
	}
}



// This converts 2d image coordinates into a line represented by a matrix
public Matrix getImagetoWorldTransform(Point2d point){
	if (!setWorldtoImageTransform) setWorldtoImageTransformMatrix();
	Matrix imagepoint=new Matrix(3,1);
	imagepoint.set(0,0,point.x);
	imagepoint.set(1,0,point.y);
	imagepoint.set(2,0,1);
	Matrix worldline=WorldtoImageTransform.transpose().times(imagepoint);
	return worldline;
}

//public boolean WorldPointBehindCamera(Point3d worldpoint){
//	return WorldPointBehindCamera(new MatrixManipulations().ConvertPointTo4x1Matrix(worldpoint));
//}


// This takes a 4x1 homogeneous world point and tests whether it is behind the camera
public boolean WorldPointBehindCamera(Matrix worldpoint){
	boolean returnvalue=true;
	if (!setWorldtoImageTransform) setWorldtoImageTransformMatrix();
	//There is a formula to work out the depth of a point from a camera:
	// (sign(det M)*w')/(w||m3||) where M is the left hand 3x3 block of P i.e. K[R|t], m3 is the third row of M and w and w' are the 4th and 3rd homogeneous coordinates in the 4x1 world point and 3x1 image point respectively 
	//but we are only concerned with the sign - positive means it is in front, negative means behind.
	// So we can use a simplified version sign=w'*w*det(M) 
	Matrix imagepoint=new MatrixManipulations().WorldToImageTransform(worldpoint,WorldtoImageTransform,originofimagecoordinates);
	returnvalue=((WorldtoImageTransform.getMatrix(0,2,0,2).det()*worldpoint.get(3,0)*imagepoint.get(2,0))<0);
	return !returnvalue; // TODO find out why we need to invert this. behind the camera should be when w'*w*det(M)<0 but it is not, it is when it is >0. Why????
}

//Get the point matching error we want to minimise
// specifically the sum of the square of the distance between the image ellipse center point and the circle center projected from the calibration plane to the image plane
public double GetDsquaredSumError(){
	double dsquarederrorsum=0;
	for (int i=0;i<matchingpoints.length;i++){
		Matrix point=new Matrix(4,1);
		point.set(0,0,matchingpoints[i].pointone.x);
		point.set(1,0,matchingpoints[i].pointone.y);
		point.set(2,0,0);
		point.set(3,0,1);
		Point2d centre=getWorldtoImageTransform(point);
		dsquarederrorsum=dsquarederrorsum+centre.CalculateDistanceSquared(matchingpoints[i].pointtwo);
	}
	return dsquarederrorsum;
}
//This method flips the image y coordinates if needed and changes the greyscale value to equal RGB values for display purposes
//It reads the image into a byte array that can be used by the OpenGL display method to display it
//The image is adjusted to undo the detected distortion if using the distortion function

public byte[] ConvertImageForDisplay(int numcolours)
{
	int tempindex,index;
	byte[] GLimage=new byte[(height+1)*(width+1)*numcolours];
	
	// 	Read pixels in a row at a time taking care to flip the image at the same time
	for (int y=0; y < height; y++)
	{
		tempindex=(height-y-1)*width*numcolours;
		// if the y coordinate is already stored internally as inverted then don't worry about flipping it for display
		for (int x=0;x<width;x++){
			// Apply the undistortion function to the pixel
			Point2d target=new Point2d(x,y);
			index=tempindex+(x*numcolours);
			for (int colours=0;colours<numcolours;colours++)
				GLimage[index+colours]=InterpolatePixelBrightness(target, Math.sqrt(2)); // read the greyscale pixel into the correct part of the 1D array
			} // end for x
	} // end for y
return GLimage;	
} // end of method




// This method takes a number of Coordinates and returns them with their greyscale values set.
public Coordinates[] GetBrightnessValues(Coordinates target[]){
	// Go through the Coordinate array and add in the colours where appropriate 
		for (int i=0;i<target.length;i++){
				if ((target[i].pixel.x<width) && (target[i].pixel.y<height) && (target[i].pixel.x>=0) && (target[i].pixel.y>=0))
					target[i].greyscale=InterpolatePixelBrightness(target[i].pixel,Math.sqrt(2));
		} //end for
		return target;	
	} // end GetBrightnessValues 	



//This method calculates a greyscale value using 3 other pixels for samples and extrapolates the pixel brightness based on the partial differential of the greyscale value in terms of x and y coordinates
public double ExtrapolatePixelBrightness(Point2d target, Point2d point1, Point2d point2, Point2d point3){
		// Find the centroid of the triangle made by these points
		Point2d[] referencepoints=new Point2d[3];
		referencepoints[0]=point1.clone();
		referencepoints[1]=point2.clone();
		referencepoints[2]=point3.clone();
		Coordinates coords=new Coordinates(3);
		for (int i=0;i<3;i++) coords.barycoordinates[i]=(double)1/(double)3;
		coords.CalculatePixelCoordinate(referencepoints);
		Point2d centre=coords.pixel.clone();
		// Find the interpolated greyscale values of the center pixel and those offset from it by 1 pixel in the x and y directions and from them the interpolated change in greyscale value in terms of change in x and y (i.e. partial derivatives)
		double centregreyscalevalue=0;
		for (int i=0;i<3;i++) centregreyscalevalue=centregreyscalevalue+((double)(InterpolatePixelBrightness(referencepoints[i]) & 0xff)*coords.barycoordinates[i]);
		
		coords.pixel.x=centre.x+1;
		coords.pixel.y=centre.y;
		coords.calculatebary(referencepoints);
		double dx=0;
		for (int i=0;i<3;i++) dx=dx+((int)(InterpolatePixelBrightness(referencepoints[i]) & 0xff)*coords.barycoordinates[i]);
		
		coords.pixel.x=centre.x;
		coords.pixel.y=centre.y+1;
		coords.calculatebary(referencepoints);
		double dy=0;
		for (int i=0;i<3;i++) dy=dy+((int)(InterpolatePixelBrightness(referencepoints[i]) & 0xff)*coords.barycoordinates[i]);
		
		
		dx=dx-centregreyscalevalue;
		dy=dy-centregreyscalevalue;
		// Now use the partial derivatives to find the pixel brightness at the target point.
		double value=centregreyscalevalue;
		value=value+dx*(target.x-centre.x);
		value=value+dy*(target.y-centre.y);
		
		
		return value;
} // end of method

//This method calculates a greyscale value using a circular filter around a target pixel coordinate with a fixed radius of sqrt(2) and returns the estimated greyscale value.
public byte InterpolatePixelBrightness(Point2d target){
	return InterpolatePixelBrightness(target,Math.sqrt(2));
}


/*****************************************************************************************************************************************
 * 
 * Private methods from here on down
 * 
 *****************************************************************************************************************************************/


//This method calculates a greyscale value using a circular filter around a target pixel coordinate with radius value passed in along with the coordinate
//this method returns the estimated greyscale value.
	private byte InterpolatePixelBrightness(Point2d target, double radius){
		// Don't bother with interpolating if the target pixel is very close to an actual pixel, just return that pixel value	
		int roundedx=Math.round((long)target.x);
		int roundedy=Math.round((long)target.y);
		if ((target.isApproxEqual(new Point2d(roundedx,roundedy),0.0001)) && (roundedx>=0) && (roundedx<width) && (roundedy>=0) && (roundedy<height)) return imagemap[roundedx][roundedy];
		else {
			double maxdistancesquared=radius*radius;
			// find the maximum and minimum pixels to add to filter
			int minx=(int)(target.x-radius-1);
			int miny=(int)(target.y-radius-1);
			int maxx=(int)(target.x+radius+1);
			int maxy=(int)(target.y+radius+1);
			double distancesquared;
			double weightsum=0;
			double oneoverrsquared=1/maxdistancesquared;
			// Calculate the greyscale value and enter it into the target
			double greyscale=0;
			for (int y=miny;y<=maxy;y++){
				double dy=target.y-y;
				for (int x=minx;x<=maxx;x++) {
					double dx=target.x-x;
					distancesquared=dx*dx+dy*dy;
					// only add the colour if it is within the distance we care about and weight it by that distance
					if ((distancesquared<=maxdistancesquared) && (x>=0) && (x<width) && (y>=0) && (y<height)){
						// This is a very simple weighting, simply 1-(d^2/R^2)
						double weight=1-(distancesquared*oneoverrsquared);
						weightsum=weightsum+weight;
						greyscale=greyscale+(((int) imagemap[x][y] & 0xff)*weight); 
						// note the & 0xff of the signed bit as otherwise direct conversion to int assumes it -128..127 not 0..255 
						// can't just add 128 as it is 2's complement so -1<->255, -2<->254 .. -127<->128 etc.
					} // end if
				} // end for x
			} //end for ytarget.
			//normalise finalgreyscale and return it
			return (byte)((int)(greyscale/weightsum));
			} // end else
		} // end of method
	
	private byte InterpolatePixelBrightness(Point2d target, Point2d[] source, int[] greyscale){
		// Find the distances squared to the source pixels and also find the maximum distance squared
		double[] dsquared=new double[source.length];
		double maxdistancesquared=0;
		for (int i=0;i<source.length;i++){
			dsquared[i]=target.CalculateDistanceSquared(source[i]);
			if (maxdistancesquared<dsquared[i]) maxdistancesquared=dsquared[i];
		}
		// Now calculate the weighted average greyscale weighting
		// The weighting is the same as in the above method i.e. 1-(d^2/R^2)
		double weightsum=0;
		double oneoverrsquared=1/maxdistancesquared;
		double greyscalevalue=0;
		for (int i=0;i<source.length;i++){
			double weight=1-(dsquared[i]*oneoverrsquared);
			weightsum=weightsum+weight;
			greyscalevalue=greyscalevalue+(greyscale[i]*weight); 
		}
		//normalise finalgreyscale and return it
			return (byte)((int)(greyscalevalue/weightsum));
		} // end of method
	
	//TODO these are only used in the Gui Testing class. If they are to be used elsewhere this should be changed. Its a bad hack!
	public void OverwriteGreyscaleWithRedChannel(){
		ImageFile inputfile=new ImageFile(filename);
		imagemap=inputfile.ReadImageFromFile(blur,16); // 16 is the red channel by default
	}
	public void OverwriteGreyscaleWithGreenChannel(){
		ImageFile inputfile=new ImageFile(filename);
		imagemap=inputfile.ReadImageFromFile(blur,8); // 8 is the green channel by default
	}
	public void OverwriteGreyscaleWithBlueChannel(){
		ImageFile inputfile=new ImageFile(filename);
		imagemap=inputfile.ReadImageFromFile(blur,0); // 0 is the blue channel by default
	}
	public void OverwriteColourWithGreyscaleChannel(){
		ImageFile inputfile=new ImageFile(filename);
		imagemap=inputfile.ReadImageFromFile(blur,-1); // -1 is for a greyscale image
	}

	
	private void ReadImageFromFile(float[] filter){
		blur=filter.clone();
		ImageFile inputfile=new ImageFile(filename);
		imagemap=inputfile.ReadImageFromFile(filter,-1); // -1 is greyscale image
		width=inputfile.width;
		height=inputfile.height;
		calibrationsheet=new boolean[width][height];
		for(int y=0;y<height;y++)
			for(int x=0;x<width;x++)
				calibrationsheet[x][y]=false;
	} // end of ReadImageFromFile

	
} // end of class