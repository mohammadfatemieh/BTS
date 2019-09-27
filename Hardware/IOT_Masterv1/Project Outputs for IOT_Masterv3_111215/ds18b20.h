/*****************************************************************************
  *Ten Tep          :     ds18b20.h
  *Ngay             :     19/06/2014
  *Tac Gia          :     MinhHa R&D Team
  *Cong Ty          :     MinhHaGroup
  *Webside          :     mcu.banlinhkien.vn
  *Phien Ban        :     V1.0
  *Tom Tat          :     Khai bao cac ham giao tiep DS18B20
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
#ifndef __DS18B20_H
#define __DS18B20_H

//#include "main.h"
//#include "stm32f10x.h"
#include "GPIO_STM32F10x.h"
//#include "user.h"
void mekiep(uint8_t lsb,uint8_t msb);
//#include <stdio.h>
#define DS18B20_PORT_DQ_H GPIO_PinWrite(GPIOA, 15, 1);
#define DS18B20_PORT_DQ_L GPIO_PinWrite(GPIOA, 15, 0);
// Dinh nghia do phan giai su dung
#define DS18B20_9BIT_RES 0  // Do phan giai 9bit
#define DS18B20_10BIT_RES 1 // Do phan giai 10bit
#define DS18B20_11BIT_RES 2 // Do phan giai 11bit
#define DS18B20_12BIT_RES 3 // Do phan giai 12bit

// Dinh nghia cac lenh ROM
#define DS1820_CMD_SEARCHROM     0xF0   // Tim so luong DS18B20 tren bus va gia tri 64 bit ROM cua cac DS18B20   
#define DS1820_CMD_READROM       0x33   // Doc gia tri 8 Byte ma khac tren ROM DS18B20
#define DS1820_CMD_MATCHROM      0x55   // Chon DS18B20 can giao tiep, gui truoc 64 Bit ROM DS18B20 can chon
#define DS1820_CMD_SKIPROM       0xCC   // Truy cap thang den bo nho cua DS18B20
#define DS1820_CMD_ALARMSEARCH   0xEC   // Tim DS18B20 co co bao dong duoc bat

// Dinh nghia cac lenh chuc nang
#define DS1820_CMD_CONVERTTEMP   0x44   // Khoi dong qua trinh do va chuyen doi gia tri nhiet do thanh so nhi phan
#define DS1820_CMD_WRITESCRPAD   0x4E   // Ghi gia tri vao 3 thanh ghi: TH, TL, Configuration register (Ghi tu MSB->LSB)
#define DS1820_CMD_READSCRPAD    0xBE   // Doc noi dung bo nho DS18B20: doc tu Byte0 -> Byte9, doc tu MSB->LSB
#define DS1820_CMD_COPYSCRPAD    0x48   // Copy gia tri 3 thanh ghi TH, TL, Config vao bo nho EEPROM
#define DS1820_CMD_RECALLEE      0xB8
 
void GPIO_SetState(GPIO_TypeDef* GPIOx,uint16_t GPIO_Pin,GPIOMode_TypeDef GPIO_Mode);
/*-----------------------------------------------------------------------------
Noi Dung    :   Doc 1 byte du lieu tu DS18B20 ra ngoai. 
Tham Bien   :   Khong. 
Tra Ve      :   Byte du lieu can doc.
  -----------------------------------------------------------------------------*/   
  
uint8_t DS18B20_ReadByte(void);	

/*-----------------------------------------------------------------------------
Noi Dung    :   Viet 1 byte du lieu vao DS18B20. 
Tham Bien   :   data: Byte du lieu can viet vao. 
Tra Ve      :   Khong.
  -----------------------------------------------------------------------------*/
  			
void DS18B20_WriteByte(uint8_t data);	

/*-----------------------------------------------------------------------------
Noi Dung    :   Khoi tao DS18B20. 
Tham Bien   :   Khong. 
Tra Ve      :   Gia tri tra ve khi khoi tao xong cua DS18B20 (bit).
  -----------------------------------------------------------------------------*/
  
void DS18B20_Init(void);

/*-----------------------------------------------------------------------------
Noi Dung    :   Ghi 1 byte lenh chuc nang vao DS18B20. 
Tham Bien   :   byte_func: byte lenh chuc nang cua DS18B20. 
Tra Ve      :   Khong.
  -----------------------------------------------------------------------------*/
  
void DS18B20_WriteFunc(uint8_t byte_func);

/*-----------------------------------------------------------------------------
Noi Dung    :   Cau hinh cho DS18B20. 
Tham Bien   :   temp_low: Gia tri nhiet do thap nhat de dua ra canh bao. 
                temp_high: Gia tri nhiet do cao nhat de dua ra canh bao.   
                resolution: Do phan giai cho DS18B20.
Tra Ve      :   Khong.
  -----------------------------------------------------------------------------*/
  
void DS18B20_Config(uint8_t temp_low, uint8_t temp_high, uint8_t resolution);	

/*-----------------------------------------------------------------------------
Noi Dung    :   Doc gia tri nhiet do do duoc cua DS18B20. 
Tham Bien   :   Khong. 
Tra Ve      :   Gia tri nhiet do do duoc.
  -----------------------------------------------------------------------------*/
  												
float DS18B20_ReadTemp(void);									
               
#endif 
/*------------------------------KET THUC FILE-------------------------------
 ______________________________MinhHa R&D Team______________________________*/






