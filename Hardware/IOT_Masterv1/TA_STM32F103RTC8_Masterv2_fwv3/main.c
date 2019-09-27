//Inclue USE_STDPERIPH_DRIVER, STM32F10X_HD
#include <stdio.h>
#include <stdlib.h>
#include "GPIO_STM32F10x.h"
#include "main.h"
#include <string.h>
#include "TA_Master_HW2_drivers.h"
#include <math.h>

TIM_ICInitTypeDef  TIM_ICInitStructure;
struct PWM_State {
    uint8_t  state;
    uint16_t rise;
    uint16_t fall;
    uint16_t capture;
}Inputs[4] = { { 0, } };


 uint32_t  NumberPulse=0;
 uint32_t  Frequency=0;
 uint16_t  CurrentValue=0;
 uint16_t  LastValue=0;

/**
  * @brief  This function handles TIM4 global interrupt request.
  * @param  None
  * @retval None
  */
void TIM4_IRQHandler(void)
{
    static uint32_t Current;
	
		if (TIM_GetITStatus(TIM4, TIM_IT_Update) != RESET)
		{
				TIM_ClearITPendingBit(TIM4, TIM_IT_Update);
			  NumberPulse++;
			  //printf("I'm here\r\n");
    }
		
//				if (TIM_GetITStatus(TIM4, TIM_IT_CC1) != RESET)
//		{
//				TIM_ClearITPendingBit(TIM4, TIM_IT_CC1);
//			  CurrentValue  =  TIM_GetCapture1(TIM1);
//			  Frequency     =  NumberPulse+CurrentValue-LastValue;
//			  NumberPulse   =  0;
//			  LastValue     =  CurrentValue;
//    }
		
		
//    if (TIM_GetITStatus(TIM4, TIM_IT_CC1) != RESET) {
//        TIM_ClearITPendingBit(TIM4, TIM_IT_CC1);
//        Current = TIM_GetCapture1(TIM4);
//        if (Inputs[0].state == 0) {
//            Inputs[0].rise = Current;
//            TIM_ICInitStructure.TIM_ICPolarity = TIM_ICPolarity_Falling;
//            TIM_ICInitStructure.TIM_Channel = TIM_Channel_1;
//            TIM_ICInit(TIM4, &TIM_ICInitStructure);
//						TIM_SetCounter(TIM4,0);
//            Inputs[0].state = 1;
//        } else {
//            Inputs[0].fall = Current;
//            Inputs[0].capture = Inputs[0].fall - Inputs[0].rise;
//            TIM_ICInitStructure.TIM_ICPolarity = TIM_ICPolarity_Rising;
//            TIM_ICInitStructure.TIM_Channel = TIM_Channel_1;
//            TIM_ICInit(TIM4, &TIM_ICInitStructure);
//            Inputs[0].state = 0;
//        }
//    }
//    if (TIM_GetITStatus(TIM4, TIM_IT_CC2) != RESET) {
//				//printf("I'm here\r\n");
//        TIM_ClearITPendingBit(TIM4, TIM_IT_CC2);
//        Current = TIM_GetCapture2(TIM4);
//        if (Inputs[1].state == 0) {
//            Inputs[1].rise = Current;
//            TIM_ICInitStructure.TIM_ICPolarity = TIM_ICPolarity_Rising;
//            TIM_ICInitStructure.TIM_Channel = TIM_Channel_2;
//            TIM_ICInit(TIM4, &TIM_ICInitStructure);
//            Inputs[1].state = 1;
//					TIM_SetCounter(TIM4,0);
//        } else {
//            Inputs[1].fall = Current;
//            Inputs[1].capture = Inputs[1].fall - Inputs[1].rise;
//            TIM_ICInitStructure.TIM_ICPolarity = TIM_ICPolarity_Falling;
//            TIM_ICInitStructure.TIM_Channel = TIM_Channel_2;
//            TIM_ICInit(TIM4, &TIM_ICInitStructure);
//            Inputs[1].state = 0;
//					TIM_SetCounter(TIM4,0);
//        }
//    }
//    if (TIM_GetITStatus(TIM4, TIM_IT_CC3) != RESET) {
//        TIM_ClearITPendingBit(TIM4, TIM_IT_CC3);
//        Current = TIM_GetCapture3(TIM4);
//        if (Inputs[2].state == 0) {
//            Inputs[2].rise = Current;
//            TIM_ICInitStructure.TIM_ICPolarity = TIM_ICPolarity_Falling;
//            TIM_ICInitStructure.TIM_Channel = TIM_Channel_3;
//            TIM_ICInit(TIM4, &TIM_ICInitStructure);
//            Inputs[2].state = 1;
//        } else {
//            Inputs[2].fall = Current;
//            Inputs[2].capture = Inputs[2].fall - Inputs[2].rise;
//            TIM_ICInitStructure.TIM_ICPolarity = TIM_ICPolarity_Rising;
//            TIM_ICInitStructure.TIM_Channel = TIM_Channel_3;
//            TIM_ICInit(TIM4, &TIM_ICInitStructure);
//            Inputs[2].state = 0;
//        }
//    }
//    if (TIM_GetITStatus(TIM4, TIM_IT_CC4) != RESET) {
//        TIM_ClearITPendingBit(TIM4, TIM_IT_CC4);
//        Current = TIM_GetCapture4(TIM4);
//        if (Inputs[3].state == 0) {
//            Inputs[3].rise = Current;
//            TIM_ICInitStructure.TIM_ICPolarity = TIM_ICPolarity_Falling;
//            TIM_ICInitStructure.TIM_Channel = TIM_Channel_4;
//            TIM_ICInit(TIM4, &TIM_ICInitStructure);
//            Inputs[3].state = 1;
//        } else {
//            Inputs[3].fall = Current;
//            Inputs[3].capture = Inputs[3].fall - Inputs[3].rise;
//            TIM_ICInitStructure.TIM_ICPolarity = TIM_ICPolarity_Rising;
//            TIM_ICInitStructure.TIM_Channel = TIM_Channel_4;
//            TIM_ICInit(TIM4, &TIM_ICInitStructure);
//            Inputs[3].state = 0;
//        }
//    }
		
}

