#include "WConstants.h"
#include "ThermoplastExtruder.h"

#define NUMTEMPS  22
short temptable[NUMTEMPS][2] = {
// { adc ,  temp }
   { 1 ,  608 } ,
   { 60 ,  176 } ,
   { 70 ,  166 } ,
   { 80 ,  157 } ,
   { 90 ,  150 } ,
   { 100 ,  143 } ,
   { 110 ,  137 } ,
   { 120 ,  131 } ,
   { 130 ,  125 } ,
   { 140 ,  120 } ,
   { 150 ,  115 } ,
   { 160 ,  110 } ,
   { 170 ,  105 } ,
   { 180 ,  100 } ,
   { 190 ,  95 } ,
   { 200 ,  91 } ,
   { 210 ,  86 } ,
   { 220 ,  81 } ,
   { 230 ,  75 } ,
   { 240 ,  70 } ,
   { 250 ,  64 } ,
   { 300 ,  4 }
};

/*!
  motor_pwm_pin and heater_pin must be PWM capable outputs.
  thermistor_pin must be an analog input.
  motor_dir_pin must be a digital output.
*/
ThermoplastExtruder::ThermoplastExtruder(byte motor_dir_pin, byte motor_pwm_pin, 
                                         byte heater_pin, byte thermistor_pin)
{
  this->motor_dir_pin = motor_dir_pin;
  this->motor_pwm_pin = motor_pwm_pin;
  this->heater_pin = heater_pin;
  this->thermistor_pin = thermistor_pin;

  pinMode(this->motor_dir_pin, OUTPUT);
  pinMode(this->motor_pwm_pin, OUTPUT);
  pinMode(this->heater_pin, OUTPUT);
	
  this->readTemp();
  this->setSpeed(0);
  this->setTargetTemp(0);
}

/*!
  Sets the motor speed from 0-255 (0 is off).
*/
void ThermoplastExtruder::setSpeed(byte speed)
{
  this->motor_pwm = speed;
  analogWrite(this->motor_pwm_pin, this->motor_pwm);
}

/*!
  Sets the motor direction (true = forward, false = backward)
*/
void ThermoplastExtruder::setDirection(bool dir)
{
  this->motor_dir = dir;
  digitalWrite(this->motor_dir_pin, this->motor_dir);
}

void ThermoplastExtruder::setTargetTemp(int target)
{
  this->target_celcius = target;
}

byte ThermoplastExtruder::getSpeed()
{
  return this->motor_pwm;
}

bool ThermoplastExtruder::getDirection()
{
  return this->motor_dir;
}

int ThermoplastExtruder::getTemp()
{
  return this->current_celcius;
}

int ThermoplastExtruder::getTargetTemp()
{
  return this->target_celcius;
}

/*!
  Samples the temperature and converts it to degrees Celcius.
  Returns degrees Celcius.
*/
int ThermoplastExtruder::readTemp()
{
  int rawtemp = analogRead(this->thermistor_pin);
  this->rawtmp = rawtemp;
  byte i;
  for (i=1;i<NUMTEMPS;i++) {
    if (temptable[i][0] > rawtemp) {
      this->current_celcius = temptable[i-1][1] +
        (rawtemp - temptable[i-1][0]) * (temptable[i][1] - temptable[i-1][1]) /
        (temptable[i][0] - temptable[i-1][0]);
      break;
    }
  }
  if (i == NUMTEMPS) {
    // Overflow: We just clamp to 0 degrees celcius
    this->current_celcius = 0;
  }
  return this->current_celcius;
}

/*!
  Manages motor and heater based on measured temperature:
  o If temp is too low, don't start the motor
  o Adjust the heater power to keep the temperature at the target
 */
void ThermoplastExtruder::manageTemp()
{
  // Stop the motor if temp is too low
  if (this->current_celcius < this->target_celcius) {
    analogWrite(this->motor_pwm_pin, 0);
  }
  // Start the motor again if temp is high enough
  else {
    analogWrite(this->motor_pwm_pin, this->motor_pwm);
  }
  
  // Adjust the heater power
  this->calculateHeaterPWM();
  analogWrite(this->heater_pin, this->heater_pwm);
}

/*!
 */
void ThermoplastExtruder::calculateHeaterPWM()
{
  // FIXME: This is as simple on/off scheme - make it adjust gradually?
  //lower values == hotter temps.
  if (this->current_celcius > this->target_celcius)
    this->heater_pwm = 255;
  else
    this->heater_pwm = 0;
}

/*!
  Raw temperature reading - just for debugging.
 */
int ThermoplastExtruder::getRaw()
{
  return this->rawtmp;
}
