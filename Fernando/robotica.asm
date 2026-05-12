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
    IMP_COLOR rob_opt4, 36, 0, 0, 14, 22, 0FH
    IMP_COLOR prompt_sel, 29, 0, 0, 18, 25, 0EH  

seleccionar_rob:
    CURSOR 18, 52, 0        
    RASTREO                 
    
    CMP AL, '1'
    JE activar_riego
    CMP AL, '2'
    JE activar_robot
    CMP AL, '3'
    JE salir_robotica
    CMP AL, '4'
    JE llamar_impresora
    JMP seleccionar_rob    

llamar_impresora:
    CALL IMPRIMIR_REPORTE
    JMP menu_robotica

; -------------------------------------------
; RUTINA: MOTOR STEPPER (PUERTO 7)
; -------------------------------------------
activar_riego:
    IMP_COLOR rob_msg1, 36, 0, 0, 20, 22, 0BH 
    
    MOV CX, 15      ; Dará 50 pasos fluidos
ciclo_stepper:
    MOV AL, 3       
    OUT 7, AL       
    CALL RETARDO_STEPPER
    
    MOV AL, 6       
    OUT 7, AL
    CALL RETARDO_STEPPER
    
    MOV AL, 12      
    OUT 7, AL
    CALL RETARDO_STEPPER
    
    MOV AL, 9       
    OUT 7, AL
    CALL RETARDO_STEPPER
    
    LOOP ciclo_stepper
    JMP menu_robotica

; -------------------------------------------
; RUTINA INTELIGENTE: ROBOT RECOLECTOR 
; -------------------------------------------
activar_robot:
    IMP_COLOR rob_msg2, 36, 0, 0, 20, 22, 0BH 
    
    ; --- FASE 1: AVANZAR 3 CASILLAS ---
    MOV CX, 3       
avanza_bruto:
    MOV AL, 3       ; COMANDO 3 = AVANZAR
    OUT 9, AL       
    CALL RETARDO_ROBOT 
    LOOP avanza_bruto
    
    ; --- FASE 2: GIRAR A LA DERECHA ---
    MOV AL, 1       ; COMANDO 1 = GIRAR DERECHA
    OUT 9, AL
    CALL RETARDO_ROBOT

    ; --- FASE 3: AVANZAR 2 CASILLAS MAS ---
    MOV CX, 2
avanza_mas:
    MOV AL, 3       ; COMANDO 3 = AVANZAR
    OUT 9, AL
    CALL RETARDO_ROBOT
    LOOP avanza_mas

    JMP menu_robotica

salir_robotica:
    RET
MODULO_ROBOTICA ENDP

; --- SUBRUTINAS DE HARDWARE ---

RETARDO_STEPPER PROC
    PUSH CX
    MOV CX, 000FH   ; Velocidad ideal para que el Stepper se vea fluido
pausa_step: LOOP pausa_step
    POP CX
    RET
RETARDO_STEPPER ENDP

RETARDO_ROBOT PROC
    PUSH CX
    ; El robot necesita mas tiempo grafico que la aguja del motor.
    ; Empezamos con 00FFH. Si el robot no alcanza a dar el paso completo, 
    ; subele un cero (ej. 0FFFH). Si va muy lento, bajale.
    MOV CX, 000FH   
pausa_rob: LOOP pausa_rob
    POP CX
    RET
RETARDO_ROBOT ENDP   

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