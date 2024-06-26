	.FILE	"NARCANIM.ASM"
	.TITLE	" <<< N  A  R  C  -- MISCELLANEOUS ANIMATION SCRIPTS >>>"
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
	.INCLUDE	"IMGTBL.GLO"		;Image Label Globals
	.INCLUDE	"NARCPLAY.TBL"		;Image Label Equates

	.data
	.EVEN

*
*PLAYER ANIMATION SCRIPT OFFSET TABLE
P1AOFFS .WORD   1,21,41,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,0,0
	.WORD	77,79,81,83,85,87,89,91
P1MAINTL
	.LONG	P1AOFFS
*		  LR      UP     UPQ     DNQ     DN
	.LONG	P1WLLR, P1WLUP, P1WLUPQ,P1WLDNQ,P1WLDN	;WALKING  --> LEGS
	.LONG	P1WTLR, P1WTUP, P1WTUPQ,P1WTDNQ,P1WTDN	;WALKING  --> TORSO
	.LONG	P1FTLR, P1FTUP, P1FTUPQ,P1FTDNQ,P1FTDN	;WALKING  --> TORSO FIRE
  	.LONG	P1RBTLR,P1RBTUP,P1RBTUPQ,P1RBTDNQ,P1RBTDN ;WALK > TORSO ROCKET

	.LONG	P1SWLLR,P1SWLLR,P1SWLLR,P1SWLLR,P1SWLLR	;SQUAT WALK > LEGS
	.LONG	P1SWTLR,P1SWTLR,P1SWTLR,P1SWTLR,P1SWTLR	;SQUAT WALK > TORSO	
	.LONG	P1SFTLR,P1SFTLR,P1SFTLR,P1SFTLR,P1SFTLR	;SQUAT WALK > FIRE
	.LONG	P1SRBTLR,P1SRBTLR,P1SRBTLR,P1SRBTLR,P1SRBTLR ;SQUAT WALK > ROCKET

	.LONG	P1JLLR1,P1JLLR1,P1JLLR2,P1JLLR3,P1JLLR4	;JUMP LFT/RGHT LEGS
	.LONG	P1JTLR1,P1JTLR1,P1JTLR2,P1JTLR3,P1JTLR4	;JUMP L/R TORSO
	.LONG	P1JFTLR1,P1JFTLR2,P1JFTLR3,P1JFTLR4,P1JFTLR4 ;JUMP L/R FIRE
	.LONG	P1JRTLR1,P1JRTLR2,P1JRTLR3,P1JRTLR4,P1JRTLR4 ;JUMP L/R ROCKET

	.LONG	P1STDL					;STAND REST LEGS
	.LONG	P1STDT					;STAND REST TORSO		

	.LONG	P1SQTL					;SQUAT REST LEGS
	.LONG	P1SQTT					;SQUAT REST TORSO

	.LONG	P1FLSTD					;STAND REST/FIRE LEGS
	.LONG	P1FTSTD					;STAND REST/FIRE TORSO

	.LONG	P1SQTL					;SQUAT REST/FIRE LEGS
	.LONG	P1SQFLR					;SQUAT REST/FIRE TORSO

	.LONG	P1RBLSTD				;STAND REST/ROCKET LEGS	
	.LONG	P1RBTSTD				;STAND REST/ROCKET TORSO

	.LONG	P1SQTL					;SQUAT REST/ROCKET LEGS
	.LONG	P1SQRBLR				;SQUAT REST/ROCKET TORSO

	.LONG	P1DRIVEL				;DRIVING LEGS
	.LONG	P1DRIVET				;DRIVING TORSO

	.LONG	P1PASSL					;PASSENGER LEGS
	.LONG	P1PASST					;PASSENGER TORSO

	.LONG	P1DRIVEL				;DRIVING LEGS
	.LONG	P1DRIVEF				;DRIVING TORSO FIRE

	.LONG	P1PASSL					;PASSENGER LEGS
	.LONG	P1PASSF					;PASSENGER TORSO FIRE

	.LONG	P1JMPINL				;JUMP IN CAR LEGS
	.LONG	P1JMPINT				;JUMP IN CAR TORSO

	.LONG	P1PILOTL				;PILOT LEGS
	.LONG	P1PILOTT				;PILOT TORSO

	.LONG	P1HELPASL				;CHOPPER PASSENGER LEGS
	.LONG	P1HELPAST				;CHOPPER PASSENGER TORSO

	.LONG	P1PILOTL				;PILOT LEGS
	.LONG	P1PILOTF				;PILOT TORSO FIRE

	.LONG	P1HELPASL				;CHOPPER PASSENGER LEGS
	.LONG	P1HELPASF				;CHOPPER PASSENGER TORSO FIRE

	.LONG	PHELJMPL				;CHOPPER JUMP IN LEGS
	.LONG	PHELJMPT				;CHOPPER JUMP IN TORSO

