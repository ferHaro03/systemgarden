;***************************************
; HARO CANDELARIO FERNANDO SAUL
; PROYECTO: systemgarden
; EQUIPO: Fernando, Daniel, Enciso, Victor
;***************************************

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
    opt_1          db ' [1] Gestion de Inventario (Daniel) ' 
    opt_2          db ' [2] Monitoreo Climatico (Enciso) '   
    opt_3          db ' [3] Automatizacion Robotica (Victor) '
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
    
    log_entry      db 'ACCESO ADMIN REGISTRADO', 13, 10  ; Longitud exacta = 25
    

    
.CODE
INICIO:
    MOV AX,@DATA
    MOV DS,AX
    MOV ES,AX

    ; --- FASE 1: INICIALIZACION DE DIRECTORIOS ---
;    LIMPIAR_PANTALLA
;    CALL MODULO_BOOT

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

END INICIO