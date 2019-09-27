#include "stm32f10x.h"
#include <stdio.h>



#ifdef __GNUC__
  /* With GCC/RAISONANCE, small printf (option LD Linker->Libraries->Small printf
     set to 'Yes') calls __io_putchar() */
  #define PUTCHAR_PROTOTYPE int __io_putchar(int ch)
#else
  #define PUTCHAR_PROTOTYPE int fputc(int ch, FILE *f)
#endif

/**
  * @brief  Retargets the C library printf function to the USART.
  * @param  None
  * @retval None
  */
 PUTCHAR_PROTOTYPE
{
	/* Loop until the end of transmission */
	while (USART_GetFlagStatus(USART2, USART_FLAG_TC) == RESET){}
	/* Place your implementation of fputc here */
	/* e.g. write a character to the USART */
	USART_SendData(USART2, (uint8_t) ch);
	return ch;
}
//Delay(1) == 10ms
void Delay(__IO uint32_t num)
{
	__IO uint32_t index = 0;

	/* default system clock is 72MHz ~~~ for(index = (64000 * num); index != 0; index--)*/
	for(index = (60000 * num); index != 0; index--)
	{
	}
}

void delay_ms(__IO uint32_t num)
{
	__IO uint32_t index = 0;
	
	/* Default system clock is 72MHz */
	for(index = (6000 * num); index != 0; index--);
}

void main_delay_us(__IO uint32_t num)
{
	__IO uint32_t index = 0;
	
	/* Default system clock is 72MHz */
	for(index = (6 * num); index != 0; index--);
}

typedef struct
 {
	uint8_t sec,min,hr,day,date,month,year;
  float temp;
 }  RTC_Time;
 //Always save real time clock of station
 RTC_Time station_rtc;

 
uint8_t  gateOpenEnable =0;
 
#define   WrongPassword           0
#define   RightPassword           1

#define   StationSecurityOn       1
#define   StationSecurityOff      0
 
#define   IdleMode           0
#define   DryContactEvent    1
#define   GateOpenEvent      2
#define   Human_Login_Work   3
 
#define         GateDryInNomalHigh         GPIO_PinRead(GPIOC,0)
#define         SmokeDryInNomalLow        GPIO_PinRead(GPIOC,1)
#define         Smoke_Power(state)        GPIO_PinWrite(GPIOC, 10, state)
#define         WaterDryInNomalLow        GPIO_PinRead(GPIOC,2)
#define         PirDryInNomalLow          GPIO_PinRead(GPIOC,3)
#define         GateDryPos        0
#define         SmokeDryPos       1
#define         WaterDryPos       2
#define         PirDryPos         3
// Define hardware for AC Board
// Define hardware
uint16_t MyID =0;//
uint16_t cpu_id=0;
uint16_t checksum=0x68;
uint16_t server_checksum=0x68;
uint16_t ServerAirCmd=0;
uint16_t ServerFanCmd=0;
uint16_t server_ID=0x86;
uint16_t ProcessCmdFromServer=0;
uint16_t fan_checksum=0x24;
uint16_t DataOfFanUnit=0;
uint16_t TimesToPingFan=3;
uint16_t dcm_checksum=0x25;
uint16_t DataOfDcmUnit[8];
uint16_t TimesToPingDcm=3;
uint16_t omc_checksum=0x22;
uint16_t OmcDryContactOutputStatus=0;
uint16_t acm_checksum=0x37;
uint16_t DataOfAcmUnit[8];
uint16_t TimesToPingAcm=3;
uint16_t TimesToPingOmc=3;
uint16_t DataOfAirCon=0;
float KofMainDcVolt=1.0932;//ADC0, Cong 1
float KofDcADC1=1.078;//Port2, ADC1
float KofDcADC2=1.084;//Port3, ADC2
float KofDcADC5=0.3788;//Port 8,ADC5, 30oC ~792
float KofAuxDcAmp=0.0485;//Port 7, ADC4, MAX 5V 4.0V ~ 825ADC
float KofMainDcAmp=0.0485;//Cong 6, ADC3, MAX 5V 4.0V ~ 825ADC
float KofDcADC6=0.251;//Cong 4 kenh 6, MAX25V 15.0V ~ 598ADC
float KofDcADC7=0.250;//Port 5, ADC7 MAX25V 15.0V ~ 600ADC
uint16_t MainDcVolt=0,MainDcAmp=0, MainDcPower=0, AuxDcAmp=0;
uint16_t MainAcVolt=0, MainAcAmp=0, MainAcPower=0, MainACCosphi=0;
uint16_t DryContactInputStatus=0;

