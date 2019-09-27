//Inclue USE_STDPERIPH_DRIVER, STM32F10X_HD
#include <stdio.h>
#include <stdlib.h>
#include "GPIO_STM32F10x.h"
#include "main.h"
#include <string.h>
#include "TA_Master_HW2_drivers.h"
#include <math.h>


#define IND_COM_OPP   GPIO_PinConfigure(GPIOB, 14,GPIO_OUT_PUSH_PULL,GPIO_MODE_OUT50MHZ);GPIO_PinWrite(GPIOB,14,0)// Output Push Pull wait for send data over USART                 
#define IND_COM_IPU   GPIO_PinConfigure(GPIOB, 14,GPIO_IN_PULL_UP,GPIO_MODE_INPUT)// Input Pull Up wait for having data over USART
#define IND_COM_PIN   GPIO_PinRead(GPIOB,14) // PIN indicate data for reciver and send data


//SysTick IRQ Handle
//*----------------------------------------------------------------------------*/

//uint16_t adc_raw_val;

static uint8_t status_DMA1=0;
volatile uint16_t ADC_values[5];
volatile uint32_t status = 0;
extern volatile uint32_t Timer;		
void ADCInit(void);
void DMAInit(void);

void SysTick_Handler (void) 
{
  static uint32_t ticks=0;
	time_to_check_system++;
	time_to_update_rtc++;
  switch (ticks++) 
	{
    case  0  :  {
			ADC_GetValue();						
									//GLCD_Hum_Temp_Update();
									//Update_Time();
									//s_connectionreset();
									//SHT1x_Display();
									break;
								}
		case 10: {
			ds18b20_nhietdo=DS18B20_ReadTemp();
			break;
		}
    case  20:
		{
			SHT1x_Display();
			break;
		}
		case  50:
		{
			
			break;
		}

    case  51:  {
									GLCD_Hum_Temp_Update();
									break;
	
							}
		case  80:  {
									Update_BTS_status();
									break;
	
							}
		case  100:  {
									GLCD_Device_Update();
									break;
	
							}
		case  180:  {
									//measure_voltage(Voltage_Input);;
									break;
	
							}
		
		case  200:  {
									GLCD_RTC_Update();
									break;
	
							}
		case  280:  {
									GLCD_FLAG_Update();
									break;
	
							}
							
		
		
								
    
    default:
      if (ticks > 350)//35s 
			{
        ticks = 0;
			}
  }
}




//unsigned int i;
void SHT1x_Display(void)
{

unsigned char error_data, checksum;
  s_connectionreset();
	error_data = 0;
  error_data +=    s_measure((uint16_t*)&humi_val.it,&checksum,Humi);
  error_data +=    s_measure((uint16_t*)&temp_val.it,&checksum,Temp);

  if(error_data != 0) s_connectionreset(); //in case of an error: connection reset

  else
  {
   humi_val.ft = (float)humi_val.it;
   temp_val.ft = (float)temp_val.it;
   calc_sth1x(&humi_val.ft,&temp_val.ft);
   dewpoint = calc_dewpoint(humi_val.ft, temp_val.ft);
	 //printf("Temp int:%d \r\n", temp_val.it);
	 //printf("Humi int:%d \r\n", humi_val.it);	
   printf("SHT10 Temp:%5.1f C \r\n", temp_val.ft);
   printf("SHT10 Humi:%5.1f %%RH \r\n", humi_val.ft);
   printf("SHT10 Dewpoint : %5.1f C \r\n", dewpoint);
  }
}

/*Update_Time*/
/** 
  * @Author Tuan - 10/07/2015 
  * @brief  Read time from RTC and put to terminal
  * @param  None
  * @retval None
  */
