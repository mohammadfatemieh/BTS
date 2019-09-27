
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega88PA
;Program type           : Application
;Clock frequency        : 16.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: Yes
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega88PA
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU EECR=0x1F
	.EQU EEDR=0x20
	.EQU EEARL=0x21
	.EQU EEARH=0x22
	.EQU SPSR=0x2D
	.EQU SPDR=0x2E
	.EQU SMCR=0x33
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU WDTCSR=0x60
	.EQU UCSR0A=0xC0
	.EQU UDR0=0xC6
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU GPIOR0=0x1E

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x04FF
	.EQU __DSTACK_SIZE=0x0100
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	RCALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	RCALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _MyID=R4
	.DEF _cpu_id=R3
	.DEF _checksum=R6
	.DEF _time_out=R5
	.DEF _usart_count=R8
	.DEF _time_out_run=R7
	.DEF _process_uart=R10
	.DEF _usart_time_out=R11
	.DEF _usart_time_out_msb=R12
	.DEF _rx_wr_index0=R9
	.DEF _rx_counter0=R14

;GPIOR0 INITIALIZATION VALUE
	.EQU __GPIOR0_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP _usart_rx_isr
	RJMP 0x00
	RJMP _usart_tx_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x30,0x0,0x37
	.DB  0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0

_0x0:
	.DB  0xD,0xA,0x3E,0x41,0x43,0x4D,0x20,0x55
	.DB  0x6E,0x69,0x74,0x20,0x76,0x31,0x20,0x66
	.DB  0x77,0x76,0x31,0x20,0x31,0x38,0x2F,0x30
	.DB  0x34,0x2F,0x32,0x30,0x31,0x36,0xD,0xA
	.DB  0x0,0x3E,0x41,0x43,0x4D,0x25,0x30,0x32
	.DB  0x58,0x25,0x30,0x34,0x58,0x25,0x30,0x34
	.DB  0x58,0x25,0x30,0x34,0x58,0x25,0x30,0x34
	.DB  0x58,0x25,0x30,0x34,0x58,0x25,0x30,0x34
	.DB  0x58,0x25,0x30,0x34,0x58,0x25,0x30,0x34
	.DB  0x58,0x25,0x30,0x32,0x58,0x3C,0x0
_0x20000:
	.DB  0x30,0x20,0x41,0x43,0x0

__GLOBAL_INI_TBL:
	.DW  0x0C
	.DW  0x03
	.DW  __REG_VARS*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;GPIOR0 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x200

	.CSEG
;/*******************************************************
;This program was created by the
;CodeWizardAVR V3.12 Advanced
;Automatic Program Generator
;© Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : AC measure
;Version : 1
;Date    : 4/18/2016
;Author  : swat
;Company :
;Comments:
;
;
;Chip type               : ATmega88PA
;Program type            : Application
;AVR Core Clock frequency: 16.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*******************************************************/
;
;#include <mega88a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;// Standard Input/Output functions
;#include <stdio.h>
;#include <delay.h>
;#include "acm.h"

	.CSEG
_HexInCharToDec:
; .FSTART _HexInCharToDec
	ST   -Y,R26
;	data -> Y+0
	LD   R26,Y
	CPI  R26,LOW(0x30)
	BRLO _0x4
	CPI  R26,LOW(0x3A)
	BRLO _0x5
_0x4:
	RJMP _0x3
_0x5:
	LD   R30,Y
	SUBI R30,LOW(48)
	RJMP _0x2080001
_0x3:
	LD   R26,Y
	CPI  R26,LOW(0x40)
	BRLO _0x7
	CPI  R26,LOW(0x47)
	BRLO _0x8
_0x7:
	RJMP _0x6
_0x8:
	LD   R30,Y
	SUBI R30,LOW(55)
	RJMP _0x2080001
_0x6:
	RJMP _0x2080001
; .FEND
_config_mcu:
; .FSTART _config_mcu
	LDI  R30,LOW(128)
	STS  97,R30
	LDI  R30,LOW(0)
	STS  97,R30
	LDI  R30,LOW(46)
	OUT  0x4,R30
	LDI  R30,LOW(0)
	OUT  0x5,R30
	LDI  R30,LOW(32)
	OUT  0x7,R30
	LDI  R30,LOW(0)
	OUT  0x8,R30
	OUT  0xA,R30
	LDI  R30,LOW(12)
	OUT  0xB,R30
	LDI  R30,LOW(0)
	OUT  0x24,R30
	LDI  R30,LOW(2)
	OUT  0x25,R30
	LDI  R30,LOW(56)
	OUT  0x26,R30
	LDI  R30,LOW(0)
	OUT  0x27,R30
	OUT  0x28,R30
	STS  128,R30
	STS  129,R30
	STS  133,R30
	STS  132,R30
	STS  135,R30
	STS  134,R30
	STS  137,R30
	STS  136,R30
	STS  139,R30
	STS  138,R30
	STS  182,R30
	STS  176,R30
	STS  177,R30
	STS  178,R30
	STS  179,R30
	STS  180,R30
	LDI  R30,LOW(1)
	STS  110,R30
	LDI  R30,LOW(0)
	STS  111,R30
	STS  112,R30
	STS  105,R30
	OUT  0x1D,R30
	STS  104,R30
	LDI  R30,LOW(2)
	STS  192,R30
	LDI  R30,LOW(216)
	STS  193,R30
	LDI  R30,LOW(6)
	STS  194,R30
	LDI  R30,LOW(0)
	STS  197,R30
	LDI  R30,LOW(16)
	STS  196,R30
	LDI  R30,LOW(128)
	OUT  0x30,R30
	LDI  R30,LOW(0)
	STS  123,R30
	STS  127,R30
	STS  122,R30
	LDI  R30,LOW(91)
	OUT  0x2C,R30
	LDI  R30,LOW(0)
	OUT  0x2D,R30
	STS  188,R30
	RET
; .FEND
;#include "ade7753.h"
;// SPI functions
;#include <spi.h>
;// Declare your global variables here
;
;
;
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0025 {
_timer0_ovf_isr:
; .FSTART _timer0_ovf_isr
	ST   -Y,R0
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0026 // Reinitialize Timer 0 value
; 0000 0027 TCNT0=0x38;
	LDI  R30,LOW(56)
	OUT  0x26,R30
; 0000 0028 // Place your code here
; 0000 0029 if(time_out_run==1){
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0x9
; 0000 002A usart_time_out--;
	__GETW1R 11,12
	SBIW R30,1
	__PUTW1R 11,12
; 0000 002B if(usart_time_out==0) time_out=1;}
	MOV  R0,R11
	OR   R0,R12
	BRNE _0xA
	LDI  R30,LOW(1)
	MOV  R5,R30
_0xA:
; 0000 002C time_to_check_ADE++;
_0x9:
	LDI  R26,LOW(_time_to_check_ADE)
	LDI  R27,HIGH(_time_to_check_ADE)
	RCALL SUBOPT_0x0
; 0000 002D }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R0,Y+
	RETI
; .FEND
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0031 {
_usart_rx_isr:
; .FSTART _usart_rx_isr
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0032 char status,data;
; 0000 0033 status=UCSR0A;
	RCALL __SAVELOCR2
;	status -> R17
;	data -> R16
	LDS  R17,192
; 0000 0034 data=UDR0;
	LDS  R16,198
; 0000 0035 usart_time_out=500;
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RCALL SUBOPT_0x1
; 0000 0036 time_out=0;
; 0000 0037 time_out_run=1;
; 0000 0038 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0xB
; 0000 0039    {
; 0000 003A    rx_buffer0[rx_wr_index0++]=data;
	MOV  R30,R9
	INC  R9
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	ST   Z,R16
; 0000 003B #if RX_BUFFER_SIZE0 == 256
; 0000 003C    // special case for receiver buffer size=256
; 0000 003D    if (++rx_counter0 == 0) rx_buffer_overflow0=1;
; 0000 003E #else
; 0000 003F    if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
	LDI  R30,LOW(50)
	CP   R30,R9
	BRNE _0xC
	CLR  R9
; 0000 0040    if (++rx_counter0 == RX_BUFFER_SIZE0)
_0xC:
	INC  R14
	LDI  R30,LOW(50)
	CP   R30,R14
	BRNE _0xD
; 0000 0041       {
; 0000 0042       rx_counter0=0;
	CLR  R14
; 0000 0043       rx_buffer_overflow0=1;
	SBI  0x1E,0
; 0000 0044       }
; 0000 0045 #endif
; 0000 0046    }
_0xD:
; 0000 0047 }
_0xB:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
; .FEND
;
;
;
;
;// USART Transmitter interrupt service routine
;interrupt [USART_TXC] void usart_tx_isr(void)
; 0000 004E {
_usart_tx_isr:
; .FSTART _usart_tx_isr
; 0000 004F RS485_TxD=0;
	CBI  0x8,5
; 0000 0050 }
	RETI
