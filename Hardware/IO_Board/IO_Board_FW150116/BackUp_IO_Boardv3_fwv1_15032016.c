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

#include <mega88.h>
#include <delay.h>
// Standard Input/Output functions
#include <stdio.h>
#include "main.h"


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
static unsigned char ac_index=1;
adc_ac_volt[ac_index]=adc_data[1];
if(++ac_index==9) {ac_index=1;adc_ac_volt[0]=(adc_ac_volt[1]+adc_ac_volt[2]+adc_ac_volt[3]+adc_ac_volt[4]+adc_ac_volt[5]+adc_ac_volt[6]+adc_ac_volt[7]+adc_ac_volt[8])/8;}
bts_stt_rtc.dc_vol=(int)(2.2+0.7919*adc_data[DC_ADC]); // Tinh toan dien ap DC    
            bts_stt_rtc.ac_vol=(int)(12.163 * (.2+(float)(adc_ac_volt[0])/35.503));       // TInh toan dien ap AC    
            if((adc_data[Water_ADC]<1000)&&(bts_stt_rtc.water==0))// Neu phat hien ra ngap nuoc lan dau tien 
            {
                //Ngap nuoc
                bts_stt_rtc.water=1;
                Relay1=1;
                //Phat di canh bao ngap nuoc
                RS485_TxD=1;
                //printf( ">BMS:%c.%c.%c.%c.%c!<",bts_stt_rtc.ac_vol,bts_stt_rtc.dc_vol>>8,bts_stt_rtc.dc_vol,(bts_stt_rtc.gate<<2)+(bts_stt_rtc.smoke<<1)+bts_stt_rtc.water,123);                    
            }
            else if((adc_data[Water_ADC]>1000)&&(bts_stt_rtc.water==1)) 
            {
                bts_stt_rtc.water=0;
                Relay1=0;  
            }
             
            if((bts_stt_rtc.dc_vol<430)&&(Relay7==0))// Neu phat hien DC yeu lan dau tien 
            {
                Relay7=1;
                //Phat di canh bao DC yeu
                RS485_TxD=1;
                //printf( ">BMS:%c.%c.%c.%c.%c!<",bts_stt_rtc.ac_vol,bts_stt_rtc.dc_vol>>8,bts_stt_rtc.dc_vol,(bts_stt_rtc.gate<<2)+(bts_stt_rtc.smoke<<1)+bts_stt_rtc.water,123); 
            }
            else if((bts_stt_rtc.dc_vol>430)&&(Relay7==1)) Relay7=0; 
            if((bts_stt_rtc.ac_vol<180)&&(Relay6==0))// Neu phat hien AC yeu lan dau tien  
            {
                Relay6=1;
                //Phat di canh bao AC yeu
                RS485_TxD=1;
                //printf( ">BMS:%c.%c.%c.%c.%c!<",bts_stt_rtc.ac_vol,bts_stt_rtc.dc_vol>>8,bts_stt_rtc.dc_vol,(bts_stt_rtc.gate<<2)+(bts_stt_rtc.smoke<<1)+bts_stt_rtc.water,123);
            }
            else if((bts_stt_rtc.ac_vol>180)&&(Relay6==1)) Relay6=0;
            
            //Neu phat hien co khoi
            if((bts_stt_rtc.smoke==1)&&(Relay4==0))// Neu phat hien SMOKE lan dau tien  
            {
                Relay4=1;
                //Phat di canh bao SMOKE
                RS485_TxD=1;
                //printf( ">BMS:%c.%c.%c.%c.%c!<",bts_stt_rtc.ac_vol,bts_stt_rtc.dc_vol>>8,bts_stt_rtc.dc_vol,(bts_stt_rtc.gate<<2)+(bts_stt_rtc.smoke<<1)+bts_stt_rtc.water,123);
            }
            else if((bts_stt_rtc.smoke==0)&&(Relay4==1)) Relay4=0; 
            
            //Neu phat hien TEMP>25oC
            if((bts_stt_rtc.Int_Sensor.temp>250)&&(Relay2==0))// Neu phat hien TEMP>25oC lan dau tien  
            {
                Relay2=1;
                //Phat di canh bao TEMP>25oC
                //RS485_TxD=1;
                //printf( ">BMS:%c.%c.%c.%c.%c!<",bts_stt_rtc.ac_vol,bts_stt_rtc.dc_vol>>8,bts_stt_rtc.dc_vol,(bts_stt_rtc.gate<<2)+(bts_stt_rtc.smoke<<1)+bts_stt_rtc.water,123);
            }
            else if((bts_stt_rtc.Int_Sensor.temp<=250)&&(Relay2==1)) Relay2=0;
            
            //Neu phat hien TEMP>60oC
            if((bts_stt_rtc.Int_Sensor.temp>600)&&(Relay5==0))// Neu phat hien TEMP>60oC lan dau tien  
            {
                Relay5=1;
                //Phat di canh bao TEMP>60oC
                //RS485_TxD=1;
                //printf( ">BMS:%c.%c.%c.%c.%c!<",bts_stt_rtc.ac_vol,bts_stt_rtc.dc_vol>>8,bts_stt_rtc.dc_vol,(bts_stt_rtc.gate<<2)+(bts_stt_rtc.smoke<<1)+bts_stt_rtc.water,123);
            }
            else if((bts_stt_rtc.Int_Sensor.temp<=600)&&(Relay5==1)) Relay5=0; 
            
            //Neu phat hien Humi>80.0%RH
            if((bts_stt_rtc.Int_Sensor.humi>800)&&(Relay3==0))// Neu phat hien Humi>80.0%RH lan dau tien  
            {
                Relay3=1;
                //Phat di canh bao TEMP>60oC
                //RS485_TxD=1;
                //printf( ">BMS:%c.%c.%c.%c.%c!<",bts_stt_rtc.ac_vol,bts_stt_rtc.dc_vol>>8,bts_stt_rtc.dc_vol,(bts_stt_rtc.gate<<2)+(bts_stt_rtc.smoke<<1)+bts_stt_rtc.water,123);
            }
            else if((bts_stt_rtc.Int_Sensor.humi<=800)&&(Relay3==1)) Relay3=0;
