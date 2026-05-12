#start=emulation_kit.exe#
#start=Traffic_Lights.exe#
#start=LED_Display.exe#

MODULO_CLIMA PROC  
    ; --- ASEGURAR SEGMENTOS AL ENTRAR ---
    MOV AX, @DATA
    MOV DS, AX
    MOV ES, AX
    

inicio_interfaz_e:
    LIMPIAR_PANTALLA    
    IMP_COLOR marco_sup, 78, 0, 0, 0, 1, 02H
    
    MOV fila_aux, 1      
    MOV CX, 23    
dibujar_lados_enciso:
    PUSH CX
    IMP_COLOR borde_lat, 1, 0, 0, fila_aux, 1, 02H
    IMP_COLOR borde_lat, 1, 0, 0, fila_aux, 78, 02H
    INC fila_aux
    POP CX
    LOOP dibujar_lados_enciso
    
    IMP_COLOR marco_inf, 78, 0, 0, 24, 1, 02H
    IMP_COLOR txt_clima_tit, 38, 0, 0, 3, 21, 0AH

ciclo_monitoreo:
    MOV DX, 2086h       
    IN AL, DX           
    MOV val_temp_raw, AL

    AAM
    ADD AH, 30h
    ADD AL, 30h
    MOV temp_ascii[0], AH
    MOV temp_ascii[1], AL

    IMP_COLOR lbl_temp_act, 31, 0, 0, 8, 24, 0FH
    IMP_COLOR temp_ascii, 2, 0, 0, 8, 48, 0AH

    CMP val_temp_raw, 30
    JL clima_estable_e        ; Menor a 30 = estable
    
    CMP val_temp_raw, 38
    JL clima_alerta_e         ; De 30 a 37 = alerta
    
    JMP clima_critico_e       ; 38 o más = crítico

clima_estable_e:
    MOV AL, 00000100b   
    PUSH AX             
    MOV SI, OFFSET msj_lcd_ok
    CALL ACTUALIZAR_LCD_E 
    POP AX              
    IMP_COLOR msj_estado_ok, 28, 0, 0, 11, 25, 0AH
    JMP refrescar_hardware_e   
    
clima_alerta_e:
    MOV AL, 00000010b   
    PUSH AX             
    MOV SI, OFFSET msj_lcd_alerta
    CALL ACTUALIZAR_LCD_E
    POP AX              
    IMP_COLOR msj_estado_alerta, 28, 0, 0, 11, 25, 0EH
    JMP refrescar_hardware_e

clima_critico_e:
    MOV AL, 00000001b   
    PUSH AX             
    MOV SI, OFFSET msj_lcd_warn
    CALL ACTUALIZAR_LCD_E
    POP AX              
    IMP_COLOR msj_alerta_crt, 28, 0, 0, 11, 25, 0CH
    
refrescar_hardware_e:
             
               
     ; --- 1. ACTUALIZAR TRAFFIC LIGHTS SEGÚN TEMPERATURA ---
    ; Verde    = temperatura estable
    ; Amarillo = temperatura en alerta
    ; Rojo     = temperatura crítica

    PUSH AX
    PUSH DX

    MOV AL, val_temp_raw

    CMP AL, 30
    JL semaforo_verde_e      ; Menor a 30 = estable

    CMP AL, 38
    JL semaforo_amarillo_e   ; De 30 a 37 = alerta

    JMP semaforo_rojo_e      ; 38 o más = crítico


semaforo_verde_e:
    MOV AX, SEM_VERDE
    JMP enviar_semaforo_e


semaforo_amarillo_e:
    MOV AX, SEM_AMARILLO
    JMP enviar_semaforo_e


semaforo_rojo_e:
    MOV AX, SEM_ROJO
    JMP enviar_semaforo_e


enviar_semaforo_e:
    MOV DX, 4
    OUT DX, AX               ; Enviar estado al Traffic Lights

    POP DX
    POP AX


    ; --- 2. ACTUALIZAR LED DISPLAY COMO NIVEL DE ESTADO ---
    ; 1 = estable
    ; 2 = alerta
    ; 3 = crítico

    PUSH AX
    PUSH DX

    MOV AL, val_temp_raw

    CMP AL, 30
    JL led_estado_estable_e

    CMP AL, 38
    JL led_estado_alerta_e

    JMP led_estado_critico_e


    led_estado_estable_e:
        MOV AX, 1                ; Nivel 1 = estable
        JMP enviar_led_estado_e
    
    
    led_estado_alerta_e:
        MOV AX, 2                ; Nivel 2 = alerta
        JMP enviar_led_estado_e
    
    
    led_estado_critico_e:
        MOV AX, 3                ; Nivel 3 = crítico
        JMP enviar_led_estado_e
    
    
    enviar_led_estado_e:
        MOV DX, 199
        OUT DX, AX               ; Enviar nivel al led_display
    
        POP DX
        POP AX
     ; --- 3. MOSTRAR MENÚ ---
    
    IMP_COLOR msj_clima_menu, 42, 0, 0, 20, 18, 0EH
    CURSOR 20, 62, 0
    RASTREO             
    
    CMP AL, '1'
    JE log_manual_e
    CMP AL, '2'
    JE ver_historial_clima
    CMP AL, '3'
    JE ver_historial_alertas 
    CMP AL, '4'
    JE salir_clima_e
    JMP ciclo_monitoreo

