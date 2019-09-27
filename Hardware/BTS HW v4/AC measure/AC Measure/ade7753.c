#include <mega88a.h>
// Standard Input/Output functions
#include <stdio.h>
#include <delay.h>

#include "ade7753.h"

// SPI functions
#include <spi.h>
#define CS_ADE PORTB.1=0
#define NCS_ADE PORTB.1=1

void setup(void)
{
    // Settings for Olimex Energy Shield #1 - Etel
    // ------------------------------------
    //ADE7753_analogSetup(GAIN_1, GAIN_1, 0, 0, FULLSCALESELECT_0_25V, INTEGRATOR_OFF);  // GAIN1, GAIN2, CH1OS, CH2OS, Range_ch1, integrator_ch1
    //ADE7753_rmsSetup( -0, +0 );                 // IRMSOS,VRMSOS  12-bit (S) [-2048 +2048] -- Refer to spec page 25, 26
    //ADE7753_energySetup(0, 0, 0, 0, 0, 0x0D); // WGAIN,WDIV,APOS,VAGAIN,VADIV,PHCAL  -- Refer to spec page 39, 31, 46, 44, 52, 53
    //ADE7753_frequencySetup(0, 0);             // CFNUM,CFDEN  12-bit (U) -- for CF pulse output  -- Refer to spec page 31
    //ADE7753_miscSetup(0, 0, 0, 0, 0, 0);
}

/// ADE Driver

/** === enableChip ===
* Enable chip, setting low ChipSelect pin (CS)
* @param none
*
*/
void ADE7753_enableChip(void){
    CS_ADE;
}

/** === disableChip ===
* Disable chip, setting high ChipSelect pin (CS)
* @param none
*
*/
void ADE7753_disableChip(void){
    NCS_ADE;
}

/** === read8 ===
* Read 8 bits from the device at specified register
* @param char containing register direction
* @return char with contents of register
*
*/
unsigned char ADE7753_read8(char reg){

    unsigned char b0;
    ADE7753_enableChip();
    spi(reg);
    b0=spi(0x00);
    ADE7753_disableChip();
    //    return (unsigned long)SPI.transfer(0x00);
    return b0;
}

/** === read16 ===
* Read 16 bits from the device at specified register
* @param char containing register direction
* @return int with contents of register
*
*/
unsigned int ADE7753_read16(char reg){

    unsigned char b1,b0;
    ADE7753_enableChip();
    spi(reg);

    b1=spi(0x00);

    b0=spi(0x00);

    ADE7753_disableChip();
    return (unsigned int)b1<<8 | (unsigned int)b0;
}

/** === read24 ===
* Read 24 bits from the device at specified register
* @param: char containing register direction
* @return: char with contents of register
*
*/
unsigned long ADE7753_read24(char reg){

    unsigned char b2,b1,b0;
     ADE7753_enableChip();
    spi(reg);

    b2=spi(0x00);

    b1=spi(0x00);

    b0=spi(0x00);

    ADE7753_disableChip();
    return (unsigned long)b2<<16 | (unsigned long)b1<<8 | (unsigned long)b0;
}

/** === write8 ===
* Write 8 bits to the device at specified register
* @param reg char containing register direction
* @param data char, 8 bits of data to send
*
*/
void ADE7753_write8(char reg, unsigned char data){

    unsigned char data0 = 0;
    ADE7753_enableChip();
    // 8th bit (DB7) of the register address controls the Read/Write mode (Refer to spec page 55 table 13)
    // For Write -> DB7 = 1  / For Read -> DB7 = 0
    reg |= WRITE;
    data0 = (unsigned char)data;


    spi((unsigned char)reg);          //register selection

    spi((unsigned char)data0);

    ADE7753_disableChip();
}


