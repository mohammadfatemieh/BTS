//Inclue USE_STDPERIPH_DRIVER, STM32F10X_HD
#include <stdio.h>
#include <stdlib.h>
#include "GPIO_STM32F10x.h"
#include "main.h"
#include <string.h>
#include "TA_Master_HW2_drivers.h"
#include <math.h>
#include "am2301.h"


char HexInCharToDec(char cdata)
      {
        char temp;    
				if((cdata>47)&&(cdata<58)) temp= (cdata-48);// 0...9
        else if((cdata>63)&&(cdata<71)) temp= (cdata-55);//A..F
				return temp;
      }
			
//SysTick IRQ Handle
//*----------------------------------------------------------------------------*/



/* Generate interrupt each 100 ms  */
void SysTick_Handler (void) 
{
	stick_timers++;
	time_to_check_sensor++;
	time_to_update_glcd++;
	//printf("Test:%d\r\n",stick_timers);
}












void USART1_IRQHandler(void)
{
	char USART1_data;
	/* RXNE handler */
  if(USART_GetITStatus(USART1, USART_IT_RXNE) != RESET)
	{
		USART1_data=(char)(USART1->DR & (uint16_t)0x01FF);
		USART1_rx_data_buff[USART1_index++]=USART1_data;
		if(USART1_data=='<') have_data=1;
		else if(USART1_data=='>') {USART1_index=1;USART1_rx_data_buff[0]='>';};
		if(USART1_index>79) {USART1_index=0;usart1_p=USART1_rx_data_buff;}// Gioi han ban tin < 50 ky tu	
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
     if(USART2_index==15) USART2_index=0;// Gioi han ban tin < 15 ky tu
     }

}
void setup_fuction(void)
{
	uint8_t stop_setup=0;
	uint8_t count_setup=0;
	uint8_t temp1=0,temp2=0,temp3=0;
	char read_keypad=0;
	char data_buffer[16];
	GLCD_Clear();
	while(stop_setup)
	{
		read_keypad=KEY4X4_GetKey();
		if((read_keypad>='0')&&(read_keypad<='9'))
			{
				if(count_setup==0)// Dat nhiet do nguong
				{
					
					if(temp1==0)
					{
						thres_temp=temp1-48;
						temp2=0;
						glcd_write_com(0x80);
						sprintf(data_buffer,"Temp:%2.1f       ",(float)(thres_temp/10));
						glcd_put_string(data_buffer);
					}
					else if(temp2==0)
					{
						thres_temp=10*thres_temp+temp2-48;
						temp3=0;
						glcd_write_com(0x80);
						sprintf(data_buffer,"Temp:2.1%f       ",(float)(thres_temp/10));
						glcd_put_string(data_buffer);
					}
					else if(temp3==0)
					{
						thres_temp=10*thres_temp+temp3-48;
						temp1=0;
						glcd_write_com(0x80);
						sprintf(data_buffer,"Temp:2.1%f       ",(float)(thres_temp/10));
						glcd_put_string(data_buffer);
					}
					
				}
		}
		//glcd_write_com(0x90);
		//glcd_put_string("Smoke OK        ");
		//glcd_write_com(0x88);
		//glcd_put_string("Water OK        ");
		//glcd_write_com(0x98);
		//glcd_put_string("Fire  OK        ");
		//printf("Request for other module data\r\n");
	}
}
//Dung de bat tang RL, stt la trang thai cua RL : stt=0xff >> ALL RL ON
void Control_Actor(uint8_t stt)
{
	uint8_t fan=0x11,air=0x80,alarm=0x33,cool_lv=0x44,check_sum=0x55;
	char data_buffer[50];
	//">MBCA[FAN_Control_Byte][AIR_Control_Byte][Alarm_Control_Byte_H][Cooling_Level_Byte][RTC_Hr][RTC_Min][RTC_Date][RTC_Month][RTC_Year][CheckSum]<"
	//Dieu khien thiet bi chay
	RS485(1);
	sprintf(data_buffer,">MBCA:%c.%c.%c.%c.%c.%c.%c.%c.%c!<@",fan,air,alarm,bts_stt_rtc.bts_rtc.hr,bts_stt_rtc.bts_rtc.min,bts_stt_rtc.bts_rtc.date,bts_stt_rtc.bts_rtc.month,bts_stt_rtc.bts_rtc.year,check_sum);// Chen so 0 vao cuoi, ky tu bao hieu het ban tin
	//USART1_SendStr_(data_buffer);
	RS485(0);
}
void GET_STT(void){
	printf("Request for other module data\r\n");
	//USART1_SendStr_(">s");
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
	glcd_write_data(bts_stt_rtc.bts_rtc.day+48);
	glcd_write_data(',');
	glcd_write_data(' ');
	glcd_write_data((bts_stt_rtc.bts_rtc.date/10)+48);
	glcd_write_data((bts_stt_rtc.bts_rtc.date%10)+48);
	glcd_write_data('/');
	glcd_write_data((bts_stt_rtc.bts_rtc.month/10)+48);
	glcd_write_data((bts_stt_rtc.bts_rtc.month%10)+48);
	glcd_write_data('/');
	glcd_write_data((bts_stt_rtc.bts_rtc.year/10)+48);
	glcd_write_data((bts_stt_rtc.bts_rtc.year%10)+48);
	
	glcd_write_com(0x92);
	glcd_write_data((bts_stt_rtc.bts_rtc.hr/10)+48);
	glcd_write_data((bts_stt_rtc.bts_rtc.hr%10)+48);
	glcd_write_data(':');
	glcd_write_data((bts_stt_rtc.bts_rtc.min/10)+48);
	glcd_write_data((bts_stt_rtc.bts_rtc.min%10)+48);
	
	glcd_write_cmd(0x8C);// Hien thi so 220
	glcd_write_data(((int)bts_stt_rtc.ac_vol/100)+48);
	glcd_write_data(((int)bts_stt_rtc.ac_vol%100)/10+48);
	glcd_write_data(((int)bts_stt_rtc.ac_vol%10)+48);
	//glcd_write_data(',');
	//glcd_write_data(((int)(10*Voltage_Input[3])%10)+48);
	
	glcd_write_cmd(0x9C);
	glcd_write_data(((int)bts_stt_rtc.dc_vol/100)+48);
	glcd_write_data(((int)bts_stt_rtc.dc_vol%100)/10+48);
	glcd_write_data(',');
	glcd_write_data(((int)bts_stt_rtc.dc_vol%10)+48);
	
	
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

	
	//printf("DS18B20 Temp: %2.3f\r\n",ds18b20_nhietdo);
	//printf("NTC2 PC0 ADCx_IN10: %d\r\n",ADC_values[0]);
	//printf("NTC1 PC1 ADCx_IN11: %d\r\n",ADC_values[1]);
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
	if(bts_stt_rtc.Int_Sensor.temp>High_Temp_Threshold)  BTS_Status|=1<<FLAG_High_Temp;
	else if(bts_stt_rtc.Int_Sensor.temp<=High_Temp_Threshold) BTS_Status &= ~(1<<FLAG_High_Temp);
	if(humi_val.ft>High_Humi_Threshold)  BTS_Status|=1<<FLAG_High_Humi;
	else if(humi_val.ft<=High_Humi_Threshold) BTS_Status &= ~(1<<FLAG_High_Humi);
	if(!(BT_STT&Dry_Gate_Is_Open)) BTS_Status|=1<<FLAG_Gate_Is_Open;
	else if(BT_STT&Dry_Gate_Is_Open) BTS_Status &= ~(1<<FLAG_Gate_Is_Open);
	if(!(BT_STT&Dry_Smoke_Is_ON)) BTS_Status|=1<<FLAG_Smoke_Is_ON;
	else if(BT_STT&Dry_Smoke_Is_ON) BTS_Status &= ~(1<<FLAG_Smoke_Is_ON);

	//Aux_RL_Control(BTS_Status);
	
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
		
		Control_Actor(Device_Control);
	}
	else if(cooling_running==1) // Cooling level 1: FAN Only
	{
		//Neu 2 quat day "Push" binh thuong
		if((FAN_Push_1.Ready_to_work==1)&&(FAN_Push_2.Ready_to_work==1)) 
		{
		//So sanh ngay xem cai nao chay roi thi chay cai kia
			if(bts_stt_rtc.bts_rtc.date<8) 														  FAN_Push_1.run=1;
			else if((bts_stt_rtc.bts_rtc.date>=15)&&(bts_stt_rtc.bts_rtc.date<22)) 	FAN_Push_1.run=1;			
			else if((bts_stt_rtc.bts_rtc.date>=8)&&(bts_stt_rtc.bts_rtc.date<15)) 	FAN_Push_2.run=1;
			else if(bts_stt_rtc.bts_rtc.date>=22) 											FAN_Push_2.run=1;
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
			if(bts_stt_rtc.bts_rtc.date<8) 														  FAN3.run=1;
			else if((bts_stt_rtc.bts_rtc.date>=15)&&(bts_stt_rtc.bts_rtc.date<22)) 	FAN3.run=1;			
			else if((bts_stt_rtc.bts_rtc.date>=8)&&(bts_stt_rtc.bts_rtc.date<15)) 	FAN4.run=1;
			else if(bts_stt_rtc.bts_rtc.date>=22) 											FAN4.run=1;
		}//Neu chi 1 trong 2 quat hut chay
		else if(FAN3.Ready_to_work==0) // Quat 3 hong, ko lap
		{
			FAN4.run=1;// Bat quat 4
		}
		else if(FAN4.Ready_to_work==0) // Quat 4 hong, ko lap
		{
			FAN3.run=1;// Bat quat 3
		}
		Control_Actor(Device_Control);
	}
	else if(cooling_running==2) // Cooling level 2: FAN and Air Condition
	{
		//Neu 2 quat day "Push" binh thuong
		if((FAN_Push_1.Ready_to_work==1)&&(FAN_Push_2.Ready_to_work==1)) 
		{
		//So sanh ngay xem cai nao chay roi thi chay cai kia
			if(bts_stt_rtc.bts_rtc.date<8) 														  FAN_Push_1.run=1;
			else if((bts_stt_rtc.bts_rtc.date>=15)&&(bts_stt_rtc.bts_rtc.date<22)) 	FAN_Push_1.run=1;			
			else if((bts_stt_rtc.bts_rtc.date>=8)&&(bts_stt_rtc.bts_rtc.date<15)) 	FAN_Push_2.run=1;
			else if(bts_stt_rtc.bts_rtc.date>=22) 											FAN_Push_2.run=1;
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
			if(bts_stt_rtc.bts_rtc.date<8) 														  FAN3.run=1;
			else if((bts_stt_rtc.bts_rtc.date>=15)&&(bts_stt_rtc.bts_rtc.date<22)) 	FAN3.run=1;			
			else if((bts_stt_rtc.bts_rtc.date>=8)&&(bts_stt_rtc.bts_rtc.date<15)) 	FAN4.run=1;
			else if(bts_stt_rtc.bts_rtc.date>=22) 											FAN4.run=1;
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
			if(bts_stt_rtc.bts_rtc.date<8) 														  AIR_CON1.run=1;
			else if((bts_stt_rtc.bts_rtc.date>=15)&&(bts_stt_rtc.bts_rtc.date<22)) 	AIR_CON1.run=1;			
			else if((bts_stt_rtc.bts_rtc.date>=8)&&(bts_stt_rtc.bts_rtc.date<15)) 	AIR_CON2.run=1;
			else if(bts_stt_rtc.bts_rtc.date>=22) 											AIR_CON2.run=1;
		}//Neu chi 1 trong 2 dieu hoa chay
		else if(AIR_CON1.Ready_to_work==0) // Quat 3 hong, ko lap
		{
			AIR_CON2.run=1;// Bat dieu hoa 2
		}
		else if(AIR_CON2.Ready_to_work==0) // Quat 4 hong, ko lap
		{
			AIR_CON1.run=1;// Bat dieu hoa 1
		}
		Control_Actor(Device_Control);
	}
}
void Control_BTS_Station(void)
{
//Chay hút 1, day 1 ; hút 2, day 2 duoc chay luân phiên sau 1 tuan:
	// Nhiet do tang dan
	// Neu nhiet do tang > 25oC thi bat che do COOLING
	// Neu nhiet do giam duoi 23oC thi tat COOLING
	if((bts_stt_rtc.Int_Sensor.temp>250)&&(cooling_running==0))// Neu nhiet do > 25oC va chua bat che do cooling
	{
		//Update_Time();// Cap nhat thoi gian hien tai
		//Cooling_Time=rtctime;// Ghi lai thoi diem bat dau cooling
		cooling_running=1;
		cooling(1);//Starting cooling process
		printf("Cooling level 1 running\r\n");
	}
	else if((bts_stt_rtc.Int_Sensor.temp>250)&&(cooling_running==1))// Neu nhiet do > 25oC va bat che do cooling 1
	{
		//Update_Time();// Cap nhat thoi gian hien tai
		//Cooling_Time=rtctime;// Ghi lai thoi diem bat dau cooling
		cooling_running=2;
		cooling(2);//Starting cooling process
		printf("Cooling level 2 running\r\n");
	}
	else if((bts_stt_rtc.Int_Sensor.temp>250)&&(cooling_running==2))// Neu nhiet do > 25oC va bat che do cooling 1
	{
		//Update_Time();// Cap nhat thoi gian hien tai
		//Cooling_Time=rtctime;// Ghi lai thoi diem bat dau cooling
		printf("Cooling Error\r\n");
	}
	else if((bts_stt_rtc.Int_Sensor.temp<230)&&(cooling_running>0))// Neu nhiet do < 23oC va dang bat che do cooling
	{
		cooling_running=0;
		cooling(0);// Turn off cooling system
		printf("Cooling system stop\r\n");
	}

}