#define RS485_TxD(state) GPIO_PinWrite(GPIOA, 8, state)

//Thoi gian de kiem tra trang thai he thong
//100ms >> 1 ngat
//1s >> 10 ngat
// 1phut >> 600 ngat
// 15 phut >> 9000 ngat
uint32_t time_to_check_dry    =0;
uint32_t time_to_check_sensor =0;
uint32_t time_to_update_rtc   =0;
uint32_t time_to_update_glcd  =0;
uint32_t stick_timers         =0;
uint32_t time_to_ping         =0;
uint8_t  pingwhat             =0;
uint8_t  pingwhatED           =0;
uint8_t  enablePingModule     =1;//>>>>>>>>>>>Ping
uint8_t  enableSendToServer   =1;
uint8_t  enableUpdateGLCD     =1;
uint8_t  time_to_check_keypad =0;
uint16_t time_to_enter_passwd =0;
uint8_t  count_to_enter_passwd=0;
//Password of device
char password[6]="123456";
//buffer for enter password
char input_password[8];
//Password dung hay sai khi cua mo? 
//If gate Open, A passwork need to enter within (count_to_enter_passwd) seconds
//password_right_count : ==0 
uint8_t password_right_count=0;
uint8_t password_input_count=0;
// status security of station
uint8_t station_security=1;
//Make event every minute
uint32_t time_to_make_one_minute;
//thoi gian lam viec
uint8_t time_to_work_hour=0;//max 5h;
uint8_t time_to_work_min=15;
char input_time_work[3];
uint8_t count_input_time_to_work=0;
 //Save time work, if station_rtc==time_for_work >>>> Turn On Security Again
 RTC_Time time_for_work;
 
uint16_t sizeOfEeprom=50;
void loadDataFromEeprom (void);
void loadDefault_eeprom_value (void);
uint32_t time_to_server       =0,time_out_ping_server;
uint8_t ping_server_now,PingServerRunning,CanNotPingServer,ConnectedServer;


uint8_t GLCD_Disp_Mode=0,GLCD_Disp_Idle=0;
void  Update_BTS_Sensor(void);
void  GLCD_RTCSEN_Update(void);
void  GLCD_Volt_Update(void);
void  GLCD_Actor_Update(void);
void  GLCD_Dry_Update(void);
 

 

void Update_BTS_status(void);
void Control_BTS_Station(void);
void cooling(uint8_t stt);
uint8_t cooling_running=0;






typedef union
 {
  uint16_t it;
  float ft;
 }  value;

enum{Temp,Humi};
value humi_val, temp_val;
float dewpoint;

typedef struct
 {
	uint8_t value_of_key;//nut nao dc bam, giu
  uint8_t status_of_press;//Phim dc bam hay giu
 }  Keypad_Struct;
Keypad_Struct keypad_status;


 typedef struct
{
	RTC_Time time_running;
	uint8_t Ready_to_work;
	uint8_t Is_Avaible;
	uint8_t Port;
	uint8_t run;
} Device;

/**
* @brief  Du lieu cam bien nhiet do, do am
* @param  Dinh dang hien thi nhiet do "xx.y" ( ex: 24.1 oC ) ; Dinh dang luu : uint16_t xxy ; 000<xxy<999
* @param  Dinh dang hien thi do am "xx.y" ( ex: 80.4 RH ) ; Dinh dang luu : uint16_t xxy ; 000<xxy<999
* @retval None
*/
typedef struct
{
uint16_t temp;
uint16_t humi;
} Sensor;
Sensor temp_humi_rtc_int,temp_humi_rtc_ex;
typedef struct
{
	RTC_Time bts_rtc;
	Sensor Int_Sensor;
	Sensor Ex_Sensor;
	uint8_t water;
	uint8_t smoke;
	uint8_t gate;
	uint16_t dc_vol;
	uint8_t ac_vol;
} BTS_RTC;
//BTS_RTC bts_stt_rtc;
	
