/**
  ******************************************************************************
  * @file    user.c
  * @author  Ngo Quy Tuan
  * @version V1.0
  * @date    12-March-2014
  * @brief   This file provides all user functions.
  ******************************************************************************
  * @attention
  *
  ******************************************************************************
  */

/* Includes ------------------------------------------------------------------*/
#include <stdio.h>
#include "GPIO_STM32F10x.h"
#include "user.h"
#include "misc.h"
#include "stm32f10x_gpio.h"



void USART1_SendChar_(char ch) {
	while (USART_GetFlagStatus(USART1, USART_FLAG_TC) == RESET); // wait for "Transmission Complete" flag cleared
	USART_SendData(USART2,ch);
}

void USART1_SendStr_(char *str) {
	while (*str) USART1_SendChar_(*str++);
}

void USART2_TX(char *str)	
{
	while (*str) 
	{
		while (USART_GetFlagStatus(USART2, USART_FLAG_TC) == RESET);
		USART_SendData(USART2, *str++);
	}

}

/*USART2 SEND Data*/
/** 
  * @Author Anh Tuan - 02/04/2014 
  * @brief  USART2 SEND Data
  * @param  None
  * @retval None
  */
void USART2_SEND(char data_to_tx[],uint8_t length)	
{
	uint8_t i;
	for(i=0;i<length;i++)
	{
		while (USART_GetFlagStatus(USART2, USART_FLAG_TC) == RESET);
		USART_SendData(USART2, *(data_to_tx+i));
	}
	
	//USART_SendData(USART2, 0x0D);
	//while (USART_GetFlagStatus(USART2, USART_FLAG_TC) == RESET);
	//USART_SendData(USART2, 0x0A);
	//while (USART_GetFlagStatus(USART2, USART_FLAG_TC) == RESET);
}

void USER_UART_Init(void){
	USART_InitTypeDef USARTx_Init;
		/* USARTx configured as follow:
        - BaudRate = 115200 baud  
        - Word Length = 8 Bits
        - One Stop Bit
        - No parity
        - Hardware flow control disabled (RTS and CTS signals)
        - Receive and transmit enabled
  	*/

	USARTx_Init.USART_BaudRate = 115200;
	USARTx_Init.USART_WordLength = USART_WordLength_8b;
	USARTx_Init.USART_StopBits = USART_StopBits_1;
	USARTx_Init.USART_Parity = USART_Parity_No;
	USARTx_Init.USART_HardwareFlowControl = USART_HardwareFlowControl_None;
	USARTx_Init.USART_Mode = USART_Mode_Rx | USART_Mode_Tx;
	

/* Enable UART clock, if using USART2 or USART3 ... we must use RCC_APB1PeriphClockCmd(RCC_APB1Periph_USARTx, ENABLE) */
	RCC_APB1PeriphClockCmd(RCC_APB1Periph_USART2, ENABLE);
	GPIO_PortClock   (GPIOA, true);
	GPIO_PinWrite    (GPIOA, 2, 0);
	GPIO_PinConfigure(GPIOA, 2,
										GPIO_AF_PUSHPULL, 
										GPIO_MODE_OUT50MHZ);
	
	/* Configure PA2 for USART2 TX as alternate function push-pull */
	GPIO_PinConfigure(GPIOA, 3,
										GPIO_IN_FLOATING,
										GPIO_MODE_INPUT);
	/* Configure PA3 for USART2 RX as input floating */
	
	USARTx_Init.USART_BaudRate = 9600;
	/* USART configuration */
	USART_Init(USART2, &USARTx_Init);
	/* Enable USART */
	USART_Cmd(USART2, ENABLE);	
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

	USARTx_Init.USART_BaudRate = 9600;

	

	/* USART configuration */
	USART_Init(USART1, &USARTx_Init);
	/* Enable USART */
	USART_Cmd(USART1, ENABLE);
	//USART_DMACmd(USART1,USART_DMAReq_Tx,ENABLE);
	//USART_DMACmd(USART1,USART_DMAReq_Rx,ENABLE);
	USER_UART_NVIC();
}

