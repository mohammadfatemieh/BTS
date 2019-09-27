#include "stm32f10x.h"
#include <stdio.h>



#ifdef __GNUC__
  /* With GCC/RAISONANCE, small printf (option LD Linker->Libraries->Small printf
     set to 'Yes') calls __io_putchar() */
  #define PUTCHAR_PROTOTYPE int __io_putchar(int ch)
#else
  #define PUTCHAR_PROTOTYPE int fputc(int ch, FILE *f)
#endif

/**
  * @brief  Retargets the C library printf function to the USART.
  * @param  None
  * @retval None
  */
 PUTCHAR_PROTOTYPE
{
	/* Loop until the end of transmission */
	while (USART_GetFlagStatus(USART2, USART_FLAG_TC) == RESET){}
	/* Place your implementation of fputc here */
	/* e.g. write a character to the USART */
	USART_SendData(USART2, (uint8_t) ch);
	return ch;
}
//Delay(1) == 10ms
void Delay(__IO uint32_t num)
{
	__IO uint32_t index = 0;

	/* default system clock is 72MHz ~~~ for(index = (64000 * num); index != 0; index--)*/
	for(index = (60000 * num); index != 0; index--)
	{
	}
}

void delay_ms(__IO uint32_t num)
{
	__IO uint32_t index = 0;
	
	/* Default system clock is 72MHz */
	for(index = (6000 * num); index != 0; index--);
}

void delay_us(__IO uint32_t num)
{
	__IO uint32_t index = 0;
	
	/* Default system clock is 72MHz */
	for(index = (6 * num); index != 0; index--);
}



void Update_Time(void);
void USART1_Init(void);
void USART2_Init(void);
void USART1_SendChar_(char ch);
void USART2_SendChar_(char ch);
void USART1_SendStr_(char *str) {
	while (*str) USART1_SendChar_(*str++);
}

void USER_UART_NVIC(void);
void GLCD_Hum_Temp_Update (void);
void SHT1x_Display(void);


 
/* GPIO configuration defines for 1-wire data input/output pin DHT11 */
#define GPIO_SET_AS_OUTPUT GPIO_SetState(GPIOC,GPIO_Pin_2,GPIO_Mode_Out_PP);   // Cau hinh chan Data la OUPUT
#define GPIO_SET_AS_INPUT  GPIO_SetState(GPIOC,GPIO_Pin_2,GPIO_Mode_IN_FLOATING);
#define GPIO_OUPUT_CLEAR   GPIO_PinWrite(GPIOC, 2, 0)
#define GPIO_OUTPUT_SET		 GPIO_PinWrite(GPIOC, 2, 1)
#define GPIO_INPUT_GET		 GPIO_PinRead(GPIOC,2)

 
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


#define DHT_ER       0
#define DHT_OK       1

/*******************************************************************************
Noi Dung    :   Doc gia tri nhiet do, do am tu DHT.
Tham Bien   :   *tem:    con tro luu tru gia tri nhiet do.
                *humi:   con tro luu tru gia tri do am.   
Tra Ve      :   - DHT_OK:   Neu do nhiet do,do am thanh cong.
                - DHT_ER:   Neu do nhiet do, do am xay ra loi.
 *******************************************************************************/

uint8_t DHT_GetTemHumi (uint8_t *tem,uint8_t *humi);


void USER_ADC_Init(void);

void DMA1_Channel1_IRQHandler(void);
void DMAInit(void);
void ADC_GetValue(void);

void Turn_RL(uint8_t stt);
void GET_BT(void);
void GET_RL(void);
void Clear_IO_CmD(void);
	