void Update_Time(void)
{
	//uint8_t sec,min,hr,day,date,month,year,temp_ub,temp_lb;
	uint8_t temp_ub,temp_lb;
	USER_I2C_Init();
	DS3231_init();
	rtctime.sec=BCD2DEC(DS3231_ReadReg(DS3231_SECOND_REG ));
	rtctime.min=BCD2DEC(DS3231_ReadReg(DS3231_MINUTE_REG ));
	rtctime.hr=BCD2DEC(DS3231_ReadReg(DS3231_HOURS_REG ));
	rtctime.day=BCD2DEC(DS3231_ReadReg(DS3231_DAY_REG ));
	rtctime.date=BCD2DEC(DS3231_ReadReg(DS3231_DATE_REG ));
	rtctime.month=BCD2DEC(DS3231_ReadReg(DS3231_MONTH_REG ));
	rtctime.year=BCD2DEC(DS3231_ReadReg(DS3231_YEAR_REG ));
	// Read temperature inside DS3231 in format XX.xx oC
	temp_ub=DS3231_ReadReg(0x11);// Upper Byte for XX
	temp_lb=(DS3231_ReadReg(0x12))>>6;//Lower Byte for xx
	if(temp_lb==1) temp_lb=25;
	if(temp_lb==2) temp_lb=50;
	if(temp_lb==3) temp_lb=75;
	rtctime.temp=(float)temp_ub + (float)(temp_lb/100);
	printf("\n\rRTC TIME: %d:%d:%d",rtctime.hr,rtctime.min,rtctime.sec);
	printf("\n\rRTC DAY:%d %d-%d-20%d",rtctime.day,rtctime.date,rtctime.month,rtctime.year);
	printf("\n\rRTC TEMP:%d.%d\r\n",temp_ub,temp_lb);
}



uint8_t USART1_index=0,USART1_flag=0,USART1_rx_data_buff[10],have_data=0;
void USART1_IRQHandler(void)
{
	uint8_t USART1_data;
	USART1_data=(USART1->DR & (uint16_t)0x01FF);
	
	if(USART1_data=='>') have_data=1;//Bat dau ghi cmd
	if((have_data==1)&&(USART1_data==0x0A)) USART1_flag=1;
	if(have_data==1)
     {
     USART1_rx_data_buff[USART1_index++]=USART1_data;
     if(USART1_index==10) USART1_index=0;// Gioi han ban tin < 10 ky tu
     }
	
}

/** 
  * @Author Tuan - 02/04/2014 
  * @brief  USART2_IRQHandler
  * @param  None
  * @retval None
  */
uint8_t USART2_index=0,USART2_flag=0,USART2_rx_data_buff[15],right_usart2_data=0;
void USART2_IRQHandler(void)
{
	uint8_t USART2_data;
	USART2_data=(USART2->DR & (uint16_t)0x01FF);
	if(USART2_data=='>') right_usart2_data=1;//Bat dau ghi cmd
	if((right_usart2_data==1)&&(USART2_data==0x0A)) USART2_flag=1;
	if(right_usart2_data==1)
     {
     USART2_rx_data_buff[USART2_index++]=USART2_data;
     if(USART1_index==15) USART2_index=0;// Gioi han ban tin < 15 ky tu
     }

}
//Dung de bat tang RL, stt la trang thai cua RL : stt=0xff >> ALL RL ON
void Turn_RL(uint8_t stt)
{

	USART1_SendStr_(">r");
	USART1_SendChar_(stt);
	USART1_SendChar_(0x0D);
	USART1_SendChar_(0x0A);
}
void GET_STT(void){

	USART1_SendStr_(">s");
	USART1_SendChar_(0x0D);
	USART1_SendChar_(0x0A);
}