P1STDL		        	;PLAYER STANDING IN PLACE LEGS
	.LONG	jlsw4
	.WORD	1
DUMSCRIP
	.LONG	0

P1STDT				;PLAYER STANDING IN PLACE TORSO
	.LONG	jtsstdrst
	.WORD	1
	.LONG	0

P1SQTL				;PLAYER SQUAT IN PLACE LEGS
	.LONG	jlssqrst
	.WORD	1
	.LONG	0

P1SQTT				;PLAYER SQUAT IN PLACE TORSO	
	.LONG	jtssqrstc
	.WORD	1
	.LONG	0

P1DRIVEL
	.LONG	jtdrive1		;PLAYER DRIVING LEGS
	.WORD	1
	.LONG	0
P1DRIVET
	.LONG	jtdrive1		;PLAYER DRIVING TORSO
	.WORD	1
	.LONG	0
P1DRIVEF
	.LONG	jtdrive1		;PLAYER DRIVING TORSO FIRE
	.WORD	7
	.LONG	0

P1PASSL
	.LONG	jtpassen1		;PLAYER PASSENGER LEGS
	.WORD	1
	.LONG	0
P1PASST
	.LONG	jtpassen1		;PLAYER PASSENGER TORSO
	.WORD	1
	.LONG	0
P1PASSF
	.LONG	jtpassen1		;PLAYER PASSENGER TORSO FIRE
	.WORD	7
	.LONG	0

P1PILOTL
	.LONG	jrpilot			;PLAYER PILOT LEGS
	.WORD	1
	.LONG	0
P1PILOTT
	.LONG	jrpilot			;PLAYER PILOT TORSO
	.WORD	1
	.LONG	0
P1PILOTF
	.LONG	jrpilot			;PLAYER PILOT TORSO FIRE
	.WORD	7
	.LONG	0

P1HELPASL
	.LONG	jrhelpas		;PLAYER CHOPPER PASSENGER LEGS
	.WORD	1
	.LONG	0
P1HELPAST
	.LONG	jrhelpas		;PLAYER CHOPPER PASSENGER TORSO
	.WORD	1
	.LONG	0
P1HELPASF
	.LONG	jrhelpas		;PLAYER CHOPPER PASSENGER TORSO FIRE
	.WORD	7
	.LONG	0

P1JMPINL				;PLAYER ONE JUMP IN CAR LEGS
	.LONG	jljucar3
	.WORD	5
	.LONG	jljucar4
	.WORD	5
	.LONG	0

P1JMPINT				;PLAYER ONE JUMP IN CAR TORSO
	.LONG	jtjucar3
	.WORD	5
	.LONG	jtjucar4
	.WORD	5
	.LONG	0

PHELJMPL				;PLAYER JUMP IN CHOPPER LEGS
	.LONG	jljuhel3
	.WORD	5
	.LONG	jljuhel4
	.WORD	5
	.LONG	0

PHELJMPT				;PLAYER JUMP IN CHOPPER TORSO
	.LONG	jtjuhel3
	.WORD	5
	.LONG	jtjuhel4
	.WORD	5
	.LONG	0

P1WLLR		     		;PLAYER ONE WALKING LEFT/RIGHT
	.LONG	jlsw4
	.WORD	3
	.LONG	jlsw5
	.WORD	3
	.LONG	jlsw6
	.WORD	3
	.LONG	jlsw7
	.WORD	3
	.LONG	jlsw8
	.WORD	3
	.LONG	jlsw9
	.WORD	3
	.LONG	jlsw10
	.WORD	3
	.LONG	jlsw11
	.WORD	3
	.LONG	jlsw1
	.WORD	3
	.LONG	jlsw2
	.WORD	3
	.LONG	jlsw3
	.WORD	3
	.LONG	0

