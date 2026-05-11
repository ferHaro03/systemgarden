; === MODULO DE SEGURIDAD Y ACCESO ===
; Responsable: Fernando
; ====================================

MODULO_LOGIN PROC
    ; --- 1. DIBUJAR MARGEN GENERAL ---
    LIMPIAR_PANTALLA 07H
    
    ; Orden: CADENA, LONGITUD, PAGINA, MODO, REN(Y), COL(X), COLOR
    IMP_COLOR marco_sup, 78, 0, 0, 0, 1, 02H
    
    MOV CX, 23    
    MOV DH, 1     
dibujar_lados_log:
    PUSH CX
    IMP_COLOR borde_lat, 1, 0, 0, DH, 1, 02H
    IMP_COLOR borde_lat, 1, 0, 0, DH, 78, 02H
    POP CX
    INC DH        
    LOOP dibujar_lados_log
    
    IMP_COLOR marco_inf, 78, 0, 0, 24, 1, 02H

    ; --- 2. DIBUJAR PORTADA "GARDEN" ---
    IMP_COLOR txt_sys, 11, 0, 0, 2, 34, 0AH
    IMP_COLOR txt_acc, 19, 0, 0, 3, 30, 0AH
    
    IMP_COLOR art_g1, 48, 0, 0, 5, 16, 0AH
    IMP_COLOR art_g2, 48, 0, 0, 6, 16, 0AH
    IMP_COLOR art_g3, 48, 0, 0, 7, 16, 0AH
    IMP_COLOR art_g4, 48, 0, 0, 8, 16, 0AH
    IMP_COLOR art_g5, 48, 0, 0, 9, 16, 0AH

    IMP_COLOR txt_eqp, 41, 0, 0, 11, 19, 0FH

    ; --- 3. CAPTURA DE USUARIO ---
    IMP_COLOR prompt_usr_log, 13, 0, 0, 15, 28, 0EH
    
    CURSOR 15, 41, 0       ; Posicionar el cursor justo despues del prompt
    LECTURA_CADENA buff_usr
    
    ; --- 4. CAPTURA DE CONTRASEÑA ---
    IMP_COLOR prompt_pwd_log, 13, 0, 0, 17, 28, 0EH
    
    CURSOR 17, 41, 0       ; Posicionar el cursor para los asteriscos
    MOV CX, 0              
    LEA BX, buff_pwd + 2   

captura_pass:
    RASTREO                
    CMP AL, 13             ; ¿Es ENTER?
    JE fin_pass            
    
    MOV [BX], AL           
    INC BX                 
    INC CX                 
    
    MOV AH, 02H            ; Imprimir asterisco
    MOV DL, '*'            
    INT 21H                
    JMP captura_pass       

fin_pass:
    MOV buff_pwd[1], CL    

    ; --- 5. VALIDACION DE CREDENCIALES ---
    ; (Usuario)
    MOV CL, buff_usr[1]    
    CMP CL, 5              
    JNE error_login        

    CLD                    
    LEA SI, buff_usr + 2   
    LEA DI, usr_ok         
    MOV CX, 5              
    REPE CMPSB             
    JNE error_login        

    ; (Password)
    MOV CL, buff_pwd[1]
    CMP CL, 4
    JNE error_login

    LEA SI, buff_pwd + 2   
    LEA DI, pwd_ok         
    MOV CX, 4
    REPE CMPSB
    JNE error_login

    ; --- 6. ACCESO CONCEDIDO ---
    IMP_COLOR msg_valido, 23, 0, 0, 20, 28, 0AH  ; Verde Claro
    
    ; Pequeña pausa antes de saltar al menú para que el usuario vea el "[OK]"
    CURSOR 24, 79, 0 
    RASTREO
    
    CALL MENU_PRINCIPAL
    RET

error_login:
    ; --- 7. ACCESO DENEGADO ---
    IMP_COLOR msg_err, 39, 0, 0, 20, 20, 0CH     ; Rojo Claro
    
    ; Pausa para leer el error y luego reiniciar el proceso de login
    CURSOR 24, 79, 0
    RASTREO 
    JMP MODULO_LOGIN
    
MODULO_LOGIN ENDP