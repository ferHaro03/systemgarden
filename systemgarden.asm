;***************************************
; HARO CANDELARIO FERNANDO SAUL
; PROYECTO: systemgarden
; EQUIPO: Fernando, Daniel, Enciso, Victor
;***************************************

INCLUDE biblioteca.txt
 
.MODEL SMALL
.STACK
.DATA
    ; --- RUTAS DEL SISTEMA (BASE DE DATOS EN C:) ---
    rutaRaiz db 'C:\SYSTGARD',0
    rutaFer  db 'C:\SYSTGARD\FERNANDO',0 
    rutaDan  db 'C:\SYSTGARD\DANIEL',0   
    rutaEnc  db 'C:\SYSTGARD\ENCISO',0   
    rutaVic  db 'C:\SYSTGARD\VICTOR',0   
    
    ; --- MENSAJES DE INICIALIZACION ---
    msjInit  db 'Iniciando systemgarden...$'
    msjDirOK db '[OK] Modulos de almacenamiento listos.$'
    msjError db '[X] ERROR: Fallo en la montura del sistema.$'
    msjPausa db 'Presiona una tecla para continuar...$'
    
    ; ====================================================
    ; --- VARIABLES DEL DISENO VISUAL (PORTADA) ---
    ; ====================================================
    ; Textos Superiores
    marco_sup  db 201, 76 dup(205), 187, '$'
    marco_inf  db 200, 76 dup(205), 188, '$'
    txt_sys  db 'SYSTG/\RDEN$'
    txt_acc  db '// ACCESS PORTAL //$'
    
    ; Arte ASCII "GARDEN" (47 caracteres de ancho)
    art_g1   db ' @@@@@@  @@@@@  @@@@@@  @@@@@@  @@@@@@@ @@@  @@ $'
    art_g2   db '@@      @@   @@ @@   @@ @@   @@ @@      @@@@ @@ $'
    art_g3   db '@@  @@@ @@@@@@@ @@@@@@  @@   @@ @@@@@   @@ @@@@ $'
    art_g4   db '@@   @@ @@   @@ @@   @@ @@   @@ @@      @@  @@@ $'
    art_g5   db ' @@@@@@ @@   @@ @@   @@ @@@@@@  @@@@@@@ @@   @@ $'

    ; Textos Inferiores
    txt_ver  db '~~ Sistema de Invernadero v1.0 ~~$'
    txt_zig  db '\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/$'
    txt_eqp  db '-- Fernando - Daniel - Enciso - Victor --$'
    
    ; Adornos
    adorno_i db '<$'
    adorno_d db '>$'     
    
    ; --- Status boot ---
    msg_err  db '  [X]   ERROR FATAL: fallo al montar directorios$'
    msg_paus db 'Presiona cualquier tecla...$'             
    
    prompt_usr_log db ' > USER_ID : '                         ; 13 letras
    prompt_pwd_log db ' > P/\SS   : '                         ; 13 letras
    buff_usr       db 15, 0, 15 dup(' ')
    buff_pwd       db 15, 0, 15 dup(' ')
    
    ; --- CREDENCIALES MAESTRAS ---
    usr_ok         db 'admin'
    pwd_ok         db '1234'
    log_err        db '  [X] ACCESO DENEGADO. Intenta de nuevo. $'
    msg_valido     db '  [OK] ACCESO CONCEDIDO. '              ; 23 letras
    ; ==================================================== 
    
    ; --- TEXTOS DEL MENU PRINCIPAL ---
    txt_menu_tit   db ' < // G/\RDEN CONTROL PANEL // > '  ; 33 letras
    opt_1          db ' [1] Gestion de Inventario (Daniel) ' ; 36 letras
    opt_2          db ' [2] Monitoreo Climatico (Enciso) '   ; 34 letras
    opt_3          db ' [3] Automatizacion Robotica (Victor) '; 38 letras
    opt_4          db ' [4] Ver Historial de Accesos (Logs) '; 37 letras
    opt_5          db ' [5] Utilidades del Sistema '         ; 28 letras
    opt_6          db ' [6] Salir de SystemGarden '          ; 27 letras
    
    prompt_sel     db ' > Seleccione una opcion: [ ]'        ; 29 letras
    msg_salida     db ' Cerrando sesion... '                 ; 20 letras

    ; Para dibujar usando la nueva macro
    borde_lat      db 186

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

END INICIO