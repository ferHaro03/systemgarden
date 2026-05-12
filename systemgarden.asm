;***************************************
; HARO CANDELARIO FERNANDO SAUL
; PROYECTO: systemgarden
; EQUIPO: Fernando, Daniel, Enciso, Victor
;***************************************

#start=stepper_motor.exe#
#start=robot.exe#
#start=printer.exe#

INCLUDE biblioteca.txt
 
.MODEL SMALL
.STACK
.DATA
    ; ====================================================
    ; --- 1. RUTAS DEL SISTEMA Y ALMACENAMIENTO ---
    ; ====================================================
    rutaRaiz db 'C:\SYSTGARD',0
    rutaFer  db 'C:\SYSTGARD\FERNANDO',0 
    rutaDan  db 'C:\SYSTGARD\DANIEL',0   
    rutaEnc  db 'C:\SYSTGARD\ENCISO',0   
    rutaVic  db 'C:\SYSTGARD\VICTOR',0   
    
    ; ====================================================
    ; --- 2. MODULO: BOOT (Mensajes de carga) ---
    ; ====================================================
    ; IMPORTANTE: Llevan '$' porque BOOT usa IMP_SINCOLOR
    ok_raiz  db ' [OK] Raiz montada.$'
    ok_fer   db ' [OK] Dir Fernando.$'
    ok_dan   db ' [OK] Dir Daniel.$'
    ok_enc   db ' [OK] Dir Enciso.$'
    ok_vic   db ' [OK] Dir Victor.$'
    
    msg_err  db '   [X] ERROR FATAL: fallo al montar directorios$'
    msjError db '   [X] ERROR: Fallo en la montura del sistema.$' ; Para el salto ERROR de systemgarden
    msg_paus db '   Presiona cualquier tecla...$'             
    
    ; ====================================================
    ; --- 3. DISEÑO VISUAL COMPARTIDO (Boot, Login, Menu) ---
    ; ====================================================
    marco_sup  db 201, 76 dup(205), 187, '$'
    marco_inf  db 200, 76 dup(205), 188, '$'
    borde_lat  db 186
    adorno_i   db '<$'
    adorno_d   db '>$'     
    
    txt_sys    db 'SYSTG/\RDEN$'
    txt_acc    db '// ACCESS PORTAL //$'
    txt_ver    db '~~ Sistema de Invernadero v1.0 ~~$'
    txt_zig    db '\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/$'
    txt_eqp    db '-- Fernando - Daniel - Enciso - Victor --$'

    art_g1   db ' @@@@@@  @@@@@  @@@@@@  @@@@@@  @@@@@@@ @@@  @@ $'
    art_g2   db '@@      @@   @@ @@   @@ @@   @@ @@      @@@@ @@ $'
    art_g3   db '@@  @@@ @@@@@@@ @@@@@@  @@   @@ @@@@@   @@ @@@@ $'
    art_g4   db '@@   @@ @@   @@ @@   @@ @@   @@ @@      @@  @@@ $'
    art_g5   db ' @@@@@@ @@   @@ @@   @@ @@@@@@  @@@@@@@ @@   @@ $'

    ; ==================================================== 
    ; --- 4. MODULO: LOGIN ---
    ; ====================================================
    prompt_usr_log db ' > USER_ID : '                         
    prompt_pwd_log db ' > P/\SS   : '                         
    buff_usr       db 15, 0, 15 dup(' ')
    buff_pwd       db 15, 0, 15 dup(' ')
    
    usr_ok         db 'admin'
    pwd_ok         db '1234'
    log_err        db '[X] ACCESO DENEGADO. Intenta de nuevo. '  ; 39 letras
    msg_valido     db '[OK] ACCESO CONCEDIDO. '                  ; 23 letras
    
    ; ====================================================
    ; --- 5. MODULO: MENU PRINCIPAL ---
    ; ====================================================
    txt_menu_tit   db ' < // G/\RDEN CONTROL PANEL // > '    
    opt_1          db ' [1] Gestion de Inventario ' 
    opt_2          db ' [2] Monitoreo Climatico '   
    opt_3          db ' [3] Automatizacion Robotica ' ; 40 letras
    opt_4          db ' [4] Ver Historial de Accesos (Logs) '
    opt_5          db ' [5] Utilidades del Sistema '         
    opt_6          db ' [6] Salir de SystemGarden '          
    
    prompt_sel     db ' > Seleccione una opcion: [ ]'        
    msg_salida     db ' Cerrando sesion... '                 
    msjPausa       db 'Presiona una tecla para continuar...$' ; Usado en VISUALIZAR_LOGS
    
    ; ====================================================
    ; --- 6. VARIABLES PARA LOGS (ARCHIVOS) ---
    ; ====================================================
    file_log       db 'C:\SYSTGARD\FERNANDO\access.txt',0
    handle_log     dw ?
    buffer_log     db 500 dup('$')       ; Buffer para cargar el texto del archivo
    
    msg_log_vacio  db ' [!] El historial esta vacio. '   ; 30 letras
    msg_log_err    db ' [X] Error al leer el historial. ' ; 33 letras 
    
    log_entry      db '                           ACCESO ADMIN REGISTRADO', 13, 10  ; Longitud exacta = 25
    

    ; ====================================================
    ; --- MODULO ROBOTICA (FERNANDO) ---
    ; ====================================================
    txt_rob_tit db ' < // M0DULO DE AUTOMATIZACION // > ' ; 36 letras
    rob_opt1    db ' [1] Abrir Valvula Riego (Stepper)  ' ; 36 letras
    rob_opt2    db ' [2] Desplegar Robot Recolector     ' ; 36 letras
    rob_opt3    db ' [3] Volver al Panel Principal      ' ; 36 letras
    rob_opt4    db ' [4] Generar Reporte Impreso (TXT)  ' ; 36 letras
    
    rob_msg1    db ' [!] Motor Stepper activado...      ' ; 36 letras
    rob_msg2    db ' [!] Robot en movimiento...         ' ; 36 letras

    ; --- CONFIGURACIÓN DE SEGUNDO ARCHIVO ---
    file_sensores  db 'C:\SYSTGARD\FERNANDO\sensores.txt', 0
    handle_sens    dw ?

    ; Datos a manipular (ejemplo: Temperatura y Humedad)
    ; Usamos 10 bytes para que sea fácil de leer/escribir
    msg_temp       db 'TEMP: 25C ', 13, 10 ; 12 bytes
    msg_hum        db 'HUM:  60% ', 13, 10 ; 12 bytes
    msg_imp       db ' [!] Enviando reporte a impresora...', '$'
    ; Buffer para leer el estado
    buffer_sens    db 24 dup('$')
     
    ; VARIABLES DE DANIEL
    TIT_INV         DB  'SELECCIONA EL PROCEDIMIENTO'
    OP_INV          DB  'OP:'
    OP1_INV         DB  'INVENTARIO (1)'
    OP2_INV         DB  'FLUJO DE RIEGO (2)'
    OP3_INV         DB  'SALIR (3)'
    OPDB_INV        DB  2,1,3 DUP('$')
    MSJPRUEBA       DB  'ESTO ES UNA PRUEBA                     $'
    MSJERROR_DAN    DB  'INTRODUCE UN VALOR NUMERICO ENTRE 1 - 3$' ; Nombre único
    MSJ_INV_VACIO   DB  'NO HAY PRODUCTOS EN INVENTARIO$' 
     
    ; VARIABLES SUBMENÚ
    TIT_INV_SUB     DB  '--- INVENTARIO ---$'
    OP1_INV_SUB     DB  '1.- A',165,'ADIR RECURSO$'
    OP2_INV_SUB     DB  '2.- LECTURA DE DATOS$'
    OP3_INV_SUB     DB  '3.- ELIMINAR INVENTARIO$'
    OP4_INV_SUB     DB  '4.- REGRESAR$'
    OP_MSG_SUB      DB  'OP: $'
    OPDB_SUB        DB  2, 0, 2 DUP ('$')
    RUTA_INV        DB  'C:\SYSTGARD\DANIEL\stock.txt',0
    ID_DAN          DW  0 ; Nombre único para Daniel
    MSJERRORINV     DB  'INTRODUCE UN VALOR NUMERICO ENTRE 1 - 4$'
    MSJERRORARC     DB  'OCURRIO UN ERROR CON EL ARCHIVO        $'
    ADD_INV         DB  101,0,102
    MSJ_ELIMINADO   DB  'INVENTARIO ELIMINADO CORRECTAMENTE$'
    MSJ_ERROR_READ  DB  'INTRODUCE UN VALOR ENTRE 1 Y 2$' 
     
    ; FORMULARIO ADD
    TIT_ADD         DB  '=== AGREGAR DATOS ==='
    MSG_RECURSO     DB  'RECURSO: '
    MSG_CANTIDAD    DB  'CANTIDAD: '
    MSJ_LIMITE      DB  'YA HAS LLEGADO AL LIMITE DEL INVENTARIO$'
    BUFFER_NOMBRE   DB  20,0,22 DUP(' ')
    BUFFER_CANT     DB  5,0,7 DUP(' ')
    ESPACIO         DB  ' - '
    SALTO_LINEA     DB 13,10
    CONTADOR_INV    DB  0 
    
    ; FORMULARIO LECTURA
    BUFFER_LECTURA  DB  300 DUP('$')
    BYTES_LEIDOS    DW  0
    TIT_READ        DB  '=== LECTURA DE INVENTARIO ==='
    OP1_READ        DB  '1.- DESPLEGAR EN LCD'
    OP2_READ        DB  '2.- REGRESAR'
    OP_READ         DB  'OP: '
    OPDB_READ       DB  2,0,3 DUP('$')
    MSJ_LCD         DB  'DATOS ENVIADOS AL LCD$'
    FILA_READ       DB  5
    INDICE_DAN      DW  0 
    TOTAL_PRODUCTOS DB  0 
    
    ; FORMULARIO RIEGO
    TIT_RIEGO       DB  '=== CONTROL DE RIEGO ==='
    OP1_RIEGO       DB  '1.- INICIAR RIEGO'
    OP2_RIEGO       DB  '2.- DETENER RIEGO'
    OP3_RIEGO       DB  '3.- VER BITACORA'
    OP4_RIEGO       DB  '4.- REGRESAR'
    MSG_RIEGO_OP    DB  'OP: '
    OPDB_RIEGO      DB  2,0,3 DUP('$')
    MSJ_RIEGO_ON    DB  'RIEGO ACTIVADO$'
    MSJ_RIEGO_OFF   DB  'RIEGO DETENIDO$'
    MSJ_ERROR_RIEGO DB  'INTRODUCE UN VALOR NUMERICO ENTRE 1 - 4$'
    
    ; FORMULARIO BITACORA
    TIT_BITACORA      DB '=== BITACORA ==='
    OP1_BITACORA      DB '1.- EDITAR BITACORA'
    OP2_BITACORA      DB '2.- VER BITACORA'
    OP3_BITACORA      DB '3.- REGRESAR'
    MSG_BITACORA_OP   DB 'OP: '
    OPDB_BITACORA     DB 2,0,3 DUP('$')
    RUTA_BITACORA     DB 'C:\SYSTGARD\DANIEL\bitacora.txt',0
    BUFFER_BITACORA   DB 100,0,102 DUP(' ')
    LECTURA_BITACORA  DB 500 DUP('$')
    MSJ_CREAR_BIT     DB 'PRIMERO CREA UNA BITACORA$'
    MSJ_GUARDADO      DB 'BITACORA GUARDADA$'
    MSJ_BITACORA_VACIA DB 'NO HAY CONTENIDO EN LA BITACORA$'
    TIT_EDICION_BITACORA DB '=== MODO EDICION BITACORA ===$'
    TIT_MOSTRAR_BITACORA DB '=== CONTENIDO DE BITACORA ===$'

    ; ====================================================
    ; --- VARIABLES DEL MODULO 2: CLIMA (ENCISO) ---
    ; ==================================================== 
    
    val_temp_raw     db 0  
    ; --- Códigos para Traffic Lights ---
    ; Puerto 4 - Word de 16 bits
    
    SEM_ROJO        EQU 0249h   ; Todos los semáforos en rojo
    SEM_AMARILLO    EQU 0492h   ; Todos los semáforos en amarillo
    SEM_VERDE       EQU 0924h   ; Todos los semáforos en verde       
    ID               dw 0            ; Manejador de archivos 
    fila_aux         db 0            ; Auxiliar para dibujo de marco 
    ruta_clima       DB 'C:\SYSTGARD\ENCISO\clima.txt', 0
    ruta_alertas     db 'C:\SYSTGARD\ENCISO\alertas.txt', 0
    
    ; Formatos del Historial (Conteo de caracteres exacto para macros)
    msj_log_estable  db 'SISTEMA ESTABLE HORA:      ' ; Rellenado a 28 letras
    msj_log_alerta   db '!! ALERTA CRITICA !! HORA:  ' ; 28 letras
    hora_txt         db '00:00'                   ; 5 letras 
    msj_log_fin      db ' FUE: '                  ; 6 letras 
    salto_linea      DB 13, 10                  ; 2 letras 
    
    ; Datos y Buffers
    temp_ascii       db '00', '$' 
    buffer_clima     db 400 dup('$') ; Capacidad para ~10 registros largos 
    
    ; Interfaz de Pantalla
    txt_clima_tit      db ' < // CLIM/\TE MONITORING SYSTEM // > ' 
    lbl_temp_act       db ' TEMPERATURE RE/\DING: [    ] C '          
    msj_estado_ok      db ' SYSTEM ST/\TUS: [ OPTIMAL ] '            
    msj_alerta_crt     db ' SYSTEM ST/\TUS: [ CRITICAL ] '           
    msj_clima_menu     db ' [1] LOG [2] CLIMA [3] ALERTAS [4] EXIT'  
    msj_hist_alertas   db ' --- CRITICAL ALERTS HISTORY --- ' ;
    msj_lect_hist      db ' --- SYSTEM RE/\DINGS HISTORY --- '  
    msj_lcd_alerta     DB 'ALERTA    '
    msj_estado_alerta  DB ' SYSTEM ST/\TUS: [   ALERT ] '    
    msj_lcd_ok         db 'SYSTEM: OK$'      
    msj_lcd_warn       db '!! ALERT !!$'
    msj_error_arc      db 'OCURRIO UN ERROR CON EL ARCHIVO  $' ; Error técnico 
    msj_vacio_e        db ' [INFO] Sin registros guardados aun.  $' ; Sin datos  
    
    ; ====================================================    
    ; ====================================================
        
.CODE
INICIO:
    MOV AX,@DATA
    MOV DS,AX
    MOV ES,AX

    ; --- FASE 1: INICIALIZACION DE DIRECTORIOS ---
     ;LIMPIAR_PANTALLA
     ;CALL MODULO_BOOT

    ; --- FASE 2: INTERFAZ DE ACCESO ---
    LIMPIAR_PANTALLA
    CALL MODULO_LOGIN
    
    ; --- MENÚ ---
    LIMPIAR_PANTALLA
    CALL MENU_PRINCIPAL
    JMP FIN

ERROR:
    CURSOR 22,20,0
    IMP_SINCOLOR msjError

FIN:
    MOV AX,4C00H
    INT 21H

; --- INCLUSION DE MODULOS DEL EQUIPO ---
; Los include siempre van al final, fuera del flujo principal de ejecucion
INCLUDE Fernando\login.asm
INCLUDE Fernando\boot.asm
INCLUDE Fernando\menu_principal.asm
INCLUDE Fernando\logs.asm  
INCLUDE Fernando\robotica.asm
INCLUDE Fernando\logs.asm
INCLUDE Daniel\inventario.asm
INCLUDE Enciso\clima.asm

END INICIO