P1SWLLR			 	;PLAYER 1 SQUAT WALK L/R
	.LONG	jlssqw1
	.WORD	4
	.LONG	jlssqw2
	.WORD	4
	.LONG	jlssqw3
	.WORD	4
	.LONG	jlssqw4
	.WORD	4
	.LONG	jlssqw5
	.WORD	4
	.LONG	jlssqw6
	.WORD	4
	.LONG	jlssqw7
	.WORD	4
	.LONG	jlssqw8
	.WORD	4
	.LONG	0

P1WLUP				;PLAYER 1 WALK UP LEGS
	.LONG	jlbw1
	.WORD	6
	.LONG	jlbw2
	.WORD	6
	.LONG	jlbw3
	.WORD	6
	.LONG	jlbw4
	.WORD	6
	.LONG	jlbw5
	.WORD	6
	.LONG	0

P1WTUP				;PLAYER 1 WALK UP TORSO
	.LONG	jtbwrst1
	.WORD	1
	.LONG	0
	.LONG	jtbwrst2
	.WORD	1
	.LONG	0
	.LONG	jtbwrst3
	.WORD	1
	.LONG	0
	.LONG	jtbwrst4
	.WORD	1
	.LONG	0
	.LONG	jtbwrst5
	.WORD	1
	.LONG	0

P1WLUPQ				;PLAYER 1 WALK UP 3 QUARTER LEGS
	.LONG	jlqbw1
	.WORD	5
	.LONG	jlqbw2
	.WORD	5
	.LONG	jlqbw3
	.WORD	5
	.LONG	jlqbw4
	.WORD	5
	.LONG	jlqbw5
	.WORD	5
	.LONG	jlqbw6
	.WORD	5
	.LONG	jlqbw7
	.WORD	5
	.LONG	0

P1WTUPQ				;PLAYER 1 WALK UP 3 QUARTER TORSO
	.LONG	jtqbwrst1
	.WORD	1
	.LONG	0
	.LONG	jtqbwrst2
	.WORD	1
	.LONG	0
	.LONG	jtqbwrst3
	.WORD	1
	.LONG	0
	.LONG	jtqbwrst4
	.WORD	1
	.LONG	0
	.LONG	jtqbwrst5
	.WORD	1
	.LONG	0
	.LONG	jtqbwrst6
	.WORD	1
	.LONG	0
	.LONG	jtqbwrst7
	.WORD	1
	.LONG	0

P1WLDN				;PLAYER 1 WALK DOWN LEGS
	.LONG	jlfw1
	.WORD	6
	.LONG	jlfw2
	.WORD	6
	.LONG	jlfw3
	.WORD	6
	.LONG	jlfw4
	.WORD	6
	.LONG	jlfw5
	.WORD	6
	.LONG	0

P1WTDN				;PLAYER 1 WALK UP TORSO
	.LONG	jtfwrst1
	.WORD	1
	.LONG	0
	.LONG	jtfwrst2
	.WORD	1
	.LONG	0
	.LONG	jtfwrst3
	.WORD	1
	.LONG	0
	.LONG	jtfwrst4
	.WORD	1
	.LONG	0
	.LONG	jtfwrst5
	.WORD	1
	.LONG	0

P1WLDNQ				;PLAYER 1 WALK DOWN 3 QUARTER LEGS
	.LONG	jlqfw1
	.WORD	5
	.LONG	jlqfw2
	.WORD	5
	.LONG	jlqfw3
	.WORD	5
	.LONG	jlqfw4
	.WORD	5
	.LONG	jlqfw5
	.WORD	5
	.LONG	jlqfw6
	.WORD	5
	.LONG	jlqfw7
	.WORD	5
	.LONG	0

P1WTDNQ				;PLAYER 1 WALK DOWN 3 QUARTER TORSO
	.LONG	jtqfwrst1
	.WORD	1
	.LONG	0
	.LONG	jtqfwrst2
	.WORD	1
	.LONG	0
	.LONG	jtqfwrst3
	.WORD	1
	.LONG	0
	.LONG	jtqfwrst4
	.WORD	1
	.LONG	0
	.LONG	jtqfwrst5
	.WORD	1
	.LONG	0
	.LONG	jtqfwrst6
	.WORD	1
	.LONG	0
	.LONG	jtqfwrst7
	.WORD	1
	.LONG	0