; .FEND
;
;
;
;
;void main(void)
; 0000 0056 {
_main:
; .FSTART _main
; 0000 0057 // Declare your local variables here
; 0000 0058 
; 0000 0059 
; 0000 005A config_mcu();
	RCALL _config_mcu
; 0000 005B // Global enable interrupts
; 0000 005C #asm("sei")
	sei
; 0000 005D RS485_TxD=1;
	SBI  0x8,5
; 0000 005E //while(usart_status&(RX_COMPLETE));
; 0000 005F printf("\r\n>ACM Unit v1 fwv1 18/04/2016\r\n");
	__POINTW1FN _0x0,0
	RCALL SUBOPT_0x2
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
; 0000 0060 
; 0000 0061 delay_ms(200);
	LDI  R26,LOW(200)
	LDI  R27,0
	RCALL _delay_ms
; 0000 0062               // Settings for Olimex Energy Shield #1 - Etel
; 0000 0063     // ------------------------------------
; 0000 0064     //ADE7753_analogSetup(GAIN_1, GAIN_1, 0, 0, FULLSCALESELECT_0_25V, INTEGRATOR_OFF);  // GAIN1, GAIN2, CH1OS, CH2OS,  ...
; 0000 0065     //ADE7753_rmsSetup( -0, +0 );                 // IRMSOS,VRMSOS  12-bit (S) [-2048 +2048] -- Refer to spec page 25, 2 ...
; 0000 0066     //ADE7753_energySetup(0, 0, 0, 0, 0, 0x0D); // WGAIN,WDIV,APOS,VAGAIN,VADIV,PHCAL  -- Refer to spec page 39, 31, 46, ...
; 0000 0067     //ADE7753_frequencySetup(0, 0);             // CFNUM,CFDEN  12-bit (U) -- for CF pulse output  -- Refer to spec page ...
; 0000 0068     //ADE7753_miscSetup(0, 0, 0, 0, 0, 0);   3450=0
; 0000 0069 ADE7753_analogSetup(GAIN_4, GAIN_1, -3,-2, FULLSCALESELECT_0_5V, INTEGRATOR_OFF);  // GAIN1, GAIN2, CH1OS, CH2OS, Range_ ...
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL SUBOPT_0x3
	LDI  R30,LOW(65533)
	LDI  R31,HIGH(65533)
	RCALL SUBOPT_0x2
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	RCALL SUBOPT_0x3
	LDI  R26,LOW(0)
	LDI  R27,0
	RCALL _ADE7753_analogSetup
; 0000 006A ADE7753_rmsSetup( -60, -1999 );
	LDI  R30,LOW(65476)
	LDI  R31,HIGH(65476)
	RCALL SUBOPT_0x2
	LDI  R26,LOW(63537)
	LDI  R27,HIGH(63537)
	RCALL _ADE7753_rmsSetup
; 0000 006B //ADE7753_write16(WGAIN,0);
; 0000 006C //ADE7753_write16(CFDEN,6253);delay_ms(200);
; 0000 006D //ADE7753_write8(WDIV,4);// Chia cac loai cong suat cho WDIV :))
; 0000 006E //ADE7753_write16(WGAIN,131);delay_ms(200);
; 0000 006F //ADE7753_write16(APOS,-784);delay_ms(200);
; 0000 0070 //ADE7753_setMode(CYCMODE); //Mode energy accumulation begins.
; 0000 0071 //ADE7753_setLineCyc(1000);
; 0000 0072 //delay_ms(200);
; 0000 0073 //RS485_TxD=1;
; 0000 0074 //printf("CFDEN:%u\r\n",ADE7753_read16(CFDEN));delay_ms(200);
; 0000 0075 //RS485_TxD=1;
; 0000 0076 //printf("WGAIN:%u\r\n",ADE7753_read16(WGAIN));delay_ms(200);
; 0000 0077 //RS485_TxD=1;
; 0000 0078 //printf("WDIV:%u\r\n",ADE7753_read8(WDIV));delay_ms(200);
; 0000 0079 //RS485_TxD=1;
; 0000 007A //printf("APOS:%u\r\n",ADE7753_read8(APOS));
; 0000 007B Vpeak 	  = ADE7753_getVpeakReset() ;
	RCALL SUBOPT_0x4
; 0000 007C adc_data[0]=(int)(Vpeak/19.05);
	LDS  R30,_Vpeak
	LDS  R31,_Vpeak+1
	LDS  R22,_Vpeak+2
	LDS  R23,_Vpeak+3
	RCALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x41986666
	RCALL __DIVF21
	RCALL __CFD1
	RCALL SUBOPT_0x5
; 0000 007D adc_data[7]=ADE7753_getPeriod();
	RCALL SUBOPT_0x6
; 0000 007E IDC_Standby;
	CBI  0x7,4
	SBI  0x8,4
; 0000 007F usart_time_out=5000;
	LDI  R30,LOW(5000)
	LDI  R31,HIGH(5000)
	RCALL SUBOPT_0x1
; 0000 0080 time_out=0;
; 0000 0081 time_out_run=1;
; 0000 0082 process_uart=1;// Clear buffer
	LDI  R30,LOW(1)
	MOV  R10,R30
; 0000 0083 while (1)
_0x18:
; 0000 0084       {
; 0000 0085       // Place your code here
; 0000 0086 
; 0000 0087 
; 0000 0088       if(time_out==1)
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x1B
; 0000 0089       {
; 0000 008A         time_out=0;
	CLR  R5
; 0000 008B         time_out_run=0;
	CLR  R7
; 0000 008C         process_uart=1;
	MOV  R10,R30
; 0000 008D       }
; 0000 008E       if(process_uart==1)
_0x1B:
	LDI  R30,LOW(1)
	CP   R30,R10
	BREQ PC+2
	RJMP _0x1C
; 0000 008F       {
; 0000 0090         // Chi nhan ban tin tu CPU_Unit ">CPU[REC_ID]r[checksum]<"
; 0000 0091         // In hex : ">CPU[0xMyIDHigh.0xMyIDLow]r[0xchecksum.0xchecksum]<"
; 0000 0092         //">CPU30r37<"
; 0000 0093         if((rx_buffer0[0]=='>')&&(rx_buffer0[1]=='C')&&(rx_buffer0[2]=='P')&&(rx_buffer0[3]=='U')&&(rx_buffer0[9]=='<')
; 0000 0094         &&(HexInCharToDec(rx_buffer0[5]) +  (HexInCharToDec(rx_buffer0[4])<<4) ==MyID)
; 0000 0095         &&(HexInCharToDec(rx_buffer0[8]) +  (HexInCharToDec(rx_buffer0[7])<<4) ==checksum))
	LDS  R26,_rx_buffer0
	CPI  R26,LOW(0x3E)
	BRNE _0x1E
	__GETB2MN _rx_buffer0,1
	CPI  R26,LOW(0x43)
	BRNE _0x1E
	__GETB2MN _rx_buffer0,2
	CPI  R26,LOW(0x50)
	BRNE _0x1E
	__GETB2MN _rx_buffer0,3
	CPI  R26,LOW(0x55)
	BRNE _0x1E
	__GETB2MN _rx_buffer0,9
	CPI  R26,LOW(0x3C)
	BRNE _0x1E
	__GETB2MN _rx_buffer0,5
	RCALL SUBOPT_0x7
	PUSH R31
	PUSH R30
	__GETB2MN _rx_buffer0,4
	RCALL SUBOPT_0x7
	RCALL __LSLW4
	POP  R26
	POP  R27
	ADD  R26,R30
	ADC  R27,R31
	MOV  R30,R4
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x1E
	__GETB2MN _rx_buffer0,8
	RCALL SUBOPT_0x7
	PUSH R31
	PUSH R30
	__GETB2MN _rx_buffer0,7
	RCALL SUBOPT_0x7
	RCALL __LSLW4
	POP  R26
	POP  R27
	ADD  R26,R30
	ADC  R27,R31
	MOV  R30,R6
	LDI  R31,0
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x1F
_0x1E:
	RJMP _0x1D
_0x1F:
; 0000 0096         {
; 0000 0097         RS485_TxD=1;
	SBI  0x8,5
; 0000 0098         //printf("CPU request!\r\n");// Phan hoi tat cac cac gia tri AC ADC????Co can cau hinh ADE ko????
; 0000 0099         printf(">ACM%02X%04X%04X%04X%04X%04X%04X%04X%04X%02X<",cpu_id,adc_data[0],adc_data[1],adc_data[2],adc_data[3],ad ...
	__POINTW1FN _0x0,33
	RCALL SUBOPT_0x2
	MOV  R30,R3
	RCALL SUBOPT_0x8
	LDS  R30,_adc_data
	LDS  R31,_adc_data+1
	RCALL SUBOPT_0x9
	__GETW1MN _adc_data,2
	RCALL SUBOPT_0x9
	__GETW1MN _adc_data,4
	RCALL SUBOPT_0x9
	__GETW1MN _adc_data,6
	RCALL SUBOPT_0x9
	__GETW1MN _adc_data,8
	RCALL SUBOPT_0x9
	__GETW1MN _adc_data,10
	RCALL SUBOPT_0x9
	__GETW1MN _adc_data,12
	RCALL SUBOPT_0x9
	__GETW1MN _adc_data,14
	RCALL SUBOPT_0x9
	MOV  R30,R6
	RCALL SUBOPT_0x8
	LDI  R24,40
	RCALL _printf
	ADIW R28,42
; 0000 009A         }
; 0000 009B         //RS485_TxD=1;
; 0000 009C         //printf("Mess:%s!\r\n",rx_buffer0);
; 0000 009D         process_uart=0;
_0x1D:
	CLR  R10
; 0000 009E         for(usart_count=0;usart_count<RX_BUFFER_SIZE0;usart_count++)
	CLR  R8
_0x23:
	LDI  R30,LOW(50)
	CP   R8,R30
	BRSH _0x24
; 0000 009F                             {
; 0000 00A0                             rx_buffer0[usart_count]=0;
	MOV  R30,R8
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 00A1                             }
	INC  R8
	RJMP _0x23
_0x24:
; 0000 00A2                             rx_wr_index0=0;
	CLR  R9
; 0000 00A3       }
; 0000 00A4       if(time_to_check_ADE>10000)//1s
_0x1C:
	LDS  R26,_time_to_check_ADE
	LDS  R27,_time_to_check_ADE+1
	CPI  R26,LOW(0x2711)
	LDI  R30,HIGH(0x2711)
	CPC  R27,R30
	BRSH PC+2
	RJMP _0x25
; 0000 00A5       {
; 0000 00A6         time_to_check_ADE=0;
	LDI  R30,LOW(0)
	STS  _time_to_check_ADE,R30
	STS  _time_to_check_ADE+1,R30
; 0000 00A7         Vrms 	  = ADE7753_vrms() ;    // Hieu dien the hieu dung, Vrms = Vpeak / sqrt(2)     , Vpeak la V max
	RCALL _ADE7753_vrms
	STS  _Vrms,R30
	STS  _Vrms+1,R31
	STS  _Vrms+2,R22
	STS  _Vrms+3,R23
; 0000 00A8         Irms 	  = ADE7753_irms() ;     // Cuong do dong dien hieu dung, Irms = Ipeak / sqrt(2)
	RCALL _ADE7753_irms
	STS  _Irms,R30
	STS  _Irms+1,R31
	STS  _Irms+2,R22
	STS  _Irms+3,R23
; 0000 00A9         Ipeak 	  = ADE7753_getIpeakReset() ;
	RCALL _ADE7753_getIpeakReset
	STS  _Ipeak,R30
	STS  _Ipeak+1,R31
	STS  _Ipeak+2,R22
	STS  _Ipeak+3,R23
; 0000 00AA         Vpeak 	  = ADE7753_getVpeakReset() ;
	RCALL SUBOPT_0x4
; 0000 00AB         adc_data[7] = ADE7753_getPeriod();
	RCALL SUBOPT_0x6
; 0000 00AC 
; 0000 00AD         adc_data[0]=Vpeak;
	LDS  R30,_Vpeak
	LDS  R31,_Vpeak+1
	RCALL SUBOPT_0x5
; 0000 00AE         adc_data[1]=Vrms;
	LDS  R30,_Vrms
	LDS  R31,_Vrms+1
	__PUTW1MN _adc_data,2
; 0000 00AF         adc_data[2]=Irms;
	LDS  R30,_Irms
	LDS  R31,_Irms+1
	__PUTW1MN _adc_data,4
; 0000 00B0         adc_data[3]=Ipeak;
	LDS  R30,_Ipeak
	LDS  R31,_Ipeak+1
	__PUTW1MN _adc_data,6
; 0000 00B1         //RS485_TxD=1;
; 0000 00B2         //printf("Vrms:%d;Vpeak:%d;Irms:%d;Ipeak:%d;PERIOD:%d\r\n",adc_data[1],adc_data[0],adc_data[2],adc_data[3],adc_d ...
; 0000 00B3       }
; 0000 00B4       }
_0x25:
	RJMP _0x18
; 0000 00B5 }
_0x26:
	RJMP _0x26
; .FEND
;
;//delay_ms(500);
;//      delay_ms(500);
;//
;//      Vrms 	  = ADE7753_vrms() ;    // Hieu dien the hieu dung, Vrms = Vpeak / sqrt(2)     , Vpeak la V max
;//      Irms 	  = ADE7753_irms()-800 ;     // Cuong do dong dien hieu dung, Irms = Ipeak / sqrt(2)
;//      Vpeak 	  = ADE7753_getVpeakReset() ;
;//      Ipeak 	  = ADE7753_getIpeakReset() ;
;//      Frequency = ADE7753_getPeriod();
;//      //Vpeak 	  = ADE7753_getVpeakReset() ;
;//      //Vrms=2642412;
;//      delay_ms(500);
;//      RS485_TxD=1;
;//      //printf("test:%d\r\n",-32765);
;//      printf("Vrms:%d;Vpeak:%d;Irms:%d;Ipeak:%d;PERIOD:%d\r\n",Vrms,(int)(Vpeak/13.63),Irms,Ipeak,Frequency);
;
;#include <mega88a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif
;// Standard Input/Output functions
;#include <stdio.h>
;#include <delay.h>
;
;#include "ade7753.h"
;
;// SPI functions
;#include <spi.h>
;#define CS_ADE PORTB.1=0
;#define NCS_ADE PORTB.1=1
;
;void setup(void)
; 0001 000E {

	.CSEG
; 0001 000F     // Settings for Olimex Energy Shield #1 - Etel
; 0001 0010     // ------------------------------------
; 0001 0011     //ADE7753_analogSetup(GAIN_1, GAIN_1, 0, 0, FULLSCALESELECT_0_25V, INTEGRATOR_OFF);  // GAIN1, GAIN2, CH1OS, CH2OS,  ...
; 0001 0012     //ADE7753_rmsSetup( -0, +0 );                 // IRMSOS,VRMSOS  12-bit (S) [-2048 +2048] -- Refer to spec page 25, 2 ...
; 0001 0013     //ADE7753_energySetup(0, 0, 0, 0, 0, 0x0D); // WGAIN,WDIV,APOS,VAGAIN,VADIV,PHCAL  -- Refer to spec page 39, 31, 46, ...
; 0001 0014     //ADE7753_frequencySetup(0, 0);             // CFNUM,CFDEN  12-bit (U) -- for CF pulse output  -- Refer to spec page ...
; 0001 0015     //ADE7753_miscSetup(0, 0, 0, 0, 0, 0);
; 0001 0016 }
;
;/// ADE Driver
;
;/** === enableChip ===
;* Enable chip, setting low ChipSelect pin (CS)
;* @param none
;*
;*/
;void ADE7753_enableChip(void){
; 0001 001F void ADE7753_enableChip(void){
_ADE7753_enableChip:
; .FSTART _ADE7753_enableChip
; 0001 0020     CS_ADE;
	CBI  0x5,1
; 0001 0021 }
	RET
; .FEND
;
;/** === disableChip ===
;* Disable chip, setting high ChipSelect pin (CS)
;* @param none
;*
;*/
;void ADE7753_disableChip(void){
; 0001 0028 void ADE7753_disableChip(void){
_ADE7753_disableChip:
; .FSTART _ADE7753_disableChip
; 0001 0029     NCS_ADE;
	SBI  0x5,1
; 0001 002A }
	RET
; .FEND
;
;/** === read8 ===
;* Read 8 bits from the device at specified register
;* @param char containing register direction
;* @return char with contents of register
;*
;*/
;unsigned char ADE7753_read8(char reg){
; 0001 0032 unsigned char ADE7753_read8(char reg){
; 0001 0033 
; 0001 0034     unsigned char b0;
; 0001 0035     ADE7753_enableChip();
;	reg -> Y+1
;	b0 -> R17
; 0001 0036     spi(reg);
; 0001 0037     b0=spi(0x00);
; 0001 0038     ADE7753_disableChip();
; 0001 0039     //    return (unsigned long)SPI.transfer(0x00);
; 0001 003A     return b0;
; 0001 003B }
;
;/** === read16 ===
;* Read 16 bits from the device at specified register
;* @param char containing register direction
;* @return int with contents of register
;*
;*/
;unsigned int ADE7753_read16(char reg){
; 0001 0043 unsigned int ADE7753_read16(char reg){
_ADE7753_read16:
; .FSTART _ADE7753_read16
; 0001 0044 
; 0001 0045     unsigned char b1,b0;
; 0001 0046     ADE7753_enableChip();
	ST   -Y,R26
	RCALL __SAVELOCR2
;	reg -> Y+2
;	b1 -> R17
;	b0 -> R16
	RCALL _ADE7753_enableChip
; 0001 0047     spi(reg);
	LDD  R26,Y+2
	RCALL SUBOPT_0xA
; 0001 0048 
; 0001 0049     b1=spi(0x00);
; 0001 004A 
; 0001 004B     b0=spi(0x00);
; 0001 004C 
; 0001 004D     ADE7753_disableChip();
	RCALL _ADE7753_disableChip
; 0001 004E     return (unsigned int)b1<<8 | (unsigned int)b0;
	MOV  R31,R17
	LDI  R30,LOW(0)
	MOVW R26,R30
	MOV  R30,R16
	LDI  R31,0
	OR   R30,R26
	OR   R31,R27
	RCALL __LOADLOCR2
	RJMP _0x2080003
; 0001 004F }
; .FEND
;
;/** === read24 ===
;* Read 24 bits from the device at specified register
;* @param: char containing register direction
;* @return: char with contents of register
;*
;*/
;unsigned long ADE7753_read24(char reg){
; 0001 0057 unsigned long ADE7753_read24(char reg){
_ADE7753_read24:
; .FSTART _ADE7753_read24
; 0001 0058 
; 0001 0059     unsigned char b2,b1,b0;
; 0001 005A      ADE7753_enableChip();
	ST   -Y,R26
	RCALL __SAVELOCR4
;	reg -> Y+4
;	b2 -> R17
;	b1 -> R16
;	b0 -> R19
	RCALL _ADE7753_enableChip
; 0001 005B     spi(reg);
	LDD  R26,Y+4
	RCALL SUBOPT_0xA
; 0001 005C 
; 0001 005D     b2=spi(0x00);
; 0001 005E 
; 0001 005F     b1=spi(0x00);
; 0001 0060 
; 0001 0061     b0=spi(0x00);
	LDI  R26,LOW(0)
	RCALL _spi
	MOV  R19,R30
; 0001 0062 
; 0001 0063     ADE7753_disableChip();
	RCALL _ADE7753_disableChip
; 0001 0064     return (unsigned long)b2<<16 | (unsigned long)b1<<8 | (unsigned long)b0;
	MOV  R30,R17
	RCALL SUBOPT_0xB
	RCALL __LSLD16
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOV  R30,R16
	RCALL SUBOPT_0xB
	MOVW R26,R30
	MOVW R24,R22
	LDI  R30,LOW(8)
	RCALL __LSLD12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __ORD12
	MOVW R26,R30
	MOVW R24,R22
	MOV  R30,R19
	RCALL SUBOPT_0xB
	RCALL __ORD12
	RCALL __LOADLOCR4
	RJMP _0x2080008
; 0001 0065 }
; .FEND
;
;/** === write8 ===
;* Write 8 bits to the device at specified register
;* @param reg char containing register direction
;* @param data char, 8 bits of data to send
;*
;*/
;void ADE7753_write8(char reg, unsigned char data){
; 0001 006D void ADE7753_write8(char reg, unsigned char data){
_ADE7753_write8:
; .FSTART _ADE7753_write8
; 0001 006E 
; 0001 006F     unsigned char data0 = 0;
; 0001 0070     ADE7753_enableChip();
	ST   -Y,R26
	ST   -Y,R17
;	reg -> Y+2
;	data -> Y+1
;	data0 -> R17
	LDI  R17,0
	RCALL _ADE7753_enableChip
; 0001 0071     // 8th bit (DB7) of the register address controls the Read/Write mode (Refer to spec page 55 table 13)
; 0001 0072     // For Write -> DB7 = 1  / For Read -> DB7 = 0
; 0001 0073     reg |= WRITE;
	LDD  R30,Y+2
	ORI  R30,0x80
	STD  Y+2,R30
; 0001 0074     data0 = (unsigned char)data;
	LDD  R17,Y+1
; 0001 0075 
; 0001 0076 
; 0001 0077     spi((unsigned char)reg);          //register selection
	LDD  R26,Y+2
	RCALL SUBOPT_0xC
; 0001 0078 
; 0001 0079     spi((unsigned char)data0);
; 0001 007A 
; 0001 007B     ADE7753_disableChip();
; 0001 007C }
	LDD  R17,Y+0
	RJMP _0x2080003
; .FEND
;
;
;/** === write16 ===
;* Write 16 bits to the device at specified register
;* @param reg: char containing register direction
;* @param data: int, 16 bits of data to send
;*
;*/
;void ADE7753_write16(char reg, unsigned int data){
; 0001 0085 void ADE7753_write16(char reg, unsigned int data){
_ADE7753_write16:
; .FSTART _ADE7753_write16
; 0001 0086 
; 0001 0087     unsigned char data0=0,data1=0;
; 0001 0088     ADE7753_enableChip();
	RCALL SUBOPT_0xD
	RCALL __SAVELOCR2
;	reg -> Y+4
;	data -> Y+2
;	data0 -> R17
;	data1 -> R16
	LDI  R17,0
	LDI  R16,0
	RCALL _ADE7753_enableChip
; 0001 0089     // 8th bit (DB7) of the register address controls the Read/Write mode (Refer to spec page 55 table 13)
; 0001 008A     // For Write -> DB7 = 1  / For Read -> DB7 = 0
; 0001 008B     reg |= WRITE;
	LDD  R30,Y+4
	ORI  R30,0x80
	STD  Y+4,R30
; 0001 008C     //split data
; 0001 008D     data0 = (unsigned char)data;
	LDD  R17,Y+2
; 0001 008E     data1 = (unsigned char)(data>>8);
	LDD  R16,Y+3
; 0001 008F 
; 0001 0090     //register selection, we have to send a 1 on the 8th bit to perform a write
; 0001 0091 
; 0001 0092     spi((unsigned char)reg);
	LDD  R26,Y+4
	RCALL _spi
; 0001 0093 
; 0001 0094     //data send, MSB first
; 0001 0095     spi((unsigned char)data1);
	MOV  R26,R16
	RCALL SUBOPT_0xC
; 0001 0096 
; 0001 0097     spi((unsigned char)data0);
; 0001 0098 
; 0001 0099     ADE7753_disableChip();
; 0001 009A }
	RCALL __LOADLOCR2
	RJMP _0x2080008
; .FEND
;
;
;/*****************************
;*
;*     public functions
;*
;*****************************/
;
;
;/**
;* In general:
;* @params:  void
;* @return: register content (measure) of the proper type depending on register width
;*/
;
;/** === setMode / getMode ===
;* This is a 16-bit register through which most of the ADE7753 functionality is accessed.
;* Signal sample rates, filter enabling, and calibration modes are selected by writing to this register.
;* The contents can be read at any time.
;*
;*
;* The next table describes the functionality of each bit in the register:
;*
;* Bit     Location    Bit Mnemonic    Default Value Description
;* 0       DISHPF       0            HPF (high-pass filter) in Channel 1 is disabled when this bit is set.
;* 1       DISLPF2      0            LPF (low-pass filter) after the multiplier (LPF2) is disabled when this bit is set.
;* 2       DISCF        1            Frequency output CF is disabled when this bit is set.
;* 3       DISSAG       1            Line voltage sag detection is disabled when this bit is set.
;* 4       ASUSPEND     0            By setting this bit to Logic 1, both ADE7753 A/D converters can be turned off. In no ...
;* 5       TEMPSEL      0            Temperature conversion starts when this bit is set to 1. This bit is automatically r ...
;* 6       SWRST        0            Software Chip Reset. A data transfer should not take place to the ADE7753 for at lea ...
;* 7       CYCMODE      0            Setting this bit to Logic 1 places the chip into line cycle energy accumulation mode ...
;* 8       DISCH1       0            ADC 1 (Channel 1) inputs are internally shorted together.
;* 9       DISCH2       0            ADC 2 (Channel 2) inputs are internally shorted together.
;* 10       SWAP         0            By setting this bit to Logic 1 the analog inputs V2P and V2N are connected to ADC 1 ...
;* 12, 11  DTRT1,0      0            These bits are used to select the waveform register update rate.
;*                         DTRT 1    DTRT0    Update Rate
;*                             0    0    27.9 kSPS (CLKIN/128)
;*                             0    1    14 kSPS (CLKIN/256)
;*                             1    0    7 kSPS (CLKIN/512)
;*                             1    1    3.5 kSPS (CLKIN/1024)
;* 14, 13  WAVSEL1,0    0            These bits are used to select the source of the sampled data for the waveform regist ...
;*                               WAVSEL1, 0    Length    Source
;*                               0            0    24 bits active power signal (output of LPF2)
;*                               0            1    Reserved
;*                               1            0    24 bits Channel 1
;*                               1            1    24 bits Channel 2
;* 15    POAM            0            Writing Logic 1 to this bit allows only positive active power to be accumulated in  ...
;*
;*
;* @param none
;* @return int with the data (16 bits unsigned).
;*/
;void ADE7753_setMode(int m){
; 0001 00D0 void ADE7753_setMode(int m){
; 0001 00D1     ADE7753_write16(MODE, m);
;	m -> Y+0
; 0001 00D2 }
;int ADE7753_getMode(){
; 0001 00D3 int ADE7753_getMode(){
; 0001 00D4     return ADE7753_read16(MODE);
; 0001 00D5 }
;
;/* The IRQ Interrupt Request pin of the ADE7753 on the Olimex Energy Shield is not wired
;to the Arduino board, so need to poll to service the interrupts.
;See board spec and wiring diagram at:
;http://www.olimex.cl/product_info.php?products_id=797&product__name=Arduino_Energy_Shield
;http://www.olimex.cl/pdf/Main_Sch.pdf
;*/
;
;/** === getInterrupts / setInterrupts
;* ADE7753 interrupts can be deactivated at any time by setting the corresponding
;* bit in this 16-bit enable register to Logic 0. The status register continues
;* to register an interrupt event even if disabled. However, the IRQ output is not activated.
;
;* The next table summarizes the function of each bit in this register:
;*
;* BitLocation / Interrupt Flag / Description
;* 0    AEHF        Indicates that an interrupt occurred because the active energy register, AENERGY, is more than half f ...
;* 1    SAG            Indicates that an interrupt was caused by a SAG on the line voltage.
;* 2    CYCEND        Indicates the end of energy accumulation over an integer number of half line cycles as defined by t ...
;* 3    WSMP        Indicates that new data is present in the waveform register.
;* 4    ZX            This status bit is set to Logic 0 on the rising and falling edge of the the voltage waveform. See t ...
;* 5    TEMP        Indicates that a temperature conversion result is available in the temperature register.
;* 6    RESET        Indicates the end of a reset (for both software or hardware reset). The corresponding enable bit has ...
;* 7    AEOF        Indicates that the active energy register has overflowed.
;* 8    PKV            Indicates that waveform sample from Channel 2 has exceeded the VPKLVL value.
;* 9    PKI            Indicates that waveform sample from Channel 1 has exceeded the IPKLVL value.
;* 10    VAEHF        Indicates that an interrupt occurred because the active energy register, VAENERGY, is more than hal ...
;* 11    VAEOF        Indicates that the apparent energy register has overflowed.
;* 12    ZXTO        Indicates that an interrupt was caused by a missing zero crossing on the line voltage for the specif ...
;* 13    PPOS        Indicates that the power has gone from negative to positive.
;* 14    PNEG        Indicates that the power has gone from positive to negative.
;* 15    RESERVED    Reserved.
;*
;//Register address
;    IRQEN     0x0A  // interrupts enable register
;    STATUS    0x0B  // interrupts status register
;    RSTSTATUS 0x0C  // interrupts status register but read will reset all interrupt flags
;
;* @param none
;* @return int with the data (16 bits unsigned).
;*/
;int ADE7753_getEnabledInterrupts(void){
; 0001 00FF int ADE7753_getEnabledInterrupts(void){
; 0001 0100     return ADE7753_read16(IRQEN);
; 0001 0101 }
;
;/** === getStatus ===
;* This is an 16-bit read-only register. The status register contains information regarding the source of ADE7753 interru ...
;* @param none
;* @return int with the data (16 bits unsigned).
;*/
;int ADE7753_getInterruptStatus(void){
; 0001 0108 int ADE7753_getInterruptStatus(void){
_ADE7753_getInterruptStatus:
; .FSTART _ADE7753_getInterruptStatus
; 0001 0109     return ADE7753_read16(STATUS);
	LDI  R26,LOW(11)
	RJMP _0x2080005
; 0001 010A }
; .FEND
;
;/** === resetStatus ==
;* Same as the interrupt status register except that the register contents are reset to 0 (all flags cleared) after a rea ...
;* @param none
;* @return int with the data (16 bits unsigned).
;*/
;int ADE7753_getresetInterruptStatus(void){
; 0001 0111 int ADE7753_getresetInterruptStatus(void){
_ADE7753_getresetInterruptStatus:
; .FSTART _ADE7753_getresetInterruptStatus
; 0001 0112     return ADE7753_read16(RSTSTATUS);
	LDI  R26,LOW(12)
	RJMP _0x2080005
; 0001 0113 }
; .FEND
;/** (1) === getActiveEnergyLineSync ===
;* The instantaneous active power is accumulated in this read-only register over
;* the LINECYC number of half line cycles.
;* Used in combination with CYCEND Interrupt Flag and with LINECYC register (nbr of half-cycles)
;* >>> This is the prefered method The advantage of summing the active energy over an integer number
;*     of line cycles is that the sinusoidal component in the active energy is reduced to 0.
;*     This eliminates any ripple in the energy calculation. Energy is calculated more
;*     accurately and in a shorter time because the integration period can be shortened.
;* @param none
;* @return long with the data (24 bits 2-complement signed).
;*/
;long ADE7753_getActiveEnergyLineSync(void){
; 0001 011F long ADE7753_getActiveEnergyLineSync(void){
; 0001 0120     return ADE7753_read24(LAENERGY);
; 0001 0121 }
;
;/** (2) === getApparentEnergyLineSync ===
;* The instantaneous real power is accumulated in this read-only register over
;* the LINECYC number of half line cycles.
;* >>> This is the prefered method The advantage of summing the active energy over an integer number
;*     of line cycles is that the sinusoidal component in the active energy is reduced to 0.
;*     This eliminates any ripple in the energy calculation. Energy is calculated more
;*     accurately and in a shorter time because the integration period can be shortened.
;* @param none
;* @return long with the data (24 bits unsigned).
;*/
;long ADE7753_getApparentEnergyLineSync(void){
; 0001 012D long ADE7753_getApparentEnergyLineSync(void){
; 0001 012E     return ADE7753_read24(LVAENERGY);
; 0001 012F }
;
;/** (3) === getReactiveEnergyLineSync ===
;* The instantaneous reactive power is accumulated in this read-only register over
;* the LINECYC number of half line cycles.
;* >>> This is the prefered method The advantage of summing the active energy over an integer number
;*     of line cycles is that the sinusoidal component in the active energy is reduced to 0.
;*     This eliminates any ripple in the energy calculation. Energy is calculated more
;*     accurately and in a shorter time because the integration period can be shortened.
;* @param none
;* @return long with the data (24 bits 2-complement signed).
;*/
;long ADE7753_getReactiveEnergyLineSync(void){
; 0001 013B long ADE7753_getReactiveEnergyLineSync(void){
; 0001 013C     return ADE7753_read24(LVARENERGY);
; 0001 013D }
;
;/** === getIRMS ===
;* Channel 2 RMS Value (Current Channel).
;* The update rate of the Channel 2 rms measurement is CLKIN/4.
;* To minimize noise, synchronize the reading of the rms register with the zero crossing
;* of the voltage input and take the average of a number of readings.
;* @param none
;* @return long with the data (24 bits unsigned).
;*/
;long ADE7753_getIRMS(void){
; 0001 0147 long ADE7753_getIRMS(void){
_ADE7753_getIRMS:
; .FSTART _ADE7753_getIRMS
; 0001 0148     long vv;
; 0001 0149     //char zero;
; 0001 014A     ADE7753_getresetInterruptStatus(); // Clear all interrupts
	SBIW R28,4
;	vv -> Y+0
	RCALL _ADE7753_getresetInterruptStatus
; 0001 014B //    zero=PIND.3;
; 0001 014C //    while(PIND.3 == zero);
; 0001 014D     vv=0;
	LDI  R30,LOW(0)
	RCALL __CLRD1S0
; 0001 014E     while( !  ( ADE7753_getInterruptStatus() & ZX )  )   // wait Zero-Crossing
_0x20007:
	RCALL _ADE7753_getInterruptStatus
	ANDI R30,LOW(0x10)
	BRNE _0x20009
; 0001 014F     { // wait for the selected interrupt to occur
; 0001 0150         if ( vv > 200)
	RCALL __GETD2S0
	__CPD2N 0xC9
	BRGE _0x20009
; 0001 0151         {
; 0001 0152             //printf("no AC");
; 0001 0153             break;
; 0001 0154         }
; 0001 0155         vv++;
	RCALL __GETD1S0
	__SUBD1N -1
	RCALL __PUTD1S0
; 0001 0156     }
	RJMP _0x20007
_0x20009:
; 0001 0157     return ADE7753_read24(IRMS);
	LDI  R26,LOW(22)
	RCALL _ADE7753_read24
	RJMP _0x2080004
; 0001 0158 }
; .FEND
;
;/** === getVRMS ===
;* Channel 1 RMS Value (Voltage Channel).
;* The update rate of the Channel 1 rms measurement is CLKIN/4.
;* To minimize noise, synchronize the reading of the rms register with the zero crossing
;* of the voltage input and take the average of a number of readings.
;* @param none
;* @return long with the data (24 bits unsigned).
;*/
;long int ADE7753_getVRMS(void){
; 0001 0162 long int ADE7753_getVRMS(void){
_ADE7753_getVRMS:
; .FSTART _ADE7753_getVRMS
; 0001 0163 
; 0001 0164     int ww=0;
; 0001 0165     //char zero;
; 0001 0166     ADE7753_getresetInterruptStatus(); // Clear all interrupts
	RCALL __SAVELOCR2
;	ww -> R16,R17
	__GETWRN 16,17,0
	RCALL _ADE7753_getresetInterruptStatus
; 0001 0167     while( !  ( ADE7753_getInterruptStatus() & ZX )  )   // wait Zero-Crossing
_0x2000B:
	RCALL _ADE7753_getInterruptStatus
	ANDI R30,LOW(0x10)
	BRNE _0x2000D
; 0001 0168     { // wait for the selected interrupt to occur
; 0001 0169         if ( ww > 200)
	__CPWRN 16,17,201
	BRGE _0x2000D
; 0001 016A         {
; 0001 016B             //printf("No AC");
; 0001 016C             break;
; 0001 016D         }
; 0001 016E         ww++;
	__ADDWRN 16,17,1
; 0001 016F     }
	RJMP _0x2000B
_0x2000D:
; 0001 0170     //PORTC.5=1;
; 0001 0171     //printf("ww:%d",ww);
; 0001 0172     return ADE7753_read24(VRMS);
	LDI  R26,LOW(23)
	RCALL _ADE7753_read24
	LD   R16,Y+
	LD   R17,Y+
	RET
; 0001 0173 }
; .FEND
;
;/** === vrms ===
;* Returns the mean of last 100 readings of RMS voltage. Also supress first reading to avoid
;* corrupted data.
;* rms measurement update rate is CLKIN/4.
;* To minimize noise, synchronize the reading of the rms register with the zero crossing
;* of the voltage input and take the average of a number of readings.
;* @param none
;* @return long with RMS voltage value
;*/
;long int ADE7753_vrms(){
; 0001 017E long int ADE7753_vrms(){
_ADE7753_vrms:
; .FSTART _ADE7753_vrms
; 0001 017F     char i=0;
; 0001 0180     long int v=0;
; 0001 0181     ADE7753_getVRMS();//Ignore first reading to avoid garbage
	RCALL SUBOPT_0xE
;	i -> R17
;	v -> Y+1
	RCALL _ADE7753_getVRMS
; 0001 0182     for(i=0;i<10;++i){
	LDI  R17,LOW(0)
_0x20010:
	CPI  R17,10
	BRSH _0x20011
; 0001 0183         v+=ADE7753_getVRMS();
	RCALL _ADE7753_getVRMS
	RCALL SUBOPT_0xF
; 0001 0184     }
	SUBI R17,-LOW(1)
	RJMP _0x20010
_0x20011:
; 0001 0185     return (long int)(v/10);
	RJMP _0x2080007
; 0001 0186 }
; .FEND
;
;/** === irms ===
;* Returns the mean of last 100 readings of RMS current. Also supress first reading to avoid
;* corrupted data.
;* rms measurement update rate is CLKIN/4.
;* To minimize noise, synchronize the reading of the rms register with the zero crossing
;* of the voltage input and take the average of a number of readings.
;* @param none
;* @return long with RMS current value in hundreds of [mA], ie. 6709=67[mA]
;*/
;long ADE7753_irms(){
; 0001 0191 long ADE7753_irms(){
_ADE7753_irms:
; .FSTART _ADE7753_irms
; 0001 0192     char n=0;
; 0001 0193     long i=0;
; 0001 0194     ADE7753_getIRMS();//Ignore first reading to avoid garbage
	RCALL SUBOPT_0xE
;	n -> R17
;	i -> Y+1
	RCALL _ADE7753_getIRMS
; 0001 0195     for(n=0;n<10;++n){
	LDI  R17,LOW(0)
_0x20013:
	CPI  R17,10
	BRSH _0x20014
; 0001 0196         i+=ADE7753_getIRMS();
	RCALL _ADE7753_getIRMS
	RCALL SUBOPT_0xF
; 0001 0197     }
	SUBI R17,-LOW(1)
	RJMP _0x20013
_0x20014:
; 0001 0198     return i/10;
_0x2080007:
	__GETD2S 1
	__GETD1N 0xA
	RCALL __DIVD21
	LDD  R17,Y+0
_0x2080008:
	ADIW R28,5
	RET
; 0001 0199 }
; .FEND
;
;/** === getWaveform ===
;* This read-only register contains the sampled waveform data from either Channel 1,
;* Channel 2, or the active power signal. The data source and the length of the waveform
;* registers are selected by data Bits 14 and 13 in the mode register.
;* - Max sampling CLKIN/128 = 3.579545 MHz / 128 = 27.9 kSPS
;* - Bandwidth 14 kHz
;* - one of four output sample rates can be chosen by using Bits 11 and 12
;*   of the mode register (WAVSEL1,0). The output sample rate
;*   can be 27.9 kSPS, 14 kSPS, 7 kSPS, or 3.5 kSPS
;* - arrivals of new waveform samples after each read is indicated by interrupt
;*   request IRQ, but unfortunatly IRQ is not wired in the Olimex Energy Shield
;* - The interrupt request output, IRQ, signals a new sample
;*   availability by going active low.
;* - In waveform sampling mode, the WSMP bit (Bit 3) in the
;*   interrupt enable register must also be set to Logic 1.
;* - The interrupt request output IRQ stays low until the interrupt
;*   routine reads the reset status register.
;* - Interrupt Flag WSMP (bit location 3) in the Interrupt Status Register
;*   indicates that new data is present in the waveform register.
;*   Therefore arrival of new waveform samples may be indicated by polling
;*   this flag and then reading the 24-bit waveform register
;*   --- we use this polling method for Arduino/Nanode ---
;* - When acquiring waveform data, disable low pass filter in order to
;*   obtain and view all the high harmoniques
;* @param none
;* @return long with the data (24 bits 2-complement signed).
;*/
;long ADE7753_getWaveform(void){  // this function will have to be rewritten for allowing rapid polling
; 0001 01B6 long ADE7753_getWaveform(void){
; 0001 01B7     // of WSMP flag in ISR and getting rapid Waveform data over 1 full cycle
; 0001 01B8     // and storing to Arduino tiny RAM
; 0001 01B9     return ADE7753_read24(WAVEFORM);
; 0001 01BA }
;
;/** === getIpeakReset ===
;* Same as Channel 1 Peak Register except that the register contents are reset to 0 after read.
;* @param none
;* @return long with the data (24 bits 24 bits unsigned).
;*/
;long ADE7753_getIpeakReset(void){
; 0001 01C1 long ADE7753_getIpeakReset(void){
_ADE7753_getIpeakReset:
; .FSTART _ADE7753_getIpeakReset
; 0001 01C2     return ADE7753_read24(RSTIPEAK);
	LDI  R26,LOW(35)
	RJMP _0x2080006
; 0001 01C3 }
; .FEND
;
;/** === getVpeakReset ===
;* Same as Channel 2 Peak Register except that the register contents are reset to 0 after a read.
;* @param none
;* @return long with the data (24 bits  unsigned).
;*/
;long ADE7753_getVpeakReset(void){
; 0001 01CA long ADE7753_getVpeakReset(void){
_ADE7753_getVpeakReset:
; .FSTART _ADE7753_getVpeakReset
; 0001 01CB     return ADE7753_read24(RSTVPEAK);
	LDI  R26,LOW(37)
_0x2080006:
	RCALL _ADE7753_read24
	RET
; 0001 01CC }
; .FEND
;
;/** === getPeriod ===
;* Period of the Channel 2 (Voltage Channel) Input Estimated by Zero-Crossing Processing.
;* The ADE7753 provides the period measurement of the grid line.
;* The period register is an unsigned 16-bit register and is updated every period.
;* The MSB of this register is always zero.
;* The resolution of this register is 2.2 Î¼s/LSB when CLKIN = 3.579545 MHz,
;* which represents 0.013% when the line fre-quency is 60 Hz.
;* When the line frequency is 60 Hz, the value of the period register is
;* approximately CLKIN/4/32/60 Hz x16 = 7457d.
;* The length of the register enables the measurement of line frequencies as low as 13.9 Hz.
;* @param none
;* @return int with the data (16 bits unsigned).
;*/
;int ADE7753_getPeriod(void){
; 0001 01DB int ADE7753_getPeriod(void){
_ADE7753_getPeriod:
; .FSTART _ADE7753_getPeriod
; 0001 01DC     return ADE7753_read16(PERIOD);
	LDI  R26,LOW(39)
_0x2080005:
	RCALL _ADE7753_read16
	RET
; 0001 01DD }
; .FEND
;
;/** === getTemp ===
;* Force a temperature measure and then returns it. This is done by setting bit 5 HIGH in MODE register.
;* Temperature measuring can't be calibrated, the values used in this function are according to the datasheet
;* (register TEMP is 0x00 at -25 celsius degrees).
;*  The contents of the temperature register are signed (twos complement) with a resolution of
;* approximately 1.5 LSB/ °C. The temperature register produces a code of 0x00 when the ambient
;* temperature is approximately -25°C. The temperature measurement is uncalibrated in the ADE7753
;* and has an offset tolerance as high as ±25 °C.
;* @param none
;* @return char with the temperature in celsius degrees.
;*/
;char ADE7753_getTemp(){
; 0001 01EA char ADE7753_getTemp(){
; 0001 01EB     unsigned int tt;
; 0001 01EC     unsigned char r=0;
; 0001 01ED     long lastMode = 0;
; 0001 01EE     //char zero;
; 0001 01EF 
; 0001 01F0     //zero=PIND.3;// Connect ZX pin on ADE7753 to pin   PIND.3 on MCU
; 0001 01F1     //while(PIND.3 == zero);// wait Zero-Crossing
; 0001 01F2 
; 0001 01F3     lastMode = ADE7753_getMode();
;	tt -> R16,R17
;	r -> R19
;	lastMode -> Y+4
; 0001 01F4     //Temp measure
; 0001 01F5     ADE7753_setMode(TEMPSEL);
; 0001 01F6     ADE7753_getresetInterruptStatus(); // Clear all interrupts
; 0001 01F7     tt=0;
; 0001 01F8 while( ! ( ADE7753_getInterruptStatus() & TEMPREADY ) ) // wait for Temperature measurement to be ready
; 0001 01F9     { // wait for the selected interrupt to occur
; 0001 01FA         if ( tt > 1000)
; 0001 01FB         {
; 0001 01FC              printf("0 AC");
; 0001 01FD             ADE7753_getresetInterruptStatus(); // Clear all interrupts
; 0001 01FE             break;
; 0001 01FF         }
; 0001 0200     }
; 0001 0201     //Read register
; 0001 0202     r= ADE7753_read8(TEMP);
; 0001 0203 
; 0001 0204     //    // Do it twice to make sure
; 0001 0205     //Read register
; 0001 0206     r= ADE7753_read8(TEMP);
; 0001 0207 
; 0001 0208     // Set to the previous mode
; 0001 0209     ADE7753_setMode (lastMode);
; 0001 020A     return (1806*r-25000)/1000;
; 0001 020B     //return r;
; 0001 020C }
;
;// Functions for manual setting of calibrations
;
;/** === energySetup ===
;* @param
;* @param
;*/
;void ADE7753_energySetup(int wgain, char wdiv, int apos, int vagain, char vadiv, char phcal){
; 0001 0214 void ADE7753_energySetup(int wgain, char wdiv, int apos, int vagain, char vadiv, char phcal){
; 0001 0215     ADE7753_write16(WGAIN,wgain);
;	wgain -> Y+7
;	wdiv -> Y+6
;	apos -> Y+4
;	vagain -> Y+2
;	vadiv -> Y+1
;	phcal -> Y+0
; 0001 0216     ADE7753_write8(WDIV,wdiv);
; 0001 0217     ADE7753_write16(APOS,apos);
; 0001 0218     ADE7753_write16(VAGAIN,vagain);
; 0001 0219     ADE7753_write8(VADIV,vadiv);
; 0001 021A     ADE7753_write8(PHCAL,phcal);
; 0001 021B }
;
;
;/** === frequencySetup ===
;* The output frequency on the CF pin is adjusted by writing to this 12-bit
;* read/write registerâ€”see the Energy-to-Frequency Conversion section.
;* @param cfnum: integer containing number (12 bits available unsigned. ie range=[0,4095])
;* @param cfden: the same as cfnum
;*/
;void ADE7753_frequencySetup(int cfnum, int cfden){
; 0001 0224 void ADE7753_frequencySetup(int cfnum, int cfden){
; 0001 0225     ADE7753_write16(CFNUM,cfnum);
;	cfnum -> Y+2
;	cfden -> Y+0
; 0001 0226     ADE7753_write16(CFDEN,cfden);
; 0001 0227 }
;
;/** === analogSetup ===
;* This 8-bit register is used to adjust the gain selection for the PGA in Channels 1 and 2
;* @param gain_ch1 char set the PGA channel 1 gain, use constants GAIN_1, GAIN_2, GAIN_4, GAIN_8 and gain_16
;* @param gain_ch2 char set the PGA channel 2 gain, use constants GAIN_1, GAIN_2, GAIN_4, GAIN_8 and gain_16
;* @param os_ch1 char set channel 1 analog offset, range : [-32,32]
;* @param os_ch2 char set channel 1 analog offset, range : [-32,32]
;* @param scale_ch1 char
;* @param integrator_ch1 char
;* @return char with the data (8 bits unsigned).
;*/
;void ADE7753_analogSetup(int gain_ch1, int gain_ch2,int os_ch1,int os_ch2,int scale_ch1,int integrator_ch1){
; 0001 0233 void ADE7753_analogSetup(int gain_ch1, int gain_ch2,int os_ch1,int os_ch2,int scale_ch1,int integrator_ch1){
_ADE7753_analogSetup:
; .FSTART _ADE7753_analogSetup
; 0001 0234     unsigned char pga = (gain_ch2<<5) | (scale_ch1<<3) | (gain_ch1); //format is |3 bits PGA2 gain|2 bits full scale|3 b ...
; 0001 0235     int sign = 0;
; 0001 0236     int ch1os = 0, ch2os = 0;
; 0001 0237 
; 0001 0238 
; 0001 0239     ADE7753_write8(GAIN,pga);//write GAIN register, format is |3 bits PGA2 gain|2 bits full scale|3 bits PGA1 gain
	RCALL SUBOPT_0xD
	SBIW R28,2
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	RCALL __SAVELOCR6
;	gain_ch1 -> Y+18
;	gain_ch2 -> Y+16
;	os_ch1 -> Y+14
;	os_ch2 -> Y+12
;	scale_ch1 -> Y+10
;	integrator_ch1 -> Y+8
;	pga -> R17
;	sign -> R18,R19
;	ch1os -> R20,R21
;	ch2os -> Y+6
	LDD  R30,Y+16
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	MOV  R26,R30
	LDD  R30,Y+10
	LSL  R30
	LSL  R30
	LSL  R30
	OR   R30,R26
	LDD  R26,Y+18
	OR   R30,R26
	MOV  R17,R30
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	LDI  R30,LOW(15)
	ST   -Y,R30
	MOV  R26,R17
	RCALL _ADE7753_write8
; 0001 023A 
; 0001 023B     // CH1OS: ch1 offset 6-bit, sign magnitude on Bit-5 then integrator on Bit-7
; 0001 023C     // Refer to spec Page 58 Table 16
; 0001 023D     if(os_ch1<0){
	LDD  R26,Y+15
	TST  R26
	BRPL _0x20019
; 0001 023E         sign=1;
	__GETWRN 18,19,1
; 0001 023F         os_ch1=-os_ch1;
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	RCALL __ANEGW1
	STD  Y+14,R30
	STD  Y+14+1,R31
; 0001 0240     } else{ sign=0; }
	RJMP _0x2001A
_0x20019:
	__GETWRN 18,19,0
_0x2001A:
; 0001 0241     ch1os = (integrator_ch1<<7) | (sign<<5) | os_ch1;
	RCALL SUBOPT_0x10
	LDI  R30,LOW(7)
	RCALL __LSLW12
	MOVW R22,R30
	MOVW R26,R18
	LDI  R30,LOW(5)
	RCALL __LSLW12
	OR   R30,R22
	OR   R31,R23
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	OR   R30,R26
	OR   R31,R27
	MOVW R20,R30
; 0001 0242     ADE7753_write8(CH1OS,ch1os);
	LDI  R30,LOW(13)
	ST   -Y,R30
	MOV  R26,R20
	RCALL _ADE7753_write8
; 0001 0243 
; 0001 0244     // CH2OS: ch2 offset, sign magnitude (ch2 doesn't have integrator) and the offset applied is inverted (ie offset of  ...
; 0001 0245     if(os_ch2<0){
	LDD  R26,Y+13
	TST  R26
	BRPL _0x2001B
; 0001 0246         sign=1;
	__GETWRN 18,19,1
; 0001 0247         os_ch2=-os_ch2;
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	RCALL __ANEGW1
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0001 0248     } else{ sign=0; }
	RJMP _0x2001C
_0x2001B:
	__GETWRN 18,19,0
_0x2001C:
; 0001 0249     ch2os = (sign<<5) | os_ch2;
	MOVW R26,R18
	LDI  R30,LOW(5)
	RCALL __LSLW12
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	OR   R30,R26
	OR   R31,R27
	RCALL SUBOPT_0x11
; 0001 024A     ADE7753_write8(CH2OS,ch2os);
	LDI  R30,LOW(14)
	ST   -Y,R30
	LDD  R26,Y+7
	RCALL _ADE7753_write8
; 0001 024B }
	RJMP _0x2080002
; .FEND
;
;/** === rmsSetup ===
;**/
;void ADE7753_rmsSetup(int irmsos, int vrmsos){
; 0001 024F void ADE7753_rmsSetup(int irmsos, int vrmsos){
_ADE7753_rmsSetup:
; .FSTART _ADE7753_rmsSetup
; 0001 0250     ADE7753_write16(VRMSOS,vrmsos);
	RCALL SUBOPT_0xD
;	irmsos -> Y+2
;	vrmsos -> Y+0
	LDI  R30,LOW(25)
	ST   -Y,R30
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	RCALL _ADE7753_write16
; 0001 0251     ADE7753_write16(IRMSOS,irmsos);
	LDI  R30,LOW(24)
	ST   -Y,R30
	LDD  R26,Y+3
	LDD  R27,Y+3+1
	RCALL _ADE7753_write16
; 0001 0252 }
_0x2080004:
	ADIW R28,4
	RET
; .FEND
;
;void ADE7753_miscSetup(int zxtout, char sagsyc, char saglvl, char ipklvl, char vpklvl, char tmode){
; 0001 0254 void ADE7753_miscSetup(int zxtout, char sagsyc, char saglvl, char ipklvl, char vpklvl, char tmode){
; 0001 0255     // ZXTOUT 12-bit (U) - Zero-Crossing Timeout
; 0001 0256     // SAGCYC  8-bit (U) - Sag Line Cycle Register.
; 0001 0257     // SAGLVL  8-bit (U) - Sag Voltage Level.
; 0001 0258     // IPKLVL  8-bit (U) - Channel 1 Peak Level Threshold
; 0001 0259     // VPKLVL  8-bit (U) - Channel 2 Peak Level Threshold
; 0001 025A     // TMODE   8-bit (U) - Test Mode Register
; 0001 025B     ADE7753_write16(ZXTOUT,zxtout);
;	zxtout -> Y+5
;	sagsyc -> Y+4
;	saglvl -> Y+3
;	ipklvl -> Y+2
;	vpklvl -> Y+1
;	tmode -> Y+0
; 0001 025C     ADE7753_write8(SAGCYC,sagsyc);
; 0001 025D     ADE7753_write8(SAGLVL,saglvl);
; 0001 025E     ADE7753_write8(IPKLVL,ipklvl);
; 0001 025F     ADE7753_write8(VPKLVL,vpklvl);
; 0001 0260     ADE7753_write8(TMODE,tmode);
; 0001 0261 }
;
;void ADE7753_setInterruptsMask(int Mask16){
; 0001 0263 void ADE7753_setInterruptsMask(int Mask16){
; 0001 0264     ADE7753_write16(IRQEN, Mask16);
;	Mask16 -> Y+0
; 0001 0265 }
;
;void ADE7753_setLineCyc(int d){
; 0001 0267 void ADE7753_setLineCyc(int d){
; 0001 0268     ADE7753_write16(LINECYC,d);
;	d -> Y+0
; 0001 0269 }
;
;/** === printGetResetInterruptStatus ===
;* used for code verification et debugging
;*/
;void ADE7753_printGetResetInterruptStatus(void){
; 0001 026E void ADE7753_printGetResetInterruptStatus(void){
; 0001 026F 
; 0001 0270     //int InterruptMask;
; 0001 0271 
; 0001 0272     //printf("Interrupt Status (binary): ");
; 0001 0273     //InterruptMask = ADE7753_getresetInterruptStatus();
; 0001 0274 }
;
;
;
;/** === chkSum ===
;* Checksum Register. This 6-bit read-only register is equal to the sum of all the ones in the previous read.
;* see the ADE7753 Serial Read Operation section.
;* @param none
;* @return char with the data (6 bits unsigned).
;*/
;char ADE7753_chkSum(){
; 0001 027E char ADE7753_chkSum(){
; 0001 027F     return ADE7753_read8(CHKSUM);
; 0001 0280 }
;
;/** === getActiveEnergy ===
;* Active power is accumulated (integrated) over time in this 24-bit, read-only register
;* @param none
;* @return long with the data (24 bits 2-complement signed).
;*/
;long ADE7753_getActiveEnergy(void){
; 0001 0287 long ADE7753_getActiveEnergy(void){
; 0001 0288     return ADE7753_read24(AENERGY);
; 0001 0289 }
;
;/** === getActiveEnergyReset ===
;* Same as the active energy register except that the register is reset to 0 following a read operation.
;* @param none
;* @return long with the data (24 bits 2-complement signed).
;*/
;long ADE7753_getActiveEnergyReset(void){
; 0001 0290 long ADE7753_getActiveEnergyReset(void){
; 0001 0291     return ADE7753_read24(RAENERGY);
; 0001 0292 }
;
;/** === getApparentEnergy ===
;* Apparent Energy Register. Apparent power is accumulated over time in this read-only register.
;* @param none
;* @return long with the data (24 bits unsigned).
;*/
;long ADE7753_getApparentEnergy(void){
; 0001 0299 long ADE7753_getApparentEnergy(void){
; 0001 029A     return ADE7753_read24(VAENERGY);
; 0001 029B }
;
;/** === getApparentEnergyReset ===
;* Same as the VAENERGY register except that the register is reset to 0 following a read operation.
;* @param none
;* @return long with the data (24 bits unsigned).
;*/
;long ADE7753_getApparentEnergyReset(void){
; 0001 02A2 long ADE7753_getApparentEnergyReset(void){
; 0001 02A3     return ADE7753_read24(RVAENERGY);
; 0001 02A4 }
;
;/** === getCurrentOffset ===
;* Channel 2 RMS Offset Correction Register.
;* @param none
;* @return int with the data (12 bits 2-complement signed).
;*/
;int ADE7753_getCurrentOffset(){
; 0001 02AB int ADE7753_getCurrentOffset(){
; 0001 02AC     return ADE7753_read16(IRMSOS);
; 0001 02AD }
;
;/** === getVoltageOffset ===
;* Channel 2 RMS Offset Correction Register.
;*
;* @param none
;* @return int with the data (12 bits 2-complement's signed).
;*/
;int ADE7753_getVoltageOffset(){
; 0001 02B5 int ADE7753_getVoltageOffset(){
; 0001 02B6     return ADE7753_read16(VRMSOS);
; 0001 02B7 }
;
;/** === setZeroCrossingTimeout / getZeroCrossingTimeout ===
;* Zero-Crossing Timeout. If no zero crossings are detected
;* on Channel 2 within a time period specified by this 12-bit register,
;* the interrupt request line (IRQ) is activated
;* @param none
;* @return int with the data (12 bits unsigned).
;*/
;void ADE7753_setZeroCrossingTimeout(int d){
; 0001 02C0 void ADE7753_setZeroCrossingTimeout(int d){
; 0001 02C1     ADE7753_write16(ZXTOUT,d);
;	d -> Y+0
; 0001 02C2 }
;int ADE7753_getZeroCrossingTimeout(){
; 0001 02C3 int ADE7753_getZeroCrossingTimeout(){
; 0001 02C4     return ADE7753_read16(ZXTOUT);
; 0001 02C5 }
;
;/** === getSagCycles / setSagCycles ===
;* Sag Line Cycle Register. This 8-bit register specifies the number of
;* consecutive line cycles the signal on Channel 2 must be below SAGLVL
;* before the SAG output is activated.
;* @param none
;* @return char with the data (8 bits unsigned).
;*/
;char ADE7753_getSagCycles(){
; 0001 02CE char ADE7753_getSagCycles(){
; 0001 02CF     return ADE7753_read8(SAGCYC);
; 0001 02D0 }
;void ADE7753_setSagCycles(char d){
; 0001 02D1 void ADE7753_setSagCycles(char d){
; 0001 02D2     ADE7753_write8(SAGCYC,d);
;	d -> Y+0
; 0001 02D3 }
;
;/** === getLineCyc / setLineCyc ===
;* Line Cycle Energy Accumulation Mode Line-Cycle Register.
;* This 16-bit register is used during line cycle energy accumulation mode
;* to set the number of half line cycles for energy accumulation
;* @param none
;* @return int with the data (16 bits unsigned).
;*/
;int ADE7753_getLineCyc(){
; 0001 02DC int ADE7753_getLineCyc(){
; 0001 02DD     return ADE7753_read16(LINECYC);
; 0001 02DE }
;
;
;/** === getSagVoltageLevel / setSagVoltageLevel ===
;* Sag Voltage Level. An 8-bit write to this register determines at what peak
;* signal level on Channel 2 the SAG pin becomes active. The signal must remain
;* low for the number of cycles specified in the SAGCYC register before the SAG pin is activated
;* @param none
;* @return char with the data (8 bits unsigned).
;*/
;char ADE7753_getSagVoltageLevel(){
; 0001 02E8 char ADE7753_getSagVoltageLevel(){
; 0001 02E9     return ADE7753_read8(SAGLVL);
; 0001 02EA }
;void ADE7753_setSagVoltageLevel(char d){
; 0001 02EB void ADE7753_setSagVoltageLevel(char d){
; 0001 02EC     ADE7753_write8(SAGLVL,d);
;	d -> Y+0
; 0001 02ED }
;
;/** === getIPeakLevel / setIPeakLevel ===
;* Channel 1 Peak Level Threshold (Current Channel). This register sets the level of the current
;* peak detection. If the Channel 1 input exceeds this level, the PKI flag in the status register is set.
;* @param none
;* @return char with the data (8 bits unsigned).
;*/
;char ADE7753_getIPeakLevel(){
; 0001 02F5 char ADE7753_getIPeakLevel(){
; 0001 02F6     return ADE7753_read8(IPKLVL);
; 0001 02F7 }
;void ADE7753_setIPeakLevel(char d){
; 0001 02F8 void ADE7753_setIPeakLevel(char d){
; 0001 02F9     ADE7753_write8(IPKLVL,d);
;	d -> Y+0
; 0001 02FA }
;
;/** === getVPeakLevel / setVPeakLevel ===
;* Channel 2 Peak Level Threshold (Voltage Channel). This register sets the level of the
;* voltage peak detection. If the Channel 2 input exceeds this level,
;* the PKV flag in the status register is set.
;* @param none
;* @return char with the data (8bits unsigned).
;*/
;char ADE7753_getVPeakLevel(){
; 0001 0303 char ADE7753_getVPeakLevel(){
; 0001 0304     return ADE7753_read8(VPKLVL);
; 0001 0305 }
;void ADE7753_setVPeakLevel(char d){
; 0001 0306 void ADE7753_setVPeakLevel(char d){
; 0001 0307     ADE7753_write8(VPKLVL,d);
;	d -> Y+0
; 0001 0308 }
;
;/** === getVpeak ===
;* Channel 2 Peak Register. The maximum input value of the voltage channel since the last read of the register is stored  ...
;* @param none
;* @return long with the data (24 bits unsigned).
;*/
;long ADE7753_getVpeak(void){
; 0001 030F long ADE7753_getVpeak(void){
; 0001 0310     return ADE7753_read24(VPEAK);
; 0001 0311 }
;
;/** === getIpeak ===
;* Channel 1 Peak Register. The maximum input value of the current channel since the last read
;* of the register is stored in this register.
;* @param none
;* @return long with the data (24 bits unsigned) .
;*/
;long ADE7753_getIpeak(void){
; 0001 0319 long ADE7753_getIpeak(void){
; 0001 031A     return ADE7753_read24(IPEAK);
; 0001 031B }
;
;/** === energyGain ===
;* @param
;* @param
;*/
;void ADE7753_energyGain(int wgain, int vagain){
; 0001 0321 void ADE7753_energyGain(int wgain, int vagain){
; 0001 0322     ADE7753_write16(WGAIN,wgain);
;	wgain -> Y+2
;	vagain -> Y+0
; 0001 0323     ADE7753_write16(VAGAIN,vagain);
; 0001 0324 }
;
;
;/** === getLAENERGY ===
;* Accumulated Active Energy until a fixed number of semi cicles according to the LineCyc register.
;* @param none
;* @return long with the data (24 bits unsigned).
;*/
;
;long ADE7753_get_LAENERGY(void){
; 0001 032D long ADE7753_get_LAENERGY(void){
; 0001 032E 
; 0001 032F     long aux;
; 0001 0330     ADE7753_getresetInterruptStatus(); // Clear all interrupts
;	aux -> Y+0
; 0001 0331       while( !  ( ADE7753_getInterruptStatus() & CYCEND )  )   // wait Zero-Crossing
; 0001 0332     {}
; 0001 0333     aux=ADE7753_read24(LAENERGY);
; 0001 0334     return aux;
; 0001 0335 }
;
;long ADE7753_get_AENERGY(void){
; 0001 0337 long ADE7753_get_AENERGY(void){
; 0001 0338 
; 0001 0339     long aux;
; 0001 033A     ADE7753_getresetInterruptStatus(); // Clear all interrupts
;	aux -> Y+0
; 0001 033B       while( !  ( ADE7753_getInterruptStatus() & CYCEND )  );   // wait Zero-Crossing
; 0001 033C 
; 0001 033D     aux=ADE7753_read24(AENERGY);
; 0001 033E     return aux;
; 0001 033F }
;
;long ADE7753_get_LVAENERGY(void){
; 0001 0341 long ADE7753_get_LVAENERGY(void){
; 0001 0342 
; 0001 0343     long aux;
; 0001 0344     ADE7753_getresetInterruptStatus(); // Clear all interrupts
;	aux -> Y+0
; 0001 0345       while( !  ( ADE7753_getInterruptStatus() & CYCEND )  );   // wait Zero-Crossing
; 0001 0346 
; 0001 0347     aux=ADE7753_read24(LVAENERGY);
; 0001 0348     return aux;
; 0001 0349 }
;long ADE7753_get_LVARENERGY(void){
; 0001 034A long ADE7753_get_LVARENERGY(void){
; 0001 034B 
; 0001 034C     long aux;
; 0001 034D     ADE7753_getresetInterruptStatus(); // Clear all interrupts
;	aux -> Y+0
; 0001 034E       while( !  ( ADE7753_getInterruptStatus() & CYCEND )  );   // wait Zero-Crossing
; 0001 034F 
; 0001 0350     aux=ADE7753_read24(LVARENERGY);
; 0001 0351     return aux;
; 0001 0352 }
;void ADE7753_get_ENERGY(long e1,long e2)
; 0001 0354 {
; 0001 0355 
; 0001 0356     ADE7753_getresetInterruptStatus(); // Clear all interrupts
;	e1 -> Y+4
;	e2 -> Y+0
; 0001 0357       while( !  ( ADE7753_getInterruptStatus() & CYCEND )  );   // wait Zero-Crossing
; 0001 0358     e1=ADE7753_read24(LAENERGY);
; 0001 0359     e2=ADE7753_read24(LVAENERGY);
; 0001 035A 
; 0001 035B }
;
;
;
;
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG
_putchar:
; .FSTART _putchar
	ST   -Y,R26
_0x2000006:
	LDS  R30,192
	ANDI R30,LOW(0x20)
	BREQ _0x2000006
	LD   R30,Y
	STS  198,R30
	RJMP _0x2080001
; .FEND
_put_usart_G100:
; .FSTART _put_usart_G100
	RCALL SUBOPT_0xD
	LDD  R26,Y+2
	RCALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	RCALL SUBOPT_0x0
_0x2080003:
	ADIW R28,3
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	RCALL SUBOPT_0xD
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x200001C:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x200001E
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x2000022
	CPI  R18,37
	BRNE _0x2000023
	LDI  R17,LOW(1)
	RJMP _0x2000024
_0x2000023:
	RCALL SUBOPT_0x12
_0x2000024:
	RJMP _0x2000021
_0x2000022:
	CPI  R30,LOW(0x1)
	BRNE _0x2000025
	CPI  R18,37
	BRNE _0x2000026
	RCALL SUBOPT_0x12
	RJMP _0x20000D2
_0x2000026:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000027
	LDI  R16,LOW(1)
	RJMP _0x2000021
_0x2000027:
	CPI  R18,43
	BRNE _0x2000028
	LDI  R20,LOW(43)
	RJMP _0x2000021
_0x2000028:
	CPI  R18,32
	BRNE _0x2000029
	LDI  R20,LOW(32)
	RJMP _0x2000021
_0x2000029:
	RJMP _0x200002A
_0x2000025:
	CPI  R30,LOW(0x2)
	BRNE _0x200002B
_0x200002A:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x200002C
	ORI  R16,LOW(128)
	RJMP _0x2000021
_0x200002C:
	RJMP _0x200002D
_0x200002B:
	CPI  R30,LOW(0x3)
	BREQ PC+2
	RJMP _0x2000021
_0x200002D:
	CPI  R18,48
	BRLO _0x2000030
	CPI  R18,58
	BRLO _0x2000031
_0x2000030:
	RJMP _0x200002F
_0x2000031:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x2000021
_0x200002F:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2000035
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x13
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x15
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x73)
	BRNE _0x2000038
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x17
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2000039
_0x2000038:
	CPI  R30,LOW(0x70)
	BRNE _0x200003B
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x17
	RCALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000039:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x200003C
_0x200003B:
	CPI  R30,LOW(0x64)
	BREQ _0x200003F
	CPI  R30,LOW(0x69)
	BRNE _0x2000040
_0x200003F:
	ORI  R16,LOW(4)
	RJMP _0x2000041
_0x2000040:
	CPI  R30,LOW(0x75)
	BRNE _0x2000042
_0x2000041:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	RCALL SUBOPT_0x11
	LDI  R17,LOW(5)
	RJMP _0x2000043
_0x2000042:
	CPI  R30,LOW(0x58)
	BRNE _0x2000045
	ORI  R16,LOW(8)
	RJMP _0x2000046
_0x2000045:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x2000077
_0x2000046:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	RCALL SUBOPT_0x11
	LDI  R17,LOW(4)
_0x2000043:
	SBRS R16,2
	RJMP _0x2000048
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x18
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000049
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000049:
	CPI  R20,0
	BREQ _0x200004A
	SUBI R17,-LOW(1)
	RJMP _0x200004B
_0x200004A:
	ANDI R16,LOW(251)
_0x200004B:
	RJMP _0x200004C
_0x2000048:
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x18
_0x200004C:
_0x200003C:
	SBRC R16,0
	RJMP _0x200004D
_0x200004E:
	CP   R17,R21
	BRSH _0x2000050
	SBRS R16,7
	RJMP _0x2000051
	SBRS R16,2
	RJMP _0x2000052
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x2000053
_0x2000052:
	LDI  R18,LOW(48)
_0x2000053:
	RJMP _0x2000054
_0x2000051:
	LDI  R18,LOW(32)
_0x2000054:
	RCALL SUBOPT_0x12
	SUBI R21,LOW(1)
	RJMP _0x200004E
_0x2000050:
_0x200004D:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x2000055
_0x2000056:
	CPI  R19,0
	BREQ _0x2000058
	SBRS R16,3
	RJMP _0x2000059
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	RCALL SUBOPT_0x11
	RJMP _0x200005A
_0x2000059:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x200005A:
	RCALL SUBOPT_0x12
	CPI  R21,0
	BREQ _0x200005B
	SUBI R21,LOW(1)
_0x200005B:
	SUBI R19,LOW(1)
	RJMP _0x2000056
_0x2000058:
	RJMP _0x200005C
_0x2000055:
_0x200005E:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RCALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	RCALL SUBOPT_0x11
_0x2000060:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x2000062
	SUBI R18,-LOW(1)
	RCALL SUBOPT_0x10
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x2000060
_0x2000062:
	CPI  R18,58
	BRLO _0x2000063
	SBRS R16,3
	RJMP _0x2000064
	SUBI R18,-LOW(7)
	RJMP _0x2000065
_0x2000064:
	SUBI R18,-LOW(39)
_0x2000065:
_0x2000063:
	SBRC R16,4
	RJMP _0x2000067
	CPI  R18,49
	BRSH _0x2000069
	RCALL SUBOPT_0x10
	SBIW R26,1
	BRNE _0x2000068
_0x2000069:
	RJMP _0x20000D3
_0x2000068:
	CP   R21,R19
	BRLO _0x200006D
	SBRS R16,0
	RJMP _0x200006E
_0x200006D:
	RJMP _0x200006C
_0x200006E:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x200006F
	LDI  R18,LOW(48)
_0x20000D3:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2000070
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0x15
	CPI  R21,0
	BREQ _0x2000071
	SUBI R21,LOW(1)
_0x2000071:
_0x2000070:
_0x200006F:
_0x2000067:
	RCALL SUBOPT_0x12
	CPI  R21,0
	BREQ _0x2000072
	SUBI R21,LOW(1)
_0x2000072:
_0x200006C:
	SUBI R19,LOW(1)
	RCALL SUBOPT_0x10
	SBIW R26,2
	BRLO _0x200005F
	RJMP _0x200005E
_0x200005F:
_0x200005C:
	SBRS R16,0
	RJMP _0x2000073
_0x2000074:
	CPI  R21,0
	BREQ _0x2000076
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL SUBOPT_0x15
	RJMP _0x2000074
_0x2000076:
_0x2000073:
_0x2000077:
_0x2000036:
_0x20000D2:
	LDI  R17,LOW(0)
_0x2000021:
	RJMP _0x200001C
_0x200001E:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL __GETW1P
_0x2080002:
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
; .FEND
_printf:
; .FSTART _printf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR2
	MOVW R26,R28
	ADIW R26,4
	RCALL __ADDW2R15
	MOVW R16,R26
	LDI  R30,LOW(0)
	STD  Y+4,R30
	STD  Y+4+1,R30
	STD  Y+6,R30
	STD  Y+6+1,R30
	MOVW R26,R28
	ADIW R26,8
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0x2
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_usart_G100)
	LDI  R31,HIGH(_put_usart_G100)
	RCALL SUBOPT_0x2
	MOVW R26,R28
	ADIW R26,8
	RCALL __print_G100
	RCALL __LOADLOCR2
	ADIW R28,8
	POP  R15
	RET
; .FEND
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG
_spi:
; .FSTART _spi
	ST   -Y,R26
	LD   R30,Y
	OUT  0x2E,R30
_0x2020003:
	IN   R30,0x2D
	SBRS R30,7
	RJMP _0x2020003
	IN   R30,0x2E
_0x2080001:
	ADIW R28,1
	RET
; .FEND

	.CSEG

	.CSEG
_strlen:
; .FSTART _strlen
	RCALL SUBOPT_0xD
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
; .FEND
_strlenf:
; .FSTART _strlenf
	RCALL SUBOPT_0xD
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret
; .FEND

	.DSEG
_adc_data:
	.BYTE 0x10
_rx_buffer0:
	.BYTE 0x32
_time_to_check_ADE:
	.BYTE 0x2
_Irms:
	.BYTE 0x4
_Vpeak:
	.BYTE 0x4
_Ipeak:
	.BYTE 0x4
_Vrms:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	__PUTW1R 11,12
	CLR  R5
	LDI  R30,LOW(1)
	MOV  R7,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	RCALL SUBOPT_0x2
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4:
	RCALL _ADE7753_getVpeakReset
	STS  _Vpeak,R30
	STS  _Vpeak+1,R31
	STS  _Vpeak+2,R22
	STS  _Vpeak+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	STS  _adc_data,R30
	STS  _adc_data+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	RCALL _ADE7753_getPeriod
	__PUTW1MN _adc_data,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	RCALL _HexInCharToDec
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x9:
	RCALL __CWD1
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xA:
	RCALL _spi
	LDI  R26,LOW(0)
	RCALL _spi
	MOV  R17,R30
	LDI  R26,LOW(0)
	RCALL _spi
	MOV  R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	LDI  R31,0
	RCALL __CWD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	RCALL _spi
	MOV  R26,R17
	RCALL _spi
	RJMP _ADE7753_disableChip

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xD:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xE:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	ST   -Y,R17
	LDI  R17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xF:
	__GETD2S 1
	RCALL __ADDD12
	__PUTD1S 1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x11:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x12:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x14:
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x15:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	RCALL SUBOPT_0x13
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x17:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	RCALL __GETW1P
	RCALL SUBOPT_0x11
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	RCALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__ORD12:
	OR   R30,R26
	OR   R31,R27
	OR   R22,R24
	OR   R23,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSLW12R
__LSLW12L:
	LSL  R30
	ROL  R31
	DEC  R0
	BRNE __LSLW12L
__LSLW12R:
	RET

__LSLD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSLD12R
__LSLD12L:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R0
	BRNE __LSLD12L
__LSLD12R:
	RET

__LSLW4:
	LSL  R30
	ROL  R31
__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__LSLD16:
	MOV  R22,R30
	MOV  R23,R31
	LDI  R30,0
	LDI  R31,0
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__DIVD21:
	RCALL __CHKSIGND
	RCALL __DIVD21U
	BRTC __DIVD211
	RCALL __ANEGD1
__DIVD211:
	RET

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	CLR  R0
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	ADIW R26,1
	ADC  R24,R0
	ADC  R25,R0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__CLRD1S0:
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
