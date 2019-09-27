#include "main.h"

/******************************************************************************
													USART1 Configure
*******************************************************************************/
/******************************************************************************
															USART2 Configure
*******************************************************************************/
/**	
 * @brief  :  UART2 init, interface with Module SIM900a
 * @param  :  Baundrate
 * @retval :	None
 * @author :	anhnqt
 * @created:	18/04/2016
 */
void UART2_Init(u32 Baudrate)
{
	GPIO_InitTypeDef  	GPIO_InitStructure;
	USART_InitTypeDef  	USART_InitStructure;
	NVIC_InitTypeDef  NVIC_InitStructure;
	 
	/* Configure the system clocks */
	/* Enable GPIOA clocks */
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA | RCC_APB2Periph_AFIO, ENABLE);
	/* Enable UART clock, if using USART2 or USART3 ... we must use RCC_APB1PeriphClockCmd(RCC_APB1Periph_USARTx, ENABLE) */
	RCC_APB1PeriphClockCmd(RCC_APB1Periph_USART2, ENABLE); 

	/* Configure PA9 for USART Tx as alternate function push-pull */
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_2;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF_PP;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_Init(GPIOA, &GPIO_InitStructure);

	/* Configure PA10 for USART Rx as input floating */
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_3;
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
	USART_Init(USART2, &USART_InitStructure);

	/* Enable USART */
	USART_Cmd(USART2, ENABLE);
	USART_ClearFlag(USART2, USART_FLAG_TC);
	
	NVIC_InitStructure.NVIC_IRQChannel = USART2_IRQn;
  NVIC_InitStructure.NVIC_IRQChannelPreemptionPriority = 0x01;
  NVIC_InitStructure.NVIC_IRQChannelSubPriority = 0x02;
  NVIC_InitStructure.NVIC_IRQChannelCmd = ENABLE;
  NVIC_Init(&NVIC_InitStructure);
	
	USART_ITConfig(USART2,USART_IT_RXNE,ENABLE);
}

/**	
 * @brief  :  UART2 send char
 * @param  :  ch
 * @retval :	None
 * @author :	anhnqt
 * @created:	18/04/2016
 */
void UART2_SendData(char ch)
{
	USART_SendData(USART2, (uint8_t) ch);

	/* Loop until the end of transmission */
	while (USART_GetFlagStatus(USART2, USART_FLAG_TC) == RESET)
	{}
}

/**	
 * @brief  :  UART2 send string
 * @param  :  None
 * @retval :	None
 * @author :	anhnqt
 * @created:	18/04/2016
 */
void UART2_SendString(char *str)
{
	u8 i = 0;
	while(str[i])
	{
		UART2_SendData(str[i]);
		i++;
	}
}

/** @End of file */