/** === write16 ===
* Write 16 bits to the device at specified register
* @param reg: char containing register direction
* @param data: int, 16 bits of data to send
*
*/
void ADE7753_write16(char reg, unsigned int data){

    unsigned char data0=0,data1=0;
    ADE7753_enableChip();
    // 8th bit (DB7) of the register address controls the Read/Write mode (Refer to spec page 55 table 13)
    // For Write -> DB7 = 1  / For Read -> DB7 = 0
    reg |= WRITE;
    //split data
    data0 = (unsigned char)data;
    data1 = (unsigned char)(data>>8);

    //register selection, we have to send a 1 on the 8th bit to perform a write

    spi((unsigned char)reg);

    //data send, MSB first
    spi((unsigned char)data1);

    spi((unsigned char)data0);

    ADE7753_disableChip();
}


/*****************************
*
*     public functions
*
*****************************/


/**
* In general:
* @params:  void
* @return: register content (measure) of the proper type depending on register width
*/

/** === setMode / getMode ===
* This is a 16-bit register through which most of the ADE7753 functionality is accessed.
* Signal sample rates, filter enabling, and calibration modes are selected by writing to this register.
* The contents can be read at any time.
*
*
* The next table describes the functionality of each bit in the register:
*
* Bit     Location    Bit Mnemonic    Default Value Description
* 0       DISHPF       0            HPF (high-pass filter) in Channel 1 is disabled when this bit is set.
* 1       DISLPF2      0            LPF (low-pass filter) after the multiplier (LPF2) is disabled when this bit is set.
* 2       DISCF        1            Frequency output CF is disabled when this bit is set.
* 3       DISSAG       1            Line voltage sag detection is disabled when this bit is set.
* 4       ASUSPEND     0            By setting this bit to Logic 1, both ADE7753 A/D converters can be turned off. In normal operation, this bit should be left at Logic 0. All digital functionality can be stopped by suspending the clock signal at CLKIN pin.
* 5       TEMPSEL      0            Temperature conversion starts when this bit is set to 1. This bit is automatically reset to 0 when the temperature conversion is finished.
* 6       SWRST        0            Software Chip Reset. A data transfer should not take place to the ADE7753 for at least 18 us after a software reset.
* 7       CYCMODE      0            Setting this bit to Logic 1 places the chip into line cycle energy accumulation mode.
* 8       DISCH1       0            ADC 1 (Channel 1) inputs are internally shorted together.
* 9       DISCH2       0            ADC 2 (Channel 2) inputs are internally shorted together.
* 10       SWAP         0            By setting this bit to Logic 1 the analog inputs V2P and V2N are connected to ADC 1 and the analog inputs V1P and V1N are connected to ADC 2.
* 12, 11  DTRT1,0      0            These bits are used to select the waveform register update rate.
*                         DTRT 1    DTRT0    Update Rate
*                             0    0    27.9 kSPS (CLKIN/128)
*                             0    1    14 kSPS (CLKIN/256)
*                             1    0    7 kSPS (CLKIN/512)
*                             1    1    3.5 kSPS (CLKIN/1024)
* 14, 13  WAVSEL1,0    0            These bits are used to select the source of the sampled data for the waveform register.
*                               WAVSEL1, 0    Length    Source
*                               0            0    24 bits active power signal (output of LPF2)
*                               0            1    Reserved
*                               1            0    24 bits Channel 1
*                               1            1    24 bits Channel 2
* 15    POAM            0            Writing Logic 1 to this bit allows only positive active power to be accumulated in the ADE7753.
*
*
* @param none
* @return int with the data (16 bits unsigned).
*/
void ADE7753_setMode(int m){
    ADE7753_write16(MODE, m);
}
int ADE7753_getMode(){
    return ADE7753_read16(MODE);
}

/* The IRQ Interrupt Request pin of the ADE7753 on the Olimex Energy Shield is not wired
to the Arduino board, so need to poll to service the interrupts.
See board spec and wiring diagram at:
http://www.olimex.cl/product_info.php?products_id=797&product__name=Arduino_Energy_Shield
http://www.olimex.cl/pdf/Main_Sch.pdf
*/

