SMAL32 (rev  8/19)              main.a by Douglas Jones --   09:36:22  Page  1
                                                             Mon Apr 15 2024

                                 1          TITLE   "main.a by Douglas Jones -- exerciser for array and list stacks"
                                 2          ; A recursion-free solution to MP4 using several stacks.
                                 3          ; The stacks hold trees that have yet to be plotted on the screen.
                                 4  
                                 5          ; NOTE:  There is no recursion here, it's all done with loops and stacks
                                 6  
                                 7          USE     "hawk.h"
                                 8          USE     "stdio.h"
                                 9          USE     "stack.h"
                                10          USE     "arraystack.h"
                                11          USE     "liststack.h"
                                12  
                                13          INT     MAIN
                                14          S       MAIN
                                15  
                                16  ; activation record for MAIN
                                17  ;RETAD  =       0
                                18  ARSIZE  =       4
                                19  
                                20  MAIN:
+00000000: F1  A2               21          STORES  R1,R2
+00000002: 12  C4               22          ADDSI   R2,ARSIZE
                                23  
                                24                                          ; ==============
                                25                                          ; -- A, make some stacks
+00000004: E1 +000000           26          LIL     R1,NEWARRAYSTACK
+00000008: F1  B1               27          JSRS    R1,R1                   ; -- stack for sizes of trees
+0000000A: FD  F3               28          MOVE    R13,R3                  ; sizestack = newarraystack()
+0000000C: E1 +000000           29          LIL     R1,NEWLISTSTACK
+00000010: F1  B1               30          JSRS    R1,R1                   ; -- stack for x coordinates
+00000012: FE  F3               31          MOVE    R14,R3                  ; xstack = newliststack()
+00000014: E1 +000000           32          LIL     R1,NEWLISTSTACK
+00000018: F1  B1               33          JSRS    R1,R1                   ; -- stack for y coordinates
+0000001A: FF  F3               34          MOVE    R15,R3                  ; ystack = newliststack()
                                35          ; here  R13 = sizestack
                                36          ;       R14 = xstack
                                37          ;       R14 = ystack            ; -- these stacks describe pending trees
                                38          
                                39                                          ; ==============
                                40                                          ; -- B, get tree size from screen size
+0000001C: E3 +000000           41          LIL     R3,TERMINFO
SMAL32 (rev  8/19)              main.a by Douglas Jones --   09:36:22  Page  2
                                                             Mon Apr 15 2024

+00000020: F4  53  0004         42          LOAD    R4,R3,TERMCOLS          ; -- get termcols
+00000024: F5  53  0000         43          LOAD    R5,R3,TERMROWS          ; -- get termrows
                                44  
                                45                                          ; -- problem 1, what size fits?
+00000028: D3  01               46          LIS     R3,1                    ; size = 1
                                47          ; here  R3 = size               ; -- size is always a power of 2
                                48          ;       R4 = termcols
                                49          ;       R5 = termrows
                                50          ;       R6 = height then width
                                51          ;       R13,14,15 = stacks for size,x,y
                                52  SIZELP:                                 ; for (;;) {
+0000002A: B6  31               53          MOVESL  R6,R3,1
+0000002C: 16  CF               54          ADDSI   R6,-1                   ;   height = 2*size - 1
+0000002E: 20  56               55          CMP     R5,R6
+00000030: 05  05               56          BLT     SIZEQT                  ;   if (termrows < height) break
+00000032: A6  01               57          SL      R6,1                    ;   width = 2*height
+00000034: 20  46               58          CMP     R4,R6
+00000036: 05  02               59          BLT     SIZEQT                  ;   if (termcols < width) break
+00000038: A3  01               60          SL      R3,1                    ;   size = size * 2
+0000003A: 00  F7               61          BR      SIZELP
                                62  SIZEQT:                                 ; }
                                63          
                                64                                          ; -- we computed one size too large
+0000003C: 83  01               65          SRU     R3,1                    ; -- parameter size = size/2
+0000003E: 94  01               66          SR      R4,1                    ; -- parameter x = termcols/2
+00000040: 95  01               67          SR      R5,1                    ; -- parameter y = termrows/2 - size + 1
                                68  
                                69                                          ; ==============
                                70                                          ; -- C, schedule first tree to print
                                71          ; here  R3 = size               ; -- size of the tree
                                72          ;       R4 = termcols           ; -- x location of tree center
                                73          ;       R5 = termrows           ; -- y location of gree center
                                74          ;       R13,14,15 = stacks for size,x,y
                                75  
+00000042: F8  F4               76          MOVE    R8,R4
+00000044: F9  F5               77          MOVE    R9,R5                   ; -- move x and y temporarily
+00000046: F4  F3               78          MOVE    R4,R3                   ; -- parameter size
+00000048: F3  FD               79          MOVE    R3,R13                  ; -- parameter sizestack
+0000004A: F1  53  0004         80          LOAD    R1,R3,PUSH
+0000004E: F1  B1               81          JSRS    R1,R1                   ; sizestack->push( sizestack, size )
+00000050: F4  F8               82          MOVE    R4,R8                   ; -- parameter x
SMAL32 (rev  8/19)              main.a by Douglas Jones --   09:36:22  Page  3
                                                             Mon Apr 15 2024

