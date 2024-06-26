	.FILE	"NARCMINE.ASM"
	.TITLE	" <<< N  A  R  C  -- LAND MINES >>>"
	.WIDTH	132
	.OPTION	B,D,L
	.MNOLIST	

*	GET THE SYSTEM STUFF
	.include	"..\sys\mprocequ.asm"	;mproc equates
	.include	"..\sys\dispequ.asm"	;display processor equates
	.include	"..\sys\gsp.inc"	;gsp assembler equates
	.include	"..\sys\sys.inc"	;zunit system equates
	.include	"..\sys\macros.hdr"	;macros, yeah!
*	LOCAL STUFF
	.INCLUDE	"NARCEQU.ASM"		;NARC Equates
	.INCLUDE	"IMGTBL.GLO"		;Image Label Equates
	.EVEN
	.TEXT
	.GLOBAL	NEXPLODE,NEXAIR,WEEDCOLD,NUCLEXP,NEXINIT

**************************************************************************
*                                                                        *
* MINECOLD - MINE COLD START						 *
* A5 = [Y,X] UPPER LEFT							 *
* A6 = [0,Z]								 *
* TYPES:	8 = NORMAL LANDMINE					 *
* 		9 = HIDDEN MINE, RAISES AT SOME RANDOM TIME		 *
*                                                                        *
**************************************************************************
MINECOLD
	MOVE	A6,A11	
	MOVE	A5,A10				
	OR	A5,A6
	JRNZ	MINEPOSG		;WE GOT US A POSITION
	MOVK	1,A5			;FLAG RANDOM POSITION(S)
	JRUC	MINEDOIT
MINEPOSG
	CLR	A5			;FLAG CONSTANT POSITION(S)
MINEDOIT
	MOVE	A14,A6
	SLL	8,A6
	SRL	28,A6			;GRAB # TO START
	MOVE	A14,A0
	SLL	12,A0
	SRL	28,A0			;GRAB RANDOM # TO START
	JRZ	MINENORN		;BR = NO RANDOM # TO START
	CALLA	RANDU
	ADD	A0,A6
MINENORN
	MOVI	LMINEPID,A1
	SLL	28,A14
	SRL	28,A14
	CMPI	9,A14
	JRNE	MINENORM		;BR = DEFAULT TO NORMAL MINE THANG	
	MOVI	HIDEMINE,A7
	JRUC	MINELP
MINENORM
	MOVI	LANDERM,A7
MINELP
	MOVE	A5,A5
	JRZ	MINECR			;BR = JUST CREATE WITH GIVEN POS.
	CLR	A11			;OTHERWISE RANDOM [Y,X]
	MOVE	@PLYMIN,B0,W
	MOVE	@PLYMAX,B1,W
	SUBK	32,B1
	CALLA	RANGRAND
	SLL	16,A0
	MOVY	A0,A10
	MOVI	512,B0
	MOVE	B0,B1
	SLL	1,B1
	CALLA	RANGRAND
	MOVX	A0,A10
	MOVE	@WORLDTL,A0,L
	ADDXY	A0,A10			;OFFSET TO THE CURRENT WORLD
MINECR
	CALLA	GETPRC
	DSJ	A6,MINELP	
	RETS

*
*LAND MINE INIT TABLE
LANDINIT
	.LONG	0,0,0,0
	.WORD	0,0
	.LONG	LANDMINE,LANDMZ,LMCOLL
	.WORD	DMAWNZ,BEOID|LANDMOID
	.LONG	0

**************************************************************************
*                                                                        *
* LANDERM - NORMAL LANDMINE THAT JUST SITS THERE LIKE A BUMP		 *
* A10 = [Y,X] POSITION							 *
* A11 = [0,Z] IF Z = ZERO THEN OBJECT IS CONSIDERED ON THE GROUND	 *
*                                                                        *
**************************************************************************
LANDERM
	CALLR	INITMINE
	JAZ	DUMDIE
	MOVI	EXPLOSIONS,A1
	CALLA	INSOBJ
	CALLA	ADDSUPP			;O.K. HERE IT IS
	CLR	A0
	MOVE	A0,*A8(OPLINK),L
	DIE

