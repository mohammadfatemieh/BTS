#include "stm32f10x.h"
void TIM_Config(void);
uint16_t measure_voltage(uint8_t input);
void Aux_RL_Control( char CMD);
void KeyPad4x4_Init(void);
uint8_t  KEY4X4_GetKey(void);
#define GLCD_BL(state) 					GPIO_PinWrite(GPIOA, 7, state)//LED LCD
#define GLCD_RW(state) 					GPIO_PinWrite(GPIOA, 5, state)//SID
#define GLCD_EN(state) 					GPIO_PinWrite(GPIOA, 6, state)//SCLK
#define GLCD_RS(state)					GPIO_PinWrite(GPIOA, 4, state)//CS
void GLCD_INIT_(void);
void glcd_write_cmd(uint8_t cmd);
void GLCD_CONST_DATA (void);
void	GLCD_GPIO_init(void);
void glcd_delay(uint8_t time);
void glcd_sendbyte(uint8_t zdata);
void glcd_write_com(uint8_t cmdcode);
void glcd_write_data(uint8_t Dispdata);
void glcd_init(void);
void glcd_put_string(char *s);
void glcd_test(void);
void GLCD_Clear(void);


#define DS18B20_PORT_DQ_H GPIO_PinWrite(GPIOC, 3, 1);
#define DS18B20_PORT_DQ_L GPIO_PinWrite(GPIOC, 3, 0);
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





void USER_I2C_Init(void);
#define DS3231_addr     0xD0 // I2C 7-bit slave address shifted for 1 bit to the left
#define DS3231_seconds  0x00 // DS3231 seconds address
#define DS3231_control  0x0E // DS3231 control register address
#define DS3231_tmp_MSB  0x11 // DS3231 temperature MSB

	 /* dinh nghia giao tiep giua DS3231 va stm32f10x qua I2C */
	 #define I2C_DS3231		I2C2
	 #define DS3231_SCL		GPIO_Pin_10
	 #define DS3231_SDA		GPIO_Pin_11
	 #define RCC_APB2Periph_DS3231_GPIO		RCC_APB2Periph_GPIOB
	 #define RCC_APB1Periph_DS3231_I2C		RCC_APB1Periph_I2C2
		/* Dinh nghia cac thanh ghi cua DS3231 */
	 #define DS3231_ADDRESS_READ	0xD1
	 #define DS3231_ADDRESS_WRITE	0xD0
	 #define DS3231_SECOND_REG 		0x00
	 #define DS3231_MINUTE_REG 		0x01
	 #define DS3231_HOURS_REG 		0x02
	 #define DS3231_DAY_REG				0x03
	 #define DS3231_DATE_REG			0x04
	 #define DS3231_MONTH_REG			0x05
	 #define DS3231_YEAR_REG			0x06
	 #define DS3231_CONTROL_REG		0x0F
	 

void USER_I2C_Init(void);
void DS3231_init(void);
uint8_t DS3231_Set_Time(uint8_t sec,uint8_t min,uint8_t hr,uint8_t day,uint8_t date,uint8_t month, uint16_t year);
uint8_t DS3231_WriteReg(uint8_t addReg, uint8_t Data);
uint8_t DS3231_ReadReg(uint8_t addReg);
uint8_t DEC2BCD(uint8_t dat);
uint8_t BCD2DEC(uint8_t dat);

enum {TEMP,HUMI};

#define SCK_H         GPIO_SetBits(GPIOB , GPIO_Pin_10) //GPIOB->BSRR = GPIO_Pin_10       
#define SCK_L         GPIO_ResetBits(GPIOB , GPIO_Pin_10) // GPIOB->BRR  = GPIO_Pin_10  

#define	SHT1x_SDA   	GPIO_Pin_11
#define	SHT1x_SCL   	GPIO_Pin_10
#define RCC_APB2Periph_SHT1x_GPIO		RCC_APB2Periph_GPIOB
#define RCC_APB1Periph_SHT1x_I2C		RCC_APB1Periph_I2C2
#define I2C_SHT1x		I2C2

#define noACK 0
#define ACK   1
                                   //adr  command  r/w
#define SHT1x_STATUS_REG_W 0x06   //000   0011    0
#define SHT1x_STATUS_REG_R 0x07   //000   0011    1
#define SHT1x_MEASURE_TEMP 0x03   //000   0001    1
#define SHT1x_MEASURE_HUMI 0x05   //000   0010    1
#define SHT1x_RESET        0x1e   //000   1111    0
void SHT1x_init(void);
void s_transstart(void);
void calc_sth1x(float *p_humidity ,float *p_temperature);
float calc_dewpoint(float h,float t);
char s_write_byte(unsigned char value);
char s_read_byte(unsigned char ack);
void s_connectionreset(void);
char s_softreset(void);
char s_read_statusreg(unsigned char *p_value, unsigned char *p_checksum);
char s_write_statusreg(unsigned char *p_value);
char s_measure(uint16_t *p_value, unsigned char *p_checksum, unsigned char mode);



