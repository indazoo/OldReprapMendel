/*

RepRap
------

The Replicating Rapid Prototyper Project


Copyright (C) 2005
Adrian Bowyer & The University of Bath

http://reprap.org

Principal author:

Adrian Bowyer
Department of Mechanical Engineering
Faculty of Engineering and Design
University of Bath
Bath BA2 7AY
U.K.

e-mail: A.Bowyer@bath.ac.uk

RepRap is free; you can redistribute it and/or
modify it under the terms of the GNU Library General Public
Licence as published by the Free Software Foundation; either
version 2 of the Licence, or (at your option) any later version.

RepRap is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
Library General Public Licence for more details.

For this purpose the words "software" and "library" in the GNU Library
General Public Licence are taken to mean any and all computer programs
computer files data results documents and other copyright information
available from the RepRap project.

You should have received a copy of the GNU Library General Public
Licence along with RepRap; if not, write to the Free
Software Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA,
or see

http://www.gnu.org/

=====================================================================


Rr2Point: 2D vectors

First version 20 May 2005
This version: 2 October 2005 (translation to Java)


*/

package org.reprap.geometry.polygons;

// Class for (x, y) points and vectors

public class Rr2Point
{
    private double x, y;

    // Default to the origin
    
    public Rr2Point()
    {
	x = 0;
	y = 0;
    }

    // Usual constructor
    
    public Rr2Point(double a, double b)
    {
	x = a;
	y = b;
    }

    // Copy
    
    public Rr2Point(Rr2Point r)
    {
	x = r.x;
	y = r.y;
    }


    // Convert to a string
    
    public String toString()
    {
	return Double.toString(x) + " " + Double.toString(y);
    }
    
    // Coordinates
    
    public double x() { return x; }
    public double y() { return y; }

    // Arithmetic
    
    public Rr2Point neg()
    {
	return new Rr2Point(-x, -y);
    }
    
    public static Rr2Point add(Rr2Point a, Rr2Point b)
    {
	Rr2Point r = new Rr2Point(a);
	r.x += b.x;
	r.y += b.y;
	return r;
    }
   
    public static Rr2Point sub(Rr2Point a, Rr2Point b)
    {
        return add(a, b.neg());
    }


    // Scaling

    public static Rr2Point mul(Rr2Point b, double a)
    {
        return new Rr2Point(b.x*a, b.y*a);
    }
    
    public static Rr2Point mul(double a, Rr2Point b)
    {
        return mul(b, a);
    }

    public static Rr2Point div(Rr2Point b, double a)
    {
	return mul(b, 1/a);
    }

    // Inner product

    public static double mul(Rr2Point a, Rr2Point b)
    {
	return a.x*b.x + a.y*b.y;
    }

        
    // Modulus
    
    public double mod()
    {
        return Math.sqrt(mul(this, this));
    }


    // Unit length normalization
    
    public Rr2Point norm()
    {
        return div(this, mod());
    }


    // Outer product

    public static double op(Rr2Point a, Rr2Point b)
    {
	return a.x*b.y - a.y*b.x;
    }


    // Squared distance

    public static double d_2(Rr2Point a, Rr2Point b)
    {
	Rr2Point c = sub(a, b);
	return mul(c, c);
    }
}


