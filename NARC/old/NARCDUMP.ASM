	.FILE	'DUMP.ASM'
	.TITLE	" <<< D U M P S T E R   M A N >>>"

**************************************************************************
*                                                                        *
* 	COPYRIGHT (C) 1988 WILLIAMS ELECTRONICS GAMES, INC. 		 *
* 	ALL RIGHTS RESERVED.						 *
*                                                                        *
**************************************************************************

	.WIDTH	132
	.OPTION	B,D,L
	.MNOLIST

*	GET THE SYSTEM STUFF
	.INCLUDE	"\video\MPROCEQU.ASM"	;MPROC equates
	.INCLUDE	"\video\DISPEQU.ASM"	;Display processor equates
	.INCLUDE	"\video\GSP.INC"	;GSP assembler equates
	.INCLUDE	"\video\SYS.INC"	;Zunit system equates
	.INCLUDE	"\video\MACROS.HDR"	;Macros, Yeah!
*	LOCAL STUFF
	.INCLUDE	"NARCEQU.ASM"		;NARC Equates
	.INCLUDE	"IMGTBL.GLO"		;Image Label Equates
	.INCLUDE	"NARCTEQU.ASM"		;TODD JIZZ
	.INCLUDE	"NARCDUMP.TBL"		;Image Label Equates

	.GLOBAL	HEADBUTT,ZCHK
	.GLOBAL	DUMPCRM1,OIDATA

	.TEXT
*
*DUMPSTER MAN DISPATCHER
*
*DUMPDISP:
*DUMPDIS1:
*	MOVE	@DUMPCNT,A0,W		;HOW MANY DUMP BABIES?
*	MOVE	@DUMPMAX,A1,W
*	CMP	A0,A1
*	JRLS	DUMPDIS4		;DON'T NEED MORE
*
*	CLR	A5
*	MOVI	>0E50,A14		;OID
*	CALLR 	DUMPCOLD
*	DEC	A11
*	JAEQ	SUCIDE			;CASH IT IN FOLKS
*DUMPDIS4:
*	SLOOP	30,DUMPDIS1		;WAIT FOR THEM TO DIE
*
*DUMPSTER MAN COLD START 
*A5=Y:X
*A6=Z
*A14=OID
DUMPCOLD:		
	MOVE	A5,A9
	MOVE	A14,A10
	CREATE	0E5H,DUMPMAN
	RETS
*
*DUMPSTER MAN PROCESS
*A9=XY COORD
*A10=OID
*
DUMPMAN:
	MOVE	A9,A9
	JRNE	DUMPWST		;ALREADY GOT COORDINATE
	MOVE	@WORLDTL,A1,W  	;COME FROM EDGE OF SCREEN
	CALLA	RANDOM
	MOVE	A0,A0
	JRN	DUMP2X 		
	ADDI	512,A1		;START HIM AT RIGHT SCREEN EDGE
DUMP2X:
	ZEXT	A1			;Y COORDINATE
	MOVE	@PLYMIN,B0,W
	MOVE	@PLYMAX,B1,W
	CALLA	RANGRAND
	SUBI	93,A0
	SLL	16,A0
	ADD	A0,A1
	MOVE	A1,A9
*
*WARM START DUMPMAN 
*A9=STARTING COORD.
*A10=OID
DUMPWST:
	MOVE	@DUMPCNT,A0,W		;HOW MANY DUMP BABIES?
	MOVE	@DUMPMAX,A1,W
	CMP	A0,A1
	JALS	SUCIDE			;DON'T NEED MORE

	MOVE	@DUMPSHT,A0,W		;SHOTS TO TAKE
	MOVE	A0,A1
	CALLA	RANDU
	ADD	A1,A0
	MOVE	A0,*A13(ETEMP3),W	;SETUP SHOT COUNT

	MOVE	A9,A1		;GET Y:X COORD
	MOVI	[1,1],A5	;SET SPEED
	MOVI	DUMPTAB,A6
	MOVI	DUMPINIT,A14	;DUMP ENEMY INIT
	MMTM	SP,A10		;SAVE YOUR OID
	CALLA	ENINITUL	;CREATE DUMP
	MMFM	SP,A10
	JAEQ	SUCIDE		;CREATE ERROR, EXIT

	MOVE	A10,*A8(OID),W
	MOVE	@DUMPCNT,A0,W
	INC	A0
	MOVE	A0,@DUMPCNT,W 	;INCREMENT DUMP COUNT
	MOVE	A8,A0
	CALLA	DELSHAD
*
*DUMPSTER MAN PROCESS
*
GCAN0:
	CLR	A0
	MOVE	A0,*A13(ETEMP1),W		;HAS NO CAN
	MOVE	A0,*A13(ETEMP2),L	;NO CAN YET
	MOVI	DUMPWLK,A9	;ANIMATION SCRIPT
GCAN01
	CALLR	GETCAN		;TARGET CAN IN A11
	JREQ	GPLAYR		;GO HEAD BUTT PLAYER

	MOVE	*A8(OID),A0,W
	BTST	0,A0
	JRNE	GPLAYR		;ALWAYS GET PLAYER SUBTYPE ODD
	
	MOVE	@DUMPBTT,A0,W	;GET BUTT PROB
	SRL	1,A0
	CALLA	RANDPER		;HEAD BUTT ODDS
	JRC	GPLAYR
GCANLP:
	CALLA	ZCHK
	MOVK	4,A1
	JSRP	FRANIM
	JRNC	GCANL1
	MOVI	DUMPWLK,A9
	JRUC	GCANLP
GCANL1:
	SRL	1,A0
	MOVE	A0,A10		;SAVE SLEEP TIME	
	CALLR	CKPLAYR		;CLOSE TO PLAYER ???
	JRNC	GCANLL		;NO, GET CAN
	MOVE	@DUMPBTT,A0,W
	CALLA	RANDPER
	JRC	GPLAYR		;GO GET IM....
