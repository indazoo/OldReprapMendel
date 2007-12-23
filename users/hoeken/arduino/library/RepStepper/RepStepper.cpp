
#include "RepStepper.h"

/*
 * two-wire constructor.
 * Sets which wires should control the motor.
 */
RepStepper::RepStepper(unsigned int number_of_steps, byte dir_pin, byte step_pin, byte enable_pin)
{
	//init our variables.
	this->direction = 1;
	this->setSpeed(0);

	//get our parameters
	this->number_of_steps = number_of_steps;
	this->step_pin = step_pin;
	this->direction_pin = dir_pin;
	this->enable_pin = enable_pin;
	
	// setup the pins on the microcontroller:
	pinMode(this->step_pin, OUTPUT);
	pinMode(this->direction_pin, OUTPUT);
	this->enable();
}

/*
  Sets the speed in ticks per step
*/
void RepStepper::setSpeed(unsigned long speed)
{
	step_delay = speed;
	
	if (step_delay > 0)
		rpm = 960000000UL / (step_delay * number_of_steps);
	else
		rpm = 0;
}

/*
  Gets the speed in ticks per step
*/
unsigned long RepStepper::getSpeed()
{
	return step_delay;
}

/*
  Sets the speed in revs per minute
*/
void RepStepper::setRPM(unsigned int new_rpm)
{
	if (new_rpm == 0)
	{
		step_delay = 0;
		rpm = 0;
	}
	else
	{
		rpm = new_rpm;
		
		//lets use the highest precision possible... processor ticks.
		// 16MHZ = 16,000,000 ticks/sec * 60 seconds in a minute = 960,000,000 ticks / minute
		// take the total # of ticks / steps per rev / number of revolutions per minute = ticks per step
		step_delay = (960000000UL / number_of_steps) / rpm;
	}
}

unsigned int RepStepper::getRPM()
{
	return rpm;
}

void RepStepper::setSteps(unsigned int steps)
{
	number_of_steps = steps;
	
	//recalculate our speed.
	this->setRPM(this->getRPM());
}

unsigned int RepStepper::getSteps()
{
	return number_of_steps;
}

void RepStepper::setDirection(bool direction)
{
	this->direction = direction;
	digitalWrite(this->direction_pin, this->direction);
}

bool RepStepper::getDirection()
{
	return direction;
}

void RepStepper::enable()
{
	if (enable_pin != 255)
	{
		enabled = true;
		digitalWrite(enable_pin, HIGH);
	}
}

void RepStepper::disable()
{
	if (enable_pin != 255)
	{
		enabled = false;
		digitalWrite(enable_pin, LOW);
	}
}

bool RepStepper::isEnabled()
{
	if (enable_pin != 255)
		return enabled;
	else
		return true;
}

void RepStepper::pulse()
{
	//this sends a pulse to our stepper controller.
	digitalWrite(step_pin, HIGH);
	delayMicroseconds(1);
	digitalWrite(step_pin, LOW);
}
