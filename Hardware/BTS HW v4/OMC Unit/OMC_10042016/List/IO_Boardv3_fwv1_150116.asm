
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
	.DEF _MyID=R4
	.DEF _cpu_cmd=R5
	.DEF _omc_stt=R7
	.DEF _flag_for_update=R9
	.DEF _flag_for_volt=R11
	.DEF _usart_status=R3
	.DEF _index=R14
	.DEF _usart_flag=R13

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
	RJMP _adc_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x3F:
	.DB  0x1,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0
_0x0:
	.DB  0xD,0xA,0x3E,0x4F,0x4D,0x43,0x20,0x55
	.DB  0x6E,0x69,0x74,0x20,0x76,0x31,0x20,0x66
	.DB  0x77,0x76,0x31,0x20,0x31,0x30,0x2F,0x30
	.DB  0x34,0x2F,0x32,0x30,0x31,0x36,0xD,0xA
	.DB  0x0,0x6F,0x6D,0x63,0x5F,0x73,0x74,0x74
	.DB  0x3A,0x25,0x78,0xD,0xA,0x0,0x43,0x50
	.DB  0x55,0x20,0x63,0x6D,0x64,0x3A,0x25,0x78
	.DB  0xD,0xA,0x0,0x59,0x6F,0x75,0x20,0x61
	.DB  0x72,0x65,0x20,0x68,0x65,0x72,0x65,0x3A
	.DB  0x25,0x73,0x21,0xD,0xA,0x0,0x3E,0x31
	.DB  0x30,0x32,0x3A,0x25,0x30,0x32,0x58,0x25
	.DB  0x30,0x32,0x58,0x25,0x30,0x32,0x58,0x25
	.DB  0x30,0x32,0x58,0x25,0x30,0x32,0x58,0x25
	.DB  0x30,0x34,0x58,0x25,0x30,0x34,0x58,0x25
	.DB  0x30,0x34,0x58,0x25,0x30,0x34,0x58,0x25
	.DB  0x30,0x32,0x58,0x25,0x30,0x32,0x58,0x25
	.DB  0x30,0x32,0x58,0x21,0x3C,0x0,0x25,0x73
	.DB  0x0,0x3E,0x33,0x30,0x32,0x3A,0x25,0x30
	.DB  0x32,0x58,0x25,0x30,0x34,0x58,0x25,0x30
	.DB  0x32,0x58,0x25,0x30,0x32,0x58,0x21,0x3C
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x0B
	.DW  0x04
	.DW  _0x3F*2

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
;#include <delay.h>
;// Standard Input/Output functions
;#include <stdio.h>
;#include "main.h"
;
;unsigned char HexInCharToDec(char data)
; 0000 0025       {

	.CSEG
_HexInCharToDec:
; 0000 0026             if((data>47)&&(data<58)) return (data-48);// 0...9
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
	RJMP _0x2060002
; 0000 0027             if((data>63)&&(data<71)) return (data-55);//A..F
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
	RJMP _0x2060002
; 0000 0028       }
_0x6:
	RJMP _0x2060002
;// ADC interrupt service routine
;// with auto input scanning
;interrupt [ADC_INT] void adc_isr(void)
; 0000 002C {
_adc_isr:
	ST   -Y,R24
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 002D static unsigned char input_index=0;
; 0000 002E //static unsigned char ac_index=1;
; 0000 002F // Read the AD conversion result
; 0000 0030 adc_data[input_index]=ADCW;
	LDS  R30,_input_index_S0000001000
	LDI  R26,LOW(_adc_data)
	LDI  R27,HIGH(_adc_data)
	RCALL SUBOPT_0x0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LDS  R30,120
	LDS  R31,120+1
	ST   X+,R30
	ST   X,R31
; 0000 0031 //if(++input_index==1) adc_ac_volt[ac_index]=adc_data[input_index];
; 0000 0032 //if(++ac_index==9) {ac_index=1;adc_ac_volt[0]=(adc_ac_volt[1]+adc_ac_volt[2]+adc_ac_volt[3]+adc_ac_volt[4]+adc_ac_volt[5]+adc_ac_volt[6]+adc_ac_volt[7]+adc_ac_volt[8])/8;}
; 0000 0033 // Select next ADC input
; 0000 0034 if (++input_index > (LAST_ADC_INPUT-FIRST_ADC_INPUT))
	LDS  R26,_input_index_S0000001000
	SUBI R26,-LOW(1)
	STS  _input_index_S0000001000,R26
	CPI  R26,LOW(0x3)
	BRLO _0x9
; 0000 0035    input_index=0;
	LDI  R30,LOW(0)
	STS  _input_index_S0000001000,R30
; 0000 0036 ADMUX=(FIRST_ADC_INPUT | (ADC_VREF_TYPE & 0xff))+input_index;
_0x9:
	LDS  R30,_input_index_S0000001000
	SUBI R30,-LOW(65)
	STS  124,R30
; 0000 0037 // Delay needed for the stabilization of the ADC input voltage
; 0000 0038 delay_us(10);
	__DELAY_USB 53
; 0000 0039 // Start the AD conversion
; 0000 003A ADCSRA|=0x40;
	LDS  R30,122
	ORI  R30,0x40
	STS  122,R30
; 0000 003B }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R24,Y+
	RETI
