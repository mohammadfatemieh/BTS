#include "stm32f10x.h"

//#include <stdio.h>
#define ifFired
#define ifACpowerlost
#define ifHumiHigh
//Tat quat/dieu h�a khi c� canh b�o ch�y, kh�i
uint16_t afcAlarmEn =1;//true/false
//Cho ph�p chay dieu h�a bang m�y ph�t
uint16_t afcGenAllow =1;//true/false
//Nguong dien �p AC chay dieu h�a
//Khi dien �p AC nho hon nguong n�y th� chi cho ph�p chay quat m� kh�ng cho ph�p chay dieu h�a
uint16_t afcVacTh=180;
//Nguong do am chay quat
//- �o am ph�ng = afcHn: cho ph�p chay quat.
//- �o am ph�ng >afcHn: kh�ng cho ph�p chay quat.
uint16_t afcHn=800;//80.0%
//Nhiet do ph�ng mong muon
uint16_t afcTlt=260;//26.0 oC
//�o lech nhiet do cho ph�p
uint16_t afcdt=60;// 6.0 oC
//Tham so on dinh dieu khien
//Tham so n�y c� t�c dung tr�nh viec tat/bat dieu h�a li�n tuc khi nhiet do bien doi ? gan 1 nguong n�o d�.
uint16_t afcN=20;// 2.0 oC
//Thoi gian chay cua moi dieu h�a khi lu�n phi�n
uint16_t afcCycle=180;//phut
//Nguong dien �p AC chay m�y ph�t
uint16_t gctrlVacTh=160; //V
//Nguong dien �p DC bat dau chay m�y ph�t
uint16_t gctrlVdcTh=48;//V
//Cho ph�p tat m�y ph�t khi accu d� duoc sac day
uint16_t gctrlBatFull=1; //true
//Thoi gian chay m�y ph�t li�n tuc toi da
uint16_t gctrlRunTime=240;//phut
//Thoi gian toi thieu m�y ph�t can nghi sau khi chay li�n tuc het thoi gian toi da n�i tr�n
uint16_t gctrlRestTime=120;//phut
//Thoi gian tre tu l�c mat AC den khi ra lenh chay m�y ph�t
uint16_t gctrlDelayTime=15; //phut
//Thoi gian (trong ng�y) bat dau uu ti�n chay theo thoi gian
uint16_t gctrlActivateTime=70;//7h00@@
//Thoi gian (trong ng�y) ngung uu ti�n chay theo thoi gian
uint16_t gctrlDeactivateTime=180;//18h00
//	Tham so kiem tra dinh ki m�y ph�t
//Cho ph�p kiEm tra m�y ph�t theo lich.
uint16_t gtestEn=0; //false
//Thoi diem bat dau kiem tra m�y ph�t
uint16_t gtestStart=15;//1/1/2015 9:00 DM
//Chu ky kiem tra m�y ph�t
uint16_t gtestCycle=7;// ng�y
//Thoi gian moi lan kiem tra
uint16_t gtestTime=5;// phut

uint16_t default_value_eeprom[20]={1,1,180,800,260,60,20,180,160,48,1,240,120,15,70,180,0,15,7,5};
uint16_t save_config_data[20];
#define ADD_afcAlarmEn           					((uint16_t)0x0000)
#define ADD_afcGenAllow           				((uint16_t)0x0001)
#define ADD_afcVacTh          						((uint16_t)0x0002)
#define ADD_afcHn           							((uint16_t)0x0003)
#define ADD_afcTlt           							((uint16_t)0x0004)
#define ADD_afcdt           							((uint16_t)0x0005)
#define ADD_afcN           								((uint16_t)0x0006)
#define ADD_afcCycle           						((uint16_t)0x0007)
#define ADD_gctrlVacTh           					((uint16_t)0x0008)
#define ADD_gctrlVdcTh           					((uint16_t)0x0009)
#define ADD_gctrlBatFull          				((uint16_t)0x0010)
#define ADD_gctrlRunTime           				((uint16_t)0x0011)
#define ADD_gctrlRestTime           			((uint16_t)0x0012)
#define ADD_gctrlDelayTime           			((uint16_t)0x0013)
#define ADD_gctrlActivateTime          		((uint16_t)0x0014)
#define ADD_gctrlDeactivateTime           ((uint16_t)0x0015)
#define ADD_gtestEn           						((uint16_t)0x0016)
#define ADD_gtestStart           					((uint16_t)0x0017)
#define ADD_gtestCycle           					((uint16_t)0x0018)
#define ADD_gtestTime           					((uint16_t)0x0019)

