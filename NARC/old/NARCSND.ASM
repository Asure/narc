	.FILE	'NARCSND.ASM'
	.TITLE	" <<< N  A  R  C  -- SOUND TABLE >>>"
	.WIDTH	132
	.OPTION	B,D,L
	.MNOLIST

*	GET THE SYSTEM STUFF
	.INCLUDE	"\video\MPROCEQU.ASM"	;MPROC equates
	.INCLUDE	"\video\GSP.INC"	;GSP assembler equates
	.INCLUDE	"\video\SYS.INC"	;Zunit system equates
	.INCLUDE	"\video\MACROS.HDR"	;Macros, Yeah!
	.INCLUDE	"NARCEQU.ASM"		;NARC Equates

*
*GLOBALS IN THIS FILE
	.GLOBAL	TUNELAB
	.data
**************************************************************************
*                                                                        *
* THE NARC SOUND TABLE							 *
* 									 *
* CHANNEL #0	CVSD SOUNDS						 *
* CHANNEL #1	DAC A							 *
* CHANNEL #2	DAC B							 *
* CHANNEL #3	MUSIC							 *
*                                                                        *
**************************************************************************
*------------------------------------------------------------------------*
*SOUND DESCRIPTION= PRIORITY,TIME,SOUND CODE,(PRIORITY),(TIME),(SOUND CODE),0
*SOUND ENDS IN 0000.
*PRIORITY WORD = 1111IENNPPPPPPPP; I=1=NON-INTERRUPTABLE, E=1=NON-INT BY EQUAL
*NN=CHANNEL #(0-3);
*PP=PRIORITY (00-FF), FF=HIGHEST.
*TIME WORD =TTTT (0000-7FFF X 16MS).
*SOUND WORD =8SSS SSS=SOUND CODE(000-FFF).
*SOUND WORD =4SSS SSS=SOUND CODE (ZERO TIME SOUND CODE)
*------------------------------------------------------------------------*
SNDTAB:
SND3A	.WORD	>F103,>40,>8005,0		;PLAYER 1 GUNSHOT
SND3B	.WORD	>F203,>40,>8006,0		;PLAYER 2 GUNSHOT
P1BHIT	.WORD	>F000,>10,>8014,0		;PLAYER 1 BULLET HIT
HHITSND	.WORD	>F310,>3E,>8086,0		;PLAYER HIT BY HYPO
HHITEND	.WORD	>F3FE,>01,>807F,0		;HYPO HIT ENDER HIGH PRIO.

SND4	.WORD	>F000,>01,>8035,0		;ROCKET LAUNCH PRE-IGNITION
RLNCHSND .WORD	>F00F,>50,>8008,0		;ROCKET LAUNCH SOUND	

EBSND	.WORD	>F200,>40,>8004,0		;ENEMY BULLET SOUND

DINGDUMP .WORD	>F300,>28,>8097,0		;DING ON A DUMPSTER
DINGPSTR .WORD	>F000,>20,>8040,0		;DING ON A LAMP POST
DINGCANR .WORD	>F300,>20,>809C,0		;DING ON A GARBAGE CAN

CANSMSND .WORD	>F021,>48,>8010,0		;SMASH A CAN HARD
CANWPSND .WORD	>F021,>3C,>800A,0		;SMASH A CAN WIMPILY
CANBCSND .WORD	>F021,>25,>800B,0		;GARBAGE CAN BOUNCE

PCDMPSND .WORD	>F000|NINTEQ|EXPLOPRI,>10,>8010	;CAR EXPLODING AGAINST DUMPSTER
	 .WORD	>48,>8007,0

;* MrBig Sounds
MBLAUGH .WORD	>F040,>80,>8055,0	;laugh
MBGETEM .WORD	>F041|NINTEQ,>80,>8056,0	;get em
MBKILLEM .WORD	>F041|NINTEQ,>80,>8057,0	;kill em
MBYOUDIE .WORD	>F041|NINTEQ,>80,>8058,0	;you die cop
MBNTRY .WORD	>F041|NINTEQ,>80,>8059,0	;nice try narc

;* HypoMan Sounds
SHYPOSND .WORD	>F305,>90,>8099,0		;knife throw (spinning)

;* Pimp Sounds
BNCESND .WORD	>F000,>5,>8053,0		;roach foot click (dyna bnce)

;* Bug Sounds
HELLBUGS .WORD	>F300|NINTEQ,>1,>809F,0		;bugs from hell..
SQISHSND .WORD	>F330,>30,>80A1,0		;pinbot fart squish
BUGHTSND .WORD	>F020,>20,>804E,0		;bug shot (slow crunch)
BBITESND .WORD	>F001,>10,>804A,0		;bug bite..

GRUNT1R	.WORD	>F000,>3E,>8011,0		;GRUNT #1
GRUNT2R	.WORD	>F000,>3E,>8013,0		;GRUNT #2
GRUNT3R	.WORD	>F000,>3E,>8015,0		;GRUNT #3
GRUNT4R	.WORD	>F000,>3E,>803E,0		;GRUNT #4
GRUNT5R	.WORD	>F000,>3E,>803F,0		;GRUNT #5

