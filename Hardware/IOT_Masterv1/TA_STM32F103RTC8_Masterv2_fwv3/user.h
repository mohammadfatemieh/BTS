#include "stm32f10x.h"


void USER_UART_Init(void);
void USER_USART1_TX(uint8_t data);
void USER_UART_NVIC(void);
void USART2_SEND(char data_to_tx[],uint8_t length);
void USART2_TX(char *str)	;	
void USER_ADC_Init(void);


//Begin of Onewire
void GPIO_SetState(GPIO_TypeDef* GPIOx,uint16_t GPIO_Pin,GPIOMode_TypeDef GPIO_Mode);
/* OneWire delay */
#define ONEWIRE_DELAY(x)				glcd_delay(x)
/* Pin settings */
#define ONEWIRE_LOW(structure)			GPIO_PinWrite((structure)->GPIOx, (structure)->GPIO_Pin,0)
#define ONEWIRE_HIGH(structure)			GPIO_PinWrite((structure)->GPIOx, (structure)->GPIO_Pin,1)
#define ONEWIRE_INPUT(structure)		GPIO_PinConfigure(structure->GPIOx, (structure)->GPIO_Pin,GPIO_IN_PULL_UP, GPIO_MODE_INPUT)
#define ONEWIRE_OUTPUT(structure)		GPIO_PinConfigure(structure->GPIOx, (structure)->GPIO_Pin, GPIO_OUT_PUSH_PULL, GPIO_MODE_OUT10MHZ)

/* OneWire commands */
#define ONEWIRE_CMD_RSCRATCHPAD			0xBE
#define ONEWIRE_CMD_WSCRATCHPAD			0x4E
#define ONEWIRE_CMD_CPYSCRATCHPAD		0x48
#define ONEWIRE_CMD_RECEEPROM			0xB8
#define ONEWIRE_CMD_RPWRSUPPLY			0xB4
#define ONEWIRE_CMD_SEARCHROM			0xF0
#define ONEWIRE_CMD_READROM				0x33
#define ONEWIRE_CMD_MATCHROM			0x55
#define ONEWIRE_CMD_SKIPROM				0xCC
/**
 * @brief  OneWire working struct
 * @note   Except ROM_NO member, everything is fully private and should not be touched by user
 */
typedef struct {
	GPIO_TypeDef* GPIOx;           /*!< GPIOx port to be used for I/O functions */
	uint16_t GPIO_Pin;             /*!< GPIO Pin to be used for I/O functions */
	uint8_t LastDiscrepancy;       /*!< Search private */
	uint8_t LastFamilyDiscrepancy; /*!< Search private */
	uint8_t LastDeviceFlag;        /*!< Search private */
	uint8_t ROM_NO[8];             /*!< 8-bytes address of last search device */
} TM_OneWire_t;

/**
 * @brief  Initializes OneWire bus
 * @param  *OneWireStruct: Pointer to @ref TM_OneWire_t empty working onewire structure
 * @param  *Pointer to GPIO port used for onewire channel
 * @param  GPIO_Pin: GPIO Pin on specific GPIOx to be used for onewire channel
 * @retval None
 */
void TM_OneWire_Init(TM_OneWire_t* OneWireStruct, GPIO_TypeDef* GPIOx, uint16_t GPIO_Pin);

/**
 * @brief  Resets OneWire bus
 * 
 * @note   Sends reset command for OneWire
 * @param  *OneWireStruct: Pointer to @ref TM_OneWire_t working onewire structure
 * @retval None
 */
uint8_t TM_OneWire_Reset(TM_OneWire_t* OneWireStruct);

/**
 * @brief  Reads byte from one wire bus
 * @param  *OneWireStruct: Pointer to @ref TM_OneWire_t working onewire structure
 * @retval Byte from read operation
 */
uint8_t TM_OneWire_ReadByte(TM_OneWire_t* OneWireStruct);

/**
 * @brief  Writes byte to bus
 * @param  *OneWireStruct: Pointer to @ref TM_OneWire_t working onewire structure
 * @param  byte: 8-bit value to write over OneWire protocol
 * @retval None
 */
void TM_OneWire_WriteByte(TM_OneWire_t* OneWireStruct, uint8_t byte);

/**
 * @brief  Writes single bit to onewire bus
 * @param  *OneWireStruct: Pointer to @ref TM_OneWire_t working onewire structure
 * @param  bit: Bit value to send, 1 or 0
 * @retval None
 */
