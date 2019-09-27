#include "main.h"

extern u8 TCP_Flag;

extern char GSMBuffer[];
extern u16 GSMBufferPos;

extern char	CMDBuffer[];
extern u16 uiBufferPos;
extern u8 NewGSMData;
char RESBuffer[MAX_CMD_BUFFER];

char Phone_Tx[15] = {0};
char Sms_Tx[160] = {0};

char IP_Tx[15] = {0};
char Port_Tx[15] = {0};
char Tcp_Tx[160] = {0};

static void DebugPuts(const char* s);

/**	
 * @brief  :  Process data recv from UART1
 * @param  :  None
 * @retval :	None
 * @author :	anhnqt
 * @created:	18/04/2016
 */
void ProcessCMD(void)
{
	static char tem1[MAX_CMD_BUFFER],
							tem2[MAX_CMD_BUFFER];
	static u16 timeout_ = 500;
	
	memset(tem1, 0, MAX_CMD_BUFFER);
	memset(tem2, 0, MAX_CMD_BUFFER);
							
	/*  Neu nhan duoc chuoi OK -> da ket noi thanh cong OK*/
	if(Is_Con_Str(CMDBuffer,"SMS"))
	{
		Str_Cut(CMDBuffer, ',', tem1, tem2);
		Str_Cut(tem2, ',', Phone_Tx, Sms_Tx);
		
		printf("+SMS: \"%s\" to \"%s\"\r\n", Sms_Tx, Phone_Tx);
		
		if(Send_Sms(Phone_Tx, Sms_Tx, 1))
			printf("+SMS: Gui SMS thanh cong\r\n");
		else
			printf("+SMS: Gui SMS loi\r\n");
		
		memset(Phone_Tx, 0, sizeof Phone_Tx);
		memset(Sms_Tx, 0, sizeof Sms_Tx);
		goto ENDPROCESSCONFIG;
	}
	else if(Is_Con_Str(CMDBuffer,"TCP"))
	{
		Str_Cut(CMDBuffer, ',', tem1, tem2);
		memset(tem1, 0, MAX_CMD_BUFFER);
		Str_Cut(tem2, ',', IP_Tx, tem1);
		Str_Cut(tem1, ',', Port_Tx, Tcp_Tx);
		
		if(Is_Con_Str(CMDBuffer,"27.72.18.127") && Is_Con_Str(CMDBuffer,"100"))
		{
			if(!TCP_Flag)
			{
				if(Tcp_Close())
				{
					printf("Dong ket noi TCP\r\n");
				
					TCP_Flag = Tcp_Connect("27.72.18.127", "100");
					if(TCP_Flag)
					{
						printf("Ket noi TCP den %s:%s xong!\r\n", IP_Tx, Port_Tx);
					}
					else
						printf("+ERR: Ket noi TCP den %s:%s!\r\n", IP_Tx, Port_Tx);
				}
				else
					printf("+ERR: Loi TCP Connect\r\n");
			}
			else
			{
				if(Send_Tcp(Tcp_Tx) == TCP_SENDOK_)
				{
					printf("+TCP: Send TCP OK\r\n");
				}
				else
				{
					printf("+ERR: Loi Send TCP\r\n");
					TCP_Flag = 0;
				}
			}
		}
		memset(IP_Tx, 0, sizeof IP_Tx);
		memset(Port_Tx, 0, sizeof Port_Tx);
		memset(Tcp_Tx, 0, sizeof Tcp_Tx);
		
		goto ENDPROCESSCONFIG;
	}
	else if(Is_Con_Str(CMDBuffer,"AT"))
	{
		{
			UART2_SendString(CMDBuffer);
			UART2_SendString("\r\n");

			while(!NewGSMData && timeout_)
			{
				delay_ms(10);
				timeout_--;
			}
			
			if(timeout_ || NewGSMData)
			{
				printf("%s", GSMBuffer);
				
				memset(GSMBuffer, 0, MAX_CMD_BUFFER);
				GSMBufferPos = 0;
			}
			else
				printf("SIM900a do not have response!\r\n");
			
			goto ENDPROCESSCONFIG;
		}
	}

ENDPROCESSCONFIG:
	uiBufferPos = 0;
	memset(CMDBuffer, 0, MAX_CMD_BUFFER);
}

/**	
 * @brief  :  UART1 send char through printf function
 * @param  :  None
 * @retval :	return ch
 * @author :	anhnqt
 * @created:	18/04/2016
 */
PUTCHAR_PROTOTYPE
{
	DebugPut(ch);
		
	return ch;	
}

/**	
 * @brief  :  UART1 send char
 * @param  :  char d
 * @retval :	None
 * @author :	anhnqt
 * @created:	18/04/2016
 */
void DebugPut(char d)
{
	USART_SendData(USART1, (uint16_t) d);
	while(USART_GetFlagStatus(USART1, USART_FLAG_TC) == 0);
}

/**	
 * @brief  :  UART1 send string
 * @param  :  string s
 * @retval :	None
 * @author :	anhnqt
 * @created:	18/04/2016
 */
static void DebugPuts(const char* s)
{
	char c;

	while((c = *s++) != '\0')
	{
			DebugPut(c);
	}
}

/**	
 * @brief  :  UART1 send string
 * @param  :  string s
 * @retval :	None
 * @author :	anhnqt
 * @created:	18/04/2016
 */
void DebugPrint(const char* s)
{
	DebugPuts(s);
}

/** @End of file */