YBUSTSND .WORD	>F400|SPEAKPRI,>38,>8020,0	;"YOU'RE BUSTED"
YSCUMSND .WORD	>F400|SPEAKPRI,>1F,>8035,0	;"BUSTED"
LEGOSND	.WORD	>F400|SPEAKPRI,>23,>8027,0	;"LET'S GO"

DSHTSND	.WORD	>F400|SPEAKPRI,>6A,>8034,0	;"DON'T SHOOT"
IGIVSND	.WORD	>F400|EXPLOPRI,>20,>802F,0    	;"I GIVE UP"
DSH2SND	.WORD	>F400|SPEAKPRI,>2B,>802E,0	;"DON'T SHOOT"
CLENSND	.WORD	>F400|SPEAKPRI,>2E,>8021,0    	; I'M CLEAN"
SPRDSND	.WORD	>F400|SPEAKPRI,>29,>802C,0    	;"SPREAD'EM"

HALTSND	.WORD	>F400|SPEAKPRI,>51,>8033,0    	;"POLICE, FREEZE"
FREZSND	.WORD	>F400|SPEAKPRI,>25,>8024,0    	;"FREEZE"
LETSGO	.WORD	>F400|SPEAKPRI,>23,>8027,0    	;"LET'S GO!"

SND1	.WORD	>F000|EXPLOPRI,>30,>8031,0	;LARGE EXPLOSION @ 20K
SND2	.WORD	>F000|EXPLOPRI,>30,>8007,0	;MISSLE LARGE EXPLOSION
BOMBSND	.WORD	>F000|EXPLOPRI,>30,>803D,0	;BIG BOMB @ 30K
CEXSND1	.WORD	>F000|EXPLOPRI,>30,>8031,0	;LARGE EXPLOSION @ 30K
CEXSND2	.WORD	>F000|EXPLOPRI,>30,>803C,0	;BIG BOMB @ 20K

SIZZAIR	.WORD	>F010,>20,>8016,0		;IN THE AIR ON FIRE
SIZZSND	.WORD	>F310,>20,>808B,0		;THE SIZZLE
FSIZZSND .WORD	>F310,>20,>8088,0		;THE FLAMER SIZZLE

SQUEELSR .WORD	>F015,>05,>800F,0		;CAR SQUEEL RIGHT
CADHORN	.WORD	>F340|NINT,>3E,>80A0,0		;CADILLAC HORN
CADSHLD	.WORD	>F320,>3E,>809B,0		;CADILLAC WINDSHIELD BREAKAGE
SPINSNDR .WORD	>F020,>64,>8017,0		;SPIN OUT SOUND
TRNKSNDR .WORD	>F020,>13,>8018,0		;TRUNK OPEN SOUND
CARREVR	.WORD	>F010,>10,>800E,0		;CAR REVVV RIGHT

PCSPINSD .WORD	>F010,>20,>800D,0		;PLAYER CAR SPIN OUT SOUND
PCBRAKSD .WORD	>F010,>64,>8017,0		;PLAYER CAR BRAKING SOUND
PCALLOFF .WORD	>F011,>01,>8002,0		;PLAYER CAR SOUND OFF

DOOROSND .WORD	>F000,>13,>8018,0		;DOOR OPEN
DOORCSND .WORD	>F000,>14,>8019,0		;DOOR CLOSE

WAVESND	.WORD	>F300,>20,>4060,>8085,0		;WAVE OVER
***WAVESND
	.WORD	>F3FD,>3C,>4020,>4060,>800A,>01,>8040,0

BULLRSND .WORD	>F300,>10,>809E,0      		;BULLETS REPLENISHED
NOBONSND .WORD	>F300,>10,>808D,0		;NO BONUS
BONCSND	.WORD	>F300,>01,>8091,0		;BONUS COUNTDOWN SHORT <150K
BONCLSND .WORD	>F300,>01,>80AC,0		;BONUS COUNTDOWN LONG >150K
CASHSND	.WORD	>F315,>01,>8098,0		;CASH PICK-UP AWARD
BUSTSND	.WORD	>F000|SPEAKPRI,>08,>804F,0	;BUST STAMP	
BUSTBONS .WORD	>F025,>20,>8049,0		;BUST STAMP FOR BONUS COUNT	
DRUGSND	.WORD	>F315,>01,>809D,0		;DOPE SOUND	
CLIPSND .WORD	>F015,>09,>8041,>8041,0		;CLIP PICKUP SOUND	
ROCKSND .WORD	>F316,>10,>808E,0		;ROCKET PICKUP SOUND	
CARDSND1 .WORD	>F000|SPEAKPRI,>1E,>802D,0	;"SAFE" CARD PICKUP 1 PLAYER
CARDSND2 .WORD	>F000|SPEAKPRI,>1E,>802D,>8027,0 ;"SAFE" CARD PICKUP 2 PLAYERS

OPENSD1 .WORD	>F000|SPEAKPRI,>1E,>802A,0	;"OPEN UP"
OPENSD2	.WORD	>F000|SPEAKPRI,>A,>8044,>8044
	.WORD	>1E,>802A,0			;KNOCK KNOCK, OPEN UP
