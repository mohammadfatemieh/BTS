
;CodeVisionAVR C Compiler V2.05.3 Standard
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega88
;Program type             : Application
;Clock frequency          : 16.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Enhanced core instructions         : On
;Smart register allocation          : On
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATmega88
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1279
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
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
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
	.DEF _control_stt=R4
	.DEF _flag_for_update=R5
	.DEF _index=R3
	.DEF _usart_p=R7

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
	RJMP 0x00
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

_0x31:
	.DB  0x0,0x0,0x0,0x0
_0x0:
	.DB  0xD,0xA,0x3E,0x41,0x49,0x52,0x20,0x42
	.DB  0x6F,0x61,0x72,0x64,0x20,0x76,0x31,0x20
	.DB  0x66,0x77,0x76,0x31,0x20,0x32,0x36,0x2F
	.DB  0x30,0x32,0x2F,0x32,0x30,0x31,0x36,0xD
	.DB  0xA,0x0,0x3E,0x41,0x49,0x52,0x3A,0x25
	.DB  0x64,0x21,0x3C,0x0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  0x03
	.DW  _0x31*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	WDR
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	STS  WDTCSR,R31
	STS  WDTCSR,R30

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
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.3 Standard
;Automatic Program Generator
;© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : BTS Monitor
;Version : For IO_Board v3
;Date    : 1/15/2016
;Author  : Tuan
;Company : ATTECH
;Comments: This code for IO_Board v3
;- Have 9 relay with 9 DryOut "NC" for indicate ERROR : Water inside; Low AC Power; Low DC Power;
;- Measure AC Voltage by Transformer 220V to 12V AC
;- Measure DC Voltage 48V DC
;- Have 2 DryIN for Gate Sensor and Smoke Sensor
;- One ADC in for detect Water inside
;- One Relay to power 12V DC for Smoke Sensor
;
;
;Chip type               : ATmega88
;Program type            : Application
;AVR Core Clock frequency: 16.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include <mega88.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.SET power_ctrl_reg=smcr
	#endif
;#include <delay.h>
;// Standard Input/Output functions
;#include <stdio.h>
;// Define hardware for AIR Board
;// 2 Relay to BTS system for indicate Air Wrong
;#define Relay1 PORTD.4
;#define Relay2 PORTD.3
;
;// 2 Relay control Khoi Dong Tu de mo dieu hoa
;#define AiR1 PORTC.2
;#define AiR2 PORTC.1
;
;#define RS485_TxD PORTC.5
;
;//#define IND_COM_OPP  DDRB.5=1;PORTB.5=0// Output Push Pull wait for send data over USART
;//#define IND_COM_IPU   DDRB.5=0;PORTB.5=1// Input Pull Up wait for having data over USART
;//#define IND_COM_PIN   PINB.5// PIN indicate data for reciver and send data
;#define LG_IN_1 PIND.3
;#define LG_IN_2 PIND.2
;
;//#define LG_IN_3 PIND.6
;//#define LG_IN_4 PIND.7
;//#define LG_IN_5 PINB.0
;//#define LG_IN_6 PINB.1
;//#define LG_IN_7 PINB.2
;//#define LG_IN_8 PINB.3
;//#define GET_LG_STT (LG_IN_1<<7)+(LG_IN_2<<6)+(LG_IN_3<<5)+(LG_IN_4<<4)+(LG_IN_5<<3)+(LG_IN_6<<2)+(LG_IN_7<<1)+LG_IN_8
;//#define GET_RL_STT (Relay1<<7)+(Relay2<<6)+(Relay3<<5)+(Relay4<<4)+(Relay5<<3)+(Relay6<<2)+(Relay7<<1)+Relay8
;#define ALL_RL_ON   Relay1=1;Relay2=1
;#define ALL_RL_OFF   Relay1=0;Relay2=0
;unsigned char control_stt; //luu trang thai bi dieu khien
;int flag_for_update=0;
;//Khoang 60s se nhay vao day 1 lan
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0042 {

	.CSEG
_timer0_ovf_isr:
	RCALL SUBOPT_0x0
; 0000 0043 // Place your code here
; 0000 0044 flag_for_update++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 5,6,30,31
; 0000 0045 }
	RJMP _0x30
