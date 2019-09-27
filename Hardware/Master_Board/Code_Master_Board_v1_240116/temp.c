
	printf("EEPROM_WriteReg(0x01,11):%d\r\n",EEPROM_WriteReg(0x01,9));
	printf("EEPROM_WriteReg(0x01,11):%d\r\n",EEPROM_WriteReg(0x02,8));
	printf("EEPROM_WriteReg(0x01,11):%d\r\n",EEPROM_WriteReg(0x03,7));
	printf("EEPROM_WriteReg(0x01,11):%d\r\n",EEPROM_WriteReg(0x04,6));
	printf("EEPROM_WriteReg(0x01,11):%d\r\n",EEPROM_WriteReg(0x05,5));
	printf("EEPROM_WriteReg(0x01,11):%d\r\n",EEPROM_WriteReg(0x06,4));
	printf("EEPROM_WriteReg(0x01,11):%d\r\n",EEPROM_WriteReg(0x07,2));
	//printf("Write:%d\r\n",EEPROM_W_Regs(1,12,"Ngo Quy TUan"));
	printf("EEPROM 0x00: %d\r\n",EEPROM_ReadReg(0));
	printf("EEPROM 0x01: %d\r\n",EEPROM_ReadReg(1));
	printf("EEPROM 0x02: %d\r\n",EEPROM_ReadReg(2));
	printf("EEPROM 0x03: %d\r\n",EEPROM_ReadReg(3));
	printf("EEPROM 0x04: %d\r\n",EEPROM_ReadReg(4));
	printf("EEPROM 0x05: %d\r\n",EEPROM_ReadReg(5));
	printf("EEPROM 0x06: %d\r\n",EEPROM_ReadReg(6));
	printf("EEPROM 0x07: %d\r\n",EEPROM_ReadReg(7));

#define IND_COM_OPP   GPIO_PinConfigure(GPIOB, 14,GPIO_OUT_PUSH_PULL,GPIO_MODE_OUT50MHZ);GPIO_PinWrite(GPIOB,14,0)// Output Push Pull wait for send data over USART                 
#define IND_COM_IPU   GPIO_PinConfigure(GPIOB, 14,GPIO_IN_PULL_UP,GPIO_MODE_INPUT)// Input Pull Up wait for having data over USART
#define IND_COM_PIN   GPIO_PinRead(GPIOB,14) // PIN indicate data for reciver and send data
static uint8_t status_DMA1=0;
volatile uint16_t ADC_values[5];
volatile uint32_t status = 0;
extern volatile uint32_t Timer;		
void ADCInit(void);
void DMAInit(void);

void Test(void* ptr)
{
	printf("Tuan\r\n");
}


__IO DWORD g_dwTickcount = 0;

	Test(&ProcessTimerEvents);
	StartShortTimer(50,Test, NULL);
ProcessTimerEvents();


	while(1){
	if (TM_AM2301_Read(&data) == TM_AM2301_OK) {
	printf( "Humidity: %2.1f %%Temperature: %2.1f C\r\n", (float)data.Hum / 10, (float)data.Temp / 10);}
	else printf( "AM2301 ERROR\r\n");
	Delay(100);}
	Update_BTS_Sensor();
	
		//Delay(100);

	//USER_ADC_Init();
	//DMAInit();
	//DMA_Cmd(DMA1_Channel1, ENABLE);
	//TIM_Config();
	
//		while(1)
//	{

//		delay_ms(1000);


//		//SHT1x_Display();
//		//Update_Time();
//		keyp=KEY4X4_GetKey();
//		//RS485(1);
//		printf("%c",keyp);
//		//RS485(0);
//	}


	//Write to DS3231
	//DS3231(sec,min,hr,day,date,month,year)
	//DS3231_Set_Time(0,40,14,6,10,7,15);
	
		//DS3231_Set_Time(0,40,14,6,10,7,15);
		
		//GPIO_PinWrite(GPIOA, 11, 1);
	//RS485(1);
		//Neu tat ca Board deu gui loi chao nay thi se rat met ^^
	//USART1_SendStr_(">Master Board HWv3 fwv1 24/01/2016\r\n");
	//RS485(0);
	
				keyp=KEY4X4_GetKey();
				//Khi dang o ham setup nay tat tat ca cac tien trinh khac.
				if(keyp=='#') setup_fuction();
				printf("%c",keyp);
				
								//Neu chua co du lieu tu cac module khac, cap nhat du lieu
//				if(right_data_IO==0)
//					{
//						GET_STT();
//						//If NOT respond????
//					}


//void DMA1_Channel1_IRQHandler(void)
//{
//  //Test on DMA1 Channel1 Transfer Complete interrupt
//  if(DMA_GetITStatus(DMA1_IT_TC1))
//  {
//	  status_DMA1 =1;
//   //Clear DMA1 interrupt pending bits
//    DMA_ClearITPendingBit(DMA1_IT_GL1);
//  }
//}

//void ADC_GetValue(void)
//{
//	ADC_SoftwareStartConvCmd(ADC1, ENABLE);
//	status_DMA1 =0;
//	while (!status_DMA1){};
//	ADC_SoftwareStartConvCmd(ADC1, DISABLE);
//}

  static uint32_t ticks=0;
	time_to_check_system++;
	time_to_update_rtc++;
