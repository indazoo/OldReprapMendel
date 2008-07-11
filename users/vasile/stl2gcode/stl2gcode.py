#!/usr/bin/python

## stl2gcode generates gcode from stereolithographic triangles.  This
## gcode can be fed to CNC fab machines to create physical 3D models.
## stl2gcode also generates intermediate file formats (i.e. pov and
## png files).

## Copyright (C) 2008 James Vasile <james@hackervisions.org>.  This is
## free software; you can redistribute it and/or modify it under the
## terms of the GNU General Public License as published by the Free
## Software Foundation; either version 3 of the License, or any later
## version.

## This is distributed in the hope that it will be useful, but WITHOUT
## ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
## or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
## License for more details.  You should have received a copy of the
## GNU General Public License along with image-to-gcode; if not, write
## to the Free Software Foundation, Inc., 51 Franklin Street 5th
## Floor, Boston, MA 02110-1301 USA
##
## See http://www.evilmadscientist.com/article.php/slicingstl
## See http://forums.reprap.org/read.php?12,9756,page=1
##
## Not tested on Windows or Mac boxes.
## 
## Needs PIL, the Python Imaging Library (aptitude install
## python-imaging)
##
## stl2gcode includes and derives from code originating in
## image-to-gcode.py.  That code is Copyright (C) 2005 Chris Radek
## (chris@timeguy.com)

## TODO: adjust the scale so that the png represents 1 step per bit in the bitmap
## TODO: decide whether this is a module or a class

import os
import sys
import Image
import gcode
import povray
from miscellaneous import *

VERSION=0.1

def povray_include (base_fname, inside_vector):
    'Convert an stl file into a POVRAY include object'
    ## TODO: use the -e distance option for stl2pov
    stdout_handle = os.popen("stl2pov -s " + base_fname + '.stl', "r")
    inc = stdout_handle.read()

    vec_string = 'inside_vector <%f, %f, %f>' % (
        inside_vector[0],inside_vector[1],inside_vector[2])

    ## write out include file with inside vector added
    out = open(base_fname+'.inc', 'w')
    out.write(inc.rpartition('} //')[0] + vec_string + "\n}\n")
    out.close

    return povray.object(inc);

def make_pov(fname, include, step_x, step_y, step_z):
    'Write a povray file that displays our included object'
    min_x = include.min_x()
    max_x = include.max_x()
    min_y = include.min_y()
    max_y = include.max_y()
    min_z = include.min_z()
    max_z = include.max_z()

    ## TODO: do we really want to center the object?
    camera = '''camera {
        orthographic
        up y*%f
        right x *  %f / %f * %f
        location <%f, 99999, %f>
        look_at <%f, 0, %f>
    }''' % ( max(max_x - min_x, max_z-min_z), 
             step_x, step_z, max(max_x-min_x, max_z-min_z),
            (max_x - min_x) / 2, (max_z - min_z) / 2,
            (max_x - min_x) / 2, (max_z - min_z) /2)

    pov = '''//Generated by stl2gcode.  Do not edit.
    #include "%s"
    background {color rgb 1 }
    %s
    intersection {
        object {  %s }
        box { <%f, %f, %f>, <%f, %f, %f>
              translate y * frame_number * %f }
    }''' % (fname+'.inc', camera,
            include.name(),
            2*min_x, min_y, min_z*2,
            2*max_x, min_y + step_y, max_z*2,
            step_y)

    out = open(fname+'.pov', 'w')
    out.write(pov)
    out.close

def make_png(fname, frames):
    '''Takes a pov file and generates png files that are slices of that pov scene
    TODO: lower png color depth'''
    cmd = 'povray +Q0 -D0 +KFF'+ str(frames) + ' ' + fname + '.pov'
    stdout_handle = os.popen(cmd, 'r')
    povray_output = stdout_handle.read()

def image_to_gcode(in_file, step_x, step_y, depth, x, y, out_file):
    '''Take a bitmapped image and generate gcode for cutting that image out.

    x and y are offsets for the initial x and y position
    step is the minimum distance you can move in the x or y directions.

    Note that what image_to_gcode calls the y axis is really our z axis.

    TODO: figure out how to use color depth?
    TODO: output gcode that works on a reprap'''

    im = Image.open(in_file)
    size = im.size
    im = im.convert("L") #grayscale
    w, h = im.size

    g = gcode.gcode(safetyheight=0.02)

    out = open(out_file, 'w')
    out.write(g.begin() + g.continuous() + g.safety() + g.rapid(0,0))

    for j in range(h-1,-1,-1):
        if j%2==1:
            for i in range(w):
                d = float(im.getpixel((i, h-j-1)) / 255.0) * depth - depth
                out.write(g.cut(x, y, d, feed=12))
                x += step_x
            x -= step_x
        else:
            for i in range(w-1,-1,-1):
                d = float(im.getpixel((i, h-j-1)) / 255.0) * depth - depth
                out.write(g.cut(x, y, d, feed=12))
                x -= step_x
            x += step_x
        y -= step_z
        out.write(g.cut(y=y))

    out.write(g.end())
    out.close

def png_to_gcode(fname, num_files, step_x, step_y, depth):
    'Given a range of png files, convert each to gcode'
    for i in range(1, num_files+1):
        image_to_gcode('%s%02d.png' % (fname, i), step_x, step_y,
                       depth, 0, 0, '%s%02d.gcode' % (fname, i))

class stl2gcode:
    step_x = step_y = step_z = 0.1
    depth = 0.008
    x, y = 0, 0

    #tolerance = 0.000000001
    inside_vector = [-0.5, 0.68, 0.5] # TODO: calculate this
    target = 'gcode'  # target format should be one of inc, pov, png, gcode

    filename=''
    base_fname=''

    def __init__(self, params):
        for p in params: exec('self.' + p + ' = params[p]')

    def convert(self):
        'The main sub-- it converts stl to inc/pov to png to gcode'
        self.base_fname, dot, extension = self.filename.rpartition('.');

        ## Generate inc file from stl
        if extension != 'stl':
            povray_inc = povray.object(self.base_fname + '.inc') # pull object from file
        else:
            povray_inc = povray_include(self.base_fname, self.inside_vector)
            if self.target == 'inc': return povray_inc

        ## Generate pov file from stl
        if extension in (['stl', 'inc']):
            make_pov(self.base_fname, povray_inc, self.step_x, self.step_y, self.step_z)
            if self.target == 'pov': return

        layers = int((povray_inc.max_y() - povray_inc.min_y()) / self.step_y) 

        ## Generate png files from pov and inc
        if extension in (['stl', 'inc', 'pov']):
            make_png(self.base_fname, layers)
            if self.target == 'png': return

        ## Generate gcode files from png
        if extension in (['stl', 'inc', 'pov', 'png']):
            png_to_gcode(self.base_fname, layers, self.step_x, self.step_z, self.depth)


