SMAL32 (rev  8/19)              liststack.a by Vinayak Des   15:26:12  Page  1
                                                             Thu Apr 25 2024

                                 1          TITLE   "liststack.a by Vinayak Deshpande -- list stack implementation"
                                 2                  ; thanks to emily and sai for help explaining concepts
                                 3                  ; acknowledgement to Professor Jones for ARRAYSTACK code as
                                 4                  ; starting point for liststack
                                 5                  ; also thanks to Geeks4Geeks for help explaining data struct
                                 6          USE     "hawk.h"
                                 7          USE     "stdlib.h"
                                 8          USE     "exceptions.h"
                                 9  
                                10          USE     "stack.h"
                                11  
                                12  ;These methods are defined in stack.h
                                13  ;EMPTY  =       0       ; pointer to empty method
                                14  ;PUSH   =       4       ; pointer to push method
                                15  ;POP    =       8       ; pointer to pop method
                                16  
                                17  ; additional fields for list stack objects
                                18  TOPNODE =       12      ; location of address of top most node
                                19  INITSIZE=       16      ; size of the header object
                                20  
                                21  ;=========
                                22          INT     NEWLISTSTACK    ; construct a new stack object,see liststack.h
                                23                                  ; given nothing
                                24                                  ; returns R3 -- pointer to the header object
                                25                                  ; wipes out R3-R7
                                26  ; AR for NEWLISTSTACK
                                27  ;RETAD  =       0
                                28  ARSIZE  =       4
                                29  NEWLISTSTACK:
                                30          ; Constructor for LISTSTACK
+00000000: F1  A2               31          STORES  R1,R2
+00000002: 12  C4               32          ADDSI   R2,ARSIZE
                                33  
+00000004: D3  10               34          LIS     R3,INITSIZE     ; -- allocate space for header object
+00000006: E1 +000000           35          LIL     R1,MALLOC       ; -- 4 fields = 4*4 bytes = 16
+0000000A: F1  B1               36          JSRS    R1,R1           ; address = malloc( INITSIZE)
                                37  
                                38                                  ; -- initialize method pointers
+0000000C: F4  70  001E         39          LEA     R4,LSEMPTY
+00000010: F4  23  0000         40          STORE   R4,R3,EMPTY     ; -- EMPTY method at pos 0
+00000014: F4  70  0026         41          LEA     R4,LSPUSH
SMAL32 (rev  8/19)              liststack.a by Vinayak Des   15:26:12  Page  2
                                                             Thu Apr 25 2024

+00000018: F4  23  0004         42          STORE   R4,R3,PUSH      ; -- PUSH method at pos 4
+0000001C: F4  70  005A         43          LEA     R4,LSPOP
+00000020: F4  23  0008         44          STORE   R4,R3,POP       ; -- POP method at pos 8
+00000024: D4  00               45          LIS     R4,0            ; -- address should point to null value
+00000026: F4  23  000C         46          STORE   R4,R3,TOPNODE   ; -- TOPNODE field at pos 12
                                47  
+0000002A: 12  CC               48          ADDSI   R2,-ARSIZE      ; return address
+0000002C: F0  D2               49          LOADS   PC,R2
                                50  ;========
                                51  ; no AR for LSEMPTY
                                52  LSEMPTY:
                                53          ; test to see if given stack is empty
                                54          ; given R3 -- stack to test
                                55          ; returns R3 -- 0 if not empty, non-zero if empty
                                56          ; wipes R4-R7
+0000002E: F3  53  000C         57          LOAD    R3,R3,TOPNODE   ; temp = TOPNODE
+00000032: F0  63  0000         58          CMPI    R3,0            ; if(temp == 0)
+00000036: 02  01               59          BEQ     LSEZERO         ; jump to LSEZERO
+00000038: D3  FF               60          LIS     R3,-1           ; else{temp = -1)
                                61  LSEZERO:
+0000003A: 13  90               62          NOT     R3              ; retval = (temp == 0)
+0000003C: F0  B1               63          JUMPS   R1              ; return retval
                                64  ;========
                                65  ;AR for LSPUSH
                                66  ;RETAD  =       0
                                67  NODEVAL =       0       ; pointer to the value saved in the node
                                68  PRENODE =       4       ; pointer to the address of the previous node
                                69  R3SAVE  =       4       ; place to save value in R3 to the AR
                                70  R4SAVE  =       8       ; place to save value in R4 to the AR
                                71  ARSIZE  =       12
                                72  NODESIZE=       8       ; size of the node in bytes
                                73  LSPUSH:
                                74          ; push a word on the stack
                                75          ; given R3 -- stack to push on
                                76          ;       R4 -- value to push
                                77          ; returns nothing
                                78          ; wipes out R3-R7
