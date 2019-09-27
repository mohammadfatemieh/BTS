/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.3 Standard
Automatic Program Generator
© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : BTS Monitor
Version : For IO_Board v3
Date    : 1/15/2016
Author  : Tuan
Company : ATTECH
Comments: This code for IO_Board v3 
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

#include <mega88a.h>
#include <delay.h>
// Standard Input/Output functions
#include <stdio.h>
#include "main.h"

unsigned char HexInCharToDec(char data)
      {
            if((data>47)&&(data<58)) return (data-48);// 0...9
            if((data>63)&&(data<71)) return (data-55);//A..F
      }
// ADC interrupt service routine
// with auto input scanning
interrupt [ADC_INT] void adc_isr(void)
{
static unsigned char input_index=0;
//static unsigned char ac_index=1;
// Read the AD conversion result
adc_data[input_index]=ADCW;
//if(++input_index==1) adc_ac_volt[ac_index]=adc_data[input_index];
//if(++ac_index==9) {ac_index=1;adc_ac_volt[0]=(adc_ac_volt[1]+adc_ac_volt[2]+adc_ac_volt[3]+adc_ac_volt[4]+adc_ac_volt[5]+adc_ac_volt[6]+adc_ac_volt[7]+adc_ac_volt[8])/8;}
// Select next ADC input
if (++input_index > (LAST_ADC_INPUT-FIRST_ADC_INPUT))
   input_index=0;
ADMUX=(FIRST_ADC_INPUT | (ADC_VREF_TYPE & 0xff))+input_index;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=0x40;
}


//Khoang 60s se nhay vao day 1 lan
// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Place your code here
//static unsigned char ac_index=1;
//adc_ac_volt[ac_index]=adc_data[1];
//if(++ac_index==9) {ac_index=1;adc_ac_volt[0]=(adc_ac_volt[1]+adc_ac_volt[2]+adc_ac_volt[3]+adc_ac_volt[4]+adc_ac_volt[5]+adc_ac_volt[6]+adc_ac_volt[7]+adc_ac_volt[8])/8;}
//bts_stt_rtc.dc_vol=(int)(2.2+0.7919*adc_data[DC_ADC]); // Tinh toan dien ap DC    
//            bts_stt_rtc.ac_vol=(int)(12.163 * (.2+(float)(adc_ac_volt[0])/35.503));       // TInh toan dien ap AC    
//flag_for_update++;
//flag_for_volt++;
}




//Ban tin tu MB
char USART_DATA[50];
unsigned char index=0, usart_flag=0;
unsigned char usart_time_out;
char *usart_p;
// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char data;
usart_status=UCSR0A;
data=UDR0;
usart_time_out=0xffff;
usart_flag=0;
if ((usart_status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
     //Du lieu nhan duoc tu RS485 dc luu vao mang USART_DATA[50] va se xu ly sau do
     // Chi nhan ban tin tu CPU_Unit ">CPU[REC_ID][cmd_High][cmd_Low][checksum]<" 
     USART_DATA[index++]=data;
     if(index>49) {index=0;usart_p=USART_DATA;}// Gioi han ban tin < 50 ky tu      
   }
}

interrupt [USART_TXC] void usart_tx_isr(void)
{
RS485_TxD=0;   
}