OPENSD3	.WORD	>F000|SPEAKPRI,>18,>8029,>1E
	.WORD	>802A,0				;POLICE, OPEN UP
OPENSD4	.WORD	>F000|SPEAKPRI,>1E,>802A,>18
	.WORD	>8029,0				;OPEN UP, POLICE
OPENSD5	.WORD	>F000|SPEAKPRI,>A,>8044,>8044
	.WORD	>18,>8029,0			;KNOCK KNOCK, POLICE
OPENBEEP .WORD	>F315,>5,>80A4,>80A2,>80A5
	.WORD	>80A3,>80A4,0			;BEEPS, TO OPEN DOOR


KNOCKSND .WORD	>F000|SPEAKPRI,>10,>8044,>8044,0 ;KNOCK KNOCK
PBONSND	.WORD	>F300,>01,>808E,0		;PLAYER BONUS COUNT ANNOUNCE
FREESND	.WORD	>F3DF,>10,>8089,0		;"FREE MAN" SOUND
THECROWD .WORD	>F030|NINT,>CF,>801D,0		;CROWD CHEER
POWERSND .WORD	>F335,>F8,>8092,0		;CHOPPER POWERUP
CHOPCRUZ .WORD	>F335,>01,>8082,0		;CHOPPER CRUISE
ALARMSND .WORD	>F321,>01,>80A6,0		;BURGLAR ALARM SOUND

GAMOVSND
	.WORD	>F3FE,>FF,>4040,>8087,0		;GAME OVER SOUND
TUNE1LO
	.WORD	>F3FD,>01,>402F,>406F,>8007,0	;NARC 1 THEME
TUNE2LO
	.WORD	>F3FD,>01,>402F,>406F,>8001,0	;EUGENE GROOVE
TUNE3LO
	.WORD	>F3FD,>01,>402F,>406F,>8003,0	;ROCK 
TUNE4LO
	.WORD	>F3FD,>01,>402F,>406F,>8006,0	;BRIAN SPY/DRIVING THEME
TUNE5LO
	.WORD	>F3FD,>01,>402F,>406F,>8007,0
TUNE6LO
	.WORD	>F3FD,>01,>402F,>406F,>8002,0	;MR. BIG THEME
TUNE7LO
	.WORD	>F3FD,>01,>402F,>406F,>8003,0

TUNE2
	.WORD	>F3FD,>01,>4021,>4061,>8002,0	;MR. BIGS
TUNE3
	.WORD	>F3FD,>01,>4021,>4061,>8003,0	;LOCAS. 6/8
TUNE6
	.WORD	>F3FD,>01,>4021,>4061,>8006,0	;DRIVING THEME
TUNE7
	.WORD	>F3FD,>01,>4021,>4061,>8007,0	;NARC THEME
TUNE8	
	.WORD	>F3FD,>01,>4021,>4061,>8008,0	;SR TRIB
TUNE9
	.WORD	>F3FD,>01,>4021,>4061,>8009,0	;THE STICK
TUNE10
	.WORD	>F3FD,>01,>4021,>4061,>800B,0	;THE STICK - "BASS JAM"

TUNELAB
	.WORD	>F3FD,>01,>4021,>4061,>8008,>80D1,>80D2,>80D3,>D0D4,0 ;SR TRIB

RAPTUNE
	.WORD	>F3FD,>01,>4020,>4060,>8004,0

FADEUP
	.WORD	>F3FD,>10,>402D,>806D,>402B,>806B
	.WORD	>4029,>8069,>4027,>8067,>4025
	.WORD	>8065,>4023,>8063,0
FADEDOWN
	.WORD	>F3FD,>10,>4022,>8062,>4024,>8064
	.WORD	>4026,>8066,>4028,>8068,>402A
	.WORD	>806A,>402C,>806C,>402F,>806F,0
MUSICFUL
	.WORD	>F3FE,>1,>4020,>8060,0		;MUSIC TO FULL VOLUME
MUSICNRM
	.WORD	>F3FE,>1,>4023,>8063,0		;MUSIC NORMAL VOLUME
*
*HIGH PRIORITY OFF CODES, NOTHING SHOULD BEAT THESE
CVSDOFF  .WORD	>F0FF|>800,>01,>8001,0		;CVSD BACKGROUND LOOP OFF
CVSDFOFF .WORD	>F0FF|>800,>01,>8002,0		;CVSD FOREGROUND LOOP OFF
SOUNDOFF .WORD	>F0FF|>800,>01,>8000,0		;TURN SOUND SIDE OFF
ALLOFF	 .WORD	>F0FF|>800,>01,>4000,>4001,>8002,0	;ALL CVSD & DAC SOUNDS OFF
MUSICOFF .WORD	>F3FF|>800,>01,>8000,0		;MUSIC HARD OFF
MUSITOFF .WORD	>F3FF|>800,>01,>8040,0		;MUSIC TRANSITION OFF
YAMOFF	 .WORD	>F3FF|>800,>01,>807F,0		;YAMAHA EFFECT OFF

	.END
