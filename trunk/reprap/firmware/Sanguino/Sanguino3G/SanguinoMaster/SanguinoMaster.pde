// Yep, this is actually -*- c++ -*-
/***************************************************************************************
 *  Sanguino 3rd Generation Firmware (S3G)
 *
 *  Specification for this protocol is located at: 
 *    http://docs.google.com/Doc?id=dd5prwmp_14ggw37mfp
 *  
 *  License: GPLv2
 *  Authors: Marius Kintel, Adam Mayer, and Zach Hoeken
 *
 *  Version History:
 *
 *  0001: Initial release of the protocol and firmware.
 *
 ***************************************************************************************/

//include some basic libraries.
#include <WProgram.h>
#include <SimplePacket.h>

#include "Configuration.h"
#include "Datatypes.h"
#include "CircularBuffer.h"
#include "RS485.h"
#include "Variables.h"
#include "Commands.h"
#ifdef USE_SD_CARD
#include <RepRapSDCard.h>
#endif

//this is our firmware version
#define FIRMWARE_VERSION 0001

//set up our firmware for actual usage.
void setup()
{
  //setup our firmware to a default state.
  init_serial();
  initialize();

  //this is a simple text string that identifies us.
  Serial.print("R3G Master v");
  Serial.println(FIRMWARE_VERSION, DEC);
}

//this function takes us back to our default state.
void initialize()
{
  is_machine_paused = false;

  init_commands();
  init_steppers();
  init_tools();
}

//start our hardware serial drivers
void init_serial()
{
  pinMode(RX_ENABLE_PIN, OUTPUT);
  pinMode(TX_ENABLE_PIN, OUTPUT);
  digitalWrite(RX_ENABLE_PIN, LOW); //always listen.

  Serial.begin(HOST_SERIAL_SPEED);
  Serial1.begin(SLAVE_SERIAL_SPEED);
}

//handle various things we're required to do.
void loop()
{
  /*
  //if we've aborted, dont do anything.
   //if (!is_machine_aborted)
   //{
   //check for and handle any packets that come in.
   	if (Serial.available())
   		process_host_packets();
   
   //only handle our buffer if we're unpaused. 
   if (!is_machine_paused && !is_machine_aborted)
   handle_commands();
   //}
   */

  check_tool_version(1);
  set_motor1_pwm(1, 255);
  set_motor2_pwm(1, 255);
  toggle_motor1(1, true, true);
  toggle_motor2(1, true, true);
  delay(3000); 
  toggle_motor1(1, true, false);
  toggle_motor2(1, true, false);
  delay(3000); 
  toggle_motor1(1, false, true);
  toggle_motor2(1, false, true);
  delay(3000); 
  toggle_motor1(1, false, false);
  toggle_motor2(1, false, false);
  delay(3000); 
}

//handle the abortion of a print job
void abort_print()
{
  //yes, we're done here.
  is_machine_aborted = true;

  //TODO: turn off all of our tools.

  //turn off steppers too.
  disableTimer1Interrupt();
  disable_steppers();

  //initalize everything to the beginning
  initialize();
}
