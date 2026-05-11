; === MODULO DE SEGURIDAD Y ACCESO ===
; Responsable: Fernando
; ====================================

MODULO_LOGIN PROC
    ; --- 1. DIBUJAR MARGEN GENERAL ---
    CURSOR 1, 1, 0
    IMP_SINCOLOR marco_sup
    
    MOV CX, 23    
    MOV DH, 1     
dibujar_lados_log:
    CURSOR DH, 1, 0
    MOV AH, 02H
    MOV DL, 186     ; Borde izquierdo '¦'
    INT 21H
    CURSOR DH, 78, 0
    MOV AH, 02H
    MOV DL, 186     ; Borde derecho '¦'
    INT 21H
    INC DH        
    LOOP dibujar_lados_log
    
    CURSOR 24, 1, 0
    IMP_SINCOLOR marco_inf

    ; --- 2. DIBUJAR PORTADA "GARDEN" ---
    CURSOR 2, 34, 0
    IMP_SINCOLOR txt_sys
    CURSOR 3, 30, 0
    IMP_SINCOLOR txt_acc
    
    CURSOR 5, 16, 0
    IMP_SINCOLOR art_g1
    CURSOR 6, 16, 0
    IMP_SINCOLOR art_g2
    CURSOR 7, 16, 0
    IMP_SINCOLOR art_g3
    CURSOR 8, 16, 0
    IMP_SINCOLOR art_g4
    CURSOR 9, 16, 0
    IMP_SINCOLOR art_g5

    CURSOR 11, 19, 0
    IMP_SINCOLOR txt_eqp

    ; --- 3. CAPTURA DE USUARIO ---
    CURSOR 15, 28, 0
    IMP_SINCOLOR prompt_usr_log  
    LECTURA_CADENA buff_usr
    
    ; --- 4. CAPTURA DE CONTRASEÑA ---
    CURSOR 17, 28, 0
    IMP_SINCOLOR prompt_pwd_log  
    
    MOV CX, 0              
    LEA BX, buff_pwd + 2   

captura_pass:
    RASTREO                
    CMP AL, 13             ; ¿Es ENTER?
    JE fin_pass            
    
    MOV [BX], AL           
    INC BX                 
    INC CX                 
    
    MOV AH, 02H            
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
    CURSOR 20, 28, 0
    IMP_SINCOLOR msg_valido
    ; <-- Aquí más adelante agregaremos el menú principal de SystemGarden
    RET

error_login:
    ; --- 7. ACCESO DENEGADO ---
    CURSOR 20, 20, 0
    IMP_SINCOLOR msg_err
    RASTREO 
    ; Limpiar los buffers si queremos que reintente (opcional para despues)
    RET
    
MODULO_LOGIN ENDP