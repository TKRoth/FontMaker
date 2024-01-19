   10 REM ********************************
   20 REM ***                          ***
   30 REM ***  FontMaker  Version 1.0  ***
   40 REM ***                          ***
   50 REM *** by Thomas Krueger-Reimer ***
   60 REM ***                          ***
   70 REM ***         (C) 2023         ***
   80 REM ***                          ***
   90 REM ********************************
  100 :
  500 :
  510 REM *********************************
  520 REM * Initialyzing and build screen *
  530 REM *********************************
  540 :
  550 DIM CHAR% 2055
  560 COLOUR 15:COLOUR 128:MODE 8:VDU 23,0,192,0
  570 ON ERROR GOTO 3300
 1000 PRINT TAB(1,29);"Please wait ...";
 1010 PROCBigString(7,7,"FontMaker 1.0",1)
 1020 PROCBigString(5,5,"FontMaker 1.0",9)
 1030 COLOUR 11:PRINT TAB(2,4);
 1040 PRINT "(C) 2023  by  Thomas Krueger-Reimer";
 1050 PROCBox(10,66,85,141,4)
 1060 PROCBox(116,68,131,83,2)
 1070 PROCBox(108,124,138,138,2)
 1080 PROCBox(164,68,299,203,2)
 2000 COLOUR 7:PRINT TAB(3,7);"Editor";
 2010 PRINT TAB(12,7);"Preview";
 2020 PRINT TAB(12,14);"In work";
 2030 PRINT TAB(25,7);"Char set";
 2100 PRINT TAB(1,19);"[N] New char set";
 2110 PRINT TAB(1,20);"[C] Select char";
 2120 PRINT TAB(1,21);"[M] Char in set";
 2130 PRINT TAB(1,22);"[L] Load char set";
 2140 PRINT TAB(1,23);"[S] Save char set";
 2150 PRINT TAB(1,24);"[P] Put editor to";
 2160 PRINT TAB(1,25);"[X] Quit FontMaker":
 2170 PRINT TAB(1,27);
 2180 PRINT "Cursor keys and space for edit/select";
 2200 CH%=32:PROCCreateCharBitmaps
 2210 PROCShowCharset:PROCMoveChar(CH%,256)
 2220 PROCWorkChar(TRUE):PROCShowChanges
 2230 PROCClearState
 2240 :
 3000 :
 3010 REM **********************
 3020 REM * Main loop / Editor *
 3030 REM **********************
 3040 :
 3050 COLOUR 15:X%=0:Y%=0
 3060 PROCClearState:PRINT TAB(2+X%,9+Y%);:K%=GET
 3070 IF K%=8 THEN IF X% THEN X%=X%-1:GOTO 3060
 3080 IF K%=10 THEN IF Y%<7 THEN Y%=Y%+1:GOTO 3060
 3090 IF K%=11 THEN IF Y% THEN Y%=Y%-1:GOTO 3060
 3100 IF K%=21 THEN IF X%<7 THEN X%=X%+1:GOTO 3060
 3110 IF K%=32 THEN PROCToggle(X%,Y%):PROCShowChanges
 3120 IF K%=67 OR K%=99 THEN PROCSelectChar
 3130 IF K%=76 OR K%=108 THEN PROCLoadSet
 3140 IF K%=77 OR K%=109 THEN PROCPutInSet
 3150 IF K%=78 OR K%=110 THEN PROCNewCharset
 3160 IF K%=80 OR K%=112 THEN REM PUT EDITOR TO
 3170 IF K%=83 OR K%=115 THEN PROCSaveSet
 3180 IF K%=88 OR K%=120 THEN PROCQuit
 3190 GOTO 3060
 3200 :
 3250 :
 3260 REM ***********************
 3270 REM * Show editor changes *
 3280 REM ***********************
 3290 :
 3300 DEF PROCShowChanges
 3310 PROCShowChar(256,15,9):PROCShowEditor
 3320 ENDPROC
 3330 :
 3350 :
 3360 REM ******************
 3370 REM * Error handling *
 3380 REM ******************
 3390 :
 3400 K%=ERR:IF K%=17 THEN PROCClearState:GOTO 2060
 3410 COLOUR 9:PRINT TAB(1,29);
 3420 PRINT "Error ";STR$(K%);" in ";STR$(ERL);
 3430 K%=GET:PROCClearState:MODE 1:END
 3440 :
