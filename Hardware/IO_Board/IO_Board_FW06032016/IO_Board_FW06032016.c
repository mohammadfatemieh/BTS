/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.3 Standard
Automatic Program Generator
© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 3/6/2016
Author  : Tuan
Company : ATTECH
Comments:  This code for IO_Board v3 
- Have 9 relay with 9 DryOut "NC" for indicate ERROR : Water inside; Low AC Power; Low DC Power; 
- Measure AC Voltage by Transformer 220V to 12V AC
- Measure DC Voltage 48V DC
- Have 2 DryIN for Gate Sensor and Smoke Sensor
- One ADC in for detect Water inside
- One Relay to power 12V DC for Smoke Sensor  


Chip type               : ATmega88
Program type            : Application
AVR Core Clock frequency: 16.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega88.h>
// Standard Input/Output functions
#include <stdio.h>
#include <delay.h>

// Define hardware for Basic Board
// 9 Relay to BTS system for indicate something Wrong
// Define hardware
#define Relay1 PORTB.4// for water detected
#define Relay2 PORTB.3// Temp > 25oC
#define Relay3 PORTB.2//Humi > 80 %RH
#define Relay4 PORTB.1 // for smoke detected
#define Relay5 PORTB.0 // Fired, temp > 60oC
#define Relay6 PORTD.7 // AC Volt < 180V
#define Relay7 PORTD.6 //DC Volt < 43V
#define Relay8 PORTD.5 // System failre
#define Relay9 PORTD.4 // Lost power (mat dien luoi)

// 1 Relay cap nguon cho sensor khoi
#define Smoke_Power PORTC.0


#define RS485_TxD PORTC.5

//2 logic port to plug dry contact sensor : smoke and gate open
#define LG_IN_1 PIND.3
#define LG_IN_2 PIND.2

#define ALL_RL_ON   Relay1=1;Relay2=1;Relay3=1;Relay4=1;Relay5=1;Relay6=1;Relay7=1;Relay8=1;Relay9=1;
#define ALL_RL_OFF   Relay1=0;Relay2=0;Relay3=0;Relay4=0;Relay5=0;Relay6=0;Relay7=0;Relay8=0;Relay9=0

#define Water_ADC 1
#define AC_ADC 2
#define DC_ADC 3

#ifndef RXB8
#define RXB8 1
#endif

#ifndef TXB8
#define TXB8 0
#endif

#ifndef UPE
#define UPE 2
#endif

#ifndef DOR
#define DOR 3
#endif

#ifndef FE
#define FE 4
#endif

#ifndef UDRE
#define UDRE 5
#endif

#ifndef RXC
#define RXC 7
#endif

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)


// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
status=UCSR0A;
data=UDR0;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {

   }
}





// USART Transmitter interrupt service routine
interrupt [USART_TXC] void usart_tx_isr(void)
{
RS485_TxD=0;
}



// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Place your code here

}

#define ADC_VREF_TYPE 0x40
#define FIRST_ADC_INPUT 1
#define LAST_ADC_INPUT 3
unsigned int adc_data[LAST_ADC_INPUT-FIRST_ADC_INPUT+1];

// ADC interrupt service routine
// with auto input scanning
interrupt [ADC_INT] void adc_isr(void)
{
static unsigned char input_index=0;
// Read the AD conversion result
adc_data[input_index]=ADCW;
// Select next ADC input
if (++input_index > (LAST_ADC_INPUT-FIRST_ADC_INPUT))
   input_index=0;
ADMUX=(FIRST_ADC_INPUT | (ADC_VREF_TYPE & 0xff))+input_index;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=0x40;
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
// Port B initialization
// Func7=In Func6=In Func5=In Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=T State6=T State5=T State4=0 State3=0 State2=0 State1=0 State0=0 
PORTB=0x00;
DDRB=0x1F;

// Port C initialization
// Func6=In Func5=Out Func4=In Func3=In Func2=In Func1=In Func0=Out 
// State6=T State5=0 State4=T State3=T State2=T State1=T State0=0 
PORTC=0x00;
DDRC=0x21;

// Port D initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In 
// State7=0 State6=0 State5=0 State4=0 State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0xF0;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 15.625 kHz
// Mode: Normal top=0xFF
// OC0A output: Disconnected
// OC0B output: Disconnected
TCCR0A=0x00;
TCCR0B=0x05;
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2A output: Disconnected
// OC2B output: Disconnected
ASSR=0x00;
TCCR2A=0x00;
TCCR2B=0x00;
TCNT2=0x00;
OCR2A=0x00;
OCR2B=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// Interrupt on any change on pins PCINT0-7: Off
// Interrupt on any change on pins PCINT8-14: Off
// Interrupt on any change on pins PCINT16-23: Off
EICRA=0x00;
EIMSK=0x00;
PCICR=0x00;

// Timer/Counter 0 Interrupt(s) initialization
TIMSK0=0x01;

// Timer/Counter 1 Interrupt(s) initialization
TIMSK1=0x00;

// Timer/Counter 2 Interrupt(s) initialization
TIMSK2=0x00;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART0 Mode: Asynchronous
// USART Baud Rate: 115200 (Double Speed Mode)
UCSR0A=0x02;
UCSR0B=0xD8;
UCSR0C=0x06;
UBRR0H=0x00;
UBRR0L=0x10;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
ADCSRB=0x00;
DIDR1=0x00;


// ADC initialization
// ADC Clock frequency: 1000.000 kHz
// ADC Voltage Reference: AVCC pin
// ADC Auto Trigger Source: ADC Stopped
// Digital input buffers on ADC0: On, ADC1: On, ADC2: On, ADC3: On
// ADC4: On, ADC5: On
DIDR0=0x00;
ADMUX=FIRST_ADC_INPUT | (ADC_VREF_TYPE & 0xff);
ADCSRA=0xCC;



// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

// Global enable interrupts
#asm("sei")
RS485_TxD=1;
printf("Hi all"); 
while (1)
      {
      // Place your code here
      RS485_TxD=1;
      printf(">ADC value: %d;%d;%d \r\n",adc_data[0],adc_data[1],adc_data[2]);
      delay_ms(100);
      }
}
