
;CodeVisionAVR C Compiler V2.05.3 Standard
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega88PA
;Program type             : Application
;Clock frequency          : 20.000000 MHz
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

	#pragma AVRPART ADMIN PART_NAME ATmega88PA
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
	.DEF _index=R4
	.DEF _process_CMD=R3
	.DEF _have_data=R6
	.DEF _LG_STT=R5
	.DEF _LG_TEMP=R8

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
	RJMP 0x00
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

_0x35:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0
_0x0:
	.DB  0x3E,0x49,0x4F,0x20,0x42,0x6F,0x61,0x72
	.DB  0x64,0x20,0x76,0x31,0x20,0x66,0x77,0x76
	.DB  0x32,0xD,0xA,0x0,0x3E,0x25,0x63,0x25
	.DB  0x63,0xD,0xA,0x0

__GLOBAL_INI_TBL:
	.DW  0x06
	.DW  0x03
	.DW  _0x35*2

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
;Project :
;Version :
;Date    : 9/30/2015
;Author  : Tuan
;Company : ATTECH
;Comments:
;
;
;Chip type               : ATmega88PA
;Program type            : Application
;AVR Core Clock frequency: 20.000000 MHz
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
;// Define hardware
;#define Relay1 PORTD.3
;#define Relay2 PORTD.2
;#define Relay3 PORTC.5
;#define Relay4 PORTC.4
;#define Relay5 PORTC.3
;#define Relay6 PORTC.2
;#define Relay7 PORTC.1
;#define Relay8 PORTC.0
;#define RUN PORTB.5
;
;#define LG_IN_1 PIND.4
;#define LG_IN_2 PIND.5
;#define LG_IN_3 PIND.6
;#define LG_IN_4 PIND.7
;#define LG_IN_5 PINB.0
;#define LG_IN_6 PINB.1
;#define LG_IN_7 PINB.2
;#define LG_IN_8 PINB.3
;#define GET_LG_STT (LG_IN_1<<7)+(LG_IN_2<<6)+(LG_IN_3<<5)+(LG_IN_4<<4)+(LG_IN_5<<3)+(LG_IN_6<<2)+(LG_IN_7<<1)+LG_IN_8
;#define GET_RL_STT (Relay1<<7)+(Relay2<<6)+(Relay3<<5)+(Relay4<<4)+(Relay5<<3)+(Relay6<<2)+(Relay7<<1)+Relay8
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
;char CMD[7]={0,0,0,0,0,0,0};
;unsigned char index=0,process_CMD=0,have_data=0;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0056 {

	.CSEG
_usart_rx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0057 char status,data;
; 0000 0058 status=UCSR0A;
	RCALL __SAVELOCR2
;	status -> R17
;	data -> R16
	LDS  R17,192
; 0000 0059 data=UDR0;
	LDS  R16,198
; 0000 005A if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
; 0000 005B    {
; 0000 005C    //>r 0xBB 0x0D 0x0A: Ban tin dieu khien relay
; 0000 005D    //>s 0x0D 0x0A: Ban tin lay trang thai IO_BOARD
; 0000 005E      if((have_data==1)&&(data==0x0A)) process_CMD=1;
	LDI  R30,LOW(1)
	CP   R30,R6
	BRNE _0x5
	CPI  R16,10
	BREQ _0x6
_0x5:
	RJMP _0x4
_0x6:
	LDI  R30,LOW(1)
	MOV  R3,R30
; 0000 005F      if(data=='>') have_data=1;//Bat dau ghi cmd
_0x4:
	CPI  R16,62
	BRNE _0x7
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 0060      if(have_data==1)
_0x7:
	LDI  R30,LOW(1)
	CP   R30,R6
	BRNE _0x8
; 0000 0061      {
; 0000 0062      CMD[index++]=data;
	MOV  R30,R4
	INC  R4
	RCALL SUBOPT_0x0
	ST   Z,R16
; 0000 0063      if(index==7) index=0;// Gioi han ban tin < 7 ky tu
	LDI  R30,LOW(7)
	CP   R30,R4
	BRNE _0x9
	CLR  R4
; 0000 0064      }
_0x9:
; 0000 0065    }
_0x8:
; 0000 0066 }
_0x3:
	RCALL __LOADLOCR2P
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;
;
;// Declare your global variables here
;unsigned char LG_STT=0,LG_TEMP=0;// Trang thai cua muc logic
;void main(void)
; 0000 006D {
_main:
; 0000 006E // Declare your local variables here
; 0000 006F 
; 0000 0070 // Crystal Oscillator division factor: 1
; 0000 0071 #pragma optsize-
; 0000 0072 CLKPR=0x80;
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 0073 CLKPR=0x00;
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 0074 #ifdef _OPTIMIZE_SIZE_
; 0000 0075 #pragma optsize+
; 0000 0076 #endif
; 0000 0077 
; 0000 0078 // Input/Output Ports initialization
; 0000 0079 // Port B initialization
; 0000 007A // Func7=In Func6=In Func5=Out Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 007B // State7=T State6=T State5=0 State4=T State3=T State2=T State1=T State0=T
; 0000 007C PORTB=0x00;
	OUT  0x5,R30
; 0000 007D DDRB=0x20;
	LDI  R30,LOW(32)
	OUT  0x4,R30
; 0000 007E 
; 0000 007F // Port C initialization
; 0000 0080 // Func6=In Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0081 // State6=T State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 0082 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x8,R30
; 0000 0083 DDRC=0x3F;
	LDI  R30,LOW(63)
	OUT  0x7,R30
; 0000 0084 
; 0000 0085 // Port D initialization
; 0000 0086 // Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=In Func0=In
; 0000 0087 // State7=T State6=T State5=T State4=T State3=0 State2=0 State1=T State0=T
; 0000 0088 PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0089 DDRD=0x0C;
	LDI  R30,LOW(12)
	OUT  0xA,R30
; 0000 008A 
; 0000 008B // Timer/Counter 0 initialization
; 0000 008C // Clock source: System Clock
; 0000 008D // Clock value: Timer 0 Stopped
; 0000 008E // Mode: Normal top=0xFF
; 0000 008F // OC0A output: Disconnected
; 0000 0090 // OC0B output: Disconnected
; 0000 0091 TCCR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 0092 TCCR0B=0x00;
	OUT  0x25,R30
; 0000 0093 TCNT0=0x00;
	OUT  0x26,R30
; 0000 0094 OCR0A=0x00;
	OUT  0x27,R30
; 0000 0095 OCR0B=0x00;
	OUT  0x28,R30
; 0000 0096 
; 0000 0097 // Timer/Counter 1 initialization
; 0000 0098 // Clock source: System Clock
; 0000 0099 // Clock value: Timer1 Stopped
; 0000 009A // Mode: Normal top=0xFFFF
; 0000 009B // OC1A output: Discon.
; 0000 009C // OC1B output: Discon.
; 0000 009D // Noise Canceler: Off
; 0000 009E // Input Capture on Falling Edge
; 0000 009F // Timer1 Overflow Interrupt: Off
; 0000 00A0 // Input Capture Interrupt: Off
; 0000 00A1 // Compare A Match Interrupt: Off
; 0000 00A2 // Compare B Match Interrupt: Off
; 0000 00A3 TCCR1A=0x00;
	STS  128,R30
; 0000 00A4 TCCR1B=0x00;
	STS  129,R30
; 0000 00A5 TCNT1H=0x00;
	STS  133,R30
; 0000 00A6 TCNT1L=0x00;
	STS  132,R30
; 0000 00A7 ICR1H=0x00;
	STS  135,R30
; 0000 00A8 ICR1L=0x00;
	STS  134,R30
; 0000 00A9 OCR1AH=0x00;
	STS  137,R30
; 0000 00AA OCR1AL=0x00;
	STS  136,R30
; 0000 00AB OCR1BH=0x00;
	STS  139,R30
; 0000 00AC OCR1BL=0x00;
	STS  138,R30
; 0000 00AD 
; 0000 00AE // Timer/Counter 2 initialization
; 0000 00AF // Clock source: System Clock
; 0000 00B0 // Clock value: Timer2 Stopped
; 0000 00B1 // Mode: Normal top=0xFF
; 0000 00B2 // OC2A output: Disconnected
; 0000 00B3 // OC2B output: Disconnected
; 0000 00B4 ASSR=0x00;
	STS  182,R30
; 0000 00B5 TCCR2A=0x00;
	STS  176,R30
; 0000 00B6 TCCR2B=0x00;
	STS  177,R30
; 0000 00B7 TCNT2=0x00;
	STS  178,R30
; 0000 00B8 OCR2A=0x00;
	STS  179,R30
; 0000 00B9 OCR2B=0x00;
	STS  180,R30
; 0000 00BA 
; 0000 00BB // External Interrupt(s) initialization
; 0000 00BC // INT0: Off
; 0000 00BD // INT1: Off
; 0000 00BE // Interrupt on any change on pins PCINT0-7: Off
; 0000 00BF // Interrupt on any change on pins PCINT8-14: Off
; 0000 00C0 // Interrupt on any change on pins PCINT16-23: Off
; 0000 00C1 EICRA=0x00;
	STS  105,R30
; 0000 00C2 EIMSK=0x00;
	OUT  0x1D,R30
; 0000 00C3 PCICR=0x00;
	STS  104,R30
; 0000 00C4 
; 0000 00C5 // Timer/Counter 0 Interrupt(s) initialization
; 0000 00C6 TIMSK0=0x00;
	STS  110,R30
; 0000 00C7 
; 0000 00C8 // Timer/Counter 1 Interrupt(s) initialization
; 0000 00C9 TIMSK1=0x00;
	STS  111,R30
; 0000 00CA 
; 0000 00CB // Timer/Counter 2 Interrupt(s) initialization
; 0000 00CC TIMSK2=0x00;
	STS  112,R30
; 0000 00CD 
; 0000 00CE // USART initialization
; 0000 00CF // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 00D0 // USART Receiver: On
; 0000 00D1 // USART Transmitter: On
; 0000 00D2 // USART0 Mode: Asynchronous
; 0000 00D3 // USART Baud Rate: 19200
; 0000 00D4 UCSR0A=0x00;
	STS  192,R30
; 0000 00D5 UCSR0B=0x98;
	LDI  R30,LOW(152)
	STS  193,R30
; 0000 00D6 UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  194,R30
; 0000 00D7 UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  197,R30
; 0000 00D8 UBRR0L=0x40;
	LDI  R30,LOW(64)
	STS  196,R30
; 0000 00D9 
; 0000 00DA // Analog Comparator initialization
; 0000 00DB // Analog Comparator: Off
; 0000 00DC // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00DD ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x30,R30
; 0000 00DE ADCSRB=0x00;
	LDI  R30,LOW(0)
	STS  123,R30
; 0000 00DF DIDR1=0x00;
	STS  127,R30
; 0000 00E0 
; 0000 00E1 // ADC initialization
; 0000 00E2 // ADC disabled
; 0000 00E3 ADCSRA=0x00;
	STS  122,R30
; 0000 00E4 
; 0000 00E5 // SPI initialization
; 0000 00E6 // SPI disabled
; 0000 00E7 SPCR=0x00;
	OUT  0x2C,R30
; 0000 00E8 
; 0000 00E9 // TWI initialization
; 0000 00EA // TWI disabled
; 0000 00EB TWCR=0x00;
	STS  188,R30
; 0000 00EC // Global enable interrupts
; 0000 00ED #asm("sei")
	sei
; 0000 00EE Relay1=1;
	SBI  0xB,3
; 0000 00EF delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL _delay_ms
; 0000 00F0 printf(">IO Board v1 fwv2\r\n");
	__POINTW1FN _0x0,0
	RCALL SUBOPT_0x1
	LDI  R24,0
	RCALL _printf
	ADIW R28,2
; 0000 00F1 //Doc trang thai cac cong logic luc khoi tao
; 0000 00F2 LG_STT=GET_LG_STT;
	RCALL SUBOPT_0x2
	MOV  R5,R30
; 0000 00F3 delay_ms(100);
	LDI  R26,LOW(100)
	LDI  R27,0
	RCALL _delay_ms
; 0000 00F4 printf(">%c%c\r\n",GET_LG_STT,GET_RL_STT);
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x6
; 0000 00F5 while (1)
_0xC:
; 0000 00F6       {
; 0000 00F7       // Place your code here
; 0000 00F8 
; 0000 00F9            if(process_CMD)
	TST  R3
	BRNE PC+2
	RJMP _0xF
; 0000 00FA            {
; 0000 00FB                 RUN=1;
	SBI  0x5,5
; 0000 00FC                 //printf("%s",CMD);
; 0000 00FD                 if((CMD[0]=='>')&&(CMD[1]=='s') ) printf(">%c%c\r\n",GET_LG_STT,GET_RL_STT);
	LDS  R26,_CMD
	CPI  R26,LOW(0x3E)
	BRNE _0x13
	__GETB2MN _CMD,1
	CPI  R26,LOW(0x73)
	BREQ _0x14
_0x13:
	RJMP _0x12
_0x14:
	RJMP _0x34
; 0000 00FE                 else if((CMD[0]=='>')&&(CMD[1]=='r'))
_0x12:
	LDS  R26,_CMD
	CPI  R26,LOW(0x3E)
	BRNE _0x17
	__GETB2MN _CMD,1
	CPI  R26,LOW(0x72)
	BREQ _0x18
_0x17:
	RJMP _0x16
_0x18:
; 0000 00FF                 {
; 0000 0100                     Relay1=CMD[2]&0x80;
	RCALL SUBOPT_0x7
	ANDI R30,LOW(0x80)
	BRNE _0x19
	CBI  0xB,3
	RJMP _0x1A
_0x19:
	SBI  0xB,3
_0x1A:
; 0000 0101                     Relay2=CMD[2]&0x40;
	RCALL SUBOPT_0x7
	ANDI R30,LOW(0x40)
	BRNE _0x1B
	CBI  0xB,2
	RJMP _0x1C
_0x1B:
	SBI  0xB,2
_0x1C:
; 0000 0102                     Relay3=CMD[2]&0x20;
	RCALL SUBOPT_0x7
	ANDI R30,LOW(0x20)
	BRNE _0x1D
	CBI  0x8,5
	RJMP _0x1E
_0x1D:
	SBI  0x8,5
_0x1E:
; 0000 0103                     Relay4=CMD[2]&0x10;
	RCALL SUBOPT_0x7
	ANDI R30,LOW(0x10)
	BRNE _0x1F
	CBI  0x8,4
	RJMP _0x20
_0x1F:
	SBI  0x8,4
_0x20:
; 0000 0104                     Relay5=CMD[2]&0x8;
	RCALL SUBOPT_0x7
	ANDI R30,LOW(0x8)
	BRNE _0x21
	CBI  0x8,3
	RJMP _0x22
_0x21:
	SBI  0x8,3
_0x22:
; 0000 0105                     Relay6=CMD[2]&0x4;
	RCALL SUBOPT_0x7
	ANDI R30,LOW(0x4)
	BRNE _0x23
	CBI  0x8,2
	RJMP _0x24
_0x23:
	SBI  0x8,2
_0x24:
; 0000 0106                     Relay7=CMD[2]&0x2;
	RCALL SUBOPT_0x7
	ANDI R30,LOW(0x2)
	BRNE _0x25
	CBI  0x8,1
	RJMP _0x26
_0x25:
	SBI  0x8,1
_0x26:
; 0000 0107                     Relay8=CMD[2]&0x1;
	RCALL SUBOPT_0x7
	ANDI R30,LOW(0x1)
	BRNE _0x27
	CBI  0x8,0
	RJMP _0x28
_0x27:
	SBI  0x8,0
_0x28:
; 0000 0108                     printf(">%c%c\r\n",GET_LG_STT,GET_RL_STT);
_0x34:
	__POINTW1FN _0x0,20
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x6
; 0000 0109                 }
; 0000 010A                 for(index=0;index<7;index++)
_0x16:
	CLR  R4
_0x2A:
	LDI  R30,LOW(7)
	CP   R4,R30
	BRSH _0x2B
; 0000 010B                 {
; 0000 010C                     CMD[index]=0;
	MOV  R30,R4
	RCALL SUBOPT_0x0
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 010D                 }
	INC  R4
	RJMP _0x2A
_0x2B:
; 0000 010E                 index=0;
	CLR  R4
; 0000 010F                 process_CMD=0;
	CLR  R3
; 0000 0110                 have_data=0;
	CLR  R6
; 0000 0111                 RUN=0;
	CBI  0x5,5
; 0000 0112            }
; 0000 0113 
; 0000 0114             LG_TEMP=GET_LG_STT;
_0xF:
	RCALL SUBOPT_0x2
	MOV  R8,R30
; 0000 0115             if(LG_TEMP!=LG_STT)
	CP   R5,R8
	BREQ _0x2E
; 0000 0116                 {
; 0000 0117                     RUN=1;
	SBI  0x5,5
; 0000 0118                     printf(">%c%c\r\n",GET_LG_STT,GET_RL_STT);
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x6
; 0000 0119                     LG_STT=LG_TEMP;
	MOV  R5,R8
; 0000 011A                     RUN=0;
	CBI  0x5,5
; 0000 011B                 }
; 0000 011C 
; 0000 011D       }
_0x2E:
	RJMP _0xC
; 0000 011E }
_0x33:
	RJMP _0x33
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
	RCALL SUBOPT_0x8
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
	RCALL SUBOPT_0x8
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
	RCALL SUBOPT_0x9
_0x2000024:
	RJMP _0x2000021
_0x2000022:
	CPI  R30,LOW(0x1)
	BRNE _0x2000025
	CPI  R18,37
	BRNE _0x2000026
	RCALL SUBOPT_0x9
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
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xA
	LDD  R26,Z+4
	ST   -Y,R26
	RCALL SUBOPT_0xC
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x73)
	BRNE _0x2000038
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xE
	RCALL _strlen
	MOV  R17,R30
	RJMP _0x2000039
_0x2000038:
	CPI  R30,LOW(0x70)
	BRNE _0x200003B
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0xE
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
	RCALL SUBOPT_0xF
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
	RCALL SUBOPT_0xF
	LDI  R17,LOW(4)
_0x2000043:
	SBRS R16,2
	RJMP _0x2000048
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x10
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
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x10
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
	RCALL SUBOPT_0x9
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
	RCALL SUBOPT_0xF
	RJMP _0x200005A
_0x2000059:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x200005A:
	RCALL SUBOPT_0x9
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
	RCALL SUBOPT_0xF
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
	RCALL SUBOPT_0xC
	CPI  R21,0
	BREQ _0x2000071
	SUBI R21,LOW(1)
_0x2000071:
_0x2000070:
_0x200006F:
_0x2000067:
	RCALL SUBOPT_0x9
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
	RCALL SUBOPT_0xC
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
	RCALL SUBOPT_0x1
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_usart_G100)
	LDI  R31,HIGH(_put_usart_G100)
	RCALL SUBOPT_0x1
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
	RCALL SUBOPT_0x8
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
	RCALL SUBOPT_0x8
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
_CMD:
	.BYTE 0x7

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	LDI  R31,0
	SUBI R30,LOW(-_CMD)
	SBCI R31,HIGH(-_CMD)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:226 WORDS
