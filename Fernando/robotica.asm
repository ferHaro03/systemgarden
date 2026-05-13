; === MODULO DE AUTOMATIZACION (HARDWARE) ===
; Responsable: Fernando
; ===========================================

MODULO_ROBOTICA PROC
menu_robotica:
    LIMPIAR_PANTALLA 07H
    
    ; 1. Dibujar Marco
    IMP_COLOR marco_sup, 78, 0, 0, 0, 1, 02H
    MOV CX, 23    
    MOV DH, 1     
dib_lados_rob:
    PUSH CX
    IMP_COLOR borde_lat, 1, 0, 0, DH, 1, 02H
    IMP_COLOR borde_lat, 1, 0, 0, DH, 78, 02H
    POP CX
    INC DH        
    LOOP dib_lados_rob
    IMP_COLOR marco_inf, 78, 0, 0, 24, 1, 02H

    ; 2. Formulario
    IMP_COLOR txt_rob_tit, 36, 0, 0, 3, 22, 0AH  
    IMP_COLOR rob_opt1, 36, 0, 0, 8, 22, 0FH     
    IMP_COLOR rob_opt2, 36, 0, 0, 10, 22, 0FH
    IMP_COLOR rob_opt3, 36, 0, 0, 12, 22, 0FH
    IMP_COLOR prompt_sel, 29, 0, 0, 18, 25, 0EH  

seleccionar_rob:
    CURSOR 18, 52, 0        
    RASTREO                 
    
    CMP AL, '1'
    JE activar_robot
    CMP AL, '2'
    JE llamar_impresora
    CMP AL, '3'
    JE salir_robotica
    JMP seleccionar_rob    

llamar_impresora:
    CALL IMPRIMIR_REPORTE
    JMP menu_robotica

; -------------------------------------------
; RUTINA: MEDIDOR DE PRESIÓN (PUERTO 2088h)
; -------------------------------------------
activar_presion:
    IMP_COLOR rob_msg1, 36, 0, 0, 20, 22, 0BH

    MOV DX, 2088h
    MOV AL, 0

subir_presion:
    OUT DX, AL
    CALL RETARDO_PRESION
    INC AL
    CMP AL, 101          ; 101 porque INC va ANTES del CMP
    JNE subir_presion

    MOV CX, 15           ; pausa visible en el tope
pausa_cima:
    CALL RETARDO_PRESION
    LOOP pausa_cima      ; CX aquí es seguro, no hay CALL anidado

bajar_presion:
    DEC AL
    OUT DX, AL
    CALL RETARDO_PRESION
    CMP AL, 0
    JNE bajar_presion

    JMP menu_robotica

; -------------------------------------------
; RUTINA INTELIGENTE: ROBOT RECOLECTOR 
; -------------------------------------------
activar_robot:
    IMP_COLOR rob_msg2, 36, 0, 0, 20, 22, 0BH

    MOV BYTE PTR [pasos_rumba], 1
    MOV BYTE PTR [giros_rumba], 0

rumba_loop:
    MOV AL, [pasos_rumba]
    CMP AL, [limite_rumba]
    JG  rumba_fin

    ; --- AVANZAR N pasos (usando variable, NO CX) ---
    MOV AL, [pasos_rumba]
    MOV [cont_pasos], AL    ; copiar a variable auxiliar

avanza_tramo:
    CALL WAIT_ROBOT
    MOV AL, 1
    OUT 9, AL              ; avanzar

    DEC BYTE PTR [cont_pasos]
    JNZ avanza_tramo        ; sin LOOP, sin tocar CX

    ; --- GIRAR A LA DERECHA ---
    CALL WAIT_ROBOT
    MOV AL, 3
    OUT 9, AL              ; girar derecha

    ; --- Cada 2 giros ? pasos++ ---
    INC BYTE PTR [giros_rumba]
    MOV AL, [giros_rumba]
    AND AL, 01H
    JNZ rumba_loop
    INC BYTE PTR [pasos_rumba]
    JMP rumba_loop

