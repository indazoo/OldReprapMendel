/*
  LinearAxis.h - RepRap Linear Axis library for Arduino - Version 0.1

  History:
  * Created library (0.1) by Zach Smith.

  The interface for controlling a linear axis: stepper motor + min/max sensors + optional encoder
*/

// ensure this library description is only included once
#ifndef LinearAxis_h
#define LinearAxis_h

#include <LimitSwitch.h>
#include <RepStepper.h>

// library interface description
class LinearAxis {
  public:
    
	// constructors:
    LinearAxis(int steps, int dir_pin, int step_pin, int min_pin, int max_pin);

	//these are our other object variables.
	RepStepper stepper;
//	AnalogEncoder encoder;

	//various guys to interface with class
	void readState();
	bool canStep();
	void doStep();

	//our DDA based functions
	void initDDA(long max_delta);
	void ddaStep(long max_delta);
	long getDelta();
	
	//various position things.
	long getPosition();
	void setPosition(long position);
	long getTarget();
	void setTarget(long t);
	bool atTarget();
	long getCounter();
	
	//our limit switch functions
	bool atMin();
	bool atMax();

  private:
	bool can_step;				//are we capable of taking a step yet?
	bool dda_ready;				//are we allowed to take a step yet?
	long current;				//this is our current position.
	long target;				//this is our target position.
	long counter;				//this is our 'counter' for dda operations.	
	long delta;					//this is our change for DDA.

	LimitSwitch min_switch;
	LimitSwitch max_switch;
};

#endif