/** === getInterrupts / setInterrupts
* ADE7753 interrupts can be deactivated at any time by setting the corresponding
* bit in this 16-bit enable register to Logic 0. The status register continues
* to register an interrupt event even if disabled. However, the IRQ output is not activated.

* The next table summarizes the function of each bit in this register:
*
* BitLocation / Interrupt Flag / Description
* 0    AEHF        Indicates that an interrupt occurred because the active energy register, AENERGY, is more than half full.
* 1    SAG            Indicates that an interrupt was caused by a SAG on the line voltage.
* 2    CYCEND        Indicates the end of energy accumulation over an integer number of half line cycles as defined by the content of the LINECYC registerâ€”see the Line Cycle Energy Accumulation Mode section.
* 3    WSMP        Indicates that new data is present in the waveform register.
* 4    ZX            This status bit is set to Logic 0 on the rising and falling edge of the the voltage waveform. See the Zero-Crossing Detection section.
* 5    TEMP        Indicates that a temperature conversion result is available in the temperature register.
* 6    RESET        Indicates the end of a reset (for both software or hardware reset). The corresponding enable bit has no function in the interrupt enable register, i.e., this status bit is set at the end of a reset, but it cannot be enabled to cause an interrupt.
* 7    AEOF        Indicates that the active energy register has overflowed.
* 8    PKV            Indicates that waveform sample from Channel 2 has exceeded the VPKLVL value.
* 9    PKI            Indicates that waveform sample from Channel 1 has exceeded the IPKLVL value.
* 10    VAEHF        Indicates that an interrupt occurred because the active energy register, VAENERGY, is more than half full.
* 11    VAEOF        Indicates that the apparent energy register has overflowed.
* 12    ZXTO        Indicates that an interrupt was caused by a missing zero crossing on the line voltage for the specified number of line cyclesâ€”see the Zero-Crossing Timeout section.
* 13    PPOS        Indicates that the power has gone from negative to positive.
* 14    PNEG        Indicates that the power has gone from positive to negative.
* 15    RESERVED    Reserved.
*
//Register address
    IRQEN     0x0A  // interrupts enable register
    STATUS    0x0B  // interrupts status register
    RSTSTATUS 0x0C  // interrupts status register but read will reset all interrupt flags

* @param none
* @return int with the data (16 bits unsigned).
*/
int ADE7753_getEnabledInterrupts(void){
    return ADE7753_read16(IRQEN);
}

/** === getStatus ===
* This is an 16-bit read-only register. The status register contains information regarding the source of ADE7753 interrupts
* @param none
* @return int with the data (16 bits unsigned).
*/
int ADE7753_getInterruptStatus(void){
    return ADE7753_read16(STATUS);
}

/** === resetStatus ==
* Same as the interrupt status register except that the register contents are reset to 0 (all flags cleared) after a read operation.
* @param none
* @return int with the data (16 bits unsigned).
*/
int ADE7753_getresetInterruptStatus(void){
    return ADE7753_read16(RSTSTATUS);
}
/** (1) === getActiveEnergyLineSync ===
* The instantaneous active power is accumulated in this read-only register over
* the LINECYC number of half line cycles.
* Used in combination with CYCEND Interrupt Flag and with LINECYC register (nbr of half-cycles)
* >>> This is the prefered method The advantage of summing the active energy over an integer number
*     of line cycles is that the sinusoidal component in the active energy is reduced to 0.
*     This eliminates any ripple in the energy calculation. Energy is calculated more
*     accurately and in a shorter time because the integration period can be shortened.
* @param none
* @return long with the data (24 bits 2-complement signed).
*/
long ADE7753_getActiveEnergyLineSync(void){
    return ADE7753_read24(LAENERGY);
}

/** (2) === getApparentEnergyLineSync ===
* The instantaneous real power is accumulated in this read-only register over
* the LINECYC number of half line cycles.
* >>> This is the prefered method The advantage of summing the active energy over an integer number
*     of line cycles is that the sinusoidal component in the active energy is reduced to 0.
*     This eliminates any ripple in the energy calculation. Energy is calculated more
*     accurately and in a shorter time because the integration period can be shortened.
* @param none
* @return long with the data (24 bits unsigned).
*/
long ADE7753_getApparentEnergyLineSync(void){
    return ADE7753_read24(LVAENERGY);
}