void USER_UART_NVIC(void)
{
  NVIC_InitTypeDef  NVIC_InitStructure;
  

	NVIC_InitStructure.NVIC_IRQChannel = USART1_IRQn;
  NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0;
  NVIC_InitStructure.NVIC_IRQChannelSubPriority = 1;
  NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
  NVIC_Init(&NVIC_InitStructure);
	
	USART_ITConfig(USART1,USART_IT_RXNE,ENABLE);
}	



void USER_ADC_Init(void){
	//GPIO_InitTypeDef GPIO_InitStructure;
	ADC_InitTypeDef ADC_InitStructure;
	
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_ADC1, ENABLE);
	/* Configure PA.02 (ADC Channel) as analog input -------------------------*/
	GPIO_PinConfigure(GPIOA, 4,
										GPIO_IN_ANALOG,
										GPIO_MODE_INPUT);
	
	/* ADCx configuration ------------------------------------------------------*/
	ADC_InitStructure.ADC_Mode = ADC_Mode_Independent;
	ADC_InitStructure.ADC_ScanConvMode = DISABLE;
	ADC_InitStructure.ADC_ContinuousConvMode = ENABLE;
	ADC_InitStructure.ADC_ExternalTrigConv = ADC_ExternalTrigConv_None;
	ADC_InitStructure.ADC_DataAlign = ADC_DataAlign_Right;
	ADC_InitStructure.ADC_NbrOfChannel = 1;
	ADC_Init(ADC1, &ADC_InitStructure);	
	/* ADC1 Regular Channel 2 Configuration */
	ADC_RegularChannelConfig(ADC1, ADC_Channel_4, 1, ADC_SampleTime_55Cycles5);		
	/* Enable ADC1 */
	ADC_Cmd(ADC1, ENABLE);   

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
	ADC_SoftwareStartConvCmd(ADC1, ENABLE);

}



void delay_us(__IO uint32_t num)
{
	__IO uint32_t index = 0;
	//__IO uint32_t temp = 0;
	/* Default system clock is 72MHz */
	for(index = (10 * num); index != 0; index--);
}
//Begin of Onewire

/*******************************************************************************
Noi Dung    : Cau hinh trang thai cua mot chan I/O.
Tham Bien   : GPIOx     : GPIOA, GPIOB, GPIOC, GPIOD, GPIOE, GPIOF, GPIOG.
              GPIO_Pin  : Thu tu chan cua GPIOx.
              GPIO_Mode : Trang thai chan I/O.
Tra Ve      : Khong.
********************************************************************************/

void GPIO_SetState(GPIO_TypeDef* GPIOx,uint16_t GPIO_Pin,GPIOMode_TypeDef GPIO_Mode)
{
	GPIO_InitTypeDef GPIO_InitStructure;
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin;	         		
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_Init(GPIOx, &GPIO_InitStructure);
}

//void DS18B20_Config(uint8_t temp_low, uint8_t temp_high, uint8_t resolution)
//{
//    resolution=(resolution<<5)|0x1f;
//    DS18B20_WriteFunc(DS1820_CMD_WRITESCRPAD);        // Cho phep ghi 3 byte vao bo nho nhap: 
//    DS18B20_WriteByte(temp_high);  // byte 2: Th
//    DS18B20_WriteByte(temp_low);    // byte 3: Tl
//    DS18B20_WriteByte(resolution);  // byte 4: configuration register
//    DS18B20_WriteFunc(DS1820_CMD_COPYSCRPAD);        // Ghi vao EEPROM
//}

