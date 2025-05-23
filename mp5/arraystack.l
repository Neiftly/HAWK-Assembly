SMAL32 (rev  8/19)              arraystack.a by Douglas W.   09:36:22  Page  1
                                                             Mon Apr 15 2024

                                 1          TITLE   "arraystack.a by Douglas W. Jones -- array stack implementation"
                                 2  
                                 3          USE     "hawk.h"
                                 4          USE     "stdlib.h"
                                 5  
                                 6          USE     "stack.h"       ; the code here implements the stack interface
                                 7  
                                 8  ; configuration constants
                                 9  STACKSIZE=      10      ; stack size for this implementation, in words
                                10  
                                11  ; each stack object is a structure with 2 fields:
                                12  ; All instances of stack have the following fields:
                                13  ;EMPTY  =       0       ; pointer to the empty method, see stack.h
                                14  ;PUSH   =       4       ; pointer to the push method, see stack.h
                                15  ;POP    =       8       ; pointer to the pop method, see stack.h
                                16  
                                17  ; additional fields defined for arraystack objects
                                18  SP      =       12      ; the stack pointer, address of first free word
                                19  STACK   =       16      ; first word of an array of stacksize words
                                20  OBJSIZE =       STACK + (STACKSIZE << 2)
                                21  
                                22  ;==========
                                23          INT     NEWARRAYSTACK; construct a new stack object, see arraystack.h
                                24                          ; given   nothing
                                25                          ; returns R3 -- pointer to an initialized stack object
                                26                          ; wipes out R3-R7
                                27  ; AR for NEWARRAYSTACK
                                28  ;RETAD  =       0
                                29  ARSIZE  =       4
                                30  NEWARRAYSTACK:
+00000000: F1  A2               31          STORES  R1,R2
+00000002: 12  C4               32          ADDSI   R2,ARSIZE
                                33                                  ; -- first, allocate a new stack object
+00000004: D3  38               34          LIS     R3,OBJSIZE      ; -- parameter
+00000006: E1 +000000           35          LIL     R1,MALLOC
+0000000A: F1  B1               36          JSRS    R1,R1           ; retval = malloc( stacksize * 4 )
                                37  
                                38                                  ; -- second, initialize the new object
                                39                                  ; -- start with the method pointers
+0000000C: F4  70  0020         40          LEA     R4,ASEMPTY
+00000010: F4  23  0000         41          STORE   R4,R3,EMPTY     ; retval->empty = asempty -- the empty method
SMAL32 (rev  8/19)              arraystack.a by Douglas W.   09:36:22  Page  2
                                                             Mon Apr 15 2024

+00000014: F4  70  002A         42          LEA     R4,ASPUSH
+00000018: F4  23  0004         43          STORE   R4,R3,PUSH      ; retval->push = aspush -- the push method
+0000001C: F4  70  0030         44          LEA     R4,ASPOP
+00000020: F4  23  0008         45          STORE   R4,R3,POP       ; retval->pop = aspop -- the pop method
                                46  
                                47                                  ; -- finish by making this new stack empty
+00000024: F4  73  0010         48          LEA     R4,R3,STACK
+00000028: F4  23  000C         49          STORE   R4,R3,SP        ; retval->sp = &(retval->stack)
                                50  
+0000002C: 12  CC               51          ADDSI   R2,-ARSIZE
+0000002E: F0  D2               52          LOADS   PC,R2           ; return retval
                                53  
                                54  ;==========
                                55  ;               ASEMPTY ; test to see if a stack is empty
                                56  ASEMPTY:                ; given   R3 -- s, a stack to test
                                57                          ; returns R3 -- zero if not empty, nonzero if empty
                                58                          ; may use R4-R7
+00000030: F4  73  0010         59          LEA     R4,R3,STACK     ; -- &(s->stack)
+00000034: F5  53  000C         60          LOAD    R5,R3,SP        ; -- s->sp
+00000038: 23  45               61          SUB     R3,R4,R5        ; temp = &(s->stack) - s->sp
                                62                                  ; -- here, temp = 0 if empty, we want opposite
+0000003A: 02  01               63          BZS     ASEZERO
+0000003C: D3  FF               64          LIS     R3,-1           ; -- tricky code: if it was nonzero, make it -1
                                65  ASEZERO:
+0000003E: 13  90               66          NOT     R3              ; retval = (temp == 0)
                                67  
+00000040: F0  B1               68          JUMPS   R1              ; return retval
                                69          
                                70  ;==========
                                71  ;               ASPUSH  ; push a word on the stack
                                72                          ; given   R3 -- s, stack to push on
                                73                          ;         R4 -- word to push
                                74                          ; returns nothing
                                75                          ; wipes out R3-R6
                                76  ASPUSH:
+00000042: F5  73  000C         77          LEA     R5,R3,SP        ; -- address of stack->mysp
+00000046: F6  D5               78          LOADS   R6,R5           ; -- value of stack->mysp
+00000048: F4  A6               79          STORES  R4,R6           ; *(s->mysp) = word to push
+0000004A: 16  C4               80          ADDSI   R6,4            ; s->mysp ++
+0000004C: F6  A5               81          STORES  R6,R5           ; -- put s->mysp back
                                82  
SMAL32 (rev  8/19)              arraystack.a by Douglas W.   09:36:22  Page  3
                                                             Mon Apr 15 2024

+0000004E: F0  B1               83          JUMPS   R1              ; return
                                84  
                                85  ;==========
                                86  ;               ASPOP   ; pop a word from the stack
                                87                          ; given   R3 -- s, stack to push on
                                88                          ; returns R3 -- a word popped from the stack
                                89                          ; wipes out R4-R6
                                90  ASPOP:
+00000050: F5  73  000C         91          LEA     R5,R3,SP        ; -- address of stack->mysp
+00000054: F6  D5               92          LOADS   R6,R5           ; -- value of stack->mysp
+00000056: 16  CC               93          ADDSI   R6,-4           ; s->mysp --
+00000058: F3  D6               94          LOADS   R3,R6           ; retval = *(s->mysp)
+0000005A: F6  A5               95          STORES  R6,R5           ; -- put s->mysp back
                                96  
+0000005C: F0  B1               97          JUMPS   R1              ; return retval
                                98  
                                99          END
                    no errors