int main(void)
{
	//uint32_t timeout=6500;
	char keyp=0;
	uint8_t usart_count;
	//TM_AM2301_Data_t data;
	
	//uint8_t i,ddata[5] = {0};     /* dht11 data container */
	//Ngoai vi gom co
	//Cam bien nhiet do do am SHT10 & AM2301
	//Thoi gian thuc DS3231
	//Ban phim ma tran 4x4
	// Man hinh GLCD 128x64
	// Truyen thong voi cac module khac qua RS485
	
	//GPIO_InitTypeDef GPIO_InitStructure;


	
	SystemCoreClockUpdate();
	
	

	GPIO_PortClock   (GPIOA, true);
	GPIO_PortClock   (GPIOB, true);

	KeyPad4x4_Init();
	GLCD_GPIO_init();
	GLCD_INIT_();
	GLCD_BL(1);
	glcd_test();
	
	USART1_Init();
	USART2_Init();
	USER_UART_NVIC();
	
	
	printf(">Master Board HWv3 fwv1 24/01/2016\r\n");
	

	USER_I2C_Init();
	DS3231_init();

	EEPROM_init();
	TM_AM2301_Init();
	delay_ms(1000);
	GLCD_Clear();
	Delay(10);
	GLCD_CONST_DATA();

	

	
	/* Kiem tra cac thiet bi trong tram BTS*/
	Device_Init();
	Update_BTS_Sensor();
	
	/* Setup SysTick Timer for 100 millisec interrupts, also enables Systick and Systick-Interrupt */
	SysTick_Config(SystemCoreClock/10);      /* Generate interrupt each 100 ms  */
	USART1_index=0;
	usart1_p=USART1_rx_data_buff;

		while(1)
			{
				

				if(time_to_check_sensor>400)//600= 1 Phut
				{
					
					Update_BTS_Sensor();
					time_to_check_sensor=0;					
				}
				if(stick_timers>1200) //1200= 2 phut
				{
					//printf("Mot phut nhe\r\n");
					//Sau 1 khoang thoi gian goi ham nay de dieu chinh che do hoat dong
					//Cap nhat trang thai lam mat Cooling mode
					//Control_BTS_Station();
					stick_timers=0;
					printf("Hi\r\n");

				}	
				if(time_to_update_glcd==120)
					{
						GLCD_Hum_Temp_Update();
					}
				else if(time_to_update_glcd==230)
					{
						GLCD_RTC_Update();
						time_to_update_glcd=0;
					}


					if(have_data==1)
					{
						// Decode date,smoke,water
						if((USART1_rx_data_buff[0]=='>')&&(USART1_rx_data_buff[1]=='1')&&(USART1_rx_data_buff[2]=='0')
							&&(USART1_rx_data_buff[3]=='2')&&(USART1_rx_data_buff[37]=='!')
							&&(HexInCharToDec(usart1_p[36]) +  (HexInCharToDec(usart1_p[35])<<4)==102))
						{
							
							bts_stt_rtc.gate      = HexInCharToDec(usart1_p[32]) +  (HexInCharToDec(usart1_p[31])<<4);// Decode data and save
							bts_stt_rtc.smoke 		= 0x01&(bts_stt_rtc.gate>>1);
							bts_stt_rtc.water 		= 0x01&bts_stt_rtc.gate;
							bts_stt_rtc.gate      = 0x01&(bts_stt_rtc.gate>>2);
							printf("Trang Bi: %d-%d-%d",bts_stt_rtc.gate,bts_stt_rtc.smoke,bts_stt_rtc.water);
							for(usart_count=0;usart_count<80;usart_count++)
																		{
																		USART1_rx_data_buff[usart_count]=0;
																		}
							have_data=0;
							USART1_index=0;
						}
						//Decode AC,DC volt from basic board >302:[][][][][][302]!<
						else if((USART1_rx_data_buff[0]=='>')&&(USART1_rx_data_buff[1]=='3')&&(USART1_rx_data_buff[2]=='0')
							&&(USART1_rx_data_buff[3]=='2')&&(USART1_rx_data_buff[15]=='!')
							&&(HexInCharToDec(usart1_p[14]) +  (HexInCharToDec(usart1_p[13])<<4)==102)) 
						{
							bts_stt_rtc.ac_vol         = HexInCharToDec(usart1_p[6]) +  (HexInCharToDec(usart1_p[5])<<4);
							bts_stt_rtc.dc_vol         = ((HexInCharToDec(usart1_p[8])+(HexInCharToDec(usart1_p[7])<<4))<<8)+
																						 HexInCharToDec(usart1_p[10])+16*HexInCharToDec(usart1_p[9]);
							printf("Trang : %d-%d",bts_stt_rtc.ac_vol,bts_stt_rtc.dc_vol);
							for(usart_count=0;usart_count<80;usart_count++)
																		{
																		USART1_rx_data_buff[usart_count]=0;
																		}
							have_data=0;
							USART1_index=0;
						}
						else 
						{
							printf("Trang ngao: %d",HexInCharToDec(usart1_p[15]) +  (HexInCharToDec(usart1_p[14])<<4));
							for(usart_count=0;usart_count<80;usart_count++)
																		{
																		USART1_rx_data_buff[usart_count]=0;
																		}
							have_data=0;
							USART1_index=0;
						}
					}
					if(have_data==2)
					{
								if(*usart1_p=='>')
									//&&(HexInCharToDec(usart1_p[36]) +  (HexInCharToDec(usart1_p[35])<<4) ==102))// Process data with IO board 
								{
									if((usart1_p[1]=='1')&&(usart1_p[2]=='0')&&(usart1_p[3]=='2')&&(usart1_p[37]=='!'))
									{
										printf("Trang Bi: %d",USART1_index);
										for(usart_count=0;usart_count<50;usart_count++)
																	{
																	USART1_rx_data_buff[usart_count]=0;
																	}  
																	USART1_index=0;
																	usart1_p=USART1_rx_data_buff;
																	have_data=0;
									}
									
								}
								//else if(usart1_p<(USART1_rx_data_buff+50))usart1_p++;  //Scan for '>'
								//else usart1_p=USART1_rx_data_buff;
					}
					if(USART2_flag) 
					{
						printf("%s",USART2_rx_data_buff);
												
						if((USART2_rx_data_buff[0]=='>')&&(USART2_rx_data_buff[1]=='s'))
											{
												printf(">%c%c\r\n",BT_STT,RL_STT);
											}
						else if((USART2_rx_data_buff[0]=='>')&&(USART2_rx_data_buff[1]=='r'))
											{
												//Turn_RL(USART2_rx_data_buff[2]);
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





void Update_BTS_Sensor(void)
{
	TM_AM2301_Data_t data;
	unsigned char error_data, checksum;
	char data_buffer[50];
  
	s_connectionreset();
	
	bts_stt_rtc.bts_rtc.sec=BCD2DEC(DS3231_ReadReg(DS3231_SECOND_REG ));
	bts_stt_rtc.bts_rtc.min=BCD2DEC(DS3231_ReadReg(DS3231_MINUTE_REG ));
	bts_stt_rtc.bts_rtc.hr=BCD2DEC(DS3231_ReadReg(DS3231_HOURS_REG ));
	bts_stt_rtc.bts_rtc.day=BCD2DEC(DS3231_ReadReg(DS3231_DAY_REG ));
	bts_stt_rtc.bts_rtc.date=BCD2DEC(DS3231_ReadReg(DS3231_DATE_REG ));
	bts_stt_rtc.bts_rtc.month=BCD2DEC(DS3231_ReadReg(DS3231_MONTH_REG ));
	bts_stt_rtc.bts_rtc.year=BCD2DEC(DS3231_ReadReg(DS3231_YEAR_REG ));
	//Neu thong tin RTC sai thi sao?????
	
	error_data = 0;
  error_data +=    s_measure((uint16_t*)&humi_val.it,&checksum,Humi);
  error_data +=    s_measure((uint16_t*)&temp_val.it,&checksum,Temp);

  if(error_data != 0) {s_connectionreset();printf( "SHT10 ERROR\r\n");} //in case of an error: connection reset
  else
  {
   
		humi_val.ft = (float)humi_val.it;
		temp_val.ft = (float)temp_val.it;
		calc_sth1x(&humi_val.ft,&temp_val.ft);
	 
		bts_stt_rtc.Int_Sensor.temp=10*temp_val.ft;
		bts_stt_rtc.Int_Sensor.humi=10*humi_val.ft;
  }
	
	if (TM_AM2301_Read(&data) == TM_AM2301_OK) 
		{	
			bts_stt_rtc.Ex_Sensor.humi=data.Hum ;
			bts_stt_rtc.Ex_Sensor.temp=data.Temp ;
		}
	else { printf( "AM2301 ERROR\r\n");}
	

	//Truyen thong tin ve cam bien di cho cac module khac
	//>1XX:[hr][min][date][month][year][ex_humi_H][ex_humi_L][ex_temp_H]
	//[ex_temp_L][int_Humi_H][int_Humi_L][int_temp_H][int_temp_H][water+smoke+gate+pir+glass][alarm][check_sum]!<
	sprintf(data_buffer,">101:%02X%02X%02X%02X%02X%04X%04X%04X%04X%02X%02X%02X!<",
          bts_stt_rtc.bts_rtc.hr,bts_stt_rtc.bts_rtc.min,
	        bts_stt_rtc.bts_rtc.date,bts_stt_rtc.bts_rtc.month,bts_stt_rtc.bts_rtc.year,
	        bts_stt_rtc.Ex_Sensor.humi,
	        bts_stt_rtc.Ex_Sensor.temp,
	        bts_stt_rtc.Int_Sensor.humi,
	        bts_stt_rtc.Int_Sensor.temp,
	        (bts_stt_rtc.gate<<2)+(bts_stt_rtc.smoke<<1)+bts_stt_rtc.water,60,101);
	RS485(1);
	USART1_SendStr_(data_buffer,40);
	RS485(0);
	//printf( "Sensor: %doC-%dRH:%doC-%dRH\r\n",bts_stt_rtc.Int_Sensor.temp,bts_stt_rtc.Int_Sensor.humi,bts_stt_rtc.Ex_Sensor.temp,bts_stt_rtc.Ex_Sensor.humi);		
	//printf("%s",data_buffer);
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