;//#define ADC_VREF_TYPE 0x40
;
;//// Read the AD conversion result
;//unsigned int read_adc(unsigned char adc_input)
;//{
;//ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;//// Delay needed for the stabilization of the ADC input voltage
;//delay_us(10);
;//// Start the AD conversion
;//ADCSRA|=0x40;
;//// Wait for the AD conversion to complete
;//while ((ADCSRA & 0x10)==0);
;//ADCSRA|=0x10;
;//return ADCW;
;//}
;
;#ifndef RXB8
;#define RXB8 1
;#endif
;
;#ifndef TXB8
;#define TXB8 0
;#endif
;
;#ifndef UPE
;#define UPE 2
;#endif
;
;#ifndef DOR
;#define DOR 3
;#endif
;
;#ifndef FE
;#define FE 4
;#endif
;
;#ifndef UDRE
;#define UDRE 5
;#endif
;
;#ifndef RXC
;#define RXC 7
;#endif
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;
;//Ban tin tu MB
;//sprintf(data_buffer,">MBS:%x.%x.%x.%x!<\r\n@%c",bts_stt_rtc.Int_Sensor.temp,bts_stt_rtc.Int_Sensor.humi,bts_stt_rtc.Ex_Sensor.temp,bts_stt_rtc.Ex_Sensor.humi,0);
;char USART_DATA[50];
;unsigned char index=0;
;char *usart_p;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0080 {
_usart_rx_isr:
	RCALL SUBOPT_0x0
; 0000 0081 char status,data;
; 0000 0082 status=UCSR0A;
	RCALL __SAVELOCR2
;	status -> R17
;	data -> R16
	LDS  R17,192
; 0000 0083 data=UDR0;
	LDS  R16,198
; 0000 0084 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
; 0000 0085    {
; 0000 0086      //Du lieu nhan duoc tu RS485 dc luu vao mang USART_DATA[50] va se xu ly sau do
; 0000 0087      if(index==0) usart_p=USART_DATA;
	TST  R3
	BRNE _0x4
	RCALL SUBOPT_0x1
; 0000 0088      USART_DATA[index++]=data;
_0x4:
	MOV  R30,R3
	INC  R3
	RCALL SUBOPT_0x2
	SUBI R30,LOW(-_USART_DATA)
	SBCI R31,HIGH(-_USART_DATA)
	ST   Z,R16
; 0000 0089      if(index==49) index=0;// Gioi han ban tin < 50 ky tu
	LDI  R30,LOW(49)
	CP   R30,R3
	BRNE _0x5
	CLR  R3
; 0000 008A    }
_0x5:
; 0000 008B }
_0x3:
	RCALL __LOADLOCR2P
