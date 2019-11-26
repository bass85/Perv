/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.3 Standard
Automatic Program Generator
© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 22.11.2018
Author  : Dima
Company : Dima
Comments: 


Chip type               : ATtiny261
AVR Core Clock frequency: 8,000000 MHz
Memory model            : Tiny
External RAM size       : 0
Data Stack size         : 32
*****************************************************/

#include <tiny261.h>

#include <delay.h>

unsigned int adc_data;
unsigned int pover=0;
 unsigned int timer=0;
#define ADC_VREF_TYPE 0x180

// ADC interrupt service routine
interrupt [ADC_INT] void adc_isr(void)
{
// Read the AD conversion result
adc_data=ADCW;
}

// Read the AD conversion result
// with noise canceling
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
#asm
    in   r30,mcucr
    cbr  r30,__sm_mask
    sbr  r30,__se_bit | __sm_adc_noise_red
    out  mcucr,r30
    sleep
    cbr  r30,__se_bit
    out  mcucr,r30
#endasm
return adc_data;
}

// Declare your global variables here

void main(void)
{
// Declare your local variables here

// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Input/Output Ports initialization
// Port A initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=In 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=T 
PORTA=0x00;
DDRA=0xFE;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=Out Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=1 State3=P State2=T State1=T State0=T 
PORTB=0x18;
DDRB=0x10;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: 8bit top=0xFF
TCCR0A=0x00;
TCCR0B=0x00;
TCNT0H=0x00;
TCNT0L=0x00;
OCR0A=0x00;
OCR0B=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=OCR1C
// OC1A output: Discon.
// OC1B output: Discon.
// OC1C output: Discon.
// Fault Protection Mode: Off
// Fault Protection Noise Canceler: Off
// Fault Protection triggered on Falling edge
// Fault Protection triggered by the Analog Comparator: Off
// Dead Time Rising Edge: 0.000 us
// Dead Time Falling Edge: 0.000 us
// Timer1 Overflow Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
// Compare D Match Interrupt: Off
// Fault Protection Interrupt: Off
PLLCSR=0x00;

TCCR1A=0x00;
TCCR1B=0x00;
TCCR1C=0x00;
TCCR1D=0x00;
TCCR1E=0x00;
TC1H=0x00;
TCNT1=0x00;
TC1H=0x00;
OCR1A=0x00;
TC1H=0x00;
OCR1B=0x00;
TC1H=0x00;
OCR1C=0x00;
TC1H=0x00;
OCR1D=0x00;
DT1=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// Interrupt on any change on pins PCINT0-7, 12-15: Off
// Interrupt on any change on pins PCINT8-11: Off
MCUCR=0x00;
GIMSK=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// Universal Serial Interface initialization
// Mode: Disabled
// Clock source: Register & Counter=no clk.
// USI Counter Overflow Interrupt: Off
USICR=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
ACSRA=0x80;
// Hysterezis level: 0 mV
ACSRB=0x00;
DIDR1=0x00;

// ADC initialization
// ADC Clock frequency: 7,813 kHz
// ADC Voltage Reference: AVCC pin
// ADC Bipolar Input Mode: Off
// ADC Auto Trigger Source: ADC Stopped
// Digital input buffers on ADC0: On, ADC1: On, ADC2: On, Aref: On
// ADC3: On, ADC4: On, ADC5: On, ADC6: On
DIDR0=0x00;
// Digital input buffers on ADC7: On, ADC8: On, ADC9: On, ADC10: On
DIDR1=0x00;
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x8F;
ADCSRB&=0x7F;
ADCSRB|=0x00 | ((ADC_VREF_TYPE & 0x100) >> 4);

// Global enable interrupts
#asm("sei")
     PORTA.1=0;
     PORTA.2=0;
     PORTA.3=0;
     PORTA.4=0;
     PORTA.5=0;
     PORTA.6=0;
     PORTB.4=1;
while (1)
      {
      // Place your code here
   while(PINB.3==0)
   {
  // PORTB.4=0;
    if(adc_data>770)
   { 
   PORTA.1=1;
   PORTA.2=1;
   PORTA.3=1;
   PORTA.4=1;
   PORTA.5=1;
   }
   if((adc_data<770)&&(adc_data>750))
   { 
   PORTA.1=1;
   PORTA.2=1;
   PORTA.3=1;
   PORTA.4=1;
   PORTA.5=0;
   } 
   if((adc_data<750)&&(adc_data>730))
   { 
   PORTA.1=1;
   PORTA.2=1;
   PORTA.3=1;
   PORTA.4=0;
   PORTA.5=0;
   }
   if((adc_data<700)&&(adc_data>650))
   { 
   PORTA.1=1;
   PORTA.2=1;
   PORTA.3=0;
   PORTA.4=0;
   PORTA.5=0;
   }
   if((adc_data<650)&&(adc_data>550))
   { 
   PORTA.1=1;
   PORTA.2=0;
   PORTA.3=0;
   PORTA.4=0;
   PORTA.5=0;
   }
    delay_ms(1000);
    timer++;
   }
 //  else 
   {
  // PORTB.4=1; 
   
     PORTA.1=0;
     PORTA.2=0;
     PORTA.3=0;
     PORTA.4=0;
     PORTA.5=0;
   } 
   
   if(timer>=3) 
   {
   if(pover==0)
   {
   pover=1;
   PORTA.6=1;
   PORTB.4=0;
   }
   else
   {
   pover=0;
   PORTA.6=0;
   PORTB.4=1;
  
   }
  
   }
      timer=0;
   
    read_adc(0);
      }
}
