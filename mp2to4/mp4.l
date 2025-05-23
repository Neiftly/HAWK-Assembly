SMAL32 (rev  8/19)              mp4.a by Vinayak Deshpande   17:32:32  Page  1
                                                             Sun Mar 31 2024

                                 1          TITLE   "mp4.a by Vinayak Deshpande"
                                 2  ;               Acknowledgements: Sai, Emily, Professor Jones
                                 3  ;               specifically, inspiration from mp3 by DWJones, as well as
                                 4  ;               the serpinski's triangle problem and pascal's triangle problem
                                 5  ;               from previous years.
                                 6          USE     "hawk.h"
                                 7          USE     "stdio.h"
                                 8          USE     "ascii.h"
                                 9  
                                10  TERMROWS        =       0
                                11  TERMCOLS        =       4
                                12  
                                13          INT     MAIN
                                14          S       MAIN
                                15  
                                16  ;activation record for TREEMAKER, recursive routine for tree making
                                17  ;RETAD          =       0
                                18  MAXHEIGHT       =       4       ; MAX TOTAL HEIGHT
                                19  COUNTER         =       8       ; COUNTER FOR HEIGHT
                                20  COUNTER2        =       12      ; COUNTER FOR Distance manipulation
                                21  WIDTH           =       16      ; The width just before recursion
                                22  HEIGHT          =       20      ; the branch height
                                23  ARSIZE          =       24
                                24  
                                25  TREEMAKER:
                                26          ; expects r3 = midpoint
                                27          ; expects r4 = max height
                                28          ; expects r5 = starting postion of node
                                29          ; expects r11= branch length of previous triangle
+00000000: F1  A2               30          STORES  R1,R2
+00000002: F8  F3               31          MOVE    R8,R3
+00000004: F9  F5               32          MOVE    R9,R5
+00000006: F9  22  0008         33          STORE   R9,R2,COUNTER   ; -- move to AR
+0000000A: FA  22  0004         34          STORE   R10,R2,MAXHEIGHT; -- move to AR
+0000000E: F2  62  0018         35          ADDI    R2,R2,ARSIZE    ; -- push AR
+00000012: FA  F4               36          MOVE    R10,R4          ; -- move max height to safe register
+00000014: DC  00               37          LIS     R12,0           ; -- reset counter to 0
+00000016: 9B  01               38          SR      R11,1           ; -- get new branch height
                                39  TREEGROWING:
+00000018: 20  CB               40          CMP     R12,R11         
+0000001A: 0D  19               41          BGE     TREECURSION     ; if(counter>=branchheight) break
SMAL32 (rev  8/19)              mp4.a by Vinayak Deshpande   17:32:32  Page  2
                                                             Sun Mar 31 2024

+0000001C: F3  F8               42          MOVE    R3,R8
+0000001E: 23  3C               43          SUB     R3,R3,R12       ; x = mid-counter
+00000020: F4  F9               44          MOVE    R4,R9           ; y = height from 0
+00000022: E1 +000000           45          LIL     R1,PUTAT
+00000026: F1  B1               46          JSRS    R1,R1
+00000028: D3  2F               47          LIS     R3,'/'
+0000002A: E1 +000000           48          LIL     R1,PUTCHAR
+0000002E: F1  B1               49          JSRS    R1,R1
+00000030: F3  F8               50          MOVE    R3,R8           ; x = mid
+00000032: 33  3C               51          ADD     R3,R3,R12       ; x = x+counter
+00000034: 13  C1               52          ADDSI   R3,1            ; x ++ to avoid collision
+00000036: F4  F9               53          MOVE    R4,R9
+00000038: E1 +000000           54          LIL     R1,PUTAT
+0000003C: F1  B1               55          JSRS    R1,R1
+0000003E: D3  5C               56          LIS     R3,'\'
+00000040: E1 +000000           57          LIL     R1,PUTCHAR
+00000044: F1  B1               58          JSRS    R1,R1
+00000046: 19  C1               59          ADDSI   R9,1            ; h++
+00000048: 1C  C1               60          ADDSI   R12,1           ; counter++
+0000004A: F0  30  FFCA         61          JUMP    TREEGROWING
                                62  TREECURSION:
+0000004E: F0  6B  0000         63          CMPI    R11,0           ; if(branch height == 0) break
+00000052: 02  1A               64          BEQ     TREEQUITTER     
                                65                                  ; --left side