rumba_fin:
    JMP menu_robotica

salir_robotica:
    RET
    
MODULO_ROBOTICA ENDP

; --- SUBRUTINAS DE HARDWARE ---
; --- RUTINA PARA ACTUALIZAR SENSORES ---
ACTUALIZAR_ESTADO PROC
    ; Abrir el archivo en modo lectura/escritura (2)
    ABRIR_ARCHIVO file_sensores, 2
    MOV handle_sens, AX
    
    ; Supongamos que queremos actualizar la temperatura a 30C
    ; Primero movemos el puntero al inicio para sobreescribir el dato viejo
    MOVER_PUNTERO handle_sens, 00H
    
    ; Definimos un nuevo dato local o usamos uno de .DATA
    ; (Aquí podrías capturar un dato del teclado antes)
    ESCRIBIR_ARCHIVO handle_sens, 12, msg_temp 
    
    CERRAR_ARCHIVO handle_sens
    RET
ACTUALIZAR_ESTADO ENDP

; --- RUTINA PARA MOSTRAR ESTADO ---
MOSTRAR_MONITOREO PROC
    ABRIR_ARCHIVO file_sensores, 0 ; Solo lectura
    MOV handle_sens, AX
    
    LEER_ARCHIVO handle_sens, 24, buffer_sens
    
    CERRAR_ARCHIVO handle_sens
    
    ; Imprimir en pantalla lo que leímos del TXT
    CURSOR 20, 10, 0
    IMP_SINCOLOR buffer_sens
    RET
MOSTRAR_MONITOREO ENDP

; === RUTINA DE IMPRESIÓN EN LPT1 ===
IMPRIMIR_REPORTE PROC
    ; 1. Informar al usuario
    CURSOR 20, 22, 0
    MOV AH, 09H
    LEA DX, msg_imp
    INT 21H

    ; 2. Abrir archivo de sensores
    ABRIR_ARCHIVO file_sensores, 0
    MOV handle_sens, AX

    ; 3. Leer contenido (suponiendo 100 bytes max)
    LEER_ARCHIVO handle_sens, 100, buffer_sens
    PUSH AX ; Guardamos en la pila cuántos bytes se leyeron realmente
    
    CERRAR_ARCHIVO handle_sens

    ; 4. Enviar al Printer (INT 17H)
    POP CX              ; Recuperamos la cantidad de bytes a imprimir
    JCXZ fin_impresion  ; Si el archivo estaba vacío, salir
    LEA SI, buffer_sens ; Apuntar al inicio de los datos

ciclo_impresora:
    MOV AL, [SI]        ; Tomar un caracter del buffer
    MOV AH, 00H         ; Función 00h: Imprimir caracter
    MOV DX, 0           ; Puerto LPT1 (0)
    INT 17H             ; Interrupción de Impresora BIOS
    
    INC SI              ; Siguiente letra
    LOOP ciclo_impresora

    ; 5. Enviar un Salto de Línea final para que la impresora avance el papel
    MOV AL, 13
    MOV AH, 00H         ; <-- VITAL: Limpiar la basura que dejó la interrupción anterior
    MOV DX, 0           
    INT 17H             

    MOV AL, 10
    MOV AH, 00H         ; <-- VITAL: Limpiar de nuevo
    MOV DX, 0           
    INT 17H

fin_impresion:
    RET
IMPRIMIR_REPORTE ENDP

RETARDO_PRESION PROC
    PUSH AX
    PUSH CX
    PUSH DX
    MOV AH, 86H
    MOV CX, 0000H
    MOV DX, 0C350H      ; 50,000µs = aguja visible y fluida
    INT 15H
    POP DX
    POP CX
    POP AX
    RET
RETARDO_PRESION ENDP

WAIT_ROBOT PROC
esperar_robot:
    IN  AL, 11              ; leer estado del robot
    TEST AL, 00000010b      ; bit 1 = robot ocupado
    JNZ esperar_robot       ; si está ocupado, seguir esperando
    RET
WAIT_ROBOT ENDP