#define IND_COM_OPP   GPIO_PinConfigure(GPIOB, 14,GPIO_OUT_PUSH_PULL,GPIO_MODE_OUT50MHZ);GPIO_PinWrite(GPIOB,14,0)// Output Push Pull wait for send data over USART                 
#define IND_COM_IPU   GPIO_PinConfigure(GPIOB, 14,GPIO_IN_PULL_UP,GPIO_MODE_INPUT)// Input Pull Up wait for having data over USART
#define IND_COM_PIN   GPIO_PinRead(GPIOB,14) // PIN indicate data for reciver and send data

uint8_t RL_STT=0;
uint8_t BT_STT=0;
uint8_t right_data_IO=0;
//SysTick IRQ Handle
//*----------------------------------------------------------------------------*/
uint8_t         dht11Data[5] = {0};     /* dht11 data container */
uint16_t adc_raw_val;

static uint8_t status_DMA1=0;
volatile uint16_t ADC_values[5];
volatile uint32_t status = 0;
extern volatile uint32_t Timer;		
void ADCInit(void);
void DMAInit(void);

void SysTick_Handler (void) 
{
  static uint32_t ticks=0;

  switch (ticks++) 
	{
    case  0  :  {
									//GLCD_Hum_Temp_Update();
									//Update_Time();
									//s_connectionreset();
									//SHT1x_Display();
									break;
								}
    case  50:  {

								
		
								break;}
    case  60:  {
	
							}
								
    
    default:
      if (ticks > 100) 
			{
        ticks = 0;
			}
  }
}


/* Private define ------------------------------------------------------------*/
typedef union
 {
  uint16_t it;
  float ft;
 }  value;

enum{Temp,Humi};

value humi_val, temp_val;
float dewpoint;

