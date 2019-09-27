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
//#define IND_COM_OPP  DDRB.5=1;PORTB.5=0// Output Push Pull wait for send data over USART                 
//#define IND_COM_IPU   DDRB.5=0;PORTB.5=1// Input Pull Up wait for having data over USART
//#define IND_COM_PIN   PINB.5// PIN indicate data for reciver and send data
//2 logic port to plug dry contact sensor : smoke and gate open
#define LG_IN_1 PIND.3
#define LG_IN_2 PIND.2

#define ALL_RL_ON   Relay1=1;Relay2=1;Relay3=1;Relay4=1;Relay5=1;Relay6=1;Relay7=1;Relay8=1;Relay9=1;
#define ALL_RL_OFF   Relay1=0;Relay2=0;Relay3=0;Relay4=0;Relay5=0;Relay6=0;Relay7=0;Relay8=0;Relay9=0

//#define ADC_VREF_TYPE 0x40
#define Water_ADC 0
#define AC_ADC 1
#define DC_ADC 2
typedef struct
 {
	unsigned char sec,min,hr,day,date,month,year;
  float temp;
 }  RTC_Time;     
 
 typedef struct
{
int temp;
int humi;
} Sensor;

typedef struct
{
	RTC_Time bts_rtc;
	Sensor Int_Sensor;
	Sensor Ex_Sensor;
	unsigned char water;
	unsigned char smoke;
	unsigned char gate;
	int dc_vol;
	int ac_vol;
} BTS_RTC;
BTS_RTC bts_stt_rtc; 
//unsigned char control_stt; //luu trang thai bi dieu khien 
#define FIRST_ADC_INPUT 1
#define LAST_ADC_INPUT 3
unsigned int adc_data[LAST_ADC_INPUT-FIRST_ADC_INPUT+1];
#define ADC_VREF_TYPE 0x40
unsigned int adc_ac_volt[9];
int flag_for_update=0,flag_for_volt=0;
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
char usart_status;