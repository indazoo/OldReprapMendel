warning = '## This file generated by brlcad.py.  It might get clobbered.'
copyright = '## Copyright (C) 2008 James Vasile <james@hackervisions.org>'
license = '''## This is a freed work; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## any later version.

## This is distributed in the hope that it will be useful, but WITHOUT
## ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
## or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
## License for more details.  You should have received a copy of the
## GNU General Public License along with the work; if not, write
## to the Free Software Foundation, Inc., 51 Franklin Street, 5th
## Floor, Boston, MA 02110-1301 USA '''

import sys, os
from ctypes import *


VERSION = 0.3 

class Vector:
    def __init__(self,*args):
        if len(args) == 1:
            self.v = args[0]
        else:
            self.v = args
    def __str__(self):
        return "%s"%(" ".join([str(x)for x in self.v]))
    def __repr__(self):
        return "Vector(%s)"%self.v
    def __mul__(self,other):
        return Vector( [r*other for r in self.v] )
    def __rmul__(self,other):
        return Vector( [r*other for r in self.v] )


unique_names={}
def unique_name(stub, suffix):
    global unique_names
    full = stub + suffix
    if not full in unique_names:
        unique_names[full]=0
    unique_names[full] += 1
    return stub + '.' + str(unique_names[full]) + suffix

def build_name(stub, ending, **kwargs):
    '''There are a lot of kwargs options to control how objects are named.

    If you specify a name with 'name', the object will bear that exact
    name, with no suffix or unique number.  You are responsible for
    making sure the name is unique.

    'suffix' is added to names.  It's usually a single letter
    indicating s for shape or r for region.

    'basename' overrides the stub.  To this, a unique number and the
    suffix will be added.

    'unique_name' can be set to False, and that will turn off the numbering.'''

    if 'name' in kwargs:
        return kwargs['name']

    if 'suffix' in kwargs:
        suffix = kwargs['suffix']
    else:
        suffix = ending
    if suffix: suffix = '.' + suffix


    if 'basename' in kwargs:
        if 'unique_name' in kwargs and kwargs['unique_name']==False:
            return kwargs['basename'] + suffix
        else:
            return unique_name(kwargs['basename'], suffix)
    else:
        return unique_name(stub, suffix)

class Statement():
    isstatement = True
    name='' # statements don't have names, but this keeps group from complaining
    def __init__(self, statement, args=[]):

        self.args=[]
        if type(args) == str:
            self.args.append(args)
        else:
            for i in range(len(args)):
                if type(args[i]) == tuple or type(args[i]) == list:
                    self.args.append(Vector(args[i]))
                else:
                    self.args.append(args[i])

        self.statement = statement
        

    def __str__(self):
        return '%s %s\n' % (self.statement, ' '.join([str(s) for s in self.args]))