unsigned int i;
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
	uint8_t sec,min,hr,day,date,month,year,temp_ub,temp_lb;

	USER_I2C_Init();
	DS3231_init();
	sec=BCD2DEC(DS3231_ReadReg(DS3231_SECOND_REG ));
	min=BCD2DEC(DS3231_ReadReg(DS3231_MINUTE_REG ));
	hr=BCD2DEC(DS3231_ReadReg(DS3231_HOURS_REG ));
	day=BCD2DEC(DS3231_ReadReg(DS3231_DAY_REG ));
	date=BCD2DEC(DS3231_ReadReg(DS3231_DATE_REG ));
	month=BCD2DEC(DS3231_ReadReg(DS3231_MONTH_REG ));
	year=BCD2DEC(DS3231_ReadReg(DS3231_YEAR_REG ));
	// Read temperature inside DS3231 in format XX.xx oC
	temp_ub=DS3231_ReadReg(0x11);// Upper Byte for XX
	temp_lb=(DS3231_ReadReg(0x12))>>6;//Lower Byte for xx
	if(temp_lb==1) temp_lb=25;
	if(temp_lb==2) temp_lb=50;
	if(temp_lb==3) temp_lb=75;
	printf("\n\rRTC TIME: %d:%d:%d",hr,min,sec);
	printf("\n\rRTC DAY:%d %d-%d-20%d",day,date,month,year);
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




void GLCD_Hum_Temp_Update (void)
{

char numberic1,numberic2,numberic3,i;
float nhietdo;
	
	
	nhietdo=DS18B20_ReadTemp();
	//printf("DS18B20 Temp: %2.3f\r\n",nhietdo);
	ADC_GetValue();
	//printf("NTC2 PC0 ADCx_IN10: %d\r\n",ADC_values[0]);
	//printf("NTC1 PC1 ADCx_IN11: %d\r\n",ADC_values[1]);
	s_connectionreset();
	SHT1x_Display();
	
	if (DHT11_OK == DHT11_Read(dht11Data))
		{		
			//printf("DHT11: %d%%RH, %doC\r\n", dht11Data[0], dht11Data[2]);
		}
			numberic1=((int)humi_val.ft)/10;
			numberic2=((int)humi_val.ft)%10;
			numberic3=(int)((int)((int)(10*humi_val.ft)%100)%10);
			glcd_write_cmd(0x85);
			glcd_write_data(numberic1 + 48);
			glcd_write_data(numberic2 + 48);
			glcd_write_data('.');
			glcd_write_data(numberic3 + 48);
			//nhietdo=temp_val.ft;
			numberic1=((int)temp_val.ft)/10;
			numberic2=((int)temp_val.ft)%10;
			numberic3=(int)((int)((int)(10*temp_val.ft)%100)%10);
			glcd_write_com(0x95);
			glcd_write_data(numberic1 + 48);
			glcd_write_data(numberic2 + 48);
			glcd_write_data('.');
			glcd_write_data(numberic3 + 48);
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



			//printf("CC1:Rise: %d, Fall: %d, Capture: %d\r\n", Inputs[0].rise, Inputs[0].fall, Inputs[0].capture);
			//printf("CC2:Rise: %d, Fall: %d, Capture: %d\r\n", Inputs[1].rise, Inputs[1].fall, Inputs[1].capture);
			//printf("CC3:Rise: %d, Fall: %d, Capture: %d\r\n", Inputs[2].rise, Inputs[2].fall, Inputs[2].capture);
			//printf("CC4:Rise: %d, Fall: %d, Capture: %d\r\n", Inputs[3].rise, Inputs[3].fall, Inputs[3].capture);
			//printf("Frequency = %lu\n\r",Frequency);

}







