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
* Last modified by Reece Arnott 11th October 2010
* 
* Colour abstracted out so that both greyscale and colour processing can take place
* Note that the greyscale value is not calculated from the RGB colour values. It is assumed to be precalculated and feed to the constructor
*
************************************************************************************/

public class PixelColour {

	private byte greyscale;
	 private byte r,g,b;
	
	
	// Constructors
	public PixelColour(byte grey){
		greyscale=grey;
		r=grey;
		g=grey;
		b=grey;
	}
	public PixelColour(){
		greyscale=(byte)0;
		r=(byte)0;
		g=(byte)0;
		b=(byte)0;
		}
	public PixelColour(int ARGB, byte grey){
	// Note that it is assumed that the int encodes the pixel colour in the default format of 8 bits for each of Alpha, Red, Green, Blue (and we are ignoring the Alpha channel)
	// The greyscale value is a given and is not calculated within this class
		r=(byte)((ARGB >> 16) & 0xff);
		g=(byte)((ARGB >> 8) & 0xff);
		b=(byte)((ARGB >> 0) & 0xff);
		greyscale=grey;
	}
	
	
	public PixelColour clone(){
		PixelColour returnvalue=new PixelColour();
		returnvalue.r=r;
		returnvalue.g=g;
		returnvalue.b=b;
		returnvalue.greyscale=greyscale;
		return returnvalue;
	}
	
	public void SetPixelToWeightedAverageColour(double[] weights, PixelColour[] colours){
		double weightsum=0;
		double redsum=0;
		double greensum=0;
		double bluesum=0;
		double greysum=0;
		for (int i=0;i<colours.length;i++){
			if (i<weights.length){
				weightsum=weightsum+weights[i];
				redsum=redsum+((int)(colours[i].r & 0xff)*weights[i]);
				greensum=greensum+((int)(colours[i].g & 0xff)*weights[i]);
				bluesum=bluesum+((int)(colours[i].b & 0xff)*weights[i]);
				greysum=greysum+((int)(colours[i].greyscale & 0xff)*weights[i]);
				// note the & 0xff of the signed bit as otherwise direct conversion to int assumes it -128..127 not 0..255 
				// can't just add 128 as it is 2's complement so -1<->255, -2<->254 .. -127<->128 etc.
			}
		}
		r=(byte)((int)(redsum/weightsum));
		g=(byte)((int)(greensum/weightsum));
		b=(byte)((int)(bluesum/weightsum));
		greyscale=(byte)((int)(greysum/weightsum));
	}
	
	public void SetPixelToWeightedAverageColour(double[] weights, PixelColour[] colours, int truncate){
	PixelColour[] newcolours=colours.clone();
	double[] newweights=weights.clone();
		if (truncate<colours.length){
			newcolours=new PixelColour[truncate];
			for (int i=0;i<truncate;i++) newcolours[i]=colours[i].clone();
		}
		if (truncate<weights.length){
			newweights=new double[truncate];
			for (int i=0;i<truncate;i++) newweights[i]=weights[i];
		}
		SetPixelToWeightedAverageColour(newweights,newcolours);
	}
	
	public byte getGreyscale(){
		return greyscale;
	}
	public byte getRed(){
		return r;
	}
	public byte getGreen(){
		return g;
	}
	public byte getBlue(){
		return b;
	}
	/*
	public boolean CompareColours(PixelColour other, int threshold){
	//TODO???
	}
	*/
	public boolean CompareGreyscale(int greyscalevalue, int threshold){
		return (Math.abs((int)(greyscale & 0xff)-greyscalevalue)<=threshold);
	}
	public boolean CompareGreyscale(byte greyscalevalue, int threshold){
		return CompareGreyscale((int)greyscalevalue & 0xff,threshold);
	}
	public boolean CompareGreyscale(PixelColour other, int threshold){
		return CompareGreyscale(other.greyscale,threshold);
	}
	
	public boolean[][] ConvertGreyscaleToBoolean(PixelColour[][] array, int width, int height,int threshold){
		boolean[][] returnvalue=new boolean[width][height];
		for (int i=0;i<width;i++)
			for (int j=0;j<height;j++){
				returnvalue[i][j]=(int)(array[i][j].greyscale & 0xff)>=threshold;
			}
		return returnvalue;
	}
	
}