void TM_OneWire_WriteBit(TM_OneWire_t* OneWireStruct, uint8_t bit);

/**
 * @brief  Reads single bit from one wire bus
 * @param  *OneWireStruct: Pointer to @ref TM_OneWire_t working onewire structure
 * @retval Bit value:
 *            - 0: Bit is low (zero)
 *            - > 0: Bit is high (one)
 */
uint8_t TM_OneWire_ReadBit(TM_OneWire_t* OneWireStruct);

/**
 * @brief  Searches for OneWire devices on specific Onewire port
 * @note   Not meant for public use. Use @ref TM_OneWire_First and @ref TM_OneWire_Next for this.
 * @param  *OneWireStruct: Pointer to @ref TM_OneWire_t working onewire structure where to search
 * @param  Device status:
 *            - 0: No devices detected
 *            - > 0: Device detected
 */
uint8_t TM_OneWire_Search(TM_OneWire_t* OneWireStruct, uint8_t command);

/**
 * @brief  Resets search states
 * @param  *OneWireStruct: Pointer to @ref TM_OneWire_t working onewire where to reset search values
 * @retval None
 */
void TM_OneWire_ResetSearch(TM_OneWire_t* OneWireStruct);

/**
 * @brief  Starts search, reset states first
 * @note   When you want to search for ALL devices on one onewire port, you should first use this function.
@verbatim
/...Initialization before
status = TM_OneWire_First(&OneWireStruct);
while (status) {
	//Save ROM number from device
	TM_OneWire_GetFullROM(ROM_Array_Pointer);
	//Check for new device
	status = TM_OneWire_Next(&OneWireStruct);
}
@endverbatim
 * @param  *OneWireStruct: Pointer to @ref TM_OneWire_t working onewire where to reset search values
 * @param  Device status:
 *            - 0: No devices detected
 *            - > 0: Device detected
 */
uint8_t TM_OneWire_First(TM_OneWire_t* OneWireStruct);

/**
 * @brief  Reads next device
 * @note   Use @ref TM_OneWire_First to start searching
 * @param  *OneWireStruct: Pointer to @ref TM_OneWire_t working onewire
 * @param  Device status:
 *            - 0: No devices detected any more
 *            - > 0: New device detected
 */
uint8_t TM_OneWire_Next(TM_OneWire_t* OneWireStruct);

/**
 * @brief  Gets ROM number from device from search
 * @param  *OneWireStruct: Pointer to @ref TM_OneWire_t working onewire
 * @param  index: Because each device has 8-bytes long ROm address, you have to call this 8 times, to get ROM bytes from 0 to 7
 * @reetval ROM byte for index (0 to 7) at current found device
 */
uint8_t TM_OneWire_GetROM(TM_OneWire_t* OneWireStruct, uint8_t index);

/**
 * @brief  Gets all 8 bytes ROM value from device from search
 * @param  *OneWireStruct: Pointer to @ref TM_OneWire_t working onewire
 * @param  *firstIndex: Pointer to first location for first byte, other bytes are automatically incremented
 * @retval None
 */
void TM_OneWire_GetFullROM(TM_OneWire_t* OneWireStruct, uint8_t *firstIndex);

/**
 * @brief  Selects specific slave on bus
 * @param  *OneWireStruct: Pointer to @ref TM_OneWire_t working onewire
 * @param  *addr: Pointer to first location of 8-bytes long ROM address
 * @retval None
 */
void TM_OneWire_Select(TM_OneWire_t* OneWireStruct, uint8_t* addr);

/**
 * @brief  Selects specific slave on bus with pointer address
 * @param  *OneWireStruct: Pointer to @ref TM_OneWire_t working onewire
 * @param  *ROM: Pointer to first byte of ROM address
 * @retval None
 */
void TM_OneWire_SelectWithPointer(TM_OneWire_t* OneWireStruct, uint8_t* ROM);

/**
 * @brief  Calculates 8-bit CRC for 1-wire devices
 * @param  *addr: Pointer to 8-bit array of data to calculate CRC
 * @param  len: Number of bytes to check
 *
 * @retval Calculated CRC from input data
 */
uint8_t TM_OneWire_CRC8(uint8_t* addr, uint8_t len);



