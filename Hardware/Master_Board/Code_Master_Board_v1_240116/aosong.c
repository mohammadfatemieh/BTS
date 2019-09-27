#include "aosong.h"
#include <stdio.h>
#include <math.h>
#include "GPIO_STM32F10x.h"
#include "TA_Master_HW2_drivers.h"
#include "misc.h"
#include "stm32f10x_gpio.h"
#define HIGH 1
#define LOW 0
#define         SHT11_LOW         GPIO_PinWrite(DHT11_PORT,DHT11_PIN,1)
#define         SHT11_HIGH         GPIO_PinWrite(DHT11_PORT,DHT11_PIN,0)
#define MAXTIMINGS	85
#define DHTPIN		7
int dht11_dat[5] = { 0, 0, 0, 0, 0 };


/*******************************************************************************
* Function Name  : delay_ms
* Description    : Delay Time
* Input          : - nCount: Delay Time
* Output         : None
* Return         : None
* Return         : None
* Attention		 : None
*******************************************************************************/
static void delay_ms(uint16_t nms)    
{ 
	__IO uint32_t index = 0;
	
	/* Default system clock is 72MHz */
	for(index = (6000 * nms); index != 0; index--);
} 

static void delay_us(__IO uint32_t num)
{
	__IO uint32_t index = 0;
	
	/* Default system clock is 72MHz */
	for(index = (6 * num); index != 0; index--);
}

void DHT11_Init(void)
{
    CRITICAL_SECTION_INIT;
    
}
 
void DHT11_Denit(void)
{
    
    CRITICAL_SECTION_DEINIT;
}

DHT11_ERROR_CODE_t DHT11_Read(uint8_t * const pData)
{
    int i = 0;
    int j = 0;
    DHT11_ERROR_CODE_t errorCode = DHT11_OK;
     
    #ifdef ENABLE_TIMEOUTS
    int timeout = TIMEOUT_VALUE;
    #endif
 
    GPIO_SET_AS_OUTPUT;
     
    CRITICAL_SECTION_ENTER;
     
    
     
    /* start sequence */
    GPIO_OUPUT_CLEAR;    
    delay_ms(1);//18
 
    GPIO_OUTPUT_SET;
    delay_us(20);//40
 
    GPIO_SET_AS_INPUT;
 
    while(0 == GPIO_INPUT_GET) /* 80us on '0' */
    {
        #ifdef ENABLE_TIMEOUTS
        if (--(timeout) <= 0)
        {
            errorCode = DHT11_TIMEOUT;
            break;
        }
        #endif
    };
     
    #ifdef ENABLE_TIMEOUTS
    timeout = TIMEOUT_VALUE;
    #endif
    if (DHT11_OK == errorCode)
    {
        while(1 == GPIO_INPUT_GET) /* 80us on '1' */
        {
            #ifdef ENABLE_TIMEOUTS
            if (--(timeout) <= 0)
            {
                errorCode = DHT11_TIMEOUT;
                break;
            }
            #endif
        };
    }        
    /* start sequence - end */
 
    /* read sequence */
    if (DHT11_OK == errorCode)
    {
        for(j=0;j<5;j++)
        {
            for(i=0;i<8;i++)
            {
                #ifdef ENABLE_TIMEOUTS
                timeout = TIMEOUT_VALUE;
                #endif
                while(0 == GPIO_INPUT_GET)
                {
                    #ifdef ENABLE_TIMEOUTS
                    if (--(timeout) <= 0)
                    {
                        errorCode = DHT11_TIMEOUT;
                        break;
                    }
                    #endif
                }; /* 50 us on 0 */
 
                if (1 == GPIO_INPUT_GET)
                {
                    delay_us(26);//30
                }
 
                pData[j] <<= 1;
                 
                if(1 == GPIO_INPUT_GET)
                {
                    delay_us(40); /* wait 'till 70us */
                    pData[j] |= 1;
                }
                else
                {
                    pData[j] &= 0xfe;
                }
            }
        }
    }
    /* read sequence - end */
     
    
    CRITICAL_SECTION_LEAVE;
 
    /* checksum check */
    if (DHT11_OK == errorCode)
    {
        if ((pData[0] +pData[1] +pData[3] + pData[2]) != pData[4])
        {
            errorCode = DHT11_WRONG_CHCKSUM;
        }
        else
        {
            errorCode = DHT11_OK;
        }
    }
		//errorCode = DHT11_OK;
    return errorCode;
}