10000 :
10010 REM *******************************
10020 REM * Select a char from char set *
10030 REM *******************************
10040 l
10050 DEF PROCSelectChar
10060 LOCAL CO%:CO%=CH%:VDU 23,1,0:PROCWorkChar(0)
10070 COLOUR 11:COLOUR 128:PRINT TAB(1,29);
10080 PRINT "[TAB] Cancel  [SPACE] Select and edit";
10100 REPEAT:K%=GET
10110   IF K%=8 THEN PROCSelectLeft
10120   IF K%=9 THEN PROCChangeSelect(CH%,CO%):CH%=CO%
10130   IF K%=10 THEN PROCSelectDown
10140   IF K%=11 THEN PROCSelectUp
10150   IF K%=21 THEN PROCSelectRight
10250 UNTIL K%=9 OR K%=32:VDU 23,1,1:PROCClearState
10270 PROCMoveChar(CH%,256):PROCShowChanges:PROCWorkChar(-1)
10280 ENDPROC
10290 :
11000 :
11010 REM ***************
11020 REM * Select left *
11030 REM ***************
11040 :
11050 DEF PROCSelectLeft
11060 IF CH% MOD 16=0 THEN 11080
11070 CH%=CH%-1:PROCChangeSelect(CH%+1,CH%):PROCWorkChar(0)
11080 ENDPROC
11090 :
11100 :
11110 REM ****************
11120 REM * Select right *
11130 REM ****************
11140 :
11150 DEF PROCSelectRight
11160 IF CH% MOD 16=15 THEN 11180
11170 CH%=CH%+1:PROCChangeSelect(CH%-1,CH%):PROCWorkChar(0)
11180 ENDPROC
11190 :
11200 :
11210 REM *************
11220 REM * Select up *
11230 REM *************
11240 :
11250 DEF PROCSelectUp
11260 IF CH%<48 THEN 11280
11270 CH%=CH%-16:PROCChangeSelect(CH%+16,CH%):PROCWorkChar(0)
11280 ENDPROC
11290 :
11300 :
11310 REM ***************
11320 REM * Select down *
11330 REM ***************
11340 :
11350 DEF PROCSelectDown
11360 IF CH%>239 THEN 11380
11370 CH%=CH%+16:PROCChangeSelect(CH%-16,CH%):PROCWorkChar(0)
11380 ENDPROC
11390 :
12000 :
12010 REM *******************
12020 REM * Put char in set *
12030 REM *******************
12040 :
12050 DEF PROCPutInSet
12060 LOCAL PX%,PY%:PX%=(CH% MOD 16)+21:PY%=(CH% DIV 16)+9
12070 PROCMoveChar(256,CH%):PROCShowChar(CH%,PX%,PY%)
12080 PROCClearState
12085 ENDPROC
12090 :
12100 :
12110 REM *****************
12120 REM * Load char set *
12130 REM *****************
12140 :
12150 DEF PROCLoadSet
12160 F$=FNGetName:K%=OPENIN F$
12170 IF K%<0 THEN CLS:PRINT K%;CHR$(7);:GOTO 12240
12180 COLOUR 11:COLOUR 128:PRINT TAB(1,29);"File loading ...";
12190 VDU 23,1,0
12200 FOR L%=0 TO 2047:CHAR%?L%=BGET #K%:NEXT:CLOSE #K%
12210 CH%=32:PROCCreateCharBitmaps:PROCMoveChar(CH%,256)
12220 PROCWorkChar(TRUE):PROCShowChanges
12230 PROCShowCharset:PROCClearState:VDU 23,1,1
12240 ENDPROC
12250 :
12300 :
12310 REM *****************
12320 REM * Save char set *
12330 REM *****************
12340 :
12350 DEF PROCSaveSet
12360 F$=FNGetName:K%=OPENOUT F$
12370 IF K%<0 THEN CLS:PRINT CHR$(7);:GOTO 12420
12380 COLOUR 11:COLOUR 128:PRINT TAB(1,29);"File saving ...";
12390 VDU 23,1,0
12400 FOR L%=0 TO 2047:BPUT #K%,CHAR%?L%:NEXT:CLOSE #K%
12410 PROCClearState:VDU 23,1,1
12420 ENDPROC
12430 :
12500 :
12510 REM ****************
12520 REM * New char set *
12530 REM ****************
12540 :
12550 DEF PROCNewCharset
12560 K%=FNGetAnswer("New set. Realy (Y/N) ?")
12570 IF K%=FALSE THEN 12630
12580 COLOUR 11:COLOUR 128:PRINT TAB(1,29);"Please wait ...";
12590 FOR K%=0 TO 2055:CHAR%?K%=0:NEXT
12600 CH%=32:PROCCreateCharBitmaps:PROCMoveChar(CH%,256)
12610 PROCWorkChar(TRUE):PROCShowChanges
12620 PROCShowCharset:PROCClearState:X%=0:Y%=0:VDU 23,1,1
12630 ENDPROC
12640 :
12700 :
12710 REM ******************
12720 REM * Quit FontMaker *
12730 REM ******************
12740 :
12750 DEF PROCQuit
12760 K%=FNGetAnswer("Realy quit (Y/N) ?")
12770 IF K% THEN MODE 1:COLOUR 15:COLOUR 128:CLS:END
12780 ENDPROC
12790 :
60000 :
60010 REM *********************
60020 REM * Draw a big string *
60030 REM *********************
60040 :
60050 DEF PROCBigString(XS%,YS%,S$,COL%)
60060 LOCAL C%,X%,Y%,L%:GCOL 0,COL%:COLOUR 16
60070 FOR C%=1 TO LEN(S$)
60080   PRINT TAB(0,29);MID$(S$,C%,1);:FOR L%=0 TO 500:NEXT
60090   FOR Y%=0 TO 7
60100     FOR X%=0 TO 7:L%=(C%-1)*24+(X%*3)
60110       IF POINT(X%,232+Y%) THEN PROCPlot(L%+XS%,Y%*3+YS%)
60120     NEXT
60130   NEXT
60140 NEXT:PRINT TAB(0,29);" ";
60150 ENDPROC
60160 :
60500 :
60510 REM ******************
60520 REM * Draw big point *
60530 REM ******************
60540 :
60550 DEF PROCPlot(X%,Y%)
60560 LOCAL L%:FOR L%=0 TO 2
60570   MOVE X%,Y%+L%:DRAW X%+2,Y%+L%
60580 NEXT
60590 ENDPROC
60600 :
60700 :
60710 REM **************
60720 REM * Draw a box *
60730 REM **************
60740 :
60750 DEF PROCBox(XS%,YS%,XE%,YE%,T%)
60760 LOCAL L%:FOR L%=0 TO T%-1
60770   GCOL 0,1:MOVE XS%+L%,YS%+L%:DRAW XS%+L%,YE%-L%
60780   MOVE XS%+L%,YS%+L%:DRAW XE%-L%,YS%+L%
60790   GCOL 0,9:MOVE XE%-L%,YE%-L%:DRAW XS%+L%,YE%-L%
60800   MOVE XE%-L%,YE%-L%:DRAW XE%-L%,YS%+L%
60810 NEXT
60820 ENDPROC
60830 :
60900 :
60910 REM ************************
60920 REM * Toggle point in char *
60930 REM ************************
60940 :
60950 DEF PROCToggle(PX%,PY%)
60970 LOCAL M%,A%,R%:M%=2^(7-PX%):A%=2048+PY%:R%=CHAR%?A%
60980 R%=R% EOR M%:CHAR%?A%=R%:PROCCreateBitmap(256)
60990 ENDPROC
61000 :
61100 :
61110 REM ***********************
61120 REM * Dhow char in editor *
61130 REM ***********************
61140 :
61150 DEF PROCShowEditor
61160 LOCAL PX%,PY%,M%,R%:FOR PY%=0 TO 7
61170   FOR PX%=0 TO 7:M%=2^(7-PX%):R%=CHAR%?(2048+PY%) AND M%
61180     IF R% THEN COLOUR 143 ELSE COLOUR 128
61190     PRINT TAB(2+PX%,9+PY%);" ";
61200   NEXT
61210 NEXT:COLOUR 15:COLOUR 128:PRINT TAB(0,29);" ";
61220 ENDPROC
61230 :
61250 :
61260 REM *************
61270 REM * Show char *
61280 REM *************
61290 :
61300 DEF PROCShowChar(C%,PX%,PY%)
61310 IF C%<32 THEN 61380
61320 VDU 23,27,0,C%-32,23,27,3,PX%*8;PY%*8;
61380 ENDPROC
61390 :
61400 :
61410 REM *****************
61420 REM * Show char set *
61430 REM *****************
61440 :
61450 DEF PROCShowCharset
61460 LOCAL PX%,PY%,C%:FOR C%=0 TO 255
61470   IF C% MOD 16=0 THEN PY%=PY%+1:PX%=0
61490   PROCShowChar(C%,PX%+21,PY%+8):PX%=PX%+1
61500 NEXT:COLOUR 9:COLOUR 128:PRINT TAB(24,9);"Char  0-31";
61510 PRINT TAB(23,10);"not editable";
61520 ENDPROC
61530 :
61600 :
61610 REM *******************************
61620 REM * Show number of char in work *
61630 REM *******************************
61640 :
61650 DEF PROCWorkChar(EM%)
61660 IF EM% THEN COLOUR 11 ELSE COLOUR 9
61670 PRINT TAB(14,16);RIGHT$("  "+STR$(CH%),3);:PROCClearState
61680 ENDPROC
61690 :
61700 :
61710 REM **********************
61720 REM * Move a char in set *
61730 REM **********************
61740 :
61750 DEF PROCMoveChar(SC%,DC%)
61760 SC%=SC%*8:DC%=DC%*8:LOCAL L%:FOR L%=0 TO 7
61770   CHAR%?(DC%+L%)=CHAR%?(SC%+L%):NEXT:PROCClearState
61775 PROCCreateBitmap(DC%/8)
61780 ENDPROC
61790 :
61800 :
61810 REM *******************************
61820 REM * Change selected char in set *
61830 REM *******************************
61840 :
61850 DEF PROCChangeSelect(CO%,CN%)
61860 LOCAL PX%,PY%,CS%:PX%=CO% MOD 16:PY%=CO% DIV 16
61870 CS%=CH%:CH%=0
61880 PROCCreateBitmap(CO%):PROCShowChar(CO%,PX%+21,PY%+9)
61890 PX%=CN% MOD 16:PY%=CN% DIV 16:CH%=CN%
61900 PROCCreateBitmap(CN%):PROCShowChar(CN%,PX%+21,PY%+9)
61910 CH%=CS%
61920 ENDPROC
61930 :
62000 :
62010 REM ***************
62020 REM * Clear state *
62030 REM ***************
62040 :
62050 DEF PROCClearState
62060 COLOUR 15:COLOUR 128:PRINT TAB(1,29);SPC(38);
62070 ENDPROC
62080 :
62100 :
62110 REM ****************
62120 REM * Get filename *
62130 REM ****************
62140 :
62150 DEF FNGetName
62160 LOCAL F$:COLOUR 11:COLOUR 128:PRINT TAB(1,29);"Name : ";
62170 PRINT TAB(8,29);F$;SPC(31-LEN(F$));
62180 PRINT TAB(8+LEN(F$),29);:K%=GET
62190 IF K%=13 THEN 62230
62200 IF K%=127 THEN F$=LEFT$(F$,LEN(F$)-1):GOTO 62170
62210 IF K%>31 AND LEN(F$)<31 THEN F$=F$+CHR$(K%)
62220 GOTO 62170
62230 PROCClearState
62240 =F$
62250 :
62300 :
62310 REM ************************
62320 REM * Create a char bitmap *
62330 REM ************************
62340 :
62350 DEF PROCCreateBitmap(N%)
62355 VDU 23,27,0,N%-32,23,27,1,8;8;
62360 LOCAL L%,B%,M%,A%:FOR L%=0 TO 7:A%=CHAR%?(N%*8+L%)
62370   FOR P%=0 TO 7:M%=2^(7-P%)
62380     IF A% AND M% THEN B%=1 ELSE B%=0
62400     IF CH%=N% THEN VDU 255,B%*255,0,255:GOTO 62420
62410     VDU B%*255,B%*255,B%*255,255
62420   NEXT
62430 NEXT
62440 ENDPROC
62450 :
62500 :
62510 REM ***************************
62520 REM * Create bitmaos for char *
62530 REM ***************************
62540 :
62550 DEF PROCCreateCharBitmaps
62560 LOCAL C%:FOR C%=32 TO 255:PROCCreateBitmap(C%):NEXT
62570 ENDPROC
62580 :
62600 :
62610 REM *********************
62620 REM * Get yes/no answer *
62630 REM *********************
62640 :
62650 DEF FNGetAnswer(Q$)
62660 COLOUR 11:COLOUR 128:PRINT TAB(1,29);Q$;
62670 LOCAL A$:VDU 23,1,0:REPEAT A$=GET$
62680   IF A$="Y" OR A$="y" THEN K%=TRUE
62690   IF A$="N" OR A$="n" THEN K%=FALSE
62700 UNTIL A$="Y" OR A$="y" OR A$="N" OR A$="n"
62710 PROCClearState:VDU 23,1,1
62720 =K%
62730 :
