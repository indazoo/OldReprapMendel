#ifndef HOSTCOM_H
#define HOSTCOM_H

#include "features.h"

/*
  Class to handle sending messages from and back to the host.
  NOWHERE ELSE in this program should anything send to Serial.print()
  or get anything from Serial.read().
  
  All communication is in printable ASCII characters.  Messages sent back
  to the host computer are terminated by a newline and look like this:
  
  xx [line number to resend] [T:93.2 B:22.9] [C: X:9.2 Y:125.4 Z:3.7 E:1902.5] [Some debugging or other information may be here]
  
  where xx can be one of:
  
  ok
  rs
  !!
  
  ok means that no error has been detected.
  rs means resend, and must be followed by the line number to resend.
  !! means that a hardware fault has been detected.  The RepRap machine will
       shut down immediately after it has sent this message.
       
  The T: and B: values are the temperature of the currently-selected extruder 
  and the bed respectively, and are only sent in response to a request using the
  appropriate M code.
  
  C: means that coordinates follow.  Those are the X: Y: etc values.  These are only 
  sent in response to a request using the appropriate M code.

  The most common response is simply:

  ok  
       
  When the machine boots up it sends the string
  
  start
  
  once to the host before sending anything else.  This should not be replaced or augmented
  by version numbers and the like.  M115 requests those.
       
 */

// Can't get lower than absolute zero...

#define NO_TEMP -300

extern void shutdown();

class hostcom
{
public:
  hostcom();
  char* string();
  void setETemp(int et);
  void setBTemp(int bt);
  void setCoords(const FloatPoint& where);
  void capabilities();
  void setResend(long ln);
  void setFatal();
  void sendMessage(bool doMessage);
  void start();
  
// Wrappers for the comms interface

  void putInit();
  void put(const char* s);
  void put(const float& f);
  void put(const long& l);
  void put(const int i);
  void put(double i);  //overloading!
  void put(); // to allow putting an undefined constant as "n/a"
  void putEnd();
  byte gotData();
  char get();
  
private:
  void reset();
  void sendtext(bool noText);
  char message[RESPONSE_SIZE];
  int etemp;
  int btemp;
  float x;
  float y;
  float z;
  float e;
  long resend;
  bool fatal;
  bool sendCoordinates;  
  bool sendCapabilities;
};

inline hostcom::hostcom()
{
  fatal = false;
  reset();
}

// Wrappers for the comms interface
#if DATA_SOURCE == DATA_SOURCE_USB_SERIAL
inline void hostcom::putInit() {  Serial.begin(HOST_BAUD); }
inline void hostcom::put(const char* s) { Serial.print(s); }
inline void hostcom::put(const float& f) { Serial.print(f); }
inline void hostcom::put(const long& l) { Serial.print(l); }
inline void hostcom::put(const int i) { Serial.print(i); }
inline void hostcom::put(double i) { Serial.print(i); }
inline void hostcom::put() { Serial.print("n/a"); }
inline void hostcom::putEnd() { Serial.println(); }
inline byte hostcom::gotData() { return Serial.available(); }
inline char hostcom::get() { return Serial.read(); }
#endif // DATA_SOURCE_USB_SERIAL

#if DATA_SOURCE == DATA_SOURCE_SDCARD
//TODO how to read data from a SD card using SPI? 
#error Oops! Reading from a SD Card is not yet implemented! 
#endif  //DATA_SOURCE_SDCARD

#if DATA_SOURCE == DATA_SOURCE_EPROM
//TODO how to read data from an EEPROM using I2C normally
#error Oops! Reading from an EPROM is not yet implemented! 
#endif  //DATA_SOURCE_EPROM


// called after each message has been sent

inline void hostcom::reset()
{
  etemp = NO_TEMP;
  btemp = NO_TEMP;
  message[0] = 0;
  resend = -1;
  sendCoordinates = false;
  sendCapabilities = false;
  // Don't reset fatal.
}

// Called once when the machine boots

inline void hostcom::start()
{
  putInit();
  put("start");
  putEnd();  
}

// Return the place to write messages into.  Typically this is used in lines like:
// sprintf(talkToHost.string(), "Echo: %s", cmdbuffer);

inline char* hostcom::string()
{
  return message;
}

// Set the extruder temperature to be returned.

inline void hostcom::setETemp(int et)
{
  etemp = et;
}

// Set the bed temperature to be returned

inline void hostcom::setBTemp(int bt)
{
  btemp = bt;
}

// Set the machine's coordinates to be returned

inline void hostcom::setCoords(const FloatPoint& where)
{
  x = where.x;
  y = where.y;
  z = where.z;
  e = where.e;
  sendCoordinates = true;
}

// tell the host what our key compile-time features are - see M115
inline void hostcom::capabilities()
{
  sendCapabilities = true;
}

// Request a resend of line ln

inline void hostcom::setResend(long ln)
{
  resend = ln;
}

// Flag that a fatal error has occurred (such as a temperature sensor failure).

inline void hostcom::setFatal()
{
  fatal = true;
}

// Send the text stored (if any) to the host.

inline void hostcom::sendtext(bool doMessage)
{
  if(!doMessage)
    return;
  if(!message[0])
    return;
  put(" ");
  put(message);
}

