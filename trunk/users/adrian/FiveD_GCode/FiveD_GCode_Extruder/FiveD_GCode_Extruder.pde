/*
 * 5D GCode Interpreter
 * Arduino code to load into the extruder controller
 * 
  * Adrian Bowyer 3 July 2009
 */
 
 /*
 ***NOTE***
 This program changes the frequency of Timer 0 so that PWM on pins H1E and H2E goes at
 a very high frequency (64kHz see: 
 http://tzechienchu.typepad.com/tc_chus_point/2009/05/changing-pwm-frequency-on-the-arduino-diecimila.html)
This will mess up timings in the delay() and similar functions; they will no longer work in
 milliseconds, but 64 times faster.
 */
  
#ifndef __AVR_ATmega168__
#error Oops!  Make sure you have 'Arduino Diecimila' selected from the boards menu.
#endif

#include <ctype.h>
#include <HardwareSerial.h>
#include "WProgram.h"
#include "configuration.h"
#include "extruder.h"
#include "intercom.h"



extruder ex;
intercom talker;
int loopBlink;

void setup() 
{
  pinMode(DEBUG_PIN, OUTPUT);
  loopBlink = 0;
  rs485Interface.begin(RS485_BAUD); 
} 

void loop() 
{ 
  //if(rs485Interface.available())
  //    rs485Interface.print(rs485Interface.read(), BYTE);
  //What should I do?  
  talker.getAndProcessCommand();
  talker.tick();
  
  // Keep me at the right temp etc. 
  ex.manage();
  loopBlink++;
  if(loopBlink & 0x4000)
   digitalWrite(DEBUG_PIN, 1);
  else
   digitalWrite(DEBUG_PIN, 0); 
} 