int main(void)
{
	char keyp=0;
	uint8_t count=0;
	//uint8_t i=0,j=0;
	//GPIO_InitTypeDef GPIO_InitStructure;
	
	//uint8_t dht_nhiet_do=10,dht_do_am=20; 
	
	SystemCoreClockUpdate();
	//#define SYSCLK_FREQ_72MHz  72000000
	

	GPIO_PortClock   (GPIOA, true);
	GPIO_PortClock   (GPIOB, true);
	GPIO_PortClock   (GPIOC, true);

	
	KeyPad4x4_Init();
	USART1_Init();
	USART2_Init();
	USER_UART_NVIC();
	Aux_RL_Control(0);	
	Turn_RL(0x0);
	Delay(100);
	printf(">Master Board HWv2 fwv1\r\n");
	GLCD_GPIO_init();
	
	
	//Write to DS3231
	//DS3231(sec,min,hr,day,date,month,year)
	//DS3231_Set_Time(0,40,14,6,10,7,15);
	
	SHT1x_Display();
	USER_I2C_Init();
	DS3231_init();
	Update_Time();
	//glcd_init();
	GLCD_INIT_();
	GLCD_BL(1);
	glcd_test();
	Delay(100);
	GLCD_Clear();
	Delay(100);
	GLCD_CONST_DATA();

	
	DS18B20_Config(15,50,DS18B20_12BIT_RES);
	DHT11_Init();
	USER_ADC_Init();
	DMAInit();
	DMA_Cmd(DMA1_Channel1, ENABLE);
	SysTick_Config(SystemCoreClock/10);      /* Generate interrupt each 100 ms  */

	keyp=KEY4X4_GetKey();
	TIM_Config();
	printf("Voltage 1: %d\r\n",measure_voltage(1));
	printf("Voltage 2: %d\r\n",measure_voltage(2));
	printf("Voltage 3: %d\r\n",measure_voltage(3));
	printf("Voltage 4: %d\r\n",measure_voltage(4));
	/*
	while(1){
	while(GPIO_PinRead(GPIOB,6)){if(TIM4->CNT>30000) break;};//while for PB6==0;cho xung xuong/ BP6 == PWM1_IN
	while(!GPIO_PinRead(GPIOB,6)){if(TIM4->CNT>30000) break;};//while for PB6==1;cho xung len
	TIM4->CNT=0;//Bat dau dem
	while(GPIO_PinRead(GPIOB,6)){if(TIM4->CNT>30000) break;};//while for PB6==0;cho xung xuong
	while(!GPIO_PinRead(GPIOB,6)){if(TIM4->CNT>30000) break;};//while for PB6==1;cho xung len
	while(GPIO_PinRead(GPIOB,6)){if(TIM4->CNT>30000) break;};//while for PB6==0;cho xung xuong
	while(!GPIO_PinRead(GPIOB,6)){if(TIM4->CNT>30000) break;};//while for PB6==1;cho xung len
	while(GPIO_PinRead(GPIOB,6)){if(TIM4->CNT>30000) break;};//while for PB6==0;cho xung xuong
	while(!GPIO_PinRead(GPIOB,6)){if(TIM4->CNT>30000) break;};//while for PB6==1;cho xung len
	while(GPIO_PinRead(GPIOB,6)){if(TIM4->CNT>30000) break;};//while for PB6==0;cho xung xuong
	while(!GPIO_PinRead(GPIOB,6)){if(TIM4->CNT>30000) break;};//while for PB6==1;cho xung len
	while(GPIO_PinRead(GPIOB,6)){if(TIM4->CNT>30000) break;};//while for PB6==0;cho xung xuong
	while(!GPIO_PinRead(GPIOB,6)){if(TIM4->CNT>30000) break;};//while for PB6==1;cho xung len
	CurrentValue=TIM4->CNT;
	printf("PWM1_IN:%d\r\n",CurrentValue);
	//Delay(100);
	while(GPIO_PinRead(GPIOB,7));//while for PB6==0;cho xung xuong/ BP7 == PWM2_IN
	while(!GPIO_PinRead(GPIOB,7));//while for PB6==1;cho xung len
	TIM4->CNT=0;//Bat dau dem
	while(GPIO_PinRead(GPIOB,7));//while for PB6==0;cho xung xuong
	while(!GPIO_PinRead(GPIOB,7));//while for PB6==1;cho xung len
	while(GPIO_PinRead(GPIOB,7));//while for PB6==0;cho xung xuong
	while(!GPIO_PinRead(GPIOB,7));//while for PB6==1;cho xung len
	while(GPIO_PinRead(GPIOB,7));//while for PB6==0;cho xung xuong
	while(!GPIO_PinRead(GPIOB,7));//while for PB6==1;cho xung len
	while(GPIO_PinRead(GPIOB,7));//while for PB6==0;cho xung xuong
	while(!GPIO_PinRead(GPIOB,7));//while for PB6==1;cho xung len
	while(GPIO_PinRead(GPIOB,7));//while for PB6==0;cho xung xuong
	while(!GPIO_PinRead(GPIOB,7));//while for PB6==1;cho xung len
	CurrentValue=TIM4->CNT;
	printf("PWM2_IN:%d\r\n",CurrentValue);
	Delay(100);
	}
	*/
		while(1)
			{
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



void USART1_Init(void)
{
	USART_InitTypeDef USARTx_Init;
	
	USARTx_Init.USART_WordLength = USART_WordLength_8b;
	USARTx_Init.USART_StopBits = USART_StopBits_1;
	USARTx_Init.USART_Parity = USART_Parity_No;
	USARTx_Init.USART_HardwareFlowControl = USART_HardwareFlowControl_None;
	USARTx_Init.USART_Mode = USART_Mode_Rx | USART_Mode_Tx;
	USARTx_Init.USART_BaudRate = 115200;
	
	/* Enable UART clock, if using USART2 or USART3 ... we must use RCC_APB1PeriphClockCmd(RCC_APB1Periph_USARTx, ENABLE) */
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_USART1, ENABLE);
	GPIO_PortClock   (GPIOA, true);
	GPIO_PinWrite    (GPIOA, 9, 0);
	GPIO_PinConfigure(GPIOA, 9,
										GPIO_AF_PUSHPULL, 
										GPIO_MODE_OUT50MHZ);
	
	/* Configure PA9 for USART Tx as alternate function push-pull */
	GPIO_PinConfigure(GPIOA, 10,
										GPIO_IN_FLOATING,
										GPIO_MODE_INPUT);
	/* Configure PA10 for USART Rx as input floating */
	
	GPIO_PinConfigure(GPIOA, 11,
										GPIO_IN_PULL_UP,
										GPIO_MODE_INPUT);
	/* Configure PA11 for USART INDICATE as input pull up */
	
	
		/* USART configuration */
	USART_Init(USART1, &USARTx_Init);
	/* Enable USART */
	USART_Cmd(USART1, ENABLE);
}

void USART2_Init(void)
{
	USART_InitTypeDef USARTx_Init;
	
	USARTx_Init.USART_WordLength = USART_WordLength_8b;
	USARTx_Init.USART_StopBits = USART_StopBits_1;
	USARTx_Init.USART_Parity = USART_Parity_No;
	USARTx_Init.USART_HardwareFlowControl = USART_HardwareFlowControl_None;
	USARTx_Init.USART_Mode = USART_Mode_Rx | USART_Mode_Tx;
	USARTx_Init.USART_BaudRate = 115200;
	
	/* Enable UART clock, if using USART2 or USART3 ... we must use RCC_APB1PeriphClockCmd(RCC_APB1Periph_USARTx, ENABLE) */
	RCC_APB1PeriphClockCmd(RCC_APB1Periph_USART2, ENABLE);
	GPIO_PortClock   (GPIOA, true);
	GPIO_PinWrite    (GPIOA, 2, 0);
	GPIO_PinConfigure(GPIOA, 2,
										GPIO_AF_PUSHPULL, 
										GPIO_MODE_OUT50MHZ);
	
	/* Configure PA2 for USART Tx as alternate function push-pull */
	GPIO_PinConfigure(GPIOA, 3,
										GPIO_IN_FLOATING,
										GPIO_MODE_INPUT);
	/* Configure PA3 for USART Rx as input floating */
		/* USART configuration */
	USART_Init(USART2, &USARTx_Init);
	/* Enable USART */
	USART_Cmd(USART2, ENABLE);
}

void USART1_SendChar_(char ch) {
	while (USART_GetFlagStatus(USART1, USART_FLAG_TC) == RESET); // wait for "Transmission Complete" flag cleared
	USART_SendData(USART1,ch);
}

void USART2_SendChar_(char ch) {
	while (USART_GetFlagStatus(USART2, USART_FLAG_TC) == RESET); // wait for "Transmission Complete" flag cleared
	USART_SendData(USART2,ch);
}

void USER_UART_NVIC(void)
{
  NVIC_InitTypeDef  NVIC_InitStructure;
  
	NVIC_InitStructure.NVIC_IRQChannel = USART2_IRQn;
  NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0x02;
  NVIC_InitStructure.NVIC_IRQChannelSubPriority = 0x02;
  NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
  NVIC_Init(&NVIC_InitStructure);
	
	USART_ITConfig(USART2,USART_IT_RXNE,ENABLE);
	
	NVIC_InitStructure.NVIC_IRQChannel = USART1_IRQn;
  NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0;
  NVIC_InitStructure.NVIC_IRQChannelSubPriority = 1;
  NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
  NVIC_Init(&NVIC_InitStructure);
	
	USART_ITConfig(USART1,USART_IT_RXNE,ENABLE);
}	





void DHT11_Init(void)
{
    CRITICAL_SECTION_INIT;
}
 
void DHT11_Denit(void)
{
    CRITICAL_SECTION_DEINIT;
}
 
DHT11_ERROR_CODE_t DHT11_Read(uint8_t * const pData)
{
    int i = 0;
    int j = 0;
    DHT11_ERROR_CODE_t errorCode = DHT11_OK;
     
    #ifdef ENABLE_TIMEOUTS
    int timeout = TIMEOUT_VALUE;
    #endif
 
    GPIO_SET_AS_OUTPUT;
     
    CRITICAL_SECTION_ENTER;
     
     
    /* start sequence */
    GPIO_OUPUT_CLEAR;    
    delay_us(18000);
 
    GPIO_OUTPUT_SET;
    delay_us(40);
 
    GPIO_SET_AS_INPUT;
 
    while(0 == GPIO_INPUT_GET) /* 80us on '0' */
    {
        #ifdef ENABLE_TIMEOUTS
        if (--(timeout) <= 0)
        {
            errorCode = DHT11_TIMEOUT;
            break;
        }
        #endif
    };
     
    #ifdef ENABLE_TIMEOUTS
    timeout = TIMEOUT_VALUE;
    #endif
    if (DHT11_OK == errorCode)
    {
        while(1 == GPIO_INPUT_GET) /* 80us on '1' */
        {
            #ifdef ENABLE_TIMEOUTS
            if (--(timeout) <= 0)
            {
                errorCode = DHT11_TIMEOUT;
                break;
            }
            #endif
        };
    }        
    /* start sequence - end */
 
    /* read sequence */
    if (DHT11_OK == errorCode)
    {
        for(j=0;j<5;j++)
        {
            for(i=0;i<8;i++)
            {
                #ifdef ENABLE_TIMEOUTS
                timeout = TIMEOUT_VALUE;
                #endif
                while(0 == GPIO_INPUT_GET)
                {
                    #ifdef ENABLE_TIMEOUTS
                    if (--(timeout) <= 0)
                    {
                        errorCode = DHT11_TIMEOUT;
                        break;
                    }
                    #endif
                }; /* 50 us on 0 */
 
                if (1 == GPIO_INPUT_GET)
                {
                    delay_us(30);
                }
 
                pData[j] <<= 1;
                 
                if(1 == GPIO_INPUT_GET)
                {
                    delay_us(40); /* wait 'till 70us */
                    pData[j] |= 1;
                }
                else
                {
                    pData[j] &= 0xfe;
                }
            }
        }
    }
    /* read sequence - end */
     
    CRITICAL_SECTION_LEAVE;
 
    /* checksum check */
    if (DHT11_OK == errorCode)
    {
        if ((pData[0] + pData[2]) != pData[4])
        {
            errorCode = DHT11_WRONG_CHCKSUM;
        }
        else
        {
            errorCode = DHT11_OK;
        }
    }
 
    return errorCode;
}


 /*******************************************************************************
Noi Dung    :   MCU gui yeu cau chuyen doi den DHT11.
Tham Bien   :   Khong.
Tra Ve      :   Khong.
********************************************************************************/
uint8_t DHT_GetTemHumi (uint8_t *tem,uint8_t *humi)
{
    uint8_t buffer[5]={0,0,0,0,0};
    uint8_t ii,i,checksum;
	
    //DHT_DDR_DATA=DDROUT;   // set la cong ra
		GPIO_SET_AS_OUTPUT;
    //DHT_DATA_OUT=1;
		GPIO_OUTPUT_SET;
    delay_us(60);
    //DHT_DATA_OUT=0;
		GPIO_OUPUT_CLEAR;
    delay_ms(25); // it nhat 18ms
    //DHT_DATA_OUT=1;
		GPIO_OUTPUT_SET;
    //DHT_DDR_DATA=DDRIN;
		GPIO_SET_AS_INPUT;
    delay_us(60);
    if(GPIO_INPUT_GET)return DHT_ER ;
    else while(!(GPIO_INPUT_GET));	//Doi DaTa len 1
    delay_us(60);
    if(!GPIO_INPUT_GET)return DHT_ER;
    else while((GPIO_INPUT_GET));	 //Doi Data ve 0
    //Bat dau doc du lieu
    for(i=0;i<5;i++)
    {
        for(ii=0;ii<8;ii++)
        {	
        while((!GPIO_INPUT_GET));//Doi Data len 1
        delay_us(50);
        if(GPIO_INPUT_GET)
            {
            buffer[i]|=(1<<(7-ii));
            while((GPIO_INPUT_GET));//Doi Data xuong 0
            }
        }
    }
	//Tinh toan check sum
    checksum=buffer[0]+buffer[1]+buffer[2]+buffer[3];
	//Kiem tra check sum
    if((checksum)!=buffer[4])return DHT_ER;
	//Lay du lieu
    *tem  =   buffer[2];
    *humi =   buffer[0];
    return DHT_OK;
}


void USER_ADC_Init(void){
	ADC_InitTypeDef ADC_InitStructure;
	GPIO_InitTypeDef GPIO_InitStructure;
	
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_ADC1|RCC_APB2Periph_GPIOC, ENABLE);
	

	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_0|GPIO_Pin_1;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AIN;
	GPIO_Init(GPIOC, &GPIO_InitStructure);
	
//	/* Configure PC.04 (ADC Channel) as analog input -------------------------*/
//	GPIO_PinConfigure(GPIOC, 0,
//										GPIO_IN_ANALOG,
//										GPIO_MODE_INPUT);
//	/* Configure PC.04 (ADC Channel) as analog input -------------------------*/
//	GPIO_PinConfigure(GPIOC, 1,
//										GPIO_IN_ANALOG,
//										GPIO_MODE_INPUT);
//	/* Configure PC.04 (ADC Channel) as analog input -------------------------*/
//	GPIO_PinConfigure(GPIOC, 2,
//										GPIO_IN_ANALOG,
//										GPIO_MODE_INPUT);
//										/* Configure PC.04 (ADC Channel) as analog input -------------------------*/
//	GPIO_PinConfigure(GPIOC, 3,
//										GPIO_IN_ANALOG,
//										GPIO_MODE_INPUT);
//										/* Configure PC.04 (ADC Channel) as analog input -------------------------*/
//	GPIO_PinConfigure(GPIOC, 4,
//										GPIO_IN_ANALOG,
//										GPIO_MODE_INPUT);
	
	/* ADCx configuration ------------------------------------------------------*/
	ADC_InitStructure.ADC_Mode = ADC_Mode_Independent;
	ADC_InitStructure.ADC_ScanConvMode = ENABLE;
	ADC_InitStructure.ADC_ContinuousConvMode = ENABLE;
	ADC_InitStructure.ADC_ExternalTrigConv = ADC_ExternalTrigConv_None;
	ADC_InitStructure.ADC_DataAlign = ADC_DataAlign_Right;
	ADC_InitStructure.ADC_NbrOfChannel = 2;
	ADC_Init(ADC1, &ADC_InitStructure);	
	/* ADC1 Regular Channel 2 Configuration */
	ADC_RegularChannelConfig(ADC1, ADC_Channel_10, 1, ADC_SampleTime_55Cycles5);
	ADC_RegularChannelConfig(ADC1, ADC_Channel_11, 2, ADC_SampleTime_55Cycles5);	
	/* Enable ADC1 */
	ADC_Cmd(ADC1, ENABLE); 
	//enable DMA for ADC
	ADC_DMACmd(ADC1, ENABLE);  

	/* Enable Vrefint channel enable temperature sensor for ADC module */
	ADC_TempSensorVrefintCmd(ENABLE);

	/* Enable ADC1 reset calibaration register */   
	ADC_ResetCalibration(ADC1);

	/* Check the end of ADC1 reset calibration register */
	while(ADC_GetResetCalibrationStatus(ADC1));

	/* Start ADC1 calibaration */
	ADC_StartCalibration(ADC1);
	/* Check the end of ADC1 calibration */
	while(ADC_GetCalibrationStatus(ADC1));  
	/* Start ADC1 Software Conversion */ 
	//ADC_SoftwareStartConvCmd(ADC1, ENABLE);

}

