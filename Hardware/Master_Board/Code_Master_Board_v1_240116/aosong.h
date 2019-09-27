 /* Define to prevent recursive inclusion -------------------------------------*/
#ifndef __DHT11_H
#define __DHT11_H

/* Includes ------------------------------------------------------------------*/
#include "stm32f10x.h"
/* GPIO configuration defines for 1-wire data input/output pin*/
#define GPIO_SET_AS_OUTPUT  GPIO_PinConfigure(GPIOA, 0,GPIO_OUT_PUSH_PULL,GPIO_MODE_OUT50MHZ);
#define GPIO_SET_AS_INPUT   	GPIO_PinConfigure(GPIOA, 0,GPIO_IN_PULL_UP,GPIO_MODE_INPUT);
#define GPIO_OUPUT_CLEAR    GPIO_PinWrite(GPIOA, 0, 0);   /* clear port state */
#define GPIO_OUTPUT_SET     GPIO_PinWrite(GPIOA, 0, 1);     /* set port state to 1 */
#define GPIO_INPUT_GET      GPIO_PinRead(GPIOA,0) /* should return 0 or 1 */
 
/* Optional critical section (because of delays slow as 30us) */
#define CRITICAL_SECTION_INIT
#define CRITICAL_SECTION_DEINIT
#define CRITICAL_SECTION_ENTER
#define CRITICAL_SECTION_LEAVE
 
/* optional timeouts for while() loops (in case of hardware failure) */
#define ENABLE_TIMEOUTS     /* comment to not perform timeout checks */
#define TIMEOUT_VALUE       100000
 
/* Return codes */
typedef enum DHT11_ERROR_CODE_t
{
    DHT11_OK = 0,
    DHT11_TIMEOUT,
    DHT11_WRONG_CHCKSUM
} DHT11_ERROR_CODE_t;
 
/* Interface function declarations */
void               DHT11_Init(void);
void               DHT11_Denit(void);
DHT11_ERROR_CODE_t DHT11_Read(uint8_t * const pData);



#endif /* __DHT11_H */
