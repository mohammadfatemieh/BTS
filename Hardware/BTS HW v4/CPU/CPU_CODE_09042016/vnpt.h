#include "stm32f10x.h"

//#include <stdio.h>
#define ifFired
#define ifACpowerlost
#define ifHumiHigh
//Tat quat/dieu hòa khi có canh báo cháy, khói
uint16_t afcAlarmEn =1;//true/false
//Cho phép chay dieu hòa bang máy phát
uint16_t afcGenAllow =1;//true/false
//Nguong dien áp AC chay dieu hòa
//Khi dien áp AC nho hon nguong này thì chi cho phép chay quat mà không cho phép chay dieu hòa
uint16_t afcVacTh=180;
//Nguong do am chay quat
//- Ðo am phòng = afcHn: cho phép chay quat.
//- Ðo am phòng >afcHn: không cho phép chay quat.
uint16_t afcHn=800;//80.0%
//Nhiet do phòng mong muon
uint16_t afcTlt=260;//26.0 oC
//Ðo lech nhiet do cho phép
uint16_t afcdt=60;// 6.0 oC
//Tham so on dinh dieu khien
//Tham so này có tác dung tránh viec tat/bat dieu hòa liên tuc khi nhiet do bien doi ? gan 1 nguong nào dó.
uint16_t afcN=20;// 2.0 oC
//Thoi gian chay cua moi dieu hòa khi luân phiên
uint16_t afcCycle=180;//phut
//Nguong dien áp AC chay máy phát
uint16_t gctrlVacTh=160; //V
//Nguong dien áp DC bat dau chay máy phát
uint16_t gctrlVdcTh=48;//V
//Cho phép tat máy phát khi accu dã duoc sac day
uint16_t gctrlBatFull=1; //true
//Thoi gian chay máy phát liên tuc toi da
uint16_t gctrlRunTime=240;//phut
//Thoi gian toi thieu máy phát can nghi sau khi chay liên tuc het thoi gian toi da nói trên
uint16_t gctrlRestTime=120;//phut
//Thoi gian tre tu lúc mat AC den khi ra lenh chay máy phát
uint16_t gctrlDelayTime=15; //phut
//Thoi gian (trong ngày) bat dau uu tiên chay theo thoi gian
uint16_t gctrlActivateTime=70;//7h00@@
//Thoi gian (trong ngày) ngung uu tiên chay theo thoi gian
uint16_t gctrlDeactivateTime=180;//18h00
//	Tham so kiem tra dinh ki máy phát
//Cho phép kiEm tra máy phát theo lich.
uint16_t gtestEn=0; //false
//Thoi diem bat dau kiem tra máy phát
uint16_t gtestStart=15;//1/1/2015 9:00 DM
//Chu ky kiem tra máy phát
uint16_t gtestCycle=7;// ngày
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

