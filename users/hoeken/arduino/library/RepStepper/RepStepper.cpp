
#include "RepStepper.h"

/*
 * two-wire constructor.
 * Sets which wires should control the motor.
 */
RepStepper::RepStepper(unsigned int number_of_steps, byte dir_pin, byte step_pin, byte enable_pin)
{
	//init our variables.
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
	this->setDirection(RS_FORWARD);
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
	digitalWrite(this->direction_pin, direction);
	delayMicroseconds(5); //make sure it stabilizes..
	this->direction = direction; //save our direction.
}

bool RepStepper::getDirection()
{
	return this->direction;
}

void RepStepper::enable()
{
	if (enable_pin != 255)
	{
		digitalWrite(enable_pin, HIGH);
		delayMicroseconds(5); //make sure it stabilizes
	}

	enabled = true;
}

void RepStepper::disable()
{
	if (enable_pin != 255)
	{
		digitalWrite(enable_pin, LOW);
		delayMicroseconds(5); //make sure it stabilizes
	}

	enabled = false;
}

bool RepStepper::isEnabled()
{
	return enabled;
}

//this sends a pulse to our stepper controller.
void RepStepper::pulse()
{
	digitalWrite(step_pin, HIGH);
	delayMicroseconds(5); //make sure it stabilizes... for opto isolated stepper drivers.
	digitalWrite(step_pin, LOW);
}