+00000054: FC  22  000C         66          STORE   R12,R2,COUNTER2 ; save counter to AR
+00000058: FB  22  0014         67          STORE   R11,R2,HEIGHT   ; save branch height to AR
+0000005C: F4  FA               68          MOVE    R4,R10          ; begin setup for recursion
+0000005E: F5  F9               69          MOVE    R5,R9
+00000060: F3  F8               70          MOVE    R3,R8
+00000062: F8  22  0010         71          STORE   R8,R2,WIDTH     ; save x to AR
+00000066: 23  3C               72          SUB     R3,R3,R12       ; x-counter
+00000068: F1  30  FF94         73          JSR     R1,TREEMAKER    ; recurse
                                74  
                                75                                  ; --right side
+0000006C: FC  52  000C         76          LOAD    R12,R2,COUNTER2 ; load saved values from AR
+00000070: F9  52  0008         77          LOAD    R9,R2,COUNTER
+00000074: F8  52  0010         78          LOAD    R8,R2,WIDTH
+00000078: FB  52  0014         79          LOAD    R11,R2,HEIGHT
+0000007C: F4  FA               80          MOVE    R4,R10          ; begin setup for recursion
+0000007E: F5  F9               81          MOVE    R5,R9
+00000080: F3  F8               82          MOVE    R3,R8
SMAL32 (rev  8/19)              mp4.a by Vinayak Deshpande   17:32:32  Page  3
                                                             Sun Mar 31 2024

+00000082: 33  3C               83          ADD     R3,R3,R12       ; x+counter
+00000084: F1  30  FF78         84          JSR     R1,TREEMAKER    ; recurse
                                85  TREEQUITTER:
+00000088: F2  62  FFE8         86          ADDI    R2,R2,-ARSIZE
+0000008C: F0  D2               87          LOADS   PC,R2           ; return
                                88  
                                89  
                                90  ;activation record for MAIN
                                91  ;RETAD  =       0
                                92  ARSIZE  =       28
                                93  
                                94  MAIN:   ;uses TERMINFO to get
                                95          ; R3 = width
                                96          ; R4 = height
+0000008E: F1  A2               97          STORES  R1,R2
+00000090: F2  62  001C         98          ADDI    R2,R2,ARSIZE
+00000094: E1 +000000           99          LIL     R1,TERMINFO
+00000098: F3  51  0004        100          LOAD    R3,R1,TERMCOLS  ; -- param width
+0000009C: F4  51  0000        101          LOAD    R4,R1,TERMROWS  ; -- param height
+000000A0: D5  01              102          LIS     R5,1            ; -- maxheight counter
                               103  
                               104  WIDTHCALC:
+000000A2: 20  34              105          CMP     R3,R4           ;if(width > height) break
+000000A4: 0E  03              106          BGT     HEIGHTCALC
+000000A6: F6  F3              107          MOVE    R6,R3
+000000A8: 96  01              108          SR      R6,1
+000000AA: F4  F6              109          MOVE    R4,R6           ; height = width/2
                               110  HEIGHTCALC:                     ; -- to make sure maxheight is power of 2
+000000AC: 20  54              111          CMP     R5,R4           ; if(maxheight > height) break
+000000AE: 0E  03              112          BGT     FINISHSETUP
+000000B0: A5  01              113          SL      R5,1            ; maxheight*2
+000000B2: F0  30  FFF6        114          JUMP    HEIGHTCALC
                               115  FINISHSETUP:
+000000B6: 95  01              116          SR      R5,1
+000000B8: F4  F5              117          MOVE    R4,R5           ; height = maxheight
+000000BA: 93  01              118          SR      R3,1            ; get midpoint
+000000BC: D5  00              119          LIS     R5,0            ; setup counter
+000000BE: 13  CD              120          ADDSI   R3,-3           ; center the midpoint
+000000C0: FB  F4              121          MOVE    R11,R4          ; set up branch height
+000000C2: F1  30  FF3A        122          JSR     R1,TREEMAKER    ; call treemaker(width,height,counter,branchh)
                               123  
SMAL32 (rev  8/19)              mp4.a by Vinayak Deshpande   17:32:32  Page  4
                                                             Sun Mar 31 2024

+000000C6: F2  62  FFE4        124          ADDI    R2,R2,-ARSIZE
+000000CA: F0  D2              125          LOADS   PC,R2           ; return
                               126  
                               127          END
                    no errors
