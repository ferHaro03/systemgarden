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
    ok_raiz  db '  [OK]  C:\SYSTGARD             creado / verificado$'
    ok_fer   db '  [OK]  C:\SYSTGARD\FERNANDO    creado / verificado$'
    ok_dan   db '  [OK]  C:\SYSTGARD\DANIEL      creado / verificado$'
    ok_enc   db '  [OK]  C:\SYSTGARD\ENCISO      creado / verificado$'
    ok_vic   db '  [OK]  C:\SYSTGARD\VICTOR      creado / verificado$'
    msg_err  db '  [X]   ERROR FATAL: fallo al montar directorios$'
    msg_paus db 'Presiona cualquier tecla...$'             
    
    ; ====================================================
    ; --- VARIABLES DEL MODULO 1: LOGIN (FERNANDO) ---
    ; ====================================================     
    borde_onda_sup db '  /\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\ $'
    txt_logo       db '  <                   SYSTG/\RDEN                    > $'
    txt_header     db '  <               // ACCESS PORTAL //                > $'
    borde_onda_inf db '  \/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/ $'
    
    prompt_usr_log db '  > USER_ID : $'
    prompt_pwd_log db '  > P/\SS   : $'
    msg_valido     db '  [OK] ACCESO CONCEDIDO. REDIRIGIENDO... $'
    
    buff_usr       db 15, 0, 15 dup(' ')
    buff_pwd       db 15, 0, 15 dup(' ')
    
    ; --- CREDENCIALES MAESTRAS ---
    usr_ok         db 'admin'
    pwd_ok         db '1234'
    log_err        db '  [X] ACCESO DENEGADO. Intenta de nuevo. $'
    ; ==================================================== 
    
    ; --- TEXTOS DEL MENU PRINCIPAL ---
    txt_menu_tit   db ' < // G/\RDEN CONTROL PANEL // > $'
    opt_1          db ' [1] Gestión de Inventario (Daniel) $'
    opt_2          db ' [2] Monitoreo Climático (Enciso) $'
    opt_3          db ' [3] Automatización Robótica (Victor) $'
    opt_4          db ' [4] Ver Historial de Accesos (Logs) $'
    opt_5          db ' [5] Utilidades del Sistema $'
    opt_6          db ' [6] Salir de SystemGarden $'
    
    prompt_sel     db ' > Seleccione una opción: [ ]$'
    msg_salida     db ' Cerrando sesión... $'

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