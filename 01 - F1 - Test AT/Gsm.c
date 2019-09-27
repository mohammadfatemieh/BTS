#include "main.h"

extern u8 	NewGSMData;
extern char GSMBuffer[];
extern u16 GSMBufferPos;

char str_cmgs[30]={0};
u8 gsm_ok = 0;

static void Buffer_Del(void)
{
	NewGSMData = 0;
	GSMBufferPos = 0;
	memset(GSMBuffer, 0, MAX_GSM_BUFFER);
}

/**********************************************************************************
Function: Tuong tu ham tren nhung kiem tra chuoi const
Input		: Chuoi nguon va chuoi hang dich
Output	: 1 neu okie, 0 neu dieu kien kiem tra sai 
**********************************************************************************/
u8 Is_Con_Str(char *source, char const *find)
{
	int i,j=0;
	u8 flag=0;
	
	for(i=0;source[i]!='\0' && find[j]!='\0';i++)
	{
		if(find[j]==source[i])
		{
			j++;
		}
		else
		{
			i-=j;
			j=0;
		}
		if(find[j]=='\0')
		{
			flag=1;
		}
		else
		{
			flag=0;
		}
	}
	return flag;
}

/**	
 * @brief  :  
 * @param  :  
 * @retval :	
 * @author :	anhnqt
 * @created:	18/04/2016
 */
void Str_Cut(char *source, char chr, char *str1, char *str2)
{
	static u16 i, j;

	for(i = 0; source[i] != '\0'; i++)
	{
		if(source[i] != chr)
		{
			str1[i] = source[i];
		}
		else
		{
			j = i + 1;
			break;
		}
	}

	for(i = j; source[i] != '\0'; i++)
	{
		str2[i - j] = source[i];
	}
}

/**	
 * @brief  :  Xu ly cac lenh nguoi dung cap tu UART1
 * @param  :  
 * @retval :	
 * @author :	anhnqt
 * @created:	18/04/2016
 */
void ProcessGSM(void)
{
	static char tem1[MAX_CMD_BUFFER] = {0}, 
							tem2[MAX_CMD_BUFFER] = {0};
							
	GSMBufferPos = 0;
	
	/*  Neu nhan duoc chuoi OK -> da ket noi thanh cong OK*/
	if(Is_Con_Str(GSMBuffer,"OK"))
	{
		gsm_ok = 1;
		
		goto ENDPROCESSCONFIG;
	}

ENDPROCESSCONFIG:
	Buffer_Del();
}

/**	
 * @brief  :  
 * @param  :  
 * @retval :	
 * @author :	anhnqt
 * @created:	18/04/2016
 */

u8 Send_Cmd(char *cmd, u8 ntime, char *resp)
{
	static u16 timeout_;
	
	while(ntime)
	{
		timeout_ = 2000;
		NewGSMData = 0;
		Buffer_Del();
		
		UART2_SendString(cmd);
		UART2_SendString("\r");
				
		while(!NewGSMData && timeout_)
		{
			delay_ms(1);
			timeout_--;
		}
		
		if(timeout_ || NewGSMData)
		{
			NewGSMData = 0;
			
			if(Is_Con_Str(GSMBuffer,resp))
				return 1;
		}
		
		ntime--;
	}
	
	printf("%s not response!\r\n", cmd);
	return 0;
}

/**	
 * @brief  :  SIM900a Config
 * @param  :  None
 * @retval :	Return 1 if Configure OK else 0;
 * @author :	anhnqt
 * @created:	18/04/2016
 */
u8 SIM900a_Config(void)
{
	static u8 ret = 0;
	
	ret = Send_Cmd("AT", 10, "OK");
	delay_ms(100);
	
	if(ret)
		ret = Send_Cmd("ATE0", 10, "OK");
	else
		return 0;
	delay_ms(100);
	
	if(ret)
		ret = Send_Cmd("AT+CIPSHUT", 10, "OK");
	else
		return 0;
	
	// AT+CRC=1
	if(ret)
		ret = Send_Cmd("AT+CRC=1", 2, "OK");
	else
		return 0;
	delay_ms(100);
	
	// CMGF
	if(ret)
		ret = Send_Cmd("AT+CMGF=1", 2, "OK");
	else	
		return 0;
	delay_ms(100);
	
	//
	if(ret)
		ret = Send_Cmd("AT+CSCS=\"GSM\"", 2, "OK");
	else
		return 0;
	delay_ms(100);
	
	// AT+CNMI=2,1
	if(ret)
		ret = Send_Cmd("AT+CNMI=2,1", 2, "OK");
	else
		return 0;
	delay_ms(100);
	
	// AT+CMGD=1,4
	if(ret)
		ret = Send_Cmd("AT+CMGD=1,4", 2, "OK");
	else
		return 0;
	delay_ms(100);
	
	// AT+CPMS=\"SM\",\"SM\",\"SM\"
	if(ret)
		ret = Send_Cmd("AT+CPMS=\"SM\",\"SM\",\"SM\"", 2, "OK");
	else
		return 0;
	delay_ms(100);
	
	return ret;
}

/**	
 * @brief  :  
 * @param  :  
 * @retval :	
 * @author :	anhnqt
 * @created:	18/04/2016
 */
u8 Send_Sms(char *phone, char *compose, u8 ntime)
{
	static u16 timeout_;
	
	memset(str_cmgs,0,sizeof(str_cmgs));
	sprintf(str_cmgs, "AT+CMGS=\"%s\"\r", phone);	
	Buffer_Del();
	
	while(ntime)
	{
		/* Gui chuoi lenh gui text toi module SIM*/
		UART2_SendString(str_cmgs);
		
		timeout_ = 1000;
		while(!NewGSMData && timeout_)
		{
			delay_ms(1);
			timeout_--;
		}
		if(timeout_ || NewGSMData)
		{
			if(NewGSMData)
			{
				//printf("GSMBuffer: %s\r\n", GSMBuffer);
				if(Is_Con_Str(GSMBuffer,">"))
				{
					Buffer_Del();
				}
				else
				{
					Buffer_Del();
					
					return 0;
				}
			}
		}
		
		/* Gui choi text toi so phone qua module SIM*/
		UART2_SendString(compose);
		UART2_SendData(0x1A);
		
		timeout_ = 6000;
		while(!NewGSMData && timeout_)
		{
			delay_ms(1);
			timeout_--;
		}
		if(timeout_ || NewGSMData)
		{
			if(NewGSMData)
			{
				//printf("GSMBuffer: %s\r\n", GSMBuffer);
				if(Is_Con_Str(GSMBuffer,"CMGS"))
				{
					Buffer_Del();
					
					return 1;
				}
			}
		}
		
		/* Giam so lan gui tin*/
		ntime--;
	}
	/* Tra ve gia tri 0 -> Bao gui SMS khong thanh cong*/
	Buffer_Del();
	
	return 0;
}

/**	
 * @brief  :  
 * @param  :  
 * @retval :	
 * @author :	anhnqt
 * @created:	18/04/2016
 */
u8 Tcp_Connect(char *IP, char *port)
{
	static u8 ret = 0;
	static char tem1[100] = {0};
	
	ret = Send_Cmd("AT", 2, "OK");
	delay_ms(100);
	
	if(ret)
		ret = Send_Cmd("ATE0", 10, "OK");
	else
		return 0;
	delay_ms(100);
	
	// CGCLASS
	if(ret)
		ret = Send_Cmd("AT+CGCLASS=\"B\"", 2, "OK");
	else
		return 0;
	delay_ms(100);
	
	// CGDCONT
	if(ret)
		ret = Send_Cmd("AT+CGDCONT=1,\"IP\",\"CMNET\"", 2, "OK");
	else
		return 0;
	delay_ms(100);
	
	// CGATT
	if(ret)
		ret = Send_Cmd("AT+CGATT=1", 2, "OK");
	else
		return 0;
	delay_ms(100);
	
	// CIPCSGP
	if(ret)
		ret = Send_Cmd("AT+CIPCSGP=1,\"CMNET\"", 2, "OK");
	else
		return 0;
	delay_ms(100);
	
	// CLPORT
	if(ret)
		ret = Send_Cmd("AT+CLPORT=\"TCP\",\"2000\"", 2, "OK");
	else
		return 0;
	delay_ms(100);
	
	// CIPSTART
	if(ret)
	{
		sprintf(tem1, "AT+CIPSTART=\"TCP\",\"%s\",\"%s\"", IP, port);
		ret = Send_Cmd(tem1, 2, "CONNECT");
	}
	else
		return 0;
	delay_ms(100);
	
	return ret;
}

u8 Send_Tcp(char *data)
{
	static u16 timeout_;
  
	Buffer_Del();
	
	UART2_SendString("AT+CIPSEND\r");
	
	timeout_ = 1000;
	while(!NewGSMData && timeout_)
	{
		delay_ms(1);
		timeout_--;
	}
	if(timeout_ || NewGSMData)
	{
		if(NewGSMData)
		{
			if(Is_Con_Str(GSMBuffer,">"))
			{ 
				NewGSMData = 0;
			}
			else if(Is_Con_Str(GSMBuffer,"ERROR"))
			{
				return 0;
			}
		}
		NewGSMData = 0;
	}
	
	UART2_SendString(data);
	delay_ms(1);
	UART2_SendData(0x1A);
	
	timeout_ = 3000;
	while(!NewGSMData && timeout_)
	{
		delay_ms(1);
		timeout_--;
	}
	if(timeout_ || NewGSMData)
	{
		if(NewGSMData)
		{
			//printf("GSMBuffer: %s\r\n", GSMBuffer);
			if(Is_Con_Str(GSMBuffer,"OK"))
			{ 
				NewGSMData = 0;
				return TCP_SENDOK_;
			}
		}
		NewGSMData = 0;
	}
	
	return 0;
}

u8 Tcp_Close(void)
{
	return Send_Cmd("AT+CIPSHUT", 2, "OK");;
}
