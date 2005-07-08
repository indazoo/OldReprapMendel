#include "motor.h"

typedef unsigned int config;
config at 0x2007 __CONFIG = _CP_OFF &
 _WDT_OFF &
 _BODEN_OFF &
 _PWRTE_ON &
 _INTRC_OSC_CLKOUT &
 _MCLRE_OFF &
 _LVP_OFF;

byte deviceAddress = 4;  ///@todo #define or const?

// Support routines for bank 1
#include "serial-inc.c"

static void isr() interrupt 0 {
  serialInterruptHandler();
  if (RBIF)
    motorTick();
}

void main()
{
  byte v = 0;

  OPTION_REG = BIN(11011111); // Disable TMR0 on RA4, 1:128 WDT
  CMCON = 0xff;               // Comparator module defaults
  TRISA = BIN(00110000);      // Port A outputs (except 4/5)
                              // RA4 is used for clock out (debugging)
                              // RA5 can only be used as an input
  TRISB = BIN(10000110);      // Port B outputs, except 1/2 for serial and
                              // RB7 for optointerrupter input
  // Note port B3 will be used for PWM output (CCP1)
  PIE1 = BIN(00000000);       // All peripheral interrupts initially disabled
  INTCON = BIN(00000000);     // Interrupts disabled
  PIR1 = 0;                   // Clear peripheral interrupt flags
  SPBRG = 25;                 // 25 = 2400 baud @ 4MHz
  TXSTA = BIN(00000000);      // 8 bit low speed 
  RCSTA = BIN(10000000);      // Enable port for 8 bit receive

  TXEN = 1;  // Enable transmit
  RCIE = 1;  // Enable receive interrupts
  CREN = 1;  // Start reception

  RBIE = 1;  // Enable RB port change interrupt

  PEIE = 1;  // Peripheral interrupts on
  GIE = 1;   // Now turn on interrupts

  PORTB = 0;
  PORTA = 0;

  PR2 = PWMPeriod;          // Initial PWM period
  CCP1CON = BIN(00111100);  // Enable PWM mode (low two bits set)
  CCPR1L = 0;               // Start turned off
  
  T2CON = BIN(00000100);    // Enable timer 2 and set prescale to 1

  // Clear up any boot noise from the TSR
  uartTransmit(0);

  for(;;) {
    if (processingLock) {
      processCommand();
      releaseLock();
    }
  }
}