GCANLL:
	MOVE	A11,A0		;IS THE CAN STILL THERE??
	MOVE	@BACKSLST,A1,L
	CALLA	ON_SLIST
	JRNC	GCAN01		;CAN IS MISSING GET ANOTHER
	CALLR	CKCAN		;ARE WE THERE YET ?
	JRNC	GCANL3		;NOPE...
	MOVE	*A8(OXVEL),A0,L	;NO X VEL ?
	JREQ	GCANL3		;GIVE HIM XVEL
	CLR	A0
	MOVE	A0,*A8(OZVEL),L	;COOL VELOCITY
	MOVE	A0,*A8(OYVEL),L	;COOL VELOCITY
	CALLA	SHVELCPY  	;DO IT FOR SHADOW
	CMPI	25,A3
	JRLO	GCANL4		;TOO CLOSE
	MOVE	A1,A1		;TEST SIGN OF A1
	JRN	GCANL20		;ADJUST YOUR FLIP TO GET CAN
	CALLA	NOYFLP
	JRUC	PKCAN
GCANL20:
	CALLA	YFLP
	JRUC	PKCAN		;WE'RE CLOSE, TIME TO GRAB IT
GCANL3:
	CALLR	DMPDIR		;GET DIRECTION AND VELOCITY
GCANL4:
	SLEEP	2
	DSJ	A10,GCANLL
	JRUC	GCANLP		;NOPE, KEEP GOING
*
*HIT BY SOMETHING WHILE WALKING
*A8=OBJECT
*A13=PROCESS
DWHIT:
	CLR 	A0			;RESET HIT FLAG
	MOVE	A0,*A13(EFLAGS),W
	MOVE	*A8(OXPOS),A1,W		;KNOCK HIM A BIT
	SUBK	2,A1
	MOVE	A1,*A8(OXPOS),W

	SRAM	2,*A8(OXVEL),L		;SLOW HIM DOWN
	SRAM 	2,*A8(OYVEL),L
	SRAM	2,*A8(OZVEL),L
	CALLA	SHVELCPY		;COPY VELOCITIES TO SHADOW
	MOVI	DUMPHIT,A9
	MOVK	1,A1
	JSRP	FRANIM			;RUN YOUR HIT UNTIL DONE
	SLLM	2,*A8(OXVEL),L		;SPEED HIM BACK UP
	SLLM 	2,*A8(OYVEL),L
	SLLM	2,*A8(OZVEL),L
	CALLA	SHVELCPY		;COPY VELOCITIES TO SHADOW
	RETP
*	
*HIT WHILE PICKING UP
*
DPHIT:
	CLR	A1
	MOVE	A1,*A13(ETEMP1),W	;CHANGE STATUS WORD, CAN IS THROWN
	MOVE	A1,*A13(ETEMP2),L	;NO MORE CAN ATTACHED	
        CREATE	0E1h,AIRCAN		;LET CAN FLY 
	MOVE	*A13(ETEMP4),*A0(ETEMP4),L
      	JRUC	DWHIT
*
*THROW THE CAN
*A8=DUMPSTER MAN
*A11=THE CAN
*
*PICK UP THE CAN
*
PKCAN:	
	MOVE	*A11(OPLINK),A0,L	;IS THERE A PROCESS
	JRNZ	GCAN0			;BR = YES, DON'T BOTHER WITH THIS 
	MOVE	A11,A0
	CALLA	ISBB
	JRNC	GCAN0			;BR = CAN IS NOT CORRECT
	CLR 	A0			;RESET HIT FLAG
	MOVE	A0,*A13(EFLAGS),W
	MOVK	1,A0
	MOVE	A0,*A13(ETEMP1)	;PICKING UP STAGE
	MOVE	A11,*A13(ETEMP2),L	;STORE CAN TARGET
	MOVE	*A11(OCVECT),*A13(ETEMP4),L
	MOVI	DUMCOLL,A1
	MOVE	A1,*A11(OCVECT),L
	CALLA	PSTOP		;STOP DUMPSTER MAN
	MOVI	DUMPICK,A9	;PICK UP ANIMATION
 	MOVI	PKOFFTAB,A10	;OFFSET TABLE FOR CAN
	MOVE	A11,A0
	MOVI	BACKSLST,A1
	CALLA	DELSUPP
	MOVI	ENEMIES,A1
	CALLA	ADDSUPP
	CALLA	DELBB		;PULL BLOCK OFF BACKGROUND LIST
	SWAP	A11,A8
	CALLA	SHADST		;GIVE CAN A SHADOW
	SWAP	A11,A8
	MOVI	CPICKSND,A0
	CALLA	ONESND
	
PKCAN0:	
	MOVE	*A13(EFLAGS),A0,W	;CHECK IF HIT
	JREQ	PKCAN1
	JSRP	DPHIT			;HIT WHILE PICKING UP
	JRUC	GCAN0			;GRAB IT AGAIN
PKCAN1:
	MOVE	*A11(OYPOS),A1,W 	;GET CURRENT CAN X,Y POS
	MOVE	*A11(OXPOS),A0,W
	MOVE	*A10+,A2,W		;ADD DELTAS
	MOVE	*A8(OFLAGS),A5,W
	BTST	B_FLIPH,A5
	JRZ	PKCAN2			;NO FLIP
	NEG	A2			;NEGATE DELTA X FOR FLIP
PKCAN2:	
	MOVE	*A11(OZPOS),A5,W
	CLR	A7
	MOVE	*A10+,A3,W
	JREQ	PKCAN3
	MOVE	*A8(OZPOS),A6,W
	SUB	A5,A6
	SUBI	7,A6			;ADJUST Z?
	JREQ	PKCAN3			;NOPE, ZERO
	MOVK	1,A7
	JRNN	PKCAN3
	NEG	A7
PKCAN3:
	ADD	A7,A5
	MOVE	A5,*A11(OZPOS),W
	ADD	A2,A0
	ADD	A3,A1
	ADD	A7,A1
	MOVE	A0,*A11(OXPOS),W
	MOVE	A1,*A11(OYPOS),W

	MOVE	*A11(OSHAD),A4,L	;UPDATE SHADOW X
	JREQ	PKCAN00
	MOVE	*A4(OXPOS),A0,W
	ADD	A2,A0
	MOVE	A0,*A4(OXPOS),W
	MOVE	*A4(OZPOS),A5,W
	ADD	A7,A5
	MOVE	A5,*A4(OZPOS),W		;UPDATE SHADOW Z
	MOVE	*A4(OYPOS),A0,W
	ADD	A7,A0
	MOVE	A0,*A4(OYPOS),W		;UPDATE SHADOW Y
