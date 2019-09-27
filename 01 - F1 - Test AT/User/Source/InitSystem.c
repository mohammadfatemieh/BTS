#include "main.h"


/**
 * @brief  Configure a SysTick Base time to 1 ms.
 * @param  None
 * @retval None
 */
static void SysTickConfig(void)
{
	/* Setup SysTick Timer for 1 msec interrupts  */
	if(SysTick_Config(SystemCoreClock / 1000))
	{
			/* Capture error */
			while(1);
	}
}

/**	
 * @brief  :  System clock configuration
 * @param  :  None
 * @retval :	None
 * @author :	anhnqt
 * @created:	18/04/2016
 */
static void RCC_Configuration(void)
{
	SystemInit();
	SystemCoreClockUpdate();
}

/**	
 * @brief  :  UART1 Init for Debug and recv data from PC
 * @param  :  Baundrate
 * @retval :	None
 * @author :	anhnqt
 * @created:	18/04/2016
 */
static void UART1_Init(u32 Baudrate)
{
	GPIO_InitTypeDef  	GPIO_InitStructure;
	USART_InitTypeDef  	USART_InitStructure;
	NVIC_InitTypeDef  NVIC_InitStructure;
	
	USART_DeInit(USART1);
  USART_Cmd(USART1, DISABLE);
	
	/* Enable GPIOA clocks */
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA | RCC_APB2Periph_AFIO, ENABLE);
	/* Enable UART clock */
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_USART1, ENABLE);

	/* Configure PA9 for USART Tx as alternate function push-pull */
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_9;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF_PP;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_Init(GPIOA, &GPIO_InitStructure);

	/* Configure PA10 for USART Rx as input floating */
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_10;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_IN_FLOATING;
	GPIO_Init(GPIOA, &GPIO_InitStructure);
	
	/* USARTx configured as follow:
        - BaudRate = 115200 baud  
        - Word Length = 8 Bits
        - One Stop Bit
        - No parity
        - Hardware flow control disabled (RTS and CTS signals)
        - Receive and transmit enabled
	*/
	USART_InitStructure.USART_BaudRate = Baudrate;
	USART_InitStructure.USART_WordLength = USART_WordLength_8b;
	USART_InitStructure.USART_StopBits = USART_StopBits_1;
	USART_InitStructure.USART_Parity = USART_Parity_No;
	USART_InitStructure.USART_HardwareFlowControl = USART_HardwareFlowControl_None;
	USART_InitStructure.USART_Mode = USART_Mode_Rx | USART_Mode_Tx;	

	/* USART configuration */
	USART_Init(USART1, &USART_InitStructure);
	/* Ngat UART */
	USART_ITConfig(USART1,USART_IT_RXNE,ENABLE);
	/* Enable USART */
	USART_Cmd(USART1, ENABLE);
	/* Xoa co TX */
	USART_ClearFlag(USART1, USART_FLAG_TC);
	
	NVIC_InitStructure.NVIC_IRQChannel = USART1_IRQn;
  NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0x01;
  NVIC_InitStructure.NVIC_IRQChannelSubPriority = 0x01;
  NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
  NVIC_Init(&NVIC_InitStructure);
}

/**	
 * @brief  :  Draw screen when programming start
 * @param  :  None
 * @retval :	None
 * @author :	anhnqt
 * @created:	18/04/2016
 */
static void DrawScreen(void)
{
	DebugPrint("\r\n\r\n\r\n\r\n");
	DebugPrint("********************************************************************************\r\n");
	DebugPrint("Copyright by Anhnqt, anhnqt.fet@gmail.com\r\n");
	DebugPrint("MCU Online - STM32F103C8T6\r\n");
	DebugPrint("********************************************************************************\r\n");
}
/**
 * @brief  	Init all module and set some configs
 * @param  	None
 * @retval 	None
 */
void InitSystem(void)
{
	/* Init system clock */
	RCC_Configuration();
	/* System Clock */
	SysTickConfig();
	
	UART1_Init(115200);
	
	DrawScreen();
	
	delay_ms(500);
	
	UART2_Init(9600);
}

/** @End of file */