/** (3) === getReactiveEnergyLineSync ===
* The instantaneous reactive power is accumulated in this read-only register over
* the LINECYC number of half line cycles.
* >>> This is the prefered method The advantage of summing the active energy over an integer number
*     of line cycles is that the sinusoidal component in the active energy is reduced to 0.
*     This eliminates any ripple in the energy calculation. Energy is calculated more
*     accurately and in a shorter time because the integration period can be shortened.
* @param none
* @return long with the data (24 bits 2-complement signed).
*/
long ADE7753_getReactiveEnergyLineSync(void){
    return ADE7753_read24(LVARENERGY);
}

/** === getIRMS ===
* Channel 2 RMS Value (Current Channel).
* The update rate of the Channel 2 rms measurement is CLKIN/4.
* To minimize noise, synchronize the reading of the rms register with the zero crossing
* of the voltage input and take the average of a number of readings.
* @param none
* @return long with the data (24 bits unsigned).
*/
long ADE7753_getIRMS(void){
    long vv;
    //char zero;
    ADE7753_getresetInterruptStatus(); // Clear all interrupts
//    zero=PIND.3;
//    while(PIND.3 == zero);
    vv=0;
    while( !  ( ADE7753_getInterruptStatus() & ZX )  )   // wait Zero-Crossing
    { // wait for the selected interrupt to occur
        if ( vv > 200)
        {
            //printf("no AC");
            break;
        }
        vv++;
    }
    return ADE7753_read24(IRMS);
}

/** === getVRMS ===
* Channel 1 RMS Value (Voltage Channel).
* The update rate of the Channel 1 rms measurement is CLKIN/4.
* To minimize noise, synchronize the reading of the rms register with the zero crossing
* of the voltage input and take the average of a number of readings.
* @param none
* @return long with the data (24 bits unsigned).
*/
long int ADE7753_getVRMS(void){

    int ww=0;
    //char zero;
    ADE7753_getresetInterruptStatus(); // Clear all interrupts
    while( !  ( ADE7753_getInterruptStatus() & ZX )  )   // wait Zero-Crossing
    { // wait for the selected interrupt to occur
        if ( ww > 200)
        {
            //printf("No AC");
            break;
        }
        ww++;
    }
    //PORTC.5=1;
    //printf("ww:%d",ww);
    return ADE7753_read24(VRMS);
}

/** === vrms ===
* Returns the mean of last 100 readings of RMS voltage. Also supress first reading to avoid
* corrupted data.
* rms measurement update rate is CLKIN/4.
* To minimize noise, synchronize the reading of the rms register with the zero crossing
* of the voltage input and take the average of a number of readings.
* @param none
* @return long with RMS voltage value
*/
long int ADE7753_vrms(){
    char i=0;
    long int v=0;
    ADE7753_getVRMS();//Ignore first reading to avoid garbage
    for(i=0;i<10;++i){
        v+=ADE7753_getVRMS();
    }
    return (long int)(v/10);
}

/** === irms ===
* Returns the mean of last 100 readings of RMS current. Also supress first reading to avoid
* corrupted data.
* rms measurement update rate is CLKIN/4.
* To minimize noise, synchronize the reading of the rms register with the zero crossing
* of the voltage input and take the average of a number of readings.
* @param none
* @return long with RMS current value in hundreds of [mA], ie. 6709=67[mA]
*/
long ADE7753_irms(){
    char n=0;
    long i=0;
    ADE7753_getIRMS();//Ignore first reading to avoid garbage
    for(n=0;n<10;++n){
        i+=ADE7753_getIRMS();
    }
    return i/10;
}