SUBOPT_0x2:
	LDI  R26,0
	SBIC 0x9,4
	LDI  R26,1
	MOV  R30,R26
	ROR  R30
	LDI  R30,0
	ROR  R30
	MOV  R0,R30
	LDI  R26,0
	SBIC 0x9,5
	LDI  R26,1
	MOV  R30,R26
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	LSL  R30
	ADD  R0,R30
	LDI  R26,0
	SBIC 0x9,6
	LDI  R26,1
	MOV  R30,R26
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	ADD  R0,R30
	LDI  R26,0
	SBIC 0x9,7
	LDI  R26,1
	MOV  R30,R26
	SWAP R30
	ANDI R30,0xF0
	ADD  R0,R30
	LDI  R26,0
	SBIC 0x3,0
	LDI  R26,1
	MOV  R30,R26
	LSL  R30
	LSL  R30
	LSL  R30
	ADD  R0,R30
	LDI  R26,0
	SBIC 0x3,1
	LDI  R26,1
	MOV  R30,R26
	LSL  R30
	LSL  R30
	ADD  R0,R30
	LDI  R26,0
	SBIC 0x3,2
	LDI  R26,1
	MOV  R30,R26
	LSL  R30
	MOV  R26,R0
	ADD  R26,R30
	LDI  R30,0
	SBIC 0x3,3
	LDI  R30,1
	ADD  R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	__POINTW1FN _0x0,20
	RCALL SUBOPT_0x1
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4:
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:114 WORDS
SUBOPT_0x5:
	LDI  R26,0
	SBIC 0xB,3
	LDI  R26,1
	MOV  R30,R26
	ROR  R30
	LDI  R30,0
	ROR  R30
	MOV  R0,R30
	LDI  R26,0
	SBIC 0xB,2
	LDI  R26,1
	MOV  R30,R26
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	LSL  R30
	ADD  R0,R30
	LDI  R26,0
	SBIC 0x8,5
	LDI  R26,1
	MOV  R30,R26
	SWAP R30
	ANDI R30,0xF0
	LSL  R30
	ADD  R0,R30
	LDI  R26,0
	SBIC 0x8,4
	LDI  R26,1
	MOV  R30,R26
	SWAP R30
	ANDI R30,0xF0
	ADD  R0,R30
	LDI  R26,0
	SBIC 0x8,3
	LDI  R26,1
	MOV  R30,R26
	LSL  R30
	LSL  R30
	LSL  R30
	ADD  R0,R30
	LDI  R26,0
	SBIC 0x8,2
	LDI  R26,1
	MOV  R30,R26
	LSL  R30
	LSL  R30
	ADD  R0,R30
	LDI  R26,0
	SBIC 0x8,1
	LDI  R26,1
	MOV  R30,R26
	LSL  R30
	MOV  R26,R0
	ADD  R26,R30
	LDI  R30,0
	SBIC 0x8,0
	LDI  R30,1
	ADD  R30,R26
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	LDI  R24,8
	RCALL _printf
	ADIW R28,10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7:
	__GETB1MN _CMD,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	ST   -Y,R27
	ST   -Y,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x9:
	ST   -Y,R18
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xB:
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xC:
	LDD  R26,Y+13
	LDD  R27,Y+13+1
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	RCALL SUBOPT_0xA
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xE:
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
SUBOPT_0xF:
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x10:
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
	__DELAY_USW 0x1388
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
