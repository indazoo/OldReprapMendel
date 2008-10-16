/****************************************************************************************
* Sanguino digital i/o pin assignment
*
****************************************************************************************/

//cartesian bot pins
#define X_STEP_PIN 15
#define X_DIR_PIN 18
#define X_MIN_PIN 20
#define X_MAX_PIN 21
#define X_ENABLE_PIN 19

#define Y_STEP_PIN 22
#define Y_DIR_PIN 23
#define Y_MIN_PIN 25
#define Y_MAX_PIN 26
#define Y_ENABLE_PIN 19

#define Z_STEP_PIN 29
#define Z_DIR_PIN 30
#define Z_MIN_PIN 1
#define Z_MAX_PIN 2
#define Z_ENABLE_PIN 31

//extruder pins
#define EXTRUDER_0_MOTOR_SPEED_PIN   12
#define EXTRUDER_0_MOTOR_DIR_PIN     16
#define EXTRUDER_0_HEATER_PIN        14
#define EXTRUDER_0_FAN_PIN           3
#define EXTRUDER_0_THERMISTOR_PIN    -1  //a -1 disables thermistor readings
#define EXTRUDER_0_THERMOCOUPLE_PIN  4   //a -1 disables thermocouple readings
#define EXTRUDER_0_VALVE_DIR_PIN     17
#define EXTRUDER_0_VALVE_ENABLE_PIN  13  // Valve needs to be redesigned not to need this

/*
#define EXTRUDER_1_MOTOR_SPEED_PIN   99
#define EXTRUDER_1_MOTOR_DIR_PIN     99
#define EXTRUDER_1_HEATER_PIN        99
#define EXTRUDER_1_FAN_PIN           99
#define EXTRUDER_1_THERMISTOR_PIN    99  //a -1 disables thermistor readings
#define EXTRUDER_1_THERMOCOUPLE_PIN  99 //a -1 disables thermocouple readings
#define EXTRUDER_1_VALVE_DIR_PIN     99
#define EXTRUDER_1_VALVE_ENABLE_PIN  99  
*/
