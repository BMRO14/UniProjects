
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Release
;Chip type              : ATmega164A
;Program type           : Application
;Clock frequency        : 20.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : float, width, precision
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': No
;'char' is unsigned     : No
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega164A
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

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
	.EQU GPIOR1=0x2A
	.EQU GPIOR2=0x2B

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
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
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
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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
	CALL __PUTDP1
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

;GPIOR0-GPIOR2 INITIALIZATION VALUES
	.EQU __GPIOR0_INIT=0x00
	.EQU __GPIOR1_INIT=0x00
	.EQU __GPIOR2_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0x0:
	.DB  0x41,0x6C,0x63,0x6F,0x68,0x6F,0x6C,0x20
	.DB  0x4C,0x65,0x76,0x65,0x6C,0x3A,0x0,0x41
	.DB  0x6C,0x63,0x6F,0x68,0x6F,0x6C,0x3A,0x20
	.DB  0x25,0x2E,0x32,0x66,0x6D,0x67,0x2F,0x4C
	.DB  0xD,0xA,0x0
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x2080060:
	.DB  0x1
_0x2080000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x0F
	.DW  _0x28
	.DW  _0x0*2

	.DW  0x01
	.DW  __seed_G104
	.DW  _0x2080060*2

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

;GPIOR0-GPIOR2 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30
	;__GPIOR1_INIT = __GPIOR0_INIT
	OUT  GPIOR1,R30
	;__GPIOR2_INIT = __GPIOR0_INIT
	OUT  GPIOR2,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 1

	.DSEG
	.ORG 0x200

	.CSEG