**************************************************************************
*                                                                        *
* HIDEMINE - HIDDEN LANDMINE COMES OUT OF THE GROUND AT SOME RANDOM TIME *
* A10 = [Y,X] POSITION							 *
* A11 = [0,Z] IF Z = ZERO THEN OBJECT IS CONSIDERED ON THE GROUND	 *
*                                                                        *
**************************************************************************
HIDEMINE
	CALLR	INITMINE
	JAZ	DUMDIE
	MOVE	*A8(OIMG),A14,L
	MOVE	*A14(ISIZEY),A2,W	;GET THE AMOUNT TO CLIP
	DEC	A2
	MOVK	1,A1
	MOVE	A1,*A8(OSIZEY),W 	;CUT THE SUCKA DOWN
	MOVE	*A8(OYPOS),A1,W
	ADD	A2,A1			;OFFSET THE Y POSITION
	MOVE	A1,*A8(OYPOS),W
	MOVE	A2,A9			;STORE ITERATION COUNT
HIDEMLP
	CALLA	SCRTST
	JRZ	HIDEW
	SLOOP	15,HIDEMLP
HIDEW
	MOVI	5,B0			;SLEEP ANYTIME FROM 1
	MOVI	20H,B1			;TO 10 SECONDS
	CALLA	RANGRAND
	CALLA	PRCSLP
	MOVE	A8,A0
	CALLA	INSOBJ			;TIME TO WAKE UP CHARLIE
	MOVK	5,A11			;FIVE PIXEL FAIR WARNING
HIDEUILP
	MOVE	*A8(OYPOS),A1,W		
	DEC	A1
	MOVE	A1,*A8(OYPOS),W
	MOVE	*A8(OSIZEY),A1,W
	INC	A1
	MOVE	A1,*A8(OSIZEY),W
	SLEEP	5
	DEC	A9
	DSJS	A11,HIDEUILP
	MOVI	EXPLOSIONS,A1
	MOVE	A8,A0
	CALLA	ADDSUPP			;NOW MAKE IT DESPICABLE
HIDEULP
	MOVE	*A8(OYPOS),A1,W		;UNCOVER THE DEADLY TRUTH REST		
	DEC	A1
	MOVE	A1,*A8(OYPOS),W
	MOVE	*A8(OSIZEY),A1,W
	INC	A1
	MOVE	A1,*A8(OSIZEY),W
	SLEEP	5
	DSJS	A9,HIDEULP
	CLR	A0
	MOVE	A0,*A8(OPLINK),L	;DE-LINKIFY
	DIE

**************************************************************************
*                                                                        *
* INITMINE - INITIALIZE THE MINE OBJECT					 *
* A10 = [Y,X] POSITION							 *
* A11 = [0,Z] IF Z = 0 THEN OBJECT IS GROUNDED				 *
* RETURNS:								 *
* Z BIT SET = FAILURE A0 = A8 = 0					 *
* Z BIT CLR = SUCCESS A0 = A8 = PTR TO MINE OBJECT			 *
*                                                                        *
**************************************************************************
INITMINE
	PUSH	A14
	MOVI	LANDINIT,A14
	CALLA	GPALOBJ			;GET US AN OBJECT
	JAZ	INITMX			;NO LUCK CHEESE BALL
	CALLA	STFOBJ			;STUFF IT UP DUDE
	MOVE	A0,A8
	MOVE	A13,*A0(OPLINK),L
	CLR	A14
	MOVX	A10,A14
	MOVE	A14,*A0(OXPOS),W
	MOVY	A10,A14
	SRL	16,A14
	MOVE	A14,*A0(OYPOS),W
	MOVE	A11,A11
	JRZ	LANDSETZ
	MOVE	A11,*A0(OZPOS),W
	JRUC	LANDMGO
LANDSETZ
	CALLA	SETZPOS
LANDMGO
	MOVE	A0,A0			;CLR Z BIT
INITMX
	PULL	A14
	RETS
*
*LAND MINE CAR COLLISION
*A0 = PTR TO CAR
*A8 = PTR TO LAND MINE
LMCOLCAR
	MOVI	CEXPLODE,A7		;BIG CAR EXPLOSION
	MOVI	CEXPID,A1
	JRUC	LMCOLL3
*
*LAND MINE NORMAL COLLISION
*A8 = PTR TO THING THAT STEPPED ON IT
*A0 = PTR TO LAND MINE
LMCOLL1 
	MOVI	NEXPLODE,A7    		;NORMAL EXPLOSION
	MOVI	REXPID,A1		;EXPROSION PROCESS I.D.	
