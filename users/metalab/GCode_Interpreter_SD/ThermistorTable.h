#ifndef THERMISTORTABLE_H_
#define THERMISTORTABLE_H_

// Thermistor lookup table for RepRap Temperature Sensor Boards (http://make.rrrf.org/ts)
// Made with createTemperatureLookup.py (http://svn.reprap.org/trunk/reprap/firmware/Arduino/utilities/createTemperatureLookup.py)
// ./createTemperatureLookup.py --r0=100000 --t0=25 --r1=0 --r2=4700 --beta=4066 --max-adc=1023
// r0: 100000
// t0: 25
// r1: 0
// r2: 4700
// beta: 4066
// max adc: 1023
#if 0
#define NUMTEMPS 20
short temptable[NUMTEMPS][2] = {
   {1, 841},
   {54, 255},
   {107, 209},
   {160, 184},
   {213, 166},
   {266, 153},
   {319, 142},
   {372, 132},
   {425, 124},
   {478, 116},
   {531, 108},
   {584, 101},
   {637, 93},
   {690, 86},
   {743, 78},
   {796, 70},
   {849, 61},
   {902, 50},
   {955, 34},
   {1008, 3}
};
#endif

#if 0
#define NUMTEMPS 32
short temptable[NUMTEMPS][2] = {
   {210, -10},
   {224, 0},
   {238, 10},
   {252, 20},
   {266, 30},
   {281, 40},
   {296, 50},
   {310, 60},
   {325, 70},
   {339, 80},
   {354, 90},
   {368, 100},
   {383, 110},
   {397, 120},
   {411, 130},
   {425, 140},
   {439, 150},
   {452, 160},
   {465, 170},
   {478, 180},
   {491, 190},
   {503, 200},
   {516, 210},
   {528, 220},
   {539, 230},
   {551, 240},
   {562, 250},
   {573, 260},
   {583, 270},
   {593, 280},
   {602, 290},
   {610, 300},
};
#endif

#if 0
#define NUMTEMPS 32
short temptable[NUMTEMPS][2] = {
   {23, 300},
   {26, 290},
   {30, 280},
   {35, 270},
   {41, 260},
   {47, 250},
   {57, 240},
   {67, 230},
   {95, 220},
   {105, 210},
   {117, 200},
   {133, 190},
   {149, 180},
   {186, 170},
   {223, 160},
   {266, 150},
   {318, 140},
   {376, 130},
   {442, 120},
   {514, 110},
   {589, 100},
   {663, 90},
   {735, 80},
   {800, 70},
   {856, 60},
   {903, 50},
   {939, 40},
   {966, 30},
   {986, 20},
   {1000, 10},
   {1009, 0},
   {1015, -10},
};
#endif

#define NUMTEMPS 32
short temptable[NUMTEMPS][2] = {
   {100, 300},
   {114, 290},
   {129, 280},
   {147, 270},
   {168, 260},
   {191, 250},
   {224, 240},
   {256, 230},
   {334, 220},
   {361, 210},
   {388, 200},
   {423, 190},
   {457, 180},
   {525, 170},
   {582, 160},
   {640, 150},
   {697, 140},
   {751, 130},
   {801, 120},
   {846, 110},
   {885, 100},
   {918, 90},
   {945, 80},
   {966, 70},
   {983, 60},
   {995, 50},
   {1004, 40},
   {1011, 30},
   {1015, 20},
   {1018, 10},
   {1020, 0},
   {1021, -10}
};
#endif