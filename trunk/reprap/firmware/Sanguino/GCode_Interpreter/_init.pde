
// define the parameters of our machine.
#define X_STEPS_PER_INCH 203.133
#define X_STEPS_PER_MM   7.99735
#define X_MOTOR_STEPS    400

#define Y_STEPS_PER_INCH 203.133
#define Y_STEPS_PER_MM   7.99735
#define Y_MOTOR_STEPS    400

#define Z_STEPS_PER_INCH 8128.0
#define Z_STEPS_PER_MM   320.0
#define Z_MOTOR_STEPS    400

//our maximum feedrates
#define FAST_XY_FEEDRATE 1600.0
#define FAST_Z_FEEDRATE  50.0

// Units in curve section
#define CURVE_SECTION_INCHES 0.019685
#define CURVE_SECTION_MM 0.5

// Set to one if sensor outputs inverting (ie: 1 means open, 0 means closed)
// RepRap opto endstops are *not* inverting.
#define SENSORS_INVERTING 0

// How many temperature samples to take.  each sample takes about 100 usecs.
#define TEMPERATURE_SAMPLES 5

/****************************************************************************************
* digital i/o pin assignment
*
* this uses the undocumented feature of Arduino - pins 14-19 correspond to analog 0-5
****************************************************************************************/

//cartesian bot pins
#define X_STEP_PIN 1
#define X_DIR_PIN 2
#define X_MIN_PIN 3
#define X_MAX_PIN 4
#define X_ENABLE_PIN 15

#define Y_STEP_PIN 26
#define Y_DIR_PIN 27
#define Y_MIN_PIN 28
#define Y_MAX_PIN 10
#define Y_ENABLE_PIN 15

#define Z_STEP_PIN 11
#define Z_DIR_PIN 24
#define Z_MIN_PIN 25
#define Z_MAX_PIN 18
#define Z_ENABLE_PIN 15

//extruder pins
#define EXTRUDER_MOTOR_SPEED_PIN   13
#define EXTRUDER_MOTOR_DIR_PIN     20
#define EXTRUDER_HEATER_PIN        12
#define EXTRUDER_FAN_PIN           19
#define EXTRUDER_THERMISTOR_PIN    -1  //a -1 disables thermistor readings
#define EXTRUDER_THERMOCOUPLE_PIN  0 //a -1 disables thermocouple readings
#define VALVE_DIR_PIN             21
#define VALVE_ENABLE_PIN          22  
