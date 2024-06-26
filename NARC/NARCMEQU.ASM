**************************************************************************
*                                                                        *
*          NARC (R)                                                      *
*                                                                        *
*          Copyright 1988 Williams Electronics Games Inc.                *
*          All Rights Reserved                                           *
*                                                                        *
**********************************MENU EQUATES****************************
*
*        FOR EACH ENTRY IN THE MENU
*
MENU_TEXT_PTR    EQU     0            ;OFFSET OF TEXT POINTER
MENU_ROUTINE     EQU     LONG_SIZE    ;OFFSET OF ROUTINE
MENU_HELP        EQU     MENU_ROUTINE+LONG_SIZE
MENU_ENTRY_SIZE  EQU     3*LONG_SIZE   
*
BLNK_HELP        EQU     0            ;NO HELP BOX FOR THIS ENTRY
NO_HELP          EQU     00000001H    ;NO HELP AREA IN THIS MENU 
ADJ_HELP         EQU     00000002H    ;PASS STRUCTURE POINTER TO ADJUSTMENT HELP ROUT
SND_HELP         EQU     00000003H    ;CALLED ON SOUND TEST MENU
SND_PLAY         EQU     00000004H    ;CALLED FROM SOUND "PLAY" SELECTIONS
*
SND_MESS_Y       EQU     330
SND_BOX_H        EQU     69

*
*        SPACING BETWEEN BOXES ON SCREEN
*
BOX_YGAP EQU     6
BOX_XGAP EQU     6
*
*
*        A CENTERED BOX NEEDS TO BE MOVED LEFT THIS AMOUNT
*        (PIXELS) TO CORRECTELY FRAME CENTERED TEXT AT
*        THE SAME POSITION
*
*C_KLUDGE EQU        3           ;BEFORE "SPACE WIDTH" BUG FIX
C_KLUDGE EQU     1
*
*        THESE DETERMINE THE THICKNESS OF THE BOX LINES
*
MB_XWID  EQU     5
MB_YWID  EQU     5
*
*        GAP BETWEEN A MENU BORDER BOX AND
*        THE SELECTION BAR
*
GAP      EQU     2               ;GAP BETWEEN BORDER AND SELECTION BAR
*
*        CONSTANT TO PASS TO "DO_BORDER" FOR OUR
*        BOX SIZE
*
BORDER_SIZE      EQU     (MB_YWID*10000H)+MB_XWID

*******************************TEST TITLE CONSTANTS****************************
*
*        THESE ARE USED TO SET TOP BOX AND MAIN TITLE.
*        THE MENUS AND HELP SCREENS WILL SQUARE OFF 
*        TO THE NUMBERS SET HERE.
*

TM_X     EQU     256             ;USED TO POSITION TITLE AND BOX TOGETHER
TM_Y     EQU     24

*TIT_ULX  EQU     TM_X-0D0H
*TIT_LRX  EQU     TM_X+0C8H
TIT_ULX  EQU     TM_X-0D4H
TIT_LRX  EQU     TM_X+0CCH

TIT_ULY  EQU     TM_Y-09H
TIT_LRY  EQU     TM_Y+31H

********************************MAIN MENU CONSTANTS***************************

INST_ULY EQU     TIT_LRY+BOX_YGAP     ;Y RANGE FOR INSTRUCTION BOX
INST_LRY EQU     INST_ULY+40

BAR_DY   EQU     -12
BAR_WID EQU     235
MENU_X   EQU     TIT_ULX+GAP+MB_XWID+(BAR_WID/2)+C_KLUDGE
MENU_Y   EQU     INST_LRY+BOX_YGAP+MB_YWID+GAP-BAR_DY
MENU_DY  EQU     42
BAR_HITE EQU     40
BAR_DX   EQU     8
*
*        HELP DRAWER CONSTANTS
*
HELP_X_MARGIN    EQU     10                ;MARGIN FOR LEFT JUSTIFIED HELP TEXT
HELP_Y_MARGIN    EQU     8                 ;TOP OF BOX TO 1ST ENTRY
HELP_YLO_MARGIN  EQU     HELP_Y_MARGIN-4   ;BOTTOM MARGIN IS A TOUCH LESS DUE
*                                          ;TO SPACING
HELP_DY          EQU     12                ;SCREEN UNITS PER ITEM.
*
*
*        ADJUSTMENT MENU CONSTANTS
*
*        "CURRENT SETTING" BOX
*
CUR_ULY  EQU     225
CUR_LRX  EQU     TIT_LRX
CUR_LRY  EQU     CUR_ULY+(INST_LRY-INST_ULY)    ;SAME HEIGHT AS TOP BOX
*
ADJ_ULY  EQU     CUR_LRY+BOX_YGAP               ;USE OUR "FIXED" SPACING.
*
COIN_HEAD_Y  EQU    CUR_ULY+96                  ;1ST OF TOP COIN INFO LINES
MESS_CTS     EQU    COIN_HEAD_Y+39             ;START/CONTINUE PLACE