void DMAInit(void)
{
	NVIC_InitTypeDef NVIC_InitStructure;
	//create DMA structure
	DMA_InitTypeDef  DMA_InitStructure;
	//enable DMA1 clock
	RCC_AHBPeriphClockCmd(RCC_AHBPeriph_DMA1, ENABLE);
	//reset DMA1 channe1 to default values;
	DMA_DeInit(DMA1_Channel1);
	//channel will be used for memory to memory transfer
	DMA_InitStructure.DMA_M2M = DMA_M2M_Disable;
	//setting normal mode (non circular)
	DMA_InitStructure.DMA_Mode = DMA_Mode_Circular;
	//medium priority
	DMA_InitStructure.DMA_Priority = DMA_Priority_High;
	//source and destination data size word=32bit
	DMA_InitStructure.DMA_PeripheralDataSize = DMA_PeripheralDataSize_HalfWord;
	DMA_InitStructure.DMA_MemoryDataSize = DMA_MemoryDataSize_HalfWord;
	//automatic memory destination increment enable.
	DMA_InitStructure.DMA_MemoryInc = DMA_MemoryInc_Enable;
	//source address increment disable
	DMA_InitStructure.DMA_PeripheralInc = DMA_PeripheralInc_Disable;
	//Location assigned to peripheral register will be source
	DMA_InitStructure.DMA_DIR = DMA_DIR_PeripheralSRC;
	//chunk of data to be transfered
	DMA_InitStructure.DMA_BufferSize = 2; // Bao nhieu kenh ADC??????????????????????????????
	//source and destination start addresses
	DMA_InitStructure.DMA_PeripheralBaseAddr = (uint32_t)&ADC1->DR;
	DMA_InitStructure.DMA_MemoryBaseAddr = (uint32_t)ADC_values;
	//send values to DMA registers
	DMA_Init(DMA1_Channel1, &DMA_InitStructure);
	// Enable DMA1 Channel Transfer Complete interrupt
	DMA_ITConfig(DMA1_Channel1, DMA_IT_TC, ENABLE);
	DMA_Cmd(DMA1_Channel1, ENABLE); //Enable the DMA1 - Channel1
	


  /* Set the Vector Table base location at 0x08000000 */
  NVIC_SetVectorTable(NVIC_VectTab_FLASH, 0x0);
  /* 2 bit for pre-emption priority, 2 bits for subpriority */
  NVIC_PriorityGroupConfig(NVIC_PriorityGroup_2); 
	
 	//Enable DMA1 channel IRQ Channel */
	NVIC_InitStructure.NVIC_IRQChannel = DMA1_Channel1_IRQn;
	NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 2;
	NVIC_InitStructure.NVIC_IRQChannelSubPriority = 3;
	NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
	NVIC_Init(&NVIC_InitStructure);
	

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