_0x30:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;//union floatnum
;//{
;// float temp;
;// unsigned char byte[4];
;//} floatnum;
;typedef struct
; {
;	unsigned char sec,min,hr,day,date,month,year;
;  float temp;
; }  RTC_Time;
;
; typedef struct
;{
;int temp;
;int humi;
;} Sensor;
;
;typedef struct
;{
;	RTC_Time bts_rtc;
;	Sensor Int_Sensor;
;	Sensor Ex_Sensor;
;	unsigned char water;
;	unsigned char smoke;
;	unsigned char gate;
;	unsigned char dc_vol;
;	unsigned char ac_vol;
;} BTS_RTC;
;BTS_RTC bts_stt_rtc;
;
;
;
;
;// Declare your global variables here
;//unsigned char LG_STT=0,LG_TEMP=0;// Trang thai cua muc logic
;void main(void)
; 0000 00B1 {
_main:
; 0000 00B2 // Declare your local variables here
; 0000 00B3 unsigned char ii;
; 0000 00B4 
; 0000 00B5 // Crystal Oscillator division factor: 1
; 0000 00B6 #pragma optsize-
; 0000 00B7 CLKPR=0x80;
;	ii -> R17
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 00B8 CLKPR=0x00;
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 00B9 #ifdef _OPTIMIZE_SIZE_
; 0000 00BA #pragma optsize+
; 0000 00BB #endif
; 0000 00BC 
; 0000 00BD // Input/Output Ports initialization
; 0000 00BE // Port B initialization
; 0000 00BF // Func7=In Func6=In Func5=In Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 00C0 // State7=T State6=T State5=T State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 00C1 PORTB=0x00;
	OUT  0x5,R30
; 0000 00C2 DDRB=0;
	OUT  0x4,R30
; 0000 00C3 
; 0000 00C4 // Port C initialization
; 0000 00C5 // Func6=In Func5=Out Func4=In Func3=In Func2=Out Func1=Out Func0=In
; 0000 00C6 // State6=T State5=0 State4=T State3=T State2=0 State1=0 State0=T
; 0000 00C7 PORTC=0x00;
	OUT  0x8,R30
; 0000 00C8 DDRC=0x26;
	LDI  R30,LOW(38)
	OUT  0x7,R30
; 0000 00C9 
; 0000 00CA // Port D initialization
; 0000 00CB // Func7=In Func6=In Func5=In Func4=Out Func3=Out Func2=In Func1=In Func0=In
; 0000 00CC // State7=T State6=T State5=T State4=0 State3=0 State2=T State1=T State0=T
; 0000 00CD PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 00CE DDRD=0x18;
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 00CF 
; 0000 00D0 
; 0000 00D1 // Timer/Counter 1 initialization
; 0000 00D2 // Clock source: System Clock
; 0000 00D3 // Clock value: Timer1 Stopped
; 0000 00D4 // Mode: Normal top=0xFFFF
; 0000 00D5 // OC1A output: Discon.
; 0000 00D6 // OC1B output: Discon.
; 0000 00D7 // Noise Canceler: Off
; 0000 00D8 // Input Capture on Falling Edge
; 0000 00D9 // Timer1 Overflow Interrupt: Off
; 0000 00DA // Input Capture Interrupt: Off
; 0000 00DB // Compare A Match Interrupt: Off
; 0000 00DC // Compare B Match Interrupt: Off
; 0000 00DD TCCR1A=0x00;
	LDI  R30,LOW(0)
	STS  128,R30
; 0000 00DE TCCR1B=0x00;
	STS  129,R30
; 0000 00DF TCNT1H=0x00;
	STS  133,R30
; 0000 00E0 TCNT1L=0x00;
	STS  132,R30
; 0000 00E1 ICR1H=0x00;
	STS  135,R30
; 0000 00E2 ICR1L=0x00;
	STS  134,R30
; 0000 00E3 OCR1AH=0x00;
	STS  137,R30
; 0000 00E4 OCR1AL=0x00;
	STS  136,R30
; 0000 00E5 OCR1BH=0x00;
	STS  139,R30
; 0000 00E6 OCR1BL=0x00;
	STS  138,R30
; 0000 00E7 
; 0000 00E8 // Timer/Counter 2 initialization
; 0000 00E9 // Clock source: System Clock
; 0000 00EA // Clock value: Timer2 Stopped
; 0000 00EB // Mode: Normal top=0xFF
; 0000 00EC // OC2A output: Disconnected
; 0000 00ED // OC2B output: Disconnected
; 0000 00EE ASSR=0x00;
	STS  182,R30
; 0000 00EF TCCR2A=0x00;
	STS  176,R30
; 0000 00F0 TCCR2B=0x00;
	STS  177,R30
; 0000 00F1 TCNT2=0x00;
	STS  178,R30
; 0000 00F2 OCR2A=0x00;
	STS  179,R30
; 0000 00F3 OCR2B=0x00;
	STS  180,R30
; 0000 00F4 
; 0000 00F5 // External Interrupt(s) initialization
; 0000 00F6 // INT0: Off
; 0000 00F7 // INT1: Off
; 0000 00F8 // Interrupt on any change on pins PCINT0-7: Off
; 0000 00F9 // Interrupt on any change on pins PCINT8-14: Off
; 0000 00FA // Interrupt on any change on pins PCINT16-23: Off
; 0000 00FB EICRA=0x00;
	STS  105,R30
; 0000 00FC EIMSK=0x00;
	OUT  0x1D,R30
; 0000 00FD PCICR=0x00;
	STS  104,R30
; 0000 00FE 
; 0000 00FF 
; 0000 0100 // Timer/Counter 0 initialization
; 0000 0101 // Clock source: System Clock
; 0000 0102 // Clock value: 15.625 kHz
; 0000 0103 // Mode: Normal top=0xFF
; 0000 0104 // OC0A output: Disconnected
; 0000 0105 // OC0B output: Disconnected
; 0000 0106 TCCR0A=0x00;
	OUT  0x24,R30
; 0000 0107 TCCR0B=0x05;
	LDI  R30,LOW(5)
	OUT  0x25,R30
; 0000 0108 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 0109 OCR0A=0x00;
	OUT  0x27,R30
; 0000 010A OCR0B=0x00;
	OUT  0x28,R30
; 0000 010B TIMSK0=0x01;
	LDI  R30,LOW(1)
	STS  110,R30
; 0000 010C 
; 0000 010D 
; 0000 010E // Timer/Counter 1 Interrupt(s) initialization
; 0000 010F TIMSK1=0x00;
	LDI  R30,LOW(0)
	STS  111,R30
; 0000 0110 
; 0000 0111 // Timer/Counter 2 Interrupt(s) initialization
; 0000 0112 TIMSK2=0x00;
	STS  112,R30
; 0000 0113 
; 0000 0114 // USART initialization
; 0000 0115 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0116 // USART Receiver: On
; 0000 0117 // USART Transmitter: On
; 0000 0118 // USART0 Mode: Asynchronous
; 0000 0119 // USART Baud Rate: 115200 (Double Speed Mode)
; 0000 011A UCSR0A=0x02;
	LDI  R30,LOW(2)
	STS  192,R30
; 0000 011B UCSR0B=0x98;
	LDI  R30,LOW(152)
	STS  193,R30
; 0000 011C UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  194,R30
; 0000 011D UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  197,R30
; 0000 011E UBRR0L=0x10;
	LDI  R30,LOW(16)
	STS  196,R30
; 0000 011F 
; 0000 0120 // Analog Comparator initialization
; 0000 0121 // Analog Comparator: Off
; 0000 0122 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0123 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 0124 ADCSRB=0x00;
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 0125 DIDR1=0x00;
	STS  127,R30
; 0000 0126 
; 0000 0127 // ADC initialization
; 0000 0128 // ADC disabled
; 0000 0129 ADCSRA=0x00;
	STS  122,R30
; 0000 012A 
; 0000 012B // SPI initialization
; 0000 012C // SPI disabled
; 0000 012D SPCR=0x00;
	OUT  0x2C,R30
; 0000 012E 
; 0000 012F // TWI initialization
; 0000 0130 // TWI disabled
; 0000 0131 TWCR=0x00;
	STS  188,R30
; 0000 0132 
; 0000 0133 // Global enable interrupts
; 0000 0134 #asm("sei")
	sei
; 0000 0135 delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 0136 //Pull up for transmit data
; 0000 0137 RS485_TxD=1;
	SBI  0x8,5
; 0000 0138 printf("\r\n>AIR Board v1 fwv1 26/02/2016\r\n");
	__POINTW1FN _0x0,0
	RCALL SUBOPT_0x3
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
; 0000 0139 //c=(unsigned char*)&a;
; 0000 013A //printf("In a %x %x %x %x",*c,c[1],c[2],c[3]);
; 0000 013B //bts_stt_rtc.water=0;
; 0000 013C //bts_stt_rtc.smoke=0;
; 0000 013D //printf(">IO Board v3 fwv1\r\n");
; 0000 013E RS485_TxD=0; //pull down for receiver data
	CBI  0x8,5
; 0000 013F //Turn on power Smoke Sensor
; 0000 0140 
; 0000 0141 //IND_COM_IPU; // Wait for reciver data
; 0000 0142 //delay_ms(1000);
; 0000 0143 //while(!IND_COM_PIN);//wait for data line free
; 0000 0144 //IND_COM_OPP;// Pull Indicate PIN to GND for sending data
; 0000 0145 //printf(">IO Board v2 fwv1\r\n");
; 0000 0146 ////Doc trang thai cac cong logic luc khoi tao
; 0000 0147 //LG_STT=GET_LG_STT;
; 0000 0148 //printf(">%c%c\r\n",GET_LG_STT,GET_RL_STT);  //">[Byte1][Byte2] \r\n"
; 0000 0149 //IND_COM_IPU; // Free line and wait for reciver data
; 0000 014A ALL_RL_ON;
	SBI  0xB,4
	SBI  0xB,3
; 0000 014B delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 014C ALL_RL_OFF;
	CBI  0xB,4
	CBI  0xB,3
; 0000 014D usart_p=USART_DATA;
	RCALL SUBOPT_0x1
; 0000 014E while (1)
_0x12:
; 0000 014F       {
; 0000 0150       // Place your code here
; 0000 0151       //Neu index>0 thi co du lieu; doc du lieu, xu ly du lieu, xu ly xong cho index=0 OK
; 0000 0152       if(index>0)
	LDI  R30,LOW(0)
	CP   R30,R3
	BRLO PC+2
	RJMP _0x15
; 0000 0153       {
; 0000 0154       if((*usart_p=='>')&&(*(usart_p+1)=='M')&&(*(usart_p+2)=='B')&&(*(usart_p+3)=='S')&&(*(usart_p+20)=='!')&&(*(usart_p+18)=='.'))  //Du lieu ve sensor tu Master Board, nhan day du, dung cu phap
	RCALL SUBOPT_0x4
	BRNE _0x17
	RCALL SUBOPT_0x5
	LDD  R26,Z+1
	CPI  R26,LOW(0x4D)
	BRNE _0x17
	RCALL SUBOPT_0x5
	LDD  R26,Z+2
	CPI  R26,LOW(0x42)
	BRNE _0x17
	RCALL SUBOPT_0x5
	LDD  R26,Z+3
	CPI  R26,LOW(0x53)
	BRNE _0x17
	RCALL SUBOPT_0x5
	LDD  R26,Z+20
	CPI  R26,LOW(0x21)
	BRNE _0x17
	RCALL SUBOPT_0x5
	LDD  R26,Z+18
	CPI  R26,LOW(0x2E)
	BREQ _0x18
_0x17:
	RJMP _0x16
_0x18:
; 0000 0155       {
; 0000 0156             //ALL_RL_ON;
; 0000 0157             bts_stt_rtc.Int_Sensor.temp=(*(usart_p+5)<<8)+*(usart_p+7);
	RCALL SUBOPT_0x5
	LDD  R27,Z+5
	RCALL SUBOPT_0x6
	LDD  R30,Z+7
	RCALL SUBOPT_0x7
	__PUTW1MN _bts_stt_rtc,11
; 0000 0158             bts_stt_rtc.Int_Sensor.humi=(*(usart_p+9)<<8)+*(usart_p+11);
	RCALL SUBOPT_0x5
	LDD  R27,Z+9
	RCALL SUBOPT_0x6
	LDD  R30,Z+11
	RCALL SUBOPT_0x7
	__PUTW1MN _bts_stt_rtc,13
; 0000 0159             bts_stt_rtc.Ex_Sensor.temp=(*(usart_p+13)<<8)+*(usart_p+15);
	RCALL SUBOPT_0x5
	LDD  R27,Z+13
	RCALL SUBOPT_0x6
	LDD  R30,Z+15
	RCALL SUBOPT_0x7
	__PUTW1MN _bts_stt_rtc,15
; 0000 015A             bts_stt_rtc.Ex_Sensor.humi=(*(usart_p+17)<<8)+*(usart_p+19);
	RCALL SUBOPT_0x5
	LDD  R27,Z+17
	RCALL SUBOPT_0x6
	LDD  R30,Z+19
	RCALL SUBOPT_0x7
	__PUTW1MN _bts_stt_rtc,17
; 0000 015B             //delay_ms(10);
; 0000 015C             //RS485_TxD=1;
; 0000 015D             //printf( "Sensor: %d/%d-%d/%d\r\n",bts_stt_rtc.Int_Sensor.temp,bts_stt_rtc.Int_Sensor.humi,bts_stt_rtc.Ex_Sensor.temp,bts_stt_rtc.Ex_Sensor.humi);
; 0000 015E             //RS485_TxD=0;
; 0000 015F             for(ii=0;ii<21;ii++)
	LDI  R17,LOW(0)
_0x1A:
	CPI  R17,21
	BRSH _0x1B
; 0000 0160             {
; 0000 0161                 USART_DATA[ii]=0;
	RCALL SUBOPT_0x8
; 0000 0162             }
	SUBI R17,-1
	RJMP _0x1A
_0x1B:
; 0000 0163             index=0;//Xu ly xong du lieu ^^
	CLR  R3
; 0000 0164       }
; 0000 0165       else if((*usart_p=='>')&&(*(usart_p+1)=='M')&&(*(usart_p+2)=='B')&&(*(usart_p+3)=='C')&&(*(usart_p+4)=='A')&&(*(usart_p+23)=='!'))  //Du lieu ve sensor tu Master Board, nhan day du, dung cu phap
	RJMP _0x1C
_0x16:
	RCALL SUBOPT_0x4
	BRNE _0x1E
	RCALL SUBOPT_0x5
	LDD  R26,Z+1
	CPI  R26,LOW(0x4D)
	BRNE _0x1E
	RCALL SUBOPT_0x5
	LDD  R26,Z+2
	CPI  R26,LOW(0x42)
	BRNE _0x1E
	RCALL SUBOPT_0x5
	LDD  R26,Z+3
	CPI  R26,LOW(0x43)
	BRNE _0x1E
	RCALL SUBOPT_0x5
	LDD  R26,Z+4
	CPI  R26,LOW(0x41)
	BRNE _0x1E
	RCALL SUBOPT_0x5
	LDD  R26,Z+23
	CPI  R26,LOW(0x21)
	BREQ _0x1F
_0x1E:
	RJMP _0x1D
_0x1F:
; 0000 0166       {
; 0000 0167             //ALL_RL_ON;
; 0000 0168             //Doc trang thai dieu khien
; 0000 0169             control_stt=*(usart_p+8);
	RCALL SUBOPT_0x5
	LDD  R4,Z+8
; 0000 016A             if(control_stt>0)  flag_for_update=1800;// Neu co lenh dieu khien AIR thi thuc hien dieu khien ngay
	LDI  R30,LOW(0)
	CP   R30,R4
	BRSH _0x20
	LDI  R30,LOW(1800)
	LDI  R31,HIGH(1800)
	__PUTW1R 5,6
; 0000 016B             //=> Neu muon tat dieu hoa??? Bit cao nhat cua byte nay phai set la 1 neu muon control, neu set la 0, coi nhu ko co nghia. Bit0 = AIR1; Bit1 = AIR2;
; 0000 016C             //bts_stt_rtc.Int_Sensor.temp=(*(usart_p+5)<<8)+*(usart_p+7);
; 0000 016D             //bts_stt_rtc.Int_Sensor.humi=(*(usart_p+9)<<8)+*(usart_p+11);
; 0000 016E             //bts_stt_rtc.Ex_Sensor.temp=(*(usart_p+13)<<8)+*(usart_p+15);
; 0000 016F             //bts_stt_rtc.Ex_Sensor.humi=(*(usart_p+17)<<8)+*(usart_p+19);
; 0000 0170             //delay_ms(10);
; 0000 0171             //RS485_TxD=1;
; 0000 0172             //printf( "Sensor: %d/%d-%d/%d\r\n",bts_stt_rtc.Int_Sensor.temp,bts_stt_rtc.Int_Sensor.humi,bts_stt_rtc.Ex_Sensor.temp,bts_stt_rtc.Ex_Sensor.humi);
; 0000 0173             //RS485_TxD=0;
; 0000 0174             for(ii=0;ii<21;ii++)
_0x20:
	LDI  R17,LOW(0)
_0x22:
	CPI  R17,21
	BRSH _0x23
; 0000 0175             {
; 0000 0176                 USART_DATA[ii]=0;
	RCALL SUBOPT_0x8
; 0000 0177             }
	SUBI R17,-1
	RJMP _0x22
_0x23:
; 0000 0178             index=0;//Xu ly xong du lieu ^^
	CLR  R3
; 0000 0179       }
; 0000 017A       else usart_p++;
	RJMP _0x24
_0x1D:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 7,8,30,31
; 0000 017B       //RS485_TxD=1;
; 0000 017C       //printf("AIR:%s\r\n",USART_DATA);
; 0000 017D       //RS485_TxD=0;
; 0000 017E 
; 0000 017F       }
_0x24:
_0x1C:
; 0000 0180 
; 0000 0181       if(flag_for_update>1800)// 30s update
_0x15:
	LDI  R30,LOW(1800)
	LDI  R31,HIGH(1800)
	CP   R30,R5
	CPC  R31,R6
	BRGE _0x25
; 0000 0182       {
; 0000 0183 //            RS485_TxD=1;
; 0000 0184 //            printf( "AIR Update!");
; 0000 0185 //            RS485_TxD=0;
; 0000 0186             if(control_stt>0)
	LDI  R30,LOW(0)
	CP   R30,R4
	BRSH _0x26
; 0000 0187             {
; 0000 0188                 Relay1=control_stt&0x01;
	SBRC R4,0
	RJMP _0x27
	CBI  0xB,4
	RJMP _0x28
_0x27:
	SBI  0xB,4
_0x28:
; 0000 0189                 Relay2=control_stt&0x02;
	SBRC R4,1
	RJMP _0x29
	CBI  0xB,3
	RJMP _0x2A
_0x29:
	SBI  0xB,3
_0x2A:
; 0000 018A                 control_stt=0;
	CLR  R4
; 0000 018B                 RS485_TxD=1;
	SBI  0x8,5
; 0000 018C                 printf( ">AIR:%d!<",Relay1+(Relay2<<1));
	__POINTW1FN _0x0,34
	RCALL SUBOPT_0x3
	LDI  R30,0
	SBIC 0xB,4
	LDI  R30,1
	MOV  R0,R30
	LDI  R26,0
	SBIC 0xB,3
	LDI  R26,1
	MOV  R30,R26
	LSL  R30
	ADD  R30,R0
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _printf
	ADIW R28,6
; 0000 018D                 RS485_TxD=0;
	CBI  0x8,5
; 0000 018E             }
; 0000 018F             flag_for_update=0;
_0x26:
	CLR  R5
	CLR  R6
; 0000 0190       }
; 0000 0191 //      if(process_CMD)
; 0000 0192 //           {
; 0000 0193 //                //printf("%s",CMD);
; 0000 0194 //                if((CMD[0]=='>')&&(CMD[1]=='s') )  // Xu ly ban tin ">s 0x0D 0x0A" --- ban tin hoi trang thai cua IO board
; 0000 0195 //                {
; 0000 0196 //                    //Reply with status of Relays and Logics
; 0000 0197 //                    while(!IND_COM_PIN);//wait for data line free
; 0000 0198 //                    IND_COM_OPP;// Pull Indicate PIN to GND for sending data
; 0000 0199 //                    //printf(">%c%c\r\n",GET_LG_STT,GET_RL_STT);
; 0000 019A //                    IND_COM_IPU; // Free line and wait for reciver data
; 0000 019B //                }
; 0000 019C //                else if((CMD[0]=='>')&&(CMD[1]=='r'))  // Process message ">r[Byte1] 0x0D 0x0A" ; control Relays
; 0000 019D //                {
; 0000 019E //                    Relay1=CMD[2]&0x80;
; 0000 019F //                    Relay2=CMD[2]&0x40;
; 0000 01A0 //                    Relay3=CMD[2]&0x20;
; 0000 01A1 //                    Relay4=CMD[2]&0x10;
; 0000 01A2 //                    Relay5=CMD[2]&0x8;
; 0000 01A3 //                    Relay6=CMD[2]&0x4;
; 0000 01A4 //                    Relay7=CMD[2]&0x2;
; 0000 01A5 //                    Relay8=CMD[2]&0x1;
; 0000 01A6 //                    //Reply with status of Relays and Logics
; 0000 01A7 //                    while(!IND_COM_PIN);//wait for data line free
; 0000 01A8 //                    IND_COM_OPP;// Pull Indicate PIN to GND for sending data
; 0000 01A9 //                    //printf(">%c%c\r\n",GET_LG_STT,GET_RL_STT);
; 0000 01AA //                    IND_COM_IPU; // Free line and wait for reciver data
; 0000 01AB //                }
; 0000 01AC //                for(index=0;index<7;index++)
; 0000 01AD //                {
; 0000 01AE //                    CMD[index]=0;
; 0000 01AF //                }
; 0000 01B0 //                index=0;
; 0000 01B1 //                process_CMD=0;
; 0000 01B2 //                have_data=0;
; 0000 01B3 //           }
; 0000 01B4 
; 0000 01B5 //            LG_TEMP=GET_LG_STT;        // Get current status of logics port
; 0000 01B6 //            if(LG_TEMP!=LG_STT)           // compare with elder status; if diffient ; send message
; 0000 01B7 //                {
; 0000 01B8 //                    //Reply with status of Relays and Logics
; 0000 01B9 //                    while(!IND_COM_PIN);//wait for data line free
; 0000 01BA //                    IND_COM_OPP;// Pull Indicate PIN to GND for sending data
; 0000 01BB //                    printf(">%c%c\r\n",GET_LG_STT,GET_RL_STT);
; 0000 01BC //                    IND_COM_IPU; // Free line and wait for reciver data
; 0000 01BD //
; 0000 01BE //                    LG_STT=LG_TEMP; // Update new logic status
; 0000 01BF //                }
; 0000 01C0       }
_0x25:
	RJMP _0x12
; 0000 01C1 }
_0x2F:
	RJMP _0x2F
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_adc_noise_red=0x02
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG
_putchar:
	ST   -Y,R26
