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
// Define hardware
#define Relay1 PORTB.4
#define Relay2 PORTB.3
#define Relay3 PORTB.2
#define Relay4 PORTB.1
#define Relay5 PORTB.0
#define Relay6 PORTD.7
#define Relay7 PORTD.6
#define Relay8 PORTD.5
#define Relay9 PORTD.4

#define Smoke_Power PORTC.0
#define RS485_TxD PORTC.5
//#define IND_COM_OPP  DDRB.5=1;PORTB.5=0// Output Push Pull wait for send data over USART                 
//#define IND_COM_IPU   DDRB.5=0;PORTB.5=1// Input Pull Up wait for having data over USART
//#define IND_COM_PIN   PINB.5// PIN indicate data for reciver and send data
#define LG_IN_1 PIND.3
#define LG_IN_2 PIND.2

//#define LG_IN_3 PIND.6
//#define LG_IN_4 PIND.7
//#define LG_IN_5 PINB.0
//#define LG_IN_6 PINB.1
//#define LG_IN_7 PINB.2
//#define LG_IN_8 PINB.3
//#define GET_LG_STT (LG_IN_1<<7)+(LG_IN_2<<6)+(LG_IN_3<<5)+(LG_IN_4<<4)+(LG_IN_5<<3)+(LG_IN_6<<2)+(LG_IN_7<<1)+LG_IN_8
//#define GET_RL_STT (Relay1<<7)+(Relay2<<6)+(Relay3<<5)+(Relay4<<4)+(Relay5<<3)+(Relay6<<2)+(Relay7<<1)+Relay8
#define ALL_RL_ON   Relay1=1;Relay2=1;Relay3=1;Relay4=1;Relay5=1;Relay6=1;Relay7=1;Relay8=1;Relay9=1;
#define ALL_RL_OFF   Relay1=0;Relay2=0;Relay3=0;Relay4=0;Relay5=0;Relay6=0;Relay7=0;Relay8=0;Relay9=0

#define ADC_VREF_TYPE 0x40

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
}

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




char CMD[7]={0,0,0,0,0,0,0};
unsigned char index=0,process_CMD=0,have_data=0;
// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
status=UCSR0A;
data=UDR0;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
      //>r 0xBB 0x0D 0x0A: Ban tin dieu khien relay
   //>s 0x0D 0x0A: Ban tin lay trang thai IO_BOARD 
     if((have_data==1)&&(data==0x0A)) process_CMD=1;
     if(data=='>') have_data=1;//Bat dau ghi cmd
     if(have_data==1)
     {
     CMD[index++]=data;
     if(index==7) index=0;// Gioi han ban tin < 7 ky tu       
     }
   }
}

//union floatnum
//{
// float temp;
// unsigned char byte[4];
//} floatnum;
typedef struct
 {
    unsigned char sec,min,hr,day,date,month,year;
  float temp;
 }  RTC_Time;     
 
 typedef struct
{
float temp;
float humi;
} Sensor;

typedef struct
{
    RTC_Time bts_rtc;
    Sensor Int_Sensor;
    Sensor Ex_Sensor;
    unsigned char water;
    unsigned char smoke;
    unsigned char gate;
    unsigned char dc_vol;
    unsigned char ac_vol;
} BTS_RTC;
BTS_RTC bts_stt_rtc; 

// Declare your global variables here
//unsigned char LG_STT=0,LG_TEMP=0;// Trang thai cua muc logic 
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
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0A output: Disconnected
// OC0B output: Disconnected
TCCR0A=0x00;
TCCR0B=0x00;
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
TIMSK0=0x00;

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
UCSR0B=0x98;
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
// ADC Auto Trigger Source: Free Running
// Digital input buffers on ADC0: Off, ADC1: On, ADC2: On, ADC3: On
// ADC4: Off, ADC5: Off
DIDR0=0x31;
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0xA4;
ADCSRB&=0xF8;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

// Global enable interrupts
#asm("sei")
delay_ms(1000);
//Pull up for transmit data
RS485_TxD=1;
printf("\r\n>AIR Board v1 fwv1 26/02/2016\r\n");
//ADC1 Water
//ADC2 DC
//ADC3 AC
//printf(">ADC value: %d;%d;%d \r\n",read_adc(1),read_adc(2),read_adc(3));
//c=(unsigned char*)&a;
//printf("In a %x %x %x %x",*c,c[1],c[2],c[3]);
//bts_stt_rtc.water=0;
//bts_stt_rtc.smoke=0;
//printf(">IO Board v3 fwv1\r\n");
RS485_TxD=0; //pull down for receiver data
//Turn on power Smoke Sensor
Smoke_Power=1;

//IND_COM_IPU; // Wait for reciver data
//delay_ms(1000);
//while(!IND_COM_PIN);//wait for data line free
//IND_COM_OPP;// Pull Indicate PIN to GND for sending data
//printf(">IO Board v2 fwv1\r\n"); 
////Doc trang thai cac cong logic luc khoi tao
//LG_STT=GET_LG_STT;
//printf(">%c%c\r\n",GET_LG_STT,GET_RL_STT);  //">[Byte1][Byte2] \r\n"
//IND_COM_IPU; // Free line and wait for reciver data
ALL_RL_ON;
delay_ms(1000);
ALL_RL_OFF;
while (1)
      {
      // Place your code here
//      if(process_CMD)
//           {
//                //printf("%s",CMD);
//                if((CMD[0]=='>')&&(CMD[1]=='s') )  // Xu ly ban tin ">s 0x0D 0x0A" --- ban tin hoi trang thai cua IO board
//                {
//                    //Reply with status of Relays and Logics 
//                    while(!IND_COM_PIN);//wait for data line free
//                    IND_COM_OPP;// Pull Indicate PIN to GND for sending data
//                    //printf(">%c%c\r\n",GET_LG_STT,GET_RL_STT);
//                    IND_COM_IPU; // Free line and wait for reciver data
//                }
//                else if((CMD[0]=='>')&&(CMD[1]=='r'))  // Process message ">r[Byte1] 0x0D 0x0A" ; control Relays 
//                {
//                    Relay1=CMD[2]&0x80;
//                    Relay2=CMD[2]&0x40;
//                    Relay3=CMD[2]&0x20;
//                    Relay4=CMD[2]&0x10;
//                    Relay5=CMD[2]&0x8;
//                    Relay6=CMD[2]&0x4;
//                    Relay7=CMD[2]&0x2;
//                    Relay8=CMD[2]&0x1;    
//                    //Reply with status of Relays and Logics 
//                    while(!IND_COM_PIN);//wait for data line free
//                    IND_COM_OPP;// Pull Indicate PIN to GND for sending data
//                    //printf(">%c%c\r\n",GET_LG_STT,GET_RL_STT);
//                    IND_COM_IPU; // Free line and wait for reciver data
//                }
//                for(index=0;index<7;index++)
//                {
//                    CMD[index]=0;
//                } 
//                index=0;
//                process_CMD=0;
//                have_data=0;  
//           }
            
//            LG_TEMP=GET_LG_STT;        // Get current status of logics port
//            if(LG_TEMP!=LG_STT)           // compare with elder status; if diffient ; send message
//                {
//                    //Reply with status of Relays and Logics 
//                    while(!IND_COM_PIN);//wait for data line free
//                    IND_COM_OPP;// Pull Indicate PIN to GND for sending data
//                    printf(">%c%c\r\n",GET_LG_STT,GET_RL_STT);
//                    IND_COM_IPU; // Free line and wait for reciver data     
//                    
//                    LG_STT=LG_TEMP; // Update new logic status  
//                } 
      }
}
