SMAL32 (rev  8/19)              mp3.a by Vinayak Deshpande   18:26:12  Page  1
                                                             Tue Mar  5 2024

                                 1          TITLE   "mp3.a by Vinayak Deshpande"
                                 2  ;               special thanks to Ben and Sai for their help explaining
                                 3  ;               what I was missing.
                                 4          USE     "hawk.h"
                                 5          USE     "stdio.h"
                                 6          USE     "ascii.h"
                                 7  
                                 8          EXT     MP3DATA
                                 9  
                                10          INT     MAIN
                                11          S       MAIN
                                12  ;Activation Record for TRAVERSE
                                13  RETAD   =       0
                                14  NODE    =       4
                                15  ARSIZE  =       8
                                16  
                                17  TRAVERSE:
                                18          ; expects R8: the pointer
                                19          ; returns nothing
+00000000: F1  A2               20          STORES  R1,R2
+00000002: F8  22  0004         21          STORE   R8,R2,NODE      ; Point to the data
+00000006: 12  C0               22          ADDSI   R2,ARSIZE
+00000008: F3  D8               23          LOADS   R3,R8           ; grab MP3DATA and get the value
+0000000A: F0  E3               24          TESTR   R3              ; If pointer is null end recursion
+0000000C: 02  11               25          BZS     QUIT
                                26  
+0000000E: 90  31               27          BITTST  R3,0            ; If pointer is at odd value
+00000010: 04  09               28          BBS     PRINTNODE       ; call the print function
                                29  
+00000012: F8  F3               30          MOVE    R8,R3           ; if pointer is at even value, recurse
+00000014: F1  30  FFE8         31          JSR     R1,TRAVERSE
+00000018: F8  52  FFFC         32          LOAD    R8,R2,NODE-ARSIZE       ; pop AR to move back up tree
+0000001C: 18  C4               33          ADDSI   R8,4
+0000001E: F1  30  FFDE         34          JSR     R1,TRAVERSE
                                35  
+00000022: 00  06               36          BR      QUIT
                                37  PRINTNODE:
+00000024: E1 +000000           38          LIL     R1,PUTSTR
+00000028: F1  B1               39          JSRS    R1,R1
+0000002A: 18  C4               40          ADDSI   R8,4            ; increment pointer
+0000002C: F1  30  FFD0         41          JSR     R1,TRAVERSE     ; recurse
SMAL32 (rev  8/19)              mp3.a by Vinayak Deshpande   18:26:12  Page  2
                                                             Tue Mar  5 2024

                                42  
                                43  QUIT:
+00000030: 12  C8               44          ADDSI   R2,-ARSIZE      ;return sequence for traverse
+00000032: F0  D2               45          LOADS   PC,R2
                                46  
                                47  ;Activation Record for MAIN
                                48  ;RETAD  =       0
                                49  ARSIZE  =       4
                                50  
                                51  MAIN:
+00000034: F1  A2               52          STORES  R1,R2
+00000036: 12  C4               53          ADDSI   R2,ARSIZE
                                54  
+00000038: E8 +000000           55          LIL     R8,MP3DATA
+0000003C: F1  30  FFC0         56          JSR     R1,TRAVERSE
                                57  
+00000040: 12  CC               58          ADDSI   R2,-ARSIZE
+00000042: F0  D2               59          LOADS   PC,R2
                                60  
                                61          END
                    no errors