/** === getWaveform ===
* This read-only register contains the sampled waveform data from either Channel 1,
* Channel 2, or the active power signal. The data source and the length of the waveform
* registers are selected by data Bits 14 and 13 in the mode register.
* - Max sampling CLKIN/128 = 3.579545 MHz / 128 = 27.9 kSPS
* - Bandwidth 14 kHz
* - one of four output sample rates can be chosen by using Bits 11 and 12
*   of the mode register (WAVSEL1,0). The output sample rate
*   can be 27.9 kSPS, 14 kSPS, 7 kSPS, or 3.5 kSPS
* - arrivals of new waveform samples after each read is indicated by interrupt
*   request IRQ, but unfortunatly IRQ is not wired in the Olimex Energy Shield
* - The interrupt request output, IRQ, signals a new sample
*   availability by going active low.
* - In waveform sampling mode, the WSMP bit (Bit 3) in the
*   interrupt enable register must also be set to Logic 1.
* - The interrupt request output IRQ stays low until the interrupt
*   routine reads the reset status register.
* - Interrupt Flag WSMP (bit location 3) in the Interrupt Status Register
*   indicates that new data is present in the waveform register.
*   Therefore arrival of new waveform samples may be indicated by polling
*   this flag and then reading the 24-bit waveform register
*   --- we use this polling method for Arduino/Nanode ---
* - When acquiring waveform data, disable low pass filter in order to
*   obtain and view all the high harmoniques
* @param none
* @return long with the data (24 bits 2-complement signed).
*/
long ADE7753_getWaveform(void){  // this function will have to be rewritten for allowing rapid polling
    // of WSMP flag in ISR and getting rapid Waveform data over 1 full cycle
    // and storing to Arduino tiny RAM
    return ADE7753_read24(WAVEFORM);
}

/** === getIpeakReset ===
* Same as Channel 1 Peak Register except that the register contents are reset to 0 after read.
* @param none
* @return long with the data (24 bits 24 bits unsigned).
*/
long ADE7753_getIpeakReset(void){
    return ADE7753_read24(RSTIPEAK);
}

/** === getVpeakReset ===
* Same as Channel 2 Peak Register except that the register contents are reset to 0 after a read.
* @param none
* @return long with the data (24 bits  unsigned).
*/
long ADE7753_getVpeakReset(void){
    return ADE7753_read24(RSTVPEAK);
}

/** === getPeriod ===
* Period of the Channel 2 (Voltage Channel) Input Estimated by Zero-Crossing Processing.
* The ADE7753 provides the period measurement of the grid line.
* The period register is an unsigned 16-bit register and is updated every period.
* The MSB of this register is always zero.
* The resolution of this register is 2.2 Î¼s/LSB when CLKIN = 3.579545 MHz,
* which represents 0.013% when the line fre-quency is 60 Hz.
* When the line frequency is 60 Hz, the value of the period register is
* approximately CLKIN/4/32/60 Hz x16 = 7457d.
* The length of the register enables the measurement of line frequencies as low as 13.9 Hz.
* @param none
* @return int with the data (16 bits unsigned).
*/
int ADE7753_getPeriod(void){
    return ADE7753_read16(PERIOD);
}

/** === getTemp ===
* Force a temperature measure and then returns it. This is done by setting bit 5 HIGH in MODE register.
* Temperature measuring can't be calibrated, the values used in this function are according to the datasheet
* (register TEMP is 0x00 at -25 celsius degrees).
*  The contents of the temperature register are signed (twos complement) with a resolution of
* approximately 1.5 LSB/ °C. The temperature register produces a code of 0x00 when the ambient
* temperature is approximately -25°C. The temperature measurement is uncalibrated in the ADE7753
* and has an offset tolerance as high as ±25 °C.
* @param none
* @return char with the temperature in celsius degrees.
*/
char ADE7753_getTemp(){
    unsigned int tt;
    unsigned char r=0;
    long lastMode = 0;
    //char zero;

    //zero=PIND.3;// Connect ZX pin on ADE7753 to pin   PIND.3 on MCU
    //while(PIND.3 == zero);// wait Zero-Crossing

    lastMode = ADE7753_getMode();
    //Temp measure
    ADE7753_setMode(TEMPSEL);
    ADE7753_getresetInterruptStatus(); // Clear all interrupts
    tt=0;
while( ! ( ADE7753_getInterruptStatus() & TEMPREADY ) ) // wait for Temperature measurement to be ready
    { // wait for the selected interrupt to occur
        if ( tt > 1000)
        {
             printf("0 AC");
            ADE7753_getresetInterruptStatus(); // Clear all interrupts
            break;
        }
    }
    //Read register
    r= ADE7753_read8(TEMP);

    //    // Do it twice to make sure
    //Read register
    r= ADE7753_read8(TEMP);

    // Set to the previous mode
    ADE7753_setMode (lastMode);
    return (1806*r-25000)/1000;
    //return r;
}