flag_for_update++;
}




//Ban tin tu MB
//sprintf(data_buffer,">MBS:%x.%x.%x.%x!<\r\n@%c",bts_stt_rtc.Int_Sensor.temp,bts_stt_rtc.Int_Sensor.humi,bts_stt_rtc.Ex_Sensor.temp,bts_stt_rtc.Ex_Sensor.humi,0);
char USART_DATA[50];
unsigned char index=0,have_data=0;
char *usart_p;
// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char data;
usart_status=UCSR0A;
data=UDR0;
if ((usart_status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
     //Du lieu nhan duoc tu RS485 dc luu vao mang USART_DATA[50] va se xu ly sau do 
     //if(data=='>') {have_data=1;}
     USART_DATA[index++]=data;
     if(index==49) index=0;// Gioi han ban tin < 50 ky tu        
   }
}

interrupt [USART_TXC] void usart_tx_isr(void)
{
RS485_TxD=0;   
}

//void Send_str(char *str, unsigned char length)
//{
//     while (length--) putchar(*str++);
//}

// Declare your global variables here

void main(void)
{
// Declare your local variables here
unsigned char ii;
char data_buffer[50];

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
// ADC Clock frequency: 1000.000 kHz
// ADC Voltage Reference: AVCC pin
// ADC Auto Trigger Source: ADC Stopped =>> The nay no chay mi ngon =)) (Tuan da thu 06032016)
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


delay_ms(1000);
// Global enable interrupts
#asm("sei")
//ADC1 Water
//ADC2 AC
//ADC3 DC
//printf(">ADC value: %d;%d;%d \r\n",adc_data[Water_ADC],adc_data[AC_ADC],adc_data[DC_ADC]);
//RS485_TxD=0; //pull down for receiver data
//Turn on power Smoke Sensor
Smoke_Power=1;
// 0.215V drop on diode
//In 35.6
//ADC 449
// Vin=2.19
//ADC(Vin) x k + 0.215 = 35.6
//V= ADC(Vin) x   0.07880846325167037861915367483296
//V = (int)( ADC(Vin) x 0.7881 + 2.1) 
//216V=k1 x (Vac)= k1 x 12.75
//Vac x 1.41=Vdc+Vdrop
//Vdc=ADC x k2=17.02VDC 
//V=k1 x (ADC x k2 + Vdrop)
//k1=16.94 / v2 = 11.98
//k2=0.02749596122778675282714054927302
//ADC(ac)=619  
//Vac= 11.98 x ( ADC x 0.0275 +1)
//bts_stt_rtc.dc_vol=(int)(2.2+0.7881*adc_data[DC_ADC]);
//bts_stt_rtc.ac_vol=(int)(11.98 * (1.01+0.0276*adc_data[AC_ADC]));
bts_stt_rtc.dc_vol=(int)(2.2+0.7919*adc_data[DC_ADC]); // Tinh gia tri dien ap 1 chieu
bts_stt_rtc.ac_vol=(int)(12.163 * (.2+(float)(adc_ac_volt[0])/35.503)); //Tinh gia tri dien ap xoay chieu
//RS485_TxD=1;
//delay_ms(1000);
//printf(">Volt value: %d;%d \r\n",bts_stt_rtc.dc_vol,bts_stt_rtc.ac_vol);
//RS485_TxD=0;
            if(bts_stt_rtc.dc_vol<430) Relay7=1;
            else Relay7=0; 
            if(bts_stt_rtc.ac_vol<180) Relay6=1;
            else Relay6=0;
            if(adc_data[Water_ADC]>1000) 
            {
                bts_stt_rtc.water=0;
                Relay1=0;
            }
            else 
            {
                bts_stt_rtc.water=1;
                Relay1=1;   
            }  
bts_stt_rtc.gate=1;
bts_stt_rtc.smoke=1;
//ALL_RL_ON;
//delay_ms(1000);
//ALL_RL_OFF;
usart_p=USART_DATA;
//Pull up for transmit data
RS485_TxD=1;
//Send_str("Tuan quy ngo dang ngoi o day",6);
while(usart_status&(RX_COMPLETE));
printf("\r\n>Basic Board v1 fwv1 28/02/2016\r\n");


while (1)
      { 
      // Place your code here    
      if(index>10) 
            {
                //delay_ms(10);
                RS485_TxD=1;
                printf("I'm here:%d\r\n",index);  
                index=0;
                have_data=0;   
            }  
      //Neu index>0 thi co du lieu; doc du lieu, xu ly du lieu, xu ly xong cho index=0 OK
      /*
      if(0)
      {      
      if((*usart_p=='>'))//&&(usart_p[1]=='1'))//&&(usart_p[2]=='0')&&(usart_p[3]=='1')&&(usart_p[37]=='!')&&(usart_p[36]+16*usart_p[35] ==101))  //Du lieu ve sensor tu Master Board, nhan day du, dung cu phap      
      {
            bts_stt_rtc.bts_rtc.hr=usart_p[6]+16*usart_p[5];
            bts_stt_rtc.bts_rtc.min=usart_p[8]+16*usart_p[7];
            bts_stt_rtc.bts_rtc.date=usart_p[10]+16*usart_p[9];
            bts_stt_rtc.bts_rtc.month=usart_p[12]+16*usart_p[11];
            bts_stt_rtc.bts_rtc.year=usart_p[14]+16*usart_p[13];
            bts_stt_rtc.Int_Sensor.temp=(usart_p[16]+16*usart_p[15])<<8+usart_p[18]+16*usart_p[17];
            bts_stt_rtc.Int_Sensor.humi=(usart_p[20]+16*usart_p[19])<<8+usart_p[22]+16*usart_p[21];
            bts_stt_rtc.Ex_Sensor.temp=(usart_p[24]+16*usart_p[23])<<8+usart_p[26]+16*usart_p[25];
            bts_stt_rtc.Ex_Sensor.humi=(usart_p[28]+16*usart_p[27])<<8+usart_p[30]+16*usart_p[29];   
            delay_ms(10);
            RS485_TxD=1;
            //printf("I'm here\r\n");
            printf("%s",usart_p);
            //printf( "102Sensor: %d/%d-%d/%d\r\n",bts_stt_rtc.Int_Sensor.temp,bts_stt_rtc.Int_Sensor.humi,bts_stt_rtc.Ex_Sensor.temp,bts_stt_rtc.Ex_Sensor.humi);        
            for(ii=0;ii<50;ii++)
            {
                USART_DATA[ii]=0;
            }
            index=0;//Xu ly xong du lieu ^^
      }
      else if((*usart_p=='>')&&(*(usart_p+1)=='M')&&(*(usart_p+2)=='B')&&(*(usart_p+3)=='C')&&(*(usart_p+4)=='A')&&(*(usart_p+23)=='!'))  //Du lieu ve sensor tu Master Board, nhan day du, dung cu phap
      {
            //ALL_RL_ON;   
            //Doc trang thai dieu khien
            control_stt=*(usart_p+8); 
            if(control_stt>0)  flag_for_update=1800;// Neu co lenh dieu khien AIR thi thuc hien dieu khien ngay
            //=> Neu muon tat dieu hoa??? Bit cao nhat cua byte nay phai set la 1 neu muon control, neu set la 0, coi nhu ko co nghia. Bit0 = AIR1; Bit1 = AIR2;
            //bts_stt_rtc.Int_Sensor.temp=(*(usart_p+5)<<8)+*(usart_p+7);
            //bts_stt_rtc.Int_Sensor.humi=(*(usart_p+9)<<8)+*(usart_p+11);
            //bts_stt_rtc.Ex_Sensor.temp=(*(usart_p+13)<<8)+*(usart_p+15);
            //bts_stt_rtc.Ex_Sensor.humi=(*(usart_p+17)<<8)+*(usart_p+19);    
            //delay_ms(10);
            //RS485_TxD=1;
            //printf( "Sensor: %d/%d-%d/%d\r\n",bts_stt_rtc.Int_Sensor.temp,bts_stt_rtc.Int_Sensor.humi,bts_stt_rtc.Ex_Sensor.temp,bts_stt_rtc.Ex_Sensor.humi);        
            //RS485_TxD=0;
            for(ii=0;ii<21;ii++)
            {
                USART_DATA[ii]=0;
            }
            index=0;//Xu ly xong du lieu ^^
      }
      else usart_p++;
      //RS485_TxD=1;
      //printf("AIR:%s\r\n",USART_DATA);    
      //RS485_TxD=0; 
      
      }   
       */
        if(flag_for_update>3200)// 30s update 
      {

            if(control_stt>0)
            {
//                Relay1=control_stt&0x01;
//                Relay2=control_stt&0x02; 
//                control_stt=0;
//                RS485_TxD=1;
//                printf( ">BMS:%d!<",Relay1+(Relay2<<1));        
//                RS485_TxD=0;  
            }   
            
            
            
            
            
              
            //printf(">AC : %d-%d-%d-%d-%d-%d-%d-%d-%d\r\n",adc_ac_volt[0],adc_ac_volt[1],adc_ac_volt[2],adc_ac_volt[3],adc_ac_volt[4],adc_ac_volt[5],adc_ac_volt[6],adc_ac_volt[7],adc_ac_volt[8],);
            //printf(">ADC value: %d;%d;%d \r\n",adc_data[Water_ADC],adc_data[AC_ADC],adc_data[DC_ADC]);
            //printf(">Volt value: %d;%d \r\n",bts_stt_rtc.dc_vol,bts_stt_rtc.ac_vol); 
            
            //">BMS:[ac_vol].[dc_vol_H].[dc_vol_L].[water+smoke+gate][check_sum]!<"  
            //printf( "Sensor: %d/%d-%d/%d\r\n",bts_stt_rtc.Int_Sensor.temp,bts_stt_rtc.Int_Sensor.humi,bts_stt_rtc.Ex_Sensor.temp,bts_stt_rtc.Ex_Sensor.humi);   
            
            
            
            sprintf(data_buffer,">102:%02X%02X%02X%02X%02X%04X%04X%04X%04X%02X%02X%02X!<",
            bts_stt_rtc.bts_rtc.hr,bts_stt_rtc.bts_rtc.min,
            bts_stt_rtc.bts_rtc.date,bts_stt_rtc.bts_rtc.month,bts_stt_rtc.bts_rtc.year,
            bts_stt_rtc.Ex_Sensor.humi,
            bts_stt_rtc.Ex_Sensor.temp,
            bts_stt_rtc.Int_Sensor.humi,
            bts_stt_rtc.Int_Sensor.temp,
            (bts_stt_rtc.gate<<2)+(bts_stt_rtc.smoke<<1)+bts_stt_rtc.water,60,102); 
            //sprintf(data_buffer,">102:%04x",64019);
            //RS485_TxD=1;  
            //Send_str(data_buffer,23); 
            //printf("%s",data_buffer);
             
            //printf( ">BMS:%c.%c.%c.%c.%c!<",bts_stt_rtc.ac_vol,bts_stt_rtc.dc_vol>>8,bts_stt_rtc.dc_vol,(bts_stt_rtc.gate<<2)+(bts_stt_rtc.smoke<<1)+bts_stt_rtc.water,123);        
            //RS485_TxD=0; 
            flag_for_update=0;
      }

      }
}
