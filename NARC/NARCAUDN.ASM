**************************************************************************
*                                                                        *
*          NARC (R)                                                      *
*                                                                        *
*          Copyright 1988 Williams Electronics Games Inc.                *
*          All Rights Reserved                                           *
*                                                                        *
**************************************************************************
*
*        AUDITS
*
*        AUDITS ARE HANDLED BY AUDITS NUMBER OFF OF THE BASE
*        OF THE AUDIT REGION
*
*
*        IF "CHUTES" VALUE IS CHANGED....EXTRA VALUES MUST
*        BE PUT IN THIS TABLE.  (AND ADJUSTMENT TABLE OF COURSE)
*
AUDNULL          EQU     0
AUDLCOIN         EQU     1       ;TOTAL COINS IN LEFT CHUTE
AUDCCOIN         EQU     2
AUDRCOIN         EQU     3
AUDLCDC          EQU     4       ;LEFT COIN W/ DOOR CLOSED
AUDCCDC          EQU     5       ;CENTER COIN W/ DOOR CLOSED
AUDRCDC          EQU     6       ;RIGHT COIN W/ DOOR CLOSED
AUDLCSUB         EQU     7       ;SUB-TOTAL OF TOTAL COINS IN LEFT CHUTE
AUDCCSUB         EQU     8
AUDRCSUB         EQU     9
AUDLCDCS         EQU    10       ;SUB-TOTAL OF DOOR CLOSED COINS IN LEFT CHUTE
AUDCCDCS         EQU    11       ;SUB-TOTAL OF DOOR CLOSED COINS IN LEFT CHUTE
AUDRCDCS         EQU    12       ;SUB-TOTAL OF DOOR CLOSED COINS IN LEFT CHUTE
AUDPAIDC         EQU    13
*
FRST_SUB         EQU     AUDLCSUB     ;FOR CLEARING OUT SUB TOTALS
LAST_SUB         EQU     AUDRCDCS
*
FRST_C           EQU     AUDLCOIN     ;FOR CLEARING COINS
LAST_C           EQU     AUDPAIDC
*
AUD1STRT         EQU    14
AUD2STRT         EQU    15
AUD1CONT         EQU    16
AUD2CONT         EQU    17
AUD1TIME         EQU    18      ;5 SECOND CHUNKS.  (700 YEARS WORTH)
AUD2TIME         EQU    19      ;5 SECOND CHUNKS.
AUDEXTRA         EQU    20
AUDWAVE1         EQU    21
AUDWAVE2         EQU    22
AUDWAVE3         EQU    23
AUDWAVE4         EQU    24
AUDWAVE5         EQU    25
AUDWAVE6         EQU    26
AUDWAVE7         EQU    27
AUDWAVE8         EQU    28
AUDWAVE9         EQU    29
AUDWAV10         EQU    30
AUDWLAST         EQU    10      ;wave requests beyond here ignored
AUDFINI          EQU    31      ;got to finish
AUDAUTO          EQU    32      ;AUTO CYCLE PASSES
AUDDOGGY         EQU    33      ;WATCHDOG HITS
AUDLOCK          EQU    34      ;EXEC LOCKUPS
AUDRED	        EQU    35
AUDBLUE		EQU    36
AUDSILV		EQU    37
AUDTRAP          EQU    38      ;UNUSED TRAP INSTRUCTION
AUDSURV          EQU    39      ;SURVIVED LOCKUPS
AUDBONE          EQU    40
AUDLOOP          EQU    41
*
LAST_AUDIT       EQU    41     
*
FRSTGAUD         EQU     AUD1STRT
LASTGAUD         EQU     LAST_AUDIT
*
*        ADJUSTMENTS ARE ALL LONG WORDS REFERENCED BY ADJUSTMENT
*        NUMBER.
*
ADJNULL          EQU     0
ADJPRICE         EQU     1      ;MASTER PRICING
ADJLMULT         EQU     2
ADJC1            EQU     ADJLMULT          ;FIRST COIN TABLE ADJUSTMENT
ADJCMULT         EQU     3
ADJRMULT         EQU     4
ADJCUNIT         EQU     5
ADJBUNIT         EQU     6
ADJMUNIT         EQU     7
ADJCDIV          EQU     8
ADJFRAC          EQU     9      ;NON ZERO SAYS SHOW HALF CREDITS
ADJCX            EQU     ADJFRAC           ;LAST COIN TABLE ADJUSTMENT
ADJCSTRT         EQU     10      ;CREDITS REQUIRED TO START
ADJCCONT         EQU     11      ;CREDITS REQUIRED TO CONTINUE
ADJDIFF          EQU     12
ADJHSRES         EQU     13
ADJLIVES         EQU     14
ADJROCKS         EQU     15
ADJEXTRA         EQU     16      ;SCORE STORED HERE
ADJLAST          EQU     17      ;NO EXTRA MEN BEYOND THIS SCORE
ADJMUSIC         EQU     18
ADJMAXC          EQU     19      ;MAXIMUM CREDITS
ADJFREPL         EQU     20      ;NON-ZERO MEANS FREE PLAY
ADJVIRGIN        EQU     21      ;NON-ZERO MEANS 1ST 8 OF COIN ADJUST BLOCK UNTOUCHTED
**********************************;ADJVIRGIN IS MAINTAINED...BUT NOT USED
ADJGORE          EQU     22
ADJ1ST6          EQU     23      ;NON-ZERO MEANS 1ST 6 UNTOUCHED.
ADJNOCPAG        EQU     24
ADJBUYIN         EQU     25
LAST_ADJUST      EQU     25      