+0000003E: F1  A2               79          STORES  R1,R2
+00000040: F2  62  000C         80          ADDI    R2,R2,ARSIZE
+00000044: F3  22  0004         81          STORE   R3,R2,R3SAVE    ; -- save R3 value to AR
+00000048: F4  22  0008         82          STORE   R4,R2,R4SAVE    ; -- save R4 value to AR
SMAL32 (rev  8/19)              liststack.a by Vinayak Des   15:26:12  Page  3
                                                             Thu Apr 25 2024

                                83  
+0000004C: D3  08               84          LIS     R3,NODESIZE     ; nodesize = 2 fields * 4 bytes
+0000004E: E1 +000000           85          LIL     R1,MALLOC       ; newnode = malloc(nodesize)
+00000052: F1  B1               86          JSRS    R1,R1
+00000054: F0  63  0000         87          CMPI    R3,0
+00000058: 02  29               88          BEQ     THROW
+0000005A: F6  F3               89          MOVE    R6,R3           ; temp1 = newnode
+0000005C: F3  52  0004         90          LOAD    R3,R2,R3SAVE    ; this.s = s -- retrieve given R3 from AR
+00000060: F4  52  0008         91          LOAD    R4,R2,R4SAVE    ; this.val = val -- retrieve given R4 from AR
+00000064: F5  53  000C         92          LOAD    R5,R3,TOPNODE   ; temp2 = s.topnode
+00000068: F6  23  000C         93          STORE   R6,R3,TOPNODE   ; s.topnode = temp1
+0000006C: F4  26  0000         94          STORE   R4,R6,NODEVAL   ; temp1.val = value
+00000070: F5  26  0004         95          STORE   R5,R6,PRENODE   ; temp1.previousnode = temp2
                                96  
+00000074: F2  62  FFF4         97          ADDI    R2,R2,-ARSIZE
+00000078: F0  D2               98          LOADS   PC,R2           ; return
                                99  ;========
                               100  
                               101  ;AR for LSPOP
                               102  ;RETAD  =       0
                               103  RETVAL  =       4       ; place to save value in AR
                               104  ARSIZE  =       8
                               105  LSPOP:
                               106          ; pop a word from the stack
                               107          ; given R3 -- stack to pop from
                               108          ; returns R3 -- value popped
                               109          ; wipes out R4-R7
+0000007A: F1  A2              110          STORES  R1,R2
+0000007C: F2  62  0008        111          ADDI    R2,R2,ARSIZE
                               112  
+00000080: F6  53  000C        113          LOAD    R6,R3,TOPNODE   ; node = s.TOPNODE
+00000084: F0  66  0000        114          CMPI    R6,0
+00000088: 02  11              115          BEQ     THROW
+0000008A: F5  56  0004        116          LOAD    R5,R6,PRENODE   ; temp1 = node.previousnode
+0000008E: F5  23  000C        117          STORE   R5,R3,TOPNODE   ; s.TOPNODE = temp1
+00000092: F4  56  0000        118          LOAD    R4,R6,NODEVAL   ; temp2 = node.val
+00000096: F4  22  0004        119          STORE   R4,R2,RETVAL    ; -- save temp2 in AR
+0000009A: F3  F6              120          MOVE    R3,R6           ; -- temp3 = node
+0000009C: E1 +000000          121          LIL     R1,FREE         ; free(temp3)
+000000A0: F1  B1              122          JSRS    R1,R1
+000000A2: F3  52  0004        123          LOAD    R3,R2,RETVAL    ; retval = val -- retrieve val from AR
SMAL32 (rev  8/19)              liststack.a by Vinayak Des   15:26:12  Page  4
                                                             Thu Apr 25 2024

                               124  
+000000A6: F2  62  FFF8        125          ADDI    R2,R2,-ARSIZE   ;return retval
+000000AA: F0  D2              126          LOADS   PC,R2
                               127  
                               128  THROW:
+000000AC: E3  000000          129          LIL     R3,STACKEXCEPT
undefined symbol                                       ===========
+000000B0: F1  D3              130          LOADS   R1,R3
+000000B2: F2  51  0008        131          LOAD    R2,R1,EXOLD
+000000B6: F2  A3              132          STORES  R2,R3
+000000B8: F2  51  0004        133          LOAD    R2,R1,EXAR
+000000BC: F0  D1              134          LOADS   PC,R1
                               135  
                               136          END
     1 error in this assembly