//float DS18B20_ReadTemp(void)
//{
//    float temp;
//    uint8_t buff_temp1,buff_temp2;
// 
//    DS18B20_WriteFunc(DS1820_CMD_CONVERTTEMP);  // Khoi dong qua trinh do va chuyen doi nhiet do ra so nhi phan
//    delay_us(200);
//    DS18B20_WriteFunc(DS1820_CMD_READSCRPAD);  // Doc du lieu tu bo nho DS18b20
// 
//    buff_temp1 = DS18B20_ReadByte();
//    temp=((float)(buff_temp1&0x0f))/16;            // Lay phan thuc cua gia tri nhiet do
//    buff_temp2 = DS18B20_ReadByte();             
//    buff_temp1 =((buff_temp1&0xf0)>>4)|((buff_temp2&0x0f)<<4) ;    // Lay phan nguyen cua gia tri nhiet do
//    temp=temp+buff_temp1;
//    return temp;   
//} 
void TM_OneWire_Init(TM_OneWire_t* OneWireStruct, GPIO_TypeDef* GPIOx, uint16_t GPIO_Pin) {
	GPIO_InitTypeDef GPIO_InitStructure;

	/* Init GPIO pin */
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;

	GPIO_Init(GPIOA, &GPIO_InitStructure);
	//TM_GPIO_Init(GPIOx, GPIO_Pin, TM_GPIO_Mode_OUT, TM_GPIO_OType_PP, TM_GPIO_PuPd_UP, TM_GPIO_Speed_Medium);
	
	/* Save settings */
	OneWireStruct->GPIOx = GPIOx;
	OneWireStruct->GPIO_Pin = GPIO_Pin;
}
uint8_t TM_OneWire_Reset(TM_OneWire_t* OneWireStruct) {
	uint8_t i;
	
	/* Line low, and wait 480us */
	ONEWIRE_LOW(OneWireStruct);
	ONEWIRE_OUTPUT(OneWireStruct);
	ONEWIRE_DELAY(48);
	
	/* Release line and wait for 70us */
	ONEWIRE_INPUT(OneWireStruct);
	ONEWIRE_DELAY(7);
	
	/* Check bit value */
	i = GPIO_PinRead(OneWireStruct->GPIOx, OneWireStruct->GPIO_Pin);
	
	/* Delay for 410 us */
	ONEWIRE_DELAY(41);
	
	/* Return value of presence pulse, 0 = OK, 1 = ERROR */
	return i;
}

void TM_OneWire_WriteBit(TM_OneWire_t* OneWireStruct, uint8_t bit) {
	if (bit) {
		/* Set line low */
		ONEWIRE_LOW(OneWireStruct);
		ONEWIRE_OUTPUT(OneWireStruct);
		ONEWIRE_DELAY(1);
		
		/* Bit high */
		ONEWIRE_INPUT(OneWireStruct);
		
		/* Wait for 60 us and release the line */
		ONEWIRE_DELAY(6);
		ONEWIRE_INPUT(OneWireStruct);
	} else {
		/* Set line low */
		ONEWIRE_LOW(OneWireStruct);
		ONEWIRE_OUTPUT(OneWireStruct);
		ONEWIRE_DELAY(7);
		
		/* Bit high */
		ONEWIRE_INPUT(OneWireStruct);
		
		/* Wait for 5 us and release the line */
		ONEWIRE_DELAY(1);
		ONEWIRE_INPUT(OneWireStruct);
	}

}
uint8_t TM_OneWire_ReadBit(TM_OneWire_t* OneWireStruct) {
	uint8_t bit = 0;
	
	/* Line low */
	ONEWIRE_LOW(OneWireStruct);
	ONEWIRE_OUTPUT(OneWireStruct);
	ONEWIRE_DELAY(1);
	
	/* Release line */
	ONEWIRE_INPUT(OneWireStruct);
	ONEWIRE_DELAY(1);
	
	/* Read line value */
	if (GPIO_PinRead(OneWireStruct->GPIOx, OneWireStruct->GPIO_Pin)) {
		/* Bit is HIGH */
		bit = 1;
	}
	
	/* Wait 50us to complete 60us period */
	ONEWIRE_DELAY(5);
	
	/* Return bit value */
	return bit;
}