log_manual_e:
    CALL OBTENER_HORA               
    CMP val_temp_raw, 30
    JG  preparar_ruta_alerta

preparar_ruta_clima:
    ; Intentar crear el archivo primero (esto lo genera si no existe)
    MOV AH, 3Ch
    MOV CX, 32              
    LEA DX, ruta_clima      ; 'C:\SYSTGARD\ENCISO\clima.txt'
    INT 21h
    jc error_arc_e          

    ; Abrir para escribir
    MOV AH, 3Dh
    LEA DX, ruta_clima
    MOV AL, 2               
    INT 21h
    MOV ID, AX              ; Guardar Handle

    CALL MOVER_PUNTERO_FINAL
    ESCRIBIR_ARCHIVO ID, 22, msj_log_estable 
    JMP terminar_escritura_final

preparar_ruta_alerta:
    MOV AH, 3Ch
    MOV CX, 32
    LEA DX, ruta_alertas
    INT 21h

    MOV AH, 3Dh
    LEA DX, ruta_alertas
    MOV AL, 2
    INT 21h
    MOV ID, AX

    CALL MOVER_PUNTERO_FINAL
    ESCRIBIR_ARCHIVO ID, 28, msj_log_alerta  

terminar_escritura_final:
    ESCRIBIR_ARCHIVO ID, 5, hora_txt         
    ESCRIBIR_ARCHIVO ID, 6, msj_log_fin      
    ESCRIBIR_ARCHIVO ID, 2, temp_ascii       
    ESCRIBIR_ARCHIVO ID, 2, salto_linea      
    CERRAR_ARCHIVO ID
    JMP ciclo_monitoreo

error_arc_e:
    JMP ciclo_monitoreo

ver_historial_clima:
    PUSH DS
    POP ES
    MOV DI, OFFSET buffer_clima
    MOV CX, 400
    MOV AL, '$'
    REP STOSB
    
    BORRAR_SECCION 07H, 13, 10, 18, 70 
    
    MOV AH, 3Dh
    LEA DX, ruta_clima
    MOV AL, 0
    INT 21h
    JC error_lectura_real   
    
    MOV ID, AX
    LEER_ARCHIVO ID, 400, buffer_clima
    
  
    MOV BX, AX              ; Guardamos en BX cuántos bytes leímos
    CERRAR_ARCHIVO ID       ; AX se ensucia aquí
    CMP BX, 0               ; Comparamos BX (el valor real de lectura)
    

    JE archivo_vacio_e

    CURSOR 15, 20, 0
    IMP_SINCOLOR buffer_clima 
    RASTREO
    JMP MODULO_CLIMA
    
error_lectura_real:
    JMP archivo_vacio_e
    
ver_historial_alertas: 
    PUSH DS              
    POP ES
    MOV DI, OFFSET buffer_clima
    MOV CX, 400
    MOV AL, '$'
    REP STOSB

    BORRAR_SECCION 07H, 13, 10, 18, 70 
    IMP_COLOR msj_hist_alertas, 34, 0, 0, 13, 22, 0CH 
    
    MOV AH, 3Dh
    LEA DX, ruta_alertas
    MOV AL, 0
    INT 21h
    JC error_lectura_e
    
    MOV ID, AX                      
    LEER_ARCHIVO ID, 400, buffer_clima
    
    
    MOV BX, AX              ; Guardamos el conteo en BX
    CERRAR_ARCHIVO ID       ; Cerramos el archivo
    CMP BX, 0               ; Comparamos el conteo guardado
 

    JE archivo_vacio_e

    CURSOR 15, 0, 0
    IMP_SINCOLOR buffer_clima 
    RASTREO
    JMP MODULO_CLIMA
    
archivo_vacio_e:
    CURSOR 16, 18, 0
    IMP_COLOR msj_vacio_e, 41, 0, 0, 16, 18, 0EH 
    RASTREO
    JMP MODULO_CLIMA      
    
error_lectura_e:
    CURSOR 20, 20, 0
    ; --- CORREGIDO: msj_vacio_e con minúsculas ---
    IMP_SINCOLOR msj_vacio_e 
    RASTREO
    JMP MODULO_CLIMA

salir_clima_e:
    RET
MODULO_CLIMA ENDP

; --- SUBRUTINAS ---

OBTENER_HORA PROC
    MOV AH, 2Ch       
    INT 21h           
    MOV AL, CH
    AAM
    ADD AH, 30h
    ADD AL, 30h
    MOV hora_txt[0], AH
    MOV hora_txt[1], AL
    MOV AL, CL
    AAM
    ADD AH, 30h
    ADD AL, 30h
    MOV hora_txt[3], AH
    MOV hora_txt[4], AL
    RET
OBTENER_HORA ENDP

MOVER_PUNTERO_FINAL PROC
    MOV AH, 42H         
    MOV AL, 02H         
    MOV BX, ID          
    MOV CX, 0
    MOV DX, 0
    INT 21H
    RET
MOVER_PUNTERO_FINAL ENDP

ACTUALIZAR_LCD_E PROC
    MOV DX, 2040h
    MOV CX, 10          
lcd_loop_e:
    LODSB
    OUT DX, AL
    INC DX
    LOOP lcd_loop_e
    RET
ACTUALIZAR_LCD_E ENDP
