/*******************************************************
This program was created by the
CodeWizardAVR V3.12 Advanced
Automatic Program Generator
© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : OMC
Version : 1
Date    : 4/15/2016
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
#include "omc.h"
// Declare your global variables here
#include <delay.h>
// Standard Input/Output functions
#include <stdio.h>


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




void main(void)
{
// Declare your local variables here

config_mcu();

// Global enable interrupts
#asm("sei")
RS485_TxD=1;
printf("\r\n>OMC Unit v1 fwv1 10/04/2016\r\n");
IDC_Standby;
usart_time_out=500;
time_out=0;
time_out_run=1;
process_uart=1;// Clear buffer
while (1)
      {
      // Place your code here
      if(time_out==1) 
      {
        //RS485_TxD=1;                                      
        //printf("Time up!\r\n"); 
        time_out=0;
        time_out_run=0;
        process_uart=1;
      }
      if(process_uart==1)
      {
        // Chi nhan ban tin tu CPU_Unit ">CPU[REC_ID][cmd_High][cmd_Low][checksum]<" 
        // In hex : ">CPU[0xMyIDHigh.0xMyIDLow][0xcmd_High.0xcmd_High][0xcmd_Low.0xcmd_Low][0xchecksum.0xchecksum]<"   
        //">CPU01223322<"
        if((rx_buffer0[0]=='>')&&(rx_buffer0[1]=='C')&&(rx_buffer0[2]=='P')&&(rx_buffer0[3]=='U')&&(rx_buffer0[12]=='<')   
        &&(HexInCharToDec(rx_buffer0[5]) +  (HexInCharToDec(rx_buffer0[4])<<4) ==MyID) 
        &&(HexInCharToDec(rx_buffer0[11]) +  (HexInCharToDec(rx_buffer0[10])<<4) ==checksum))
        {
        
        cpu_cmd=((HexInCharToDec(rx_buffer0[7])+(HexInCharToDec(rx_buffer0[6])<<4))<<8)+HexInCharToDec(rx_buffer0[9])+16*HexInCharToDec(rx_buffer0[8]);
        //RS485_TxD=1;
        //printf("CPU cmd:%x\r\n",cpu_cmd);  
        if(omc_stt==cpu_cmd)  // Neu gui lai lenh cu >> Ping
        {
            RS485_TxD=1;
            //Phan hoi lai ban tin cho CPU
            // In hex : ">OMC[0xCPU_IDHigh.0xCPU_IDLow][0xomc_stt_High.0xomc_stt_High][0xomc_stt_Low.0xomc_stt_Low][0xchecksum.0xchecksum]<" 
            printf(">OMC%02X%04X%02X<",cpu_id,omc_stt,checksum);
        }
        else if(cpu_cmd>0x03FF)// Kiem tra trang thai
        {
            cpu_cmd=omc_stt; 
            RS485_TxD=1;
            printf(">OMC%02X%04X%02X<",cpu_id,omc_stt,checksum);
        } 
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
      
      if((omc_stt!=cpu_cmd)&&(cpu_cmd<1024))
        {                   
            // Chua xu ly truong hop neu cpu_cmd>0x03FF???
            omc_stt=cpu_cmd;
            Relay1   =omc_stt&  0x01;
            Relay2   =(omc_stt>>1)&  0x01;
            Relay3   =(omc_stt>>2)&  0x01;
            Relay4   =(omc_stt>>3)&  0x01;
            Relay5   =(omc_stt>>4)&  0x01;
            Relay6   =(omc_stt>>5)&  0x01;
            Relay7   =(omc_stt>>6)&  0x01;
            Relay8   =(omc_stt>>7)&  0x01;
            Relay9   =(omc_stt>>8)&  0x01;
            Relay10  =(omc_stt>>9)&  0x01;
            RS485_TxD=1;
            //Phan hoi lai ban tin cho CPU
            // In hex : ">OMC[0xCPU_IDHigh.0xCPU_IDLow][0xomc_stt_High.0xomc_stt_High][0xomc_stt_Low.0xomc_stt_Low][0xchecksum.0xchecksum]<" 
            printf(">OMC%02X%04X%02X<",cpu_id,omc_stt,checksum); 
        }
        
      }
}