+00000052: F3  FE               83          MOVE    R3,R14                  ; -- parameter xstack
+00000054: F1  53  0004         84          LOAD    R1,R3,PUSH
+00000058: F1  B1               85          JSRS    R1,R1                   ; xstack->push( xstack, x )
+0000005A: F4  F9               86          MOVE    R4,R9                   ; -- parameter y
+0000005C: F3  FF               87          MOVE    R3,R15                  ; -- parameter ystack
+0000005E: F1  53  0004         88          LOAD    R1,R3,PUSH
+00000062: F1  B1               89          JSRS    R1,R1                   ; ystack->push( ystack, x )
                                90  
                                91                                          ; ==============
                                92                                          ; -- D, plot trees till stack is empty
                                93  PLOTLOOP:                               ; for (;;) {
                                94          ; here  R13 = sizestack
                                95          ;       R14 = xstack
                                96          ;       R15 = ystack
+00000064: F3  FD               97          MOVE    R3,R13                  ;   -- parameter sizestack
+00000066: F1  53  0000         98          LOAD    R1,R3,EMPTY
+0000006A: F1  B1               99          JSRS    R1,R1
+0000006C: F0  E3              100          TESTR   R3
+0000006E: 0A  5C              101          BZR     PLOTQUIT                ;   if (sizestack->empty(sizestack)) brk
                               102  
+00000070: F3  FE              103          MOVE    R3,R14                  ;   -- parameter xstack
+00000072: F1  53  0000        104          LOAD    R1,R3,EMPTY
+00000076: F1  B1              105          JSRS    R1,R1
+00000078: F0  E3              106          TESTR   R3
+0000007A: 0A  56              107          BZR     PLOTQUIT                ;   if (xstack->empty( xstack )) break
                               108  
+0000007C: F3  FF              109          MOVE    R3,R15                  ;   -- parameter ystack
+0000007E: F1  53  0000        110          LOAD    R1,R3,EMPTY
+00000082: F1  B1              111          JSRS    R1,R1
+00000084: F0  E3              112          TESTR   R3
+00000086: 0A  50              113          BZR     PLOTQUIT                ;   if (ystack->empty( ystack )) break
                               114  
                               115                                          ;   -- if any stack was empty we quit
+00000088: F3  FD              116          MOVE    R3,R13                  ;   -- parameter sizestack
+0000008A: F1  53  0008        117          LOAD    R1,R3,POP
+0000008E: F1  B1              118          JSRS    R1,R1                   ; 
+00000090: F8  F3              119          MOVE    R8,R3                   ;   size = sizestack->pop( sizestack )
+00000092: F3  FE              120          MOVE    R3,R14                  ;   -- parameter xstack
+00000094: F1  53  0008        121          LOAD    R1,R3,POP
+00000098: F1  B1              122          JSRS    R1,R1
+0000009A: F9  F3              123          MOVE    R9,R3                   ;   x = sizestack->pop( xstack )
SMAL32 (rev  8/19)              main.a by Douglas Jones --   09:36:22  Page  4
                                                             Mon Apr 15 2024

+0000009C: F3  FF              124          MOVE    R3,R15                  ;   -- parameter ystack
+0000009E: F1  53  0008        125          LOAD    R1,R3,POP
+000000A2: F1  B1              126          JSRS    R1,R1
+000000A4: FA  F3              127          MOVE    R10,R3                  ;   y = sizestack->pop( ystack )
                               128          ; here  R8 = size
                               129          ;       R9 = x
                               130          ;       R10 = y                 ;   -- characteristics of one tree
                               131          ;       R13,14,15 = stacks for size,x,y
                               132  
+000000A6: F0  E8              133          TESTR   R8
+000000A8: 02  DD              134          BZS     NOTREE                  ;   if (size >= 1) {
                               135  
                               136                                          ;     -- push left subtree attributes
+000000AA: F3  FD              137          MOVE    R3,R13                  ;     -- parameter sizestack
+000000AC: F4  F8              138          MOVE    R4,R8                   ;
+000000AE: 94  01              139          SR      R4,1                    ;     -- parameter size/2
+000000B0: F1  53  0004        140          LOAD    R1,R3,PUSH
+000000B4: F1  B1              141          JSRS    R1,R1                   ;     sizestack->push( sizestack, size/2 )
                               142  
+000000B6: F3  FE              143          MOVE    R3,R14                  ;     -- parameter xstack
+000000B8: F4  F9              144          MOVE    R4,R9
+000000BA: 24  48              145          SUB     R4,R4,R8                ;     -- parameter x - size
+000000BC: F1  53  0004        146          LOAD    R1,R3,PUSH
+000000C0: F1  B1              147          JSRS    R1,R1                   ;     xstack->push( xstack, x - size )
                               148  
+000000C2: F3  FF              149          MOVE    R3,R15                  ;     -- parameter ystack
+000000C4: F4  F8              150          MOVE    R4,R8
+000000C6: 94  01              151          SR      R4,1
+000000C8: 34  A4              152          ADD     R4,R10,R4               ;     -- parameter y + size/2
+000000CA: F1  53  0004        153          LOAD    R1,R3,PUSH
+000000CE: F1  B1              154          JSRS    R1,R1                   ;     ystack->push( ystack, y + size/2 )
                               155  
                               156                                          ;     -- push right subtree attributes
+000000D0: F3  FD              157          MOVE    R3,R13                  ;     -- parameter sizestack
+000000D2: F4  F8              158          MOVE    R4,R8                   ;
+000000D4: 94  01              159          SR      R4,1                    ;     -- parameter size/2
+000000D6: F1  53  0004        160          LOAD    R1,R3,PUSH
+000000DA: F1  B1              161          JSRS    R1,R1                   ;     sizestack->push(sizestack,size/2)
                               162  
+000000DC: F3  FE              163          MOVE    R3,R14                  ;     -- parameter xstack
+000000DE: F4  F9              164          MOVE    R4,R9
SMAL32 (rev  8/19)              main.a by Douglas Jones --   09:36:22  Page  5
                                                             Mon Apr 15 2024

+000000E0: 34  48              165          ADD     R4,R4,R8                ;     -- parameter x + size
+000000E2: F1  53  0004        166          LOAD    R1,R3,PUSH
+000000E6: F1  B1              167          JSRS    R1,R1                   ;     xstack->push( xstack, x + size )
                               168  
+000000E8: F3  FF              169          MOVE    R3,R15                  ;     -- parameter ystack
+000000EA: F4  F8              170          MOVE    R4,R8
+000000EC: 94  01              171          SR      R4,1
+000000EE: 34  A4              172          ADD     R4,R10,R4               ;     -- parameter y + size/2
+000000F0: F1  53  0004        173          LOAD    R1,R3,PUSH
+000000F4: F1  B1              174          JSRS    R1,R1                   ;     ystack->push( ystack, y + size/2 )
                               175  
                               176  PLOTBRANCH:                             ;     do { -- output size rows of /\
                               177          ; here  R8 = size
                               178          ;       R9 = x
                               179          ;       R10 = y                 ;       -- characteristics of one tree
                               180          ;       R13,14,15 = stacks for size,x,y
+000000F6: F3  F9              181          MOVE    R3,R9
+000000F8: 23  38              182          SUB     R3,R3,R8                ;       -- parameter x - size
+000000FA: F4  FA              183          MOVE    R4,R10                  ;       -- parameter y
+000000FC: E1 +000000          184          LIL     R1,PUTAT
+00000100: F1  B1              185          JSRS    R1,R1                   ;       putat( x - size, y )
+00000102: D3  2F              186          LIS     R3,'/'                  ;       -- parameter
+00000104: E1 +000000          187          LIL     R1,PUTCHAR
+00000108: F1  B1              188          JSRS    R1,R1                   ;       putchar( '/' )
                               189  
+0000010A: F3  F9              190          MOVE    R3,R9
+0000010C: 33  38              191          ADD     R3,R3,R8
+0000010E: 13  CF              192          ADDSI   R3,-1                   ;       -- parameter x + size - 1
+00000110: F4  FA              193          MOVE    R4,R10                  ;       -- parameter y
+00000112: E1 +000000          194          LIL     R1,PUTAT
+00000116: F1  B1              195          JSRS    R1,R1                   ;       putat( x + size - 1, y - 1 )
+00000118: D3  5C              196          LIS     R3,'\'                  ;       -- parameter
+0000011A: E1 +000000          197          LIL     R1,PUTCHAR
+0000011E: F1  B1              198          JSRS    R1,R1                   ;       putchar( '\' )
                               199  
+00000120: 1A  CF              200          ADDSI   R10,-1                  ;       y = y - 1   -- move up
+00000122: 18  CF              201          ADDSI   R8,-1                   ;       size = size - 1
+00000124: 0E  E8              202          BGT     PLOTBRANCH              ;     } while (size > 0)
                               203  NOTREE  =       PLOTLOOP                ;   }
+00000126: 00  9E              204          BR      PLOTLOOP                ; }
                               205  PLOTQUIT:                               ; -- assert, some stack was empty
SMAL32 (rev  8/19)              main.a by Douglas Jones --   09:36:22  Page  6
                                                             Mon Apr 15 2024

                               206  
                               207                                          ; ==============
                               208                                          ; -- E, test that all stacks are empty
+00000128: F3  FD              209          MOVE    R3,R13                  ; -- parameter sizestack
+0000012A: F1  53  0000        210          LOAD    R1,R3,EMPTY
+0000012E: F1  B1              211          JSRS    R1,R1
+00000130: F0  E3              212          TESTR   R3
+00000132: 02  0C              213          BZS     PLOTBUG                 ; if (!sizestack->empty(sizestack)
                               214  
+00000134: F3  FE              215          MOVE    R3,R14                  ; -- parameter xstack
+00000136: F1  53  0000        216          LOAD    R1,R3,EMPTY
+0000013A: F1  B1              217          JSRS    R1,R1
+0000013C: F0  E3              218          TESTR   R3
+0000013E: 02  06              219          BZS     PLOTBUG                 ; ||  !xstack->empty(xstack)
                               220  
+00000140: F3  FF              221          MOVE    R3,R15                  ; -- parameter ystack
+00000142: F1  53  0000        222          LOAD    R1,R3,EMPTY
+00000146: F1  B1              223          JSRS    R1,R1
+00000148: F0  E3              224          TESTR   R3
+0000014A: 0A  05              225          BZR     PLOTOK                  ; || (ystack->empty(xstack)) {
                               226  PLOTBUG:
+0000014C: F3  70  000A        227          LEA     R3,STACKBUG
+00000150: E1 +000000          228          LIL     R1,PUTS
+00000154: F1  B1              229          JSRS    R1,R1                   ;    puts( "stacks not all empty" )
                               230  PLOTOK:                                 ; }
                               231          
+00000156: 12  CC              232          ADDSI   R2,-ARSIZE
+00000158: F0  D2              233          LOADS   PC,R2                   ; return
                               234  
                               235  STACKBUG:
+0000015A: 73  74  61  63      236          ASCII   "stacks not all empty",0
+0000015E: 6B  73  20  6E 
+00000162: 6F  74  20  61 
+00000166: 6C  6C  20  65 
+0000016A: 6D  70  74  79 
+0000016E: 00 
                               237          
                               238          END
                    no errors