;
;
;//Khoang 60s se nhay vao day 1 lan
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0041 {
_timer0_ovf_isr:
; 0000 0042 // Place your code here
; 0000 0043 //static unsigned char ac_index=1;
; 0000 0044 //adc_ac_volt[ac_index]=adc_data[1];
; 0000 0045 //if(++ac_index==9) {ac_index=1;adc_ac_volt[0]=(adc_ac_volt[1]+adc_ac_volt[2]+adc_ac_volt[3]+adc_ac_volt[4]+adc_ac_volt[5]+adc_ac_volt[6]+adc_ac_volt[7]+adc_ac_volt[8])/8;}
; 0000 0046 //bts_stt_rtc.dc_vol=(int)(2.2+0.7919*adc_data[DC_ADC]); // Tinh toan dien ap DC
; 0000 0047 //            bts_stt_rtc.ac_vol=(int)(12.163 * (.2+(float)(adc_ac_volt[0])/35.503));       // TInh toan dien ap AC
; 0000 0048 //flag_for_update++;
; 0000 0049 //flag_for_volt++;
; 0000 004A }
	RETI
;
;
;
;
;//Ban tin tu MB
;char USART_DATA[50];
;unsigned char index=0, usart_flag=0;
;unsigned char usart_time_out;
;char *usart_p;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0056 {
_usart_rx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0057 char data;
; 0000 0058 usart_status=UCSR0A;
	ST   -Y,R17
;	data -> R17
	LDS  R3,192
; 0000 0059 data=UDR0;
	LDS  R17,198
; 0000 005A usart_time_out=0xffff;
	LDI  R30,LOW(255)
	STS  _usart_time_out,R30
; 0000 005B usart_flag=0;
	CLR  R13
; 0000 005C if ((usart_status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R3
	ANDI R30,LOW(0x1C)
	BRNE _0xA
; 0000 005D    {
; 0000 005E      //Du lieu nhan duoc tu RS485 dc luu vao mang USART_DATA[50] va se xu ly sau do
; 0000 005F      // Chi nhan ban tin tu CPU_Unit ">CPU[REC_ID][cmd_High][cmd_Low][checksum]<"
; 0000 0060      USART_DATA[index++]=data;
	MOV  R30,R14
	INC  R14
	RCALL SUBOPT_0x0
	SUBI R30,LOW(-_USART_DATA)
	SBCI R31,HIGH(-_USART_DATA)
	ST   Z,R17
; 0000 0061      if(index>49) {index=0;usart_p=USART_DATA;}// Gioi han ban tin < 50 ky tu
	LDI  R30,LOW(49)
	CP   R30,R14
	BRSH _0xB
	RCALL SUBOPT_0x1
; 0000 0062    }
_0xB:
; 0000 0063 }
_0xA:
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;interrupt [USART_TXC] void usart_tx_isr(void)
; 0000 0066 {
_usart_tx_isr:
; 0000 0067 RS485_TxD=0;
	CBI  0x8,5
; 0000 0068 }
	RETI
;
;
;void main(void)
; 0000 006C {
_main:
; 0000 006D // Declare your local variables here
; 0000 006E unsigned char usart_count;
; 0000 006F char data_buffer_to_send[50];
; 0000 0070 
; 0000 0071 // Crystal Oscillator division factor: 1
; 0000 0072 #pragma optsize-
; 0000 0073 CLKPR=0x80;
	SBIW R28,50
;	usart_count -> R17
;	data_buffer_to_send -> Y+0
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 0074 CLKPR=0x00;
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 0075 #ifdef _OPTIMIZE_SIZE_
; 0000 0076 #pragma optsize+
; 0000 0077 #endif
; 0000 0078 
; 0000 0079 // Input/Output Ports initialization
; 0000 007A // Port B initialization
; 0000 007B // Func7=In Func6=In Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 007C // State7=T State6=T State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 007D PORTB=0x00;
	OUT  0x5,R30
; 0000 007E DDRB=0x3F;
	LDI  R30,LOW(63)
	OUT  0x4,R30
; 0000 007F 
; 0000 0080 // Port C initialization
; 0000 0081 // Func6=In Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 0082 // State6=T State5=0 State4=0 State3=T State2=T State1=T State0=T
; 0000 0083 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x8,R30
; 0000 0084 DDRC=0x30;
	LDI  R30,LOW(48)
	OUT  0x7,R30
; 0000 0085 
; 0000 0086 // Port D initialization
; 0000 0087 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 0088 // State7=0 State6=0 State5=0 State4=0 State3=T State2=T State1=T State0=T
; 0000 0089 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 008A DDRD=0xF0;
	LDI  R30,LOW(240)
	OUT  0xA,R30
; 0000 008B 
; 0000 008C 
; 0000 008D // Timer/Counter 1 initialization
; 0000 008E TCCR1A=0x00;
	LDI  R30,LOW(0)
	STS  128,R30
; 0000 008F TCCR1B=0x00;
	STS  129,R30
; 0000 0090 TCNT1H=0x00;
	STS  133,R30
; 0000 0091 TCNT1L=0x00;
	STS  132,R30
; 0000 0092 ICR1H=0x00;
	STS  135,R30
; 0000 0093 ICR1L=0x00;
	STS  134,R30
; 0000 0094 OCR1AH=0x00;
	STS  137,R30
; 0000 0095 OCR1AL=0x00;
	STS  136,R30
; 0000 0096 OCR1BH=0x00;
	STS  139,R30
; 0000 0097 OCR1BL=0x00;
	STS  138,R30
; 0000 0098 
; 0000 0099 // Timer/Counter 2 initialization
; 0000 009A ASSR=0x00;
	STS  182,R30
; 0000 009B TCCR2A=0x00;
	STS  176,R30
; 0000 009C TCCR2B=0x00;
	STS  177,R30
; 0000 009D TCNT2=0x00;
	STS  178,R30
; 0000 009E OCR2A=0x00;
	STS  179,R30
; 0000 009F OCR2B=0x00;
	STS  180,R30
; 0000 00A0 
; 0000 00A1 // External Interrupt(s) initialization
; 0000 00A2 EICRA=0x00;
	STS  105,R30
; 0000 00A3 EIMSK=0x00;
	OUT  0x1D,R30
; 0000 00A4 PCICR=0x00;
	STS  104,R30
; 0000 00A5 
; 0000 00A6 
; 0000 00A7 // Timer/Counter 0 initialization
; 0000 00A8 // Clock source: System Clock
; 0000 00A9 // Clock value: 15.625 kHz
; 0000 00AA // Mode: Normal top=0xFF
; 0000 00AB // OC0A output: Disconnected
; 0000 00AC // OC0B output: Disconnected
; 0000 00AD TCCR0A=0x00;
	OUT  0x24,R30
; 0000 00AE TCCR0B=0x05;
	LDI  R30,LOW(5)
	OUT  0x25,R30
; 0000 00AF TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 00B0 OCR0A=0x00;
	OUT  0x27,R30
; 0000 00B1 OCR0B=0x00;
	OUT  0x28,R30
; 0000 00B2 TIMSK0=0x01;
	LDI  R30,LOW(1)
	STS  110,R30
; 0000 00B3 
; 0000 00B4 
; 0000 00B5 // Timer/Counter 1 Interrupt(s) initialization
; 0000 00B6 TIMSK1=0x00;
	LDI  R30,LOW(0)
	STS  111,R30
; 0000 00B7 
; 0000 00B8 // Timer/Counter 2 Interrupt(s) initialization
; 0000 00B9 TIMSK2=0x00;
	STS  112,R30
; 0000 00BA 
; 0000 00BB 
; 0000 00BC 
; 0000 00BD // USART initialization
; 0000 00BE // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 00BF // USART Receiver: On
; 0000 00C0 // USART Transmitter: On
; 0000 00C1 // USART0 Mode: Asynchronous
; 0000 00C2 // USART Baud Rate: 115200 (Double Speed Mode)
; 0000 00C3 UCSR0A=0x02;
	LDI  R30,LOW(2)
	STS  192,R30
; 0000 00C4 UCSR0B=0xD8;
	LDI  R30,LOW(216)
	STS  193,R30
; 0000 00C5 UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  194,R30
; 0000 00C6 UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  197,R30
; 0000 00C7 UBRR0L=0x10;
	LDI  R30,LOW(16)
	STS  196,R30
; 0000 00C8 
; 0000 00C9 // Analog Comparator initialization
; 0000 00CA // Analog Comparator: Off
; 0000 00CB // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00CC ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 00CD ADCSRB=0x00;
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 00CE DIDR1=0x00;
	STS  127,R30
; 0000 00CF 
; 0000 00D0 // ADC initialization
; 0000 00D1 // ADC disabled
; 0000 00D2 ADCSRA=0x00;
	STS  122,R30
; 0000 00D3 
; 0000 00D4 // SPI initialization
; 0000 00D5 // SPI disabled
; 0000 00D6 SPCR=0x00;
	OUT  0x2C,R30
; 0000 00D7 
; 0000 00D8 // TWI initialization
; 0000 00D9 // TWI disabled
; 0000 00DA TWCR=0x00;
	STS  188,R30
; 0000 00DB 
; 0000 00DC 
; 0000 00DD delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 00DE // Global enable interrupts
; 0000 00DF #asm("sei")
	sei
; 0000 00E0 
; 0000 00E1 
; 0000 00E2 usart_p=USART_DATA;
	LDI  R30,LOW(_USART_DATA)
	LDI  R31,HIGH(_USART_DATA)
	STS  _usart_p,R30
	STS  _usart_p+1,R31
; 0000 00E3 //Pull up for transmit data
; 0000 00E4 RS485_TxD=1;
	SBI  0x8,5
; 0000 00E5 //while(usart_status&(RX_COMPLETE));
; 0000 00E6 printf("\r\n>OMC Unit v1 fwv1 10/04/2016\r\n");
	__POINTW1FN _0x0,0
	RCALL SUBOPT_0x2
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
; 0000 00E7 index=0;
	RCALL SUBOPT_0x1
; 0000 00E8 usart_p=USART_DATA;
; 0000 00E9 IDC_Standby;
	CBI  0x7,4
	SBI  0x8,4
; 0000 00EA //IDC_Send;
; 0000 00EB //ALL_RL_ON;
; 0000 00EC while (1)
_0x14:
; 0000 00ED       {
; 0000 00EE       // Place your code here
; 0000 00EF       if(omc_stt!=cpu_cmd)
	__CPWRR 5,6,7,8
	BRNE PC+2
	RJMP _0x17
; 0000 00F0         {
; 0000 00F1             omc_stt=cpu_cmd;
	__MOVEWRR 7,8,5,6
; 0000 00F2             Relay1   =omc_stt&  0x01;
	SBRC R7,0
	RJMP _0x18
	CBI  0x5,0
	RJMP _0x19
_0x18:
	SBI  0x5,0
_0x19:
; 0000 00F3             Relay2   =omc_stt&  0x02;
	SBRC R7,1
	RJMP _0x1A
	CBI  0xB,7
	RJMP _0x1B
_0x1A:
	SBI  0xB,7
_0x1B:
; 0000 00F4             Relay3   =omc_stt&  0x04;
	SBRC R7,2
	RJMP _0x1C
	CBI  0xB,6
	RJMP _0x1D
_0x1C:
	SBI  0xB,6
_0x1D:
; 0000 00F5             Relay4   =omc_stt&  0x08;
	SBRC R7,3
	RJMP _0x1E
	CBI  0xB,5
	RJMP _0x1F
_0x1E:
	SBI  0xB,5
_0x1F:
; 0000 00F6             Relay5   =omc_stt&  0x10;
	SBRC R7,4
	RJMP _0x20
	CBI  0xB,4
	RJMP _0x21
_0x20:
	SBI  0xB,4
_0x21:
; 0000 00F7             Relay6   =omc_stt&  0x20;
	SBRC R7,5
	RJMP _0x22
	CBI  0x5,5
	RJMP _0x23
_0x22:
	SBI  0x5,5
_0x23:
; 0000 00F8             Relay7   =omc_stt&  0x40;
	SBRC R7,6
	RJMP _0x24
	CBI  0x5,4
	RJMP _0x25
_0x24:
	SBI  0x5,4
_0x25:
; 0000 00F9             Relay8   =omc_stt&  0x80;
	SBRC R7,7
	RJMP _0x26
	CBI  0x5,3
	RJMP _0x27
_0x26:
	SBI  0x5,3
_0x27:
; 0000 00FA             Relay9   =omc_stt&  0x100;
	MOV  R30,R7
	ANDI R30,LOW(0x0)
	BRNE _0x28
	CBI  0x5,2
	RJMP _0x29
_0x28:
	SBI  0x5,2
_0x29:
; 0000 00FB             Relay10 =omc_stt&  0x200;
	MOV  R30,R7
	ANDI R30,LOW(0x0)
	BRNE _0x2A
	CBI  0x5,1
	RJMP _0x2B
_0x2A:
	SBI  0x5,1
_0x2B:
; 0000 00FC             RS485_TxD=1;
	SBI  0x8,5
; 0000 00FD             omc_stt=GET_RL_STT;
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
	MOV  R7,R30
	CLR  R8
; 0000 00FE             printf("omc_stt:%x\r\n",GET_RL_STT);
	__POINTW1FN _0x0,33
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x6
; 0000 00FF         }
; 0000 0100       if(usart_flag==0){
_0x17:
	TST  R13
	BRNE _0x2E
; 0000 0101       usart_time_out--;}
	LDS  R30,_usart_time_out
	SUBI R30,LOW(1)
	STS  _usart_time_out,R30
; 0000 0102       if(usart_time_out==1)
_0x2E:
	LDS  R26,_usart_time_out
	CPI  R26,LOW(0x1)
	BREQ PC+2
	RJMP _0x2F
; 0000 0103             {
; 0000 0104                 usart_flag=1;
	LDI  R30,LOW(1)
	MOV  R13,R30
; 0000 0105                 usart_time_out=0;
	LDI  R30,LOW(0)
	STS  _usart_time_out,R30
; 0000 0106                 delay_ms(5);
	LDI  R26,LOW(5)
	LDI  R27,0
	RCALL _delay_ms
; 0000 0107                 // Chi nhan ban tin tu CPU_Unit ">CPU[REC_ID][cmd_High][cmd_Low][checksum]<"
; 0000 0108                 // In hex : ">CPU[0xMyIDHigh.0xMyIDLow][0xcmd_High.0xcmd_High][0xcmd_Low.0xcmd_Low][0xchecksum.0xchecksum]<"
; 0000 0109                 //">CPU01223322<"
; 0000 010A                 if((USART_DATA[0]=='>')&&(USART_DATA[1]=='C')&&(USART_DATA[2]=='P')&&(USART_DATA[3]=='U')&&(USART_DATA[12]=='<')   )
	LDS  R26,_USART_DATA
	CPI  R26,LOW(0x3E)
	BRNE _0x31
	__GETB2MN _USART_DATA,1
	CPI  R26,LOW(0x43)
	BRNE _0x31
	__GETB2MN _USART_DATA,2
	CPI  R26,LOW(0x50)
	BRNE _0x31
	__GETB2MN _USART_DATA,3
	CPI  R26,LOW(0x55)
	BRNE _0x31
	__GETB2MN _USART_DATA,12
	CPI  R26,LOW(0x3C)
	BREQ _0x32
_0x31:
	RJMP _0x30
_0x32:
; 0000 010B                 //&&(HexInCharToDec(USART_DATA[5]) +  (HexInCharToDec(USART_DATA[4])<<4) ==MyID)
; 0000 010C                 //&&(HexInCharToDec(USART_DATA[11]) +  (HexInCharToDec(USART_DATA[10])<<4) ==0x22))
; 0000 010D                 {
; 0000 010E                 RS485_TxD=1;
	SBI  0x8,5
; 0000 010F                 cpu_cmd=((HexInCharToDec(USART_DATA[7])+(HexInCharToDec(USART_DATA[6])<<4))<<8)+HexInCharToDec(USART_DATA[9])+16*HexInCharToDec(USART_DATA[8]);
	__GETB2MN _USART_DATA,7
	RCALL _HexInCharToDec
	RCALL SUBOPT_0x0
	PUSH R31
	PUSH R30
	__GETB2MN _USART_DATA,6
	RCALL _HexInCharToDec
	RCALL SUBOPT_0x0
	RCALL __LSLW4
	POP  R26
	POP  R27
	ADD  R26,R30
	ADC  R27,R31
	MOVW R30,R26
	MOV  R31,R30
	LDI  R30,0
	PUSH R31
	PUSH R30
	__GETB2MN _USART_DATA,9
	RCALL _HexInCharToDec
	RCALL SUBOPT_0x0
	POP  R26
	POP  R27
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	__GETB2MN _USART_DATA,8
	RCALL _HexInCharToDec
	LDI  R26,LOW(16)
	MUL  R30,R26
	MOVW R30,R0
	POP  R26
	POP  R27
	ADD  R30,R26
	ADC  R31,R27
	__PUTW1R 5,6
; 0000 0110                 printf("CPU cmd:%x\r\n",cpu_cmd);
	__POINTW1FN _0x0,46
	RCALL SUBOPT_0x2
	__GETW1R 5,6
	RCALL SUBOPT_0x7
; 0000 0111                 }
; 0000 0112                 //RS485_TxD=1;
; 0000 0113                 printf("You are here:%s!\r\n",USART_DATA);
_0x30:
	__POINTW1FN _0x0,59
	RCALL SUBOPT_0x2
	LDI  R30,LOW(_USART_DATA)
	LDI  R31,HIGH(_USART_DATA)
	RCALL SUBOPT_0x7
; 0000 0114                 for(usart_count=0;usart_count<50;usart_count++)
	LDI  R17,LOW(0)
_0x36:
	CPI  R17,50
	BRSH _0x37
; 0000 0115                             {
; 0000 0116                             USART_DATA[usart_count]=0;
	MOV  R30,R17
	RCALL SUBOPT_0x0
	SUBI R30,LOW(-_USART_DATA)
	SBCI R31,HIGH(-_USART_DATA)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0117                             }
	SUBI R17,-1
	RJMP _0x36
_0x37:
; 0000 0118                             index=0;
	CLR  R14
; 0000 0119             }
; 0000 011A 
; 0000 011B 
; 0000 011C         if(flag_for_update>2200)// 30s update
_0x2F:
	LDI  R30,LOW(2200)
	LDI  R31,HIGH(2200)
	CP   R30,R9
	CPC  R31,R10
	BRLT PC+2
	RJMP _0x38
; 0000 011D       {
; 0000 011E             sprintf(data_buffer_to_send,">102:%02X%02X%02X%02X%02X%04X%04X%04X%04X%02X%02X%02X!<",
; 0000 011F             bts_stt_rtc.bts_rtc.hr,bts_stt_rtc.bts_rtc.min,
; 0000 0120 	        bts_stt_rtc.bts_rtc.date,bts_stt_rtc.bts_rtc.month,bts_stt_rtc.bts_rtc.year,
; 0000 0121 	        bts_stt_rtc.Ex_Sensor.humi,
; 0000 0122 	        bts_stt_rtc.Ex_Sensor.temp,
; 0000 0123 	        bts_stt_rtc.Int_Sensor.humi,
; 0000 0124 	        bts_stt_rtc.Int_Sensor.temp,
; 0000 0125 	        (bts_stt_rtc.gate<<2)+(bts_stt_rtc.smoke<<1)+bts_stt_rtc.water,60,102);
	MOVW R30,R28
	RCALL SUBOPT_0x2
	__POINTW1FN _0x0,78
	RCALL SUBOPT_0x2
	__GETB1MN _bts_stt_rtc,2
	RCALL SUBOPT_0x5
	__GETB1MN _bts_stt_rtc,1
	RCALL SUBOPT_0x5
	__GETB1MN _bts_stt_rtc,4
	RCALL SUBOPT_0x5
	__GETB1MN _bts_stt_rtc,5
	RCALL SUBOPT_0x5
	__GETB1MN _bts_stt_rtc,6
	RCALL SUBOPT_0x5
	__GETW1MN _bts_stt_rtc,17
	RCALL SUBOPT_0x8
	__GETW1MN _bts_stt_rtc,15
	RCALL SUBOPT_0x8
	__GETW1MN _bts_stt_rtc,13
	RCALL SUBOPT_0x8
	__GETW1MN _bts_stt_rtc,11
	RCALL SUBOPT_0x8
	__GETB1MN _bts_stt_rtc,21
	RCALL SUBOPT_0x0
	RCALL __LSLW2
	MOVW R26,R30
	__GETB1MN _bts_stt_rtc,20
	RCALL SUBOPT_0x0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	__GETB1MN _bts_stt_rtc,19
	RCALL SUBOPT_0x0
	ADD  R30,R26
	ADC  R31,R27
	RCALL SUBOPT_0x8
	__GETD1N 0x3C
	RCALL SUBOPT_0x9
	LDI  R24,48
	RCALL _sprintf
	ADIW R28,52
; 0000 0126 
; 0000 0127             RS485_TxD=1;
	RCALL SUBOPT_0xA
; 0000 0128             printf("%s",data_buffer_to_send);
; 0000 0129 
; 0000 012A             //printf( ">BMS:%c.%c.%c.%c.%c!<",bts_stt_rtc.ac_vol,bts_stt_rtc.dc_vol>>8,bts_stt_rtc.dc_vol,(bts_stt_rtc.gate<<2)+(bts_stt_rtc.smoke<<1)+bts_stt_rtc.water,123);
; 0000 012B             //RS485_TxD=0;
; 0000 012C             flag_for_update=0;
	CLR  R9
	CLR  R10
; 0000 012D       }
; 0000 012E       if(flag_for_volt>1200)
_0x38:
	LDI  R30,LOW(1200)
	LDI  R31,HIGH(1200)
	CP   R30,R11
	CPC  R31,R12
	BRGE _0x3B
; 0000 012F       {
; 0000 0130             //">302:[ac_vol].[dc_vol_H].[dc_vol_L].[alarm][check_sum]!<"
; 0000 0131 
; 0000 0132             //>3XX:[hr][][][][][][][][][DC]!<
; 0000 0133             sprintf(data_buffer_to_send,">302:%02X%04X%02X%02X!<",
; 0000 0134                                                         bts_stt_rtc.ac_vol,bts_stt_rtc.dc_vol,
; 0000 0135                                                         61,102);
	MOVW R30,R28
	RCALL SUBOPT_0x2
	__POINTW1FN _0x0,137
	RCALL SUBOPT_0x2
	__GETW1MN _bts_stt_rtc,24
	RCALL SUBOPT_0x8
	__GETW1MN _bts_stt_rtc,22
	RCALL SUBOPT_0x8
	__GETD1N 0x3D
	RCALL SUBOPT_0x9
	LDI  R24,16
	RCALL _sprintf
	ADIW R28,20
; 0000 0136             RS485_TxD=1;
	RCALL SUBOPT_0xA
; 0000 0137             printf("%s",data_buffer_to_send);
; 0000 0138             flag_for_volt=0;
	CLR  R11
	CLR  R12
; 0000 0139       }
; 0000 013A 
; 0000 013B 
; 0000 013C       }
_0x3B:
	RJMP _0x14
; 0000 013D }
_0x3E:
	RJMP _0x3E
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
_0x2060002:
	ADIW R28,1
	RET
_put_usart_G100:
	RCALL SUBOPT_0xB
	LDD  R26,Y+2
	RCALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	RCALL SUBOPT_0xC
	ADIW R28,3
	RET
_put_buff_G100:
	RCALL SUBOPT_0xB
	RCALL __SAVELOCR2
	RCALL SUBOPT_0xD
	ADIW R26,2
	RCALL __GETW1P
	SBIW R30,0
	BREQ _0x2000016
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xE
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000018
	__CPWRN 16,17,2
	BRLO _0x2000019
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000018:
	RCALL SUBOPT_0xD
	ADIW R26,2
	RCALL SUBOPT_0xC
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	RCALL SUBOPT_0xD
	RCALL __GETW1P
	TST  R31
	BRMI _0x200001A
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xC
_0x200001A:
_0x2000019:
	RJMP _0x200001B
_0x2000016:
	RCALL SUBOPT_0xD
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x200001B:
	RCALL __LOADLOCR2
	ADIW R28,5
	RET
__print_G100:
	RCALL SUBOPT_0xB
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
	RCALL SUBOPT_0xF
_0x2000024:
	RJMP _0x2000021
_0x2000022:
	CPI  R30,LOW(0x1)
	BRNE _0x2000025
	CPI  R18,37
	BRNE _0x2000026
	RCALL SUBOPT_0xF
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
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x10
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x12
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x73)
	BRNE _0x2000038
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x15
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2000039
_0x2000038:
	CPI  R30,LOW(0x70)
	BRNE _0x200003B
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x15
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
	RCALL SUBOPT_0x16
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
	RCALL SUBOPT_0x16
	LDI  R17,LOW(4)
_0x2000043:
	SBRS R16,2
	RJMP _0x2000048
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x17
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000049
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL __ANEGW1
	RCALL SUBOPT_0x17
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
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x17
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
	RCALL SUBOPT_0xF
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
	RCALL SUBOPT_0x16
	RJMP _0x200005A
_0x2000059:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x200005A:
	RCALL SUBOPT_0xF
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
	RCALL SUBOPT_0x16
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
	RCALL SUBOPT_0x17
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
	RCALL SUBOPT_0x12
	CPI  R21,0
	BREQ _0x2000071
	SUBI R21,LOW(1)
_0x2000071:
_0x2000070:
_0x200006F:
_0x2000067:
	RCALL SUBOPT_0xF
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
	RCALL SUBOPT_0x12
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
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	RCALL __SAVELOCR4
	RCALL SUBOPT_0x18
	SBIW R30,0
	BRNE _0x2000078
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2060001
_0x2000078:
	MOVW R26,R28
	ADIW R26,6
	RCALL __ADDW2R15
	MOVW R16,R26
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x16
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL SUBOPT_0x19
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	RCALL SUBOPT_0x2
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2060001:
	RCALL __LOADLOCR4
	ADIW R28,10
	POP  R15
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
	RCALL SUBOPT_0x19
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

	.CSEG

	.CSEG
_strlen:
	RCALL SUBOPT_0xB
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
	RCALL SUBOPT_0xB
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
_bts_stt_rtc:
	.BYTE 0x1A
_adc_data:
	.BYTE 0x6
_input_index_S0000001000:
	.BYTE 0x1
_USART_DATA:
	.BYTE 0x32
_usart_time_out:
	.BYTE 0x1
_usart_p:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x0:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1:
	CLR  R14
	LDI  R30,LOW(_USART_DATA)
	LDI  R31,HIGH(_USART_DATA)
	STS  _usart_p,R30
	STS  _usart_p+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x2:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:61 WORDS
SUBOPT_0x3:
	LDI  R26,0
	SBIC 0x5,1
	LDI  R26,1
	LDI  R30,LOW(9)
	RCALL __LSLB12
	MOV  R1,R30
	LDI  R26,0
	SBIC 0x5,2
	LDI  R26,1
	LDI  R30,LOW(8)
	RCALL __LSLB12
	ADD  R30,R1
	MOV  R0,R30
	LDI  R26,0
	SBIC 0x5,3
	LDI  R26,1
	MOV  R30,R26
	ROR  R30
	LDI  R30,0
	ROR  R30
	ADD  R0,R30
	LDI  R26,0
	SBIC 0x5,4
	LDI  R26,1
	MOV  R30,R26
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	LSL  R30
	ADD  R0,R30
	LDI  R26,0
	SBIC 0x5,5
	LDI  R26,1
	MOV  R30,R26
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	ADD  R0,R30
	LDI  R26,0
	SBIC 0xB,4
	LDI  R26,1
	MOV  R30,R26
	SWAP R30
	ANDI R30,0xF0
	ADD  R0,R30
	LDI  R26,0
	SBIC 0xB,5
	LDI  R26,1
	MOV  R30,R26
	LSL  R30
	LSL  R30
	LSL  R30
	ADD  R0,R30
	LDI  R26,0
	SBIC 0xB,6
	LDI  R26,1
	MOV  R30,R26
	LSL  R30
	LSL  R30
	ADD  R0,R30
	LDI  R26,0
	SBIC 0xB,7
	LDI  R26,1
	MOV  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4:
	LSL  R30
	MOV  R26,R0
	ADD  R26,R30
	LDI  R30,0
	SBIC 0x5,0
	LDI  R30,1
	ADD  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x5:
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x6:
	LDI  R24,4
	RCALL _printf
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x7:
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x8:
	RCALL __CWD1
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	RCALL __PUTPARD1
	__GETD1N 0x66
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xA:
	SBI  0x8,5
	__POINTW1FN _0x0,134
	RCALL SUBOPT_0x2
	MOVW R30,R28
	ADIW R30,2
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xC:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	ADIW R26,4
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0xF:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x11:
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x12:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	RCALL SUBOPT_0x10
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x14:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x16:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	MOVW R26,R28
	ADIW R26,12
	RCALL __ADDW2R15
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x19:
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0x2
	ST   -Y,R17
	ST   -Y,R16
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

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
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

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
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

;END OF CODE MARKER
__END_OF_CODE:
