#ifndef TM_AM2301_H
#define TM_AM2301_H 130

/* C++ detection */
#ifdef __cplusplus
extern C {
#endif
#include "stm32f10x.h"
/**
 * @defgroup TM_AM2301_Macros
 * @brief    Library defines
 * @{
 */

/**
 * @brief  Default data pin, overwrite it in defines.h file 
 */
//#ifndef AM2301_PIN
//#define AM2301_PORT				GPIOD
//#define AM2301_PIN				GPIO_PIN_1
//#endif

/* Pin settings */
#define AM2301_PIN_LOW			GPIO_PinWrite(GPIOA, 0, 0);
#define AM2301_PIN_HIGH			GPIO_PinWrite(GPIOA, 0, 1);
#define AM2301_PIN_IN			GPIO_PinConfigure(GPIOA, 0,GPIO_IN_PULL_UP,GPIO_MODE_INPUT);
#define AM2301_PIN_OUT			GPIO_PinConfigure(GPIOA, 0,GPIO_OUT_PUSH_PULL,GPIO_MODE_OUT50MHZ);
#define AM2301_PIN_READ			GPIO_PinRead(GPIOA,0)

/**
 * @}
 */
 
/**
 * @defgroup TM_AM2301_Typedefs
 * @brief    Library Typedefs
 * @{
 */

/**
 * Enumerations
 *
 * There are several different possible results.
 * If TM_AM2301_OK is returned from read function then you have valid data.
 */
typedef enum {
	TM_AM2301_OK,						/*!< Data OK */
	TM_AM2301_ERROR,					/*!< An error occurred */
	TM_AM2301_CONNECTION_ERROR,			/*!< Device is not connected */
	TM_AM2301_WAITHIGH_ERROR,           /*!< Wait high pulse timeout */
	TM_AM2301_WAITLOW_ERROR,            /*!< Wait low pulse timeout */
	TM_AM2301_WAITHIGH_LOOP_ERROR,      /*!< Loop error for high pulse */
 	TM_AM2301_WAITLOW_LOOP_ERROR,       /*!< Loop error for low pulse */
	TM_AM2301_PARITY_ERROR				/*!< Data read fail */
} TM_AM2301_t;

/**
 * @brief  AM2301 main data structure		
 */
typedef struct {
	int16_t Temp; /*!< Temperature in tenths of degrees.
	                   If real temperature is 27.3°C, this variable's value is 273 */
	uint16_t Hum; /*!< Humidity in tenths of percent.
	                   If real humidity is 55.5%, this variable's value is 555 */
} TM_AM2301_Data_t;

/**
 * @}
 */

/**
 * @defgroup TM_AM2301_Functions
 * @brief    Library Functions
 * @{
 */

/**
 * @brief  Initializes AM2301 sensor
 * @param  None
 * @retval TM_AM2301_OK
 */
TM_AM2301_t TM_AM2301_Init(void);

/**
 * @brief  Reads data from sensor
 * @param  *data: Pointer to @ref TM_AM2301_Data_t data structure to store data into
 * @retval Data valid:
 *            - TM_AM2301_OK: Data valid
 *            - Else: Data not valid
 */
TM_AM2301_t TM_AM2301_Read(TM_AM2301_Data_t* data);
TM_AM2301_t TM_AM2301_INT_Read(TM_AM2301_Data_t* data); 

/**
 * @}
 */
 
/**
 * @}
 */
 
/**
 * @}
 */

/* C++ detection */
#ifdef __cplusplus
}
#endif


#endif


