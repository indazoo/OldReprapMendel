EESchema Schematic File Version 1
LIBS:power,//.PSF/RepRap SVN/trunk/reprap/electronics/RepRap_kicad_library/contrib,//.PSF/RepRap SVN/trunk/reprap/electronics/RepRap_kicad_library/reprap,device,conn,linear,regul,74xx,cmos4000,adc-dac,memory,xilinx,special,microcontrollers,microchip,analog_switches,motorola,intel,audio,interface,digital-audio,philips,display,cypress,siliconi,contrib,.\comms_and_power_distribution.cache
EELAYER 23  0
EELAYER END
$Descr A4 11700 8267
Sheet 1 1
Title ""
Date "5 may 2007"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
Kmarq B 2150 4250 "Warning Pin input Unconnected" F=1
Kmarq B 2150 4450 "Warning Pin output Unconnected" F=1
Kmarq B 3750 4250 "Warning Pin output Unconnected" F=1
Kmarq B 3750 4450 "Warning Pin input Unconnected" F=1
Kmarq B 4500 3950 "Warning Pin passive Unconnected" F=1
Kmarq B 6350 4150 "Warning Pin power_in not driven (Net 17)" F=1
Kmarq B 2500 1350 "Warning Pin power_in Unconnected" F=1
Kmarq B 2900 950  "Warning Pin power_in not driven (Net 15)" F=1
Connection ~ 2700 1500
Wire Wire Line
	2700 1650 2700 1150
Wire Wire Line
	2900 1100 2900 950 
Wire Wire Line
	2700 1150 2500 1150
Connection ~ 6300 4150
Wire Wire Line
	6300 4150 6300 4200
Wire Wire Line
	6300 4200 6350 4200
Connection ~ 7050 4250
Wire Wire Line
	7050 3850 7050 4250
Wire Wire Line
	6750 3850 6650 3850
Wire Wire Line
	6550 4150 6450 4150
Wire Wire Line
	6550 4150 6550 3850
Connection ~ 6350 3850
Wire Wire Line
	6350 4200 6350 4150
Wire Wire Line
	6550 3850 6050 3850
Connection ~ 6150 3850
Wire Wire Line
	6150 3850 6150 4150
Wire Wire Line
	3850 1100 4050 1100
Wire Wire Line
	2700 1500 4050 1500
Connection ~ 2900 1500
Wire Wire Line
	3450 1400 3450 1500
Connection ~ 3450 1500
Wire Wire Line
	4050 1100 4050 950 
Wire Wire Line
	3900 3450 3750 3450
Wire Wire Line
	3750 3950 4050 3950
Wire Wire Line
	3750 3650 3900 3650
Wire Wire Line
	3900 3650 3900 3550
Wire Wire Line
	2050 3550 2150 3550
Wire Wire Line
	2050 3950 2150 3950
Wire Wire Line
	1650 4350 2150 4350
Wire Wire Line
	4500 4150 3750 4150
Wire Wire Line
	4500 4350 3750 4350
Wire Wire Line
	4500 4050 4350 4050
Wire Wire Line
	4350 4050 4350 4550
Wire Wire Line
	4350 4550 4500 4550
Wire Wire Line
	4500 4250 4400 4250
Wire Wire Line
	4400 4250 4400 4450
Wire Wire Line
	4400 4450 4500 4450
Wire Wire Line
	4400 3700 4400 3550
Wire Wire Line
	4400 3550 3900 3550
Connection ~ 4050 3550
Wire Wire Line
	1650 4050 1650 4200
Wire Wire Line
	1650 4550 1650 4700
Wire Wire Line
	4500 4650 4500 4950
Connection ~ 4500 4750
Wire Wire Line
	2150 4150 1850 4150
Wire Wire Line
	1850 4150 1850 3850
Wire Wire Line
	1850 3850 1650 3850
Wire Wire Line
	3750 2950 3750 3050
Wire Wire Line
	3750 3050 3900 3050
Wire Wire Line
	2150 3050 2050 3050
Wire Wire Line
	2150 3450 2050 3450
Wire Wire Line
	5000 2000 5000 2100
Wire Wire Line
	5000 2600 5000 2650
Connection ~ 6350 4150
Wire Wire Line
	6250 3850 6250 4150