LMCOLL3
	MOVE	*A0(OZPOS),A2,W		;LAND MINE Z
	MOVE	*A0(OFLAGS),A9,W
	SLL	16,A9
	MOVX	A2,A9			;A9 = OFLAGS:OZPOS
	MOVE	*A0(OXPOS),A3,W
	MOVE	*A0(OSIZEX),A2,W
	SRA	1,A2
	ADD	A2,A3
	MOVE	*A0(OYPOS),A2,W
	MOVE	*A0(OSIZEY),A10,W
	ADD	A10,A2
	SLL	16,A2

	MOVE	*A0(OID),A10,W		;A10 = ROCKET I.D.
	MOVY	A2,A11
	MOVX	A3,A11			;PASS MINE BOTTOM MIDDLE [Y,X] 
	MOVE	A0,B0
	CALLA	GETPRC			;CREATE THE ROCKET EXPLOSION
	MOVE	B0,A0
	MOVE	*A0(OPLINK),A0,L
	JRZ	LMCOLL4
	CALLA	KILL
LMCOLL4
	MOVE	B0,A0
	MOVI	EXPLOSIONS,A1
	CALLA	DELSUPP
	CALLA	DELSOBJ
	CLR	A0
	INC	A0
	RETS

**************************************************************************
*                                                                        *
* WEEDCOLD - SOME KIND OF WEED COLD START				 *
* A5 = [Y,X] UPPER LEFT							 *
* A6 = [0,Z]								 *
* TYPES:	8 = BOOBY TRAPPED WEED					 *
*                                                                        *
**************************************************************************
WEEDCOLD
	MOVE	A6,A11	
	MOVE	A5,A10				
	OR	A5,A6
	JRNZ	WEEDPOSG		;WE GOT US A POSITION
	MOVK	1,A5			;FLAG RANDOM POSITION(S)
	JRUC	WEEDDOIT
WEEDPOSG
	CLR	A5			;FLAG CONSTANT POSITION(S)
WEEDDOIT
	MOVE	A14,A6
	SLL	8,A6
	SRL	28,A6			;GRAB # TO START
	MOVE	A14,A0
	SLL	12,A0
	SRL	28,A0			;GRAB RANDOM # TO START
	JRZ	WEEDNORN		;BR = NO RANDOM # TO START
	CALLA	RANDU
	ADD	A0,A6
WEEDNORN
	MOVI	WEEDPID,A1
	SLL	28,A14
	SRL	28,A14
	CMPI	8,A14
	JRNE	WEEDNORM		;BR = DEFAULT TO NORMAL WEED THANG	
	MOVI	BTWEED,A7
	JRUC	WEEDLP
WEEDNORM
	MOVI	WEEDPLANT,A7
WEEDLP
	MOVE	A5,A5
	JRZ	WEEDCR			;BR = JUST CREATE WITH GIVEN POS.
	CLR	A11			;OTHERWISE RANDOM [Y,X]
	MOVE	@PLYMIN,B0,W
	MOVE	@PLYMAX,B1,W
	SUBK	32,B1
	CALLA	RANGRAND
	SLL	16,A0
	MOVY	A0,A10
	MOVI	512,B0
	MOVE	B0,B1
	SLL	1,B1
	CALLA	RANGRAND
	MOVX	A0,A10
	MOVE	@WORLDTL,A0,L
	ADDXY	A0,A10			;OFFSET TO THE CURRENT WORLD
WEEDCR
	CALLA	GETPRC
	DSJ	A6,WEEDLP	
	RETS

*
*WEED PLANT INIT TABLE
WEEDINIT
	.LONG	0,0,0,0
	.WORD	0,0
	.LONG	WEED,WEEDZ,WEEDCOLL
	.WORD	DMAWNZ,BEOID|LANDMOID
	.LONG	0

**************************************************************************
*                                                                        *
* WEEDPLANT - NORMAL WEEDPLANT THAT JUST SITS THERE LIKE A BUMP		 *
* A10 = [Y,X] POSITION							 *
* A11 = [0,Z] IF Z = ZERO THEN OBJECT IS CONSIDERED ON THE GROUND	 *
*                                                                        *
**************************************************************************
WEEDPLANT
	CALLR	INITWEED
	JAZ	DUMDIE
	CALLA	INSOBJ
	CLR	A0
	MOVE	A0,*A8(OPLINK),L
	DIE

