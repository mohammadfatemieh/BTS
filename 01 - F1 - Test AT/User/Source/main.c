#include "main.h"
//#include "stm32f10x_gpio.h"
#include "GPIO_STM32F10x.h"
extern u8 NewCMDData;
extern u8	NewGSMData;

u8 TCP_Flag = 0;
#define RS485(state) GPIO_PinWrite(GPIOA, 11, state)
/**	
 * @brief  :  LED init
 * @param  :  None
 * @retval :	None
 * @author :	anhnqt
 * @created:	18/04/2016
 */
void Led_Init()
{
	GPIO_InitTypeDef  	GPIO_InitStructure;
	
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIO_Led, ENABLE);
	
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_Led;
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_Out_PP;
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	GPIO_Init(GPIO_Led, &GPIO_InitStructure);
	
	LED_ON;
}

char SV_IP[20] = "27.72.18.127";
char SV_PORT[20] = "100";

/**	
 * @brief  :  Main program
 * @param  :  None
 * @retval :	None
 * @author :	anhnqt
 * @created:	18/04/2016
 */
int main()
{
	InitSystem();
	Led_Init();
	GPIO_PinConfigure(GPIOA, 11,
										GPIO_OUT_PUSH_PULL,
										GPIO_MODE_OUT50MHZ);
	RS485(1);
	printf("Khoi dong he thong xong!\r\n");
	RS485(0);
	if(SIM900a_Config())
	{
		RS485(1);printf("Khoi dong SIM900a xong!\r\n");RS485(0);
		
		if(Tcp_Close())
		{
			RS485(1);printf("Dong ket noi TCP\r\n");RS485(0);
		
			TCP_Flag = Tcp_Connect("27.72.18.127", "100");RS485(0);
			if(TCP_Flag)
			{
				RS485(1);printf("Ket noi TCP den %s:%s xong!\r\n", SV_IP, SV_PORT);RS485(0);
			}
			else
				RS485(1);printf("+ERR: Ket noi TCP den %s:%s!\r\n", SV_IP, SV_PORT);RS485(0);			
		}
	}
	else 
		RS485(1);printf("Loi khoi dong SIM900a!\r\n");RS485(0);
	
	while(1)
	{
		/* Co tin hieu lenh moi tu UART1 */
		if(NewCMDData)
		{
			ProcessCMD();
			NewCMDData = 0;
		}
	}
}

/** @End of file */