switch (ticks++) 
	{
    case  0  :  {
									//ADC_GetValue();						
									//GLCD_Hum_Temp_Update();
									//Update_Time();
									//s_connectionreset();
									//SHT1x_Display();
									break;
								}
		case 10: {
			//ds18b20_nhietdo=DS18B20_ReadTemp();
			break;
		}
    case  20:
		{
			//SHT1x_Display();
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
									//Update_BTS_status();
									break;
	
							}
		case  100:  {
									//GLCD_Device_Update();
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
									//GLCD_FLAG_Update();
									break;
	
							}
							
		
		
								
    
    default:
      if (ticks > 350)//35s 
			{
        ticks = 0;
			}
			
			
		void SHT1x_Display(void)
{

unsigned char error_data, checksum;
  s_connectionreset();
	error_data = 0;
  error_data +=    s_measure((uint16_t*)&humi_val.it,&checksum,Humi);
  error_data +=    s_measure((uint16_t*)&temp_val.it,&checksum,Temp);

  if(error_data != 0) {s_connectionreset();RS485(1);printf("SHT ERROR");} //in case of an error: connection reset

  else
  {
   humi_val.ft = (float)humi_val.it;
   temp_val.ft = (float)temp_val.it;
   calc_sth1x(&humi_val.ft,&temp_val.ft);
   dewpoint = calc_dewpoint(humi_val.ft, temp_val.ft);
	 //printf("Temp int:%d \r\n", temp_val.it);
	 //printf("Humi int:%d \r\n", humi_val.it);	
		RS485(1);
		printf("SHT10 Temp:%5.1f C \r\n", temp_val.ft);
		printf("SHT10 Humi:%5.1f %%RH \r\n", humi_val.ft);
		printf("SHT10 Dewpoint : %5.1f C \r\n", dewpoint);
		RS485(0);
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
	//USER_I2C_Init();
	//DS3231_init();
	bts_stt_rtc.bts_rtc.sec=BCD2DEC(DS3231_ReadReg(DS3231_SECOND_REG ));
	bts_stt_rtc.bts_rtc.min=BCD2DEC(DS3231_ReadReg(DS3231_MINUTE_REG ));
	bts_stt_rtc.bts_rtc.hr=BCD2DEC(DS3231_ReadReg(DS3231_HOURS_REG ));
	bts_stt_rtc.bts_rtc.day=BCD2DEC(DS3231_ReadReg(DS3231_DAY_REG ));
	bts_stt_rtc.bts_rtc.date=BCD2DEC(DS3231_ReadReg(DS3231_DATE_REG ));
	bts_stt_rtc.bts_rtc.month=BCD2DEC(DS3231_ReadReg(DS3231_MONTH_REG ));
	bts_stt_rtc.bts_rtc.year=BCD2DEC(DS3231_ReadReg(DS3231_YEAR_REG ));
	/*
	// Read temperature inside DS3231 in format XX.xx oC
	temp_ub=DS3231_ReadReg(0x11);// Upper Byte for XX
	temp_lb=(DS3231_ReadReg(0x12))>>6;//Lower Byte for xx
	if(temp_lb==1) temp_lb=25;
	if(temp_lb==2) temp_lb=50;
	if(temp_lb==3) temp_lb=75;
	bts_stt_rtc.bts_rtc.temp=(float)temp_ub + (float)(temp_lb/100);
	*/
	//RS485(1);
	//printf("\n\rRTC TIME: %d:%d:%d",bts_stt_rtc.bts_rtc.hr,bts_stt_rtc.bts_rtc.min,bts_stt_rtc.bts_rtc.sec);
	//printf("\n\rRTC DAY:%d %d-%d-20%d",bts_stt_rtc.bts_rtc.day,bts_stt_rtc.bts_rtc.date,bts_stt_rtc.bts_rtc.month,bts_stt_rtc.bts_rtc.year);
	//printf("\n\rRTC TEMP:%d.%d\r\n",temp_ub,temp_lb);
	//RS485(0);
}

//Update_Time();
					time_to_update_rtc=0;
					//if (TM_AM2301_Read(&data) == TM_AM2301_OK) {
					//printf( "Humidity: %2.1f %%Temperature: %2.1f C\r\n", (float)data.Hum / 10, (float)data.Temp / 10);}
					//else printf( "AM2301 ERROR\r\n");

//measure_voltage(Voltage_Input);

printf( "BTS Time: Day %d, Date %d/%d/20%d; %d:%d\r\n",bts_stt_rtc.bts_rtc.day,bts_stt_rtc.bts_rtc.date,bts_stt_rtc.bts_rtc.month,bts_stt_rtc.bts_rtc.year,bts_stt_rtc.bts_rtc.hr,bts_stt_rtc.bts_rtc.min);
	printf( "BTS Int Sensor Temp:%5.1f C/Humi:%5.1f %%RH\r\n",(float)(bts_stt_rtc.Int_Sensor.temp/10.0),(float)(bts_stt_rtc.Int_Sensor.humi/10.0));
	printf( "BTS Ex Sensor Temp:%5.1f C/Humi:%5.1f %%RH\r\n",(float)bts_stt_rtc.Ex_Sensor.temp/10,(float)bts_stt_rtc.Ex_Sensor.humi/10);


