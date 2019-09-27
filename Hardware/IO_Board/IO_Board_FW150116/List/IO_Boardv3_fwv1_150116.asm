
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
	.DEF _flag_for_update=R3
	.DEF _flag_for_volt=R5
	.DEF _usart_status=R8
	.DEF _index=R7
	.DEF _usart_p=R9

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

_0xA:
	.DB  0x1
_0x3D:
	.DB  0x0,0x0,0x0,0x0,0x0
_0x0:
	.DB  0xD,0xA,0x3E,0x42,0x61,0x73,0x69,0x63
	.DB  0x20,0x42,0x6F,0x61,0x72,0x64,0x20,0x76
	.DB  0x31,0x20,0x66,0x77,0x76,0x32,0x20,0x31
	.DB  0x35,0x2F,0x30,0x33,0x2F,0x32,0x30,0x31
	.DB  0x36,0xD,0xA,0x0,0xD,0xA,0x65,0x78
	.DB  0x3A,0x25,0x64,0x72,0x68,0x25,0x64,0x6F
	.DB  0x43,0x20,0x49,0x6E,0x3A,0x25,0x64,0x72
	.DB  0x68,0x25,0x64,0x6F,0x43,0xD,0xA,0x0
	.DB  0x3E,0x31,0x30,0x32,0x3A,0x25,0x30,0x32
	.DB  0x58,0x25,0x30,0x32,0x58,0x25,0x30,0x32
	.DB  0x58,0x25,0x30,0x32,0x58,0x25,0x30,0x32
	.DB  0x58,0x25,0x30,0x34,0x58,0x25,0x30,0x34
	.DB  0x58,0x25,0x30,0x34,0x58,0x25,0x30,0x34
	.DB  0x58,0x25,0x30,0x32,0x58,0x25,0x30,0x32
	.DB  0x58,0x25,0x30,0x32,0x58,0x21,0x3C,0x0
	.DB  0x25,0x73,0x0,0x3E,0x33,0x30,0x32,0x3A
	.DB  0x25,0x30,0x32,0x58,0x25,0x30,0x34,0x58
	.DB  0x25,0x30,0x32,0x58,0x25,0x30,0x32,0x58
	.DB  0x21,0x3C,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  _ac_index_S0000002000
	.DW  _0xA*2

	.DW  0x05
	.DW  0x03
	.DW  _0x3D*2

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
	ADD  R26,R30
	ADC  R27,R31
	LDS  R30,120
	LDS  R31,120+1
	RCALL SUBOPT_0x1
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
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0042 // Place your code here
; 0000 0043 static unsigned char ac_index=1;

	.DSEG

	.CSEG
; 0000 0044 adc_ac_volt[ac_index]=adc_data[1];
	LDS  R30,_ac_index_S0000002000
	LDI  R26,LOW(_adc_ac_volt)
	LDI  R27,HIGH(_adc_ac_volt)
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x2
	__GETW1MN _adc_data,2
	RCALL SUBOPT_0x1
; 0000 0045 if(++ac_index==9) {ac_index=1;adc_ac_volt[0]=(adc_ac_volt[1]+adc_ac_volt[2]+adc_ac_volt[3]+adc_ac_volt[4]+adc_ac_volt[5]+adc_ac_volt[6]+adc_ac_volt[7]+adc_ac_volt[8])/8;}
	LDS  R26,_ac_index_S0000002000
	SUBI R26,-LOW(1)
	STS  _ac_index_S0000002000,R26
	CPI  R26,LOW(0x9)
	BRNE _0xB
	LDI  R30,LOW(1)
	STS  _ac_index_S0000002000,R30
	__GETW2MN _adc_ac_volt,2
	__GETW1MN _adc_ac_volt,4
	RCALL SUBOPT_0x2
	__GETW1MN _adc_ac_volt,6
	RCALL SUBOPT_0x2
	__GETW1MN _adc_ac_volt,8
	RCALL SUBOPT_0x2
	__GETW1MN _adc_ac_volt,10
	RCALL SUBOPT_0x2
	__GETW1MN _adc_ac_volt,12
	RCALL SUBOPT_0x2
	__GETW1MN _adc_ac_volt,14
	RCALL SUBOPT_0x2
	__GETW1MN _adc_ac_volt,16
	RCALL SUBOPT_0x3
	RCALL __LSRW3
	STS  _adc_ac_volt,R30
	STS  _adc_ac_volt+1,R31
; 0000 0046 bts_stt_rtc.dc_vol=(int)(2.2+0.7919*adc_data[DC_ADC]); // Tinh toan dien ap DC
_0xB:
	RCALL SUBOPT_0x4
; 0000 0047             bts_stt_rtc.ac_vol=(int)(12.163 * (.2+(float)(adc_ac_volt[0])/35.503));       // TInh toan dien ap AC
; 0000 0048 flag_for_update++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 3,4,30,31
; 0000 0049 flag_for_volt++;
	__ADDWRR 5,6,30,31
