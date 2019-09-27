//==============================================================================
//    S E N S I R I O N   AG,  Laubisruetistr. 50, CH-8712 Staefa, Switzerland
//==============================================================================
// Project   :  SHTC1 Sample Code (V1.0)
// File      :  shtc1.c (V1.0)
// Author    :  RFU
// Date      :  26-Nov-2012
// Controller:  STM32F100RB
// IDE       :  �Vision V4.60.0.0
// Compiler  :  Armcc
// Brief     :  Sensor Layer: Implementation of functions for sensor access.
//==============================================================================

//-- Includes ------------------------------------------------------------------
#include "sht1x.h"
//#include "i2c_hal.h"

//==============================================================================
void SHTC1_Init(void){
//==============================================================================
  //I2c_Init(); // init I2C
}

//==============================================================================
etError SHTC1_GetTempAndHumi(float *temp, float *humi){
//==============================================================================
  etError error;        // error code
  uint16_t    rawValueTemp; // temperature raw value from sensor
  uint16_t    rawValueHumi; // humidity raw value from sensor

  error = SHTC1_StartWriteAccess();

  // measure, read temperature first, clock streching enabled
  error |= SHTC1_WriteCommand(MEAS_T_RH_CLOCKSTR);

  // if no error, read temperature and humidity raw values
  if(error == NO_ERROR)
  {
    error |= SHTC1_StartReadAccess();
    error |= SHTC1_Read2BytesAndCrc(&rawValueTemp);
    error |= SHTC1_Read2BytesAndCrc(&rawValueHumi);
  }

  SHTC1_StopAccess();

  // if no error, calculate temperature in �C and humidity in %RH
  if(error == NO_ERROR)
  {
    *temp = SHTC1_CalcTemperature(rawValueTemp);
    *humi = SHTC1_CalcHumidity(rawValueHumi);
  }

  return error;
}

//==============================================================================
etError SHTC1_GetTempAndHumiPolling(float *temp, float *humi){
//==============================================================================
  etError error;           // error code
  uint8_t     maxPolling = 20; // max. retries to read the measurement (polling)
  uint16_t    rawValueTemp;    // temperature raw value from sensor
  uint16_t    rawValueHumi;    // humidity raw value from sensor

  error  = SHTC1_StartWriteAccess();

  // measure, read temperature first, clock streching disabled (polling)
  error |= SHTC1_WriteCommand(MEAS_T_RH_POLLING);

  // if no error, ...
  if(error == NO_ERROR)
  {
    // poll every 1ms for measurement ready
    while(maxPolling--)
    {
      // check if the measurement has finished
      error = SHTC1_StartReadAccess();

      // if measurement has finished -> exit loop
      if(error == NO_ERROR) break;

      // delay 1ms
      DelayMicroSeconds(1000);
    }

    // if no error, read temperature and humidity raw values
    if(error == NO_ERROR)
    {
      error |= SHTC1_Read2BytesAndCrc(&rawValueTemp);
      error |= SHTC1_Read2BytesAndCrc(&rawValueHumi);
    }
  }

  SHTC1_StopAccess();

  // if no error, calculate temperature in �C and humidity in %RH
  if(error == NO_ERROR)
  {
    *temp = SHTC1_CalcTemperature(rawValueTemp);
    *humi = SHTC1_CalcHumidity(rawValueHumi);
  }

  return error;
}

//==============================================================================
etError SHTC1_GetId(uint16_t *id){
//==============================================================================
  etError error; // error code

  error = SHTC1_StartWriteAccess();

  // write ID read command
  error |= SHTC1_WriteCommand(READ_ID);

  // if no error, read ID
  if(error == NO_ERROR)
  {
    SHTC1_StartReadAccess();
    error = SHTC1_Read2BytesAndCrc(id);
  }

  SHTC1_StopAccess();

  return error;
}

//==============================================================================
etError SHTC1_SoftReset(void){
//==============================================================================
  etError error; // error code

  error = SHTC1_StartWriteAccess();

  // write reset command
  error |= SHTC1_WriteCommand(SOFT_RESET);

  SHTC1_StopAccess();

  return error;
}

//==============================================================================
etError SHTC1_StartWriteAccess(void){
//==============================================================================
  etError error; // error code

  // write a start condition
  I2c_StartCondition();

  // write the sensor I2C address with the write flag
  error = I2c_WriteByte(I2C_ADR_W);

  return error;
}

//==============================================================================
etError SHTC1_StartReadAccess(void){
//==============================================================================
  etError error; // error code

  // write a start condition
  I2c_StartCondition();

  // write the sensor I2C address with the read flag
  error = I2c_WriteByte(I2C_ADR_R);

  return error;
}

//==============================================================================
void SHTC1_StopAccess(void){
//==============================================================================
  // write a stop condition
  I2c_StopCondition();
}

//==============================================================================
etError SHTC1_WriteCommand(etCommands cmd){
//==============================================================================
  etError error; // error code

  // write the upper 8 bits of the command to the sensor
  error  = I2c_WriteByte(cmd >> 8);

  // write the lower 8 bits of the command to the sensor
  error |= I2c_WriteByte(cmd & 0xFF);

  return error;
}

//==============================================================================
etError SHTC1_Read2BytesAndCrc(uint16_t *data){
//==============================================================================
  etError error;    // error code
  uint8_t     bytes[2]; // read data array
  uint8_t     checksum; // checksum byte
 
  // read two data bytes and one checksum byte
  bytes[0] = I2c_ReadByte(ACK);
  bytes[1] = I2c_ReadByte(ACK);
  checksum = I2c_ReadByte(ACK);
  
  // verify checksum
  error = SHTC1_CheckCrc(bytes, 2, checksum);
  
  // combine the two bytes to a 16-bit value
  *data = (bytes[0] << 8) | bytes[1];
  
  return error;
}

//==============================================================================
etError SHTC1_CheckCrc(uint8_t data[], uint8_t nbrOfBytes, uint8_t checksum){
//==============================================================================
  uint8_t bit;        // bit mask
  uint8_t crc = 0xFF; // calculated checksum
  uint8_t byteCtr;    // byte counter
  
  // calculates 8-Bit checksum with given polynomial
  for(byteCtr = 0; byteCtr < nbrOfBytes; byteCtr++)
  {
    crc ^= (data[byteCtr]);
    for(bit = 8; bit > 0; --bit)
    {
      if(crc & 0x80) crc = (crc << 1) ^ POLYNOMIAL;
      else           crc = (crc << 1);
    }
  }
  
  // verify checksum
  if(crc != checksum) return CHECKSUM_ERROR;
  else                return NO_ERROR;
}

//==============================================================================
float SHTC1_CalcTemperature(uint16_t rawValue){
//==============================================================================
  // calculate temperature [�C]
  // T = -45 + 175 * rawValue / 2^16
  return 175 * (float)rawValue / 65536 - 45;
}

//==============================================================================
float SHTC1_CalcHumidity(uint16_t rawValue){
//==============================================================================
  // calculate relative humidity [%RH]
  // RH = rawValue / 2^16 * 100
  return 100 * (float)rawValue / 65536;
}
