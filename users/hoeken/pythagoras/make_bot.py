#!/usr/bin/python
#
# Creates a gcode file and list of rod lengths to build an auto-assembling frame based on various parameters.
#
"""Make a Bot

Creates a gcode file and list of rod lengths to build an auto-assembling frame based on various parameters.

Usage: python make_bot.py [options]

Options:
  -h, --help				    show this help
  --x=... 					    the desired maximum outside X width of your machine. default = 330mm.
  --y=... 					    the desired maximum outside Y width of your machine. default = 330mm.
  --z=...					      the desired maximum outside Z height of your machine. default = 330mm.
  --feedrate=...		  	the desired feedrate for threading nuts (in mm/minute) default = 300mm/min.
  --nut-height=...			the height of the nut in mm. default = 6.5mm (M8 nut)
  --washer-height=... 	the height of the washer in mm. default = 1.6 (M8 washer)
  --block-size=...			the width of the block you're using. default = 19.05mm
  --rod-size=...        the size of the rod you're using.  default = 8mm
  --use-thread-locker		do you want to use a thread locking compound?  default = no
  --use-nut-starter			do you want to use an automatic nut starting device?  default = no
  --no-washers         do you want to use washers?  default = yes
"""

#global variables
x = 330.0
y = 330.0
z = 330.0
feedrate = 300.0
nutHeight = 6.5
washerHeight = 1.6
blockSize = 19.05
rodSize = 8.0
useThreadLocker = False
useNutStarter = False
useWashers = True

from math import *
import sys
import getopt

class CartesianFrame:
	"Class to hold the rod lengths"
	def __init__(self, x, y, z):

		#save our sizes
		self.x = x; # x size
		self.y = y; # y size    
		self.z = z; # z size
		
		#how long are our diagonals?
		self.xy = round(sqrt(x*x + y*y), 2);
		self.xz = round(sqrt(x*x + z*z), 2);
		self.yz = round(sqrt(y*y + z*z), 2);

	def getXY(self):
		"Get XY diagonal length"
		return self.xy

	def getXZ(self):
		"Get XY diagonal length"
		return self.xz

	def getYZ(self):
		"Get YZ diagonal length"
		return self.yz
		
	def getVolume(self):
		"Get the volume of the machine in cubit meters"
		return round((self.x / 1000) * (self.y/1000) * (self.z/1000), 2);

def main(argv):

  global x, y, z, feedrate, nutHeight, washerHeight, rodSize, blockSize, useThreadLocker, useNutStarter, useWashers

  try:
    opts, args = getopt.getopt(argv, "h", ["help", "x=", "y=", "z=", "feedrate=", "nut-height=", "washer-height=", "rod-size=", "block-size=", "use-thread-locker", "use-nut-starter", "no-washers"])
  except getopt.GetoptError:
    usage()
    sys.exit(2)

  for opt, arg in opts:
    if opt in ("-h", "--help"):
      usage()
      sys.exit()
    elif opt == "--x":
      x = float(arg)
    elif opt == "--y":
      y = float(arg)
    elif opt == "--z":
      z = float(arg)
    elif opt == "--feedrate":
      feedrate = float(arg)
    elif opt == "--nut-height":
      nutHeight = float(arg)
    elif opt == "--washer-height":
      washerHeight = float(arg)
    elif opt == "--block-size":
      blockSize = float(arg)
    elif opt == "--rod-size":
      rodSize = float(arg)
    elif opt == "--use-thread-locker":
      useThreadLocker = True
    elif opt == "--use-nut-starter":
      useNutStarter = True
    elif opt == "--no-washers":
      useWashers = False
    else:
      print "(Huh? %s:%s)" % (opt,arg)

  bot = CartesianFrame(x, y, z)

  xRods = 4
  yRods = 4
  zRods = 4
  xyRods = 2
  xzRods = 4
  yzRods = 4
  totalRods = xRods + yRods + zRods + xyRods + xzRods + yzRods

  nutsPerKebab = 4
  totalNuts = totalRods * nutsPerKebab

  if useWashers:
    washersPerKebab = 4
    totalWashers = totalRods * washersPerKebab
  else:
    washersPerKebab = 0
    totalWashers = 0

  print "(Generated by make_bot.py)"
  print "(Required Rod Lengths:)"
  print "( X Rods: 4 * %06.2fmm)" % (x)
  print "( Y Rods: 4 * %06.2fmm)" % (y)
  print "( Z Rods: 4 * %06.2fmm)" % (z)
  print "(XZ Rods: 4 * %06.2fmm)" % (bot.getXZ())
  print "(YZ Rods: 4 * %06.2fmm)" % (bot.getYZ())
  print "(XY Rods: 2 * %06.2fmm)" % (bot.getXY())
  print "(Total Volume: %06.2fm^3)" % (bot.getVolume())
  print "(Total kebabs: %d)" % (totalRods)
  print "(Total nuts required: %d)" % (totalNuts)
  print "(Total washers required: %d)" % (totalWashers)
  #TODO: print the total number of whole rods required.
  print "(GCODE STARTS BELOW)"
  print "G90 (Absolute Mode)"
  print "G21 (Metric Units)"

  print "M00 (Starting X kebabs)"
  for i in range(0, xRods):
    build_frame_kebab(x)

  print "M00 (Starting Y kebabs)"
  for i in range(0, yRods):
    build_frame_kebab(y)

  print "M00 (Starting Z kebabs)"
  for i in range(0, zRods):
    build_z_kebab(z)

  print "M00 (Starting XY kebabs)"
  for i in range(0, xyRods):
    build_diagonal_kebab(bot.getXY())

  print "M00 (Starting XZ kebabs)"
  for i in range(0, xzRods):
    build_diagonal_kebab(bot.getXZ())

  print "M00 (Starting YZ kebabs)"
  for i in range(0, yzRods):
    build_diagonal_kebab(bot.getYZ())