; 0000 004A }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;
;
;
;//Ban tin tu MB
;char USART_DATA[50];
;unsigned char index=0;
;char *usart_p;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0055 {
_usart_rx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0056 char data;
; 0000 0057 usart_status=UCSR0A;
	ST   -Y,R17
;	data -> R17
	LDS  R8,192
; 0000 0058 data=UDR0;
	LDS  R17,198
; 0000 0059 if ((usart_status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R8
	ANDI R30,LOW(0x1C)
	BRNE _0xC
; 0000 005A    {
; 0000 005B      //Du lieu nhan duoc tu RS485 dc luu vao mang USART_DATA[50] va se xu ly sau do
; 0000 005C      USART_DATA[index++]=data;
	MOV  R30,R7
	INC  R7
	RCALL SUBOPT_0x5
	SUBI R30,LOW(-_USART_DATA)
	SBCI R31,HIGH(-_USART_DATA)
	ST   Z,R17
; 0000 005D      if(index>49) {index=0;usart_p=USART_DATA;}// Gioi han ban tin < 50 ky tu
	LDI  R30,LOW(49)
	CP   R30,R7
	BRSH _0xD
	RCALL SUBOPT_0x6
; 0000 005E    }
_0xD:
; 0000 005F }
_0xC:
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;interrupt [USART_TXC] void usart_tx_isr(void)
; 0000 0062 {
_usart_tx_isr:
; 0000 0063 RS485_TxD=0;
	CBI  0x8,5
; 0000 0064 }
	RETI
;
;
;void main(void)
; 0000 0068 {
_main:
; 0000 0069 // Declare your local variables here
; 0000 006A unsigned char usart_count;
; 0000 006B char data_buffer_to_send[50];
; 0000 006C 
; 0000 006D // Crystal Oscillator division factor: 1
; 0000 006E #pragma optsize-
; 0000 006F CLKPR=0x80;
	SBIW R28,50
;	usart_count -> R17
;	data_buffer_to_send -> Y+0
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 0070 CLKPR=0x00;
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 0071 #ifdef _OPTIMIZE_SIZE_
; 0000 0072 #pragma optsize+
; 0000 0073 #endif
; 0000 0074 
; 0000 0075 // Input/Output Ports initialization
; 0000 0076 // Port B initialization
; 0000 0077 // Func7=In Func6=In Func5=In Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0078 // State7=T State6=T State5=T State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 0079 PORTB=0x00;
	OUT  0x5,R30
; 0000 007A DDRB=0x1F;
	LDI  R30,LOW(31)
	OUT  0x4,R30
; 0000 007B 
; 0000 007C // Port C initialization
; 0000 007D // Func6=In Func5=Out Func4=In Func3=In Func2=In Func1=In Func0=Out
; 0000 007E // State6=T State5=0 State4=T State3=T State2=T State1=T State0=0
; 0000 007F PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x8,R30
; 0000 0080 DDRC=0x21;
	LDI  R30,LOW(33)
	OUT  0x7,R30
; 0000 0081 
; 0000 0082 // Port D initialization
; 0000 0083 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 0084 // State7=0 State6=0 State5=0 State4=0 State3=T State2=T State1=T State0=T
; 0000 0085 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0086 DDRD=0xF0;
	LDI  R30,LOW(240)
	OUT  0xA,R30
; 0000 0087 
; 0000 0088 
; 0000 0089 // Timer/Counter 1 initialization
; 0000 008A TCCR1A=0x00;
	LDI  R30,LOW(0)
	STS  128,R30
; 0000 008B TCCR1B=0x00;
	STS  129,R30
; 0000 008C TCNT1H=0x00;
	STS  133,R30
; 0000 008D TCNT1L=0x00;
	STS  132,R30
; 0000 008E ICR1H=0x00;
	STS  135,R30
; 0000 008F ICR1L=0x00;
	STS  134,R30
; 0000 0090 OCR1AH=0x00;
	STS  137,R30
; 0000 0091 OCR1AL=0x00;
	STS  136,R30
; 0000 0092 OCR1BH=0x00;
	STS  139,R30
; 0000 0093 OCR1BL=0x00;
	STS  138,R30
; 0000 0094 
; 0000 0095 // Timer/Counter 2 initialization
; 0000 0096 ASSR=0x00;
	STS  182,R30
; 0000 0097 TCCR2A=0x00;
	STS  176,R30
; 0000 0098 TCCR2B=0x00;
	STS  177,R30
; 0000 0099 TCNT2=0x00;
	STS  178,R30
; 0000 009A OCR2A=0x00;
	STS  179,R30
; 0000 009B OCR2B=0x00;
	STS  180,R30
; 0000 009C 
; 0000 009D // External Interrupt(s) initialization
; 0000 009E EICRA=0x00;
	STS  105,R30
; 0000 009F EIMSK=0x00;
	OUT  0x1D,R30
; 0000 00A0 PCICR=0x00;
	STS  104,R30
; 0000 00A1 
; 0000 00A2 
; 0000 00A3 // Timer/Counter 0 initialization
; 0000 00A4 // Clock source: System Clock
; 0000 00A5 // Clock value: 15.625 kHz
; 0000 00A6 // Mode: Normal top=0xFF
; 0000 00A7 // OC0A output: Disconnected
; 0000 00A8 // OC0B output: Disconnected
; 0000 00A9 TCCR0A=0x00;
	OUT  0x24,R30
; 0000 00AA TCCR0B=0x05;
	LDI  R30,LOW(5)
	OUT  0x25,R30
; 0000 00AB TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 00AC OCR0A=0x00;
	OUT  0x27,R30
; 0000 00AD OCR0B=0x00;
	OUT  0x28,R30
; 0000 00AE TIMSK0=0x01;
	LDI  R30,LOW(1)
	STS  110,R30
; 0000 00AF 
; 0000 00B0 
; 0000 00B1 // Timer/Counter 1 Interrupt(s) initialization
; 0000 00B2 TIMSK1=0x00;
	LDI  R30,LOW(0)
	STS  111,R30
; 0000 00B3 
; 0000 00B4 // Timer/Counter 2 Interrupt(s) initialization
; 0000 00B5 TIMSK2=0x00;
	STS  112,R30
; 0000 00B6 
; 0000 00B7 
; 0000 00B8 
; 0000 00B9 // USART initialization
; 0000 00BA // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 00BB // USART Receiver: On
; 0000 00BC // USART Transmitter: On
; 0000 00BD // USART0 Mode: Asynchronous
; 0000 00BE // USART Baud Rate: 115200 (Double Speed Mode)
; 0000 00BF UCSR0A=0x02;
	LDI  R30,LOW(2)
	STS  192,R30
; 0000 00C0 UCSR0B=0xD8;
	LDI  R30,LOW(216)
	STS  193,R30
; 0000 00C1 UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  194,R30
; 0000 00C2 UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  197,R30
; 0000 00C3 UBRR0L=0x10;
	LDI  R30,LOW(16)
	STS  196,R30
; 0000 00C4 
; 0000 00C5 // Analog Comparator initialization
; 0000 00C6 // Analog Comparator: Off
; 0000 00C7 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00C8 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 00C9 ADCSRB=0x00;
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 00CA DIDR1=0x00;
	STS  127,R30
; 0000 00CB 
; 0000 00CC 
; 0000 00CD // ADC initialization
; 0000 00CE // ADC Clock frequency: 1000.000 kHz
; 0000 00CF // ADC Voltage Reference: AVCC pin
; 0000 00D0 // ADC Auto Trigger Source: ADC Stopped =>> The nay no chay mi ngon =)) (Tuan da thu 06032016)
; 0000 00D1 // Digital input buffers on ADC0: On, ADC1: On, ADC2: On, ADC3: On
; 0000 00D2 // ADC4: On, ADC5: On
; 0000 00D3 DIDR0=0x00;
	STS  126,R30
; 0000 00D4 ADMUX=FIRST_ADC_INPUT | (ADC_VREF_TYPE & 0xff);
	LDI  R30,LOW(65)
	STS  124,R30
; 0000 00D5 ADCSRA=0xCC;
	LDI  R30,LOW(204)
	STS  122,R30
; 0000 00D6 
; 0000 00D7 // SPI initialization
; 0000 00D8 // SPI disabled
; 0000 00D9 SPCR=0x00;
	LDI  R30,LOW(0)
	OUT  0x2C,R30
; 0000 00DA 
; 0000 00DB // TWI initialization
; 0000 00DC // TWI disabled
; 0000 00DD TWCR=0x00;
	STS  188,R30
; 0000 00DE 
; 0000 00DF 
; 0000 00E0 delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 00E1 // Global enable interrupts
; 0000 00E2 #asm("sei")
	sei
; 0000 00E3 //ADC1 Water
; 0000 00E4 //ADC2 AC
; 0000 00E5 //ADC3 DC
; 0000 00E6 
; 0000 00E7 //Turn on power Smoke Sensor
; 0000 00E8 Smoke_Power=1;
	SBI  0x8,0
; 0000 00E9 
; 0000 00EA bts_stt_rtc.dc_vol=(int)(2.2+0.7919*adc_data[DC_ADC]); // Tinh gia tri dien ap 1 chieu
	RCALL SUBOPT_0x4
; 0000 00EB bts_stt_rtc.ac_vol=(int)(12.163 * (.2+(float)(adc_ac_volt[0])/35.503)); //Tinh gia tri dien ap xoay chieu
; 0000 00EC //RS485_TxD=1;
; 0000 00ED //delay_ms(1000);
; 0000 00EE //printf(">Volt value: %d;%d \r\n",bts_stt_rtc.dc_vol,bts_stt_rtc.ac_vol);
; 0000 00EF //RS485_TxD=0;
; 0000 00F0             if(bts_stt_rtc.dc_vol<430) Relay7=1;
	__GETW2MN _bts_stt_rtc,22
	CPI  R26,LOW(0x1AE)
	LDI  R30,HIGH(0x1AE)
	CPC  R27,R30
	BRGE _0x12
	SBI  0xB,6
; 0000 00F1             else Relay7=0;
	RJMP _0x15
_0x12:
	CBI  0xB,6
; 0000 00F2             if(bts_stt_rtc.ac_vol<180) Relay6=1;
_0x15:
	__GETW2MN _bts_stt_rtc,24
	CPI  R26,LOW(0xB4)
	LDI  R30,HIGH(0xB4)
	CPC  R27,R30
	BRGE _0x18
	SBI  0xB,7
; 0000 00F3             else Relay6=0;
	RJMP _0x1B
_0x18:
	CBI  0xB,7
; 0000 00F4             if(adc_data[Water_ADC]>1000)
_0x1B:
	LDS  R26,_adc_data
	LDS  R27,_adc_data+1
	CPI  R26,LOW(0x3E9)
	LDI  R30,HIGH(0x3E9)
	CPC  R27,R30
	BRLO _0x1E
; 0000 00F5             {
; 0000 00F6                 bts_stt_rtc.water=0;
	LDI  R30,LOW(0)
	__PUTB1MN _bts_stt_rtc,19
; 0000 00F7                 Relay1=0;
	CBI  0x5,4
; 0000 00F8             }
; 0000 00F9             else
	RJMP _0x21
_0x1E:
; 0000 00FA             {
; 0000 00FB                 bts_stt_rtc.water=1;
	LDI  R30,LOW(1)
	__PUTB1MN _bts_stt_rtc,19
; 0000 00FC                 Relay1=1;
	SBI  0x5,4
; 0000 00FD             }
_0x21:
; 0000 00FE 
; 0000 00FF bts_stt_rtc.gate=1;
	LDI  R30,LOW(1)
	__PUTB1MN _bts_stt_rtc,21
; 0000 0100 bts_stt_rtc.smoke=0;
	LDI  R30,LOW(0)
	__PUTB1MN _bts_stt_rtc,20
; 0000 0101 bts_stt_rtc.water=1;
	LDI  R30,LOW(1)
	__PUTB1MN _bts_stt_rtc,19
; 0000 0102 
; 0000 0103 usart_p=USART_DATA;
	RCALL SUBOPT_0x7
; 0000 0104 //Pull up for transmit data
; 0000 0105 RS485_TxD=1;
	SBI  0x8,5
; 0000 0106 //while(usart_status&(RX_COMPLETE));
; 0000 0107 printf("\r\n>Basic Board v1 fwv2 15/03/2016\r\n");
	__POINTW1FN _0x0,0
	RCALL SUBOPT_0x8
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
; 0000 0108 index=0;
	RCALL SUBOPT_0x6
; 0000 0109 usart_p=USART_DATA;
; 0000 010A while (1)
_0x26:
; 0000 010B       {
; 0000 010C       // Place your code here
; 0000 010D       //delay_ms(10);
; 0000 010E 
; 0000 010F       if(index>0)
	LDI  R30,LOW(0)
	CP   R30,R7
	BRLO PC+2
	RJMP _0x29
; 0000 0110             {
; 0000 0111                 if(*usart_p=='>')
	__GETW2R 9,10
	LD   R26,X
	CPI  R26,LOW(0x3E)
	BREQ PC+2
	RJMP _0x2A
; 0000 0112                 {
; 0000 0113                 if((usart_p[1]=='1')&&(usart_p[2]=='0')&&(usart_p[3]=='1')&&(usart_p[37]=='!')&&(HexInCharToDec(usart_p[36]) +  (HexInCharToDec(usart_p[35])<<4) ==101))
	RCALL SUBOPT_0x9
	LDD  R26,Z+1
	CPI  R26,LOW(0x31)
	BRNE _0x2C
	RCALL SUBOPT_0x9
	LDD  R26,Z+2
	CPI  R26,LOW(0x30)
	BRNE _0x2C
	RCALL SUBOPT_0x9
	LDD  R26,Z+3
	CPI  R26,LOW(0x31)
	BRNE _0x2C
	RCALL SUBOPT_0x9
	LDD  R26,Z+37
	CPI  R26,LOW(0x21)
	BRNE _0x2C
	RCALL SUBOPT_0x9
	LDD  R26,Z+36
	RCALL SUBOPT_0xA
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x9
	LDD  R26,Z+35
	RCALL SUBOPT_0xA
	RCALL __LSLW4
	POP  R26
	POP  R27
	RCALL SUBOPT_0x2
	CPI  R26,LOW(0x65)
	LDI  R30,HIGH(0x65)
	CPC  R27,R30
	BREQ _0x2D
_0x2C:
	RJMP _0x2B
_0x2D:
; 0000 0114                             {   //Decoding data >101[][][]!<
; 0000 0115                                 bts_stt_rtc.bts_rtc.hr         = HexInCharToDec(usart_p[6]) +  (HexInCharToDec(usart_p[5])<<4);
	RCALL SUBOPT_0x9
	LDD  R26,Z+6
	RCALL _HexInCharToDec
	PUSH R30
	RCALL SUBOPT_0x9
	LDD  R26,Z+5
	RCALL SUBOPT_0xB
	POP  R26
	ADD  R30,R26
	__PUTB1MN _bts_stt_rtc,2
; 0000 0116                                 bts_stt_rtc.bts_rtc.min       = HexInCharToDec(usart_p[8]) +  (HexInCharToDec(usart_p[7])<<4);
	RCALL SUBOPT_0x9
	LDD  R26,Z+8
	RCALL _HexInCharToDec
	PUSH R30
	RCALL SUBOPT_0x9
	LDD  R26,Z+7
	RCALL SUBOPT_0xB
	POP  R26
	ADD  R30,R26
	__PUTB1MN _bts_stt_rtc,1
; 0000 0117                                 bts_stt_rtc.bts_rtc.date      = HexInCharToDec(usart_p[10]) +  (HexInCharToDec(usart_p[9])<<4);
	RCALL SUBOPT_0x9
	LDD  R26,Z+10
	RCALL _HexInCharToDec
	PUSH R30
	RCALL SUBOPT_0x9
	LDD  R26,Z+9
	RCALL SUBOPT_0xB
	POP  R26
	ADD  R30,R26
	__PUTB1MN _bts_stt_rtc,4
; 0000 0118                                 bts_stt_rtc.bts_rtc.month   = HexInCharToDec(usart_p[12]) +  (HexInCharToDec(usart_p[11])<<4);
	RCALL SUBOPT_0x9
	LDD  R26,Z+12
	RCALL _HexInCharToDec
	PUSH R30
	RCALL SUBOPT_0x9
	LDD  R26,Z+11
	RCALL SUBOPT_0xB
	POP  R26
	ADD  R30,R26
	__PUTB1MN _bts_stt_rtc,5
; 0000 0119                                 bts_stt_rtc.bts_rtc.year      = HexInCharToDec(usart_p[14]) +  (HexInCharToDec(usart_p[13])<<4);
	RCALL SUBOPT_0x9
	LDD  R26,Z+14
	RCALL _HexInCharToDec
	PUSH R30
	RCALL SUBOPT_0x9
	LDD  R26,Z+13
	RCALL SUBOPT_0xB
	POP  R26
	ADD  R30,R26
	__PUTB1MN _bts_stt_rtc,6
; 0000 011A                                 bts_stt_rtc.Ex_Sensor.humi=((HexInCharToDec(usart_p[16])+(HexInCharToDec(usart_p[15])<<4))<<8)+HexInCharToDec(usart_p[18])+16*HexInCharToDec(usart_p[17]);
	RCALL SUBOPT_0x9
	LDD  R26,Z+16
	RCALL SUBOPT_0xA
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x9
	LDD  R26,Z+15
	RCALL SUBOPT_0xA
	RCALL __LSLW4
	POP  R26
	POP  R27
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0xC
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x9
	LDD  R26,Z+18
	RCALL SUBOPT_0xA
	POP  R26
	POP  R27
	RCALL SUBOPT_0xD
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x9
	LDD  R26,Z+17
	RCALL SUBOPT_0xE
	POP  R26
	POP  R27
	RCALL SUBOPT_0xD
	__PUTW1MN _bts_stt_rtc,17
; 0000 011B                                 bts_stt_rtc.Ex_Sensor.temp=((HexInCharToDec(usart_p[20])+(HexInCharToDec(usart_p[19])<<4))<<8)+HexInCharToDec(usart_p[22])+16*HexInCharToDec(usart_p[21]);
	RCALL SUBOPT_0x9
	LDD  R26,Z+20
	RCALL SUBOPT_0xA
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x9
	LDD  R26,Z+19
	RCALL SUBOPT_0xA
	RCALL __LSLW4
	POP  R26
	POP  R27
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0xC
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x9
	LDD  R26,Z+22
	RCALL SUBOPT_0xA
	POP  R26
	POP  R27
	RCALL SUBOPT_0xD
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x9
	LDD  R26,Z+21
	RCALL SUBOPT_0xE
	POP  R26
	POP  R27
	RCALL SUBOPT_0xD
	__PUTW1MN _bts_stt_rtc,15
; 0000 011C                                 bts_stt_rtc.Int_Sensor.humi=((HexInCharToDec(usart_p[24])+(HexInCharToDec(usart_p[23])<<4))<<8)+HexInCharToDec(usart_p[26])+16*HexInCharToDec(usart_p[25]);
	RCALL SUBOPT_0x9
	LDD  R26,Z+24
	RCALL SUBOPT_0xA
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x9
	LDD  R26,Z+23
	RCALL SUBOPT_0xA
	RCALL __LSLW4
	POP  R26
	POP  R27
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0xC
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x9
	LDD  R26,Z+26
	RCALL SUBOPT_0xA
	POP  R26
	POP  R27
	RCALL SUBOPT_0xD
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x9
	LDD  R26,Z+25
	RCALL SUBOPT_0xE
	POP  R26
	POP  R27
	RCALL SUBOPT_0xD
	__PUTW1MN _bts_stt_rtc,13
; 0000 011D                                 bts_stt_rtc.Int_Sensor.temp=((HexInCharToDec(usart_p[28])+(HexInCharToDec(usart_p[27])<<4))<<8)+HexInCharToDec(usart_p[30])+16*HexInCharToDec(usart_p[29]);
	RCALL SUBOPT_0x9
	LDD  R26,Z+28
	RCALL SUBOPT_0xA
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x9
	LDD  R26,Z+27
	RCALL SUBOPT_0xA
	RCALL __LSLW4
	POP  R26
	POP  R27
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0xC
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x9
	LDD  R26,Z+30
	RCALL SUBOPT_0xA
	POP  R26
	POP  R27
	RCALL SUBOPT_0xD
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x9
	LDD  R26,Z+29
	RCALL SUBOPT_0xE
	POP  R26
	POP  R27
	RCALL SUBOPT_0xD
	__PUTW1MN _bts_stt_rtc,11
; 0000 011E                             //delay_ms(10);
; 0000 011F                             RS485_TxD=1;
	SBI  0x8,5
; 0000 0120                             printf("\r\nex:%drh%doC In:%drh%doC\r\n",bts_stt_rtc.Ex_Sensor.humi,bts_stt_rtc.Ex_Sensor.temp,bts_stt_rtc.Int_Sensor.humi,bts_stt_rtc.Int_Sensor.temp);
	__POINTW1FN _0x0,36
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0xF
	LDI  R24,16
	RCALL _printf
	ADIW R28,18
; 0000 0121                             for(usart_count=0;usart_count<50;usart_count++)
	LDI  R17,LOW(0)
_0x31:
	CPI  R17,50
	BRSH _0x32
; 0000 0122                             {
; 0000 0123                             USART_DATA[usart_count]=0;
	MOV  R30,R17
	RCALL SUBOPT_0x5
	SUBI R30,LOW(-_USART_DATA)
	SBCI R31,HIGH(-_USART_DATA)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0124                             }
	SUBI R17,-1
	RJMP _0x31
_0x32:
; 0000 0125                             index=0;
	RCALL SUBOPT_0x6
; 0000 0126                             usart_p=USART_DATA;
; 0000 0127                             }
; 0000 0128                 }
_0x2B:
; 0000 0129                 else if(usart_p<(USART_DATA+50))usart_p++;  //Scan for '<'
	RJMP _0x33
_0x2A:
	__POINTW1MN _USART_DATA,50
	CP   R9,R30
	CPC  R10,R31
	BRSH _0x34
	RCALL SUBOPT_0x9
	ADIW R30,1
	__PUTW1R 9,10
	SBIW R30,1
; 0000 012A                 else usart_p=USART_DATA;
	RJMP _0x35
_0x34:
	RCALL SUBOPT_0x7
; 0000 012B             }
_0x35:
_0x33:
; 0000 012C 
; 0000 012D 
; 0000 012E         if(flag_for_update>2200)// 30s update
_0x29:
	LDI  R30,LOW(2200)
	LDI  R31,HIGH(2200)
	CP   R30,R3
	CPC  R31,R4
	BRGE _0x36
; 0000 012F       {
; 0000 0130             sprintf(data_buffer_to_send,">102:%02X%02X%02X%02X%02X%04X%04X%04X%04X%02X%02X%02X!<",
; 0000 0131             bts_stt_rtc.bts_rtc.hr,bts_stt_rtc.bts_rtc.min,
; 0000 0132 	        bts_stt_rtc.bts_rtc.date,bts_stt_rtc.bts_rtc.month,bts_stt_rtc.bts_rtc.year,
; 0000 0133 	        bts_stt_rtc.Ex_Sensor.humi,
; 0000 0134 	        bts_stt_rtc.Ex_Sensor.temp,
; 0000 0135 	        bts_stt_rtc.Int_Sensor.humi,
; 0000 0136 	        bts_stt_rtc.Int_Sensor.temp,
; 0000 0137 	        (bts_stt_rtc.gate<<2)+(bts_stt_rtc.smoke<<1)+bts_stt_rtc.water,60,102);
	MOVW R30,R28
	RCALL SUBOPT_0x8
	__POINTW1FN _0x0,64
	RCALL SUBOPT_0x8
	__GETB1MN _bts_stt_rtc,2
	RCALL SUBOPT_0x10
	__GETB1MN _bts_stt_rtc,1
	RCALL SUBOPT_0x10
	__GETB1MN _bts_stt_rtc,4
	RCALL SUBOPT_0x10
	__GETB1MN _bts_stt_rtc,5
	RCALL SUBOPT_0x10
	__GETB1MN _bts_stt_rtc,6
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0xF
	__GETB1MN _bts_stt_rtc,21
	RCALL SUBOPT_0x5
	RCALL __LSLW2
	MOVW R26,R30
	__GETB1MN _bts_stt_rtc,20
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x2
	__GETB1MN _bts_stt_rtc,19
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x11
	__GETD1N 0x3C
	RCALL SUBOPT_0x12
	LDI  R24,48
	RCALL _sprintf
	ADIW R28,52
; 0000 0138 
; 0000 0139             RS485_TxD=1;
	RCALL SUBOPT_0x13
; 0000 013A             printf("%s",data_buffer_to_send);
; 0000 013B 
; 0000 013C             //printf( ">BMS:%c.%c.%c.%c.%c!<",bts_stt_rtc.ac_vol,bts_stt_rtc.dc_vol>>8,bts_stt_rtc.dc_vol,(bts_stt_rtc.gate<<2)+(bts_stt_rtc.smoke<<1)+bts_stt_rtc.water,123);
; 0000 013D             //RS485_TxD=0;
; 0000 013E             flag_for_update=0;
	CLR  R3
	CLR  R4
; 0000 013F       }
; 0000 0140       if(flag_for_volt>1200)
_0x36:
	LDI  R30,LOW(1200)
	LDI  R31,HIGH(1200)
	CP   R30,R5
	CPC  R31,R6
	BRGE _0x39
; 0000 0141       {
; 0000 0142             //">302:[ac_vol].[dc_vol_H].[dc_vol_L].[alarm][check_sum]!<"
; 0000 0143 
; 0000 0144             //>3XX:[hr][][][][][][][][][DC]!<
; 0000 0145             sprintf(data_buffer_to_send,">302:%02X%04X%02X%02X!<",
; 0000 0146                                                         bts_stt_rtc.ac_vol,bts_stt_rtc.dc_vol,
; 0000 0147                                                         61,102);
	MOVW R30,R28
	RCALL SUBOPT_0x8
	__POINTW1FN _0x0,123
	RCALL SUBOPT_0x8
	__GETW1MN _bts_stt_rtc,24
	RCALL SUBOPT_0x11
	__GETW1MN _bts_stt_rtc,22
	RCALL SUBOPT_0x11
	__GETD1N 0x3D
	RCALL SUBOPT_0x12
	LDI  R24,16
	RCALL _sprintf
	ADIW R28,20
; 0000 0148             RS485_TxD=1;
	RCALL SUBOPT_0x13
; 0000 0149             printf("%s",data_buffer_to_send);
; 0000 014A             flag_for_volt=0;
	CLR  R5
	CLR  R6
; 0000 014B       }
; 0000 014C 
; 0000 014D 
; 0000 014E       }
_0x39:
	RJMP _0x26
; 0000 014F }
_0x3C:
	RJMP _0x3C
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
	RCALL SUBOPT_0x14
	LDD  R26,Y+2
	RCALL _putchar
	LD   R26,Y
	LDD  R27,Y+1
	RCALL SUBOPT_0x15
	ADIW R28,3
	RET
_put_buff_G100:
	RCALL SUBOPT_0x14
	RCALL __SAVELOCR2
	RCALL SUBOPT_0x16
	ADIW R26,2
	RCALL __GETW1P
	SBIW R30,0
	BREQ _0x2000016
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x17
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
	RCALL SUBOPT_0x16
	ADIW R26,2
	RCALL SUBOPT_0x15
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	RCALL SUBOPT_0x16
	RCALL __GETW1P
	TST  R31
	BRMI _0x200001A
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x15
_0x200001A:
_0x2000019:
	RJMP _0x200001B
_0x2000016:
	RCALL SUBOPT_0x16
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RCALL SUBOPT_0x1
_0x200001B:
	RCALL __LOADLOCR2
	ADIW R28,5
	RET
__print_G100:
	RCALL SUBOPT_0x14
	SBIW R28,6
	RCALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RCALL SUBOPT_0x1
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
	RCALL SUBOPT_0x18
_0x2000024:
	RJMP _0x2000021
_0x2000022:
	CPI  R30,LOW(0x1)
	BRNE _0x2000025
	CPI  R18,37
	BRNE _0x2000026
	RCALL SUBOPT_0x18
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
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x19
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0x1B
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x73)
	BRNE _0x2000038
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x1E
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2000039
_0x2000038:
	CPI  R30,LOW(0x70)
	BRNE _0x200003B
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x1E
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
	RCALL SUBOPT_0x1F
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
	RCALL SUBOPT_0x1F
	LDI  R17,LOW(4)
_0x2000043:
	SBRS R16,2
	RJMP _0x2000048
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x20
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000049
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	RCALL __ANEGW1
	RCALL SUBOPT_0x20
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
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x20
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
	RCALL SUBOPT_0x18
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
	RCALL SUBOPT_0x1F
	RJMP _0x200005A
_0x2000059:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x200005A:
	RCALL SUBOPT_0x18
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
	RCALL SUBOPT_0x1F
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
	RCALL SUBOPT_0x20
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
	RCALL SUBOPT_0x1B
	CPI  R21,0
	BREQ _0x2000071
	SUBI R21,LOW(1)
_0x2000071:
_0x2000070:
_0x200006F:
_0x2000067:
	RCALL SUBOPT_0x18
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
	RCALL SUBOPT_0x1B
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
	RCALL SUBOPT_0x21
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
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x1F
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL SUBOPT_0x22
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	RCALL SUBOPT_0x8
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
	RCALL SUBOPT_0x22
	LDI  R30,LOW(_put_usart_G100)
	LDI  R31,HIGH(_put_usart_G100)
	RCALL SUBOPT_0x8
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
	RCALL SUBOPT_0x14
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
	RCALL SUBOPT_0x14
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
_adc_ac_volt:
	.BYTE 0x12
_input_index_S0000001000:
	.BYTE 0x1
_ac_index_S0000002000:
	.BYTE 0x1
_USART_DATA:
	.BYTE 0x32

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x0:
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x2:
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	RCALL SUBOPT_0x2
	MOVW R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:48 WORDS
SUBOPT_0x4:
	__GETW1MN _adc_data,4
	CLR  R22
	CLR  R23
	RCALL __CDF1
	__GETD2N 0x3F4AB9F5
	RCALL __MULF12
	__GETD2N 0x400CCCCD
	RCALL __ADDF12
	RCALL __CFD1
	__PUTW1MN _bts_stt_rtc,22
	LDS  R30,_adc_ac_volt
	LDS  R31,_adc_ac_volt+1
	CLR  R22
	CLR  R23
	RCALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x420E0312
	RCALL __DIVF21
	__GETD2N 0x3E4CCCCD
	RCALL __ADDF12
	__GETD2N 0x41429BA6
	RCALL __MULF12
	RCALL __CFD1
	__PUTW1MN _bts_stt_rtc,24
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:32 WORDS
SUBOPT_0x5:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x6:
	CLR  R7
	LDI  R30,LOW(_USART_DATA)
	LDI  R31,HIGH(_USART_DATA)
	__PUTW1R 9,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(_USART_DATA)
	LDI  R31,HIGH(_USART_DATA)
	__PUTW1R 9,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 33 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x9:
	__GETW1R 9,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xA:
	RCALL _HexInCharToDec
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xB:
	RCALL _HexInCharToDec
	SWAP R30
	ANDI R30,0xF0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	MOV  R31,R30
	LDI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xD:
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xE:
	RCALL _HexInCharToDec
	LDI  R26,LOW(16)
	MUL  R30,R26
	MOVW R30,R0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0xF:
	__GETW1MN _bts_stt_rtc,17
	RCALL __CWD1
	RCALL __PUTPARD1
	__GETW1MN _bts_stt_rtc,15
	RCALL __CWD1
	RCALL __PUTPARD1
	__GETW1MN _bts_stt_rtc,13
	RCALL __CWD1
	RCALL __PUTPARD1
	__GETW1MN _bts_stt_rtc,11
	RCALL __CWD1
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x10:
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x11:
	RCALL __CWD1
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	RCALL __PUTPARD1
	__GETD1N 0x66
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x13:
	SBI  0x8,5
	__POINTW1FN _0x0,120
	RCALL SUBOPT_0x8
	MOVW R30,R28
	ADIW R30,2
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	LDI  R24,4
	RCALL _printf
	ADIW R28,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x15:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x16:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x17:
	ADIW R26,4
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x18:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x19:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1A:
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1B:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	RCALL SUBOPT_0x19
	RJMP SUBOPT_0x1A

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1D:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1F:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	MOVW R26,R28
	ADIW R26,12
	RCALL __ADDW2R15
	RCALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x22:
	RCALL __ADDW2R15
	RCALL __GETW1P
	RCALL SUBOPT_0x8
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

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

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

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
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

__LSRW3:
	LSR  R31
	ROR  R30
__LSRW2:
	LSR  R31
	ROR  R30
	LSR  R31
	ROR  R30
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
