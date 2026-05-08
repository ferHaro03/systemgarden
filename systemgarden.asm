;***************************************
; HARO CANDELARIO FERNANDO SAUL
; PROYECTO: systemgarden
; EQUIPO: Fernando, Daniel, Enciso, Victor
;***************************************

INCLUDE biblioteca.txt
 
.MODEL SMALL
.STACK 100H
.DATA
    ; --- RUTAS DEL SISTEMA (BASE DE DATOS EN C:) ---
    ; Se utilizan nombres compatibles con el sistema de archivos de Emu8086 
    rutaRaiz db 'C:\SYSTGARD',0
    rutaFer  db 'C:\SYSTGARD\FERNANDO',0 ; Modulo: Seguridad (Login/Logs)
    rutaDan  db 'C:\SYSTGARD\DANIEL',0   ; Modulo: Inventario (Herramientas)
    rutaEnc  db 'C:\SYSTGARD\ENCISO',0   ; Modulo: Clima (Temp/Alertas)
    rutaVic  db 'C:\SYSTGARD\VICTOR',0   ; Modulo: Robotica (Coordenadas)
    
    ; --- MENSAJES DE INTERFAZ ---
    msjInit  db 'Iniciando systemgarden...$'
    msjDirOK db '[OK] Modulos de almacenamiento listos.$'
    msjError db '[X] ERROR: Fallo en la montura del sistema.$'
    msjLogin db '=== LOGIN: SYSTEMGARDEN ADMINISTRATION ===$'
    msjPausa db 'Presiona una tecla para continuar...$'

    ; --- VARIABLES DE LOGIN ---
    promptU  db 'Usuario: $'
    promptP  db 'Password: $'

.CODE
INICIO:
    MOV AX,@DATA
    MOV DS,AX
    MOV ES,AX

    ; --- FASE 1: INICIALIZACION DE DIRECTORIOS ---
    ; Limpieza de pantalla usando la macro de la biblioteca [cite: 135]
    NEWPAGE
    
    ; Posicionamiento del cursor 
    CURSOR 2,5,0
    ; Impresion de cadena sin color 
    IMP_SINCOLOR msjInit

    ; Creacion de la estructura de carpetas usando la macro corregida 
    CREAR_DIRECTORIO rutaRaiz
    JC ERROR
    
    CREAR_DIRECTORIO rutaFer
    JC ERROR
    
    CREAR_DIRECTORIO rutaDan
    JC ERROR
    
    CREAR_DIRECTORIO rutaEnc
    JC ERROR
    
    CREAR_DIRECTORIO rutaVic
    JC ERROR

    CURSOR 4,5,0
    IMP_SINCOLOR msjDirOK
    
    CURSOR 6,5,0
    IMP_SINCOLOR msjPausa
    ; Pausa para visualizacion [cite: 135]
    RASTREO

    ; --- FASE 2: INTERFAZ DE ACCESO ---
    NEWPAGE
    
    CURSOR 5,15,0
    IMP_SINCOLOR msjLogin
    
    CURSOR 8,20,0
    IMP_SINCOLOR promptU
    ; Aqui se integrara la captura del usuario
    
    CURSOR 10,20,0
    IMP_SINCOLOR promptP
    ; Aqui se integrara la captura del password oculto

    JMP FIN

ERROR:
    CURSOR 22,20,0
    IMP_SINCOLOR msjError

FIN:
    MOV AX,4C00H
    INT 21H
END INICIO