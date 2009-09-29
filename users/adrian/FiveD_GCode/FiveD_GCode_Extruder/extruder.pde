#include "extruder.h"

extruder::extruder()
{
  pinMode(H1D, OUTPUT);
  pinMode(H1E, OUTPUT);  
  pinMode(H2D, OUTPUT);
  pinMode(H2E, OUTPUT);
  pinMode(OUTPUT_A, OUTPUT);
  pinMode(OUTPUT_B, OUTPUT);
  pinMode(OUTPUT_C, OUTPUT);
  pinMode(E_STEP_PIN, INPUT);
  pinMode(E_DIR_PIN, INPUT);  
  pinMode(POT, INPUT);
  
  disableStep();
  
  // Change the frequency of Timer 0 so that PWM on pins H1E and H2E goes at
  // a very high frequency (64kHz see: 
  // http://tzechienchu.typepad.com/tc_chus_point/2009/05/changing-pwm-frequency-on-the-arduino-diecimila.html)
  
  TCCR0B &= ~(0x07); 
  TCCR0B |= 1; 

// Defaults

  coilPosition = 0;  
  forward = true;
  pwmValue =  60;
  temp = 20;
  t = 2;
  manageCount = 0;
  blink = 0;
  stp = 0;
}

void extruder::slowManage()
{
  manageCount = 0;
  
  blink = 1 - blink;
  digitalWrite(DEBUG_PIN, blink);   

  t = internalTemperature();  
  if(temp > t)
    digitalWrite(OUTPUT_A, 1);
  else
    digitalWrite(OUTPUT_A, 0);
}

void extruder::manage()
{
  byte s = digitalRead(E_STEP_PIN);
  if(s != stp)
  {
    stp = s;
    sStep();
  }

  manageCount++;
  if(manageCount > 16000)
   slowManage();   
}

int extruder::internalTemperature()
{
  return 99;
}

void extruder::waitForTemperature()
{
  
}

void extruder::valveSet(bool open)
{
  if(open)
    digitalWrite(OUTPUT_C, 1);
  else
    digitalWrite(OUTPUT_C, 0); 
}

void extruder::setDirection(bool direction)
{
  forward = direction;  
}

void extruder::setCooler(byte e_speed)
{
    analogWrite(OUTPUT_B, e_speed);   
}

void extruder::setTemperature(int tp)
{
  temp = tp;
}

int extruder::getTemperature()
{
  return t;  
}

void extruder::sStep()
{
  byte pwm = pwmValue;
  
// This increments or decrements coilPosition then writes the appropriate pattern to the output pins.

  if(digitalRead(E_DIR_PIN))
    coilPosition++;
  else
    coilPosition--;
  coilPosition &= 7;
  
  // Disable the coils
  
  //analogueWrite(H1E, 0);
  //analogueWrite(H2E, 0);
  
  // Which of the 8 possible patterns do we want?
  // The commented out setPower(...) lines could
  // be used to run the coils at constant power (with
  // half-stepping not each step is equal).  Just
  // use the value of the argument to setPower(...) to
  // scale the PWM values.
  
  switch(coilPosition) 
  {
  case 7:
    pwm = (pwm >> 1) + (pwm >> 3);
    digitalWrite(H1D, 1);    
    digitalWrite(H2D, 1);
    //h1Enable = true;
    analogWrite(H1E, pwm);
    //h2Enable = true;
    analogWrite(H2E, pwm);    
    break;
    
  case 6:
    digitalWrite(H1D, 1);    
    digitalWrite(H2D, 1);
    //h1Enable = true;
    analogWrite(H1E, pwm);
    //h2Enable = false;
    analogWrite(H2E, 0);   
    break; 
    
  case 5:
    pwm = (pwm >> 1) + (pwm >> 3);
    digitalWrite(H1D, 1);
    digitalWrite(H2D, 0);
    //h1Enable = true;
    analogWrite(H1E, pwm);
    //h2Enable = true;
    analogWrite(H2E, pwm); 
    break;
    
  case 4:
    digitalWrite(H1D, 1);
    digitalWrite(H2D, 0);
    //h1Enable = false;
    analogWrite(H1E, 0);
    //h2Enable = true;
    analogWrite(H2E, pwm); 
    break;
    
  case 3:
    pwm = (pwm >> 1) + (pwm >> 3);
    digitalWrite(H1D, 0);
    digitalWrite(H2D, 0);
    //h1Enable = true;
    analogWrite(H1E, pwm);
    //h2Enable = true;
    analogWrite(H2E, pwm); 
    break; 
    
  case 2:
    digitalWrite(H1D, 0);
    digitalWrite(H2D, 0);
    //h1Enable = true;
    analogWrite(H1E, pwm);
    //h2Enable = false;
    analogWrite(H2E, 0); 
    break;
    
  case 1:
    pwm = (pwm >> 1) + (pwm >> 3);
    digitalWrite(H1D, 0);
    digitalWrite(H2D, 1);
    //h1Enable = true;
    analogWrite(H1E, pwm);
    //h2Enable = true;
    analogWrite(H2E, pwm); 
    break;
    
  case 0:
    //setPower(stepPower);
    digitalWrite(H1D, 0);
    digitalWrite(H2D, 1);
    //h1Enable = false;
    analogWrite(H1E, 0);
    //h2Enable = true;
    analogWrite(H2E, pwm); 
    break; 
    
  }
  
  // How much is the pot turned up?
  // Divide it by 4 to spread the valid readings out a bit.
  // This is about right for a 1A 3-ohm/coil stepper.
  
  //potValue = analogRead(POT)>>2;
  
  // Send the appropriate PWM values
/*  
  if(h1Enable)
    analogWrite(H1E, pwmValue);
  else
    analogWrite(H1E, 0);
    
  if(h2Enable)
    analogWrite(H2E, pwmValue);
  else
    analogWrite(H2E, 0);
*/
}
 

void extruder::enableStep()
{
// Nothing to do here - step() automatically enables the stepper drivers appropriately.  
}

void extruder::disableStep()
{
    analogWrite(H1E, 0);
    analogWrite(H2E, 0);  
}

int extruder::potVoltage()
{
    return (int)analogRead(POT);  
}

void extruder::setPWM(int p)
{
    pwmValue = p;
}

char* extruder::processCommand(char command[])
{
  reply[0] = 0;
  switch(command[0])
  {
    case WAIT_T:
      waitForTemperature();
      break;
      
    case VALVE:
      valveSet(command[1] == '1');
      break;
      
    case DIRECTION:
      // setDirection(command[1] == '1'); // Now handled by hardware.
      break;
      
     case COOL:
       setCooler(atoi(&command[1]));
       break;
       
     case SET_T:
       setTemperature(atoi(&command[1]));
       break;
       
     case GET_T:
       itoa(getTemperature(), reply, 10);
       break;
        
     case STEP:
       //sStep(); // Now handled by hardware.
       break;
        
     case ENABLE:
       enableStep();
       break;
        
     case DISABLE:
       disableStep();
       break;
       
     case PREAD:
       itoa(potVoltage(), reply, 10);
       break;
  
     case SPWM:
       setPWM(atoi(&command[1]));
       break;      
        
     case PING:
       break;
        
     default:
        return 0; // Flag up dud command
    }
   return reply; 
}