_0x2000006:
	LDS  R30,192
	ANDI R30,LOW(0x20)
	BREQ _0x2000006
	LD   R30,Y
	STS  198,R30
	ADIW R28,1
	RET
_put_usart_G100:
	RCALL SUBOPT_0x9
	LDD  R26,Y+2
	RCALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	ADIW R28,3
	RET
__print_G100:
	RCALL SUBOPT_0x9
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
	RCALL SUBOPT_0xA
_0x2000024:
	RJMP _0x2000021
_0x2000022:
	CPI  R30,LOW(0x1)
	BRNE _0x2000025
	CPI  R18,37
	BRNE _0x2000026
	RCALL SUBOPT_0xA
	RJMP _0x20000CF
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
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xB
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0xD
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x73)
	BRNE _0x2000038
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0xF
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2000039
_0x2000038:
	CPI  R30,LOW(0x70)
	BRNE _0x200003B
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0xF
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
	RCALL SUBOPT_0x10
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
	RCALL SUBOPT_0x10
	LDI  R17,LOW(4)
_0x2000043:
	SBRS R16,2
	RJMP _0x2000048
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x11
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
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x11
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
	RCALL SUBOPT_0xA
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
	RCALL SUBOPT_0x10
	RJMP _0x200005A
_0x2000059:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x200005A:
	RCALL SUBOPT_0xA
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
	RCALL SUBOPT_0x10
