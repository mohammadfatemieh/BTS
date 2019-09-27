/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : DC measure
Version : 1
Date    : 4/17/2016
Author  : swat
Company : 
Comments: 


Chip type               : ATmega88PA
Program type            : Application
AVR Core Clock frequency: 16.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*******************************************************/

#include <mega88a.h>
#include "dcm.h"
// Declare your global variables here
#include <delay.h>
// Standard Input/Output functions
#include <stdio.h>

// Declare your global variables here

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Reinitialize Timer 0 value
TCNT0=0x38;
// Place your code here
if(time_out_run==1){
usart_time_out--;
if(usart_time_out==0) time_out=1;}
}

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
ADMUX=(FIRST_ADC_INPUT | ADC_VREF_TYPE)+input_index;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=(1<<ADSC);
}

void main(void)
{
// Declare your local variables here


config_mcu();
// Global enable interrupts
#asm("sei")
RS485_TxD=1;
printf("\r\n>DC measure Unit v1 fwv1 17/04/2016\r\n");
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
        //">CPU0Ar25<"
        if((rx_buffer0[0]=='>')&&(rx_buffer0[1]=='C')&&(rx_buffer0[2]=='P')&&(rx_buffer0[3]=='U')&&(rx_buffer0[6]=='r')&&(rx_buffer0[9]=='<')   
        &&(HexInCharToDec(rx_buffer0[5]) +  (HexInCharToDec(rx_buffer0[4])<<4) ==MyID) 
        &&(HexInCharToDec(rx_buffer0[8]) +  (HexInCharToDec(rx_buffer0[7])<<4) ==checksum))
        {
        //cpu_cmd=0;// CPU gui lenh doc cac gia tri ADC
        //ADC5: cam cam bien nhiet do NTC
        RS485_TxD=1;
        //printf("ADC[0..7]:%d,%d,%d,%d,%d,%d,%d,%d\r\n",adc_data[0],adc_data[1],adc_data[2],adc_data[3],adc_data[4],adc_data[5],adc_data[6],adc_data[7]);
        printf(">DCM%02X%04X%04X%04X%04X%04X%04X%04X%04X%02X<",cpu_id,adc_data[0],adc_data[1],adc_data[2],adc_data[3],adc_data[4],adc_data[5],adc_data[6],adc_data[7],checksum);
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
      
//      if(cpu_cmd==1)
//        {                   
//            
//            
//            
//            RS485_TxD=1;
//            //Phan hoi lai ban tin cho CPU
//            // In hex : ">OMC[0xCPU_IDHigh.0xCPU_IDLow][0xomc_stt_High.0xomc_stt_High][0xomc_stt_Low.0xomc_stt_Low][0xchecksum.0xchecksum]<"
//            printf("ADC[0..7]:%d,%d,%d,%d,%d,%d,%d,%d\r\n",adc_data[0],adc_data[1],adc_data[2],adc_data[3],adc_data[4],adc_data[5],adc_data[6],adc_data[7]); 
//            //printf(">DCM%02X%04X%02X<",cpu_id,omc_stt,checksum);
//            cpu_cmd=0; 
//        }
      

      }
}
