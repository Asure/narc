	.FILE	"NARCPALL.ASM"
	.TITLE	"PALETTE ALLOCATOR VER. 1.0"
	.WIDTH	132
	.OPTION	B,D,L,T
	.MNOLIST

	.include	"..\sys\gsp.inc"	;gsp assembler equates
	.include	"..\sys\sys.inc"	;zunit system equates
	.include	"..\sys\mprocequ.asm"
	.include	"..\sys\dispequ.asm"
	.INCLUDE	"NARCEQU.ASM"

	.TEXT
**************************************************************************
*                                                                        *
* DELPAL - DELETE AN OBJECTS PALETTE					 *
* A0 = PTR TO OBJECT							 *
*                                                                        *
**************************************************************************
DELPAL
	PUSH	A0
	MOVE	*A0(OPAL),A0,W
	CALLR	FREEPAL
	MMFM	SP,A0
	RETS
**************************************************************************
*                                                                        *
* FINDPAL - FIND THE COLOR MAP # TO WHICH THE GIVEN PALETTE IS ASSIGNED. *
* A0 = 32 BIT PALETTE ADDRESS 						 *
* RETURNS:								 *
* Z BIT SET = PALETTE NOT FOUND ---> A0 = 0				 *
* Z BIT CLR = PALETTE FOUND ---> A0 = PALETTE #(CORRECT FORMAT FOR DMA)	 *
*                                                                        *
**************************************************************************
FINDPAL
	MMTM	SP,A1,A2,A3
	MOVK	NUMPAL,A3
	MOVI	PALRAM,A1	
FINDPAL0
	MOVE	*A1,A2,L	;GET PALETTE ID
	CMP	A0,A2
	JREQ	FINDPAL1	;FOUND
	ADDI	PALRSIZ,A1
	DSJS	A3,FINDPAL0
	CLR	A0		;SET Z BIT ---> FAILURE
	JRUC	FINDPALX
FINDPAL1
	SUBK	NUMPAL,A3	;COMPUTE PALETTE #
	NEG	A3
	MOVE	A3,A0 	      	;RETURN PALETTE #
	SLL	8,A3
	ADD	A3,A0 		;DOUBLE IT UP FOR LOFFREDO BRAIN DAMAGE
	INC	A3		;CLR Z BIT ---> SUCCESS
FINDPALX
	MMFM	SP,A1,A2,A3
	RETS

**************************************************************************
*                                                                        *
* INITPAL - GET A PALETTE FOR USE					 *
* A14 = POINTER TO OBJECT INITIALIZATION TABLE				 *
* RETURNS:								 *
* ZBIT SET = FAILURE							 *
* ZBIT CLR = SUCCESS --> VAR. CURPAL = PALETTE # JUST CREATED		 *
*                                                                        *
**************************************************************************
INITPAL
	MMTM	SP,A0
  	MOVE	*A14(INITIMG),A0,L
	MOVE	*A0(ICMAP),A0,L		;GET THE PALETTE NAME
	CALLR	GETFPAL			;GET A PALETTE
	JRZ	INITPALX		;SUCCESSFUL PALETTE CREATION
	MOVE	A0,@CURPAL,W		;STUFF THIS IN CURRENT PAL
INITPALX
	MMFM	SP,A0
	RETS

**************************************************************************
*                                                                        *
* INITBPAL - GET A BACKGROUND PALETTE FOR USE				 *
* A14 = POINTER TO OBJECT INITIALIZATION TABLE				 *
* RETURNS:								 *
* ZBIT SET = FAILURE							 *
* ZBIT CLR = SUCCESS --> VAR. CURPAL = PALETTE # JUST CREATED		 *
*                                                                        *
**************************************************************************
INITBPAL
	MMTM	SP,A0
  	MOVE	*A14(INITIMG),A0,L
	MOVE	*A0(ICMAP),A0,L		;GET THE PALETTE NAME
	CALLR	GETBPAL			;GET A BACKGROUND PALETTE
	JRZ	INITBPLX		;SUCCESSFUL PALETTE CREATION
	MOVE	A0,@CURPAL,W		;STUFF THIS IN CURRENT PAL
INITBPLX
	MMFM	SP,A0
	RETS

*
*CLEAR OUT PALETTE ALLOCATION RAM
*
CLRPAL:
	MMTM	SP,A0,A1,A2
	MOVI	FPALRAM,A0,L		;GET ADDRESS OF RAM
	MOVI	PALRSIZ*NUMPAL/16,A2	;GET # OF WORDS
	CLR	A1
CLRPALP:
	MOVE	A1,*A0+,W
	DSJS	A2,CLRPALP
CLRPTR:
	MOVI	PTRRAM,A0,L		;GET ADDRESS OF RAM
	MOVI	PTRSIZ*NUMPTR/16,A2	;GET # OF WORDS
CLRPLP1:
	MOVE	A1,*A0+,W
	DSJS	A2,CLRPLP1
	MMFM	SP,A0,A1,A2
	RETS
*
*CLEAR ONLY FOREGROUND PALETTES
CLRFPAL:
	MMTM	SP,A0,A1,A2
	MOVI	FPALRAM,A0,L		;GET ADDRESS OF RAM
	MOVI	PALRSIZ*NMFPAL/16,A2	;GET # OF WORDS
	CLR	A1
	JRUC	CLRPALP
*
*CLEAR ONLY BACKGROUND PALETTES
CLRBPAL:
	MMTM	SP,A0,A1,A2
	MOVI	BPALRAM,A0,L		;GET ADDRESS OF RAM
	MOVI	PALRSIZ*NMBPAL/16,A2	;GET # OF WORDS
	CLR	A1
	JRUC	CLRPALP

*
*GET A FOREGROUND PALETTE
*CALLING PARAMETERS:
*A0=PALETTE ID (ADDRESS OF DATA)
*A0 RETURNED WITH COLOR MAP ALLOCATED (0000-0F0F)
*RETURNS EQ IF NO PALETTE FREE
*
GETFPAL:
	MMTM	SP,A1,A2,A3
*CHECK IF PALETTE ALREADY EXISTS
	MOVK	NUMPAL,A3
	MOVI	PALRAM,A1	
GETPL0:
	MOVE	*A1,A2,L	;GET PALETTE ID
	CMP	A0,A2
	JREQ	GETPL3		;ALREADY IN COLOR RAM
	ADDI	PALRSIZ,A1
	DSJS	A3,GETPL0

*CHECK FOR A SPARE PALETTE
	MOVI	FPALRAM,A1
	MOVK	NMFPAL,A3      	;CHECK ALL PALETTES
GETPL1:	
	MOVE	*A1(PALCNT),A2,W
	JREQ	GTFPL2		;PALETTE EMPTY, GRAB IT
	ADDI	PALRSIZ,A1
	DSJS	A3,GETPL1
	MOVE	A3,A3		;NO PALETTES LEFT SET ZERO BIT
	JRUC	GETPLX		;SPLIT
*
*GET A BACKGROUND PALETTE
*CALLING PARAMETERS:
*A0=PALETTE ID (ADDRESS OF DATA)
*A0 RETURNED WITH COLOR MAP ALLOCATED (0000-0F0F)
*RETURNS EQ IF NO PALETTE FREE
*
GETBPAL:
	MMTM	SP,A1,A2,A3
*CHECK IF PALETTE ALREADY EXISTS
	MOVK	NUMPAL,A3
	MOVI	PALRAM,A1	
GTBPL0:
	MOVE	*A1,A2,L	;GET PALETTE ID
	CMP	A0,A2
	JREQ	GETPL3		;ALREADY IN COLOR RAM
	ADDI	PALRSIZ,A1
	DSJS	A3,GTBPL0

*CHECK FOR A SPARE PALETTE
	MOVI	BPALRAM,A1
	MOVK	NMBPAL,A3      	;CHECK ALL PALETTES
GTBPL1:	
	MOVE	*A1(PALCNT),A2,W
	JREQ	GETPL2		;PALETTE EMPTY, GRAB IT
	ADDI	PALRSIZ,A1
	DSJS	A3,GTBPL1
	MOVE	A3,A3		;NO PALETTES LEFT SET ZERO BIT
	JRUC	GETPLX		;SPLIT
*SETUP YOUR NEW PALETTE
GTFPL2:
	ADDK	NMBPAL,A3
