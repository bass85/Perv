
;CodeVisionAVR C Compiler V2.05.3 Standard
;(C) Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATtiny261
;Program type             : Application
;Clock frequency          : 8,000000 MHz
;Memory model             : Tiny
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 32 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;Global 'const' stored in FLASH     : No
;Enhanced function parameter passing: Yes
;Enhanced core instructions         : On
;Smart register allocation          : On
;Automatic register allocation      : On

	#pragma AVRPART ADMIN PART_NAME ATtiny261
	#pragma AVRPART MEMORY PROG_FLASH 2048
	#pragma AVRPART MEMORY EEPROM 128
	#pragma AVRPART MEMORY INT_SRAM SIZE 223
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E

	.EQU WDTCR=0x21
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SREG=0x3F
	.EQU GPIOR0=0x0A
	.EQU GPIOR1=0x0B
	.EQU GPIOR2=0x0C

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

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x00DF
	.EQU __DSTACK_SIZE=0x0020
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
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	SUBI R26,-@1
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

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _comand=R2
	.DEF _adc_data=R4

;GPIOR0-GPIOR2 INITIALIZATION VALUES
	.EQU __GPIOR0_INIT=0x00
	.EQU __GPIOR1_INIT=0x00
	.EQU __GPIOR2_INIT=0x00

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
	RJMP _adc_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	WDR
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,__CLEAR_SRAM_SIZE
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_SRAM

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

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x80

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.3 Standard
;Automatic Program Generator
;� Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 16.11.2018
;Author  : Dima
;Company : Dima
;Comments:
;
;
;Chip type               : ATtiny261
;AVR Core Clock frequency: 8,000000 MHz
;Memory model            : Tiny
;External RAM size       : 0
;Data Stack size         : 32
;*****************************************************/
;
;#include <tiny261.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_adc_noise_red=0x08
	.EQU __sm_mask=0x18
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x18
	.SET power_ctrl_reg=mcucr
	#endif
;
;#include <delay.h>
;unsigned int comand;
;unsigned int adc_data;
;#define ADC_VREF_TYPE 0x00
;
;// ADC interrupt service routine
;interrupt [ADC_INT] void adc_isr(void)
; 0000 0020 {

	.CSEG
_adc_isr:
; 0000 0021 // Read the AD conversion result
; 0000 0022 adc_data=ADCW;
	__INWR 4,5,4
; 0000 0023 }
	RETI
;
;// Read the AD conversion result
;// with noise canceling
;unsigned int read_adc(unsigned char adc_input)
; 0000 0028 {
_read_adc:
; 0000 0029 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
	ST   -Y,R26
;	adc_input -> Y+0
	LD   R30,Y
	OUT  0x7,R30
; 0000 002A // Delay needed for the stabilization of the ADC input voltage
; 0000 002B delay_us(10);
	__DELAY_USB 27
; 0000 002C #asm
; 0000 002D     in   r30,mcucr
    in   r30,mcucr
; 0000 002E     cbr  r30,__sm_mask
    cbr  r30,__sm_mask
; 0000 002F     sbr  r30,__se_bit | __sm_adc_noise_red
    sbr  r30,__se_bit | __sm_adc_noise_red
; 0000 0030     out  mcucr,r30
    out  mcucr,r30
; 0000 0031     sleep
    sleep
; 0000 0032     cbr  r30,__se_bit
    cbr  r30,__se_bit
; 0000 0033     out  mcucr,r30
    out  mcucr,r30
; 0000 0034 #endasm
; 0000 0035 return adc_data;
	MOVW R30,R4
	ADIW R28,1
	RET
; 0000 0036 }
;
;// Declare your global variables here
;
;void main(void)
; 0000 003B {
_main:
; 0000 003C // Declare your local variables here
; 0000 003D 
; 0000 003E // Crystal Oscillator division factor: 1
; 0000 003F #pragma optsize-
; 0000 0040 CLKPR=0x80;
	LDI  R30,LOW(128)
	OUT  0x28,R30
; 0000 0041 CLKPR=0x00;
	LDI  R30,LOW(0)
	OUT  0x28,R30
; 0000 0042 #ifdef _OPTIMIZE_SIZE_
; 0000 0043 #pragma optsize+
; 0000 0044 #endif
; 0000 0045 
; 0000 0046 // Input/Output Ports initialization
; 0000 0047 // Port A initialization
; 0000 0048 // Func7=In Func6=Out Func5=Out Func4=Out Func3=Out Func2=In Func1=In Func0=In
; 0000 0049 // State7=T State6=0 State5=0 State4=0 State3=0 State2=T State1=T State0=T
; 0000 004A PORTA=0x00;
	OUT  0x1B,R30
; 0000 004B DDRA=0x78;
	LDI  R30,LOW(120)
	OUT  0x1A,R30
; 0000 004C 
; 0000 004D // Port B initialization
; 0000 004E // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 004F // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0050 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0051 DDRB=0x00;
	OUT  0x17,R30
; 0000 0052 
; 0000 0053 // Timer/Counter 0 initialization
; 0000 0054 // Clock source: System Clock
; 0000 0055 // Clock value: Timer 0 Stopped
; 0000 0056 // Mode: 8bit top=0xFF
; 0000 0057 TCCR0A=0x00;
	OUT  0x15,R30
; 0000 0058 TCCR0B=0x00;
	OUT  0x33,R30
; 0000 0059 TCNT0H=0x00;
	OUT  0x14,R30
; 0000 005A TCNT0L=0x00;
	OUT  0x32,R30
; 0000 005B OCR0A=0x00;
	OUT  0x13,R30
; 0000 005C OCR0B=0x00;
	OUT  0x12,R30
; 0000 005D 
; 0000 005E // Timer/Counter 1 initialization
; 0000 005F // Clock source: System Clock
; 0000 0060 // Clock value: Timer1 Stopped
; 0000 0061 // Mode: Normal top=OCR1C
; 0000 0062 // OC1A output: Discon.
; 0000 0063 // OC1B output: Discon.
; 0000 0064 // OC1C output: Discon.
; 0000 0065 // Fault Protection Mode: Off
; 0000 0066 // Fault Protection Noise Canceler: Off
; 0000 0067 // Fault Protection triggered on Falling edge
; 0000 0068 // Fault Protection triggered by the Analog Comparator: Off
; 0000 0069 // Dead Time Rising Edge: 0.000 us
; 0000 006A // Dead Time Falling Edge: 0.000 us
; 0000 006B // Timer1 Overflow Interrupt: Off
; 0000 006C // Compare A Match Interrupt: Off
; 0000 006D // Compare B Match Interrupt: Off
; 0000 006E // Compare D Match Interrupt: Off
; 0000 006F // Fault Protection Interrupt: Off
; 0000 0070 PLLCSR=0x00;
	OUT  0x29,R30
; 0000 0071 
; 0000 0072 TCCR1A=0x00;
	OUT  0x30,R30
; 0000 0073 TCCR1B=0x00;
	OUT  0x2F,R30
; 0000 0074 TCCR1C=0x00;
	OUT  0x27,R30
; 0000 0075 TCCR1D=0x00;
	OUT  0x26,R30
; 0000 0076 TCCR1E=0x00;
	OUT  0x0,R30
; 0000 0077 TC1H=0x00;
	RCALL SUBOPT_0x0
; 0000 0078 TCNT1=0x00;
	OUT  0x2E,R30
; 0000 0079 TC1H=0x00;
	RCALL SUBOPT_0x0
; 0000 007A OCR1A=0x00;
	OUT  0x2D,R30
; 0000 007B TC1H=0x00;
	RCALL SUBOPT_0x0
; 0000 007C OCR1B=0x00;
	OUT  0x2C,R30
; 0000 007D TC1H=0x00;
	RCALL SUBOPT_0x0
; 0000 007E OCR1C=0x00;
	OUT  0x2B,R30
; 0000 007F TC1H=0x00;
	RCALL SUBOPT_0x0
; 0000 0080 OCR1D=0x00;
	OUT  0x2A,R30
; 0000 0081 DT1=0x00;
	LDI  R30,LOW(0)
	OUT  0x24,R30
; 0000 0082 
; 0000 0083 // External Interrupt(s) initialization
; 0000 0084 // INT0: Off
; 0000 0085 // INT1: Off
; 0000 0086 // Interrupt on any change on pins PCINT0-7, 12-15: Off
; 0000 0087 // Interrupt on any change on pins PCINT8-11: Off
; 0000 0088 MCUCR=0x00;
	OUT  0x35,R30
; 0000 0089 GIMSK=0x00;
	OUT  0x3B,R30
; 0000 008A 
; 0000 008B // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 008C TIMSK=0x00;
	OUT  0x39,R30
; 0000 008D 
; 0000 008E // Universal Serial Interface initialization
; 0000 008F // Mode: Disabled
; 0000 0090 // Clock source: Register & Counter=no clk.
; 0000 0091 // USI Counter Overflow Interrupt: Off
; 0000 0092 USICR=0x00;
	OUT  0xD,R30
; 0000 0093 
; 0000 0094 // Analog Comparator initialization
; 0000 0095 // Analog Comparator: Off
; 0000 0096 ACSRA=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0097 // Hysterezis level: 0 mV
; 0000 0098 ACSRB=0x00;
	LDI  R30,LOW(0)
	OUT  0x9,R30
; 0000 0099 DIDR1=0x00;
	OUT  0x2,R30
; 0000 009A 
; 0000 009B // ADC initialization
; 0000 009C // ADC Clock frequency: 500,000 kHz
; 0000 009D // ADC Voltage Reference: AVCC pin
; 0000 009E // ADC Bipolar Input Mode: Off
; 0000 009F // ADC Auto Trigger Source: ADC Stopped
; 0000 00A0 // Digital input buffers on ADC0: On, ADC1: On, ADC2: On, Aref: On
; 0000 00A1 // ADC3: On, ADC4: On, ADC5: On, ADC6: On
; 0000 00A2 DIDR0=0x00;
	OUT  0x1,R30
; 0000 00A3 // Digital input buffers on ADC7: On, ADC8: On, ADC9: On, ADC10: On
; 0000 00A4 DIDR1=0x00;
	OUT  0x2,R30
; 0000 00A5 ADMUX=ADC_VREF_TYPE & 0xff;
	OUT  0x7,R30
; 0000 00A6 ADCSRA=0x8C;
	LDI  R30,LOW(140)
	OUT  0x6,R30
; 0000 00A7 ADCSRB&=0x7F;
	CBI  0x3,7
; 0000 00A8 ADCSRB|=0x00 | ((ADC_VREF_TYPE & 0x100) >> 4);
	IN   R30,0x3
	OUT  0x3,R30
; 0000 00A9 
; 0000 00AA // Global enable interrupts
; 0000 00AB #asm("sei")
	sei
; 0000 00AC      PORTA.6=0;
	CBI  0x1B,6
; 0000 00AD      PORTA.5=0;
	CBI  0x1B,5
; 0000 00AE      PORTA.4=0;
	CBI  0x1B,4
; 0000 00AF      PORTA.3=0;
	CBI  0x1B,3
; 0000 00B0 while (1)
_0xB:
; 0000 00B1       {
; 0000 00B2 
; 0000 00B3      read_adc(0);
	LDI  R26,LOW(0)
	RCALL _read_adc
; 0000 00B4       delay_ms(50);
	RCALL SUBOPT_0x1
; 0000 00B5 
; 0000 00B6      if ((adc_data>180)&&(adc_data<355))
	LDI  R30,LOW(180)
	LDI  R31,HIGH(180)
	RCALL SUBOPT_0x2
	BRSH _0xF
	LDI  R30,LOW(355)
	LDI  R31,HIGH(355)
	RCALL SUBOPT_0x3
	BRLO _0x10
_0xF:
	RJMP _0xE
_0x10:
; 0000 00B7       {
; 0000 00B8      comand=1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R2,R30
; 0000 00B9      delay_ms(50);
	RCALL SUBOPT_0x1
; 0000 00BA       };
_0xE:
; 0000 00BB 
; 0000 00BC        if ((adc_data>135)&&(adc_data<200))
	LDI  R30,LOW(135)
	LDI  R31,HIGH(135)
	RCALL SUBOPT_0x2
	BRSH _0x12
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RCALL SUBOPT_0x3
	BRLO _0x13
_0x12:
	RJMP _0x11
_0x13:
; 0000 00BD       {
; 0000 00BE      comand=2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	MOVW R2,R30
; 0000 00BF      delay_ms(50);
	RCALL SUBOPT_0x1
; 0000 00C0       };
_0x11:
; 0000 00C1 
; 0000 00C2        if ((adc_data>100)&&(adc_data<130))
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL SUBOPT_0x2
	BRSH _0x15
	LDI  R30,LOW(130)
	LDI  R31,HIGH(130)
	RCALL SUBOPT_0x3
	BRLO _0x16
_0x15:
	RJMP _0x14
_0x16:
; 0000 00C3       {
; 0000 00C4      comand=3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	MOVW R2,R30
; 0000 00C5      delay_ms(50);
	RCALL SUBOPT_0x1
; 0000 00C6       };
_0x14:
; 0000 00C7 
; 0000 00C8        if ((adc_data>60)&&(adc_data<90))
	LDI  R30,LOW(60)
	LDI  R31,HIGH(60)
	RCALL SUBOPT_0x2
	BRSH _0x18
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	RCALL SUBOPT_0x3
	BRLO _0x19
_0x18:
	RJMP _0x17
_0x19:
; 0000 00C9       {
; 0000 00CA      comand=4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	MOVW R2,R30
; 0000 00CB      delay_ms(100);
	LDI  R26,LOW(100)
	RCALL SUBOPT_0x4
; 0000 00CC       };
_0x17:
; 0000 00CD 
; 0000 00CE        switch (comand)
	MOVW R30,R2
; 0000 00CF       {
; 0000 00D0     case 1:  PORTA.6=1; PORTA.5=0;PORTA.4=0;PORTA.3=0;comand=0;
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x1D
	SBI  0x1B,6
	RJMP _0x4B
; 0000 00D1     break;
; 0000 00D2     case 2:  PORTA.6=0; PORTA.5=1;PORTA.4=0;PORTA.3=0;comand=0; delay_ms(200);
_0x1D:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x26
	CBI  0x1B,6
	SBI  0x1B,5
	RCALL SUBOPT_0x5
	LDI  R26,LOW(200)
	RCALL SUBOPT_0x4
; 0000 00D3     break;
	RJMP _0x1C
; 0000 00D4     case 3:  PORTA.6=0; PORTA.5=0;PORTA.4=1;PORTA.3=0;comand=0; delay_ms(200);
_0x26:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x2F
	CBI  0x1B,6
	CBI  0x1B,5
	SBI  0x1B,4
	CBI  0x1B,3
	CLR  R2
	CLR  R3
	LDI  R26,LOW(200)
	RCALL SUBOPT_0x4
; 0000 00D5     break;
	RJMP _0x1C
; 0000 00D6     case 4:  PORTA.6=0; PORTA.5=0;PORTA.4=0;PORTA.3=1;comand=0; delay_ms(400);
_0x2F:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x41
	CBI  0x1B,6
	CBI  0x1B,5
	CBI  0x1B,4
	SBI  0x1B,3
	CLR  R2
	CLR  R3
	LDI  R26,LOW(400)
	LDI  R27,HIGH(400)
	RCALL _delay_ms
; 0000 00D7     break;
	RJMP _0x1C
; 0000 00D8 
; 0000 00D9     default:PORTA.6=0; PORTA.5=0;PORTA.4=0;PORTA.3=0;comand=0;
_0x41:
	CBI  0x1B,6
_0x4B:
	CBI  0x1B,5
	RCALL SUBOPT_0x5
; 0000 00DA       };
_0x1C:
; 0000 00DB 
; 0000 00DC 
; 0000 00DD 
; 0000 00DE 
; 0000 00DF 
; 0000 00E0       }
	RJMP _0xB
; 0000 00E1 }
_0x4A:
	RJMP _0x4A

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(0)
	OUT  0x25,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(50)
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	CP   R30,R4
	CPC  R31,R5
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	CP   R4,R30
	CPC  R5,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4:
	LDI  R27,0
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	CBI  0x1B,4
	CBI  0x1B,3
	CLR  R2
	CLR  R3
	RET


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

;END OF CODE MARKER
__END_OF_CODE:
