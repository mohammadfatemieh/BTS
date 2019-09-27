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




#define RS485(state) GPIO_PinWrite(GPIOA, 11, state)
//Nguong mac dinh
uint16_t thres_temp=250;
uint16_t thres_fire=600;
uint16_t thres_humi=800;
uint8_t  thres_ac=150;
uint16_t thres_dc=430;

//Thoi gian de kiem tra trang thai he thong
//100ms >> 1 ngat
//1s >> 10 ngat
// 1phut >> 600 ngat
// 15 phut >> 9000 ngat
uint32_t time_to_check_sensor=0;
uint32_t time_to_update_rtc=0;
uint32_t time_to_update_glcd=0;
uint32_t stick_timers=0;


uint8_t USART1_index=0,USART1_flag=0,have_data=0;
char *usart1_p,USART1_rx_data_buff[80];

void Update_BTS_Sensor(void);
//void Update_Time(void);
void GLCD_Hum_Temp_Update (void);
void GLCD_Device_Update (void);
void GLCD_RTC_Update (void);
void GLCD_FLAG_Update (void);

typedef struct
 {
	uint8_t sec,min,hr,day,date,month,year;
  float temp;
 }  RTC_Time;
 
RTC_Time rrtctime,Cooling_Time;
 
//float ds18b20_nhietdo; 
#define FLAG_High_Temp       (uint8_t)0x00
#define FLAG_High_Humi       (uint8_t)0x01
#define FLAG_Water_Inside    (uint8_t)0x02
#define FLAG_Gate_Is_Open    (uint8_t)0x03// ko nam trong basic module 
#define FLAG_Smoke_Is_ON     (uint8_t)0x04
#define FLAG_DC_Volt_Low     (uint8_t)0x05
#define FLAG_AC_Volt_Low     (uint8_t)0x06
#define FLAG_Fired_Temp      (uint8_t)0x07
 //Trang thai hoat dong cua tram BTS
 uint8_t BTS_Status;
//Trang thai cac Relay tren IO Board
 uint8_t RL_STT=0;
 // Cac trang thai cua Dry contact tren IO Board
 #define xDry_Gate_Is_Open       (uint8_t)0x01
 #define Dry_High_Humi       (uint8_t)0x02
 #define Dry_Water_Inside    (uint8_t)0x04
 #define Dry_Gate_Is_Open    (uint8_t)0x08 
 #define Dry_Smoke_Is_ON     (uint8_t)0x10
 #define Dry_DC_Volt_Low     (uint8_t)0x20
 #define Dry_AC_Volt_Low     (uint8_t)0x40
 #define Dry_Fired_Temp      (uint8_t)0x80

 //Trang thai cai cong Logic tren IO Board
 uint8_t BT_STT=0;
 //Bao co du lieu tu IO Board
 uint8_t right_data_IO=0;
const float Acquy_Generator_Volt_Threshold = 11.3; 
const float High_Temp_Threshold = 26.0;
const float Cooling_High_Temp_Threshold = 25.0;
const float Cooling_Low_Temp_Threshold = 23.0;
const float High_Humi_Threshold = 80.0;
void Update_BTS_status(void);
void Control_BTS_Station(void);
void cooling(uint8_t stt);
uint8_t cooling_running=0;

typedef struct
{
	RTC_Time time_running;
	uint8_t Ready_to_work;
	uint8_t Is_Avaible;
	uint8_t Port;
	uint8_t run;
} Device;
Device FAN_Push_1,FAN_Push_2,FAN3,FAN4,AIR_CON1, AIR_CON2;

/**
* @brief  Du lieu cam bien nhiet do, do am
* @param  Dinh dang hien thi nhiet do "xx.y" ( ex: 24.1 oC ) ; Dinh dang luu : uint16_t xxy ; 50<xxy<809
* @param  Dinh dang hien thi do am "xx.y" ( ex: 80.4 RH ) ; Dinh dang luu : uint16_t xxy ; 200<xxy<999
* @retval None
*/
typedef struct
{
uint16_t temp;
uint16_t humi;
} Sensor;

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
BTS_RTC bts_stt_rtc;
void Device_Init(void);
#define Device_Control FAN_Push_1.run<<(FAN_Push_1.Port-1)|FAN_Push_2.run<<(FAN_Push_2.Port-1)|FAN3.run<<(FAN3.Port-1)|FAN4.run<<(FAN4.Port-1)|AIR_CON1.run<<(AIR_CON1.Port-1)|AIR_CON2.run<<(AIR_CON2.Port-1)
typedef union
 {
  uint16_t it;
  float ft;
 }  value;

enum{Temp,Humi};
value humi_val, temp_val;
float dewpoint;
void SHT1x_Display(void);

void DMA1_Channel1_IRQHandler(void);


void Turn_RL(uint8_t stt);
void GET_BT(void);
void GET_RL(void);
//void Clear_IO_CmD(void);
float Voltage_Input[5];

	
