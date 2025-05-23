SMAL32 (rev  8/19)              mp2.a by Vinayak Deshpande   15:31:32  Page  1
                                                             Thu Feb 29 2024

                                 1          TITLE "mp2.a by Vinayak Deshpande"
                                 2  
                                 3          USE     "hawk.h"
                                 4          USE     "stdio.h"
                                 5          
                                 6          EXT     MP2DATA
                                 7          INT     MAIN
                                 8          S       MAIN
                                 9  
                                10  MAIN:
+00000000: F1  A2               11          STORES  R1,R2
+00000002: 12  C4               12          ADDSI   R2,4
+00000004: E8  000000           13          LIL     R8,0
+00000008: E9 +000000           14          LIL     R9,MP2DATA
                                15  
                                16  LOOP:
+0000000C: 39  89               17          ADD     R9,R8,R9
+0000000E: F7  D9               18          LOADS   R7,R9
                                19          
+00000010: F0  67  0000         20          CMPI    R7,0
+00000014: 02  05               21          BEQ     STOP
                                22  
+00000016: E1 +000000           23          LIL     R1,PUTSTR
+0000001A: F1  B1               24          JSRS    R1,R1
                                25  
+0000001C: 18  C4               26          ADDSI   R8,4
+0000001E: 00  F6               27          BR      LOOP
                                28  
                                29  STOP:
+00000020: 12  CC               30          ADDSI   R2, -4
+00000022: F0  D2               31          LOADS   PC,R2
                                32  
                                33          END
                    no errors