void TM_OneWire_WriteByte(TM_OneWire_t* OneWireStruct, uint8_t byte) {
	uint8_t i = 8;
	/* Write 8 bits */
	while (i--) {
		/* LSB bit is first */
		TM_OneWire_WriteBit(OneWireStruct, byte & 0x01);
		byte >>= 1;
	}
}

uint8_t TM_OneWire_ReadByte(TM_OneWire_t* OneWireStruct) {
	uint8_t i = 8, byte = 0;
	while (i--) {
		byte >>= 1;
		byte |= (TM_OneWire_ReadBit(OneWireStruct) << 7);
	}
	
	return byte;
}

uint8_t TM_OneWire_First(TM_OneWire_t* OneWireStruct) {
	/* Reset search values */
	TM_OneWire_ResetSearch(OneWireStruct);

	/* Start with searching */
	return TM_OneWire_Search(OneWireStruct, ONEWIRE_CMD_SEARCHROM);
}

uint8_t TM_OneWire_Next(TM_OneWire_t* OneWireStruct) {
   /* Leave the search state alone */
   return TM_OneWire_Search(OneWireStruct, ONEWIRE_CMD_SEARCHROM);
}

void TM_OneWire_ResetSearch(TM_OneWire_t* OneWireStruct) {
	/* Reset the search state */
	OneWireStruct->LastDiscrepancy = 0;
	OneWireStruct->LastDeviceFlag = 0;
	OneWireStruct->LastFamilyDiscrepancy = 0;
}

uint8_t TM_OneWire_Search(TM_OneWire_t* OneWireStruct, uint8_t command) {
	uint8_t id_bit_number;
	uint8_t last_zero, rom_byte_number, search_result;
	uint8_t id_bit, cmp_id_bit;
	uint8_t rom_byte_mask, search_direction;

	/* Initialize for search */
	id_bit_number = 1;
	last_zero = 0;
	rom_byte_number = 0;
	rom_byte_mask = 1;
	search_result = 0;

	// if the last call was not the last one
	if (!OneWireStruct->LastDeviceFlag) {
		// 1-Wire reset
		if (TM_OneWire_Reset(OneWireStruct)) {
			/* Reset the search */
			OneWireStruct->LastDiscrepancy = 0;
			OneWireStruct->LastDeviceFlag = 0;
			OneWireStruct->LastFamilyDiscrepancy = 0;
			return 0;
		}

		// issue the search command 
		TM_OneWire_WriteByte(OneWireStruct, command);  

		// loop to do the search
		do {
			// read a bit and its complement
			id_bit = TM_OneWire_ReadBit(OneWireStruct);
			cmp_id_bit = TM_OneWire_ReadBit(OneWireStruct);

			// check for no devices on 1-wire
			if ((id_bit == 1) && (cmp_id_bit == 1)) {
				break;
			} else {
				// all devices coupled have 0 or 1
				if (id_bit != cmp_id_bit) {
					search_direction = id_bit;  // bit write value for search
				} else {
					// if this discrepancy if before the Last Discrepancy
					// on a previous next then pick the same as last time
					if (id_bit_number < OneWireStruct->LastDiscrepancy) {
						search_direction = ((OneWireStruct->ROM_NO[rom_byte_number] & rom_byte_mask) > 0);
					} else {
						// if equal to last pick 1, if not then pick 0
						search_direction = (id_bit_number == OneWireStruct->LastDiscrepancy);
					}
					
					// if 0 was picked then record its position in LastZero
					if (search_direction == 0) {
						last_zero = id_bit_number;

						// check for Last discrepancy in family
						if (last_zero < 9) {
							OneWireStruct->LastFamilyDiscrepancy = last_zero;
						}
					}
				}

				// set or clear the bit in the ROM byte rom_byte_number
				// with mask rom_byte_mask
				if (search_direction == 1) {
					OneWireStruct->ROM_NO[rom_byte_number] |= rom_byte_mask;
				} else {
					OneWireStruct->ROM_NO[rom_byte_number] &= ~rom_byte_mask;
				}
				
				// serial number search direction write bit
				TM_OneWire_WriteBit(OneWireStruct, search_direction);

				// increment the byte counter id_bit_number
				// and shift the mask rom_byte_mask
				id_bit_number++;
				rom_byte_mask <<= 1;

				// if the mask is 0 then go to new SerialNum byte rom_byte_number and reset mask
				if (rom_byte_mask == 0) {
					//docrc8(ROM_NO[rom_byte_number]);  // accumulate the CRC
					rom_byte_number++;
					rom_byte_mask = 1;
				}
			}
		} while (rom_byte_number < 8);  // loop until through all ROM bytes 0-7

		// if the search was successful then
		if (!(id_bit_number < 65)) {
			// search successful so set LastDiscrepancy,LastDeviceFlag,search_result
			OneWireStruct->LastDiscrepancy = last_zero;

			// check for last device
			if (OneWireStruct->LastDiscrepancy == 0) {
				OneWireStruct->LastDeviceFlag = 1;
			}

			search_result = 1;
		}
	}

	// if no device found then reset counters so next 'search' will be like a first
	if (!search_result || !OneWireStruct->ROM_NO[0]) {
		OneWireStruct->LastDiscrepancy = 0;
		OneWireStruct->LastDeviceFlag = 0;
		OneWireStruct->LastFamilyDiscrepancy = 0;
		search_result = 0;
	}

	return search_result;
}

