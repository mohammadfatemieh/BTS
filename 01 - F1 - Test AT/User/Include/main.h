#include "stm32f10x.h"
#include "string.h"
#include "stdio.h"


/** @LED */
#define GPIO_Pin_Led	GPIO_Pin_11
#define GPIO_Led			GPIOB
#define RCC_APB2Periph_GPIO_Led		RCC_APB2Periph_GPIOB

#define LED_ON 			GPIO_WriteBit(GPIO_Led, GPIO_Pin_Led, Bit_RESET)
#define LED_OFF 		GPIO_WriteBit(GPIO_Led, GPIO_Pin_Led, Bit_SET)
#define LED_TOGGLE 	GPIO_WriteBit(GPIO_Led, GPIO_Pin_Led, (BitAction)(1 - GPIO_ReadOutputDataBit(GPIO_Led, GPIO_Pin_Led)));


#define SERIAL_EXAMPLE

#define	MAX_CMD_BUFFER	512
#define	MAX_GSM_BUFFER	512

#define SET_	1
#define RESET_	0
#define TCP_SENDOK_	1
#define TCP_SENDERROR_	2

#ifdef __GNUC__
  /* With GCC/RAISONANCE, small printf (option LD Linker->Libraries->Small printf
     set to 'Yes') calls __io_putchar() */
  #define PUTCHAR_PROTOTYPE int __io_putchar(int ch)
#else
  #define PUTCHAR_PROTOTYPE int fputc(int ch, FILE *f)
#endif /* __GNUC__ */

	
void delay_ms(u32 delay_num);
void InitSystem(void);

/* USART2 */
void UART2_Init(u32 Baudrate);
void UART2_SendData(char ch);
void UART2_SendString(char *str);


/******************************************************************************
															Configuration
*******************************************************************************/
/* Debug */
void DebugPut(char d);
void DebugPrint(const char* s);
void ProcessCMD(void);

/******************************************************************************
																	GSM
*******************************************************************************/
u8 Is_Con_Str(char *source, char const *find);
void Str_Cut(char *source, char chr, char *str1, char *str2);
void ProcessGSM(void);
u8 SIM900a_Config(void);
u8 Send_Sms(char *phone, char *compose, u8 ntime);
u8 Tcp_Connect(char *IP, char *port);
u8 Tcp_Close(void);
u8 Send_Tcp(char *data);
u8 Tcp_Close2(void);
u8 Send_Cmd(char *cmd, u8 ntime, char *resp);
/** @End of file */
