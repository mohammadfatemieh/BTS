#include "main.h"


#define CMDTimeOut 70
#define GSMTimeOut 70


char 	CMDBuffer[MAX_CMD_BUFFER]={0};
char 	GSMBuffer[MAX_CMD_BUFFER]={0};
u8 	CMDRevTimeOut = 0;
u8 	GSMRevTimeOut = 0;
u8 	NewCMDData = 0;
u8 	NewGSMData = 0;
u16 uiBufferPos = 0;
u16 GSMBufferPos = 0;


/******************************************************************************
													SysTick Interrupt Handler
*******************************************************************************/
u32 msTicks = 0;	/* Variable to store millisecond ticks */

void delay_ms(u32 delay_num)
{
	msTicks = delay_num;
	while(msTicks != 0);
}

void SysTick_Handler(void)
{
  if(msTicks) msTicks--;
	
	/* Xu ly timeout UART1 */
	if(CMDRevTimeOut > 0)
	{
		CMDRevTimeOut--;

		if(CMDRevTimeOut == 0)
			NewCMDData = 1;
	}
	
	/* Xu ly timeout UART2 - GSM */
	if(GSMRevTimeOut > 0)
	{
		GSMRevTimeOut--;

		if(GSMRevTimeOut == 0)
			NewGSMData = 1;
	}
}

/******************************************************************************
													USART1 Interrupt Handler
*******************************************************************************/

void USART1_IRQHandler(void)
{
	volatile unsigned int IIR;

	if(USART_GetITStatus(USART1, USART_IT_RXNE) != RESET)
	{
		IIR = USART1->SR;
		
		CMDBuffer[uiBufferPos++] = (u8)USART_ReceiveData(USART1);
		CMDBuffer[uiBufferPos] = 0;
		
		//DebugPut((char)USART_ReceiveData(USART1));
		//printf("Have new data\r\n");
		
		USART_ClearITPendingBit(USART1, USART_IT_RXNE);
		
		CMDRevTimeOut = CMDTimeOut;
	}
}

/******************************************************************************
													USART2 Interrupt Handler
*******************************************************************************/
void USART2_IRQHandler(void)
{
	 volatile unsigned int IIR;

	if(USART_GetITStatus(USART2, USART_IT_RXNE) != RESET)
	{
		IIR = USART2->SR;
		
		GSMBuffer[GSMBufferPos++] = (u8)USART_ReceiveData(USART2);
		GSMBuffer[GSMBufferPos] = 0;
		
		USART_ClearITPendingBit(USART2, USART_IT_RXNE);
		
		GSMRevTimeOut = GSMTimeOut;
	}
}

/** @End of file */