PKCAN00:
	CLR	A1
	JSRP	FRANIM		;RUN UNTIL PICKED UP
	JRNC	PKCAN0
*
*WALK WITH THE CAN
*
	MOVK	2,A0
	MOVE	A0,*A13(ETEMP1)	;WALK WITH CAN STAGE

	MOVI	DUMPTHWLK,A9
 	MOVI	COFFTAB,A10		;CARRY OFFSET TABLE
CARRYL:
	MOVI	200,A5
	MOVI	50,A6
	CALLA	GETCPLY
	MOVE	*A0(POBJ),A0,L 	;PLAYER OBJECT
	CALLA	XZCHK		;ARE WE IN POSITION
	JRC	THC00		;YES, THROW IT
	CALLR	DMPDIR		;NO GET DIRECTION
	MOVE	*A8(OXVEL),A1,L		;COPY VELOCITY TO CAN
	MOVE	A1,*A11(OXVEL),L
	MOVE	*A8(OZVEL),A1,L
	MOVE	A1,*A11(OZVEL),L
	MOVE	A1,*A11(OYVEL),L
	SWAP	A8,A11
	CALLA	SHVELCPY  	;GET CAN SHADOW
	SWAP	A8,A11
	MOVE	*A10+,A0,W	;ADD OFFSET FOR X POSITION
	MOVE	*A8(OFLAGS),A1,W
	BTST	B_FLIPH,A1
	JRNE	CARRY02A
	NEG	A0
CARRY02A:
	ADDRM	A0,*A11(OXPOS),W
	MOVE	*A11(OSHAD),A4,L
	JREQ	CARRY03
	ADDRM	A0,*A4(OXPOS),W
CARRY03:
	MOVE	*A10+,A0,W	;ADD OFFSET FOR Y POSITION
	ADDRM	A0,*A11(OYPOS),W
	CLR	A1
	JSRP	FRANIM		;RELOAD FRANIM AT END
	JRNC	CARRY1
	MOVI	DUMPTHWLK,A9
 	MOVI	COFFTAB,A10		;CARRY OFFSET TABLE
CARRY1:
	JRUC	CARRYL
*     
*THROW THE CAN
*
THC00
	MOVK	3,A0
	MOVE	A0,*A13(ETEMP1)		;THROWING STAGE

	CALLA	PSTOP  			;STOP DUMPSTER MAN
	SWAP	A8,A11
	CALLA	PSTOP			;STOP THE CAN
	SWAP	A8,A11
	CALLA	GETCPLY
	CALLA	FACEPLYR		;FACE THE DUDE
 	MOVI	THOFFTAB,A10		;OFFSET TABLE FOR CAN THROW
	MOVI	DUMPTHRW,A9		;THROW ANIMATION
THCAN0:	
	MOVE	*A13(EFLAGS),A0,W	;CHECK IF HIT
	JREQ	THCAN1
	SLEEP	8
THCAN1:
	MOVE	*A11(OYPOS),A1,W 	;GET CURRENT CAN X,Y POS
	MOVE	*A11(OXPOS),A0,W
	MOVE	*A10+,A2,W		;ADD DELTAS
	MOVE	*A10+,A3,W
	ADD	A2,A0
	ADD	A3,A1
	MOVE	A0,*A11(OXPOS),W
	MOVE	A1,*A11(OYPOS),W

	MOVE	*A11(OSHAD),A4,L	;UPDATE SHADOW X
	JREQ	THCAN00
	MOVE	*A4(OXPOS),A0,W
	ADD	A2,A0
	MOVE	A0,*A4(OXPOS),W
THCAN00:
	CMPI 	DUMPFLY,A9
	JRNE	THCAN01
	CALLR	FLYCAN 		;LAUNCH THE DUDE
THCAN0A:
	CLR	A1
	MOVE	A1,*A13(ETEMP1),W	;CHANGE STATUS WORD, CAN IS THROWN
	MOVE	A1,*A13(ETEMP2),L	;NO MORE CAN ATTACHED	
	CLR	A1
	JSRP	FRANIM			;RUN ANIMATION OUT
	JRC	GCAN0
	MOVE	*A13(EFLAGS),A0,W	;CHECK IF HIT
	JREQ	THCAN0A
	JSRP	DWHIT			;HIT WHILE PICKING UP
	JRUC	GCAN0			;GO GET ANOTHER

THCAN01
	CLR	A1
	JSRP	FRANIM		;RUN UNTIL THROWN
	JRNC	THCAN0
	JRUC	GCAN0		;GO GET ANOTHER ONE
*
*GET PLAYER AND HEAD BUTT
*A8=DUMPMAN OBJECT
GPLAYR:
	MOVI	500,A0			;GET TIME OUT VALUE
	CALLA	RANDU
	ADDI	250,A0
	MOVE	A0,A11
GPLAYR0:
	MOVI	DUMPWLK,A9
GPLAYR1:
	MOVK	4,A1
	JSRP	FRANIM
	MOVE	A0,A10		;SAVE SLEEP TIME
	JRC	GPLAYR0
GPLAYRL:
	CALLA	ZCHK		;STAY IN BOUNDS
	CALLA	GETCPLY
	MOVE	*A0(PFLAGS),A7,L
	MOVI	25,A5
	MOVI	15,A6
	MOVE	*A0(POBJ),A0,L 	;PLAYER OBJECT
	CALLA	XZCHK		;ARE WE IN POSITION
	JRNC	GPLAYR2		;NO, GET DIRECTION
	BTST	BJUMP2,A7	;PLAYER IN AIR ?
	JRNE	GPLAYR2		;YES, NO BUTT
	MOVE	A2,A2
	JRNN	GPLAYR2		;DONT DO IT IN BACK
	CMPI	15,A3
	JRHS	DMPBUTT		;NOT TOO CLOSE
	MOVE	*A8(OXVEL),A0,L	;NO X VEL ?
	JREQ	GPLAYR2		;GIVE HIM XVEL
	CLR	A0
	MOVE	A0,*A8(OZVEL),L	;COOL VELOCITY
	MOVE	A0,*A8(OYVEL),L	;COOL VELOCITY
	CALLA	SHVELCPY  	;DO IT FOR SHADOW
	JRUC	GPLAYR20
GPLAYR2:
	BTST	BJUMP2,A7	;PLAYER IN AIR ?
	JRZ	GPLYR20		;NO
	MOVI	15,A0		;YES, BE STUPID?
	CALLA	RANDPER
	JRNC	GPLAYR20	;YIP
GPLYR20:
	CALLR	DMPDIR		;NO GET DIRECTION
GPLAYR20:
	SLEEP	1
	DSJS	A11,GPLAYR3	;TIME OUT CHECK
	JRUC	GCAN0		;GO FOR A CAN
GPLAYR3:
	DSJ	A10,GPLAYRL
	JRUC	GPLAYR1
DMPBUTT:
	MOVE	A1,A1		;FLIP THE DUDE PROPERLY
	JRN	DMPBTT0
	CALLA	NOYFLP
	JRUC	DMPBTT1
DMPBTT0:
	CALLA	YFLP
DMPBTT1:
	CALLA	PSTOP			;STOP THE DUDE
	CALLA	GETCPLY
	MOVE	A0,A2
	CALLA	HEADBUTT
	MOVI	DUMPBUTT,A9		;GET ANIMATION
DMPBUT2:
	MOVK	1,A1
	JSRP	FRANIM			;BUTT HIM
	CALLA	RANDOM
	JRN	GPLAYR0			;GET HIM AGAIN
	MOVI	CHEADYEA,A0
	CALLA	ONESND
	JRUC	GCAN0			;GO FOR A CAN
**************************************************************************
*DUMPSTER MAN SOUNDS
* 									 *
* CHANNEL #0	CVSD SOUNDS						 *
* CHANNEL #1	DAC A							 *
* CHANNEL #2	DAC B							 *
* CHANNEL #3	MUSIC							 *
*                                                                        *
*SOUND DESCRIPTION= PRIORITY,TIME,SOUND CODE,(PRIORITY),(TIME),(SOUND CODE),0
*SOUND ENDS IN 0000.
*PRIORITY WORD = 1111IENNPPPPPPPP; I=1=NON-INTERRUPTABLE, E=1=NON-INT BY EQUAL
*NN=CHANNEL #(0-3);
*PP=PRIORITY (00-FF), FF=HIGHEST.
*TIME WORD =TTTT (0000-7FFF X 16MS).
*SOUND WORD =8SSS SSS=SOUND CODE(000-FFF).
*SOUND WORD =4SSS SSS=SOUND CODE (ZERO TIME SOUND CODE)
*CAN HIT SOUND
CNHTSND	.WORD	>F020,>12,>804F,01,>8002,0
*CAN THROW SOUND
CNTHSND	.WORD	>F020,>08,>801B,0
*CAN FLY SOUND
CNFLSND	.WORD	>F320,>10,>8093,0
*PICK UP SOMETHING
CPICKSND .WORD	>F020,>64,>8012,0
*HIT BY BULLET
CBULHITR .WORD  >F01F|>800,>38,>8023,0		;BULLET HITS
*THE "AFTER HEAD BUTT" GROWL
CHEADYEA .WORD	>F01F,>46,>8026,0
*
*LET IT FLY
*
FLYCAN:
	CALLA	GETCPLY
	MOVE	*A0(POBJ),A7,L		;PLAYER OBJECT
	MOVE	*A7(OXPOS),A2		;FORM DELTAS
	MOVE	*A7(OZPOS),A3
	MOVE	*A8(OXPOS),A0
	MOVE	*A8(OZPOS),A1
	SUB	A0,A2
	MOVE	A2,A4		;SAVE DELTA X
	SUB	A1,A3
	MOVK	10,A0		;ADD RANDOM OFFSET TO X
	CALLA	SRAND
	ADD	A0,A3
	MOVK	10,A0		;ADD RANDOM OFFSET TO Z
	CALLA	SRAND
	ADD	A0,A2
	ABS	A4
	CMPI	50,A4	   	;SHORT DISTANCE ?
	JRHS	FLYC1
	SLL	12,A2
	SLL	12,A3
	MOVI	>18000,A0
	JRUC	FLYC3
FLYC1:
	CMPI	100,A4	   	;SHORT DISTANCE ?
	JRHS	FLYC2
	SLL	11,A2
	SLL	11,A3
	MOVI	->10000,A0
	JRUC	FLYC3
FLYC2:
	SLL	10,A2
	SLL	10,A3
	MOVI	->30000,A0
FLYC3:
	MOVE	A2,*A11(OXVEL),L  	;LOAD UP CAN
	MOVE	A3,*A11(OZVEL),L
	ADD	A3,A0			;ADD ZVEL TO YVEL
	MOVE	A0,*A11(OYVEL),L
	SWAP	A11,A8
	CALLA	SHVELCPY
	SWAP	A11,A8
	MOVI	CNTHSND,A0		;MAKE YOUR GRUNT
	CALLA 	ONESND
        CREATE	0E1h,AIRCAN		;LET CAN FLY 
	MOVE	*A13(ETEMP4),*A0(ETEMP4),L
	RETS
*
*OFFSET TABLE FOR LIFTING CAN
*DX,DY
PKOFFTAB:
	.WORD	0,0,0,0,0,0,0,0,0,-10,0,-20,0,-20,-10,-16,-10,-7,-10,-7
*
*OFFSET TABLE FOR THROWING CAN
*DX,DY
THOFFTAB:
	.WORD	0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
*
*OFFSET TABLE FOR CARRYING CAN
*DX,DY
COFFTAB:
	.WORD	3,3,1,1,0,0,0,0,1,1,-2,-2,-3,-3,0,0,0,0