GETPL2:
	MMTM	SP,A0,A1,A2
	MOVE	A3,A1		;PALETTE #
	SUBK	NUMPAL,A1	;COMPUTE PALETTE #
	NEG	A1
	SLL	8,A1		;X 256
	MOVE	*A0+,A2,W	;GET # COLORS IN PALETTE
	CALLR	PALSET		;SETUP PALETTE TRANSFER
	MMFM	SP,A0,A1,A2
	JREQ	GETPLX		;FAILED TO GET TRANSFER
	MOVE	A0,*A1,L	;STUFF PALETTE I.D.
GETPL3:
	SUBK	NUMPAL,A3	;COMPUTE PALETTE #
	NEG	A3
	MOVE	A3,A0 	      	;RETURN PALETTE #
	SLL	8,A3
	ADD	A3,A0	      		;DOUBLE IT UP FOR LOFREDO BRAIN DAMAGE
	MOVE	*A1(PALCNT),A2,W	;INCREMENT COUNT
	ADDK	1,A2			;SET NE FOR SUCCESS 
	MOVE	A2,*A1(PALCNT),W
GETPLX:
	MMFM	SP,A1,A2,A3
	RETS
*	
*FREE A PALETTE	
*A0=PALETTE # (0-NUMPAL) TO FREE
*
FREEPAL:	
	MMTM	SP,A0,A1
	SLL	24,A0		;MASK OFF GARBAGE
	SRL	24,A0
	CMPI	NUMPAL,A0 	;ERROR...PALETTE NUMBER ERRONEOUS
***	JRHS	$
	JRLO	FREEPAL1

	CALLERR	2		;LOG THE ERROR
       	JRUC	FREPLX

FREEPAL1
	MOVI	PALRSIZ,A1
	MPYU	A0,A1
	ADDI	PALRAM,A1
	MOVE	*A1(PALCNT),A0,W
	DEC	A0    			;DECREMENT ITS COUNT
***	JRN	$			;ERROR, NEGATIVE COUNT
	JRNN	FREEPAL2

	CALLERR	2		;LOG THE ERROR
	JRUC	FREPLX
FREEPAL2
	MOVE	A0,*A1(PALCNT),W
FREPLX:
	MMFM	SP,A0,A1
	RETS

*	
*UNGETPAL - Clears out a palettes allocation count
*A0=PALETTE # (0-NUMPAL) TO UNALLOCATE
*
UNGETPAL:	
	MMTM	SP,A0,A1
	SLL	24,A0		;MASK OFF GARBAGE
	SRL	24,A0
	CMPI	NUMPAL,A0 	;ERROR...PALETTE NUMBER ERRONEOUS
***	JRHS	$
	JRLO	UNGPAL1

	CALLERR	2		;LOG THE ERROR
	JRUC	UNGPALX
	
UNGPAL1
	MOVI	PALRSIZ,A1
	MPYU	A0,A1
	ADDI	PALRAM,A1
	clr	A0
	MOVE	A0,*A1(PALCNT),W
UNGPALX
	MMFM	SP,A0,A1
	RETS

*
*TRANSFER PALETTE DATA
*CALLED DURING VBLNK
*LOOKS THROUGH PTRRAM FOR TRANSFERS
*BOMBS A0-A13
;*** Bit 13 of PLDCNT checked first, if set bits 14,15 ignored
*BIT 13 PLDCNT = repeat colors to fill full palette - lsbits address colors
*BIT 14 PLDCNT = 16 COLOR PALETTE
*BIT 15 PLDCNT = PALETTE	  B4-B7
PALTRANS:
	MOVI	PTRRAM,A0
	MOVK	NUMPTR,A3 	;# OF PALETTES
PLTLP:
	MOVE	*A0,A4,W	;XFER TO DO
	JREQ	PLTX		;NO, QUIT
PLTGO:
	CLR	A1
	MOVE	A1,*A0+,W		;CLEAR OUT TRANFER COUNT
	MOVE	*A0+,A1,L		;SOURCE ADDRESS
	MOVE	*A0+,A2,W		;DESTINATION PALETTE
	SLL	4,A2			;ADJUST FOR BIT ADDR
	ADDI	COLRAM,A2		;ADD IN COLOR RAM BASE ADDRESS
	BTST	13,A4
	JRNE	PLTRPT			;PALETTE REPEATS
	BTST	14,A4
	JRNE	PLTSPEC			;SPECIAL PALETTE
	SRL	1,A4			;ODD DATA COUNT
	JRNC	PLTGO1			;NOPE
	MOVE	*A1+,*A2+,W