//End of Onewire
#define SID(state) 						GPIO_PinWrite(GPIOA, 6, state)
#define SCLK(state) 					GPIO_PinWrite(GPIOA, 5, state)
#define RST(state)						GPIO_PinWrite(GPIOA, 7, state)
void	GLCD_GPIO_init(void);
void glcd_delay(uint8_t time);
void glcd_sendbyte(uint8_t zdata);
void glcd_write_com(uint8_t cmdcode);
void glcd_write_data(uint8_t Dispdata);
void glcd_init(void);
void glcd_put_string(char *s);
void glcd_test(void);


#define DS3231_addr     0xD0 // I2C 7-bit slave address shifted for 1 bit to the left
#define DS3231_seconds  0x00 // DS3231 seconds address
#define DS3231_control  0x0E // DS3231 control register address
#define DS3231_tmp_MSB  0x11 // DS3231 temperature MSB

	 /* dinh nghia giao tiep giua DS3231 va stm32f10x qua I2C */
	 #define I2C_DS3231		I2C1
	 #define DS3231_SCL		GPIO_Pin_6
	 #define DS3231_SDA		GPIO_Pin_7
	 #define RCC_APB2Periph_DS3231_GPIO		RCC_APB2Periph_GPIOB
	 #define RCC_APB1Periph_DS3231_I2C		RCC_APB1Periph_I2C1
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
//uint8_t DS3231_ReadTemp(void) ;
//void DS3231_DateToDateStr(DS3231_date_TypeDef* raw_date, char *str) ;
//void DS3231_DateToTimeStr(DS3231_date_TypeDef* raw_date, char *str);
//void DS3231_ReadDate(HRF_date_TypeDef* hrf_date);
//void DS3231_WriteDateRAW(DS3231_date_TypeDef* date);
//void DS3231_ReadDateRAW(DS3231_date_TypeDef* date);
uint8_t DEC2BCD(uint8_t dat);
uint8_t BCD2DEC(uint8_t dat);

	 
	 #define BH1750_ADD     0x46 // I2C 7-bit slave address shifted for 1 bit to the left
	 	 /* dinh nghia giao tiep giua BH1750 va stm32f10x qua I2C */
	 #define I2C_BH1750		I2C1
	 #define BH1750_SCL		GPIO_Pin_6
	 #define BH1750_SDA		GPIO_Pin_7
	 #define RCC_APB2Periph_BH1750_GPIO		RCC_APB2Periph_GPIOB
	 #define RCC_APB1Periph_BH1750_I2C		RCC_APB1Periph_I2C1
		/* Dinh nghia cac thanh ghi cua BH1750 */
	 #define BH1750_ADDRESS_READ	0x47
	 #define BH1750_ADDRESS_WRITE	0x46

	 

#if nRF24L01


/////////////////////////////////////////////////////////////
#define TX_ADR_WIDTH    5   // 5 bytes TX(RX) address width
#define RX_ADR_WIDTH		5
#define TX_PLOAD_WIDTH  32  // 20 bytes TX payload
#define RX_PLOAD_WIDTH	32




//****************************************************************//
// SPI(nRF24L01) commands
//#define READ_REG        0x00  // Define read command to register
//#define WRITE_REG       0x20  // Define write command to register
//#define RD_RX_PLOAD     0x61  // Define RX payload register address
//#define WR_TX_PLOAD     0xA0  // Define TX payload register address
//#define FLUSH_TX        0xE1  // Define flush TX register command
//#define FLUSH_RX        0xE2  // Define flush RX register command
//#define REUSE_TX_PL     0xE3  // Define reuse TX payload register command
//#define NOP             0xFF  // Define No Operation, might be used to read status register

//***************************************************//
// SPI(nRF24L01) registers(addresses)
//#define CONFIG          0x00  // 'Config' register address
//#define EN_AA           0x01  // 'Enable Auto Acknowledgment' register address
//#define EN_RXADDR       0x02  // 'Enabled RX addresses' register address
//#define SETUP_AW        0x03  // 'Setup address width' register address
//#define SETUP_RETR      0x04  // 'Setup Auto. Retrans' register address
//#define RF_CH           0x05  // 'RF channel' register address
//#define RF_SETUP        0x06  // 'RF setup' register address
//#define STATUS          0x07  // 'Status' register address
//#define OBSERVE_TX      0x08  // 'Observe TX' register address
//#define CD              0x09  // 'Carrier Detect' register address
//#define RX_ADDR_P0      0x0A  // 'RX address pipe0' register address
//#define RX_ADDR_P1      0x0B  // 'RX address pipe1' register address
//#define RX_ADDR_P2      0x0C  // 'RX address pipe2' register address
//#define RX_ADDR_P3      0x0D  // 'RX address pipe3' register address
//#define RX_ADDR_P4      0x0E  // 'RX address pipe4' register address
//#define RX_ADDR_P5      0x0F  // 'RX address pipe5' register address
//#define TX_ADDR         0x10  // 'TX address' register address
//#define RX_PW_P0        0x11  // 'RX payload width, pipe0' register address
//#define RX_PW_P1        0x12  // 'RX payload width, pipe1' register address
//#define RX_PW_P2        0x13  // 'RX payload width, pipe2' register address
//#define RX_PW_P3        0x14  // 'RX payload width, pipe3' register address
//#define RX_PW_P4        0x15  // 'RX payload width, pipe4' register address
//#define RX_PW_P5        0x16  // 'RX payload width, pipe5' register address
//#define FIFO_STATUS     0x17  // 'FIFO Status Register' register address
//#define RF_READ_REG    0x00  // Define read command to register
//#define RF_WRITE_REG   0x20  // Define write command to register
//#define RD_RX_PLOAD 0x61  // Define RX payload register address
//#define WR_TX_PLOAD 0xA0  // Define TX payload register address
//#define FLUSH_TX    0xE1  // Define flush TX register command
//#define FLUSH_RX    0xE2  // Define flush RX register command
//#define REUSE_TX_PL 0xE3  // Define reuse TX payload register command
//#define NOP         0xFF  // Define No Operation, might be used to read status register

#define  RX_DR  ((sta>>6)&0X01)
#define  TX_DS  ((sta>>5)&0X01)
#define  MAX_RT  ((sta>>4)&0X01)


void RX_Mode(void);
//void TX_Mode(void);
unsigned char nRF24L01_RxPacket(unsigned char* rx_buf);
//void nRF24L01_TxPacket_T(char *tx_buf);


///////////////////////////////////////////////////////////////////////////////////

/* Which SPI use */
	//#define SPI_PORT      SPI4
	//#define SPI_SCK_PIN   GPIO_Pin_5     // PA5
	//#define SPI_MISO_PIN  GPIO_Pin_6     // PA6
	//#define SPI_MOSI_PIN  GPIO_Pin_7     // PA7
	//#define SPI_CS_PIN    GPIO_Pin_0     // PB0 mach cung
	//#define SPI_CE_PIN    GPIO_Pin_1     // PB1 mach cung
	//#define SPI_GPIO_PORT GPIOA


// nRF24L01 CS (Chip Select) pin
#define nRF24_CS_PORT     GPIOB
#define nRF24_CS_PIN      GPIO_Pin_0    // PB0

// nRF24L01 CE (Chip Enable) pin
#define nRF24_CE_PORT     GPIOB
#define nRF24_CE_PIN      GPIO_Pin_1    // PB1

// nRF24L01 IRQ pin
#define nRF24_IRQ_PORT    GPIOB
#define nRF24_IRQ_PIN     GPIO_Pin_10    // PB10

// Chip Enable Activates RX or TX mode PB1
#define CE_L() GPIO_PinWrite    (GPIOB, 1, 0)
#define CE_H() GPIO_PinWrite    (GPIOB, 1, 1)


// SPI Chip Select PB0
#define CSN_L() GPIO_PinWrite    (GPIOB, 0, 0)
#define CSN_H() GPIO_PinWrite    (GPIOB, 0, 1)


/* nRF24L0 commands */
#define nRF24_CMD_RREG             0x00  // R_REGISTER -> Read command and status registers
#define nRF24_CMD_WREG             0x20  // W_REGISTER -> Write command and status registers
#define nRF24_CMD_R_RX_PAYLOAD     0x61  // R_RX_PAYLOAD -> Read RX payload
#define nRF24_CMD_W_TX_PAYLOAD     0xA0  // W_TX_PAYLOAD -> Write TX payload
#define nRF24_CMD_FLUSH_TX         0xE1  // FLUSH_TX -> Flush TX FIFO
#define nRF24_CMD_FLUSH_RX         0xE2  // FLUSH_RX -> Flush RX FIFO
#define nRF24_CMD_REUSE_TX_PL      0xE3  // REUSE_TX_PL -> Reuse last transmitted payload
#define nRF24_CMD_NOP              0xFF  // No operation (to read status register)