*
*CAN IN THE AIR
*A11 = CAN OBJECT
*
AIRCAN:	
	MOVE	A11,A8
	MOVE	A8,A0
	MOVI	ENEMIES,A1
	CALLA	DELSUPP
	MOVI	ENEMY_BULLETS,A1
	CALLA	ADDSUPP
AIRCANL:
	SLEEP	3
	CLR	A0		
	MOVE	*A8(OZPOS),A1,W		;CHECK IF Z LEGAL
	MOVE	@PLZMIN,A2,W
	ADDI	10,A2
	MOVE	@PLZMAX,A3,W
	SUBI 	10,A3
	CMP	A2,A1			;CHECK LOWER BOUND
	JRLT	ZBAD
	CMP	A3,A1
	JRLT	ZOK2
ZBAD:
	MOVE	A0,*A8(OZVEL),L		;ZERO ZV'S OF CAN AND SHADOW
	MOVE	*A8(OSHAD),A4,L
	JREQ	ZOK2
	MOVE	A0,*A4(OZVEL),L
	MOVE	A0,*A4(OYVEL),L
ZOK2:
	MOVE	*A8(OYVEL),A0,L		;EFFECT OF GRAVITY
	ADDI	>5000,A0
	MOVE	A0,*A8(OYVEL),L
	JRN	AIRCANL			;IF YV IS UP DONT STOP IT
	CALLA	DFRMGRND
	JRNN	AIRCANL			;IN THE AIR STILL

	MOVE	*A8(OYVEL),A0,L		;EFFECT OF GRAVITY
	CMPI	>10000,A0
	JRLS	CANLAND
	SRA	3,A0			;BOUNCE VELOCITY
	NEG	A0
	MOVE	A0,*A8(OYVEL),L		;CUT DOWN Y
	MOVE	*A8(OZVEL),A1,L		;CUT DOWN Z
	SRA	1,A1
	MOVE	A1,*A8(OZVEL),L
	MOVE	*A8(OXVEL),A0,L		;CUT DOWN X
	SRA	1,A0
	MOVE	A0,*A8(OXVEL),L
	MOVE	*A8(OSHAD),A4,L		;CUT DOWN X OF SHADOW
	JRZ	AIRCNLL
	MOVE	A0,*A4(OXVEL),L
	MOVE	A1,*A4(OZVEL),L
AIRCNLL:
	MOVI	CNHTSND,A0 		;MAKE YOUR SOUND
	CALLA 	ONESND
	JRUC	AIRCANL
CANLAND:
	CALLA	PSTOP			;STOP THE SUCKER   
	MOVE	A8,A0			;OBJECT IN A0 FOR SETZPOS
	CALLA	SETZPOS			;ADJUST THE MUTHA
	CALLA	DELSHAD			;GET RID OF SHADOW
	MOVI	CNHTSND,A0 		;MAKE YOUR SOUND
	CALLA 	ONESND
	MOVE	A8,A0
	MOVE	*A13(ETEMP4),*A0(OCVECT),L
	MOVI	ENEMY_BULLETS,A1
	CALLA	DELSUPP
	MOVI	BACKSLST,A1
	CALLA	ADDSUPP
	MOVK	1,A1 			;PUT HIM BACK IN BACKGROUND JIVE
	CALLA	ADDBB
*AIRCANX:
	JAUC	SUCIDE			;BAG IT....
*
*GET A GARBAGE CAN
*DUMPSTER MAN IN A8
*CAN RETURNED IN A11	
*RETURNS EQ IF NO CAN FOUND
*
GETCAN:
	MMTM	SP,A0
	MOVE	@BACKSLST,A11,L
	JREQ	GETCANX			;NOBODY HOME...
GETCAN0:
	MOVE	*A11(OIMG),A0,L		;IS IT A CAN ?
	CMPI	LAMPTOP,A0
	JREQ	GETCANL
	CMPI	LAMPOST,A0
	JREQ	GETCANL			;NO
	MOVE	*A11(OID),A0,W
	SRL	8,A0
	SLL	8,A0	 		;CHECK FOR GNARLY NO-NO OBJECTS
	CMPI	BGDCID,A0
	JREQ	GETCANL
	CMPI	BGGDCID,A0
	JREQ	GETCANL
	CMPI	BGWCID,A0
	JREQ	GETCANL

	MMTM	SP,A8
	MOVE	A11,A8
	CALLA	DFRMGRND		;ITS ON THE GROUND?
	MMFM	SP,A8
	ABS	A1
	CMPI	10,A1
	JRHI	GETCANL			;NOPE
	MOVE	A11,A11			;RETURN NE
	JRUC	GETCANX
GETCANL:
	MOVE    *A11(OSLINK),A11,L
	JRNE	GETCAN0
GETCANX:
	MMFM	SP,A0
	RETS
*
*CHECK FOR CAN INTERSECTION
*CALLING PARAMETERS:
*A8=DUMPSTER MAN
*A11=CAN HE IS GOING FOR
*RETURNS:
*CARRY SET IF HE IS CLOSE TO CAN
*A1=DELTA X
*A2=DELTA Y
*A3=ABS DELTA X
*A4=ABS	DELTA Z
CKCAN:
	MMTM	SP,A0,A8
	MOVE	*A8(OXPOS),A3,W
	MOVE	*A8(OSIZEX),A2,W 	;CHECK CENTERS
	SRL	1,A2
	ADD	A2,A3
	MOVE	*A8(OZPOS),A4,W
	MOVE	*A11(OXPOS),A1,W
	MOVE	*A11(OSIZEX),A2,W	;CHECK CENTERS
	SRL	1,A2
	ADD	A2,A1
	MOVE	*A11(OZPOS),A2,W
	SUB	A4,A2
	SUB	A3,A1
	MOVE	A1,A3
	MOVE	A2,A4
	ABS	A3
	ABS	A4
	CMPI	30,A3
	JRNC	CKCANX
	MOVE	A2,A2
	JRNN	CKCANF
	CMPI	14,A4
	JRUC	CKCANX
CKCANF:
	CLRC		;FAIL TEST
CKCANX:
	MMFM	SP,A0,A8
	RETS