class Shape():
    isshape = True
    def __init__(self, args=[], **kwargs):
        '''A Shape is any physical item we can depict with brl-cad, from a
        primitive to a screw to a hole to an entire machine.

        Each element in args is a Statement or a Shape that makes this
        item.

        See rotate, translate and scalar functions for some keywords
        that will let you produce a scaled, rotate or translated
        object via keyword args to __init__.

        kwargs['scale'] - not implemented

        Specify the Shape by instantiating it along with the
        statements and shapes that comprise it.  For many shapes, it
        might be easiest to assemble them at the origin and then use
        translate and rotate to move them into position.  Do this with
        the translate, rotate and scale keywords or have the __init__
        function of your shape just do a translate and rotate based on
        the given vertex and height_vector.

        self.children stores a list of Shapes that comprise this one.'''

        self.name = build_name('shape', '', **kwargs)

        if not hasattr(self, 'statements'):
            self.statements = []

        if not hasattr(self, 'children'):
            self.children = [] # an array of Shapes

        for a in args:
            if hasattr(a, 'isstatement'):
                self.statements.append(a)
            elif hasattr(a, 'isshape'):
                self.children.append(a)
            elif type(a) == type('str'):
                self.statements.append(Statement(a))
            else:
                print >>sys.stderr, self.name, 'contains ', type(a)
                sys.exit(2)

        Shape.guess_vertex(self)  ## called this way because we don't want this overridden.

        if not hasattr(self, 'vertex'):
            sys.stderr.write('Shape (%s) needs vertex\n' % (self.name))
            sys.exit(2)

        ## Handle some kwarg options
        if 'group' in kwargs and kwargs['group']:
            self.group()
        if 'combination' in kwargs and kwargs['combination']:
            self.combination(kwargs['combination'])
        if 'region' in kwargs and kwargs['region']:
            self.combination(kwargs['region'])
        if 'rotate' in kwargs:
            self._do_init_rst('rotate', **kwargs)
        if 'translate' in kwargs:
            self._do_init_rst('translate', **kwargs)
        if 'scale' in kwargs:
            self._do_init_rst('scale', **kwargs)

    def _do_init_rst(self, arg, **kwargs):
        '''Handle a rotate, translate, or scale kwarg passed to init by
        checking that the params are correct and calling the
        appropriate function.

        We should probably do all this via object editing, but our
        current model doesn't require combinations, so this is
        easier.'''

        absolute=''
        if 'absolute' in kwargs:
            absolute=', absolute=True'

        if type(kwargs[arg] == tuple) or type(kwargs[arg] == list):
            if len(kwargs[arg]) == 3:
                exec('self.%s (kwargs[arg]%s)' % (arg, absolute))
            elif len(kwargs[arg]) == 2:
                exec('self.%s (kwargs[arg][0], kwargs[arg][1]%s)' % (arg, absolute))
            else:
                print >>sys.stderr, ('%s: %s takes 1 vector or 2 vectors in a tuple.' % 
                                     (self.name, arg))
                sys.exit(2)
        else:
            print >>sys.stderr, '%s: %s takes 1 or 2 tuples/lists.' % (self.name, arg)
            sys.exit(2)

    def __str__(self):
        '''Accessing an Object as a string will yield all the statements and
        the children's statements.'''

        return ''.join([str(c) for c in self.children]) + \
            ''.join([str(s) for s in self.statements])

    def _sub_add_union(self, other, op):
        if type(other)==str:
            return ' '.join([self.name, op, other])
        if hasattr(other, 'isshape') and other.isshape:
            return ' '.join([self.name, op, other.name])

        print >>sys.stderr, 'Shape +/-/union  a string or a Shape, but not a ', type(other)
        sys.exit(2)
    def __sub__(self, other): return self._sub_add_union(other, '-')
    def __add__(self, other): return self._sub_add_union(other, '+')
    def __mul__ (self, other):  return self._sub_add_union(other, 'u')
    def union (self, other):  return self._sub_add_union(other, 'u')

    def _combo_region(self, command, cr):
        ## Do combinatin or region
        if hasattr(self, 'hasgrc'):
            print >>sys.stderr, self.name, 'already has a region/combination/group!'
            sys.exit(2)
        self.statements.append(Kill(self.name))
        self.statements.append(Statement(cr, (self.name, command)))
        self.hasgrc = 1
        return self.name

    def region(self, command):
        '''Add a region statement to this Shape.'''
        return self._combo_region(command, 'r')
            
    def combination(self, command):
        '''Add a combination statement to this Shape.'''
        return self._combo_region(command, 'c')

    def group(self):
        '''Take all the Shapes that comprise this item, and make a group of
        self.name.  Append the group statement to self.

        If kwargs['group']==True, this will be done as part of __init__'''

        if hasattr(self, 'hasgrc'):
            print >>sys.stderr, self.name, 'already has a region/combination/group!'
            sys.exit(2)

        self.statements.append(Kill(self.name))

        args = [self.name]
        for c in self.children:
            if hasattr(c, 'isshape'):
                args.append(c.name)

        if len(args) < 2:
            print >>sys.stderr, self.name, 'needs more items to group'
            sys.exit(2)

        self.statements.append(Statement('g', args))
        self.hasgrc = 1
        return self.name

    def guess_vertex(self):
        '''If vertex doesn't exist, adopt vertex of first shape in children.

        If this doesn't find the right vertex, you'll have to set it
        manually *before* you call init.  Otherwise, init will
        complain about lack of a vertex and halt.'''

        if not hasattr(self, 'vertex'):
            for c in self.children:
                if hasattr(c, 'vertex'):
                    self.vertex = c.vertex
                    return self.vertex

    def rotate(self, rotation, vertex=None):
        if vertex == None:
            vertex = self.vertex

        for c in self.children:
            if hasattr(c, 'rotate'):
                c.rotate(rotation, vertex)

    def translate(self, translate, vertex=None, **kwargs):
        '''translate is a tuple containing the amount to move along each axis.
        vertex is the point from which we move (defaults to
        self.vertex).  All other Shapes and Shapes that make up this
        Shape are moved relative to the vertex.

        If __init__ is called with kwarg translate=(x,y,z), this will
        be run during init.

        If keyword absolute=True is present, the shape will be moved
        relative to the origin.'''

        if vertex == None:
            vertex = self.vertex

        for c in self.children:
            if hasattr(c, 'rotate'):
                c.translate(translate, vertex, **kwargs)

######################
## Implement some simplistic commands
from string import Template
commands = {
'Comment':"##", 
'Exit':'exit',
'Kill':'kill',
'Killall':'killall', 
'Killtree': 'killtree',
'Quit':'quit',
'Source':'source',
}
for c in commands:
    exec Template('''class $command(Statement):
    def __init__(self, arg=''):
        Statement.__init__(self, '$brl', arg)''').substitute(command = c, brl = commands[c])

class Sed(Statement):
    ## Enter editing mode
    pass

class Title(Statement):
    ## TODO: escape quotes
    def __init__(self, title, args=[]):
        Statement.__init__(self,"title", title)

class Units(Statement):
    def __init__(self, units):
        good_units = ['mm', 'millimeter', 'cm', 'centimeter', 'm', 'meter', 'in',
                      'inch', 'ft', 'foot', 'feet', 'um', 'angstrom',
                      'decinanometer', 'nanometer', 'nm', 'micron', 'micrometer', 
                      'km', 'kilometer', 'cubit', 'yd', 'yard', 'rd', 'rod', 'mi',
                      'mile']
        if not units in good_units:
            sys.stdout.write('Unknown units!  Ignoring units statement.  Defaulting to mm.\n')
            units = 'mm'
        Statement.__init__(self,"units", units)

class Script():
    '''A script is just a list of statements to send to mged.
    TODO: Maybe this class should derive from list?'''

    def __init__(self, *statements):
        self.statements = list(statements)
    def __str__(self):
        return ''.join(['%s' % (s) for s in self.statements])

    def append(self, *statements):
        for i in statements:
            self.statements.append(i)
        return self

class Group(Shape):
    '''For convenience, this will probably look cleaner than group=True.
    OTOH, there's no equivalent for region or combination, so it's not as
    elegant.'''

    def __init__(self, args=[], **kwargs):
        if 'group' in kwargs:
            del kwargs['group']

        Shape.__init__(self, args, **kwargs)
        self.group()

from primitive import *