Wire Wire Line
	6250 4150 6150 4150
Connection ~ 6250 3850
Wire Wire Line
	6450 4150 6450 3850
Connection ~ 6450 4150
Connection ~ 6450 3850
Wire Wire Line
	6850 3850 6950 3850
Wire Wire Line
	6950 3850 6950 4250
Wire Wire Line
	7150 3850 7150 4250
Wire Wire Line
	6050 3850 6050 4150
Wire Wire Line
	6050 4150 6350 4150
Wire Wire Line
	6650 3850 6650 4250
Wire Wire Line
	6650 4250 7150 4250
Connection ~ 6950 4250
Wire Wire Line
	5000 3050 5000 3200
Wire Wire Line
	2700 1250 2500 1250
Connection ~ 2700 1250
Wire Wire Line
	2900 1100 3050 1100
Wire Wire Line
	2500 1050 2750 1050
Wire Wire Line
	2750 1050 2750 950 
Wire Wire Line
	2750 950  2900 950 
$Comp
L +12V #PWR01
U 1 1 463A9FF1
P 2900 950
F 0 "#PWR01" H 2900 900 20  0001 C C
F 1 "+12V" H 2900 1050 30  0000 C C
	1    2900 950 
	1    0    0    -1  
$EndComp
$Comp
L MOLEX_4PIN M02
U 1 1 463A9D69
P 1900 1200
F 0 "M02" H 1950 950 60  0000 C C
F 1 "MOLEX_4PIN" H 2200 1500 60  0000 C C
	1    1900 1200
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR03
U 1 1 46319B6C
P 6350 4150
F 0 "#PWR03" H 6350 4150 30  0001 C C
F 1 "GND" H 6350 4080 30  0001 C C
	1    6350 4150
	1    0    0    -1  
$EndComp
$Comp
L +12V #PWR04
U 1 1 46319B62
P 6950 4250
F 0 "#PWR04" H 6950 4200 20  0001 C C
F 1 "+12V" H 6950 4350 30  0000 C C
	1    6950 4250
	1    0    0    -1  
$EndComp
$Comp
L AMP P05
U 1 1 463198A7
P 6600 3900
F 0 "P05" H 6600 3900 60  0000 C C
F 1 "AMP" H 6600 3900 60  0000 C C
	1    6600 3900
	1    0    0    -1  
$EndComp
$Comp
L +12V #PWR06
U 1 1 45A40DAB
P 5000 2000
F 0 "#PWR06" H 5000 1950 20  0001 C C
F 1 "+12V" H 5000 2100 30  0000 C C
	1    5000 2000
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR07
U 1 1 45A40DA1
P 5000 3200
F 0 "#PWR07" H 5000 3200 30  0001 C C
F 1 "GND" H 5000 3130 30  0001 C C
	1    5000 3200
	1    0    0    -1  
$EndComp
$Comp
L LED D1
U 1 1 45A40D97
P 5000 2850
F 0 "D1" H 5000 2950 50  0000 C C
F 1 "LED" H 5000 2750 50  0000 C C
	1    5000 2850
	0    1    1    0   
$EndComp
$Comp
L R R1
U 1 1 45A40D8A
P 5000 2350
F 0 "R1" V 5080 2350 50  0000 C C
F 1 "560R" V 5000 2350 50  0000 C C
	1    5000 2350
	1    0    0    -1  
$EndComp
$Comp
L CP C5
U 1 1 45A40CF5
P 2050 3250
F 0 "C5" H 2100 3350 50  0000 L C
F 1 "1uF" H 2100 3150 50  0000 L C
	1    2050 3250
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR08
U 1 1 45A40C07
P 4400 3700
F 0 "#PWR08" H 4400 3700 30  0001 C C
F 1 "GND" H 4400 3630 30  0001 C C
	1    4400 3700
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR09
U 1 1 45A40C01
P 1650 4700
F 0 "#PWR09" H 1650 4700 30  0001 C C
F 1 "GND" H 1650 4630 30  0001 C C
	1    1650 4700
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR010
U 1 1 45A40BFC
P 1650 4200
F 0 "#PWR010" H 1650 4200 30  0001 C C
F 1 "GND" H 1650 4130 30  0001 C C
	1    1650 4200
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR011
U 1 1 45A40BF0
P 4500 4950
F 0 "#PWR011" H 4500 4950 30  0001 C C
F 1 "GND" H 4500 4880 30  0001 C C
	1    4500 4950
	1    0    0    -1  
$EndComp
$Comp
L CONN_2 P3
U 1 1 45A40B82
P 1300 3950
F 0 "P3" V 1250 3950 40  0000 C C
F 1 "CONN_2" V 1350 3950 40  0000 C C
	1    1300 3950
	-1   0    0    1   
$EndComp
$Comp
L CONN_2 P2
U 1 1 45A40B73
P 1300 4450
F 0 "P2" V 1250 4450 40  0000 C C
F 1 "CONN_2" V 1350 4450 40  0000 C C
	1    1300 4450
	-1   0    0    1   
$EndComp
$Comp
L DB9 J1
U 1 1 45A40B59
P 4950 4350
F 0 "J1" H 4950 4900 70  0000 C C
F 1 "DB9" H 4950 3800 70  0000 C C
	1    4950 4350
	1    0    0    1   
$EndComp
$Comp
L +5V #PWR012
U 1 1 45A40B48
P 3750 2950
F 0 "#PWR012" H 3750 3040 20  0001 C C
F 1 "+5V" H 3750 3040 30  0000 C C
	1    3750 2950
	1    0    0    -1  
$EndComp
$Comp
L CP C4
U 1 1 45A40B38
P 4050 3750
F 0 "C4" H 4100 3850 50  0000 L C
F 1 "1uF" H 4100 3650 50  0000 L C
	1    4050 3750
	1    0    0    -1  
$EndComp
$Comp
L CP C3
U 1 1 45A40B2E
P 3900 3250
F 0 "C3" H 3950 3350 50  0000 L C
F 1 "1uF" H 3950 3150 50  0000 L C
	1    3900 3250
	-1   0    0    1   
$EndComp
$Comp
L CP C2
U 1 1 45A40B29
P 2050 3750
F 0 "C2" H 2100 3850 50  0000 L C
F 1 "1uF" H 2100 3650 50  0000 L C
	1    2050 3750
	1    0    0    -1  
$EndComp
$Comp
L MAX232 U2
U 1 1 45A40B1C
P 2950 3750
F 0 "U2" H 2950 4600 70  0000 C C
F 1 "MAX232" H 2950 2900 70  0000 C C
	1    2950 3750
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR013
U 1 1 45A40A81
P 2700 1650
F 0 "#PWR013" H 2700 1650 30  0001 C C
F 1 "GND" H 2700 1580 30  0001 C C
	1    2700 1650
	1    0    0    -1  
$EndComp
$Comp
L +5V #PWR014
U 1 1 45A40A6C
P 4050 950
F 0 "#PWR014" H 4050 1040 20  0001 C C
F 1 "+5V" H 4050 1040 30  0000 C C
	1    4050 950 
	1    0    0    -1  
$EndComp
$Comp
L CP C1
U 1 1 45A40A1C
P 4050 1300
F 0 "C1" H 4100 1400 50  0000 L C
F 1 "100uF" H 4100 1200 50  0000 L C
	1    4050 1300
	1    0    0    -1  
$EndComp
$Comp
L CP C6
U 1 1 45A40A15
P 2900 1300
F 0 "C6" H 2950 1400 50  0000 L C
F 1 "4700uF" H 2950 1200 50  0000 L C
	1    2900 1300
	1    0    0    -1  
$EndComp
$Comp
L 78L05 U1
U 1 1 45A409E1
P 3450 1150
F 0 "U1" H 3600 954 60  0000 C C
F 1 "78L05" H 3450 1350 60  0000 C C
	1    3450 1150
	1    0    0    -1  
$EndComp
Text Notes 4100 2650 0    60   ~
Power-on LED
Text Notes 1750 4850 0    60   ~
RS232 to TTL converter
Text Notes 2100 650  0    60   ~
Power in and voltage regulator
Text Notes 5850 4550 0    60   ~
Power output connectors
Text Notes 4500 5150 0    60   ~
RS232 socket
$EndSCHEMATC