*
*CHECK IF DUMPMAN CLOSE TO PLAYER
*RETURNS A7=PLAYER TO GO AFTER, CARRY SET IF IN RANGE
CKPLAYR:
	MMTM	SP,A0,A1,A2,A3,A4,A5,A6
	MOVI	P1DATA,A7		;OTHERWISE PLAYER ONE
	MOVE	*A7(POBJ),A0,L		;GET EXPECTED PLAYERS OBJECT	
	JREQ	CKPL1			;ZERO INDICATES DEAD
	MOVI	45,A5			;CHECK IF WERE CLOSE
	MOVI	30,A6
	CALLA	XZCHK
	JRC	CKPLX
CKPL1:
	MOVI	P2DATA,A7
	MOVE	*A7(POBJ),A0,L		;GET EXPECTED PLAYERS OBJECT	
	JREQ	CKPLX0			;PLAYER 2  DEAD
	MOVI	30,A5			;CHECK IF WERE CLOSE
	MOVI	20,A6
	CALLA	XZCHK
	JRC	CKPLX
CKPLX0:
	CLRC
CKPLX:
	MMFM	SP,A0,A1,A2,A3,A4,A5,A6
	RETS
*
*GET DIRECTION FOR DUMPSTER MAN
*A1=DELTA X
*A2=DELTA Z
*A3=ABS DX
*A4=ABS DZ
*A8=OBJECT
*
DMPDIR:
	MOVE	A3,A14		;SAVE ABS DX
	MOVE	@DUMPSPD,A3,W	;X VELOCITY
	SLL	8,A3		;NORMALIZE IT
	MOVE	A3,A4
	SRL	1,A4		;Z VELOCITY
	ABS	A1		;NEGATE FOR NEGATIVE X
	JRN	DMPDIR1
	NEG	A3
DMPDIR1:
	ADDI	7,A2   		;ADD IN FUDGE FACTOR
	ABS	A2		;NEGATE FOR NEGATIVE Z
	JRN	DMPDIR2
	NEG	A4
DMPDIR2:	
*	CMPI	10,A1		;CLEAR IF REAL CLOSE
*	JRHI	DMPDIR3
*	CLR	A3
DMPDIR3:
	CMPI	6,A2		;CLEAR IF REAL CLOSE
	JRHI	DMPDIR4
	CLR	A4
DMPDIR4:
	MOVE	A4,*A8(OYVEL),L
	MOVE	A4,*A8(OZVEL),L
	CMPI	30,A14		;DONT CHANGE XVEL IF CLOSE (ANTI STAIRSTEP)
	JRHS	DMPDIR5
	MOVE	*A8(OXVEL),A14,L
	JREQ	DMPDIR5
	MOVE	A14,A3
DMPDIR5:
	MOVE	A3,*A8(OXVEL),L	;STORE VELOCITY
DMPDIR6:
	CALLA	SHVELCPY
	MOVE	A3,A3		;TEST X VELOCITY
	JAN	YFLP
	JAUC	NOYFLP
*
*DUMPSTER MAN COLLSION ROUTINE
*A0 = PTR TO DUMPSTER MAN OBJECT
*A8 = PTR TO OBJECT THAT SMASHED HIM
*
*HIT BY A BULLET
*
DMPBUL:
	MOVE	A0,B0			;MAKE BULLET HIT SOUND
	MOVI	CBULHITR,A0
	CALLA	ONESND
	MOVE	B0,A0
	MOVE	*A0(OPLINK),A3,L
	MOVE	*A3(ETEMP3),A1,W	;DECREMENT HIT COUNT
	CMPI	3,A1
	JRHS	DUMPB0
*MAKE A BLOOD SPLAT
	MMTM	SP,A0,A1,A3,A8
	MOVE	*A8(OYPOS),A9,W
	MOVE	*A0(OID),A11,W
	MOVE	A0,A8
	CREATE	0EDH,SPLATBOX
	MMFM	SP,A0,A1,A3,A8
DUMPB0:
	DEC	A1
	MOVE	A1,*A3(ETEMP3),W	
	JRGT	DMPBL00			;NOT DEAD YET...

	MOVE	*A8(OXVEL),A1,L		;GIVE HIM BULLET VELOCITY
	SRA	2,A1
	MOVE	A1,*A0(OXVEL),L
	MOVE	*A0(OSHAD),A2,L
	JREQ	DMPBL000
	MOVE	A1,*A2(OXVEL),L
DMPBL000
	CALLR	DMPCLNUP		;HE IS DEAD
	CALLA	SHADST
	MOVI	0EDh,A1
	MOVI	DMPBDIE,A7
	CALLA	GETPRC			;CREATE A NEW ENEMY DEATH PROCESS
	MOVE	A11,A11			;GOT A CAN?
	JREQ	DMPCOLX			;NOPE...
        CREATE	0E1h,AIRCAN		;LET CAN FLY 
	MOVE	*A3(ETEMP4),*A0(ETEMP4),L
	JRUC	DMPCOLX
DMPBL00
	MOVK	12,A2 			;FIND BULLET DIRECTION
	MOVE	*A8(OXVEL+>10),A1,W
	JRNN	DMPBUL1
	NEG	A2
DMPBUL1:
	MOVE	*A0(OXPOS),A1,W		;KNOCK HIM A BIT
	ADD	A2,A1
	MOVE	A1,*A0(OXPOS),W
	MOVE	*A0(OSHAD),A4,L
	JREQ	DMPBUL2
	MOVE	*A4(OXPOS),A1,W		;KNOCK SHADOW
	ADD	A2,A1
	MOVE	A1,*A4(OXPOS),W
DMPBUL2:
	MOVE	*A0(OPLINK),A5,L
	MOVE	*A5(ETEMP2),A5,L
	JREQ	DMPCOLX			;NO...
	MOVE	*A5(OXPOS),A1,W		;KNOCK HIM A BIT
	ADD	A2,A1
	MOVE	A1,*A5(OXPOS),W
	MOVE	*A5(OSHAD),A4,L
	JREQ	DMPBUL3
	MOVE	*A4(OXPOS),A1,W		;KNOCK SHADOW
	ADD	A2,A1
	MOVE	A1,*A4(OXPOS),W