// Functions for manual setting of calibrations

/** === energySetup ===
* @param
* @param
*/
void ADE7753_energySetup(int wgain, char wdiv, int apos, int vagain, char vadiv, char phcal){
    ADE7753_write16(WGAIN,wgain);
    ADE7753_write8(WDIV,wdiv);
    ADE7753_write16(APOS,apos);
    ADE7753_write16(VAGAIN,vagain);
    ADE7753_write8(VADIV,vadiv);
    ADE7753_write8(PHCAL,phcal);
}


/** === frequencySetup ===
* The output frequency on the CF pin is adjusted by writing to this 12-bit
* read/write registerâ€”see the Energy-to-Frequency Conversion section.
* @param cfnum: integer containing number (12 bits available unsigned. ie range=[0,4095])
* @param cfden: the same as cfnum
*/
void ADE7753_frequencySetup(int cfnum, int cfden){
    ADE7753_write16(CFNUM,cfnum);
    ADE7753_write16(CFDEN,cfden);
}

/** === analogSetup ===
* This 8-bit register is used to adjust the gain selection for the PGA in Channels 1 and 2
* @param gain_ch1 char set the PGA channel 1 gain, use constants GAIN_1, GAIN_2, GAIN_4, GAIN_8 and gain_16
* @param gain_ch2 char set the PGA channel 2 gain, use constants GAIN_1, GAIN_2, GAIN_4, GAIN_8 and gain_16
* @param os_ch1 char set channel 1 analog offset, range : [-32,32]
* @param os_ch2 char set channel 1 analog offset, range : [-32,32]
* @param scale_ch1 char
* @param integrator_ch1 char
* @return char with the data (8 bits unsigned).
*/
void ADE7753_analogSetup(int gain_ch1, int gain_ch2,int os_ch1,int os_ch2,int scale_ch1,int integrator_ch1){
    unsigned char pga = (gain_ch2<<5) | (scale_ch1<<3) | (gain_ch1); //format is |3 bits PGA2 gain|2 bits full scale|3 bits PGA1 gain
    int sign = 0;
    int ch1os = 0, ch2os = 0;


    ADE7753_write8(GAIN,pga);//write GAIN register, format is |3 bits PGA2 gain|2 bits full scale|3 bits PGA1 gain

    // CH1OS: ch1 offset 6-bit, sign magnitude on Bit-5 then integrator on Bit-7
    // Refer to spec Page 58 Table 16
    if(os_ch1<0){
        sign=1;
        os_ch1=-os_ch1;
    } else{ sign=0; }
    ch1os = (integrator_ch1<<7) | (sign<<5) | os_ch1;
    ADE7753_write8(CH1OS,ch1os);

    // CH2OS: ch2 offset, sign magnitude (ch2 doesn't have integrator) and the offset applied is inverted (ie offset of -1 sums 1)
    if(os_ch2<0){
        sign=1;
        os_ch2=-os_ch2;
    } else{ sign=0; }
    ch2os = (sign<<5) | os_ch2;
    ADE7753_write8(CH2OS,ch2os);
}

/** === rmsSetup ===
**/
void ADE7753_rmsSetup(int irmsos, int vrmsos){
    ADE7753_write16(VRMSOS,vrmsos);
    ADE7753_write16(IRMSOS,irmsos);
}

void ADE7753_miscSetup(int zxtout, char sagsyc, char saglvl, char ipklvl, char vpklvl, char tmode){
    // ZXTOUT 12-bit (U) - Zero-Crossing Timeout
    // SAGCYC  8-bit (U) - Sag Line Cycle Register.
    // SAGLVL  8-bit (U) - Sag Voltage Level.
    // IPKLVL  8-bit (U) - Channel 1 Peak Level Threshold
    // VPKLVL  8-bit (U) - Channel 2 Peak Level Threshold
    // TMODE   8-bit (U) - Test Mode Register
    ADE7753_write16(ZXTOUT,zxtout);
    ADE7753_write8(SAGCYC,sagsyc);
    ADE7753_write8(SAGLVL,saglvl);
    ADE7753_write8(IPKLVL,ipklvl);
    ADE7753_write8(VPKLVL,vpklvl);
    ADE7753_write8(TMODE,tmode);
}