P1WTLR				;WALK TORSO L/R
	.LONG	jtswrst4
	.WORD	1
	.LONG	0
	.LONG	jtswrst5
	.WORD	1
	.LONG	0
	.LONG	jtswrst6
	.WORD	1
	.LONG	0
	.LONG	jtswrst7
	.WORD	1
	.LONG	0
	.LONG	jtswrst8
	.WORD	1
	.LONG	0
	.LONG	jtswrst9
	.WORD	1
	.LONG	0
	.LONG	jtswrst10
	.WORD	1
	.LONG	0
	.LONG	jtswrst11
	.WORD	1
	.LONG	0
	.LONG	jtswrst1
	.WORD	1
	.LONG	0
	.LONG	jtswrst2
	.WORD	1
	.LONG	0
	.LONG	jtswrst3
	.WORD	1
	.LONG	0
	
P1SWTLR			 	;SQUAT WALK TORSO L/R
	.LONG	jtssqrst
	.WORD	1
	.LONG	0
	.LONG	jtssqrst
	.WORD	1
	.LONG	0
	.LONG	jtssqrst
	.WORD	1
	.LONG	0
	.LONG	jtssqrst
	.WORD	1
	.LONG	0
	.LONG	jtssqrst
	.WORD	1
	.LONG	0
	.LONG	jtssqrst
	.WORD	1
	.LONG	0
	.LONG	jtssqrst
	.WORD	1
	.LONG	0
	.LONG	jtssqrst
	.WORD	1
	.LONG	0

P1FTLR			 	;WALK SHOOT L/R
	.LONG	jtswshgs1
	.WORD	-1,34,-3,32
	.LONG	jtswshgs1
	.WORD	1
	.LONG	jtswshgs2
	.WORD	1
	.LONG	jtswshgs2
	.WORD	1
	.LONG	jtswshgs2
	.WORD	1
	.LONG	0

P1RBTLR			  	;WALK FIRE ROCKET BOMB L/R
	.LONG	jtswshms1
	.WORD	-12,29,7,32
	.LONG	jtswshms2
	.WORD	1
	.LONG	jtswshms2
	.WORD	1
	.LONG	jtswshms2
	.WORD	1
	.LONG	0

P1FLSTD		     		;STANDING IN PLACE FIRE LEGS
	.LONG	jlsstd
	.WORD	3
	.LONG	jlsstd
	.WORD	4
	.LONG	0

P1FTSTD			 	;STAND IN PLACE FIRE L/R TORSO 
	.LONG	jtswshgs1c
	.WORD	-1,34,-3,32
	.LONG	jtswshgs1c
	.WORD	1
	.LONG	jtswshgs2c
	.WORD	1
	.LONG	jtswshgs2c
	.WORD	1
	.LONG	jtswshgs2c
	.WORD	1
	.LONG	0

P1RBLSTD	     		;STANDING IN PLACE ROCKET BOMB L/R LEGS
	.LONG	jlsstd
	.WORD	12
	.LONG	jlsstd
	.WORD	4
	.LONG	0

P1RBTSTD		  	;STAND IN PLACE FIRE ROCKET BOMB L/R TORSO
	.LONG	jtswshms1c
	.WORD	-12,29,7,32
	.LONG	jtswshms2c
	.WORD	1
	.LONG	jtswshms2c
	.WORD	1
	.LONG	jtswshms2c
	.WORD	1
	.LONG	0

P1FTUP			 	;WALK UP SHOOT TORSO
	.LONG	jtbwshgs1
	.WORD	-1,25,-4,32
	.LONG	jtbwshgs1
	.WORD	1
	.LONG	jtbwshgs2
	.WORD	1
	.LONG	jtbwshgs2
	.WORD	1
	.LONG	jtbwshgs2
	.WORD	1
	.LONG	0

P1RBTUP				;WALK UP SHOOT ROCKET BOMB TORSO
	.LONG	jtbwshms1
	.WORD	-12,25,6,32
	.LONG	jtbwshms2
	.WORD	1
	.LONG	jtbwshms2
	.WORD	1
	.LONG	jtbwshms2
	.WORD	1
	.LONG	jtbwshms2
	.WORD	1
	.LONG	0