PLTGO1:
	SRL	1,A4			;/2 DATA COUNT
	JRNC	PLTGO2			;NOPE
	MOVE	*A1+,*A2+,L
PLTGO2:
	SRL	1,A4			;/2 DATA COUNT
	JRNC	PLTGO3			;NOPE
	MOVE	*A1+,*A2+,L
	MOVE	*A1+,*A2+,L
PLTGO3:
	JREQ	PLTGO4			;DONE
	MOVE	*A1+,*A2+,L
	MOVE	*A1+,*A2+,L
	MOVE	*A1+,*A2+,L
	MOVE	*A1+,*A2+,L
	DSJS	A4,PLTGO3
PLTGO4:
	DSJS	A3,PLTLP	;DONE
PLTX:	
	RETS

*repeat colors in palette
PLTRPT:
	sll	24,A4
	srl	24,A4
	movk	1,A6
	movi	0100H,A7		;A7 # of times to repeat plotting colors
	cmp	A4,A6
	jreq	GotColCt
GetColCt:
	srl	1,A7
	sll	1,A6 		;A6 # of colors to copy
	cmp	A4,A6
	jrlt	GetColCt
GotColCt:
	
	move	A6,A4
	move	A1,A5
TransLp:
	move	*A1+,*A2+,W
	dsjs	A4,TransLp
	move	A6,A4
	move	A5,A1
	dsjs	A7,TransLp
	JRUC	PLTGO4

*SPECIAL 16 COLOR PALETTE
*A1=SOURCE
*A2=DESTINATION
*BIT 14 PLDCNT = 16 COLOR PALETTE
*BIT 15 PLDCNT = PALETTE	  B4-B7
PLTSPEC:
	BTST	15,A4
	JRNE	PLTSPC1
	MMFM	A1,A5,A6,A7,A8,A9,A10,A11,A12
	ADDI	01000H,A2
	MOVK	16,A4
PLTSPL:
	MMTM	A2,A5,A6,A7,A8,A9,A10,A11,A12
	DSJS	A4,PLTSPL
	JRUC	PLTGO4
PLTSPC1:
	MOVK	16,A4
PLTSPC1L:
	MOVE	*A1+,A5,W
	MOVE	A5,A6
	SLL	16,A5
	ADD	A6,A5
	MOVE	A5,*A2+,L
	MOVE	A5,*A2+,L
	MOVE	A5,*A2+,L
	MOVE	A5,*A2+,L
	MOVE	A5,*A2+,L
	MOVE	A5,*A2+,L
	MOVE	A5,*A2+,L
	MOVE	A5,*A2+,L
	DSJS	A4,PLTSPC1L
	JRUC	PLTGO4
*	
*SETUP PALETTE TRANSFER
*CALLING PARAMETERS:
*A0= PALSRC = 32 BIT SOURCE ADDRESS OF PALETTE COLOR DATA 	
*A1= PALDEST = BIT 8-15 DESTINATION PALETTE | BIT 0-7 START COLOR
*A2= PLDCNT = 16 BIT COLOR COUNT
*RETURNS: EQ IF UNABLE TO SETUP TRANSFER, NE IF TRANSFER O.K.
*
PALSET:
	MMTM	SP,A3,A4,A5
	MOVI	PTRRAM,A4
	MOVK	NUMPTR,A3	;# OF PALETTE TRANSFERS ALLOWED
PALSTL:
	MOVE	*A4,A5,W	;CELL TAKEN ?
	JRNE	PALST1		;YES, KEEP LOOKING
	MOVE	A0,*A4(PALSRC),L	;NO, LOAD IT UP
	MOVE	A1,*A4(PALDEST),W
	MOVE	A2,*A4(PLDCNT),W
	JRUC	PALSTX
PALST1:	
	ADDI	PTRSIZ,A4
	DSJS	A3,PALSTL
PALSTX:	
	MOVE	A3,A3		;RETURN EQ(NOT ABLE TO LOAD) OR NE (OK)
	MMFM	SP,A3,A4,A5
	RETS

	.END
