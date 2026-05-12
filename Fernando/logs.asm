; === MODULO: VISUALIZADOR DE LOGS ===
; Responsable: Fernando
; ====================================

VISUALIZAR_LOGS PROC
    ; 1. Limpiar Pantalla
    LIMPIAR_PANTALLA 07H

    ; 2. Dibujar el Marco (Verde Oscuro = 02H)
    IMP_COLOR marco_sup, 78, 0, 0, 0, 1, 02H
    
    MOV CX, 23    
    MOV DH, 1     
dibujar_lados_logs:
    PUSH CX
    IMP_COLOR borde_lat, 1, 0, 0, DH, 1, 02H
    IMP_COLOR borde_lat, 1, 0, 0, DH, 78, 02H
    POP CX
    INC DH        
    LOOP dibujar_lados_logs
    
    IMP_COLOR marco_inf, 78, 0, 0, 24, 1, 02H

    ; 3. Titulos (Blanco y Verde Claro)
    IMP_COLOR txt_acc, 19, 0, 0, 2, 30, 0FH
    IMP_COLOR txt_menu_tit, 33, 0, 0, 3, 24, 0AH

    ; --- LOGICA DE ARCHIVO (INTERRUPCION 21H) ---
    
    ABRIR_ARCHIVO file_log, 0
    MOV handle_log, AX
    
    ; Mover puntero al inicio (00h)
    MOVER_PUNTERO handle_log,00h
    
    ; LEER_ARCHIVO ID, CANTIDAD, LEIDOS
    LEER_ARCHIVO handle_log, 450, buffer_log 
    
    PUSH AX
        
    CERRAR_ARCHIVO handle_log
    
    POP AX
    
    ; Si AX (bytes leídos) es > 0, mostrar en pantalla
    CMP AX, 0
    JE log_vacio
    
    CURSOR 6, 5, 0
    IMP_SINCOLOR buffer_log
    
    JMP fin_logs

log_vacio:
    IMP_COLOR msg_log_vacio, 30, 0, 0, 12, 25, 0EH
    JMP fin_logs

err_apertura:
    ; Probablemente el archivo aun no se crea
    IMP_COLOR msg_log_vacio, 30, 0, 0, 12, 25, 0EH
    JMP fin_logs

err_lectura:
    ; Cerrar antes de salir en caso de error de lectura
    MOV AH, 3EH
    MOV BX, handle_log
    INT 21H
    IMP_COLOR msg_log_err, 33, 0, 0, 12, 23, 0CH

fin_logs:
    ; Pie de pagina y regreso al menu
    IMP_COLOR msjPausa, 35, 0, 0, 23, 22, 0FH
    RASTREO
    RET                       
    

VISUALIZAR_LOGS ENDP