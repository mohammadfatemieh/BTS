//Inclue USE_STDPERIPH_DRIVER, STM32F10X_HD
/* Includes ------------------------------------------------------------------*/
#include "eeprom.h"
#include <stdio.h>
#include <stdlib.h>
#include "GPIO_STM32F10x.h"
#include "main.h"
#include <string.h>
#include "TA_Master_HW2_drivers.h"
#include <math.h>
#include "am2301.h"
#include "vnpt.h"
/** @addtogroup EEPROM_Emulation
  * @{
  */

/* Private typedef -----------------------------------------------------------*/
/* Private define ------------------------------------------------------------*/
/* Private macro -------------------------------------------------------------*/
/* Private variables ---------------------------------------------------------*/

/* Virtual address defined by the user: 0xFFFF value is prohibited */
uint16_t VirtAddVarTab[NumbOfVar] = {0x5555, 0x6666, 0x7777};

//Device FAN_Push_1,FAN_Push_2,FAN3,FAN4,AIR_CON1, AIR_CON2;
//RTC_Time rrtctime,Cooling_Time;

uint8_t HexInCharToDec(uint8_t cdata)
      {
        uint8_t temp;    
				if((cdata>47)&&(cdata<58)) temp= (cdata-48);// 0...9
        else if((cdata>63)&&(cdata<71)) temp= (cdata-55);//A..F
				return temp;
      }
			
//SysTick IRQ Handle
//*----------------------------------------------------------------------------*/



/* Generate interrupt each 100 ms  */
void SysTick_Handler (void) 
{
//	stick_timers++;
//	time_to_check_sensor++;
//	time_to_update_glcd++;
	//printf("Test:%d\r\n",stick_timers);
}







// USART Receiver buffer
#define RX_BUFFER_SIZE0 50


uint16_t USART1_Time_Out; 
uint8_t USART1_index=0,USART1_rx_data_buff[RX_BUFFER_SIZE0];

uint8_t USART1_Time_Out_Over, USART1_Time_Out_Running,USART1_process;
void USART1_IRQHandler(void)
{
	char USART1_data;
	/* RXNE handler */
  if(USART_GetITStatus(USART1, USART_IT_RXNE) != RESET)
	{
		USART1_data=(USART1->DR & (uint16_t)0x01FF);
		//USART2_data=(USART2->DR & (uint16_t)0x01FF);
		//>> Problem : The deo nao trong mach lai co du lieu nhieu xen vao @@
		//>> Slove : Loc con me no di
		if((USART1_data>0x1F)&&(USART1_data<0x7F)) // bo loc: chi loc du lieu trong ASCII 31<data<127 T.T
		{
		USART1_Time_Out=50;// 50ms
		USART1_Time_Out_Over=0;
		USART1_Time_Out_Running=1;
		USART1_rx_data_buff[USART1_index]=USART1_data;
		USART1_index=USART1_index+1;
		if(USART1_index==RX_BUFFER_SIZE0) USART1_index=0;
		}
			
	}
//	if(USART_GetITStatus(USART1, USART_IT_TXE) != SET)
//	{
//		
//	}
}

/** 
  * @Author Tuan - 02/04/2014 
  * @brief  USART2_IRQHandler
  * @param  None
  * @retval None
  */
uint16_t USART2_Time_Out;
uint8_t USART2_index=0,USART2_rx_data_buff[RX_BUFFER_SIZE0],USART2_Time_Out_Over,USART2_Time_Out_Running,USART2_process;
void USART2_IRQHandler(void)
{
	uint8_t USART2_data;
	if(USART_GetITStatus(USART2, USART_IT_RXNE) != RESET){
	USART2_data=(USART2->DR & (uint16_t)0x01FF);
	USART2_Time_Out=50;// 50ms
	USART2_Time_Out_Over=0;
	USART2_Time_Out_Running=1;
	USART2_rx_data_buff[USART2_index++]=USART2_data;
	if(USART2_index==RX_BUFFER_SIZE0) USART2_index=0;
	}

}


uint32_t Wait_Time_Out;
uint16_t Wait_Running,Wait_Time_Out_Over,Wait_process;
void TIM2_IRQHandler(void)
{
 
		//1ms
		if (TIM_GetITStatus(TIM2, TIM_IT_Update) != RESET)
		{
				TIM_ClearITPendingBit(TIM2, TIM_IT_Update);
			
			time_to_check_dry++;
			stick_timers++;
			time_to_check_sensor++;
			time_to_update_glcd++;
			time_to_enter_passwd++;
			//Make one minute event
			time_to_make_one_minute++;
			//Check KeyPad
			time_to_check_keypad++;
			//--------------------------------------------------------------------------------------//
			time_to_ping++;
			if((time_to_ping==1000)&&(enablePingModule))//check cac module chuc nang
			{
				pingwhat++;//ping don vi tiep theo
				pingwhatED=0;//Cho phep gui lenh ping 1 lan
				time_to_ping=0;
				if(pingwhat>4) pingwhat=1;
			}
			//--------------------------------------------------------------------------------------//
			//Khoang thoi gian ket noi len server : time_to_server (ms)
			time_to_server++;
			if(time_to_server==10000)//10s,1 phut, ping server 1 lan de gui du lieu, time out 30s
			{
				time_to_server=0;
				ping_server_now=1;
			}
			
			if(PingServerRunning==1)
			{
				time_out_ping_server--;
				if(time_out_ping_server==0) {CanNotPingServer=1;PingServerRunning=0;}
			}
//			if(Wait_Running==1)
//			{
//				Wait_Time_Out--;
//				if(Wait_Time_Out==0) Wait_Time_Out_Over=1;
//			}
			//--------------------------------------------------------------------------------------//
			//for USART2 rec time out
			if(USART2_Time_Out_Running==1)
			{
				USART2_Time_Out--;
				if(USART2_Time_Out==0) USART2_Time_Out_Over=1;
			}
			//--------------------------------------------------------------------------------------//
			//for USART1 rec time out
			if(USART1_Time_Out_Running==1)
			{
				USART1_Time_Out--;
				if(USART1_Time_Out==0) USART1_Time_Out_Over=1;
			}
    }
}

/*******************************************************************************
Noi Dung    :   Tra ve trang thai cua ban phim.
Tham Bien   :   Khong.
Tra Ve      :   0:     Neu khong co nut duoc an.
								khac 0: Gia tri cua nut an.
********************************************************************************/
void  KEY4X4_Return(void)
{
	uint8_t keypad_temp;
	keypad_temp=KEY4X4_GetKey();
	if(keypad_temp==0)
		{
			keypad_status.value_of_key=0;// Ko co phim nao dc bam
		}
	else if((keypad_temp)&&(keypad_status.value_of_key!=keypad_temp))// Co 1 phim dc bam
		{
			keypad_status.value_of_key=keypad_temp;
			keypad_status.status_of_press=0;
		}
	else if((keypad_temp)&&(keypad_status.value_of_key==keypad_temp))// Co 1 phim dc giu
		{
			keypad_status.value_of_key=keypad_temp;
			keypad_status.status_of_press=1;
		}
	//keypad_status
}

/**
* @brief  GLCD_Event_Update: cap nhat cac canh bao nguy hiem len GLCD.
  * @param  
  * @param  
  * @retval None
  */
void  GLCD_Event_Update(void)
{
	// Co su co nguy hiem can kiem tra ngay
	//Cap nhat man hinh LCD moi
	glcd_write_com(0x80);
	glcd_put_string("                ");
	glcd_write_com(0x90);
	glcd_put_string("                ");
	glcd_write_com(0x88);
	glcd_put_string("                ");
	glcd_write_com(0x98);
	glcd_put_string("                ");
	if(WaterDryInNomalLow)//Phat hien ngap nuoc
		{
			glcd_write_com(0x80);
			glcd_put_string("Water In Station");
		}
	if(SmokeDryInNomalLow)//Phat hien co khoi
		{
			glcd_write_com(0x90);
			glcd_put_string("Smoke In Station");
		}
//	if((!GateDryInNomalHigh)&&(!gateOpenEnable))//Phat hien mo cua
//		{
//			glcd_write_com(0x88);
//			glcd_put_string(" Gate is Opened ");
//			//Neu cua mo, bat nhap password >> Man hinh nhap password
//			//Luu thoi gian xay ra su kien lan dau tien : Suon len cua su kien, suon xuong cua su kien
//		}
		//
		//
		//Kiem tra lai trang thai cua tram
//	DryContactInputStatus=(SmokeDryInNomalLow<<1)+(WaterDryInNomalLow<<2)+(PirDryInNomalLow<<3);
//					if(!DryContactInputStatus)
//					{
//						// Ko co su co, tro lai binh thuong
//						GLCD_Disp_Mode=IdleMode;
//					}		
}

/**
* @brief  GLCD_Gate_Check: Xu ly cua mo.
  * @param  Enter passwork to disable Alarm
  * @param  
  * @retval None
  */
void  GLCD_Gate_Check(void)
{
	// Enter passwork to disable Alarm
	enableUpdateGLCD=0;
	password_right_count=WrongPassword;
	password_input_count=0;
	time_to_enter_passwd=0;
	count_to_enter_passwd=30;//30s, neu ko nhap se bao dong
	//Cap nhat man hinh LCD moi
	glcd_write_com(0x80);
	glcd_put_string("Enter password  ");
	glcd_write_com(0x90);
	glcd_put_string("                ");
	glcd_write_com(0x88);
	glcd_put_string("A: confirm      ");
	glcd_write_com(0x98);
	glcd_put_string("B: clear        ");
	glcd_write_com(0x90);
}

/**
* @brief  GLCD_Login: Ky thuat vien nhap thong tin.
  * @param  
  * @param  Tat che do an ninh trong vai phut
  * @retval None
  */
void  GLCD_Login(void)
{
	time_to_work_hour=0;
	time_to_work_min=2;
	// Sau khi nhap password, ky thuat vien nhap cach lam viec
	enableUpdateGLCD=0;
	count_input_time_to_work=0;
	//Cap nhat man hinh LCD moi
	glcd_write_com(0x80);
	glcd_put_string(" Welcome human  ");
	glcd_write_com(0x88);
	glcd_put_string("A: Up B: Down   ");
	glcd_write_com(0x98);
	glcd_put_string("C: Confirm      ");
	glcd_write_com(0x90);
	glcd_put_string("Work time:");
	glcd_write_data(time_to_work_hour+48);
	glcd_write_data('h');
	glcd_write_data(time_to_work_min/10+48);
	glcd_write_data(time_to_work_min%10+48);
	glcd_write_data('m');
	glcd_write_com(0x95);
	//----------------------------------------------------------
	//Calculator time work : Default
	//Tat che do bao mat trong vai phut
	
					// Sync with real time clock
					time_for_work.min=station_rtc.min + time_to_work_min;
					//tinh toan lai thoi gian neu >60
					if(time_for_work.min>60) 
					{
						time_for_work.min=time_for_work.min-60;
						time_to_work_hour++;
					}
					time_for_work.hr=station_rtc.hr + time_to_work_hour;
					if(time_for_work.hr>23) 
					{
						//time_for_work.hr=23;//ko cho phep lam viec qua 24 =))
						time_for_work.hr=time_for_work.hr-24;
					}
					//station_security=StationSecurityOff;//=> check every minute to turn on security
					time_to_make_one_minute=0;
					//load default 
					input_time_work[0]=time_to_work_hour+48;
					input_time_work[1]=time_to_work_min/10+48;
					input_time_work[2]=time_to_work_min%10+48;
					//printf("Hr:%d,Min:%d",time_for_work.hr,time_for_work.min);
}
/**
* @brief  GLCD_RTCSEN_Update: cap nhat gia tri nhiet do, do am, rtc len GLCD.
  * @param  
  * @param  
  * @retval None
  */
void  GLCD_RTCSEN_Update(void)
{
	char numberic1,numberic2,numberic3;
	GLCD_CONST_RTCSEN();
	glcd_write_cmd(0x82);
	glcd_write_data(station_rtc.day+48);
	glcd_write_data(',');
	glcd_write_data(' ');
	glcd_write_data((station_rtc.date/10)+48);
	glcd_write_data((station_rtc.date%10)+48);
	glcd_write_data('/');
	glcd_write_data((station_rtc.month/10)+48);
	glcd_write_data((station_rtc.month%10)+48);
	glcd_write_data('/');
	glcd_write_data((station_rtc.year/10)+48);
	glcd_write_data((station_rtc.year%10)+48);
	
	glcd_write_com(0x92);
	glcd_write_data((station_rtc.hr/10)+48);
	glcd_write_data((station_rtc.hr%10)+48);
	glcd_write_data(':');
	glcd_write_data((station_rtc.min/10)+48);
	glcd_write_data((station_rtc.min%10)+48);
	
	//Cap nhat gia tri nhiet do va do am len GLCD
			glcd_write_cmd(0x89);// nhay den vi tri 0x89 cua GLCD
			numberic1=((int)temp_val.ft)/10;//Hang chuc
			numberic2=((int)temp_val.ft)%10;//Hang don vi
			numberic3=(int)((int)((int)(10*temp_val.ft)%100)%10);//Hang phan tram
			glcd_write_data(numberic1 + 48);
			glcd_write_data(numberic2 + 48);
			glcd_write_data('.');
			glcd_write_data(numberic3 + 48);
			glcd_write_data('o');
			glcd_write_data('C');
			glcd_write_data(' ');
			
			numberic1=((int)humi_val.ft)/10;
			numberic2=((int)humi_val.ft)%10;
			numberic3=(int)((int)((int)(10*humi_val.ft)%100)%10);
			
			glcd_write_data(numberic1 + 48);
			glcd_write_data(numberic2 + 48);
			glcd_write_data('.');
			glcd_write_data(numberic3 + 48);
			
			glcd_write_com(0x99);
			numberic1=temp_humi_rtc_ex.temp/100;//Hang chuc
			numberic2=(temp_humi_rtc_ex.temp/10)%10;//Hang don vi
			numberic3=(int)((int)(temp_humi_rtc_ex.temp)%10);//Hang phan tram
			glcd_write_data(numberic1 + 48);
			glcd_write_data(numberic2 + 48);
			glcd_write_data('.');
			glcd_write_data(numberic3 + 48);
			glcd_write_data('o');
			glcd_write_data('C');
			glcd_write_data(' ');
			
			numberic1=temp_humi_rtc_ex.humi/100;
			numberic2=((int)(temp_humi_rtc_ex.humi/10))%10;
			numberic3=(int)((int)(temp_humi_rtc_ex.humi)%10);
			
			
			glcd_write_data(numberic1 + 48);
			glcd_write_data(numberic2 + 48);
			glcd_write_data('.');
			glcd_write_data(numberic3 + 48);
			
}
void  GLCD_Volt_Update(void)
{
	
	GLCD_CONST_Volt();
	//MainDcAmp++;
	MainDcPower=(int)((MainDcVolt*MainDcAmp)/100);
	glcd_write_cmd(0x81);
	glcd_write_data(':');
	glcd_write_data((MainDcVolt/100)+48);
	glcd_write_data(((int)(MainDcVolt/10))%10+48);
	glcd_write_data(',');
	glcd_write_data(MainDcVolt%10+48);
	glcd_write_cmd(0x85);
	glcd_write_data(':');
	glcd_write_data((MainDcAmp/100)+48);
	glcd_write_data(((int)(MainDcAmp/10))%10+48);
	glcd_write_data(',');
	glcd_write_data(MainDcAmp%10+48);
	
	glcd_write_cmd(0x91);
	glcd_write_data((MainDcPower/1000)+48);
	glcd_write_data((MainDcPower%1000)/100+48);
	glcd_write_data((MainDcPower%100)/10+48);
	glcd_write_data((MainDcPower%10)+48);
	
	glcd_write_cmd(0x95);
	glcd_write_data('=');
	glcd_write_data((AuxDcAmp/100)+48);
	glcd_write_data(((int)(AuxDcAmp/10))%10+48);
	glcd_write_data(',');
	glcd_write_data(AuxDcAmp%10+48);
	
	glcd_write_cmd(0x8A);
	glcd_write_data((MainAcVolt/100)+48);
	glcd_write_data(((int)(MainAcVolt/10))%10+48);
	glcd_write_data(MainAcVolt%10+48);
	
	glcd_write_cmd(0x8D);
	glcd_write_data(':');
	glcd_write_data((MainAcAmp/100)+48);
	glcd_write_data(((int)(MainAcAmp/10))%10+48);
	glcd_write_data(',');
	glcd_write_data(MainAcAmp%10+48);
	
	glcd_write_cmd(0x99);
	glcd_write_data((MainAcPower/1000)+48);
	glcd_write_data((MainAcPower%1000)/100+48);
	glcd_write_data((MainAcPower%100)/10+48);
	glcd_write_data((MainAcPower%10)+48);
	
	glcd_write_cmd(0x9E);
	glcd_write_data('.');
	glcd_write_data(MainACCosphi/10+48);
	glcd_write_data((MainACCosphi%10)+48);

			
}

void  GLCD_Actor_Update(void)
{
	
	GLCD_CONST_Actor();
	
	glcd_write_com(0x82);
	//glcd_put_string("F1  On  F2  On  ");
	if(DataOfFanUnit&  0x01) {glcd_write_data('O');glcd_write_data('n');}
	else if((DataOfFanUnit&  0x01)==0) {glcd_write_data('O');glcd_write_data('f');glcd_write_data('f');}
	glcd_write_com(0x86);
	if((DataOfFanUnit>>1)&  0x01) {glcd_write_data('O');glcd_write_data('n');}
	else if(((DataOfFanUnit>>1)&  0x01)==0) {glcd_write_data('O');glcd_write_data('f');glcd_write_data('f');}
	glcd_write_com(0x92);
	if((DataOfFanUnit>>2)&  0x01) {glcd_write_data('O');glcd_write_data('n');}
	else if(((DataOfFanUnit>>2)&  0x01)==0) {glcd_write_data('O');glcd_write_data('f');glcd_write_data('f');}
	glcd_write_com(0x96);
	if((DataOfFanUnit>>3)&  0x01) {glcd_write_data('O');glcd_write_data('n');}
	else if(((DataOfFanUnit>>3)&  0x01)==0) {glcd_write_data('O');glcd_write_data('f');glcd_write_data('f');}
}
void  GLCD_Dry_Update(void)
{
	
	GLCD_CONST_Dry();
	
	glcd_write_com(0x82);
	if(DryContactInputStatus&  0x01) {glcd_write_data('C');}
	else if((DryContactInputStatus&  0x01)==0) {glcd_write_data('O');}
	
	glcd_write_com(0x86);
	if((DryContactInputStatus>>1)&  0x01) {glcd_write_data('C');}
	else if(((DryContactInputStatus>>1)&  0x01)==0) {glcd_write_data('O');}
	
	glcd_write_com(0x92);
	if((DryContactInputStatus>>2)&  0x01) {glcd_write_data('C');}
	else if(((DryContactInputStatus>>2)&  0x01)==0) {glcd_write_data('O');}
	
	glcd_write_com(0x96);
	if((DryContactInputStatus>>3)&  0x01) {glcd_write_data('C');}
	else if(((DryContactInputStatus>>3)&  0x01)==0) {glcd_write_data('O');}
	
	glcd_write_com(0x8A);
	if((DryContactInputStatus>>4)&  0x01) {glcd_write_data('C');}
	else if(((DryContactInputStatus>>4)&  0x01)==0) {glcd_write_data('O');}
	
	glcd_write_com(0x8E);
	if((DryContactInputStatus>>5)&  0x01) {glcd_write_data('C');}
	else if(((DryContactInputStatus>>5)&  0x01)==0) {glcd_write_data('O');}
	
	glcd_write_com(0x9A);
	if((DryContactInputStatus>>6)&  0x01) {glcd_write_data('C');}
	else if(((DryContactInputStatus>>6)&  0x01)==0) {glcd_write_data('O');}
	
	glcd_write_com(0x9E);
	if((DryContactInputStatus>>7)&  0x01) {glcd_write_data('C');}
	else if(((DryContactInputStatus>>7)&  0x01)==0) {glcd_write_data('O');}
}

/**
* @brief  Update_BTS_status: cap nhat gia tri canh bao cua tram BTS va dua canh bao ra cac Relay tuong ung.
  * @param  Dau vao la nhiet do, do am va BT_STT lay tu IO_Board
  * @param  Aux_RL_Control dieu khien cac Relay canh bao
  * @retval None
  */