P1FTDN				;WALK DOWN SHOOT TORSO
	.LONG	jtfwshgs1
	.WORD	-1,29,-2,32
	.LONG	jtfwshgs1
	.WORD	1
	.LONG	jtfwshgs2
	.WORD	1
	.LONG	jtfwshgs2
	.WORD	1
	.LONG	jtfwshgs2
	.WORD	1
	.LONG	0

P1RBTDN				;WALK DOWN ROCKET BOMB TORSO
	.LONG	jtfwshms1
	.WORD	-12,20,1,32
	.LONG	jtfwshms2
	.WORD	1
	.LONG	jtfwshms2
	.WORD	1
	.LONG	jtfwshms2
	.WORD	1
	.LONG	0

P1FTUPQ		 		;WALK UP 3 QUARTER SHOOT TORSO
	.LONG	jtqbwshgs1
	.WORD	-1,25,-4,32
	.LONG	jtqbwshgs1
	.WORD	1
	.LONG	jtqbwshgs2
	.WORD	1
	.LONG	jtqbwshgs2
	.WORD	1
	.LONG	jtqbwshgs2
	.WORD	1
	.LONG	0

P1RBTUPQ			;WALK UP 3Q ROCKET BOMB TORSO
	.LONG	jtqbwshms1
	.WORD	-12,31,5,32
	.LONG	jtqbwshms2
	.WORD	1
	.LONG	jtqbwshms2
	.WORD	1
	.LONG	jtqbwshms2
	.WORD	1
	.LONG	0

P1FTDNQ		 		;WALK DOWN 3/4 SHOOT TORSO
	.LONG	jtqfwshgs1
	.WORD	-1,32,-6,32
	.LONG	jtqfwshgs1
	.WORD	1
	.LONG	jtqfwshgs2
	.WORD	1
	.LONG	jtqfwshgs2
	.WORD	1
	.LONG	jtqfwshgs2
	.WORD	1
	.LONG	0

P1RBTDNQ	       		;WALK DOWN 3/4 ROCKET BOMB TORSO
	.LONG	jtqfwshms1
	.WORD	-12,23,-1,32
	.LONG	jtqfwshms2
	.WORD	1
	.LONG	jtqfwshms2
	.WORD	1
	.LONG	jtqfwshms2
	.WORD	1
	.LONG	0

P1SFTLR				;SQUAT WALK SHOOT L/R
	.LONG	jtssqshg1
	.WORD	-1,30,5,32
	.LONG	jtssqshg1
	.WORD	1
	.LONG	jtssqshg2
	.WORD	1
	.LONG	jtssqshg2
	.WORD	1
	.LONG	jtssqshg2
	.WORD	1
	.LONG	0

P1SRBTLR	     		;SQUAT WALK ROCKET BOMB L/R
	.LONG	jtssqshm1
	.WORD	-12,26,9,32
	.LONG	jtssqshm2
	.WORD	1
	.LONG	jtssqshm2
	.WORD	1
	.LONG	jtssqshm2
	.WORD	1
	.LONG	0

P1SQFLR		      		;SQUAT REST SHOOT L/R
	.LONG	jtssqshg1c
	.WORD	-1,30,5,32
	.LONG	jtssqshg1c
	.WORD	1
	.LONG	jtssqshg2c
	.WORD	1
	.LONG	jtssqshg2c
	.WORD	1
	.LONG	jtssqshg2c
	.WORD	1
	.LONG	0

P1SQRBLR		  	;SQUAT REST ROCKET BOMB L/R
	.LONG	jtssqshm1c
	.WORD	-12,26,9,32
	.LONG	jtssqshm2c
	.WORD	1
	.LONG	jtssqshm2c
	.WORD	1
	.LONG	jtssqshm2c
	.WORD	1
	.LONG	0

P1JFTLR1			;JUMP SHOOT L/R
	.LONG	jtjushg1
	.WORD	-1,32,-3,32
	.LONG	jtjushg1
	.WORD	1
	.LONG	jtjushg2
	.WORD	1
	.LONG	jtjushg2
	.WORD	1
	.LONG	jtjushg2
	.WORD	1
	.LONG	0

P1JFTLR2			;JUMP SHOOT L/R
	.LONG	jtjushg1
	.WORD	-1,32,-3,32
	.LONG	jtjushg1
	.WORD	1
	.LONG	jtjushg2
	.WORD	1
	.LONG	jtjushg2
	.WORD	1
	.LONG	jtjushg2
	.WORD	1
	.LONG	0

