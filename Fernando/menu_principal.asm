; === PROCEDIMIENTO: MENU PRINCIPAL ===
MENU_PRINCIPAL PROC
menu_inicio:
    LIMPIAR_PANTALLA 0AH
    
    ; 1. Dibujar el Marco (puedes reutilizar tu lógica de dibujo aquí)
    CURSOR 0, 1, 0
    IMP_SINCOLOR marco_sup
    
    ; 2. Título del Panel
    CURSOR 3, 24, 0
    IMP_SINCOLOR txt_menu_tit
    
    ; 3. Listado de Opciones
    CURSOR 7, 20, 0
    IMP_SINCOLOR opt_1
    CURSOR 9, 20, 0
    IMP_SINCOLOR opt_2
    CURSOR 11, 20, 0
    IMP_SINCOLOR opt_3
    CURSOR 13, 20, 0
    IMP_SINCOLOR opt_4
    CURSOR 15, 20, 0
    IMP_SINCOLOR opt_5
    CURSOR 17, 20, 0
    IMP_SINCOLOR opt_6
    
    CURSOR 20, 25, 0
    IMP_SINCOLOR prompt_sel

seleccionar:
    CURSOR 20, 51, 0        ; Poner el cursor dentro de los corchetes [ ]
    RASTREO                 ; Captura la tecla en AL
    
    ; Comparaciones para saltar a los módulos
    CMP AL, '1'
    JE modulo_daniel
    CMP AL, '2'
    JE modulo_enciso
    CMP AL, '3'
    JE modulo_victor
    CMP AL, '4'
    JE ver_logs
    CMP AL, '5'
    JE utilidades
    CMP AL, '6'
    JE salir_sistema
    
    JMP seleccionar         ; Si no es una opción válida, esperar de nuevo

modulo_daniel:
    ; CALL MODULO_INVENTARIO
    JMP menu_inicio

modulo_enciso:
    ; CALL MODULO_CLIMA
    JMP menu_inicio

modulo_victor:
    ; CALL MODULO_ROBOTICA
    JMP menu_inicio

ver_logs:
    CALL VISUALIZAR_LOGS
    JMP menu_inicio

utilidades:
    JMP menu_inicio

salir_sistema:
    LIMPIAR_PANTALLA 07H    ; Regresar a blanco y negro
    CURSOR 12, 30, 0
    IMP_SINCOLOR msg_salida
    RET                         ; Regresa al flujo principal para terminar
MENU_PRINCIPAL ENDP

VISUALIZAR_LOGS PROC
    LIMPIAR_PANTALLA 0AH
    CURSOR 2, 5, 0
    IMP_SINCOLOR txt_acc ; Reutilizamos el header de "// ACCESS PORTAL //"
    
    CURSOR 5, 5, 0
    ; --- Aquí irá la lógica de LECTURA_ARCHIVO ---
    ; Por ahora, imprimimos un placeholder
    MOV AH, 09H
    ; LEA DX, buffer_lectura_archivo
    ; INT 21H
    
    CURSOR 22, 5, 0
    IMP_SINCOLOR msjPausa
    RASTREO
    RET
VISUALIZAR_LOGS ENDP