void ADE7753_setInterruptsMask(int Mask16){
    ADE7753_write16(IRQEN, Mask16);
}

void ADE7753_setLineCyc(int d){
    ADE7753_write16(LINECYC,d);
}

/** === printGetResetInterruptStatus ===
* used for code verification et debugging
*/
void ADE7753_printGetResetInterruptStatus(void){

    //int InterruptMask;

    //printf("Interrupt Status (binary): ");
    //InterruptMask = ADE7753_getresetInterruptStatus();
}



/** === chkSum ===
* Checksum Register. This 6-bit read-only register is equal to the sum of all the ones in the previous read.
* see the ADE7753 Serial Read Operation section.
* @param none
* @return char with the data (6 bits unsigned).
*/
char ADE7753_chkSum(){
    return ADE7753_read8(CHKSUM);
}

/** === getActiveEnergy ===
* Active power is accumulated (integrated) over time in this 24-bit, read-only register
* @param none
* @return long with the data (24 bits 2-complement signed).
*/
long ADE7753_getActiveEnergy(void){
    return ADE7753_read24(AENERGY);
}

/** === getActiveEnergyReset ===
* Same as the active energy register except that the register is reset to 0 following a read operation.
* @param none
* @return long with the data (24 bits 2-complement signed).
*/
long ADE7753_getActiveEnergyReset(void){
    return ADE7753_read24(RAENERGY);
}

/** === getApparentEnergy ===
* Apparent Energy Register. Apparent power is accumulated over time in this read-only register.
* @param none
* @return long with the data (24 bits unsigned).
*/
long ADE7753_getApparentEnergy(void){
    return ADE7753_read24(VAENERGY);
}

/** === getApparentEnergyReset ===
* Same as the VAENERGY register except that the register is reset to 0 following a read operation.
* @param none
* @return long with the data (24 bits unsigned).
*/
long ADE7753_getApparentEnergyReset(void){
    return ADE7753_read24(RVAENERGY);
}

/** === getCurrentOffset ===
* Channel 2 RMS Offset Correction Register.
* @param none
* @return int with the data (12 bits 2-complement signed).
*/
int ADE7753_getCurrentOffset(){
    return ADE7753_read16(IRMSOS);
}

/** === getVoltageOffset ===
* Channel 2 RMS Offset Correction Register.
*
* @param none
* @return int with the data (12 bits 2-complement's signed).
*/
int ADE7753_getVoltageOffset(){
    return ADE7753_read16(VRMSOS);
}

/** === setZeroCrossingTimeout / getZeroCrossingTimeout ===
* Zero-Crossing Timeout. If no zero crossings are detected
* on Channel 2 within a time period specified by this 12-bit register,
* the interrupt request line (IRQ) is activated
* @param none
* @return int with the data (12 bits unsigned).
*/
void ADE7753_setZeroCrossingTimeout(int d){
    ADE7753_write16(ZXTOUT,d);
}
int ADE7753_getZeroCrossingTimeout(){
    return ADE7753_read16(ZXTOUT);
}

/** === getSagCycles / setSagCycles ===
* Sag Line Cycle Register. This 8-bit register specifies the number of
* consecutive line cycles the signal on Channel 2 must be below SAGLVL
* before the SAG output is activated.
* @param none
* @return char with the data (8 bits unsigned).
*/
char ADE7753_getSagCycles(){
    return ADE7753_read8(SAGCYC);
}
void ADE7753_setSagCycles(char d){
    ADE7753_write8(SAGCYC,d);
}

/** === getLineCyc / setLineCyc ===
* Line Cycle Energy Accumulation Mode Line-Cycle Register.
* This 16-bit register is used during line cycle energy accumulation mode
* to set the number of half line cycles for energy accumulation
* @param none
* @return int with the data (16 bits unsigned).
*/
int ADE7753_getLineCyc(){
    return ADE7753_read16(LINECYC);
}