void GLCD_FLAG_Update (void)
{
	GLCD_CONST_DATA_4();
	if(BTS_Status&(1<<FLAG_Gate_Is_Open)){
	glcd_write_cmd(0x83);
	glcd_write_data('O');
	glcd_write_data('P');
	glcd_write_data('E');
	glcd_write_data('N');
	}
	if(BTS_Status&(1<<FLAG_Smoke_Is_ON)){
	glcd_write_cmd(0x93);
	glcd_write_data('D');
	glcd_write_data('e');
	glcd_write_data('t');
	glcd_write_data('e');
	glcd_write_data('c');
	glcd_write_data('t');
		glcd_write_data('e');
		glcd_write_data('d');
	}
	if(BTS_Status&(1<<FLAG_Water_Inside)){
	glcd_write_cmd(0x83);
	glcd_write_data('D');
	glcd_write_data('e');
	glcd_write_data('t');
	glcd_write_data('e');
	glcd_write_data('c');
	glcd_write_data('t');
		glcd_write_data('e');
		glcd_write_data('d');
	}
	if(BTS_Status&(1<<FLAG_Fired_Temp)){
	glcd_write_cmd(0x9B);
	glcd_write_data('D');
	glcd_write_data('e');
	glcd_write_data('t');
	glcd_write_data('e');
	glcd_write_data('c');
	glcd_write_data('t');
		glcd_write_data('e');
		glcd_write_data('d');
	}

	
}
void GLCD_RTC_Update (void)
{
	//char numberic1,numberic2,numberic3,numberic4;
		GLCD_CONST_DATA_3();
	glcd_write_cmd(0x82);
	glcd_write_data(rtctime.day+48);
	glcd_write_data(',');
	glcd_write_data(' ');
	glcd_write_data((rtctime.date/10)+48);
	glcd_write_data((rtctime.date%10)+48);
	glcd_write_data('/');
	glcd_write_data((rtctime.month/10)+48);
	glcd_write_data((rtctime.month%10)+48);
	glcd_write_data('/');
	glcd_write_data((rtctime.year/10)+48);
	glcd_write_data((rtctime.year%10)+48);
	
	glcd_write_com(0x92);
	glcd_write_data((rtctime.hr/10)+48);
	glcd_write_data((rtctime.hr%10)+48);
	glcd_write_data(':');
	glcd_write_data((rtctime.min/10)+48);
	glcd_write_data((rtctime.min%10)+48);
	
	glcd_write_cmd(0x8C);// Hien thi so 314.5
	glcd_write_data(((int)Voltage_Input[3]/100)+48);
	glcd_write_data(((int)Voltage_Input[3]%100)/10+48);
	glcd_write_data(((int)Voltage_Input[3]%10)+48);
	glcd_write_data(',');
	glcd_write_data(((int)(10*Voltage_Input[3])%10)+48);
	
	glcd_write_cmd(0x9C);
	glcd_write_data(((int)Voltage_Input[1]/10)+48);
	glcd_write_data(((int)Voltage_Input[1]%10)+48);
	glcd_write_data(',');
	glcd_write_data(((int)(10*Voltage_Input[1])%10)+48);
	
	
}
void GLCD_Device_Update (void)
{
	
	GLCD_CONST_DATA_2();
	glcd_write_cmd(0x82);
		if(FAN_Push_1.run==0){
			glcd_write_data('F');
			glcd_write_data('F');
	}
	else if(FAN_Push_1.run==1){
			glcd_write_data('N');
			glcd_write_data(' ');
	}
	
	glcd_write_cmd(0x86);
	if(FAN_Push_2.run==0){
			glcd_write_data('F');
			glcd_write_data('F');
	}
	else if(FAN_Push_2.run==1){
			glcd_write_data('N');
			glcd_write_data(' ');
	}
	
			glcd_write_com(0x92);
	if(FAN3.run==0){
			glcd_write_data('F');
			glcd_write_data('F');
	}
	else if(FAN3.run==1){
			glcd_write_data('N');
			glcd_write_data(' ');
	}
	glcd_write_com(0x96);
					if(FAN4.run==0){
			glcd_write_data('F');
			glcd_write_data('F');
	}
	else if(FAN4.run==1){
			glcd_write_data('N');
			glcd_write_data(' ');
	}
	
			glcd_write_cmd(0x8B);
	if(AIR_CON1.run==0){
			glcd_write_data('F');
			glcd_write_data('F');
	}
	else if(AIR_CON1.run==1){
			glcd_write_data('N');
			glcd_write_data(' ');
	}
			glcd_write_cmd(0x9B);
	if(AIR_CON2.run==0){
			glcd_write_data('F');
			glcd_write_data('F');
	}
	else if(AIR_CON2.run==1){
			glcd_write_data('N');
			glcd_write_data(' ');
	}
}