_0x2000060:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x2000062
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
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
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000068
_0x2000069:
	RJMP _0x20000D0
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
_0x20000D0:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2000070
	ANDI R16,LOW(251)
	ST   -Y,R20
	RCALL SUBOPT_0xD
	CPI  R21,0
	BREQ _0x2000071
	SUBI R21,LOW(1)
_0x2000071:
_0x2000070:
_0x200006F:
_0x2000067:
	RCALL SUBOPT_0xA
	CPI  R21,0
	BREQ _0x2000072
	SUBI R21,LOW(1)
_0x2000072:
_0x200006C:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
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
	RCALL SUBOPT_0xD
	RJMP _0x2000074
_0x2000076:
_0x2000073:
_0x2000077:
_0x2000036:
_0x20000CF:
	LDI  R17,LOW(0)
_0x2000021:
	RJMP _0x200001C
_0x200001E:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL __GETW1P
	RCALL __LOADLOCR6
	ADIW R28,20
	RET
_printf:
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
	RCALL SUBOPT_0x3
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_usart_G100)
	LDI  R31,HIGH(_put_usart_G100)
	RCALL SUBOPT_0x3
	MOVW R26,R28
	ADIW R26,8
	RCALL __print_G100
	RCALL __LOADLOCR2
	ADIW R28,8
	POP  R15
	RET

	.CSEG

	.CSEG
_strlen:
	RCALL SUBOPT_0x9
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
_strlenf:
	RCALL SUBOPT_0x9
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

	.DSEG
_USART_DATA:
	.BYTE 0x32
_bts_stt_rtc:
	.BYTE 0x18

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(_USART_DATA)
	LDI  R31,HIGH(_USART_DATA)
	__PUTW1R 7,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x2:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	__GETW2R 7,8
	LD   R26,X
	CPI  R26,LOW(0x3E)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x5:
	__GETW1R 7,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDI  R26,LOW(0)
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x7:
	RCALL SUBOPT_0x2
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	MOV  R30,R17
	RCALL SUBOPT_0x2
	SUBI R30,LOW(-_USART_DATA)
	SBCI R31,HIGH(-_USART_DATA)
	LDI  R26,LOW(0)
	STD  Z+0,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0xA:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xC:
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xD:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	RCALL SUBOPT_0xB
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	RCALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
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

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
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

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

;END OF CODE MARKER
__END_OF_CODE:
