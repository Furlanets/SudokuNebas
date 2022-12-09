TITLE Lucca/22003004        Fernando/
.MODEL SMALL

PULO  MACRO 
    mov ah,02
    mov dl,10
    int 21H
ENDM

PUSHR  MACRO 
    push si
    push dx
    push cx
    push bx
    push ax   
ENDM 

POPR  MACRO 
    pop si
    pop dx
    pop cx
    pop bx
    pop ax 
ENDM

apagatela MACRO
    MOV AH,0h
    MOV AL,3h
    INT 10H
    ;XOR AX,AX
    MOV AH,09
    MOV AL,20H
    MOV BH,00
    MOV BL,3FH
    MOV CX,800H
    INT 10H
ENDM

LIMPAR MACRO
    XOR AX,AX
    XOR BX,BX
    XOR CX,CX
    XOR DX,DX
    XOR SI,SI
ENDM

PRINTM MACRO print
    MOV AH,09
    LEA DX,print
    INT 21H
ENDM

space MACRO 
    MOV AH, 02
    MOV DL, 32
    INT 21H    
ENDM

.DATA

    ;home DB 

    LINHA DW 9
    COLUNA DW 9
    
    
    MATRIZ1  DB 38H,?,36H,?,?,33H,?,39H,?   ;matriz
             DB ?,34H,?,31H,?,?,?,36H,38H
             DB 32H,?,?,38H,37H,?,?,?,35H
             DB 31H,?,38H,?,?,35H,?,32H,?
             DB ?,33H,?,31H,?,?,?,35H,?
             DB 37H,?,35H,?,33H,?,39H,?,?
             DB ?,32H,31H,?,?,37H,?,34H,?
             DB 36H,?,?,?,32H,?,38H,?,?
             DB ?,38H,37H,36H,?,34H,?,?,33H

    MATRIZ1R DB 8,7,6,5,4,3,1,9,2   ;matriz
             DB 5,4,3,2,1,9,7,6,8
             DB 2,1,9,8,7,6,4,3,5
             DB 1,9,8,1,6,5,3,2,4
             DB 4,3,2,4,9,8,6,5,7
             DB 7,6,5,4,3,2,9,8,1
             DB 3,2,1,9,8,7,5,4,6
             DB 6,5,4,3,2,1,8,7,9
             DB 9,8,7,6,5,4,2,1,3
    
    MATRIZ2  DB ?,?,?,?,?,?,?,?,?   ;matriz
             DB ?,?,?,?,?,?,?,?,?
             DB ?,?,?,?,?,?,?,?,?
             DB ?,?,?,?,?,?,?,?,?
             DB ?,?,?,?,?,?,?,?,?
             DB ?,?,?,?,?,?,?,?,?
             DB ?,?,?,?,?,?,?,?,?
             DB ?,?,?,?,?,?,?,?,?
             DB ?,?,?,?,?,?,?,?,?

    MATRIZ2R DB ?,?,?,?,?,?,?,?,?   ;matriz
             DB ?,?,?,?,?,?,?,?,?
             DB ?,?,?,?,?,?,?,?,?
             DB ?,?,?,?,?,?,?,?,?
             DB ?,?,?,?,?,?,?,?,?
             DB ?,?,?,?,?,?,?,?,?
             DB ?,?,?,?,?,?,?,?,?
             DB ?,?,?,?,?,?,?,?,?
             DB ?,?,?,?,?,?,?,?,?

    msgx DB "<Fase 1>",10,'$'                                         ;idem
    msgy DB "<Fase 2>",10,'$'
    msg1 DB "Insira a linha:",10,'$'
    msg2 DB "Insira a coluna:",10,'$'
    msg3 DB "Insira o valor:",10,'$'
    msg4 DB "Voce digitou o valor INCORRETO!",10,'$'
    msg5 DB "Voce digitou o valor CORRETO!",10,'$'

.CODE

main PROC
    MOV AX,@DATA        ;inicialização das matrizes
    MOV DS,AX
    MOV DX,OFFSET msgx      ;dx é carregado com o offset de MSGX e realiza o print
    MOV AH,09H              
    INT 21H

    MOV DX,OFFSET msgy      ;dx é carregado com o offset de MSGA e realiza o print
    MOV AH,09H
    INT 21H

    MOV AH,01H              ;realiza a entrada de um caractere pelo teclado
    INT 21H
    SUB AL,30H              ;realiza subtração para transformar caractere em número

    CMP AL,1                ;realiza uma comparação, se o conteúdo em AL=1, realiza um Jump Equal(JE) para a "SOMA"
    CALL FASE1

    ;CMP AL,2                ;realiza uma comparação, se o conteúdo em AL=2, realiza um Jump Equal(JE) para a "SUBT"
    ;JE PENIS2

    ;MOV AH,09
    ;LEA DX,msg1
    ;INT 21h
    ;CALL RECEBA         ;entrada de dados na matriz
    ;MOV AH,09
    ;LEA DX,msg2         
    ;INT 21h
    ;CALL PRINT          ;impressão da matriz           
    ;MOV ah,4Ch
    ;INT 21h
main ENDP

FASE1 PROC

    COMECO:

    LEA BX, MATRIZ1
    
    CALL PRINT
    
    PRINTM msg1

    MOV AH,01H
    INT 21H
    SUB AL,30H

    MOV CX,9
    MUL CX
    XOR AH,AH

    MOV BX,AX
    SUB BX,9

    PRINTM msg2

    MOV AH,01H
    INT 21H
    SUB AL,31H

    XOR AH,AH
    MOV SI,AX

    PRINTM msg3

    MOV AH,01H
    INT 21H

    SUB AL,30H

    CALL VERIFICA
    JMP COMECO

    RET

FASE1 ENDP

VERIFICA PROC

CMP AL,MATRIZ1R[BX][SI]

    JE CORRETO
    
    PRINTM msg4     ;VALOR INCORRETO

    MOV AH,01
    INT 21H
    JMP SAIDA
    XOR AX,AX
    
    CORRETO:
    
    PUSH AX

    PRINTM msg5      ;VALOR CORRETO
    
    POP AX
    ADD AL,30H

    MOV MATRIZ1[BX][SI],AL

    MOV AH,01
    INT 21H

    SAIDA:
    
    LIMPAR

    ;CALL TERMINA_FACIL
    ;CMP DL,1

    RET

VERIFICA ENDP

PRINT PROC
        PULO
        PUSHR

        MOV AH,02
        MOV CX,LINHA
        MOV DX,30H 


       EXTERNO:
            MOV DI,COLUNA
            XOR SI,SI

        INTERNO:

            FORA:

            CMP BX,0
            JNE FORA2
            MOV DL,30H
            INC DH
            ADD DL,DH
            INT 21H

            FORA2:

            MOV DL, [BX][SI]
            INT 21H
            INC SI
            DEC DI

            MOV DL,32
            INT 21H

            JNZ INTERNO

            PULO

            ADD BX,COLUNA

            LOOP EXTERNO
            POPR


    RET
    PRINT ENDP

    

end main