/**
* @brief  GLCD_Hum_Temp_Update: cap nhat gia tri nhiet do, do am, Logic Dry Contract, Relay Control len GLCD.
  * @param  
  * @param  
  * @retval None
  */
void GLCD_Hum_Temp_Update (void)
{

char numberic1,numberic2,numberic3,i;

	
	printf("DS18B20 Temp: %2.3f\r\n",ds18b20_nhietdo);
	printf("NTC2 PC0 ADCx_IN10: %d\r\n",ADC_values[0]);
	printf("NTC1 PC1 ADCx_IN11: %d\r\n",ADC_values[1]);
	GLCD_CONST_DATA();
	//Cap nhat gia tri nhiet do va do am len GLCD
			numberic1=((int)humi_val.ft)/10;
			numberic2=((int)humi_val.ft)%10;
			numberic3=(int)((int)((int)(10*humi_val.ft)%100)%10);
			glcd_write_cmd(0x85);// nhay den vi tri 0x85 cua GLCD
			glcd_write_data(numberic1 + 48);
			glcd_write_data(numberic2 + 48);
			glcd_write_data('.');
			glcd_write_data(numberic3 + 48);
			numberic1=((int)temp_val.ft)/10;//Hang chuc
			numberic2=((int)temp_val.ft)%10;//Hang don vi
			numberic3=(int)((int)((int)(10*temp_val.ft)%100)%10);//Hang phan tram
			glcd_write_com(0x95);
			glcd_write_data(numberic1 + 48);
			glcd_write_data(numberic2 + 48);
			glcd_write_data('.');
			glcd_write_data(numberic3 + 48);
			
			//CAp nhat trang thai cac cong logic va relay tu IO_Board
		if(right_data_IO==1)
			{
				glcd_write_cmd(0x8A);
				for(i=0;i<8;i++)
				{
				if((RL_STT << i) & 0x80)
				{
					glcd_write_data('1');
				}
				else 
				{
					glcd_write_data('0');
				}
				}
			}
		if(right_data_IO==1)
			{		
					glcd_write_cmd(0x9A);
					for(i=0;i<8;i++)
					{
					if((BT_STT << i) & 0x80)
					{
						glcd_write_data('1');
					}
					else 
					{
						glcd_write_data('0');
					}
					}
			}


}

/**
* @brief  Update_BTS_status: cap nhat gia tri canh bao cua tram BTS va dua canh bao ra cac Relay tuong ung.
  * @param  Dau vao la nhiet do, do am va BT_STT lay tu IO_Board
  * @param  Aux_RL_Control dieu khien cac Relay canh bao
  * @retval None
  */