void main(void)
{
// Declare your local variables here
unsigned char usart_count;
char data_buffer_to_send[50];

// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Input/Output Ports initialization
// Port B initialization
// Func7=In Func6=In Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=T State6=T State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTB=0x00;
DDRB=0x3F;

// Port C initialization
// Func6=In Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In 
// State6=T State5=0 State4=0 State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x30;

// Port D initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In 
// State7=0 State6=0 State5=0 State4=0 State3=T State2=T State1=T State0=T 
PORTD=0x00;
DDRD=0xF0;


// Timer/Counter 1 initialization
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
ASSR=0x00;
TCCR2A=0x00;
TCCR2B=0x00;
TCNT2=0x00;
OCR2A=0x00;
OCR2B=0x00;

// External Interrupt(s) initialization
EICRA=0x00;
EIMSK=0x00;
PCICR=0x00;


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
// ADC disabled
ADCSRA=0x00;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;


delay_ms(1000);
// Global enable interrupts
#asm("sei")


usart_p=USART_DATA;
//Pull up for transmit data
RS485_TxD=1;
//while(usart_status&(RX_COMPLETE));
printf("\r\n>OMC Unit v1 fwv1 10/04/2016\r\n");
index=0;
usart_p=USART_DATA;
IDC_Standby;
//IDC_Send;
//ALL_RL_ON;
while (1)
      { 
      // Place your code here
      if(omc_stt!=cpu_cmd)
        {
            omc_stt=cpu_cmd;
            Relay1   =omc_stt&  0x01;
            Relay2   =omc_stt&  0x02;
            Relay3   =omc_stt&  0x04; 
            Relay4   =omc_stt&  0x08;
            Relay5   =omc_stt&  0x10;
            Relay6   =omc_stt&  0x20;
            Relay7   =omc_stt&  0x40;
            Relay8   =omc_stt&  0x80;
            Relay9   =omc_stt&  0x100;
            Relay10 =omc_stt&  0x200;  
            RS485_TxD=1; 
            omc_stt=GET_RL_STT; 
            printf("omc_stt:%x\r\n",GET_RL_STT); 
        }
      if(usart_flag==0){   
      usart_time_out--;} 
      if(usart_time_out==1) 
            {  
                usart_flag=1; 
                usart_time_out=0;  
                delay_ms(5);      
                // Chi nhan ban tin tu CPU_Unit ">CPU[REC_ID][cmd_High][cmd_Low][checksum]<" 
                // In hex : ">CPU[0xMyIDHigh.0xMyIDLow][0xcmd_High.0xcmd_High][0xcmd_Low.0xcmd_Low][0xchecksum.0xchecksum]<"   
                //">CPU01223322<"
                if((USART_DATA[0]=='>')&&(USART_DATA[1]=='C')&&(USART_DATA[2]=='P')&&(USART_DATA[3]=='U')&&(USART_DATA[12]=='<')   )
                //&&(HexInCharToDec(USART_DATA[5]) +  (HexInCharToDec(USART_DATA[4])<<4) ==MyID)
                //&&(HexInCharToDec(USART_DATA[11]) +  (HexInCharToDec(USART_DATA[10])<<4) ==0x22))
                {
                RS485_TxD=1;
                cpu_cmd=((HexInCharToDec(USART_DATA[7])+(HexInCharToDec(USART_DATA[6])<<4))<<8)+HexInCharToDec(USART_DATA[9])+16*HexInCharToDec(USART_DATA[8]);
                printf("CPU cmd:%x\r\n",cpu_cmd);   
                }          
                //RS485_TxD=1;
                printf("You are here:%s!\r\n",USART_DATA);
                for(usart_count=0;usart_count<50;usart_count++)
                            {
                            USART_DATA[usart_count]=0;
                            }  
                            index=0;
            }  
         
       
        if(flag_for_update>2200)// 30s update 
      {   
            sprintf(data_buffer_to_send,">102:%02X%02X%02X%02X%02X%04X%04X%04X%04X%02X%02X%02X!<",
            bts_stt_rtc.bts_rtc.hr,bts_stt_rtc.bts_rtc.min,
	        bts_stt_rtc.bts_rtc.date,bts_stt_rtc.bts_rtc.month,bts_stt_rtc.bts_rtc.year,
	        bts_stt_rtc.Ex_Sensor.humi,
	        bts_stt_rtc.Ex_Sensor.temp,
	        bts_stt_rtc.Int_Sensor.humi,
	        bts_stt_rtc.Int_Sensor.temp,
	        (bts_stt_rtc.gate<<2)+(bts_stt_rtc.smoke<<1)+bts_stt_rtc.water,60,102); 

            RS485_TxD=1;  
            printf("%s",data_buffer_to_send);
             
            //printf( ">BMS:%c.%c.%c.%c.%c!<",bts_stt_rtc.ac_vol,bts_stt_rtc.dc_vol>>8,bts_stt_rtc.dc_vol,(bts_stt_rtc.gate<<2)+(bts_stt_rtc.smoke<<1)+bts_stt_rtc.water,123);        
            //RS485_TxD=0; 
            flag_for_update=0;
      }
      if(flag_for_volt>1200)
      {
            //">302:[ac_vol].[dc_vol_H].[dc_vol_L].[alarm][check_sum]!<"  
            
            //>3XX:[hr][][][][][][][][][DC]!< 
            sprintf(data_buffer_to_send,">302:%02X%04X%02X%02X!<",
                                                        bts_stt_rtc.ac_vol,bts_stt_rtc.dc_vol,
                                                        61,102);
            RS485_TxD=1;  
            printf("%s",data_buffer_to_send);
            flag_for_volt=0; 
      }    
      

      }
}