/* nRF24L0 registers */
#define nRF24_REG_CONFIG           0x00  // Configuration register
#define nRF24_REG_EN_AA            0x01  // Enable "Auto acknowledgment"
#define nRF24_REG_EN_RXADDR        0x02  // Enable RX addresses
#define nRF24_REG_SETUP_AW         0x03  // Setup of address widths
#define nRF24_REG_SETUP_RETR       0x04  // Setup of automatic retranslation
#define nRF24_REG_RF_CH            0x05  // RF channel
#define nRF24_REG_RF_SETUP         0x06  // RF setup register
#define nRF24_REG_STATUS           0x07  // Status register
#define nRF24_REG_OBSERVE_TX       0x08  // Transmit observe register
#define nRF24_REG_CD               0x09  // Carrier detect
#define nRF24_REG_RX_ADDR_P0       0x0A  // Receive address data pipe 0
#define nRF24_REG_RX_ADDR_P1       0x0B  // Receive address data pipe 1
#define nRF24_REG_RX_ADDR_P2       0x0C  // Receive address data pipe 2
#define nRF24_REG_RX_ADDR_P3       0x0D  // Receive address data pipe 3
#define nRF24_REG_RX_ADDR_P4       0x0E  // Receive address data pipe 4
#define nRF24_REG_RX_ADDR_P5       0x0F  // Receive address data pipe 5
#define nRF24_REG_TX_ADDR          0x10  // Transmit address
#define nRF24_REG_RX_PW_P0         0x11  // Number of bytes in RX payload id data pipe 0
#define nRF24_REG_RX_PW_P1         0x12  // Number of bytes in RX payload id data pipe 1
#define nRF24_REG_RX_PW_P2         0x13  // Number of bytes in RX payload id data pipe 2
#define nRF24_REG_RX_PW_P3         0x14  // Number of bytes in RX payload id data pipe 3
#define nRF24_REG_RX_PW_P4         0x15  // Number of bytes in RX payload id data pipe 4
#define nRF24_REG_RX_PW_P5         0x16  // Number of bytes in RX payload id data pipe 5
#define nRF24_REG_FIFO_STATUS      0x17  // FIFO status register
#define nRF24_REG_DYNPD            0x1C  // Enable dynamic payload length
#define nRF24_REG_FEATURE          0x1D  // Feature register

/* nRF24L0 bits */
#define nRF24_MASK_RX_DR           0x40  // Mask interrupt caused by RX_DR
#define nRF24_MASK_TX_DS           0x20  // Mask interrupt caused by TX_DS
#define nRF24_MASK_MAX_RT          0x10  // Mask interrupt caused by MAX_RT
#define nRF24_FIFO_RX_EMPTY        0x01  // RX FIFO empty flag
#define nRF24_FIFO_RX_FULL         0x02  // RX FIFO full flag

/* Some constants */
//#define nRF24_RX_ADDR_WIDTH        5    // nRF24 RX address width
//#define nRF24_TX_ADDR_WIDTH        5    // nRF24 TX address width

//#define TX_PLOAD_WIDTH  32  	// 32 TX payload
//#define RX_PLOAD_WIDTH  32  	// 32 uints TX payload


/* Variables */
//extern uint8_t nRF24_RX_addr[nRF24_RX_ADDR_WIDTH];
//extern uint8_t nRF24_TX_addr[nRF24_TX_ADDR_WIDTH];


/* Function prototypes */
void nRF24_init();
uint8_t nRF24_ReadWrite(uint8_t data);
uint8_t nRF24_RWReg(uint8_t reg, uint8_t value);
uint8_t nRF24_ReadReg(uint8_t reg);
uint8_t nRF24_ReadBuf(uint8_t reg, uint8_t *pBuf, uint8_t count);
uint8_t nRF24_WriteBuf(uint8_t reg, uint8_t *pBuf, uint8_t count);
void nRF24_TXPacket(uint8_t *pBuf, uint8_t TX_PAYLOAD);
uint8_t nRF24_Check(void);

void nRF24_RXMode(uint8_t RX_PAYLOAD);
void nRF24_TXMode(void);
uint8_t nRF24_DataReady(void);
//uint8_t nRF24_TXPacket(uint8_t * pBuf, uint8_t TX_PAYLOAD);
uint8_t nRF24_RXPacket(uint8_t* pBuf, uint8_t RX_PAYLOAD);
void nRF24_ClearIRQFlags(void);
void EXTI_config(void);
unsigned char nRF24L01_RxPacket(unsigned char* rx_buf);
void delay_us(__IO uint32_t num);
#endif



