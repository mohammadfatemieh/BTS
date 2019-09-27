#ifdefine
#include "stm32f10x.h"
//void TIM_Config(void);
//void USER_ADC_Init(void);
//void DMAInit(void);
//void ADC_GetValue(void);

//void measure_voltage(float *store_voltage_data);
//void Aux_RL_Control( char CMD);
void KeyPad4x4_Init(void);
uint8_t  KEY4X4_GetKey(void);
#define GLCD_BL(state) 					GPIO_PinWrite(GPIOA, 7, state)//LED LCD
#define GLCD_RW(state) 					GPIO_PinWrite(GPIOA, 5, state)//SID
#define GLCD_EN(state) 					GPIO_PinWrite(GPIOA, 6, state)//SCLK
#define GLCD_RS(state)					GPIO_PinWrite(GPIOA, 4, state)//CS
void GLCD_INIT_(void);
void glcd_write_cmd(uint8_t cmd);
void GLCD_CONST_DATA (void);
void GLCD_CONST_DATA_2 (void);
void GLCD_CONST_DATA_3 (void);
void GLCD_CONST_DATA_4 (void);
void	GLCD_GPIO_init(void);
void glcd_delay(uint8_t time);
void glcd_sendbyte(uint8_t zdata);
void glcd_write_com(uint8_t cmdcode);
void glcd_write_data(uint8_t Dispdata);
void glcd_init(void);
void glcd_put_string(char *s);
void glcd_test(void);
void GLCD_Clear(void);


void USART1_Init(void);
void USART2_Init(void);
void USART1_SendChar_(char ch);
void USART2_SendChar_(char ch);
void USART1_SendStr_(char *str);

void USER_UART_NVIC(void);

void USER_I2C_Init(void);
#define EEPROM_addr     0xAE
#define I2C_EEPROM		I2C2
#define EEPROM_ADDRESS_WRITE	0xAE
#define EEPROM_ADDRESS_READ	0xAF

void EEPROM_init(void);
uint8_t EEPROM_WriteReg(uint16_t addr, uint8_t Data);
uint8_t EEPROM_ReadReg(uint16_t addReg);
uint8_t EEPROM_W_Regs(uint16_t addr,uint16_t length,uint8_t* pdata);

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

#define SCK_H         GPIO_SetBits(SHT1x_PORT , SHT1x_SCL) //GPIOB->BSRR = GPIO_Pin_10       
#define SCK_L         GPIO_ResetBits(SHT1x_PORT , SHT1x_SCL) // GPIOB->BRR  = GPIO_Pin_10  

#define	SHT1x_SDA   	GPIO_Pin_7
#define	SHT1x_SCL   	GPIO_Pin_6
#define	SHT1x_PORT   	GPIOC
//#define RCC_APB2Periph_SHT1x_GPIO		RCC_APB2Periph_GPIOB
//#define RCC_APB1Periph_SHT1x_I2C		RCC_APB1Periph_I2C2
//#define I2C_SHT1x		I2C2

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