def build_frame_kebab(length):
  "Function to output the GCode to build a frame kebab of a certain length."

  #user prompt for raw materials
  if useWashers:
    print "M00 (Grab a %06.2fmm rod, 4 nuts, 4 washers, and 2 frame brackets.  Thread it into the nut winder.)" % (length)
  else:
    print "M00 (Grab a %06.2fmm rod, 4 nuts, and 2 frame brackets.  Thread it into the nut winder.)" % (length)

  #the first nut on the rod.
  nutPosition = length - nutHeight - nutHeight
  if useWashers:
    nutPosition = nutPosition - washerHeight - rodSize - blockSize - blockSize + washerHeight + nutHeight
  else:
    nutPosition = nutPosition - rodSize - blockSize - blockSize + nutHeight
  thread_nut(nutPosition)

  #prompt the user for assembly
  if useWashers:
    print "M00 (Slide on a washer / frame bracket / washer sandwich)"
  else:
    print "M00 (Slide on a frame bracket)"

  #the second nut on the rod
  if useWashers:
    nutPosition = nutPosition - nutHeight - washerHeight - blockSize - washerHeight
  else:
    nutPosition = nutPosition - nutHeight - blockSize
  thread_nut(nutPosition)
  print "M00 (Tighten them together by hand.)"

  #the 3rd nut on the rod
  if useWashers:
    nutPosition = washerHeight + rodSize + blockSize + blockSize + blockSize + washerHeight + nutHeight
  else:
    nutPosition = rodSize + blockSize + blockSize + blockSize + nutHeight
  thread_nut(nutPosition)

  #prompt the user for assembly
  if useWashers:
    print "M00 (Slide on a washer / frame bracket / washer sandwich)"
  else:
    print "M00 (Slide on a frame bracket)"

  #the 4th nut on the rod
  if useWashers:
    nutPosition = nutPosition - nutHeight - washerHeight - blockSize - washerHeight
  else:
    nutPosition = nutPosition - nutHeight - blockSize
  thread_nut(nutPosition)

  #how far should the blocks be spaced?
  if useWashers:
    blockDistanceFar = length - nutHeight - washerHeight - rodSize - blockSize - blockSize
    blockDistanceNear = nutHeight + washerHeight + rodSize + blockSize + blockSize
  else:
    blockDistanceFar = length - nutHeight - rodSize - blockSize - blockSize
    blockDistanceNear = nutHeight + rodSize + blockSize + blockSize

  #have them check it.
  totalDistance = blockDistanceFar - blockDistanceNear
  print "M00 (Double check the distance between the outside edges of the blocks.  It should be: %06.2f.  Hand tighten the nuts.)" % (totalDistance)
  
  #okay, remove the rod
  print "M00 (Firmly grasp the rod.  We're going to remove it from the winder.)"
  print "G1 Z%06.2f F%06.2f" % (-nutHeight * 1.5, feedrate * 0.5)
  print "G92 Z0"
  
def build_z_kebab(length):
  "Function to output the GCode to build a Z kebab of a certain length."

  #user prompt for raw materials
  print "M00 (Grab a %06.2fmm rod and 4 nuts)" % (length)

  #the first/top. nut on the rod.
  nutPosition = length - nutHeight - 50 - blockSize - blockSize
  if useWashers:
    nutPosition = nutPosition - washerHeight
  thread_nut(nutPosition)
  
  #the second nut on the rod
  nutPosition -= nutHeight
  thread_nut(nutPosition)
  
  #instructions
  print "M00 (Tighten the nuts against each other by hand.  Wrench tighten them later.)"

  #the third nut on the rod
  if useWashers:
    nutPosition = washerHeight + blockSize + rodSize + blockSize + blockSize + washerHeight + nutHeight + nutHeight
  else:
    nutPosition = blockSize + rodSize + blockSize + blockSize + nutHeight + nutHeight
  thread_nut(nutPosition)
  
  #the fourth nut on the rod
  nutPosition -= nutHeight
  thread_nut(nutPosition)
  
  #instructions
  print "M00 (Tighten the nuts against each other by hand.  Wrench tighten them later.)"
    
  #okay, remove the rod
  print "M00 (Firmly grasp the rod.  We're going to remove it from the winder.)"
  print "G1 Z%06.2f F%06.2f" % (-nutHeight * 1.5, feedrate * 0.5)
  print "G92 Z0"

def build_diagonal_kebab(length):
  "Function to output the GCode to build a diagonal kebab of a certain length."

  print "(TODO: make diagonal rod)"	

def thread_nut(position):
  "Thread the front of a nut to a position on the rod"
  print "M00 (Thread a nut on the rod)"

  #do we wanna use our nut starting device?
  if useNutStarter:
   print "G1 Z10 F%06.2f" % (feedrate)

  #zero us out.
  print "G92 Z0"

  #do we wanna use thread locking compound?
  if useThreadLocker:
    print "G1 Z%06.2f F%06.2f" % (position-nutHeight, feedrate)
    print "M00 (Apply thread locker just in front of the nut.)"

  print "G1 Z%06.2f F%06.2f" % (position, feedrate)

def usage():
  print __doc__

if __name__ == "__main__":
  main(sys.argv[1:])
