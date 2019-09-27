//Inclue USE_STDPERIPH_DRIVER, STM32F10X_HD
//#include <stdio.h>
//#include <stdlib.h>
#include "GPIO_STM32F10x.h"
//#include "ds18b20.h"
#include "main.h"


void USART1_Init(void)
{
	USART_InitTypeDef USARTx_Init;
	
	USARTx_Init.USART_WordLength = USART_WordLength_8b;
	USARTx_Init.USART_StopBits = USART_StopBits_1;
	USARTx_Init.USART_Parity = USART_Parity_No;
	USARTx_Init.USART_HardwareFlowControl = USART_HardwareFlowControl_None;
	USARTx_Init.USART_Mode = USART_Mode_Rx | USART_Mode_Tx;
	USARTx_Init.USART_BaudRate = 19200;
	
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
			GLCD_RW(1);
		}
		else 
		{
			GLCD_RW(0);
		}
		GLCD_EN(0);
		GLCD_EN(1);
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
	GLCD_RS(0);
	glcd_delay(150);
	GLCD_RS(1);
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
	glcd_put_string("Vui thay von");
	glcd_put_string("Hi hi hi hi");
	glcd_write_com(0x90);
	glcd_put_string("          23:59");
	//glcd_put_string("0123456789ABCDEF");
	glcd_write_com(0x88);
	glcd_put_string("    Tu dong");
	//glcd_put_string("Sixteen symbol");
	glcd_write_com(0x98);
	glcd_put_string("    Bam tay");
}


/*****************************************************************************
  *Ten Tep          :     ds18b20.c
  *Ngay             :     19/06/2014
  *Tac Gia          :     MinhHa R&D Team
  *Cong Ty          :     MinhHaGroup
  *Webside          :     mcu.banlinhkien.vn
  *Phien Ban        :     V1.0
  *Tom Tat          :     Dinh nghia cac ham giao tiep DS18B20
  ******************************************************************************
  * Chu Y        :   Phai dinh nghia chan DQ cua cam bien DS18B20 vao file main.h  
                     Chon do phan giai cho DS18B20 trong file ds18b20.h
    #define DS18B20_DDR_DQ  DDRC_1  // Cau hinh huong IN/OUT cho chan DQ
    #define DS18B20_PIN_DQ  PINC_1  // Xuat du lieu ra cho chan DQ
    #define DS18B20_PORT_DQ PORTC_1 // Doc du lieu vao chan DQ   
    
  * Vi Du        : 
    float32_t temp=0;   // Khai bao bien luu gia tri nhiet do
    DS18B20_Config(15,40,DS18B20_9BIT_RES); // Cau hinh cho DS18B20
    LCD_Init(); // Khoi tao LCD16x2
    
    temp=DS18B20_ReadTemp();    // Doc nhiet do tu DS18B20
    sprintf(str,"temp: %2.2f\xdfC  ",temp); // Hien thi len LCD16x2
    LCD_Gotoxy(0,1);
    LCD_Puts(str);                            
  ******************************************************************************
**/


void GPIO_SetState(GPIO_TypeDef* GPIOx,uint16_t GPIO_Pin,GPIOMode_TypeDef GPIO_Mode)
{
	GPIO_InitTypeDef GPIO_InitStructure;
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin;	         		
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_Init(GPIOx, &GPIO_InitStructure);
}

/*-----------------------------------------------------------------------------
Noi Dung    :   Doc 1 byte du lieu tu DS18B20 ra ngoai. 
Tham Bien   :   Khong. 
Tra Ve      :   Byte du lieu can doc.
  -----------------------------------------------------------------------------*/ 
  
	
uint8_t DS18B20_ReadByte(void)
{   
    uint8_t i=0;
    uint8_t data=0;      
      
    for(i=8;i>0;i--)
    {    
        GPIO_SetState(GPIOB,GPIO_Pin_0,GPIO_Mode_Out_PP);   // Cau hinh chan DQ la OUPUT       
        DS18B20_PORT_DQ_L;  // Keo chan DQ xuong muc '0'
        data>>=1;
        DS18B20_PORT_DQ_H;  // Keo chan DQ len muc '1'      
        GPIO_SetState(GPIOB,GPIO_Pin_0,GPIO_Mode_IPU);   // Cau hinh chan DQ la INPUT
        if(GPIO_PinRead(GPIOB,0))data|=0x80;   // Nhan du lieu tra ve tu DS18B20
        delay_us(120);                                                 
    }
    return(data);    
}	

/*-----------------------------------------------------------------------------
Noi Dung    :   Viet 1 byte du lieu vao DS18B20. 
Tham Bien   :   data: Byte du lieu can viet vao. 
Tra Ve      :   Khong.
  -----------------------------------------------------------------------------*/
  		
void DS18B20_WriteByte(uint8_t data)
{
    uint8_t i=0;
    GPIO_SetState(GPIOB,GPIO_Pin_0,GPIO_Mode_Out_PP);   // Cau hinh chan DQ la OUTPUT
    for (i=8;i>0;i--)
    {
        DS18B20_PORT_DQ_L;  // Keo chan DQ xuong muc '0'
				//delay_us(10);
        //DS18B20_PORT_DQ=(data&0x01); // Viet du lieu vao DS18B20
				if(data&0x01) DS18B20_PORT_DQ_H;
				if(!(data&0x01)) DS18B20_PORT_DQ_L;
        delay_us(60);
        DS18B20_PORT_DQ_H;  // Keo chan DQ len muc '1'
        data>>=1;
    }    
}

