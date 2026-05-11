; ====================================
; MODULO BOOT  —  Fernando
; INCLUDE Fernando\boot.asm
; ====================================

MODULO_BOOT PROC
    LIMPIAR_PANTALLA
    ; 1. Textos Superiores
    CURSOR 2, 34, 0
    IMP_SINCOLOR txt_sys
    
    CURSOR 3, 30, 0
    IMP_SINCOLOR txt_acc
    
    ; 2. Adornos laterales superiores (opcional, como en tu imagen)
    CURSOR 6, 13, 0
    IMP_SINCOLOR adorno_i
    CURSOR 6, 67, 0
    IMP_SINCOLOR adorno_d
    
    ; 3. Bloque GARDEN (Centrado en la columna 16)
    CURSOR 7, 16, 0
    IMP_SINCOLOR art_g1
    CURSOR 8, 16, 0
    IMP_SINCOLOR art_g2
    CURSOR 9, 16, 0
    IMP_SINCOLOR art_g3
    CURSOR 10, 16, 0
    IMP_SINCOLOR art_g4
    CURSOR 11, 16, 0
    IMP_SINCOLOR art_g5

    ; 4. Adornos laterales inferiores
    CURSOR 12, 10, 0
    IMP_SINCOLOR adorno_i
    CURSOR 12, 70, 0
    IMP_SINCOLOR adorno_d

    ; 5. Textos Inferiores y Autores
    CURSOR 13, 23, 0
    IMP_SINCOLOR txt_ver
    
    CURSOR 15, 15, 0
    IMP_SINCOLOR txt_zig
    
    CURSOR 16, 19, 0
    IMP_SINCOLOR txt_eqp

    ; --- Crear directorios + status ---
    CREAR_DIRECTORIO rutaRaiz
    JNC dir_fer
    CMP AX, 05H
    JNE BOOT_ERR
    CURSOR 19, 10, 0    IMP_SINCOLOR ok_raiz

dir_fer:
    CREAR_DIRECTORIO rutaFer
    JNC dir_dan
    CMP AX, 05H
    JNE BOOT_ERR
    CURSOR 20, 10, 0    IMP_SINCOLOR ok_fer

dir_dan:
    CREAR_DIRECTORIO rutaDan
    JNC dir_enc
    CMP AX, 05H
    JNE BOOT_ERR
    CURSOR 21, 10, 0    IMP_SINCOLOR ok_dan

dir_enc:
    CREAR_DIRECTORIO rutaEnc
    JNC dir_vic         ; Si no hay error (Carry=0), salta a crear la siguiente
    CMP AX, 05H         ; Si hay error, comparamos si es 05H (Ya existe)
    JNE BOOT_ERR        ; Si es diferente de 05H, hubo un problema real, salta a ERROR
    CURSOR 22, 10, 0    IMP_SINCOLOR ok_enc

dir_vic:
    CREAR_DIRECTORIO rutaVic
    CMP AX, 05H
    JNE BOOT_ERR
    CURSOR 23, 0, 0    IMP_SINCOLOR ok_vic

    ; --- Pausa (col 27, amarillo 0Eh) ---
    CURSOR 24, 27, 0
    IMP_SINCOLOR msg_paus
    RASTREO
    RET

BOOT_ERR:
    CURSOR 23, 0, 0
    IMP_SINCOLOR msg_err
    RASTREO
    MOV AX, 4C01H
    INT 21H

MODULO_BOOT ENDP