void Update_BTS_status(void)
{
	if(ds18b20_nhietdo>High_Temp_Threshold)  BTS_Status|=1<<FLAG_High_Temp;
	else if(ds18b20_nhietdo<=High_Temp_Threshold) BTS_Status &= ~(1<<FLAG_High_Temp);
	if(humi_val.ft>High_Humi_Threshold)  BTS_Status|=1<<FLAG_High_Humi;
	else if(humi_val.ft<=High_Humi_Threshold) BTS_Status &= ~(1<<FLAG_High_Humi);
	if(!(BT_STT&Dry_Gate_Is_Open)) BTS_Status|=1<<FLAG_Gate_Is_Open;
	else if(BT_STT&Dry_Gate_Is_Open) BTS_Status &= ~(1<<FLAG_Gate_Is_Open);
	if(!(BT_STT&Dry_Smoke_Is_ON)) BTS_Status|=1<<FLAG_Smoke_Is_ON;
	else if(BT_STT&Dry_Smoke_Is_ON) BTS_Status &= ~(1<<FLAG_Smoke_Is_ON);

	Aux_RL_Control(BTS_Status);
	
	printf("BTS STT: %d\r\n",BTS_Status);
}
//Khoi tao trang thai lam viec cho cac thiet bi
void Device_Init(void)
{
	FAN_Push_1.Is_Avaible=1;// Co duoc lap hay ko?
	FAN_Push_1.Port=1;// Lap vao cong may?
	FAN_Push_1.Ready_to_work=1;// Co bi hong ko?
	//FAN_Push_1.time_running=0;// Thoi gian chay
	FAN_Push_1.run=0;// Trang thai chay hay ko?
	
	FAN_Push_2.Is_Avaible=1;
	FAN_Push_2.Port=2;
	FAN_Push_2.Ready_to_work=1;
	//FAN_Push_2.time_running=0;
	FAN_Push_2.run=0;
	
	FAN3.Is_Avaible=1;
	FAN3.Port=3;
	FAN3.Ready_to_work=1;
	//FAN3.time_running=0;
	FAN3.run=0;
	
	FAN4.Is_Avaible=1;
	FAN4.Port=4;
	FAN4.Ready_to_work=1;
	//FAN4.time_running=0;
	FAN4.run=0;
	
	AIR_CON1.Is_Avaible=1;
	AIR_CON1.Port=5;
	AIR_CON1.Ready_to_work=1;
	//AIR_CON1.time_running=0;
	AIR_CON1.run=0;
	
	AIR_CON2.Is_Avaible=1;
	AIR_CON2.Port=6;
	AIR_CON2.Ready_to_work=1;
	//AIR_CON2.time_running=0;
	AIR_CON2.run=0;
}
void cooling(uint8_t stt)
{
	//uint8_t device_control=0;
	//Cooling theo level
	//Cooling level 1: Chi bat quat gio
	//Cooling level 2: bat ca quat gio va dieu hoa
	//Chay cooling level 1 trong 15 phut
	//Chay cooling level 2 neu sau 15 phut nhiet do ko giam : can co 1 dai luong "cooling time"
	if(cooling_running==0) // Tat che do cooling =)) Turn All Off
	{
		//Turn_RL(0);
		FAN_Push_1.run=0;
		FAN_Push_2.run=0;
		FAN3.run=0;
		FAN4.run=0;
		AIR_CON1.run=0;
		AIR_CON2.run=0;
		
		Turn_RL(Device_Control);
	}
	else if(cooling_running==1) // Cooling level 1: FAN Only
	{
		//Neu 2 quat day "Push" binh thuong
		if((FAN_Push_1.Ready_to_work==1)&&(FAN_Push_2.Ready_to_work==1)) 
		{
		//So sanh ngay xem cai nao chay roi thi chay cai kia
			if(rtctime.date<8) 														  FAN_Push_1.run=1;
			else if((rtctime.date>=15)&&(rtctime.date<22)) 	FAN_Push_1.run=1;			
			else if((rtctime.date>=8)&&(rtctime.date<15)) 	FAN_Push_2.run=1;
			else if(rtctime.date>=22) 											FAN_Push_2.run=1;
		}//Neu chi 1 trong 2 quat "Push" chay
		else if(FAN_Push_1.Ready_to_work==0) // Quat 1 hong, ko lap
		{
			FAN_Push_2.run=1;// Bat quat 2
		}
		else if(FAN_Push_2.Ready_to_work==0) // Quat 2 hong, ko lap
		{
			FAN_Push_1.run=1;// Bat quat 1
		}
		
		//Neu 2 quat hut hut binh thuong
		if((FAN3.Ready_to_work==1)&&(FAN4.Ready_to_work==1)) 
		{
		//So sanh ngay xem cai nao chay roi thi chay cai kia
			if(rtctime.date<8) 														  FAN3.run=1;
			else if((rtctime.date>=15)&&(rtctime.date<22)) 	FAN3.run=1;			
			else if((rtctime.date>=8)&&(rtctime.date<15)) 	FAN4.run=1;
			else if(rtctime.date>=22) 											FAN4.run=1;
		}//Neu chi 1 trong 2 quat hut chay
		else if(FAN3.Ready_to_work==0) // Quat 3 hong, ko lap
		{
			FAN4.run=1;// Bat quat 4
		}
		else if(FAN4.Ready_to_work==0) // Quat 4 hong, ko lap
		{
			FAN3.run=1;// Bat quat 3
		}
		Turn_RL(Device_Control);
	}
	else if(cooling_running==2) // Cooling level 2: FAN and Air Condition
	{
		//Neu 2 quat day "Push" binh thuong
		if((FAN_Push_1.Ready_to_work==1)&&(FAN_Push_2.Ready_to_work==1)) 
		{
		//So sanh ngay xem cai nao chay roi thi chay cai kia
			if(rtctime.date<8) 														  FAN_Push_1.run=1;
			else if((rtctime.date>=15)&&(rtctime.date<22)) 	FAN_Push_1.run=1;			
			else if((rtctime.date>=8)&&(rtctime.date<15)) 	FAN_Push_2.run=1;
			else if(rtctime.date>=22) 											FAN_Push_2.run=1;
		}//Neu chi 1 trong 2 quat "Push" chay
		else if(FAN_Push_1.Ready_to_work==0) // Quat 1 hong, ko lap
		{
			FAN_Push_2.run=1;// Bat quat 2
		}
		else if(FAN_Push_2.Ready_to_work==0) // Quat 2 hong, ko lap
		{
			FAN_Push_1.run=1;// Bat quat 1
		}
		
		//Neu 2 quat hut hut binh thuong
		if((FAN3.Ready_to_work==1)&&(FAN4.Ready_to_work==1)) 
		{
		//So sanh ngay xem cai nao chay roi thi chay cai kia
			if(rtctime.date<8) 														  FAN3.run=1;
			else if((rtctime.date>=15)&&(rtctime.date<22)) 	FAN3.run=1;			
			else if((rtctime.date>=8)&&(rtctime.date<15)) 	FAN4.run=1;
			else if(rtctime.date>=22) 											FAN4.run=1;
		}//Neu chi 1 trong 2 quat hut chay
		else if(FAN3.Ready_to_work==0) // Quat 3 hong, ko lap
		{
			FAN4.run=1;// Bat quat 4
		}
		else if(FAN4.Ready_to_work==0) // Quat 4 hong, ko lap
		{
			FAN3.run=1;// Bat quat 3
		}
		//Neu 2 dieu hoa chay binh thuong
		if((AIR_CON1.Ready_to_work==1)&&(AIR_CON2.Ready_to_work==1)) 
		{
		//So sanh ngay xem cai nao chay roi thi chay cai kia
			if(rtctime.date<8) 														  AIR_CON1.run=1;
			else if((rtctime.date>=15)&&(rtctime.date<22)) 	AIR_CON1.run=1;			
			else if((rtctime.date>=8)&&(rtctime.date<15)) 	AIR_CON2.run=1;
			else if(rtctime.date>=22) 											AIR_CON2.run=1;
		}//Neu chi 1 trong 2 dieu hoa chay
		else if(AIR_CON1.Ready_to_work==0) // Quat 3 hong, ko lap
		{
			AIR_CON2.run=1;// Bat dieu hoa 2
		}
		else if(AIR_CON2.Ready_to_work==0) // Quat 4 hong, ko lap
		{
			AIR_CON1.run=1;// Bat dieu hoa 1
		}
		Turn_RL(Device_Control);
	}
}
void Control_BTS_Station(void)
{
//Chay hút 1, day 1 ; hút 2, day 2 duoc chay luân phiên sau 1 tuan:
	// Nhiet do tang dan
	// Neu nhiet do tang > 25oC thi bat che do COOLING
	// Neu nhiet do giam duoi 23oC thi tat COOLING
	if((ds18b20_nhietdo>25)&&(cooling_running==0))// Neu nhiet do > 25oC va chua bat che do cooling
	{
		//Update_Time();// Cap nhat thoi gian hien tai
		//Cooling_Time=rtctime;// Ghi lai thoi diem bat dau cooling
		cooling_running=1;
		cooling(1);//Starting cooling process
		printf("Cooling level 1 running\r\n");
	}
	else if((ds18b20_nhietdo>25)&&(cooling_running==1))// Neu nhiet do > 25oC va bat che do cooling 1
	{
		//Update_Time();// Cap nhat thoi gian hien tai
		//Cooling_Time=rtctime;// Ghi lai thoi diem bat dau cooling
		cooling_running=2;
		cooling(2);//Starting cooling process
		printf("Cooling level 2 running\r\n");
	}
	else if((ds18b20_nhietdo>25)&&(cooling_running==2))// Neu nhiet do > 25oC va bat che do cooling 1
	{
		//Update_Time();// Cap nhat thoi gian hien tai
		//Cooling_Time=rtctime;// Ghi lai thoi diem bat dau cooling
		printf("Cooling Error\r\n");
	}
	else if((ds18b20_nhietdo<23)&&(cooling_running>0))// Neu nhiet do < 23oC va dang bat che do cooling
	{
		cooling_running=0;
		cooling(0);// Turn off cooling system
		printf("Cooling system stop\r\n");
	}

}