int TM_OneWire_Verify(TM_OneWire_t* OneWireStruct) {
	unsigned char rom_backup[8];
	int i,rslt,ld_backup,ldf_backup,lfd_backup;

	// keep a backup copy of the current state
	for (i = 0; i < 8; i++)
	rom_backup[i] = OneWireStruct->ROM_NO[i];
	ld_backup = OneWireStruct->LastDiscrepancy;
	ldf_backup = OneWireStruct->LastDeviceFlag;
	lfd_backup = OneWireStruct->LastFamilyDiscrepancy;

	// set search to find the same device
	OneWireStruct->LastDiscrepancy = 64;
	OneWireStruct->LastDeviceFlag = 0;

	if (TM_OneWire_Search(OneWireStruct, ONEWIRE_CMD_SEARCHROM)) {
		// check if same device found
		rslt = 1;
		for (i = 0; i < 8; i++) {
			if (rom_backup[i] != OneWireStruct->ROM_NO[i]) {
				rslt = 1;
				break;
			}
		}
	} else {
		rslt = 0;
	}

	// restore the search state 
	for (i = 0; i < 8; i++) {
		OneWireStruct->ROM_NO[i] = rom_backup[i];
	}
	OneWireStruct->LastDiscrepancy = ld_backup;
	OneWireStruct->LastDeviceFlag = ldf_backup;
	OneWireStruct->LastFamilyDiscrepancy = lfd_backup;

	// return the result of the verify
	return rslt;
}

void TM_OneWire_TargetSetup(TM_OneWire_t* OneWireStruct, uint8_t family_code) {
   uint8_t i;

	// set the search state to find SearchFamily type devices
	OneWireStruct->ROM_NO[0] = family_code;
	for (i = 1; i < 8; i++) {
		OneWireStruct->ROM_NO[i] = 0;
	}
	
	OneWireStruct->LastDiscrepancy = 64;
	OneWireStruct->LastFamilyDiscrepancy = 0;
	OneWireStruct->LastDeviceFlag = 0;
}

void TM_OneWire_FamilySkipSetup(TM_OneWire_t* OneWireStruct) {
	// set the Last discrepancy to last family discrepancy
	OneWireStruct->LastDiscrepancy = OneWireStruct->LastFamilyDiscrepancy;
	OneWireStruct->LastFamilyDiscrepancy = 0;

	// check for end of list
	if (OneWireStruct->LastDiscrepancy == 0) {
		OneWireStruct->LastDeviceFlag = 1;
	}
}