DMPBUL3:
DMPCOL0:
	MOVK	1,A2			;SIGNAL DUDE IS HIT
	MOVE	*A0(OPLINK),A1,L
	MOVE	A2,*A1(EFLAGS),L
	
DMPCOLX:
	CLRC			;TELL COLLISION SCANNER NOT TO DELETE
	RETS
*
*DUMPSTER MAN HIT BY ROCKET
*A0 = PTR TO DUMPSTER MAN OBJECT
*A8 = PTR TO OBJECT THAT SMASHED HIM
*
DMPROK:
DMPEXP:
	MOVE	*A0(OPLINK),A5,L
	CALLR	DMPCLNUP
	MOVI	0EDh,A1
	MOVI	DMPDIE,A7
	CALLA	GETPRC			;CREATE A NEW ENEMY DEATH PROCESS
	CALLA	SHADST
	CALLR	EXPVEL

	MOVE	A11,A11			;GOT A CAN?
	JREQ	DMPCOLX			;NOPE...
	SWAP	A11,A8
	CALLR	EXPVEL
	SWAP	A11,A8
DMPEXP1:
        CREATE	0E1h,AIRCAN		;LET CAN FLY 
	MOVE	*A5(ETEMP4),*A0(ETEMP4),L
	JRUC	DMPCOLX
*
*DUMPMAN DIE HIT BY A BULLET
*
DMPBDIE:
	MOVI	DUMPDIE0,A9     	;DO YOUR DEATH ANIMATION
	MOVK	1,A1
	JSRP	FRANIM
	MOVI	[1,1],A9
	CREATE	0DFh,ESINK     	;CREATE THE DEADMAN SINK	 
	JAUC	SUCIDE		;DIE
*
*MISC. DEATH CHORES FOR DUMPMAN
*
DMPCLNUP:
	MOVE	@DUMPCNT,A1,W		;DECREMENT DUMPSTER COUNT
	DEC	A1
	MOVE	A1,@DUMPCNT,W
	MOVI	DUMCOLL,A14
	MOVE	A14,*A0(OCVECT),L	;COLLISION POINTER NULL FOR NOW
	MOVE	*A8(OID),A11,W		;GET ENEMY ID FOR POINTS
	MOVE	A8,A6
	MOVE	A0,A8
	CALLA	SCRKIL			;SCORE YOUR POINTS
	CALLA	OIDATA
	JRC	DMPCLN1
	CALLA	PUT2x5K			;DO A LITTLE FELLER
DMPCLN1
	MOVE	*A8(OPLINK),A0,L
	MOVE	*A0(ETEMP2),A11,L	;GOT A CAN?
	JAUC 	KILL			;KILL YOUR OLD PROCESS
*
*EXPLOSION VELOCITY
*A8=OBJECT, A6=SHIT THAT HIT YOU
*
EXPVEL:
	CALLA	PSTOP		;BLOW DUDE INTO THE AIR					 
	MOVI	>60000,A0	;GET RANDOM Y VELOCITY
	CALLA	RANDU
	ADDI	>20000,A0
	MOVE	A0,A3
	NEG	A3
	MOVI	>40000,A0	;GET RANDOM X VELOCITY
	CALLA	RANDU
	ADDI	>18000,A0	;ADD IN BIAS
	MOVE	*A6(OXVEL+>10),A14  ;GET ROCKET VELOCITY
	JREQ	DMPEX1
	JRNN	DMPEX2
	NEG	A0
	JRUC	DMPEX2
DMPEX1:				 ;ZERO VELOCITY CASE, (EXPLOSION)
	SUBI	>18000,A0	 ;REMOVE BIAS
	CALLA	GETCPNT
	SWAP	A6,A8
	MOVE	A1,A2		 ;A2=DUMPSTER MAN CENTER
	CALLA	GETCPNT
	SWAP	A6,A8		 ;A1=EXPLOSION CENTER
	SUBXY	A1,A2
	JRXNN	DMPEX2
	NEG	A0
DMPEX2:
	MOVE	A0,*A8(OXVEL),L
	MOVE	A3,*A8(OYVEL),L
	MOVE	*A8(OSHAD),A4,L
	JREQ	DMPEXP0
	MOVE	A0,*A4(OXVEL),L
DMPEXP0:
	RETS
*
*DUMPSTER MAN DIE
*
DMPDIE:
	CREATE	0EDH,DMPFALL	;FALL DUDE
DMPDIE0:
	MOVI	DUMPBLO,A9     	;DO YOUR BLO UP ANIMATION
DMPDIEL:
	CLR	A1
	JSRP	FRANIM
	JRC	DMPDIE0
	CALLA	DFRMGRND
	JRN	DMPDIE1
	JREQ	DMPDIE1
	MOVE	*A8(OYVEL+>10),A2 	;CHECK VELOCITY TO START DEATH EARLY?
	JRN	DMPDIEL
	SLL	4,A2
	CMP	A2,A1
	JRGT	DMPDIEL
DMPDIE1:
	MOVI	DUMPDIE,A9     	;DO YOUR DEATH ANIMATION
	MOVK	1,A1
	JSRP	FRANIM
	MOVI	[1,1],A9
	CREATE	0DFh,ESINK     	;CREATE THE DEADMAN SINK	 
	JAUC	SUCIDE		;DIE

DMPFALL:
DMPFAL2:
	SLEEP	3
	MOVE	*A8(OYVEL),A0,L		;EFFECT OF GRAVITY
	ADDI	>5000,A0
	MOVE	A0,*A8(OYVEL),L
	CALLA	DFRMGRND
	JRNN	DMPFAL2			;IN THE AIR STILL

	CALLA	PSTOP			;STOP THE SUCKER   
	MOVE	A8,A0			;OBJECT IN A0 FOR SETZPOS
	CALLA	SETZPOS			;ADJUST THE MUTHA
	DIE				
*
*HORIZONTAL FLIP OF OBJECT
*A8=OBJECT
*FLIPS OBJECT ABOUT Y AXIS
HFLIP:
	MMTM	SP,A1,A4
	MOVE	*A8(OFLAGS),A4,L
	XORI	M_FLIPH,A4	;FLIP THE DUDE
	MOVE	*A8(OIMG),A1,L
	CALLA	ANI
	MMFM	SP,A1,A4
	RETS
