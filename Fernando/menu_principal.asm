; === PROCEDIMIENTO: MENU PRINCIPAL ===
MENU_PRINCIPAL PROC
menu_inicio:
    LIMPIAR_PANTALLA 07H
    
    ; 1. Dibujar el Marco (Verde Oscuro = 02H)
    ; Orden: CADENA, LONGITUD, PAGINA, MODO, REN(Y), COL(X), COLOR
    IMP_COLOR marco_sup, 78, 0, 0, 0, 1, 02H
    
    MOV CX, 23    
    MOV DH, 1     
dibujar_lados_menu:
    PUSH CX         ; Proteger el contador del ciclo
    ; Borde Izquierdo
    IMP_COLOR borde_lat, 1, 0, 0, DH, 1, 02H
    ; Borde Derecho
    IMP_COLOR borde_lat, 1, 0, 0, DH, 78, 02H
    POP CX          
    INC DH        
    LOOP dibujar_lados_menu
    
    ; Marco Inferior
    IMP_COLOR marco_inf, 78, 0, 0, 24, 1, 02H

    ; 2. Titulo del Panel (Verde Claro = 0AH)
    IMP_COLOR txt_menu_tit, 33, 0, 0, 3, 24, 0AH
    
    ; 3. Listado de Opciones (Blanco Brillante = 0FH)
    IMP_COLOR opt_1, 27, 0, 0, 7,  20, 0FH
    IMP_COLOR opt_2, 25, 0, 0, 9,  20, 0FH
    IMP_COLOR opt_3, 29, 0, 0, 11, 20, 0FH
    IMP_COLOR opt_4, 37, 0, 0, 13, 20, 0FH
    IMP_COLOR opt_5, 28, 0, 0, 15, 20, 0FH
    IMP_COLOR opt_6, 27, 0, 0, 17, 20, 0FH
    
    ; 4. Prompt de Seleccion (Amarillo = 0EH)
    IMP_COLOR prompt_sel, 29, 0, 0, 20, 25, 0EH

seleccionar:
    CURSOR 20, 52, 0        ; Posicionar el cursor parpadeando dentro de [ ]
    RASTREO                 ; AL = Tecla presionada
    
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
    
    JMP seleccionar         ; Bucle infinito si presiona una tecla incorrecta

modulo_daniel:
    CALL PROCESO_DANIEL  
    JMP menu_inicio     

modulo_enciso:
    CALL MODULO_CLIMA
    JMP menu_inicio

modulo_victor:
    CALL MODULO_TERMOMETRO
    JMP menu_inicio

ver_logs:
    CALL VISUALIZAR_LOGS
    JMP menu_inicio

utilidades:
    JMP menu_inicio

salir_sistema:
    LIMPIAR_PANTALLA 07H    
    IMP_COLOR msg_salida, 20, 0, 0, 12, 30, 0CH  ; Rojo Claro
    JMP FIN                     
MENU_PRINCIPAL ENDP
