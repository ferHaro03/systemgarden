; ====================================
; MODULO BOOT  —  Fernando
; INCLUDE Fernando\boot.asm
; ====================================

MODULO_BOOT PROC
    ; Limpiar con fondo negro
    LIMPIAR_PANTALLA 07H
    
    ; --- 1. DIBUJAR MARGEN (Verde Oscuro 02H) ---
    ; Orden: CADENA, LONGITUD, PAGINA, MODO, REN(Y), COL(X), COLOR
    IMP_COLOR marco_sup, 78, 0, 0, 0, 1, 02H
    
    MOV CX, 23    
    MOV DH, 1     
dibujar_lados_boot:
    PUSH CX
    IMP_COLOR borde_lat, 1, 0, 0, DH, 1, 02H
    IMP_COLOR borde_lat, 1, 0, 0, DH, 78, 02H
    POP CX
    INC DH        
    LOOP dibujar_lados_boot
    
    IMP_COLOR marco_inf, 78, 0, 0, 24, 1, 02H

    ; --- 2. DISEÑO VISUAL (Verde Claro 0AH) ---
    IMP_COLOR txt_sys, 11, 0, 0, 2, 34, 0AH
    IMP_COLOR txt_acc, 19, 0, 0, 3, 30, 0AH
    
    ; Adornos
    IMP_COLOR adorno_i, 1, 0, 0, 6, 13, 0AH
    IMP_COLOR adorno_d, 1, 0, 0, 6, 67, 0AH
    
    ; Logo GARDEN
    IMP_COLOR art_g1, 48, 0, 0, 5, 16, 0AH
    IMP_COLOR art_g2, 48, 0, 0, 6, 16, 0AH
    IMP_COLOR art_g3, 48, 0, 0, 7, 16, 0AH
    IMP_COLOR art_g4, 48, 0, 0, 8, 16, 0AH
    IMP_COLOR art_g5, 48, 0, 0, 9, 16, 0AH

    IMP_COLOR adorno_i, 1, 0, 0, 12, 10, 0AH
    IMP_COLOR adorno_d, 1, 0, 0, 12, 70, 0AH

    ; Textos de Version y Equipo (Blanco 0FH y Verde 02H)
    IMP_COLOR txt_ver, 33, 0, 0, 13, 23, 0FH
    IMP_COLOR txt_zig, 50, 0, 0, 15, 15, 02H
    IMP_COLOR txt_eqp, 41, 0, 0, 16, 19, 0FH

    ; --- 3. CREAR DIRECTORIOS + STATUS (Verde 02H) ---
    ; Usamos JNC para saltar si se crea bien, o CMP para ignorar si ya existe
    
    CREAR_DIRECTORIO rutaRaiz
    JNC ok_r
    CMP AX, 05H
    JNE BOOT_ERR
ok_r:
    IMP_COLOR ok_raiz, 20, 0, 0, 18, 10, 02H

    CREAR_DIRECTORIO rutaFer
    JNC ok_f
    CMP AX, 05H
    JNE BOOT_ERR
ok_f:
    IMP_COLOR ok_fer, 19, 0, 0, 19, 10, 02H

    CREAR_DIRECTORIO rutaDan
    JNC ok_d
    CMP AX, 05H
    JNE BOOT_ERR
ok_d:
    IMP_COLOR ok_dan, 17, 0, 0, 20, 10, 02H

    CREAR_DIRECTORIO rutaEnc
    JNC ok_e
    CMP AX, 05H
    JNE BOOT_ERR
ok_e:
    IMP_COLOR ok_enc, 17, 0, 0, 21, 10, 02H

    CREAR_DIRECTORIO rutaVic
    JNC ok_v
    CMP AX, 05H
    JNE BOOT_ERR
ok_v:
    IMP_COLOR ok_vic, 17, 0, 0, 22, 10, 02H
    

    CREAR_ARCHIVO file_log,0   
    MOV handle_log, AX
    CERRAR_ARCHIVO handle_log
    
    ; Crear archivo de sensores/estado
    CREAR_ARCHIVO file_sensores, 0
    MOV handle_sens, AX
    
    ; Escribir valores iniciales por defecto
    ESCRIBIR_ARCHIVO handle_sens, 12, msg_temp
    ESCRIBIR_ARCHIVO handle_sens, 12, msg_hum
    
    CERRAR_ARCHIVO handle_sens
    
    ; --- PAUSA FINAL (Amarillo 0EH) ---
    IMP_COLOR msg_paus, 27, 0, 0, 23, 27, 0EH
    RASTREO
    RET

BOOT_ERR:
    ; Mostrar error fatal en Rojo (0CH)
    IMP_COLOR msg_err, 45, 0, 0, 23, 10, 0CH
    RASTREO
    MOV AX, 4C01H
    INT 21H

MODULO_BOOT ENDP