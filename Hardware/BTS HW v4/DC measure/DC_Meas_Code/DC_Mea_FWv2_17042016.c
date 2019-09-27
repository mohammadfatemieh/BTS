/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.3 Standard
Automatic Program Generator
© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 4/18/2016
Author  : swat
Company : Unknown
Comments: 


Chip type               : ATmega88PA
Program type            : Application
AVR Core Clock frequency: 16.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega88a.h>
#include "dcm2.h"
// Declare your global variables here
#include <delay.h>
// Standard Input/Output functions
#include <stdio.h>




// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
status=UCSR0A;
data=UDR0;
usart_time_out=500;
time_out=0;
time_out_run=1;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer0[rx_wr_index0++]=data;
#if RX_BUFFER_SIZE0 == 256
   // special case for receiver buffer size=256
   if (++rx_counter0 == 0) rx_buffer_overflow0=1;
#else
   if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
   if (++rx_counter0 == RX_BUFFER_SIZE0)
      {
      rx_counter0=0;
      rx_buffer_overflow0=1;
      }
#endif
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
// Reinitialize Timer 0 value
TCNT0=0x38;
// Place your code here
// Place your code here
if(time_out_run==1){
usart_time_out--;
if(usart_time_out==0) time_out=1;}
}

#define FIRST_ADC_INPUT 0
#define LAST_ADC_INPUT 7
unsigned int adc_data[LAST_ADC_INPUT-FIRST_ADC_INPUT+1];
#define ADC_VREF_TYPE 0x40

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
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0x00;

// Port C initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=Out Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=0 State1=T State0=T 
PORTD=0x00;
DDRD=0x04;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 2000.000 kHz
// Mode: Normal top=0xFF
// OC0A output: Disconnected
// OC0B output: Disconnected
TCCR0A=0x00;
TCCR0B=0x02;
TCNT0=0x38;
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
printf("\r\n>DC measure Unit v2 fwv1 18/04/2016\r\n");
IDC_Standby;
usart_time_out=5000;
time_out=0;
time_out_run=1;
process_uart=1;// Clear buffer
while (1)
      {
      // Place your code here
      if(time_out==1) 
      {
        //RS485_TxD=1;                                      
            //while(usart_status&(RX_COMPLETE));
        //printf("Time up!\r\n"); 
        time_out=0;
        time_out_run=0;
        process_uart=1;
      }
      if(process_uart==1)
      {
        // Chi nhan ban tin tu CPU_Unit ">CPU[REC_ID]r[checksum]<" 
        // In hex : ">CPU[0xMyIDHigh.0xMyIDLow]r[0xchecksum.0xchecksum]<"   
        //">CPU01r25<"
        if((rx_buffer0[0]=='>')&&(rx_buffer0[1]=='C')&&(rx_buffer0[2]=='P')&&(rx_buffer0[3]=='U')&&(rx_buffer0[6]=='r')&&(rx_buffer0[9]=='<')   
        &&(HexInCharToDec(rx_buffer0[5]) +  (HexInCharToDec(rx_buffer0[4])<<4) ==MyID) 
        &&(HexInCharToDec(rx_buffer0[8]) +  (HexInCharToDec(rx_buffer0[7])<<4) ==checksum))
        {
        cpu_cmd=1;// CPU gui lenh doc cac gia tri ADC
        //RS485_TxD=1;
        //printf("CPU cmd:%x\r\n",cpu_cmd);   
        } 
        //RS485_TxD=1;                                      
        //printf("Mess:%s!\r\n",rx_buffer0);
        process_uart=0;
        for(usart_count=0;usart_count<RX_BUFFER_SIZE0;usart_count++)
                            {
                            rx_buffer0[usart_count]=0;
                            }  
                            rx_wr_index0=0;  
      }
      
      if(cpu_cmd==1)
        {                   
            
            cpu_cmd=0;
            //Phan hoi lai ban tin cho CPU
            // In hex : ">OMC[0xCPU_IDHigh.0xCPU_IDLow][0xomc_stt_High.0xomc_stt_High][0xomc_stt_Low.0xomc_stt_Low][0xchecksum.0xchecksum]<"
            RS485_TxD=1;
            printf("ADC[0..7]:%d,%d,%d,%d,%d,%d,%d,%d\r\n",adc_data[0],adc_data[1],adc_data[2],adc_data[3],adc_data[4],adc_data[5],adc_data[6],adc_data[7]); 
            //printf(">DCM%02X%04X%02X<",cpu_id,omc_stt,checksum);
             
        }
      }
}