/** === getSagVoltageLevel / setSagVoltageLevel ===
* Sag Voltage Level. An 8-bit write to this register determines at what peak
* signal level on Channel 2 the SAG pin becomes active. The signal must remain
* low for the number of cycles specified in the SAGCYC register before the SAG pin is activated
* @param none
* @return char with the data (8 bits unsigned).
*/
char ADE7753_getSagVoltageLevel(){
    return ADE7753_read8(SAGLVL);
}
void ADE7753_setSagVoltageLevel(char d){
    ADE7753_write8(SAGLVL,d);
}

/** === getIPeakLevel / setIPeakLevel ===
* Channel 1 Peak Level Threshold (Current Channel). This register sets the level of the current
* peak detection. If the Channel 1 input exceeds this level, the PKI flag in the status register is set.
* @param none
* @return char with the data (8 bits unsigned).
*/
char ADE7753_getIPeakLevel(){
    return ADE7753_read8(IPKLVL);
}
void ADE7753_setIPeakLevel(char d){
    ADE7753_write8(IPKLVL,d);
}

/** === getVPeakLevel / setVPeakLevel ===
* Channel 2 Peak Level Threshold (Voltage Channel). This register sets the level of the
* voltage peak detection. If the Channel 2 input exceeds this level,
* the PKV flag in the status register is set.
* @param none
* @return char with the data (8bits unsigned).
*/
char ADE7753_getVPeakLevel(){
    return ADE7753_read8(VPKLVL);
}
void ADE7753_setVPeakLevel(char d){
    ADE7753_write8(VPKLVL,d);
}

/** === getVpeak ===
* Channel 2 Peak Register. The maximum input value of the voltage channel since the last read of the register is stored in this register.
* @param none
* @return long with the data (24 bits unsigned).
*/
long ADE7753_getVpeak(void){
    return ADE7753_read24(VPEAK);
}

/** === getIpeak ===
* Channel 1 Peak Register. The maximum input value of the current channel since the last read
* of the register is stored in this register.
* @param none
* @return long with the data (24 bits unsigned) .
*/
long ADE7753_getIpeak(void){
    return ADE7753_read24(IPEAK);
}

/** === energyGain ===
* @param
* @param
*/
void ADE7753_energyGain(int wgain, int vagain){
    ADE7753_write16(WGAIN,wgain);
    ADE7753_write16(VAGAIN,vagain);
}


/** === getLAENERGY ===
* Accumulated Active Energy until a fixed number of semi cicles according to the LineCyc register.
* @param none
* @return long with the data (24 bits unsigned).
*/

long ADE7753_get_LAENERGY(void){

    long aux;
    ADE7753_getresetInterruptStatus(); // Clear all interrupts
      while( !  ( ADE7753_getInterruptStatus() & CYCEND )  )   // wait Zero-Crossing
    {}
    aux=ADE7753_read24(LAENERGY);
    return aux;
}

long ADE7753_get_AENERGY(void){

    long aux;
    ADE7753_getresetInterruptStatus(); // Clear all interrupts
      while( !  ( ADE7753_getInterruptStatus() & CYCEND )  );   // wait Zero-Crossing

    aux=ADE7753_read24(AENERGY);
    return aux;
}

long ADE7753_get_LVAENERGY(void){

    long aux;
    ADE7753_getresetInterruptStatus(); // Clear all interrupts
      while( !  ( ADE7753_getInterruptStatus() & CYCEND )  );   // wait Zero-Crossing

    aux=ADE7753_read24(LVAENERGY);
    return aux;
}
long ADE7753_get_LVARENERGY(void){

    long aux;
    ADE7753_getresetInterruptStatus(); // Clear all interrupts
      while( !  ( ADE7753_getInterruptStatus() & CYCEND )  );   // wait Zero-Crossing

    aux=ADE7753_read24(LVARENERGY);
    return aux;
}
void ADE7753_get_ENERGY(long e1,long e2)
{

    ADE7753_getresetInterruptStatus(); // Clear all interrupts
      while( !  ( ADE7753_getInterruptStatus() & CYCEND )  );   // wait Zero-Crossing
    e1=ADE7753_read24(LAENERGY);
    e2=ADE7753_read24(LVAENERGY);

}