uint8_t TM_OneWire_GetROM(TM_OneWire_t* OneWireStruct, uint8_t index) {
	return OneWireStruct->ROM_NO[index];
}

void TM_OneWire_Select(TM_OneWire_t* OneWireStruct, uint8_t* addr) {
	uint8_t i;
	TM_OneWire_WriteByte(OneWireStruct, ONEWIRE_CMD_MATCHROM);
	
	for (i = 0; i < 8; i++) {
		TM_OneWire_WriteByte(OneWireStruct, *(addr + i));
	}
}

void TM_OneWire_SelectWithPointer(TM_OneWire_t* OneWireStruct, uint8_t *ROM) {
	uint8_t i;
	TM_OneWire_WriteByte(OneWireStruct, ONEWIRE_CMD_MATCHROM);
	
	for (i = 0; i < 8; i++) {
		TM_OneWire_WriteByte(OneWireStruct, *(ROM + i));
	}	
}

void TM_OneWire_GetFullROM(TM_OneWire_t* OneWireStruct, uint8_t *firstIndex) {
	uint8_t i;
	for (i = 0; i < 8; i++) {
		*(firstIndex + i) = OneWireStruct->ROM_NO[i];
	}
}

uint8_t TM_OneWire_CRC8(uint8_t *addr, uint8_t len) {
	uint8_t crc = 0, inbyte, i, mix;
	
	while (len--) {
		inbyte = *addr++;
		for (i = 8; i; i--) {
			mix = (crc ^ inbyte) & 0x01;
			crc >>= 1;
			if (mix) {
				crc ^= 0x8C;
			}
			inbyte >>= 1;
		}
	}
	
	/* Return calculated CRC */
	return crc;
}

//End of Onewire
void	GLCD_GPIO_init(void)
{
	GPIO_InitTypeDef GPIO_InitStructure;
	//GLCD IO
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_5|GPIO_Pin_6|GPIO_Pin_7;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_Init(GPIOA, &GPIO_InitStructure);
	
}


void glcd_delay(uint8_t time)
{
	uint32_t i=0;
	for(i=0;i<100*time;i++);
}
void glcd_sendbyte(uint8_t zdata)
{
	unsigned int i;
	for(i=0; i<8; i++)
	{
		if((zdata << i) & 0x80)
		{
			SID(1);
		}
		else 
		{
			SID(0);
		}
		SCLK(0);
		SCLK(1);
	}
}
void glcd_write_com(uint8_t cmdcode)
{
	//CS(1);
	glcd_sendbyte(0xf8);
	glcd_sendbyte(cmdcode & 0xf0);
	glcd_sendbyte((cmdcode << 4) & 0xf0);
	glcd_delay(2);	
}
void glcd_write_data(uint8_t Dispdata)
{
	//	CS = 1;
	glcd_sendbyte(0xfa);
	glcd_sendbyte(Dispdata & 0xf0);
	glcd_sendbyte((Dispdata << 4) & 0xf0);
	glcd_delay(2);
}
void glcd_init(void)
{
	RST(0);
	glcd_delay(150);
	RST(1);
	glcd_delay(150);
	glcd_write_com(0x30);
	glcd_delay(80);
	glcd_write_com(0x0c);
	glcd_delay(50);
}

void glcd_put_string(char *s)
{
	while(*s > 0)
	{ 
		glcd_write_data(*s);
		s++;
		glcd_delay(5);
	}
}
void glcd_test(void)
{
	glcd_write_com(0x03);
	glcd_delay(10);    
	glcd_write_com(0x80);
	//glcd_put_string("Vui thay von");
	glcd_put_string("Thu 3, 13/01/15");
	glcd_write_com(0x90);
	glcd_put_string("          23:59");
	//glcd_put_string("0123456789ABCDEF");
	glcd_write_com(0x88);
	glcd_put_string("    Tu dong");
	//glcd_put_string("Sixteen symbol");
	glcd_write_com(0x98);
	glcd_put_string("    Bam tay");
}