**************************************************************************
*                                                                        *
* BTWEED - BOOBY TRAPPED WEED PLANT EXPLODES WHEN YOU TOUCH IT		 *
* A10 = [Y,X] POSITION							 *
* A11 = [0,Z] IF Z = ZERO THEN OBJECT IS CONSIDERED ON THE GROUND	 *
*                                                                        *
**************************************************************************
BTWEED
	CALLR	INITWEED
	JAZ	DUMDIE
	MOVI	EXPLOSIONS,A1
	CALLA	INSOBJ
	CALLA	ADDSUPP			;O.K. HERE IT IS
	CLR	A0
	MOVE	A0,*A8(OPLINK),L
	DIE

**************************************************************************
*                                                                        *
* INITWEED - INITIALIZE THE WEED OBJECT					 *
* A10 = [Y,X] POSITION							 *
* A11 = [0,Z] IF Z = 0 THEN OBJECT IS GROUNDED				 *
* RETURNS:								 *
* Z BIT SET = FAILURE A0 = A8 = 0					 *
* Z BIT CLR = SUCCESS A0 = A8 = PTR TO WEED OBJECT			 *
*                                                                        *
**************************************************************************
INITWEED
	PUSH	A14
	MOVI	WEEDINIT,A14
	CALLA	GPALOBJ			;GET US AN OBJECT
	JAZ	INITWX			;NO LUCK CHEESE BALL
	CALLA	STFOBJ			;STUFF IT UP DUDE
	MOVE	A0,A8
	MOVE	A13,*A0(OPLINK),L
	CLR	A14
	MOVX	A10,A14
	MOVE	A14,*A0(OXPOS),W
	MOVY	A10,A14
	SRL	16,A14
	MOVE	A14,*A0(OYPOS),W
	MOVE	A11,A11
	JRZ	WEEDSETZ
	MOVE	A11,*A0(OZPOS),W
	JRUC	WEEDMGO
WEEDSETZ
	CALLA	SETZPOS
WEEDMGO
	MOVE	A0,A0			;CLR Z BIT
INITWX
	PULL	A14
	RETS

*
*NEXPLODE - NUCLEAR EXPLOSION THANG
*A9 = OFLAGS:OZPOS OF ROCKET
*A10 = OID OF ROCKET
*A11 = YX POSITION OF ROCKET
*ENTER HERE FOR AIR BOMB
NEXAIR
	MOVI	AIRB1,A7
	JRUC	NEXPLODG
*ENTER HERE FOR GROUND BOMB
NEXPLODE:
	MOVI	NUCLEXP,A7		;GET ANIMATION TABLE
NEXPLODG
	MOVE	A7,*A13(PDATA),L
	MOVI	NEXINIT,A14
	CALLA	GPALOBJ
	JRZ	NEXXXDI		;BR = THERE'S NO PALETTES HERE	
	CALLA	STFOBJ
	MOVE	A13,*A0(OPLINK),L	;LINK IT TO THIS PROCESS

	SRL	4,A10
	SLL	4,A10
	ADDK	EXPLODID,A10	;MAKE THIS AN EXPLOSION
	MOVE	A10,*A0(OID),W	;STUFF I.D.
	SUBK	EXPLODID,A10	;BACK HOME AGAIN	

	MOVE	A9,*A0(OZPOS),W	;GONNA SET US A Z POSITION, YESIREE
	MOVI	REXOFF,A8
	SRL	20,A9		;GET FLAGS INTO POSITION
	SLL	4,A9
	ORI	DMAWNZ,A9	;MAKE SURE THE WRITE IS CORRECT
	BTST	B_FLIPH,A9	;AND TEST FOR FLIP
	JREQ	NEX2		;BR = ROCKET NOT FLIPPED
	NEG	A8
NEX2
	ADDXY	A8,A11		;ADD IN THE OFFSET

	CLR	A2
	MOVY	A11,A2		;SET Y POSITION
	MOVX	A11,A3
	SLL	16,A3		;SET X POSITION
	MOVE	A9,A4
	CALLA	GANISAG		;ADJUST

	CALLA	INSOBJ
	MOVI	EXPLOSIONS,A1	;INSERT ON THE EXPLOSIONS LIST	
	CALLA	ADDSUPP		;ADD IT TO THE CORRECT SUPPLEMENTAL LIST
	MOVE	A0,A8
	
	MOVE	*A13(PDATA),A9,L

	MOVI	SND1,A0
	CALLA	ONESND		;EXPLODE WITH NOISE

	CLR	A1
NEX3	JSRP	FRANIM
	JRC	NEXXX