void input_passwd_when_gate_open(void)
{
	//Clear and Enter Again		
	if((GLCD_Disp_Mode==GateOpenEvent)&&(keypad_status.value_of_key=='B'))//clear
				{
					password_right_count=WrongPassword;
					password_input_count=0;
					glcd_write_com(0x90);
					glcd_put_string("                ");
					glcd_write_com(0x90);
					keypad_status.value_of_key=0;
				}
			else if(GLCD_Disp_Mode==GateOpenEvent)
				{
					
					input_password[password_input_count]=keypad_status.value_of_key;
					glcd_write_data(keypad_status.value_of_key);
					//input_password[6]=0;
					//Check for right password
					if((input_password[0]==password[0])&&(input_password[1]==password[1])
						&&(input_password[2]==password[2])&&(input_password[3]==password[3])
						&&(input_password[4]==password[4])&&(input_password[5]==password[5]))
					//if(strcmp(password,input_password)==0)
							{
								//printf("Security OFF\r\n");
								enableUpdateGLCD=1;
								GLCD_Disp_Mode=Human_Login_Work;
								time_to_update_glcd=4000;
								password_right_count=RightPassword;
								station_security=StationSecurityOff;
								memset(input_password,0,6);
							}
					password_input_count++;
					if(password_input_count==6) password_input_count=0;
					keypad_status.value_of_key=0;
				}
}
//----------------------------------------------------------------------
//After login human must to enter time work
//Max : 5h45m
//Defalt: 0h15m
//After that, Security turn On
void input_time_to_work(void)
{
					if((GLCD_Disp_Mode==Human_Login_Work)&&(keypad_status.value_of_key=='C'))// confirm time to work
				{
					//Calculator time work
					time_to_work_hour=input_time_work[0]-48;
					time_to_work_min=10*(input_time_work[1]-48)-48+input_time_work[2];
					// Sync with real time clock
					time_for_work.min=station_rtc.min + time_to_work_min;
					//tinh toan lai thoi gian neu >60
					if(time_for_work.min>60) 
					{
						time_for_work.min=time_for_work.min-60;
						time_to_work_hour++;
					}
					time_for_work.hr=station_rtc.hr + time_to_work_hour;
					if(time_for_work.hr>23) 
					{
						//time_for_work.hr=23;//ko cho phep lam viec qua 24 =))
						time_for_work.hr=time_for_work.hr-24;
					}
					station_security=StationSecurityOff;//=> check every minute to turn on security
					time_to_make_one_minute=0;
					enableUpdateGLCD=1;
					GLCD_Disp_Mode=IdleMode;
					time_to_update_glcd=4000;
					//Sau thoi gian tren se khoa
					//printf("Hr:%d,Min:%d",time_for_work.hr,time_for_work.min);
				}
			else if(GLCD_Disp_Mode==Human_Login_Work)
				{
					if((count_input_time_to_work==0)&&(keypad_status.value_of_key>'5')) keypad_status.value_of_key='5';// max hour work <=5
					if((count_input_time_to_work==1)&&(keypad_status.value_of_key>'5')) keypad_status.value_of_key='5';// max min <60 =)) neu thanh nien nao co tinh nhap sai phut
					input_time_work[count_input_time_to_work]=keypad_status.value_of_key;
					glcd_write_data(keypad_status.value_of_key);
					if(count_input_time_to_work==0) glcd_write_data('h');
					count_input_time_to_work++;
					if(count_input_time_to_work==3) {count_input_time_to_work=0;glcd_write_com(0x95);}
					keypad_status.value_of_key=0;
				}
}
//-----------------------------------------------------------------------------------
void check_event (void)
{
	if(time_to_check_keypad>200)//100ms
	{
		time_to_check_keypad=0;
		//Check KeyPad
		KEY4X4_Return();
		if(keypad_status.value_of_key)//Neu co phim dc bam hoac giu
		{
			if(keypad_status.status_of_press==0)
			{
				//printf("Phim %c dc bam\r\n",keypad_status.value_of_key);
				
				
			}
			else if(keypad_status.status_of_press==1)
			{
				//printf("Phim %c dc giu\r\n",keypad_status.value_of_key);
				//Neu giu phim D thi khoa cua tro lai
				if(keypad_status.value_of_key=='D') 
					{
						password_right_count=WrongPassword;
						station_security=StationSecurityOn;//Turn on security
					}
			}
			input_passwd_when_gate_open();
			input_time_to_work();
			
		}
	}
	
	if((time_to_update_glcd>5000)&&(enableUpdateGLCD)) //5s
	{
		time_to_update_glcd=0;
		
			if     (GLCD_Disp_Mode==IdleMode)
					{
						if(GLCD_Disp_Idle==0)
						{
							GLCD_RTCSEN_Update();
							GLCD_Disp_Idle++;
						}
						else if(GLCD_Disp_Idle==1)
						{
							GLCD_Volt_Update();
							GLCD_Disp_Idle++;
						}
						else if(GLCD_Disp_Idle==2)
						{
							GLCD_Actor_Update();
							GLCD_Disp_Idle++;
							GLCD_Disp_Idle=0;//.........>>>>bo qua dry disp
						}
						else if(GLCD_Disp_Idle==3)
						{
							GLCD_Dry_Update();
							GLCD_Disp_Idle=0;
						}
						else GLCD_Disp_Idle=0;
						
					}
			else if(GLCD_Disp_Mode==DryContactEvent)
					{
						//Co 1 su kien dac biet xay ra
						GLCD_Event_Update();
						
					}
			else if(GLCD_Disp_Mode==GateOpenEvent)
					{
						//Cua mo
						GLCD_Gate_Check();
						
					}
			else if(GLCD_Disp_Mode==Human_Login_Work)
					{
						// Nhap dung password
						time_to_work_min=5;
						time_to_work_hour=0;
						//Nguoi dung nhap thoi gian lam viec
						GLCD_Login();
						
					}
	}
	//----------------------------------------------------------------------------------------
	if((GLCD_Disp_Mode==GateOpenEvent)&&(time_to_enter_passwd>1000))// Count down time to Alarm
	{
				count_to_enter_passwd--;
				if(count_to_enter_passwd==0) // Bao dong sau 1 khoang thoi gian ko nhap dung password
				{
					// Co xam nhap, bao dong
					glcd_write_com(0x80);
					glcd_put_string("  Co xam nhap!  ");
					glcd_write_com(0x90);
					//>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ALARM HERE
				}
				time_to_enter_passwd=0;
	}
	if(time_to_make_one_minute>60000) // 1 minute
	{
		time_to_make_one_minute=0;
		if((station_security==StationSecurityOff)&&(station_rtc.min==time_for_work.min)&&(station_rtc.hr==time_for_work.hr)) 
			{
				//printf("Security On Again\r\n");
				enableUpdateGLCD=1;
				station_security=StationSecurityOn;
				password_right_count=WrongPassword;
				GLCD_Disp_Mode=IdleMode;
			}
	}
	//----------------------------------------------------------------------------------/	/
	//Allow process USART data buffer			
	if(USART1_Time_Out_Over==1) 
				{
					USART1_Time_Out_Running=0;
					USART1_Time_Out_Over=0;
					USART1_process=1;
				}
	//----------------------------------------------------------------------------------/	/			
	if(USART2_Time_Out_Over==1) 
				{
					USART2_Time_Out_Running=0;
					USART2_Time_Out_Over=0;
					USART2_process=1;
				}
				
//----------------------------------------------------------------------------------/	/
				//Check Dry Contact, Security state
				if(time_to_check_dry>1000)//1s check 1 lan
				{
					time_to_check_dry=0;
					DryContactInputStatus=(SmokeDryInNomalLow<<1)+(WaterDryInNomalLow<<2)+(PirDryInNomalLow<<3);
					//if Gate is Opened
					//and Not Allow Gate Open
					//and Security ON
					if((!GateDryInNomalHigh)&&(!gateOpenEnable)&&(station_security==StationSecurityOn))// Gate Open
					{
						//printf("Cua mo");
						GLCD_Disp_Mode=GateOpenEvent;//check gate
						time_to_update_glcd=5000;
					}
					else if(DryContactInputStatus)
					{
						// Co su co nghiem trong xay ra, hien thi ngay ra LCD
						GLCD_Disp_Mode=DryContactEvent;
						//Update GLCD ngay
						time_to_update_glcd=5000;
					}
//					if(WaterDryInNomalLow==1)
//				{
//					printf("Co nuoc");
//				}
//								if(SmokeDryInNomalLow==1)
//				{
//					printf("Co khoi");
//				}
//								if(GateDryInNomalLow==1)
//				{
//					printf("Cua mo");
//				}
				}
		//----------------------------------------------------------------------------------/	/
				if(time_to_check_sensor>6666)//6.666s
				{
					//Update time, temp, humi 
					Update_BTS_Sensor();
					time_to_check_sensor=0;
									
				}
			//----------------------------------------------------------------------------------/	/
			// Send ping message to other Unit
					if((pingwhat==2)&&(pingwhatED==0))
							{
								RS485_TxD(1);
								USART1_SendStr_(">CPU0Ar25<",11);
								TimesToPingDcm--;
								//time_to_ping=0;
								RS485_TxD(0);
								pingwhatED=1;
								//pingwhat=0;
							}
					else if((pingwhat==1)&&(pingwhatED==0))
							{
								RS485_TxD(1);
								USART1_SendStr_(">CPU30r37<",11);
								TimesToPingAcm--;
								//time_to_ping=0;
								RS485_TxD(0);
								pingwhatED=1;
								//pingwhat=0;
							}
					else if((pingwhat==3)&&(pingwhatED==0))
							{
								RS485_TxD(1);
								USART1_SendStr_(">CPU201024<",12);
								TimesToPingFan--;
								//time_to_ping=0;
								RS485_TxD(0);
								pingwhatED=1;
							}//>CPU01223322<
					else if((pingwhat==4)&&(pingwhatED==0))
							{
								RS485_TxD(1);
								USART1_SendStr_(">CPU01040022<",14);
								TimesToPingOmc--;
								//time_to_ping=0;
								pingwhatED=1;
								RS485_TxD(0);
								pingwhat=0;
							}
							
			//----------------------------------------------------------------------------------/	/				
					if(ping_server_now==1)// Thoi gian ping server chinh trong ham ngat timer
						{
							ping_server_now=0;
							//printf("D001WantToConnect%02X%02X%02X",station_rtc.hr,station_rtc.min,station_rtc.sec);
							PingServerRunning=1;//Time out for ping server
							time_out_ping_server=30000;//30s
							ConnectedServer=1;
						}
					if(CanNotPingServer==1)	//Ko ping dc server, thi thoi ko gui du lieu nua
						{
							PingServerRunning=0;
							//RS485_TxD(1);
							//USART1_SendStr_("Can't connect server\r\n",25);
							//RS485_TxD(0);
							CanNotPingServer=0;							
						}
						//					if(TimesToPingDcm<2)
//					{
//						printf("Lost DCM\r\n");
//					}
//					else if(TimesToPingAcm<2)
//					{
//						printf("Lost ACM\r\n");
//					}
						//				//Time out of USART
//				if(Wait_Time_Out_Over==1) 
//				{
//					Wait_Running=0;
//					Wait_Time_Out_Over=0;
//					Wait_process=1;
//				}
//				if(Wait_process==1)
//				{
//					//GPIO_PinWrite(GPIOC, 11, 1);
//					Wait_process=0;
//				}
}
int main(void)
{

	char buff_cmd[20];
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
	GPIO_PortClock   (GPIOC, true);
	

	KeyPad4x4_Init();
	
	
	
	
	Smoke_Power(1);
//	RS485_TxD(1);
//	USART1_SendStr_(">CPU fwv1 09/04/2016\r\n",25);
//	RS485_TxD(0);	
	//printf(">CPU fwv1 09/04/2016?\r\n");
	USART1_Init();
	USART2_Init();
	USER_I2C_Init();
	DS3231_init();
	//EEPROM_init();//EX EEPROM
	GLCD_GPIO_init();
	/* Unlock the Flash Program Erase controller */
  FLASH_Unlock();
	
	EE_Init();//EEPROM STM
	
	TM_AM2301_Init();
	delay_ms(1000);
	GLCD_INIT_();
	GLCD_BL(1);
	//glcd_test();
	GLCD_Clear();
	Delay(10);
	//GLCD_CONST_DATA();
	//DS3231_Set_Time(sec,min,hr,day,date,month,year)
	//DS3231_Set_Time(0,55,11,7,4,6,16);
	//while(1);
	TIM_Config();
	

	
	/* Kiem tra cac thiet bi trong tram BTS*/

	Update_BTS_Sensor();
	
	USER_UART_NVIC();
	/* Setup SysTick Timer for 100 millisec interrupts, also enables Systick and Systick-Interrupt */
	SysTick_Config(SystemCoreClock/10);      /* Generate interrupt each 100 ms  */
	USART1_index=0;
	USART2_index=0;
	GLCD_Disp_Mode=IdleMode;
	GLCD_Disp_Idle=0;
	//EE_WriteVariable(0x0001,1234);// eeprom password
	loadDataFromEeprom();
	//GLCD_RTCSEN_Update();
	//wait(4000);
	//MainDcVolt=494;
	//MainDcAmp=337;
	//AuxDcAmp=666;
	//MainACCosphi=98;
	//MainAcPower=2271;
	//MainAcAmp=12;
	//MainAcVolt=231;
	//DryContactInputStatus=171;
	
		while(1)
			{

					check_event();


					//--------------------------------------------------------------------------------------------------------//
					if(USART1_process==1)
					{
						if((USART1_rx_data_buff[0]=='>')&&(USART1_rx_data_buff[1]=='F')&&(USART1_rx_data_buff[2]=='A')&&(USART1_rx_data_buff[3]=='N')&&(USART1_rx_data_buff[10]=='<')   
						&&(HexInCharToDec(USART1_rx_data_buff[5]) +  (HexInCharToDec(USART1_rx_data_buff[4])<<4) ==MyID) 
						&&(HexInCharToDec(USART1_rx_data_buff[9]) +  (HexInCharToDec(USART1_rx_data_buff[8])<<4) ==fan_checksum))
						{
						//printf("Oh fan\r\n");
							DataOfFanUnit=(HexInCharToDec(USART1_rx_data_buff[7])+(HexInCharToDec(USART1_rx_data_buff[6])<<4));
							TimesToPingFan=5;
						}
						else if((USART1_rx_data_buff[0]=='>')&&(USART1_rx_data_buff[1]=='D')&&(USART1_rx_data_buff[2]=='C')&&(USART1_rx_data_buff[3]=='M')&&(USART1_rx_data_buff[40]=='<')   
						&&(HexInCharToDec(USART1_rx_data_buff[5]) +  (HexInCharToDec(USART1_rx_data_buff[4])<<4) ==MyID) 
						&&(HexInCharToDec(USART1_rx_data_buff[39]) +  (HexInCharToDec(USART1_rx_data_buff[38])<<4) ==dcm_checksum))// Time out cho cai nay la bao nhieu?????????
						{
							//printf("Oh DCM\r\n");
							DataOfDcmUnit[0]=((HexInCharToDec(USART1_rx_data_buff[7])+(HexInCharToDec(USART1_rx_data_buff[6])<<4))<<8)+HexInCharToDec(USART1_rx_data_buff[9])+16*HexInCharToDec(USART1_rx_data_buff[8]);
							DataOfDcmUnit[1]=((HexInCharToDec(USART1_rx_data_buff[11])+(HexInCharToDec(USART1_rx_data_buff[10])<<4))<<8)+HexInCharToDec(USART1_rx_data_buff[13])+16*HexInCharToDec(USART1_rx_data_buff[12]);
							DataOfDcmUnit[2]=((HexInCharToDec(USART1_rx_data_buff[15])+(HexInCharToDec(USART1_rx_data_buff[14])<<4))<<8)+HexInCharToDec(USART1_rx_data_buff[17])+16*HexInCharToDec(USART1_rx_data_buff[16]);
							DataOfDcmUnit[3]=((HexInCharToDec(USART1_rx_data_buff[19])+(HexInCharToDec(USART1_rx_data_buff[18])<<4))<<8)+HexInCharToDec(USART1_rx_data_buff[21])+16*HexInCharToDec(USART1_rx_data_buff[20]);
							DataOfDcmUnit[4]=((HexInCharToDec(USART1_rx_data_buff[23])+(HexInCharToDec(USART1_rx_data_buff[22])<<4))<<8)+HexInCharToDec(USART1_rx_data_buff[25])+16*HexInCharToDec(USART1_rx_data_buff[24]);
							DataOfDcmUnit[5]=((HexInCharToDec(USART1_rx_data_buff[27])+(HexInCharToDec(USART1_rx_data_buff[26])<<4))<<8)+HexInCharToDec(USART1_rx_data_buff[29])+16*HexInCharToDec(USART1_rx_data_buff[28]);
							DataOfDcmUnit[6]=((HexInCharToDec(USART1_rx_data_buff[31])+(HexInCharToDec(USART1_rx_data_buff[30])<<4))<<8)+HexInCharToDec(USART1_rx_data_buff[33])+16*HexInCharToDec(USART1_rx_data_buff[32]);
							DataOfDcmUnit[7]=((HexInCharToDec(USART1_rx_data_buff[35])+(HexInCharToDec(USART1_rx_data_buff[34])<<4))<<8)+HexInCharToDec(USART1_rx_data_buff[37])+16*HexInCharToDec(USART1_rx_data_buff[36]);
							//printf("DCM:%d-%d-%d-%d-%d-%d-%d-%d\r\n",DataOfDcmUnit[0],DataOfDcmUnit[1],DataOfDcmUnit[2],DataOfDcmUnit[3],DataOfDcmUnit[4],DataOfDcmUnit[5],DataOfDcmUnit[6],DataOfDcmUnit[7]);
							MainDcVolt=(int)((float)DataOfDcmUnit[0]*KofMainDcVolt);
							MainDcAmp=(int)((float)DataOfDcmUnit[3]*KofMainDcAmp);
							AuxDcAmp=(int)((float)DataOfDcmUnit[4]*KofAuxDcAmp);
							TimesToPingDcm=5;
						}
						else if((USART1_rx_data_buff[0]=='>')&&(USART1_rx_data_buff[1]=='A')&&(USART1_rx_data_buff[2]=='C')&&(USART1_rx_data_buff[3]=='M')&&(USART1_rx_data_buff[40]=='<')   
						&&(HexInCharToDec(USART1_rx_data_buff[5]) +  (HexInCharToDec(USART1_rx_data_buff[4])<<4) ==MyID) 
						&&(HexInCharToDec(USART1_rx_data_buff[39]) +  (HexInCharToDec(USART1_rx_data_buff[38])<<4) ==acm_checksum))// Time out cho cai nay la bao nhieu?????????
						{
							//printf("Oh ACM\r\n");
							DataOfAcmUnit[0]=((HexInCharToDec(USART1_rx_data_buff[7])+(HexInCharToDec(USART1_rx_data_buff[6])<<4))<<8)+HexInCharToDec(USART1_rx_data_buff[9])+16*HexInCharToDec(USART1_rx_data_buff[8]);
							DataOfAcmUnit[1]=((HexInCharToDec(USART1_rx_data_buff[11])+(HexInCharToDec(USART1_rx_data_buff[10])<<4))<<8)+HexInCharToDec(USART1_rx_data_buff[13])+16*HexInCharToDec(USART1_rx_data_buff[12]);
							DataOfAcmUnit[2]=((HexInCharToDec(USART1_rx_data_buff[15])+(HexInCharToDec(USART1_rx_data_buff[14])<<4))<<8)+HexInCharToDec(USART1_rx_data_buff[17])+16*HexInCharToDec(USART1_rx_data_buff[16]);
							DataOfAcmUnit[3]=((HexInCharToDec(USART1_rx_data_buff[19])+(HexInCharToDec(USART1_rx_data_buff[18])<<4))<<8)+HexInCharToDec(USART1_rx_data_buff[21])+16*HexInCharToDec(USART1_rx_data_buff[20]);
							DataOfAcmUnit[4]=((HexInCharToDec(USART1_rx_data_buff[23])+(HexInCharToDec(USART1_rx_data_buff[22])<<4))<<8)+HexInCharToDec(USART1_rx_data_buff[25])+16*HexInCharToDec(USART1_rx_data_buff[24]);
							DataOfAcmUnit[5]=((HexInCharToDec(USART1_rx_data_buff[27])+(HexInCharToDec(USART1_rx_data_buff[26])<<4))<<8)+HexInCharToDec(USART1_rx_data_buff[29])+16*HexInCharToDec(USART1_rx_data_buff[28]);
							DataOfAcmUnit[6]=((HexInCharToDec(USART1_rx_data_buff[31])+(HexInCharToDec(USART1_rx_data_buff[30])<<4))<<8)+HexInCharToDec(USART1_rx_data_buff[33])+16*HexInCharToDec(USART1_rx_data_buff[32]);
							DataOfAcmUnit[7]=((HexInCharToDec(USART1_rx_data_buff[35])+(HexInCharToDec(USART1_rx_data_buff[34])<<4))<<8)+HexInCharToDec(USART1_rx_data_buff[37])+16*HexInCharToDec(USART1_rx_data_buff[36]);
							//printf("ACM:%d-%d-%d-%d-%d-%d-%d-%d\r\n",DataOfAcmUnit[0],DataOfAcmUnit[1],DataOfAcmUnit[2],DataOfAcmUnit[3],DataOfAcmUnit[4],DataOfAcmUnit[5],DataOfAcmUnit[6],DataOfAcmUnit[7]);
							MainAcVolt=(int)(DataOfAcmUnit[0]/19.10);
							TimesToPingAcm=5;
						}
						else if((USART1_rx_data_buff[0]=='>')&&(USART1_rx_data_buff[1]=='O')&&(USART1_rx_data_buff[2]=='M')&&(USART1_rx_data_buff[3]=='C')&&(USART1_rx_data_buff[12]=='<')   
						&&(HexInCharToDec(USART1_rx_data_buff[5]) +  (HexInCharToDec(USART1_rx_data_buff[4])<<4) ==MyID) 
						&&(HexInCharToDec(USART1_rx_data_buff[11]) +  (HexInCharToDec(USART1_rx_data_buff[10])<<4) ==omc_checksum))// Time out cho cai nay la bao nhieu?????????
						{
							//printf("Oh OMC\r\n");
							TimesToPingOmc=5;
							OmcDryContactOutputStatus=((HexInCharToDec(USART1_rx_data_buff[7])+(HexInCharToDec(USART1_rx_data_buff[6])<<4))<<8)+HexInCharToDec(USART1_rx_data_buff[9])+16*HexInCharToDec(USART1_rx_data_buff[8]);
						}
						//printf("%s",USART1_rx_data_buff);
						
						
						USART1_process=0;
						for(USART1_index=0;USART1_index<RX_BUFFER_SIZE0;USART1_index++)
                            {
                            USART1_rx_data_buff[USART1_index]=0;
                            }  
                            USART1_index=0;
					}
					//--------------------------------------------------------------------------------------------------------//
					if(USART2_process==1)
					{
						if((PingServerRunning==1)&&(USART2_rx_data_buff[0]=='O')&&(USART2_rx_data_buff[1]=='K'))// Server respond "OK"
							{
								PingServerRunning=0;
								ConnectedServer=1;
							}//>S86AAFF68<
						else if((HexInCharToDec(USART2_rx_data_buff[3]) +  (HexInCharToDec(USART2_rx_data_buff[2])<<4) ==server_ID)&&(USART2_rx_data_buff[0]=='>')&&(USART2_rx_data_buff[1]=='S')&&
							(HexInCharToDec(USART2_rx_data_buff[9]) +  (HexInCharToDec(USART2_rx_data_buff[8])<<4) ==server_checksum)&&(USART2_rx_data_buff[10]=='<'))// Server respond "OK"
							{
								ServerAirCmd=HexInCharToDec(USART2_rx_data_buff[5]) +  (HexInCharToDec(USART2_rx_data_buff[4])<<4);
								ServerFanCmd=HexInCharToDec(USART2_rx_data_buff[7]) +  (HexInCharToDec(USART2_rx_data_buff[6])<<4);
								ProcessCmdFromServer=1;
							}
							//Control from Server : FAN, Air
							// >S[Ma server = 0x01][ Control Air = 1byte ][ Control Fan = 1byte] [CheckSumByte]<
							// Giai ma lenh tu server
							// Kiem tra lenh tu server so voi trang thai hien tai cua thiet bi
							// Gui ban tin phan hoi : ping_server_now=1
						//printf("%s",USART2_rx_data_buff);
						//printf("%s",USART1_rx_data_buff);
						USART2_process=0;
						for(USART2_index=0;USART2_index<RX_BUFFER_SIZE0;USART2_index++)
                            {
                            USART2_rx_data_buff[USART2_index]=0;
                            }  
                            USART2_index=0;
					}
					//--------------------------------------------------------------------------------------------------------//
					if(ProcessCmdFromServer==1)//Xu ly ban tin tu Server
						{
							ProcessCmdFromServer=0;//Xu ly xong
							if((DataOfAirCon&0x0F)!=(ServerAirCmd&0x000F)) DataOfAirCon=ServerAirCmd&0x000F;//Send CMD to AIR Unit to Control Air Unit
							if((DataOfFanUnit&0x0F)!=(ServerFanCmd&0x000F))
								{
									DataOfFanUnit=ServerAirCmd&0x000F;// Lenh nay se xoa het trang thai cua quat
									pingwhat=3;
									pingwhatED=0;//Cap nhat lai trang trai cua quat sau khi gui lenh
									sprintf(buff_cmd,">CPU20%02X24<",(0x0F&DataOfFanUnit));// Tao lenh
									//printf("%s",buff_cmd);
									RS485_TxD(1);
									USART1_SendStr_(buff_cmd,12);
									RS485_TxD(0);	
								}
							ping_server_now=1;//Gui lai thong tin len server
						}
					//--------------------------------------------------------------------------------------------------------//
					if((ConnectedServer==1)&&(enableSendToServer))//Send data to sever
					{
						ConnectedServer=0;
						printf(">D001%04X%04X%04X%04X%04X%04X%04X%04X%04X%04X%04X%04X%04X%04X%04X%04X%04X%04X%04X<"
																				,temp_humi_rtc_int.temp,temp_humi_rtc_int.humi,temp_humi_rtc_int.temp,temp_humi_rtc_int.humi,
																				DryContactInputStatus,
																				DataOfAirCon,DataOfFanUnit,
																				OmcDryContactOutputStatus,
																				MainDcVolt,MainDcAmp, MainDcPower, AuxDcAmp,
																				MainAcVolt, MainAcAmp, MainAcPower, MainACCosphi,
																				station_rtc.hr,station_rtc.min,station_rtc.sec);
						
						
//						printf(">D001|InTe%dInHu%dExTe%dExHu%dDryIn%dAir%dFan%dOmc%dDC%dVDC%dADC%dWdc%dAAC%dVAC%dAAC%dWAC%d|H%dM%dS%d<"
//																				,temp_humi_rtc_int.temp,temp_humi_rtc_int.humi,temp_humi_rtc_int.temp,temp_humi_rtc_int.humi,
//																				DryContactInputStatus,
//																				DataOfAirCon,DataOfFanUnit,
//																				OmcDryContactOutputStatus,
//																				MainDcVolt,MainDcAmp, MainDcPower, AuxDcAmp,
//																				MainAcVolt, MainAcAmp, MainAcPower, MainACCosphi,
//																				station_rtc.hr,station_rtc.min,station_rtc.sec);
						
						
						//printf( "Sensor: %doC-%dRH:%doC-%dRH;AC:%d\r\n",temp_humi_rtc_int.temp,temp_humi_rtc_int.humi,temp_humi_rtc_int.temp,temp_humi_rtc_int.humi,MainAcVolt);
						//printf( "Time: %d-%d-%d\r\n",station_rtc.hr,station_rtc.min,station_rtc.sec);	
					}

			}
}


/*Load_data_from_EEPROM*/
/** 
  * @Author Tuan - 04/06/2016 
  * @brief  Load_data_from_EEPROM
  * @param  None
  * @retval None
  */
void loadDefault_eeprom_value (void)
{
	uint8_t i;
	EE_WriteVariable(0x0001,1234);// eeprom password
	for(i=0; i<20;i++)
	{
		EE_WriteVariable(0x0002+i,default_value_eeprom[i]);
	}
}
/*Load_data_from_EEPROM*/
/** 
  * @Author Tuan - 04/06/2016 
  * @brief  Load_data_from_EEPROM
  * @param  None
  * @retval None
  */
void loadDataFromEeprom (void)
{
	uint8_t i,j,bad_eeprom;
	uint16_t eeprom_data,eeprom_passwd=0;
	
	
	// Kiem tra gia tri cua First address 0x0000 : Size of record
	// Xem co hop le ko
	// >0 hoac <100
	EE_ReadVariable(0,&eeprom_data);
	sizeOfEeprom=eeprom_data & 0x00ff;
	if(sizeOfEeprom>100)
		{
			
			printf("Du lieu EEPROM sai con me no roi \r\n");
			
			sizeOfEeprom=0;
			//while(1);
		}
	else
		{
			
			printf("Kiem tra du lieu EEPROM\r\n");
			for(i=0; i<20;i++)
				{
					EE_ReadVariable(2+i,&eeprom_data);
					save_config_data[i]=eeprom_data;
					//printf("data[%d] : %d!\r\n",i,save_config_data[i]);
				}
			
		}
		// Kiem tra gia tri password xem co dung hom :v
		//Second address 0x0001: password : default is 1234
	EE_ReadVariable(1,&eeprom_data);
	eeprom_passwd=eeprom_data;
	if(eeprom_passwd!=1234)
		{
			bad_eeprom=1;
			//RS485_TxD(1);
			//USART1_SendStr_("Sai password nhe",17);
			printf("Sai password nhe : %d!!! \r\n",eeprom_passwd);
			loadDefault_eeprom_value();
			printf("Load default\r\n");
			EE_WriteVariable(0x0000,20);// eeprom password
			sizeOfEeprom=0;// Ko lay du lieu tu EEPROM nua
			
		}
		else bad_eeprom=0;
	
		j=0;

	for(i=0; i<2*sizeOfEeprom;i=i+2)
	{
		EE_ReadVariable(i+2,&eeprom_data);
		RS485_TxD(1);
		//printf("DATA:%d\r\n",eeprom_data);
		RS485_TxD(0);
		EE_ReadVariable(i+3,&eeprom_data);
		RS485_TxD(1);
		//printf("DATA:%d\r\n",eeprom_data);
		RS485_TxD(0);
		
		//printf("Day: %d, Hr : %d, Min : %d, Type: %d\r\n",alarm[j].day,alarm[j].hour,alarm[j].min,alarm[j].type);
		j++;
	}
	//printf("Da nhap %d chuong \r\n",j);
}
//----------------------------------------------------------------------------------------------------------------//
void Update_BTS_Sensor(void)
{
	TM_AM2301_Data_t am2301_data;
	unsigned char error_data, checksum;
	char data_buffer[50];
  
	s_connectionreset();
	
	station_rtc.sec=BCD2DEC(DS3231_ReadReg(DS3231_SECOND_REG ));
	station_rtc.min=BCD2DEC(DS3231_ReadReg(DS3231_MINUTE_REG ));
	station_rtc.hr=BCD2DEC(DS3231_ReadReg(DS3231_HOURS_REG ));
	station_rtc.day=BCD2DEC(DS3231_ReadReg(DS3231_DAY_REG ));
	station_rtc.date=BCD2DEC(DS3231_ReadReg(DS3231_DATE_REG ));
	station_rtc.month=BCD2DEC(DS3231_ReadReg(DS3231_MONTH_REG ));
	station_rtc.year=BCD2DEC(DS3231_ReadReg(DS3231_YEAR_REG ));
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
	 
		temp_humi_rtc_int.temp=10*temp_val.ft;
		temp_humi_rtc_int.humi=10*humi_val.ft;
  }
	
	if (TM_AM2301_Read(&am2301_data) == TM_AM2301_OK) 
		{	
			temp_humi_rtc_ex.humi=am2301_data.Hum ;
			temp_humi_rtc_ex.temp=am2301_data.Temp ;
		}
