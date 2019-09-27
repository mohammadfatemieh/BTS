// Define hardware for DC measure Unit
// Measure ADC0-ADC7
// Define hardware
unsigned char MyID =0x0A;//DCM's ID :10~20
unsigned char cpu_id=0;
unsigned char checksum=0x25;




#define RS485_TxD PORTD.2
#define IDC_Send DDRD.3=1;PORTD.3=0;
#define IDC_Standby DDRD.3=0;PORTD.3=1;
unsigned char time_out,usart_count, time_out_run,process_uart;
unsigned int usart_time_out;
#ifndef RXB8
#define RXB8 1
#endif

#ifndef TXB8
#define TXB8 0
#endif

#ifndef UPE
#define UPE 2
#endif

#ifndef DOR
#define DOR 3
#endif

#ifndef FE
#define FE 4
#endif

#ifndef UDRE
#define UDRE 5
#endif

#ifndef RXC
#define RXC 7
#endif

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)


// USART Receiver buffer
#define RX_BUFFER_SIZE0 50
char rx_buffer0[RX_BUFFER_SIZE0];

#if RX_BUFFER_SIZE0 <= 256
unsigned char rx_wr_index0=0;
#else
unsigned int rx_wr_index0=0;
#endif

#if RX_BUFFER_SIZE0 < 256
unsigned char rx_counter0=0;
#else
unsigned int rx_counter0=0;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow0;


unsigned int cpu_cmd;

//#define FIRST_ADC_INPUT 0
//#define LAST_ADC_INPUT 7
//unsigned int adc_data[LAST_ADC_INPUT-FIRST_ADC_INPUT+1];
//// Voltage Reference: AVCC pin
//#define ADC_VREF_TYPE ((0<<REFS1) | (1<<REFS0) | (0<<ADLAR))


//int flag_for_update=0,flag_for_volt=0;



//char usart_status;
unsigned char HexInCharToDec(char data)
      {
            if((data>47)&&(data<58)) return (data-48);// 0...9
            if((data>63)&&(data<71)) return (data-55);//A..F
      }