***	MOVE	*A8(OZPOS),A0,W
***	ADDK	2,A0
***	MOVE	A0,*A8(OZPOS),W	;EXPLODE OUTWARDS PLEASE
	JRUC	NEX3
NEXXX
	MOVE	A8,A0		;GET BACK FOR DELETE
	MOVI	EXPLOSIONS,A1
	CALLA	DELSUPP		;UN-SUPP ME
	MOVK	1,A1
	JSRP	FRANIM		;ANIMATE THE REST
	MOVE	A8,A0
	CALLA	DELPAL
	CALLA	DELOBJ		;TAKE IT AWAY
NEXXXDI
	JAUC	SUCIDE
*
*NUCLEAR BOMB EXPLOSION
NEXINIT
	.LONG	0,0,0,0
	.WORD	0,0
	.LONG	nb1grnd,NEXZ,DUMCOLL
	.WORD	DMAWNZ,0
	.LONG	0

AIRB1:
	.long	nb1
	.word	NEWPALET|4
	.long	newbom
	.long	nb2a
	.word	6
	.long	nb3a
	.word	5
	LONGNULL
AIRB2:
	.long	nb4
	.word	4
	.long	nb5
	.word	3
	.long	nb6
	.word	3
	.long	nb7
	.word	3
	.long	nb8
	.word	3
	.long	hiro9air
	.word	3
	.long	hiro10air
	.word	3
	.long	hiro11air
	.word	3
	LONGNULL

*
*NUCLEAR EXPLOSION ANIMATION
NUCLEXP
	.long	nb1grnd
	.word	3
	.long	hiro1
	.word	5
	.long	hiro2
	.word	5
	.long	hiro3
	.word	5
	.long	hiro4
	.word	4
	LONGNULL
	.long	hiro5			;TAKE IT OFF OF THE EXPLOSIONS LIST
	.word	3
	.long	hiro6
	.word	3
	.long	nb5grnd
	.word	3
	.long	nb6grnd
	.word	3
	.long	nb7grnd
	.word	3
	.long	nb8grnd
	.word	3
	.long	hiro9
	.word	3
	.long	hiro10
	.word	3
	.long	hiro11
	.word	3
	LONGNULL

*
*WEED PLANT COLLISION
*
*LAND MINE COLLISION
WEEDCOLL
	.WORD	B1OID|EXPLODID
	.LONG	LMCOLL1
	.WORD	B2OID|EXPLODID
	.LONG	LMCOLL1
	.WORD	BEOID|EXPLODID
	.LONG	LMCOLL1
	.WORD	P1OID
	.LONG	LMCOLL1
	.WORD	P2OID
	.LONG	LMCOLL1
	.WORD	0
	.LONG	DUMRTSG
*
*LAND MINE COLLISION
LMCOLL
	.WORD	C1OID|CBODYID
	.LONG	LMCOLCAR
	.WORD	CAR2OID|CBODYID
	.LONG	LMCOLCAR
	.WORD	CAR3OID|CBODYID
	.LONG	LMCOLCAR
	.WORD	TRAN1OID|CBODYID
	.LONG	LMCOLCAR
	.WORD	B1OID|EXPLODID
	.LONG	LMCOLL1
	.WORD	B2OID|EXPLODID
	.LONG	LMCOLL1
	.WORD	BEOID|EXPLODID
	.LONG	LMCOLL1
	.WORD	P1OID
	.LONG	LMCOLL1
	.WORD	P2OID
	.LONG	LMCOLL1
	.WORD	CLOWNOID
	.LONG	LMCOLL1
	.WORD	DUMPOID
	.LONG	LMCOLL1
	.WORD	LOFOID
	.LONG	LMCOLL1
	.WORD	LOFOID|1
	.LONG	LMCOLL1
	.WORD	LOFOID|2
	.LONG	LMCOLL1
	.WORD	LOFOID|3
	.LONG	LMCOLL1
	.WORD	LOFOID|4
	.LONG	LMCOLL1
	.WORD	LOFOID|5
	.LONG	LMCOLL1
	.WORD	LOFOID|6
	.LONG	LMCOLL1
	.WORD	DOGOID|0
	.LONG	LMCOLL1
	.WORD	HYPOEOID|0
	.LONG	LMCOLL1
	.WORD	BGGID
	.LONG	LMCOLL1
	.WORD	BGDMPID
	.LONG	LMCOLL1
	.WORD	0
	.LONG	DUMRTSG

