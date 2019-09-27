/*****************************************************************************
  *Ten Tep          :     24cxx.h
  *Ngay             :     20/03/2014
  *Tac Gia          :     MinhHa R&D Team
  *Cong Ty          :     MinhHaGroup
  *Webside          :     mcu.banlinhkien.vn
  *Phien Ban        :     V1.0
  *Tom Tat          :     Khai bao cac ham giao tiep IC EEPROM 24Cxx
  ******************************************************************************
  * Dia chi vung nho cua cac dong 24CXX:
    24C02 : 0 - 255
    24C04 : 0 - 511  : Chia thanh 2 phan, moi phan co 256 byte
    24C08 : 0 - 1023 : Chia thanh 4 phan, moi phan co 256 byte
    24C16 : 0 - 2047 : Chia thanh 8 phan, moi phan co 256 byte
  ******************************************************************************
 **/

#ifndef __24CXX_H
#define __24CXX_H    20032014

#include "stm32f10x.h"

#define EEP24CXX_ADDR_WRITE	0xA0
#define EEP24CXX_ADDR_READ	0xA1

/*******************************************************************************
Noi Dung    :   Kiem tra 24CXX da san sang giao tiep hay chua.
Tham Bien   :   Khong.
Tra Ve      :   Bit Ack=0: 24CXX da san sang giao tiep.
                    Ack=1: 24CXX chua san sang gia tiep.
********************************************************************************/

uint8_t EEP24CXX_IsReady(void);

/*******************************************************************************
Noi Dung    :   Ghi du lieu vao 24CXX.
Tham Bien   :   Address : Dia chi vung nho can ghi du lieu.
                Data    : Du lieu ghi vao.
Tra Ve      :   Khong.
********************************************************************************/

void EEP24CXX_WriteData(uint16_t Address, uint8_t Data);

/*******************************************************************************
Noi Dung    :   Doc du lieu tu 1 vung nho cua 24CXX ra ngoai.
Tham Bien   :   Address : Dia chi vung nho can doc du lieu.
Tra Ve      :   Du lieu doc duoc.
********************************************************************************/

uint8_t EEP24CXX_ReadData(uint16_t Address);

/*******************************************************************************
Noi Dung    :   Ghi lien tiep du lieu vao 24CXX.
Tham Bien   :   Address    : Dia chi vung nho can ghi du lieu.
                Quantity   : So luong byte du lieu can ghi vao.
                *Buff_Data : bo dem luu du lieu ghi vao.
Tra Ve      :   Khong.
********************************************************************************/

void EEP24CXX_WriteMultiData(uint16_t Address, uint16_t Quantity, uint8_t *Buff_Data);

/*******************************************************************************
Noi Dung    :   Doc du lieu tu nhieu thanh ghi lien tiep cua 24CXX ra ngoai.
Tham Bien   :   Address    : Dia chi vung nho can doc du lieu.
                Quantity   : So luong byte vung nho can doc.
                *Buff_Data : Bo dem luu du lieu doc duoc.
Tra Ve      :   Khong.
********************************************************************************/

void EEP24CXX_ReadMultiData(uint16_t Address, uint16_t Quantity, uint8_t *Buff_Data);

#endif
/*------------------------------KET THUC FILE-------------------------------
 ______________________________MinhHa R&D Team______________________________*/
 
 








