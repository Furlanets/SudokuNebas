TITLE Nome:Jean Pyton RA:22013310
.MODEL SMALL
.DATA
    linha DB 9
    coluna DB 9
    offsetlinha DW 18
    
    MATRIZ  DW ?,?,?,?,?,?,?,?,?   ;matriz
            DW ?,?,?,?,?,?,?,?,?
            DW ?,?,?,?,?,?,?,?,?
            DW ?,?,?,?,?,?,?,?,?
            DW ?,?,?,?,?,?,?,?,?
            DW ?,?,?,?,?,?,?,?,?
            DW ?,?,?,?,?,?,?,?,?
            DW ?,?,?,?,?,?,?,?,?
            DW ?,?,?,?,?,?,?,?,?

    MATRIZ2 DW ?,?,?,?,?,?,?,?,?   ;matriz auxiliar
            DW ?,?,?,?,?,?,?,?,?
            DW ?,?,?,?,?,?,?,?,?
            DW ?,?,?,?,?,?,?,?,?
            DW ?,?,?,?,?,?,?,?,?
            DW ?,?,?,?,?,?,?,?,?
            DW ?,?,?,?,?,?,?,?,?
            DW ?,?,?,?,?,?,?,?,?
            DW ?,?,?,?,?,?,?,?,?

    msgx DB "<Fase 1>",10,'$'                                         ;idem
    msgy DB "<Fase 2>",10,'$'
    msg1 DB "Insira os valores da matriz:",10,"$"
    msg2 DB 10,"Matriz original:",10,"$"

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
    CALL PENIS

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

PENIS PROC

    MOV AH,09
    LEA DX,msg1
    INT 21h
    CALL RECEBA         ;entrada de dados na matriz
    MOV AH,09
    LEA DX,msg2         
    INT 21h
    CALL PRINT          
    MOV ah,4Ch
    INT 21h
    RET
PENIS ENDP

RECEBA PROC
    XOR SI,SI           ;index
    MOV CL,linha            ;loop linha
    MOV CH,coluna            ;loop coluna
    LOOPlinha:
    LOOPcol:
    MOV AH,1h           ;input
    INT 21h
    AND AX,00FFh        ;mascara para pegar o apenas o input em AL
    SUB AX,30h          ;char para numero
    MOV MATRIZ[SI],AX   ;preenchimento da matriz
    ADD SI,2            ;index anda de 2 em 2
    DEC CH
    JNZ LOOPcol
    MOV AH,2            ;quebra de linha
    MOV DL,10
    INT 21h
    MOV CH,coluna
    DEC CL
    JNZ LOOPlinha
    RET
RECEBA ENDP

;description
PRINT PROC
    MOV CH,coluna                    ;LOOP1
    MOV CL,linha                    ;LOOP2
    XOR BX,BX                   ;index linha
    XOR SI,SI                   ;index coluna
    MOV AH,2h
    LOOP2:
    LOOP1:
    MOV DX,MATRIZ[BX][SI]       ;elemento a ser impresso
    ADD DX,30h                  ;numero para char
    INT 21h
    ADD SI,2                    ;index coluna anda de 2 em 2
    DEC CH
    JNZ LOOP1
    XOR SI,SI                   ;index coluna reset
    ADD BX,offsetlinha                    ;index linha vai para proxima linha
    MOV CH,coluna                    ;loop de coluna reset
    MOV DL,10                   ;quebra de linha
    INT 21h
    DEC CL
    JNZ LOOP2
    RET
PRINT ENDP

end main