//	else if(TM_AM2301_Read(&am2301_data) == TM_AM2301_CONNECTION_ERROR) 
//		{ 
//			printf( "TM_AM2301_CONNECTION_ERROR\r\n");
//		}
//	else if(TM_AM2301_Read(&am2301_data) == TM_AM2301_WAITHIGH_ERROR) 
//		{ 
//			printf( "TM_AM2301_WAITHIGH_ERROR\r\n");
//		}
	

	//Truyen thong tin ve cam bien di cho cac module khac
	//>1XX:[hr][min][date][month][year][ex_humi_H][ex_humi_L][ex_temp_H]
	//[ex_temp_L][int_Humi_H][int_Humi_L][int_temp_H][int_temp_H][water+smoke+gate+pir+glass][alarm][check_sum]!<
//	sprintf(data_buffer,">101:%02X%02X%02X%02X%02X%04X%04X%04X%04X%02X%02X%02X!<",
//          station_rtc.hr,station_rtc.min,
//	        station_rtc.date,station_rtc.month,station_rtc.year,
//	        temp_humi_rtc_int.humi,
//	        temp_humi_rtc_int.temp,
//	        temp_humi_rtc_int.humi,
//	        temp_humi_rtc_int.temp,
//	        (bts_stt_rtc.gate<<2)+(bts_stt_rtc.smoke<<1)+bts_stt_rtc.water,60,101);
	//RS485_TxD(1);
	//USART1_SendStr_(data_buffer,40);
	//RS485_TxD(0);
	//printf( "Sensor: %doC-%dRH:%doC-%dRH;AC:%d\r\n",temp_humi_rtc_int.temp,temp_humi_rtc_int.humi,temp_humi_rtc_int.temp,temp_humi_rtc_int.humi,MainAcVolt);
	//printf( "Time: %d-%d-%d\r\n",station_rtc.hr,station_rtc.min,station_rtc.sec);	
	//printf( "Time: %d-%d-%d\r\n"
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


