/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : AC measure
Version : 1
Date    : 4/18/2016
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
// Standard Input/Output functions
#include <stdio.h>
#include <delay.h>
#include "acm.h"
#include "ade7753.h"
// SPI functions
#include <spi.h>
// Declare your global variables here



interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Reinitialize Timer 0 value
TCNT0=0x38;
// Place your code here
if(time_out_run==1){
usart_time_out--;
if(usart_time_out==0) time_out=1;}
time_to_check_ADE++;
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




void main(void)
{
// Declare your local variables here


config_mcu();
// Global enable interrupts
#asm("sei")
RS485_TxD=1;
//while(usart_status&(RX_COMPLETE));
printf("\r\n>ACM Unit v1 fwv1 18/04/2016\r\n");

delay_ms(200);
              // Settings for Olimex Energy Shield #1 - Etel
    // ------------------------------------
    //ADE7753_analogSetup(GAIN_1, GAIN_1, 0, 0, FULLSCALESELECT_0_25V, INTEGRATOR_OFF);  // GAIN1, GAIN2, CH1OS, CH2OS, Range_ch1, integrator_ch1
    //ADE7753_rmsSetup( -0, +0 );                 // IRMSOS,VRMSOS  12-bit (S) [-2048 +2048] -- Refer to spec page 25, 26
    //ADE7753_energySetup(0, 0, 0, 0, 0, 0x0D); // WGAIN,WDIV,APOS,VAGAIN,VADIV,PHCAL  -- Refer to spec page 39, 31, 46, 44, 52, 53
    //ADE7753_frequencySetup(0, 0);             // CFNUM,CFDEN  12-bit (U) -- for CF pulse output  -- Refer to spec page 31
    //ADE7753_miscSetup(0, 0, 0, 0, 0, 0);   3450=0
ADE7753_analogSetup(GAIN_4, GAIN_1, -3,-2, FULLSCALESELECT_0_5V, INTEGRATOR_OFF);  // GAIN1, GAIN2, CH1OS, CH2OS, Range_ch1, integrator_ch1
ADE7753_rmsSetup( -60, -1999 );
//ADE7753_write16(WGAIN,0);
//ADE7753_write16(CFDEN,6253);delay_ms(200);
//ADE7753_write8(WDIV,4);// Chia cac loai cong suat cho WDIV :))
//ADE7753_write16(WGAIN,131);delay_ms(200);
//ADE7753_write16(APOS,-784);delay_ms(200);
//ADE7753_setMode(CYCMODE); //Mode energy accumulation begins.
//ADE7753_setLineCyc(1000);
//delay_ms(200);
//RS485_TxD=1;
//printf("CFDEN:%u\r\n",ADE7753_read16(CFDEN));delay_ms(200);
//RS485_TxD=1;
//printf("WGAIN:%u\r\n",ADE7753_read16(WGAIN));delay_ms(200);
//RS485_TxD=1;
//printf("WDIV:%u\r\n",ADE7753_read8(WDIV));delay_ms(200);
//RS485_TxD=1;
//printf("APOS:%u\r\n",ADE7753_read8(APOS));
Vpeak 	  = ADE7753_getVpeakReset() ;
adc_data[0]=(int)(Vpeak/19.05);
adc_data[7]=ADE7753_getPeriod();
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
        time_out=0;
        time_out_run=0;
        process_uart=1;
      }
      if(process_uart==1)
      {
        // Chi nhan ban tin tu CPU_Unit ">CPU[REC_ID]r[checksum]<" 
        // In hex : ">CPU[0xMyIDHigh.0xMyIDLow]r[0xchecksum.0xchecksum]<"   
        //">CPU30r37<"
        if((rx_buffer0[0]=='>')&&(rx_buffer0[1]=='C')&&(rx_buffer0[2]=='P')&&(rx_buffer0[3]=='U')&&(rx_buffer0[9]=='<')   
        &&(HexInCharToDec(rx_buffer0[5]) +  (HexInCharToDec(rx_buffer0[4])<<4) ==MyID) 
        &&(HexInCharToDec(rx_buffer0[8]) +  (HexInCharToDec(rx_buffer0[7])<<4) ==checksum))
        {
        RS485_TxD=1;
        //printf("CPU request!\r\n");// Phan hoi tat cac cac gia tri AC ADC????Co can cau hinh ADE ko????
        printf(">ACM%02X%04X%04X%04X%04X%04X%04X%04X%04X%02X<",cpu_id,adc_data[0],adc_data[1],adc_data[2],adc_data[3],adc_data[4],adc_data[5],adc_data[6],adc_data[7],checksum);   
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
      if(time_to_check_ADE>10000)//1s
      {
        time_to_check_ADE=0;
        Vrms 	  = ADE7753_vrms() ;    // Hieu dien the hieu dung, Vrms = Vpeak / sqrt(2)     , Vpeak la V max
        Irms 	  = ADE7753_irms() ;     // Cuong do dong dien hieu dung, Irms = Ipeak / sqrt(2)
        Ipeak 	  = ADE7753_getIpeakReset() ;
        Vpeak 	  = ADE7753_getVpeakReset() ;
        adc_data[7] = ADE7753_getPeriod();  
        
        adc_data[0]=Vpeak; 
        adc_data[1]=Vrms;
        adc_data[2]=Irms;
        adc_data[3]=Ipeak;
        //RS485_TxD=1;
        //printf("Vrms:%d;Vpeak:%d;Irms:%d;Ipeak:%d;PERIOD:%d\r\n",adc_data[1],adc_data[0],adc_data[2],adc_data[3],adc_data[7]);
      }
      }
}

//delay_ms(500);
//      delay_ms(500);
//      
//      Vrms 	  = ADE7753_vrms() ;    // Hieu dien the hieu dung, Vrms = Vpeak / sqrt(2)     , Vpeak la V max
//      Irms 	  = ADE7753_irms()-800 ;     // Cuong do dong dien hieu dung, Irms = Ipeak / sqrt(2)  
//      Vpeak 	  = ADE7753_getVpeakReset() ;  
//      Ipeak 	  = ADE7753_getIpeakReset() ; 
//      Frequency = ADE7753_getPeriod();
//      //Vpeak 	  = ADE7753_getVpeakReset() ;   
//      //Vrms=2642412;
//      delay_ms(500);
//      RS485_TxD=1; 
//      //printf("test:%d\r\n",-32765);
//      printf("Vrms:%d;Vpeak:%d;Irms:%d;Ipeak:%d;PERIOD:%d\r\n",Vrms,(int)(Vpeak/13.63),Irms,Ipeak,Frequency); 
      