P1JFTLR3			;JUMP SHOOT L/R
	.LONG	jtjushg1
	.WORD	-1,32,-3,32
	.LONG	jtjushg1
	.WORD	1
	.LONG	jtjushg2
	.WORD	1
	.LONG	jtjushg2
	.WORD	1
	.LONG	jtjushg2
	.WORD	1
	.LONG	0

P1JFTLR4			;JUMP SHOOT L/R
	.LONG	jtjushg1
	.WORD	-1,32,-3,32
	.LONG	jtjushg1
	.WORD	1
	.LONG	jtjushg2
	.WORD	1
	.LONG	jtjushg2
	.WORD	1
	.LONG	jtjushg2
	.WORD	1
	.LONG	0

P1JRTLR1			;JUMP SHOOT L/R
	.LONG	jtjushm1
	.WORD	-1,27,11,32
	.LONG	jtjushm1
	.WORD	1
	.LONG	jtjushm2
	.WORD	1
	.LONG	jtjushm2
	.WORD	1
	.LONG	jtjushm2
	.WORD	1
	.LONG	0

P1JRTLR2			;JUMP SHOOT L/R
	.LONG	jtjushm1
	.WORD	-1,27,11,32
	.LONG	jtjushm1
	.WORD	1
	.LONG	jtjushm2
	.WORD	1
	.LONG	jtjushm2
	.WORD	1
	.LONG	jtjushm2
	.WORD	1
	.LONG	0

P1JRTLR3			;JUMP SHOOT L/R
	.LONG	jtjushm1
	.WORD	-1,27,11,32
	.LONG	jtjushm1
	.WORD	1
	.LONG	jtjushm2
	.WORD	1
	.LONG	jtjushm2
	.WORD	1
	.LONG	jtjushm2
	.WORD	1
	.LONG	0

P1JRTLR4			;JUMP SHOOT L/R
	.LONG	jtjushm1
	.WORD	-1,27,11,32
	.LONG	jtjushm1
	.WORD	1
	.LONG	jtjushm2
	.WORD	1
	.LONG	jtjushm2
	.WORD	1
	.LONG	jtjushm2
	.WORD	1
	.LONG	0

P1JLLR		     		;PLAYER ONE JUMP L/R LEGS
	.LONG	jlju1
	.WORD	4
	.LONG	0		;TAKE OFF BREAK POINT
P1JTLR				;PLAYER 1 JUMP L/R TORSO
	.LONG	jtju1
	.WORD	4
	.LONG	0		;TAKE OFF BREAK POINT

P1JLLR1
	.LONG	jlju2
	.WORD	1
	.LONG	0
P1JTLR1
	.LONG	jtju2
	.WORD	1
	.LONG	0

P1JLLR2
	.LONG	jlju3
	.WORD	1
	.LONG	0

P1JTLR2
	.LONG	jtju3	
	.WORD	1
	.LONG	0

P1JLLR3
	.LONG	jlju4
	.WORD	1
	.LONG	0
P1JTLR3
	.LONG	jtju4
	.WORD	1
	.LONG	0

P1JLLR4
	.LONG	jlju5
	.WORD	1
	.LONG	0
P1JTLR4
	.LONG	jtju5
	.WORD	1
	.LONG	0

P1SHAKE					;PLAYER 1 HIT BY BULLET
	.LONG	comdb1
	.WORD	5
	.LONG	comdb2
	.WORD	5
	.LONG	0

P1DIE					;PLAYER 1 DEATH, OUT OF ENERGY
	.LONG	comdb1
	.WORD	4
	.LONG	comdb2	
	.WORD	4
	.LONG	comdb3
	.WORD	4
	.LONG	comdb4
	.WORD	4
	.LONG	comdb5
	.WORD	4
	.LONG	comdb6
	.WORD	4
	.LONG	comdb7
	.WORD	4
	.LONG	0

P1CHIT			  		;PLAYER 1 RUN-OVER BY CAR
	.LONG	comdb1
	.WORD	4
	.LONG	comdb2
	.WORD	4
	.LONG	comdb3
	.WORD	4
	.LONG	comdb4
	.WORD	4
	.LONG	comdb5
	.WORD	4
	.LONG	comdb6
	.WORD	4
	.LONG	comdb7
	.WORD	4
	LONGNULL
	.EVEN

	.END