/*-----------------------------------------------------------------------------
Noi Dung    :   Khoi tao DS18B20. 
Tham Bien   :   Khong. 
Tra Ve      :   Gia tri tra ve khi khoi tao xong cua DS18B20 (bit).
  -----------------------------------------------------------------------------*/
  	
void DS18B20_Init(void)
{
    GPIO_SetState(GPIOB,GPIO_Pin_0,GPIO_Mode_Out_PP);   // Cau hinh chan DQ la OUTPUT
    DS18B20_PORT_DQ_L;  // Keo DQ xuong muc '0' trong khoang 480us
    delay_us(500);       
    GPIO_SetState(GPIOB,GPIO_Pin_0,GPIO_Mode_IPU);   // Cau hinh chan DQ la INPUT trong khoang 480us
		//while(!(GPIO_PinRead(GPIOB,0)) );//DS18B20 will pull to LOW, if NOT, there is No DS18B20 inline
		//while((GPIO_PinRead(GPIOB,0)) );//After that, it will release line
		//printf("DS18B20 IniT OK\r\n");
    delay_us(500);         
}

/*-----------------------------------------------------------------------------
Noi Dung    :   Ghi 1 byte lenh chuc nang vao DS18B20. 
Tham Bien   :   byte_func: byte lenh chuc nang cua DS18B20. 
Tra Ve      :   Khong.
  -----------------------------------------------------------------------------*/
  
void DS18B20_WriteFunc(uint8_t byte_func)
{
    DS18B20_Init();                 // Khoi tao DS18B20
    DS18B20_WriteByte(DS1820_CMD_SKIPROM);  // Truy cap thang den cac lenh chuc nang bo nho cua DS18B20
    DS18B20_WriteByte(byte_func);   // Viet ma lenh chuc nang
}

/*-----------------------------------------------------------------------------
Noi Dung    :   Cau hinh cho DS18B20. 
Tham Bien   :   temp_low: Gia tri nhiet do thap nhat de dua ra canh bao. 
                temp_high: Gia tri nhiet do cao nhat de dua ra canh bao.   
                resolution: Do phan giai cho DS18B20.(1|R1|R0|1|1|1|1|1)
Tra Ve      :   Khong.
  -----------------------------------------------------------------------------*/
  
void DS18B20_Config(uint8_t temp_low, uint8_t temp_high, uint8_t resolution)
{   
    resolution=(resolution<<5)|0x1f;  
    DS18B20_WriteFunc(DS1820_CMD_WRITESCRPAD);        // Cho phep ghi 3 byte vao bo nho nhap:    
	DS18B20_WriteByte(temp_high);   // byte 2: Th
	DS18B20_WriteByte(temp_low);    // byte 3: Tl 
	DS18B20_WriteByte(resolution);  // byte 4: configuration register
    DS18B20_WriteFunc(DS1820_CMD_COPYSCRPAD);        // Ghi vao EEPROM
}	                   

/*-----------------------------------------------------------------------------
Noi Dung    :   Doc gia tri nhiet do do duoc cua DS18B20. 
Tham Bien   :   Khong. 
Tra Ve      :   Gia tri nhiet do do duoc.
  -----------------------------------------------------------------------------*/
  											
float DS18B20_ReadTemp(void)
{
    float temp;
	uint8_t buff_temp1,buff_temp2; 
    
	DS18B20_WriteFunc(DS1820_CMD_CONVERTTEMP);  // Khoi dong qua trinh do va chuyen doi nhiet do ra so nhi phan
    delay_us(200);
	DS18B20_WriteFunc(DS1820_CMD_READSCRPAD);   // Doc du lieu tu bo nho DS18b20 
    
	buff_temp1 = DS18B20_ReadByte(); 
	temp=((float)(buff_temp1&0x0f))/16;		    // Lay phan thuc cua gia tri nhiet do
	buff_temp2 = DS18B20_ReadByte(); 				
	buff_temp1 =((buff_temp1&0xf0)>>4)|((buff_temp2&0x0f)<<4) ;	// Lay phan nguyen cua gia tri nhiet do
	temp=temp+buff_temp1;
	return temp;	   
}	

void mekiep(uint8_t* a,uint8_t* b)
{
    //float temp;
	//uint8_t buff_temp1,buff_temp2; 
    
	DS18B20_WriteFunc(DS1820_CMD_CONVERTTEMP);  // Khoi dong qua trinh do va chuyen doi nhiet do ra so nhi phan
    delay_us(200);
	DS18B20_WriteFunc(DS1820_CMD_READSCRPAD);   // Doc du lieu tu bo nho DS18b20 
    
	*a = DS18B20_ReadByte(); 
	//temp=((float)(buff_temp1&0x0f))/16;		    // Lay phan thuc cua gia tri nhiet do
	*b = DS18B20_ReadByte(); 				
	//buff_temp1 =((buff_temp1&0xf0)>>4)|((buff_temp2&0x0f)<<4) ;	// Lay phan nguyen cua gia tri nhiet do
	//temp=temp+buff_temp1;	   

}
/*------------------------------KET THUC FILE-------------------------------
______________________________MinhHa R&D Team______________________________*/