*
*STFOBJ INITIALIZING DATA
*	.LONG	OXVEL,OYVEL,OXVAL,OYVAL
*	.WORD	OZPOS,OZVEL
*	.LONG	OIMG,OZSIZ,OCVECT
*	.WORD	OFLAGS,OID
DUMPINIT
	.LONG	0,0,0,0
	.WORD	0,0
	.LONG	bwlk4_vda,LOFZ,DMPCOL
	.WORD	DMAWNZ,>E05
	.LONG	DUMPBLIP

DMPCOL:
	.WORD	B1OID+BULLETID
	.LONG	DMPBUL
	.WORD	B2OID+BULLETID
	.LONG	DMPBUL
	.WORD	B1OID+ROCKETID
	.LONG	DMPROK
	.WORD	B2OID+ROCKETID
	.LONG	DMPROK
	.WORD	B1OID+EXPLODID
	.LONG	DMPEXP
	.WORD	B2OID+EXPLODID
	.LONG	DMPEXP
	.WORD	BEOID+EXPLODID
	.LONG	DMPEXP
	.WORD	0
	.LONG	DUMRTSG
*
*ANIMATION TABLES
*
DUMPTAB	.LONG	0
*
***********************************************
*DUMPSTER MAN ANIMATIONS
***********************************************
*
*DUMPSTER MAN WALK
*
DUMPWLK:
	.long	bwlk4_vda
	.word	5
	.long	bwlk5_vda
	.word	5
	.long	bwlk6_vda
	.word	5
	.long	bwlk8_vda
	.word	5
DUMPWLK2:
	.long	bwlk9_vda
	.word	5
	.long	bwlk10_vda
	.word	5
	.long	bwlk12_vda
	.word	5
	.long	bwlk13_vda
	.word	5
	.long	bwlk14_vda
	.word	5
	.long	0
*
*DUMPSTER MAN HIT
*
DUMPHIT:
	.long	bdie1
	.word	6
	.long	bdie2
	.word	6
	.long	bdie3
	.word	6
	.long	0
*
*DUMPSTER MAN BLOW UP THROUGH THE AIR
*
DUMPBLO:
	.long	bdie1
	.word	8
	.long	bdie2
	.word	8
	.long	bdie3
	.word	8
	.long	bdie4
	.word	8
	.long	bdie5
	.word	8
	.long	bdie6
	.word	8
	.LONG 	0
*DUMPDIE 0
DUMPDIE0:
	.long	bdie1
	.word	4
	.long	bdie2
	.word	4
	.long	bdie3
	.word	4
*	.long	bdie4
*	.word	4
*	.long	bdie5
*	.word	4
*	.long	bdie6
*	.word	4
*
*DUMPSTER MAN DIE
*
DUMPDIE:
	.long	bdie7
	.word	4
	.long	bdie9
	.word	4
	.long	bdie10
	.word	4
	.long	bdie11
	.word	4
	.long	bdie12
	.word	4
	.long	bdie14
	.word	10
	.long	0
*
*DUMPSTER MAN PICKUP
*
DUMPICK:
	.long	pick2
	.word	6
	.long	pick3
	.word	6
	.long	pick4
	.word	6
	.long	pick6
	.word	6
	.long	pick7
	.word	6
	.long	pick8
	.word	6
	.long	pick9
	.word	6
	.long	pick10
	.word	6
	.long	pick11
	.word	6
	.long	0
*
*DUMPSTER MAN THROW 
*
	.long 	dmthr1
	.word 	6
	.long 	dmthr2
	.word 	6
	.long 	dmthr3
	.word 	6
	.long 	dmthr4
	.word 	6
DUMPTHRW:
	.long 	dmthr5
	.word 	6
	.long 	dmthr7
	.word 	6
DUMPFLY:
	.long 	dmthr8
	.word 	6
	.long 	dmthr9
	.WORD	6
	.long 	dmthr10
	.word 	6
	.long 	dmthr11
	.word 	6
	.long 	dmthr12
	.word 	6
	.long 	0
*
*dumpster man head butt
*
DUMPBUTT:
	.long	pick2
	.word	6
	.long	pick9
	.word	6
	.long	pick2
	.word	6
	.long	0
*	
*DUMPSTER MAN THROW WALK
*
DUMPTHWLK:
	.long 	dmthr1
	.word 	6
	.long 	dmthr2
	.word 	6
	.long 	dmthr3
	.word 	6
	.long 	dmthr4
	.word 	6
	.long 	dmthra
	.word 	6
	.long 	dmthrb
	.word 	6
	.long 	dmthrc
	.word 	6
	.long	0
*
*dumpster man shake
*
DUMPSHAK:
	.long	pick7
	.word	4
	.long	pick9
	.word	4
	.long	pick10
	.word	4
	.long	pick11
	.word	4
	.long	pick10
	.word	4
	.long	pick9
	.word	4
	.long	0

*
*DUMPSTER MAN CRIME SCENE
*
DUMPCRM1:
	move	@(WORLDTLX+16),A0,W				 
	addi	150,A0
	move	@PLYMIN,A1,W									 
	addi	5,A1
	sll	16,A1
	movx	A0,A1
	clr	A6
	movi	DUMPINIT,A14	
	calla	ESINITLL
	clr	A0
	move	A0,*A8(OBLIPIMG),L

	calla	PSTOP
	calla	NOYFLP
	movi	>1C000,A0
	move	A0,*A8(OXVEL),L
	movi	DUMPWLK2,A9
	movk	1,A1
	jsrp	FRANIM
	SOUND1	CNTHSND
	movi	DUMPWLK,A9
	movk	1,A1
	jsrp	FRANIM
CRM1X:
	MOVI	ENEMIES,A1
	MOVE	A8,A0
	CALLA	DELSUPP
	move	*A8(OPAL),A1,W
	move	A1,@CRIMEPAL,W
	CALLA	DELSOBJ
	retp

	.END