// Master function to return messages to the host

inline void hostcom::sendMessage(bool doMessage)
{
  if(fatal)
  {
    put("!!");
    sendtext(true);
    putEnd();
    shutdown();
    return; // Technically redundant - shutdown never returns.
  }
  
  if(resend < 0)
    put("ok");
  else
  {
    put("rs ");
    put(resend);
  }
    
  if(etemp > NO_TEMP)
  {
    put(" T:");
    put(etemp);
  }
  
  if(btemp > NO_TEMP)
  {
    put(" B:");
    put(btemp);
  }
  
  if(sendCoordinates)
  {				
    put(" C: X:");
    put(x);
    put(" Y:");
    put(y);
    put(" Z:");
    put(z);
    put(" E:");
    put(e);
  }
  
  if(sendCapabilities) 
  {  
    //TODO  - WE MOST LIKELY DON"T NEED ALL THESE, AND SOME EVEN DUPLICATE INFO, BUT UNTILL WE STABILISE THE SPEC
    //        I've left them all in here as X- values    See: http://reprap.org/wiki/M115_Keywords
    //
    //HINT: if you get a compile error on a variable here, it's because you havent defined that variable in the right section of CONFIGURATION.H
    
    // agreed avlues:
   put("PROTOCOL_VERSION:"); put(PROTOCOL_VERSION); putEnd();
   put("FIRMWARE_NAME:"); put(FIRMWARE_NAME); putEnd();
   put("FIRMWARE_VERSION:"); put(FIRMWARE_VERSION); putEnd();
   put("FIRMWARE_URL:"); put(FIRMWARE_URL); putEnd();
   put("MACHINE_TYPE:"); put(MACHINE_TYPE); putEnd();
   put("X-EXTRUDER_COUNT:"); put(xstr(EXTRUDER_COUNT)); putEnd();  //num as string
   // experimental values:
    put("X-FIRMWARE_BUILD_TIMESTAMP"); put( __DATE__ " " __TIME__ ); putEnd();
    put("X-REVISION:"); put(REVISION); putEnd();
    put("X-CPUTYPE:"); put(CPUTYPE); putEnd();
    put("X-DEFAULTS:"); put(DEFAULTS); putEnd();
    put("X-MOVEMENT_TYPE:"); put(MOVEMENT_TYPE); putEnd();
    put("X-ENDSTOP_OPTO_TYPE:"); put(ENDSTOP_OPTO_TYPE); putEnd();
    put("X-ENABLE_PIN_STATE:"); put(ENABLE_PIN_STATE); putEnd();
    put("X-TEMP_SENSOR:"); put(TEMP_SENSOR); putEnd();
    put("X-EXTRUDER_CONTROLLER:"); put(EXTRUDER_CONTROLLER); putEnd();
    put("X-EXTRUDER_THERMAL_MASS:"); put(EXTRUDER_THERMAL_MASS); putEnd();
    put("X-DATA_SOURCE:"); put(DATA_SOURCE); putEnd();
    put("X-ACCELERATION:"); put(ACCELERATION); putEnd();
    put("X-HEATED_BED:"); put(HEATED_BED); putEnd();
    put("X-INVERT_X_DIR:"); put(INVERT_X_DIR); putEnd();
    put("X-INVERT_Y_DIR:"); put(INVERT_Y_DIR); putEnd();
    put("X-INVERT_Z_DIR:"); put(INVERT_Z_DIR); putEnd();
    put("X-ENDSTOPS_MIN_ENABLED:"); put(ENDSTOPS_MIN_ENABLED); putEnd();
    put("X-ENDSTOPS_MAX_ENABLED:"); put(ENDSTOPS_MAX_ENABLED); putEnd();
    put("X-ENABLE_LINES:"); put(ENABLE_LINES); putEnd();
    #if ENABLE_LINES == HAS_ENABLE_LINES
    put("X-DISABLE_X:"); put(DISABLE_X); putEnd();
    put("X-DISABLE_Y:"); put(DISABLE_Y); putEnd();
    put("X-DISABLE_Z:"); put(DISABLE_Z); putEnd();
    put("X-DISABLE_E:"); put(DISABLE_E); putEnd();
    #endif
    put("X-FAST_XY_FEEDRATE:"); put(FAST_XY_FEEDRATE); putEnd();
    put("X-FAST_Z_FEEDRATE:"); put(FAST_Z_FEEDRATE); putEnd();
    put("X-X_STEPS_PER_MM:"); put(X_STEPS_PER_MM); putEnd();
    put("X-Y_STEPS_PER_MM:"); put(Y_STEPS_PER_MM); putEnd();
    put("X-Z_STEPS_PER_MM:"); put(Z_STEPS_PER_MM); putEnd();
    put("X-E0_STEPS_PER_MM:"); put(E0_STEPS_PER_MM); putEnd();
    #if EXTRUDER_COUNT == 2 
    put("X-E1_STEPS_PER_MM:"); put(E1_STEPS_PER_MM); putEnd();
    #endif
    
    // terminate capabilities list with a blank line:
    putEnd();
  }
  
  sendtext(doMessage);
  
  putEnd();
  
  reset(); 
}


#endif