**************************************************************************
*                                                                        *
*                  COIN SELECT TABLE OFFSETS                             *
*                                                                        *
**************************************************************************
*
*        IF "CHUTES" VALUE CHANGES.....EXTRA WORDS MUST BE PUT HERE
*
CS_LMULT EQU     0
CS_CMULT EQU     CS_LMULT+WORD_SIZE
CS_RMULT EQU     CS_CMULT+WORD_SIZE
CS_UCRED EQU     CS_RMULT+WORD_SIZE
CS_UBON  EQU     CS_UCRED+WORD_SIZE
CS_UMIN  EQU     CS_UBON+WORD_SIZE
*CS_STRT  EQU     CS_UMIN+WORD_SIZE     
*CS_CONT  EQU     CS_STRT+WORD_SIZE     
CS_CDIV  EQU     CS_UMIN+WORD_SIZE
CS_FRAC  EQU     CS_CDIV+WORD_SIZE
CS_COPY  EQU     CS_FRAC+WORD_SIZE         ;UP TO HERE IS COPIED AS ADJUSTMENTS
CS_LVAL  EQU     CS_COPY
CS_CVAL  EQU     CS_LVAL+WORD_SIZE
CS_RVAL  EQU     CS_CVAL+WORD_SIZE
CS_LMES  EQU     CS_RVAL+WORD_SIZE
CS_RMES  EQU     CS_LMES+LONG_SIZE
CS_PROMPT EQU    CS_RMES+LONG_SIZE
CS_TITLE EQU     CS_PROMPT+LONG_SIZE
CS_LIST  EQU     CS_TITLE+LONG_SIZE
CS_PICK  EQU     CS_LIST+LONG_SIZE         ;WHICH LINE TO ADD TO 2 TO START...1 TO
CS_SLOTS EQU     CS_PICK+WORD_SIZE         ;TEXT DESCRIBING COIN SLOTS
CS_SIZE  EQU     CS_SLOTS+LONG_SIZE
*
*
*        ADJUSTMENT STRUCTURE.   THIS STRUCTURE IS
*        POINTED TO BY THE 2ND MENU LONG WORD (WHERE NORMALLY
*        THE ROUTINE LIVES).  
*
AD_ROUT  EQU     0                         ;LONG...ROUTINE TO RUN WHEN SELECTED.
AD_TITLE EQU     AD_ROUT+LONG_SIZE         ;LONG...POINTER TO TITLE FOR RIGHT COLUMN
AD_HELP  EQU     AD_TITLE+LONG_SIZE        ;LONG...POINT TO HELP STRUCT FOR EXPLANATION
AD_CMOS  EQU     AD_HELP+LONG_SIZE         ;WORD...GET_ADJ / PUT_ADJ NUMBER.
AD_MIN   EQU     AD_CMOS+WORD_SIZE         ;LONG...MINIMUM VALUE FOR ADJ.
AD_MAX   EQU     AD_MIN+LONG_SIZE          ;LONG...MAXIMUM VALUE FOR ADJ.
AD_DELTA EQU     AD_MAX+LONG_SIZE          ;LONG...UNITS BETWEEN VALUES.
AD_ZEQU  EQU     AD_DELTA+LONG_SIZE        ;LONG...NUMBER TO STORE AS A ZERO.
AD_NAMEIT EQU    AD_ZEQU+LONG_SIZE         ;LONG...ROUTINE TO PRINT VALUES.
AD_FLAGS  EQU    AD_NAMEIT+LONG_SIZE       ;WORD...bit zero non zero says wrap 
*                                          ;       bit one non zero says BCD
                                           ;       bit two says flag "1st 8 coinage changed"  (ADJVIRGIN)
                                           ;       bit three says flag 1st 6 changed  (ADJ1st6)
                                           ;       bit four says its hsr counter
AD_NAMPTR EQU    AD_FLAGS+WORD_SIZE        ;LONG...POINTER TO DATA FOR NAMEIT ROUTINE
AD_MAIN  EQU     AD_NAMPTR+LONG_SIZE       ;LONG...MAIN MENU STRING

WRAP_BIT EQU     0
BCD_BIT  EQU     1
VIRG_BIT EQU     2
SIX_BIT  EQU     3
HSR_BIT  EQU     4
WRAP_VAL EQU     1
BCD_VAL  EQU     2
VIRG_VAL EQU     4
SIX_VAL  EQU     8
HSR_VAL  EQU     16
*
*        FOR CSELECT TABLE......
*
*        A1 = 1  PLOT ONLY THE STRING LIST (1 OR 2 POINTERS
*                CENTERED APPROPRIATELY
*
*        A1 = 2  PLOT THE 1ST LINE OF THE STRING LIST ALONG
*                WITH THE 2 CREDITS TO START...1 TO CONTINUE
*        
*        A1 = 3  PLOT THE 2ND LINE OF THE STRING LIST ALONG
*                WITH THE 2 CREDITS TO START...1 TO CONTINUE
*
CSM_LIST EQU     1
CSM_1W_21 EQU    2
CSM_2W_21 EQU    3
CSM_3W_21 EQU    4
CSM_LAST EQU     4

*
*        FOR CS_PICK:
*
SHOW_NONE        EQU     0            ;JUST USE 2/1 BY ITSELF 
SHOW_1           EQU     2            ;SHOW 1ST LINE
SHOW_2           EQU     3            ;SHOW 2ND LINE
SHOW_3           EQU     4            ;SHOW 3RD LINE