int main(void)
{
	char keyp=0;
//	uint8_t count=1;
	//uint8_t i=0,j=0;

	
	SystemCoreClockUpdate();
	
	

	GPIO_PortClock   (GPIOA, true);
	GPIO_PortClock   (GPIOB, true);
	GPIO_PortClock   (GPIOC, true);

	
	KeyPad4x4_Init();
	USART1_Init();
	USART2_Init();
	USER_UART_NVIC();
	Aux_RL_Control(0);	
	Turn_RL(0x0);
	SHT1x_Display();
	Delay(10);
	GLCD_GPIO_init();
	
	
	//Write to DS3231
	//DS3231(sec,min,hr,day,date,month,year)
	//DS3231_Set_Time(0,40,14,6,10,7,15);
	
	
	USER_I2C_Init();
	DS3231_init();
	EEPROM_init();

//	printf("EEPROM_WriteReg(0x01,11):%d\r\n",EEPROM_WriteReg(0x01,9));
//	printf("EEPROM_WriteReg(0x01,11):%d\r\n",EEPROM_WriteReg(0x02,8));
//	printf("EEPROM_WriteReg(0x01,11):%d\r\n",EEPROM_WriteReg(0x03,7));
//	printf("EEPROM_WriteReg(0x01,11):%d\r\n",EEPROM_WriteReg(0x04,6));
//	printf("EEPROM_WriteReg(0x01,11):%d\r\n",EEPROM_WriteReg(0x05,5));
//	printf("EEPROM_WriteReg(0x01,11):%d\r\n",EEPROM_WriteReg(0x06,4));
//	//printf("Write:%d\r\n",EEPROM_W_Regs(1,12,"Ngo Quy TUan"));
//	printf("EEPROM 0x00: %d\r\n",EEPROM_ReadReg(0));
//	printf("EEPROM 0x01: %d\r\n",EEPROM_ReadReg(1));
//	printf("EEPROM 0x02: %d\r\n",EEPROM_ReadReg(2));
//	printf("EEPROM 0x03: %d\r\n",EEPROM_ReadReg(3));
//	printf("EEPROM 0x04: %d\r\n",EEPROM_ReadReg(4));
//	printf("EEPROM 0x05: %d\r\n",EEPROM_ReadReg(5));
//	printf("EEPROM 0x06: %d\r\n",EEPROM_ReadReg(6));
//	printf("EEPROM 0x07: %d\r\n",EEPROM_ReadReg(7));
	Update_Time();
	//glcd_init();
	GLCD_INIT_();
	GLCD_BL(1);
	glcd_test();
	Delay(100);
	GLCD_Clear();
	Delay(10);
	GLCD_CONST_DATA();

	
	DS18B20_Config(15,50,DS18B20_12BIT_RES);
	USER_ADC_Init();
	DMAInit();
	DMA_Cmd(DMA1_Channel1, ENABLE);
	TIM_Config();
	
	keyp=KEY4X4_GetKey();
	
	Delay(10);
	measure_voltage(Voltage_Input);
	printf("Voltage 1: %2.1f\r\n",Voltage_Input[1]);
	printf("Voltage 2: %2.1f\r\n",Voltage_Input[2]);
	printf("Voltage 3: %3.1F\r\n",Voltage_Input[3]);
	printf("Voltage 4: %3.1f\r\n",Voltage_Input[4]);
	printf(">Master Board HWv2 fwv1\r\n");
	Device_Init();
	/* Setup SysTick Timer for 100 millisec interrupts, also enables Systick and Systick-Interrupt */
	SysTick_Config(SystemCoreClock/10);      /* Generate interrupt each 100 ms  */
		while(1)
			{
				if(time_to_update_rtc>600)// 1 Phut
				{
					Update_Time();
					time_to_update_rtc=0;
					measure_voltage(Voltage_Input);
				}
				if(time_to_check_system>1200) // 2 phut
				{
					//printf("Mot phut nhe\r\n");
					//Sau 1 khoang thoi gian goi ham nay de dieu chinh che do hoat dong
					Control_BTS_Station();
					time_to_check_system=0;
				}					
				if(right_data_IO==0)
					{
						GET_STT();
						//If NOT respond????
					}

					if(USART1_flag)// Process data with IO board 
					{
						if(USART1_rx_data_buff[0]=='>')
											{
												printf("LG:%d-RL:%d\r\n",USART1_rx_data_buff[1],USART1_rx_data_buff[2]);
												BT_STT=USART1_rx_data_buff[1];
												RL_STT=USART1_rx_data_buff[2];
												right_data_IO=1;
												GLCD_Hum_Temp_Update();
											}
						
						//printf("%s",USART1_rx_data_buff);
						
						for(USART1_index=0;USART1_index<10;USART1_index++)
						{
								USART1_rx_data_buff[USART1_index]=0;
						}
						USART1_flag=0;
						USART1_index=0;	
						have_data=0;  						
					}
					
					if(USART2_flag) 
					{
						//printf("%s",USART2_rx_data_buff);
												
						if((USART2_rx_data_buff[0]=='>')&&(USART2_rx_data_buff[1]=='s'))
											{
												printf(">%c%c\r\n",BT_STT,RL_STT);
											}
						else if((USART2_rx_data_buff[0]=='>')&&(USART2_rx_data_buff[1]=='r'))
											{
												Turn_RL(USART2_rx_data_buff[2]);
												printf(">%c%c\r\n",BT_STT,RL_STT);
											}

						
						for(USART2_index=0;USART2_index<15;USART2_index++)
                {
                    USART2_rx_data_buff[USART2_index]=0;
                }
						USART2_flag=0;
						USART2_index=0;		
						right_usart2_data=0;
					}
			}
}





void DMA1_Channel1_IRQHandler(void)
{
  //Test on DMA1 Channel1 Transfer Complete interrupt
  if(DMA_GetITStatus(DMA1_IT_TC1))
  {
	  status_DMA1 =1;
   //Clear DMA1 interrupt pending bits
    DMA_ClearITPendingBit(DMA1_IT_GL1);
  }
}

void ADC_GetValue(void)
{
	ADC_SoftwareStartConvCmd(ADC1, ENABLE);
	status_DMA1 =0;
	while (!status_DMA1){};
	ADC_SoftwareStartConvCmd(ADC1, DISABLE);
}

#ifdef  USE_FULL_ASSERT

/**
  * @brief  Reports the name of the source file and the source line number
  *   where the assert_param error has occurred.
  * @param  file: pointer to the source file name
  * @param  line: assert_param error line source number
  * @retval None
  */
void assert_failed(uint8_t* file, uint32_t line)
{ 
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */

  /* Infinite loop */
  while (1)
  {
  }
}
#endif