;#include <mega164a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif
;#include <delay.h>
;#include <stdio.h>
;#include <stdint.h>
;#include <math.h>
;
;// LCD I2C Definitions
;#define LCD_I2C_ADDR 0x27
;#define LCD_BACKLIGHT 0x08
;
;#ifndef TWEN
;    #define TWSTO 4
;    #define TWSTA 5
;    #define TWEN  2
;    #define TWINT 7
;#endif
;
;#define F_CPU 20000000UL
;#define BAUD 9600
;#define UBRR_VALUE ((F_CPU / (16UL * BAUD)) - 1)
;#define RL_VALUE 10000.0
;#define R0_VALUE 8000.0
;#define A_CONST 0.4
;#define B_CONST 0.4
;#define ADC_MAX 1023
;
;void uart_init(void) {
; 0000 001B void uart_init(void) {

	.CSEG
_uart_init:
; .FSTART _uart_init
; 0000 001C     UBRR0H = (unsigned char)(UBRR_VALUE >> 8);
	LDI  R30,LOW(0)
	STS  197,R30
; 0000 001D     UBRR0L = (unsigned char)(UBRR_VALUE & 0xFF);
	LDI  R30,LOW(129)
	STS  196,R30
; 0000 001E     UCSR0B = (1 << 3);
	LDI  R30,LOW(8)
	STS  193,R30
; 0000 001F     UCSR0C = (1 << 2) | (1 << 1);
	LDI  R30,LOW(6)
	STS  194,R30
; 0000 0020 }
	RET
; .FEND
;
;void uart_send(char c) {
; 0000 0022 void uart_send(char c) {
_uart_send:
; .FSTART _uart_send
; 0000 0023     while (!(UCSR0A & (1 << 5)));
	ST   -Y,R26
;	c -> Y+0
_0x3:
	LDS  R30,192
	ANDI R30,LOW(0x20)
	BREQ _0x3
; 0000 0024     UDR0 = c;
	LD   R30,Y
	STS  198,R30
; 0000 0025 }
	RJMP _0x20A000C
; .FEND
;
;void uart_print(const char *str) {
; 0000 0027 void uart_print(const char *str) {
_uart_print:
; .FSTART _uart_print
; 0000 0028     while (*str) uart_send(*str++);
	ST   -Y,R27
	ST   -Y,R26
;	*str -> Y+0
_0x6:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x8
	CALL SUBOPT_0x0
	RCALL _uart_send
	RJMP _0x6
_0x8:
; 0000 0029 }
	RJMP _0x20A000A
; .FEND
;
;void adc_init(void) {
; 0000 002B void adc_init(void) {
_adc_init:
; .FSTART _adc_init
; 0000 002C     ADMUX = (1 << 6);
	LDI  R30,LOW(64)
	STS  124,R30
; 0000 002D     ADCSRA = (1 << 7) | (1 << 2) | (1 << 1);
	LDI  R30,LOW(134)
	STS  122,R30
; 0000 002E }
	RET
; .FEND
;
;uint16_t adc_read(void) {
; 0000 0030 uint16_t adc_read(void) {
_adc_read:
; .FSTART _adc_read
; 0000 0031     ADCSRA |= (1 << 6);
	LDS  R30,122
	ORI  R30,0x40
	STS  122,R30
; 0000 0032     while (ADCSRA & (1 << 6));
_0x9:
	LDS  R30,122
	ANDI R30,LOW(0x40)
	BRNE _0x9
; 0000 0033     return ADCW;
	LDS  R30,120
	LDS  R31,120+1
	RET
; 0000 0034 }
; .FEND
;
;void I2C_Write(uint8_t data) {
; 0000 0036 void I2C_Write(uint8_t data) {
_I2C_Write:
; .FSTART _I2C_Write
; 0000 0037     TWDR = data;
	ST   -Y,R26
;	data -> Y+0
	LD   R30,Y
	STS  187,R30
; 0000 0038     TWCR = (1 << TWEN) | (1 << TWINT);
	LDI  R30,LOW(132)
	STS  188,R30
; 0000 0039     while (!(TWCR & (1 << TWINT)));
_0xC:
	LDS  R30,188
	ANDI R30,LOW(0x80)
	BREQ _0xC
; 0000 003A }
	RJMP _0x20A000C
; .FEND
;
;void LCD_I2C_Start() {
; 0000 003C void LCD_I2C_Start() {
_LCD_I2C_Start:
; .FSTART _LCD_I2C_Start
; 0000 003D     TWCR = (1 << TWSTA) | (1 << TWEN) | (1 << TWINT);
	LDI  R30,LOW(164)
	STS  188,R30
; 0000 003E     while (!(TWCR & (1 << TWINT)));
_0xF:
	LDS  R30,188
	ANDI R30,LOW(0x80)
	BREQ _0xF
; 0000 003F }
	RET
; .FEND
;
;void LCD_I2C_Stop() {
; 0000 0041 void LCD_I2C_Stop() {
_LCD_I2C_Stop:
; .FSTART _LCD_I2C_Stop
; 0000 0042     TWCR = (1 << TWSTO) | (1 << TWEN) | (1 << TWINT);
	LDI  R30,LOW(148)
	STS  188,R30
; 0000 0043     delay_us(10);
	__DELAY_USB 67
; 0000 0044 }
	RET
; .FEND
;
;void LCD_I2C_Send(uint8_t data) {
; 0000 0046 void LCD_I2C_Send(uint8_t data) {
_LCD_I2C_Send:
; .FSTART _LCD_I2C_Send
; 0000 0047     I2C_Write(data);
	ST   -Y,R26
;	data -> Y+0
	LD   R26,Y
	RCALL _I2C_Write
; 0000 0048 }
	RJMP _0x20A000C
; .FEND
;
;void LCD_Send4Bits(uint8_t data) {
; 0000 004A void LCD_Send4Bits(uint8_t data) {
_LCD_Send4Bits:
; .FSTART _LCD_Send4Bits
; 0000 004B     LCD_I2C_Send(data | LCD_BACKLIGHT | 0x04);
	ST   -Y,R26
;	data -> Y+0
	LD   R30,Y
	ORI  R30,LOW(0xC)
	MOV  R26,R30
	RCALL _LCD_I2C_Send
; 0000 004C     delay_us(1);
	__DELAY_USB 7
; 0000 004D     LCD_I2C_Send(data | LCD_BACKLIGHT);
	LD   R30,Y
	ORI  R30,8
	MOV  R26,R30
	RCALL _LCD_I2C_Send
; 0000 004E     delay_us(50);
	__DELAY_USW 250
; 0000 004F }
_0x20A000C:
	ADIW R28,1
	RET
; .FEND
;
;void LCD_WriteCmd(uint8_t cmd) {
; 0000 0051 void LCD_WriteCmd(uint8_t cmd) {
_LCD_WriteCmd:
; .FSTART _LCD_WriteCmd
; 0000 0052     uint8_t high = cmd & 0xF0;
; 0000 0053     uint8_t low = (cmd << 4) & 0xF0;
; 0000 0054     LCD_I2C_Start();
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	cmd -> Y+2
;	high -> R17
;	low -> R16
	LDD  R30,Y+2
	ANDI R30,LOW(0xF0)
	MOV  R17,R30
	LDD  R30,Y+2
	SWAP R30
	ANDI R30,LOW(0xF0)
	CALL SUBOPT_0x1
; 0000 0055     I2C_Write(LCD_I2C_ADDR << 1);
; 0000 0056     LCD_Send4Bits(high);
; 0000 0057     LCD_Send4Bits(low);
; 0000 0058     LCD_I2C_Stop();
; 0000 0059     delay_ms(2);
; 0000 005A }
	RJMP _0x20A000B
; .FEND
;
;void LCD_WriteData(uint8_t data) {
; 0000 005C void LCD_WriteData(uint8_t data) {
_LCD_WriteData:
; .FSTART _LCD_WriteData
; 0000 005D     uint8_t high = (data & 0xF0) | 0x01;
; 0000 005E     uint8_t low = ((data << 4) & 0xF0) | 0x01;
; 0000 005F     LCD_I2C_Start();
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
;	data -> Y+2
;	high -> R17
;	low -> R16
	LDD  R30,Y+2
	ANDI R30,LOW(0xF0)
	ORI  R30,1
	MOV  R17,R30
	LDD  R30,Y+2
	SWAP R30
	ANDI R30,LOW(0xF0)
	ORI  R30,1
	CALL SUBOPT_0x1
; 0000 0060     I2C_Write(LCD_I2C_ADDR << 1);
; 0000 0061     LCD_Send4Bits(high);
; 0000 0062     LCD_Send4Bits(low);
; 0000 0063     LCD_I2C_Stop();
; 0000 0064     delay_ms(2);
; 0000 0065 }
	RJMP _0x20A000B
; .FEND
;
;void LCD_Clear() {
; 0000 0067 void LCD_Clear() {
_LCD_Clear:
; .FSTART _LCD_Clear
; 0000 0068     LCD_WriteCmd(0x01);
	LDI  R26,LOW(1)
	RCALL _LCD_WriteCmd
; 0000 0069     delay_ms(2);
	LDI  R26,LOW(2)
	RJMP _0x20A0009
; 0000 006A }
; .FEND
;
;void LCD_SetCursor(uint8_t col, uint8_t row) {
; 0000 006C void LCD_SetCursor(uint8_t col, uint8_t row) {
_LCD_SetCursor:
; .FSTART _LCD_SetCursor
; 0000 006D     uint8_t addr = (row == 0) ? 0x80 + col : 0xC0 + col;
; 0000 006E     LCD_WriteCmd(addr);
	ST   -Y,R26
	ST   -Y,R17
;	col -> Y+2
;	row -> Y+1
;	addr -> R17
	LDD  R26,Y+1
	CPI  R26,LOW(0x0)
	BRNE _0x12
	LDD  R30,Y+2
	SUBI R30,-LOW(128)
	RJMP _0x13
_0x12:
	LDD  R30,Y+2
	SUBI R30,-LOW(192)
_0x13:
	MOV  R17,R30
	MOV  R26,R17
	RCALL _LCD_WriteCmd
; 0000 006F }
	LDD  R17,Y+0
_0x20A000B:
	ADIW R28,3
	RET
; .FEND
;
;void LCD_Print(char *str) {
; 0000 0071 void LCD_Print(char *str) {
_LCD_Print:
; .FSTART _LCD_Print
; 0000 0072     while (*str) {
	ST   -Y,R27
	ST   -Y,R26
;	*str -> Y+0
_0x15:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x17
; 0000 0073         LCD_WriteData(*str++);
	CALL SUBOPT_0x0
	RCALL _LCD_WriteData
; 0000 0074     }
	RJMP _0x15
_0x17:
; 0000 0075 }
_0x20A000A:
	ADIW R28,2
	RET
; .FEND
;
;void LCD_Init() {
; 0000 0077 void LCD_Init() {
_LCD_Init:
; .FSTART _LCD_Init
; 0000 0078     TWSR = 0x00;
	LDI  R30,LOW(0)
	STS  185,R30
; 0000 0079     TWBR = 32;
	LDI  R30,LOW(32)
	STS  184,R30
; 0000 007A     delay_ms(50);
	LDI  R26,LOW(50)
	LDI  R27,0
	CALL _delay_ms
; 0000 007B 
; 0000 007C     LCD_WriteCmd(0x33);
	LDI  R26,LOW(51)
	RCALL _LCD_WriteCmd
; 0000 007D     LCD_WriteCmd(0x32);
	LDI  R26,LOW(50)
	RCALL _LCD_WriteCmd
; 0000 007E     LCD_WriteCmd(0x28);
	LDI  R26,LOW(40)
	RCALL _LCD_WriteCmd
; 0000 007F     LCD_WriteCmd(0x0C);
	LDI  R26,LOW(12)
	RCALL _LCD_WriteCmd
; 0000 0080     LCD_WriteCmd(0x06);
	LDI  R26,LOW(6)
	RCALL _LCD_WriteCmd
; 0000 0081     LCD_WriteCmd(0x01);
	LDI  R26,LOW(1)
	RCALL _LCD_WriteCmd
; 0000 0082     delay_ms(5);
	LDI  R26,LOW(5)
_0x20A0009:
	LDI  R27,0
	CALL _delay_ms
; 0000 0083 }
	RET
; .FEND
;
;void LCD_DrawBargraph(float value, float max_value) {
; 0000 0085 void LCD_DrawBargraph(float value, float max_value) {
_LCD_DrawBargraph:
; .FSTART _LCD_DrawBargraph
; 0000 0086     uint8_t bar_length = 16;
; 0000 0087     uint8_t filled = 0;
; 0000 0088     uint8_t i;
; 0000 0089 
; 0000 008A     if (value <= 0.0f) {
	CALL __PUTPARD2
	CALL __SAVELOCR4
;	value -> Y+8
;	max_value -> Y+4
;	bar_length -> R17
;	filled -> R16
;	i -> R19
	LDI  R17,16
	LDI  R16,0
	CALL SUBOPT_0x2
	CALL __CPD02
	BRLT _0x18
; 0000 008B         filled = 0; // Empty bar at 0
	LDI  R16,LOW(0)
; 0000 008C     } else if (value >= max_value) {
	RJMP _0x19
_0x18:
	CALL SUBOPT_0x3
	CALL __CMPF12
	BRLO _0x1A
; 0000 008D         filled = bar_length; // Full bar at or above max_value
	MOV  R16,R17
; 0000 008E     } else {
	RJMP _0x1B
_0x1A:
; 0000 008F         filled = (uint8_t)((value / max_value) * bar_length + 0.5f);
	CALL SUBOPT_0x3
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	MOV  R30,R17
	CALL SUBOPT_0x4
	CALL SUBOPT_0x5
	CALL __CFD1U
	MOV  R16,R30
; 0000 0090     }
_0x1B:
_0x19:
; 0000 0091 
; 0000 0092     for (i = 0; i < bar_length; i++) {
	LDI  R19,LOW(0)
_0x1D:
	CP   R19,R17
	BRSH _0x1E
; 0000 0093         if (i < filled) LCD_WriteData(0xFF);
	CP   R19,R16
	BRSH _0x1F
	LDI  R26,LOW(255)
	RJMP _0x2A
; 0000 0094         else LCD_WriteData(' ');
_0x1F:
	LDI  R26,LOW(32)
_0x2A:
	RCALL _LCD_WriteData
; 0000 0095     }
	SUBI R19,-1
	RJMP _0x1D
_0x1E:
; 0000 0096 }
	CALL __LOADLOCR4
	ADIW R28,12
	RET
; .FEND
;
;void main(void) {
; 0000 0098 void main(void) {
_main:
; .FSTART _main
; 0000 0099     char buffer[32];
; 0000 009A     uint16_t adc_val;
; 0000 009B     float rs, rs_r0, ppm, mg_per_l;
; 0000 009C 
; 0000 009D     uart_init();
	SBIW R28,48
;	buffer -> Y+16
;	adc_val -> R16,R17
;	rs -> Y+12
;	rs_r0 -> Y+8
;	ppm -> Y+4
;	mg_per_l -> Y+0
	RCALL _uart_init
; 0000 009E     adc_init();
	RCALL _adc_init
; 0000 009F     LCD_Init();
	RCALL _LCD_Init
; 0000 00A0 
; 0000 00A1     while (1) {
_0x21:
; 0000 00A2         adc_val = adc_read();
	RCALL _adc_read
	MOVW R16,R30
; 0000 00A3 
; 0000 00A4         if (adc_val == 0) {
	MOV  R0,R16
	OR   R0,R17
	BRNE _0x24
; 0000 00A5             mg_per_l = 0.0;
	LDI  R30,LOW(0)
	CALL __CLRD1S0
; 0000 00A6         } else {
	RJMP _0x25
_0x24:
; 0000 00A7             rs = RL_VALUE * ((float)ADC_MAX / adc_val - 1.0);
	MOVW R30,R16
	CLR  R22
	CLR  R23
	CALL __CDF1
	__GETD2N 0x447FC000
	CALL __DIVF21
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x6
	CALL SUBOPT_0x7
	__GETD2N 0x461C4000
	CALL SUBOPT_0x8
; 0000 00A8             rs_r0 = rs / R0_VALUE;
	CALL SUBOPT_0x9
	__GETD1N 0x45FA0000
	CALL __DIVF21
	__PUTD1S 8
; 0000 00A9             ppm = pow(rs_r0 / A_CONST, 1.0 / -B_CONST);
	CALL SUBOPT_0x2
	__GETD1N 0x3ECCCCCD
	CALL __DIVF21
	CALL __PUTPARD1
	__GETD2N 0xC0200000
	CALL _pow
	CALL SUBOPT_0xA
; 0000 00AA             mg_per_l = ppm * 1.884;
	CALL SUBOPT_0xB
	__GETD1N 0x3FF126E9
	CALL __MULF12
	CALL SUBOPT_0xC
; 0000 00AB         }
_0x25:
; 0000 00AC 
; 0000 00AD         if (mg_per_l < 0.0) mg_per_l = 0.0;
	LDD  R26,Y+3
	TST  R26
	BRPL _0x26
	LDI  R30,LOW(0)
	CALL __CLRD1S0
; 0000 00AE         if (mg_per_l > 10.0) mg_per_l = 10.0;
_0x26:
	CALL __GETD2S0
	CALL SUBOPT_0xD
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x27
	CALL SUBOPT_0xD
	CALL SUBOPT_0xC
; 0000 00AF 
; 0000 00B0         LCD_Clear();
_0x27:
	RCALL _LCD_Clear
; 0000 00B1         LCD_SetCursor(0, 0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL _LCD_SetCursor
; 0000 00B2         LCD_Print("Alcohol Level:");
	__POINTW2MN _0x28,0
	RCALL _LCD_Print
; 0000 00B3 
; 0000 00B4         LCD_SetCursor(0, 1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R26,LOW(1)
	RCALL _LCD_SetCursor
; 0000 00B5         LCD_DrawBargraph(mg_per_l, 1.0); // bar max at 1.0mg/L
	CALL SUBOPT_0xE
	CALL __PUTPARD1
	CALL SUBOPT_0xF
	RCALL _LCD_DrawBargraph
; 0000 00B6 
; 0000 00B7         sprintf(buffer, "Alcohol: %.2fmg/L\r\n", mg_per_l);
	MOVW R30,R28
	ADIW R30,16
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,15
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x10
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 00B8         uart_print(buffer);
	MOVW R26,R28
	ADIW R26,16
	RCALL _uart_print
; 0000 00B9 
; 0000 00BA         delay_ms(1000);
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	CALL _delay_ms
; 0000 00BB     }
	RJMP _0x21
; 0000 00BC }
_0x29:
	RJMP _0x29
; .FEND

	.DSEG
_0x28:
	.BYTE 0xF
;/* initialization file */
;
;#include <mega164a.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif
;#include "defs.h"
;
;
;/*
; * most intialization values are generated using Code Wizard and depend on clock value
; */
;void Init_initController(void)
; 0001 000B {

	.CSEG
; 0001 000C // Crystal Oscillator division factor: 1
; 0001 000D #pragma optsize-
; 0001 000E CLKPR=0x80;
; 0001 000F CLKPR=0x00;
; 0001 0010 #ifdef _OPTIMIZE_SIZE_
; 0001 0011 #pragma optsize+
; 0001 0012 #endif
; 0001 0013 
; 0001 0014 // Input/Output Ports initialization
; 0001 0015 // Port A initialization
; 0001 0016 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0001 0017 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0001 0018 PORTA=0x00;
; 0001 0019 DDRA=0x00;
; 0001 001A 
; 0001 001B // Port B initialization
; 0001 001C PORTB=0x00;
; 0001 001D DDRB=0x00;
; 0001 001E 
; 0001 001F // Port C initialization
; 0001 0020 PORTC=0x00;
; 0001 0021 DDRC=0x00;
; 0001 0022 
; 0001 0023 // Port D initialization
; 0001 0024 PORTD=0b00100000; // D.5 needs pull-up resistor
; 0001 0025 DDRD= 0b01010000; // D.6 is LED, D.4 is test output
; 0001 0026 
; 0001 0027 // Timer/Counter 0 initialization
; 0001 0028 // Clock source: System Clock
; 0001 0029 // Clock value: Timer 0 Stopped
; 0001 002A // Mode: Normal top=FFh
; 0001 002B // OC0 output: Disconnected
; 0001 002C TCCR0A=0x00;
; 0001 002D TCCR0B=0x00;
; 0001 002E TCNT0=0x00;
; 0001 002F OCR0A=0x00;
; 0001 0030 OCR0B=0x00;
; 0001 0031 
; 0001 0032 // Timer/Counter 1 initialization
; 0001 0033 // Clock source: System Clock
; 0001 0034 // Clock value: 19.531 kHz = CLOCK/256
; 0001 0035 // Mode: CTC top=OCR1A
; 0001 0036 // OC1A output: Discon.
; 0001 0037 // OC1B output: Discon.
; 0001 0038 // Noise Canceler: Off
; 0001 0039 // Input Capture on Falling Edge
; 0001 003A // Timer 1 Overflow Interrupt: Off
; 0001 003B // Input Capture Interrupt: Off
; 0001 003C // Compare A Match Interrupt: On
; 0001 003D // Compare B Match Interrupt: Off
; 0001 003E 
; 0001 003F TCCR1A=0x00;
; 0001 0040 TCCR1B=0x0D;
; 0001 0041 TCNT1H=0x00;
; 0001 0042 TCNT1L=0x00;
; 0001 0043 ICR1H=0x00;
; 0001 0044 ICR1L=0x00;
; 0001 0045 
; 0001 0046 // 1 sec = 19531 counts = 4C41H counts, from 0 to 4C40
; 0001 0047 // 4C40H = 4CH (MSB) and 40H (LSB)
; 0001 0048 OCR1AH=0x4C;
; 0001 0049 OCR1AL=0x40;
; 0001 004A 
; 0001 004B OCR1BH=0x00;
; 0001 004C OCR1BL=0x00;
; 0001 004D 
; 0001 004E // Timer/Counter 2 initialization
; 0001 004F // Clock source: System Clock
; 0001 0050 // Clock value: Timer2 Stopped
; 0001 0051 // Mode: Normal top=0xFF
; 0001 0052 // OC2A output: Disconnected
; 0001 0053 // OC2B output: Disconnected
; 0001 0054 ASSR=0x00;
; 0001 0055 TCCR2A=0x00;
; 0001 0056 TCCR2B=0x00;
; 0001 0057 TCNT2=0x00;
; 0001 0058 OCR2A=0x00;
; 0001 0059 OCR2B=0x00;
; 0001 005A 
; 0001 005B // External Interrupt(s) initialization
; 0001 005C // INT0: Off
; 0001 005D // INT1: Off
; 0001 005E // INT2: Off
; 0001 005F // Interrupt on any change on pins PCINT0-7: Off
; 0001 0060 // Interrupt on any change on pins PCINT8-15: Off
; 0001 0061 // Interrupt on any change on pins PCINT16-23: Off
; 0001 0062 // Interrupt on any change on pins PCINT24-31: Off
; 0001 0063 EICRA=0x00;
; 0001 0064 EIMSK=0x00;
; 0001 0065 PCICR=0x00;
; 0001 0066 
; 0001 0067 // Timer/Counter 0,1,2 Interrupt(s) initialization
; 0001 0068 TIMSK0=0x00;
; 0001 0069 TIMSK1=0x02;
; 0001 006A TIMSK2=0x00;
; 0001 006B 
; 0001 006C // USART0 initialization
; 0001 006D // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0001 006E // USART0 Receiver: On
; 0001 006F // USART0 Transmitter: On
; 0001 0070 // USART0 Mode: Asynchronous
; 0001 0071 // USART0 Baud rate: 9600
; 0001 0072 UCSR0A=0x00;
; 0001 0073 UCSR0B=0xD8;
; 0001 0074 UCSR0C=0x06;
; 0001 0075 UBRR0H=0x00;
; 0001 0076 UBRR0L=0x81;
; 0001 0077 
; 0001 0078 // USART1 initialization
; 0001 0079 // USART1 disabled
; 0001 007A UCSR1B=0x00;
; 0001 007B 
; 0001 007C 
; 0001 007D // Analog Comparator initialization
; 0001 007E // Analog Comparator: Off
; 0001 007F // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0001 0080 ACSR=0x80;
; 0001 0081 ADCSRB=0x00;
; 0001 0082 DIDR1=0x00;
; 0001 0083 
; 0001 0084 // Watchdog Timer initialization
; 0001 0085 // Watchdog Timer Prescaler: OSC/2048
; 0001 0086 #pragma optsize-
; 0001 0087 #asm("wdr")
; 0001 0088 // Write 2 consecutive values to enable watchdog
; 0001 0089 // this is NOT a mistake !
; 0001 008A WDTCSR=0x18;
; 0001 008B WDTCSR=0x08;
; 0001 008C #ifdef _OPTIMIZE_SIZE_
; 0001 008D #pragma optsize+
; 0001 008E #endif
; 0001 008F 
; 0001 0090 }
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x01
	.EQU __sm_mask=0x0E
	.EQU __sm_powerdown=0x04
	.EQU __sm_powersave=0x06
	.EQU __sm_standby=0x0C
	.EQU __sm_ext_standby=0x0E
	.EQU __sm_adc_noise_red=0x02
	.SET power_ctrl_reg=smcr
	#endif

	.CSEG
_put_buff_G100:
; .FSTART _put_buff_G100
	ST   -Y,R27
	ST   -Y,R26
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2000016
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
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
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x11
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
_0x2000019:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x200001A
	CALL SUBOPT_0x11
_0x200001A:
	RJMP _0x200001B
_0x2000016:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x200001B:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
; .FEND
__ftoe_G100:
; .FSTART __ftoe_G100
	CALL SUBOPT_0x12
	LDI  R30,LOW(128)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	CALL __SAVELOCR4
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x200001F
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2000000,0
	CALL _strcpyf
	RJMP _0x20A0008
_0x200001F:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x200001E
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ST   -Y,R31
	ST   -Y,R30
	__POINTW2FN _0x2000000,1
	CALL _strcpyf
	RJMP _0x20A0008
_0x200001E:
	LDD  R26,Y+11
	CPI  R26,LOW(0x7)
	BRLO _0x2000021
	LDI  R30,LOW(6)
	STD  Y+11,R30
_0x2000021:
	LDD  R17,Y+11
_0x2000022:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2000024
	CALL SUBOPT_0x13
	RJMP _0x2000022
_0x2000024:
	__GETD1S 12
	CALL __CPD10
	BRNE _0x2000025
	LDI  R19,LOW(0)
	CALL SUBOPT_0x13
	RJMP _0x2000026
_0x2000025:
	LDD  R19,Y+11
	CALL SUBOPT_0x14
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2000027
	CALL SUBOPT_0x13
_0x2000028:
	CALL SUBOPT_0x14
	BRLO _0x200002A
	CALL SUBOPT_0x15
	SUBI R19,-LOW(1)
	RJMP _0x2000028
_0x200002A:
	RJMP _0x200002B
_0x2000027:
_0x200002C:
	CALL SUBOPT_0x14
	BRSH _0x200002E
	CALL SUBOPT_0x9
	CALL SUBOPT_0xD
	CALL SUBOPT_0x8
	SUBI R19,LOW(1)
	RJMP _0x200002C
_0x200002E:
	CALL SUBOPT_0x13
_0x200002B:
	__GETD1S 12
	__GETD2N 0x3F000000
	CALL __ADDF12
	__PUTD1S 12
	CALL SUBOPT_0x14
	BRLO _0x200002F
	CALL SUBOPT_0x15
	SUBI R19,-LOW(1)
_0x200002F:
_0x2000026:
	LDI  R17,LOW(0)
_0x2000030:
	LDD  R30,Y+11
	CP   R30,R17
	BRLO _0x2000032
	CALL SUBOPT_0xB
	CALL SUBOPT_0x16
	CALL SUBOPT_0x5
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	CALL SUBOPT_0xA
	CALL SUBOPT_0x10
	CALL SUBOPT_0x9
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	CALL SUBOPT_0x17
	CALL SUBOPT_0x18
	CALL SUBOPT_0x4
	CALL SUBOPT_0x19
	CALL SUBOPT_0x9
	CALL SUBOPT_0x7
	__PUTD1S 12
	MOV  R30,R17
	SUBI R17,-1
	CPI  R30,0
	BRNE _0x2000030
	CALL SUBOPT_0x17
	LDI  R30,LOW(46)
	ST   X,R30
	RJMP _0x2000030
_0x2000032:
	CALL SUBOPT_0x1A
	SBIW R30,1
	LDD  R26,Y+10
	STD  Z+0,R26
	CPI  R19,0
	BRGE _0x2000034
	NEG  R19
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(45)
	RJMP _0x2000119
_0x2000034:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(43)
_0x2000119:
	ST   X,R30
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1A
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __DIVB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	CALL SUBOPT_0x1A
	SBIW R30,1
	MOVW R22,R30
	MOV  R26,R19
	LDI  R30,LOW(10)
	CALL __MODB21
	SUBI R30,-LOW(48)
	MOVW R26,R22
	ST   X,R30
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20A0008:
	CALL __LOADLOCR4
	ADIW R28,16
	RET
; .FEND
__print_G100:
; .FSTART __print_G100
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,63
	SBIW R28,17
	CALL __SAVELOCR6
	LDI  R17,0
	__GETW1SX 88
	STD  Y+8,R30
	STD  Y+8+1,R31
	__GETW1SX 86
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000036:
	MOVW R26,R28
	SUBI R26,LOW(-(92))
	SBCI R27,HIGH(-(92))
	CALL SUBOPT_0x11
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+2
	RJMP _0x2000038
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200003C
	CPI  R18,37
	BRNE _0x200003D
	LDI  R17,LOW(1)
	RJMP _0x200003E
_0x200003D:
	CALL SUBOPT_0x1B
_0x200003E:
	RJMP _0x200003B
_0x200003C:
	CPI  R30,LOW(0x1)
	BRNE _0x200003F
	CPI  R18,37
	BRNE _0x2000040
	CALL SUBOPT_0x1B
	RJMP _0x200011A
_0x2000040:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+21,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000041
	LDI  R16,LOW(1)
	RJMP _0x200003B
_0x2000041:
	CPI  R18,43
	BRNE _0x2000042
	LDI  R30,LOW(43)
	STD  Y+21,R30
	RJMP _0x200003B
_0x2000042:
	CPI  R18,32
	BRNE _0x2000043
	LDI  R30,LOW(32)
	STD  Y+21,R30
	RJMP _0x200003B
_0x2000043:
	RJMP _0x2000044
_0x200003F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000045
_0x2000044:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000046
	ORI  R16,LOW(128)
	RJMP _0x200003B
_0x2000046:
	RJMP _0x2000047
_0x2000045:
	CPI  R30,LOW(0x3)
	BRNE _0x2000048
_0x2000047:
	CPI  R18,48
	BRLO _0x200004A
	CPI  R18,58
	BRLO _0x200004B
_0x200004A:
	RJMP _0x2000049
_0x200004B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200003B
_0x2000049:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x200004C
	LDI  R17,LOW(4)
	RJMP _0x200003B
_0x200004C:
	RJMP _0x200004D
_0x2000048:
	CPI  R30,LOW(0x4)
	BRNE _0x200004F
	CPI  R18,48
	BRLO _0x2000051
	CPI  R18,58
	BRLO _0x2000052
_0x2000051:
	RJMP _0x2000050
_0x2000052:
	ORI  R16,LOW(32)
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x200003B
_0x2000050:
_0x200004D:
	CPI  R18,108
	BRNE _0x2000053
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x200003B
_0x2000053:
	RJMP _0x2000054
_0x200004F:
	CPI  R30,LOW(0x5)
	BREQ PC+2
	RJMP _0x200003B
_0x2000054:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2000059
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1C
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x1E
	RJMP _0x200005A
_0x2000059:
	CPI  R30,LOW(0x45)
	BREQ _0x200005D
	CPI  R30,LOW(0x65)
	BRNE _0x200005E
_0x200005D:
	RJMP _0x200005F
_0x200005E:
	CPI  R30,LOW(0x66)
	BREQ PC+2
	RJMP _0x2000060
_0x200005F:
	MOVW R30,R28
	ADIW R30,22
	STD  Y+14,R30
	STD  Y+14+1,R31
	CALL SUBOPT_0x1F
	CALL __GETD1P
	CALL SUBOPT_0x20
	CALL SUBOPT_0x21
	LDD  R26,Y+13
	TST  R26
	BRMI _0x2000061
	LDD  R26,Y+21
	CPI  R26,LOW(0x2B)
	BREQ _0x2000063
	CPI  R26,LOW(0x20)
	BREQ _0x2000065
	RJMP _0x2000066
_0x2000061:
	CALL SUBOPT_0x22
	CALL __ANEGF1
	CALL SUBOPT_0x20
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x2000063:
	SBRS R16,7
	RJMP _0x2000067
	LDD  R30,Y+21
	ST   -Y,R30
	CALL SUBOPT_0x1E
	RJMP _0x2000068
_0x2000067:
_0x2000065:
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	ADIW R30,1
	STD  Y+14,R30
	STD  Y+14+1,R31
	SBIW R30,1
	LDD  R26,Y+21
	STD  Z+0,R26
_0x2000068:
_0x2000066:
	SBRS R16,5
	LDI  R20,LOW(6)
	CPI  R18,102
	BRNE _0x200006A
	CALL SUBOPT_0x22
	CALL __PUTPARD1
	ST   -Y,R20
	LDD  R26,Y+19
	LDD  R27,Y+19+1
	CALL _ftoa
	RJMP _0x200006B
_0x200006A:
	CALL SUBOPT_0x22
	CALL __PUTPARD1
	ST   -Y,R20
	ST   -Y,R18
	LDD  R26,Y+20
	LDD  R27,Y+20+1
	RCALL __ftoe_G100
_0x200006B:
	MOVW R30,R28
	ADIW R30,22
	CALL SUBOPT_0x23
	RJMP _0x200006C
_0x2000060:
	CPI  R30,LOW(0x73)
	BRNE _0x200006E
	CALL SUBOPT_0x21
	CALL SUBOPT_0x24
	CALL SUBOPT_0x23
	RJMP _0x200006F
_0x200006E:
	CPI  R30,LOW(0x70)
	BRNE _0x2000071
	CALL SUBOPT_0x21
	CALL SUBOPT_0x24
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x200006F:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x2000073
	CP   R20,R17
	BRLO _0x2000074
_0x2000073:
	RJMP _0x2000072
_0x2000074:
	MOV  R17,R20
_0x2000072:
_0x200006C:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+20,R30
	LDI  R19,LOW(0)
	RJMP _0x2000075
_0x2000071:
	CPI  R30,LOW(0x64)
	BREQ _0x2000078
	CPI  R30,LOW(0x69)
	BRNE _0x2000079
_0x2000078:
	ORI  R16,LOW(4)
	RJMP _0x200007A
_0x2000079:
	CPI  R30,LOW(0x75)
	BRNE _0x200007B
_0x200007A:
	LDI  R30,LOW(10)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x200007C
	__GETD1N 0x3B9ACA00
	CALL SUBOPT_0x25
	LDI  R17,LOW(10)
	RJMP _0x200007D
_0x200007C:
	__GETD1N 0x2710
	CALL SUBOPT_0x25
	LDI  R17,LOW(5)
	RJMP _0x200007D
_0x200007B:
	CPI  R30,LOW(0x58)
	BRNE _0x200007F
	ORI  R16,LOW(8)
	RJMP _0x2000080
_0x200007F:
	CPI  R30,LOW(0x78)
	BREQ PC+2
	RJMP _0x20000BE
_0x2000080:
	LDI  R30,LOW(16)
	STD  Y+20,R30
	SBRS R16,1
	RJMP _0x2000082
	__GETD1N 0x10000000
	CALL SUBOPT_0x25
	LDI  R17,LOW(8)
	RJMP _0x200007D
_0x2000082:
	__GETD1N 0x1000
	CALL SUBOPT_0x25
	LDI  R17,LOW(4)
_0x200007D:
	CPI  R20,0
	BREQ _0x2000083
	ANDI R16,LOW(127)
	RJMP _0x2000084
_0x2000083:
	LDI  R20,LOW(1)
_0x2000084:
	SBRS R16,1
	RJMP _0x2000085
	CALL SUBOPT_0x21
	CALL SUBOPT_0x1F
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x200011B
_0x2000085:
	SBRS R16,2
	RJMP _0x2000087
	CALL SUBOPT_0x21
	CALL SUBOPT_0x24
	CALL __CWD1
	RJMP _0x200011B
_0x2000087:
	CALL SUBOPT_0x21
	CALL SUBOPT_0x24
	CLR  R22
	CLR  R23
_0x200011B:
	__PUTD1S 10
	SBRS R16,2
	RJMP _0x2000089
	LDD  R26,Y+13
	TST  R26
	BRPL _0x200008A
	CALL SUBOPT_0x22
	CALL __ANEGD1
	CALL SUBOPT_0x20
	LDI  R30,LOW(45)
	STD  Y+21,R30
_0x200008A:
	LDD  R30,Y+21
	CPI  R30,0
	BREQ _0x200008B
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x200008C
_0x200008B:
	ANDI R16,LOW(251)
_0x200008C:
_0x2000089:
	MOV  R19,R20
_0x2000075:
	SBRC R16,0
	RJMP _0x200008D
_0x200008E:
	CP   R17,R21
	BRSH _0x2000091
	CP   R19,R21
	BRLO _0x2000092
_0x2000091:
	RJMP _0x2000090
_0x2000092:
	SBRS R16,7
	RJMP _0x2000093
	SBRS R16,2
	RJMP _0x2000094
	ANDI R16,LOW(251)
	LDD  R18,Y+21
	SUBI R17,LOW(1)
	RJMP _0x2000095
_0x2000094:
	LDI  R18,LOW(48)
_0x2000095:
	RJMP _0x2000096
_0x2000093:
	LDI  R18,LOW(32)
_0x2000096:
	CALL SUBOPT_0x1B
	SUBI R21,LOW(1)
	RJMP _0x200008E
_0x2000090:
_0x200008D:
_0x2000097:
	CP   R17,R20
	BRSH _0x2000099
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200009A
	CALL SUBOPT_0x26
	BREQ _0x200009B
	SUBI R21,LOW(1)
_0x200009B:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x200009A:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL SUBOPT_0x1E
	CPI  R21,0
	BREQ _0x200009C
	SUBI R21,LOW(1)
_0x200009C:
	SUBI R20,LOW(1)
	RJMP _0x2000097
_0x2000099:
	MOV  R19,R17
	LDD  R30,Y+20
	CPI  R30,0
	BRNE _0x200009D
_0x200009E:
	CPI  R19,0
	BREQ _0x20000A0
	SBRS R16,3
	RJMP _0x20000A1
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LPM  R18,Z+
	STD  Y+14,R30
	STD  Y+14+1,R31
	RJMP _0x20000A2
_0x20000A1:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	LD   R18,X+
	STD  Y+14,R26
	STD  Y+14+1,R27
_0x20000A2:
	CALL SUBOPT_0x1B
	CPI  R21,0
	BREQ _0x20000A3
	SUBI R21,LOW(1)
_0x20000A3:
	SUBI R19,LOW(1)
	RJMP _0x200009E
_0x20000A0:
	RJMP _0x20000A4
_0x200009D:
_0x20000A6:
	CALL SUBOPT_0x27
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x20000A8
	SBRS R16,3
	RJMP _0x20000A9
	SUBI R18,-LOW(55)
	RJMP _0x20000AA
_0x20000A9:
	SUBI R18,-LOW(87)
_0x20000AA:
	RJMP _0x20000AB
_0x20000A8:
	SUBI R18,-LOW(48)
_0x20000AB:
	SBRC R16,4
	RJMP _0x20000AD
	CPI  R18,49
	BRSH _0x20000AF
	__GETD2S 16
	__CPD2N 0x1
	BRNE _0x20000AE
_0x20000AF:
	RJMP _0x20000B1
_0x20000AE:
	CP   R20,R19
	BRSH _0x200011C
	CP   R21,R19
	BRLO _0x20000B4
	SBRS R16,0
	RJMP _0x20000B5
_0x20000B4:
	RJMP _0x20000B3
_0x20000B5:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x20000B6
_0x200011C:
	LDI  R18,LOW(48)
_0x20000B1:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x20000B7
	CALL SUBOPT_0x26
	BREQ _0x20000B8
	SUBI R21,LOW(1)
_0x20000B8:
_0x20000B7:
_0x20000B6:
_0x20000AD:
	CALL SUBOPT_0x1B
	CPI  R21,0
	BREQ _0x20000B9
	SUBI R21,LOW(1)
_0x20000B9:
_0x20000B3:
	SUBI R19,LOW(1)
	CALL SUBOPT_0x27
	CALL __MODD21U
	CALL SUBOPT_0x20
	LDD  R30,Y+20
	__GETD2S 16
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	CALL SUBOPT_0x25
	__GETD1S 16
	CALL __CPD10
	BREQ _0x20000A7
	RJMP _0x20000A6
_0x20000A7:
_0x20000A4:
	SBRS R16,0
	RJMP _0x20000BA
_0x20000BB:
	CPI  R21,0
	BREQ _0x20000BD
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x1E
	RJMP _0x20000BB
_0x20000BD:
_0x20000BA:
_0x20000BE:
_0x200005A:
_0x200011A:
	LDI  R17,LOW(0)
_0x200003B:
	RJMP _0x2000036
_0x2000038:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,63
	ADIW R28,31
	RET
; .FEND
_sprintf:
; .FSTART _sprintf
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x28
	SBIW R30,0
	BRNE _0x20000BF
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20A0007
_0x20000BF:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x28
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R26,R28
	ADIW R26,10
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20A0007:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
; .FEND

	.CSEG
_ftrunc:
; .FSTART _ftrunc
	CALL __PUTPARD2
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
; .FEND
_floor:
; .FSTART _floor
	CALL __PUTPARD2
	CALL __GETD2S0
	CALL _ftrunc
	CALL SUBOPT_0xC
    brne __floor1
__floor0:
	CALL SUBOPT_0xE
	RJMP _0x20A0006
__floor1:
    brtc __floor0
	CALL SUBOPT_0xE
	CALL SUBOPT_0xF
	CALL __SUBF12
_0x20A0006:
	ADIW R28,4
	RET
; .FEND
_log:
; .FSTART _log
	CALL __PUTPARD2
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x29
	CALL __CPD02
	BRLT _0x202000C
	__GETD1N 0xFF7FFFFF
	RJMP _0x20A0005
_0x202000C:
	CALL SUBOPT_0x2A
	CALL __PUTPARD1
	IN   R26,SPL
	IN   R27,SPH
	SBIW R26,1
	PUSH R17
	PUSH R16
	CALL _frexp
	POP  R16
	POP  R17
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x29
	__GETD1N 0x3F3504F3
	CALL __CMPF12
	BRSH _0x202000D
	CALL SUBOPT_0x2C
	CALL __ADDF12
	CALL SUBOPT_0x2B
	__SUBWRN 16,17,1
_0x202000D:
	CALL SUBOPT_0x2A
	CALL SUBOPT_0xF
	CALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x2A
	CALL SUBOPT_0xF
	CALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2D
	__GETD2N 0x3F654226
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x4054114E
	CALL SUBOPT_0x7
	CALL SUBOPT_0x29
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x2E
	__GETD2N 0x3FD4114D
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R30,R16
	CALL __CWD1
	CALL __CDF1
	__GETD2N 0x3F317218
	CALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDF12
_0x20A0005:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,10
	RET
; .FEND
_exp:
; .FSTART _exp
	CALL __PUTPARD2
	SBIW R28,8
	ST   -Y,R17
	ST   -Y,R16
	CALL SUBOPT_0x2F
	__GETD1N 0xC2AEAC50
	CALL __CMPF12
	BRSH _0x202000F
	CALL SUBOPT_0x30
	RJMP _0x20A0004
_0x202000F:
	CALL SUBOPT_0x22
	CALL __CPD10
	BRNE _0x2020010
	CALL SUBOPT_0x6
	RJMP _0x20A0004
_0x2020010:
	CALL SUBOPT_0x2F
	__GETD1N 0x42B17218
	CALL __CMPF12
	BREQ PC+2
	BRCC PC+2
	RJMP _0x2020011
	__GETD1N 0x7F7FFFFF
	RJMP _0x20A0004
_0x2020011:
	CALL SUBOPT_0x2F
	__GETD1N 0x3FB8AA3B
	CALL __MULF12
	CALL SUBOPT_0x20
	CALL SUBOPT_0x2F
	RCALL _floor
	CALL __CFD1
	MOVW R16,R30
	CALL SUBOPT_0x2F
	CALL __CWD1
	CALL __CDF1
	CALL SUBOPT_0x7
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x3F000000
	CALL SUBOPT_0x7
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2D
	__GETD2N 0x3D6C4C6D
	CALL __MULF12
	__GETD2N 0x40E6E3A6
	CALL __ADDF12
	CALL SUBOPT_0x29
	CALL __MULF12
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2E
	__GETD2N 0x41A68D28
	CALL __ADDF12
	CALL SUBOPT_0x31
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x32
	CALL __ADDF12
	__GETD2N 0x3FB504F3
	CALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2E
	CALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVF21
	CALL __PUTPARD1
	MOVW R26,R16
	CALL _ldexp
_0x20A0004:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,14
	RET
; .FEND
_pow:
; .FSTART _pow
	CALL __PUTPARD2
	SBIW R28,4
	CALL SUBOPT_0x33
	CALL __CPD10
	BRNE _0x2020012
	CALL SUBOPT_0x30
	RJMP _0x20A0003
_0x2020012:
	CALL SUBOPT_0x2
	CALL __CPD02
	BRGE _0x2020013
	CALL SUBOPT_0x10
	CALL __CPD10
	BRNE _0x2020014
	CALL SUBOPT_0x6
	RJMP _0x20A0003
_0x2020014:
	CALL SUBOPT_0x2
	RCALL _log
	CALL SUBOPT_0x19
	MOVW R26,R30
	MOVW R24,R22
	RCALL _exp
	RJMP _0x20A0003
_0x2020013:
	CALL SUBOPT_0x10
	MOVW R26,R28
	CALL __CFD1
	CALL __PUTDP1
	CALL SUBOPT_0xE
	CALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	CALL SUBOPT_0x10
	CALL __CPD12
	BREQ _0x2020015
	CALL SUBOPT_0x30
	RJMP _0x20A0003
_0x2020015:
	CALL SUBOPT_0x33
	CALL __ANEGF1
	MOVW R26,R30
	MOVW R24,R22
	RCALL _log
	CALL SUBOPT_0x19
	MOVW R26,R30
	MOVW R24,R22
	RCALL _exp
	__PUTD1S 8
	LD   R30,Y
	ANDI R30,LOW(0x1)
	BRNE _0x2020016
	CALL SUBOPT_0x33
	RJMP _0x20A0003
_0x2020016:
	CALL SUBOPT_0x33
	CALL __ANEGF1
_0x20A0003:
	ADIW R28,12
	RET
; .FEND

	.CSEG

	.CSEG
_strcpyf:
; .FSTART _strcpyf
	ST   -Y,R27
	ST   -Y,R26
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret
; .FEND
_strlen:
; .FSTART _strlen
	ST   -Y,R27
	ST   -Y,R26
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
	ST   -Y,R27
	ST   -Y,R26
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

	.CSEG
_ftoa:
; .FSTART _ftoa
	RCALL SUBOPT_0x12
	LDI  R30,LOW(0)
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	ST   -Y,R17
	ST   -Y,R16
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x208000D
	RCALL SUBOPT_0x34
	__POINTW2FN _0x2080000,0
	CALL _strcpyf
	RJMP _0x20A0002
_0x208000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x208000C
	RCALL SUBOPT_0x34
	__POINTW2FN _0x2080000,1
	CALL _strcpyf
	RJMP _0x20A0002
_0x208000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x208000F
	__GETD1S 9
	CALL __ANEGF1
	RCALL SUBOPT_0x35
	RCALL SUBOPT_0x36
	LDI  R30,LOW(45)
	ST   X,R30
_0x208000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x2080010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x2080010:
	LDD  R17,Y+8
_0x2080011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2080013
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x16
	CALL __MULF12
	RCALL SUBOPT_0x31
	RJMP _0x2080011
_0x2080013:
	RCALL SUBOPT_0x37
	CALL __ADDF12
	RCALL SUBOPT_0x35
	LDI  R17,LOW(0)
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x31
_0x2080014:
	RCALL SUBOPT_0x37
	CALL __CMPF12
	BRLO _0x2080016
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0xD
	CALL __MULF12
	RCALL SUBOPT_0x31
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x2080017
	RCALL SUBOPT_0x34
	__POINTW2FN _0x2080000,5
	CALL _strcpyf
	RJMP _0x20A0002
_0x2080017:
	RJMP _0x2080014
_0x2080016:
	CPI  R17,0
	BRNE _0x2080018
	RCALL SUBOPT_0x36
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x2080019
_0x2080018:
_0x208001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x208001C
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x16
	RCALL SUBOPT_0x5
	MOVW R26,R30
	MOVW R24,R22
	CALL _floor
	RCALL SUBOPT_0x31
	RCALL SUBOPT_0x37
	CALL __DIVF21
	CALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x36
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x32
	RCALL SUBOPT_0x4
	CALL __MULF12
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x35
	RJMP _0x208001A
_0x208001C:
_0x2080019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20A0001
	RCALL SUBOPT_0x36
	LDI  R30,LOW(46)
	ST   X,R30
_0x208001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x2080020
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0xD
	CALL __MULF12
	RCALL SUBOPT_0x35
	__GETD1S 9
	CALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x36
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x7
	RCALL SUBOPT_0x35
	RJMP _0x208001E
_0x2080020:
_0x20A0001:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20A0002:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,13
	RET
; .FEND

	.DSEG

	.CSEG

	.DSEG
__seed_G104:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LD   R26,Y
	LDD  R27,Y+1
	LD   R30,X+
	ST   Y,R26
	STD  Y+1,R27
	MOV  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x1:
	MOV  R16,R30
	CALL _LCD_I2C_Start
	LDI  R26,LOW(78)
	CALL _I2C_Write
	MOV  R26,R17
	CALL _LCD_Send4Bits
	MOV  R26,R16
	CALL _LCD_Send4Bits
	CALL _LCD_I2C_Stop
	LDI  R26,LOW(2)
	LDI  R27,0
	CALL _delay_ms
	LDD  R17,Y+1
	LDD  R16,Y+0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2:
	__GETD2S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	__GETD1S 4
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5:
	CALL __MULF12
	__GETD2N 0x3F000000
	CALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	__GETD1N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x7:
	CALL __SWAPD12
	CALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8:
	CALL __MULF12
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x9:
	__GETD2S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA:
	__PUTD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xB:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	CALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xD:
	__GETD1N 0x41200000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	CALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x10:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x12:
	ST   -Y,R27
	ST   -Y,R26
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x13:
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xD
	CALL __MULF12
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x14:
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x9
	CALL __CMPF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x15:
	RCALL SUBOPT_0x9
	__GETD1N 0x3DCCCCCD
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	__GETD1N 0x3DCCCCCD
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADIW R26,1
	STD  Y+8,R26
	STD  Y+8+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x18:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	RCALL SUBOPT_0xB
	CALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	ADIW R30,1
	STD  Y+8,R30
	STD  Y+8+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1B:
	ST   -Y,R18
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x1C:
	__GETW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x1D:
	SBIW R30,4
	__PUTW1SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1E:
	LDD  R26,Y+7
	LDD  R27,Y+7+1
	LDD  R30,Y+9
	LDD  R31,Y+9+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x1F:
	__GETW2SX 90
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x20:
	__PUTD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x21:
	RCALL SUBOPT_0x1C
	RJMP SUBOPT_0x1D

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x22:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x23:
	STD  Y+14,R30
	STD  Y+14+1,R31
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	CALL _strlen
	MOV  R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x24:
	RCALL SUBOPT_0x1F
	ADIW R26,4
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x25:
	__PUTD1S 16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x26:
	ANDI R16,LOW(251)
	LDD  R30,Y+21
	ST   -Y,R30
	__GETW2SX 87
	__GETW1SX 89
	ICALL
	CPI  R21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x27:
	__GETD1S 16
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x29:
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2A:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2B:
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	RCALL SUBOPT_0x2A
	RJMP SUBOPT_0x29

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2D:
	CALL __MULF12
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2E:
	__GETD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2F:
	__GETD2S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	__GETD1N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x31:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x32:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x33:
	__GETD1S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x35:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x36:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x37:
	RCALL SUBOPT_0x2E
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x38:
	__GETD2S 9
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

_frexp:
	LD   R30,Y+
	LD   R31,Y+
	LD   R22,Y+
	LD   R23,Y+
	BST  R23,7
	LSL  R22
	ROL  R23
	CLR  R24
	SUBI R23,0x7E
	SBC  R24,R24
	ST   X+,R23
	ST   X,R24
	LDI  R23,0x7E
	LSR  R23
	ROR  R22
	BRTS __ANEGF1
	RET

_ldexp:
	LD   R30,Y+
	LD   R31,Y+
	LD   R22,Y+
	LD   R23,Y+
	BST  R23,7
	LSL  R22
	ROL  R23
	ADD  R23,R26
	LSR  R23
	ROR  R22
	BRTS __ANEGF1
	RET

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

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

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

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

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
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

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
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

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
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

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
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
