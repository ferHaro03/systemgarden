;****************************************************************************
; Proyecto INVERNADERO - ATLANTIC CORP
; Documentado por Barrera, Enciso, Haro e Ibarra
;****************************************************************************
  
INCLUDE BIBLIOTECA.LIB

.MODEL SMALL
.STACK
.DATA
    ; --- Variable de control para el ID del archivo (Requerido por tus macros) ---
    ID          dw 0

    ; --- Definición de Rutas (Raíz y Carpetas de Dispositivos) ---
    ; Hecho por Barrera Velázquez
    ; Se usa la ruta base de tu proyecto previo
    raiz        db 'C:\PROY_ATLANTIC', 0
    dir_termo   db 'C:\PROY_ATLANTIC\TERMO', 0
    dir_motor   db 'C:\PROY_ATLANTIC\MOTOR', 0
    dir_leds    db 'C:\PROY_ATLANTIC\LEDS', 0
    dir_print   db 'C:\PROY_ATLANTIC\PRINT', 0

    ; --- Definición de Archivos TXT ---
    file_termo  db 'C:\PROY_ATLANTIC\TERMO\termo.txt', 0
    file_motor  db 'C:\PROY_ATLANTIC\MOTOR\motor.txt', 0
    file_leds   db 'C:\PROY_ATLANTIC\LEDS\leds.txt', 0
    file_print  db 'C:\PROY_ATLANTIC\PRINT\print.txt', 0

    ; --- Contenido de los Archivos (Descripciones del Invernadero) ---
    msg_termo   db 'DEVICE: Termometro. USO: Monitoreo de temperatura para activacion de extractores. $'
    len_termo   dw  82

    msg_motor   db 'DEVICE: Motor Pasos. USO: Control de apertura automatica de ventilas laterales. $'
    len_motor   dw 80

    msg_leds    db 'DEVICE: Barra LED. USO: Indicadores visuales de nivel critico de humedad. $'
    len_leds    dw 74

    msg_print   db 'DEVICE: Impresora. USO: Generacion de bitacora diaria de condiciones climaticas. $'
    len_print   dw 81

    ; --- Mensajes de Interfaz ---
    msj_inicio  db 'Iniciando creacion de infraestructura Invernadero Atlantic Corp...', '$'
    msj_fin     db 10, 13, 'Sistema de archivos creado con exito.$'
    msj_error   db 10, 13, 'Error al crear la estructura. Verifique permisos.$'

.CODE
INICIO:
    MOV AX, @DATA
    MOV DS, AX
    MOV ES, AX

    ; Limpiar pantalla y mostrar inicio
    CURSOR 2, 2, 0
    IMP_CAD_SINCOLOR msj_inicio

    ; ==========================================================
    ; 1. CREACIÓN DE CARPETAS (Directorios)
    ; ==========================================================
    
    ; Crear Raíz
    CREAR_CARPETA raiz
    
    ; Crear Subcarpetas de Dispositivos
    CREAR_CARPETA dir_termo
    CREAR_CARPETA dir_motor
    CREAR_CARPETA dir_leds
    CREAR_CARPETA dir_print

    ; ==========================================================
    ; 2. CREACIÓN DE ARCHIVOS Y ESCRITURA DE USOS
    ; ==========================================================
    
    ; --- Configuración Termómetro ---
    CREAR_ARCHIVO file_termo, 32   ; 32 = Archivo de usuario según tu comentario
    ESCRIBIR_ARCHIVO ID, len_termo, msg_termo
    CERRAR_ARCHIVO ID

    ; --- Configuración Motor ---
    CREAR_ARCHIVO file_motor, 32
    ESCRIBIR_ARCHIVO ID, len_motor, msg_motor
    CERRAR_ARCHIVO ID

    ; --- Configuración LEDs ---
    CREAR_ARCHIVO file_leds, 32
    ESCRIBIR_ARCHIVO ID, len_leds, msg_leds
    CERRAR_ARCHIVO ID

    ; --- Configuración Impresora ---
    CREAR_ARCHIVO file_print, 32
    ESCRIBIR_ARCHIVO ID, len_print, msg_print
    CERRAR_ARCHIVO ID

    ; Comprobación de errores simplificada (basada en Carry Flag)
    JC ERROR_SISTEMA

    ; Mensaje final
    CURSOR 10, 2, 0
    IMP_CAD_SINCOLOR msj_fin
    JMP FIN

ERROR_SISTEMA:
    CURSOR 10, 2, 0
    IMP_CAD_SINCOLOR msj_error

FIN:
    RASTREO ; Pausa para ver el resultado
    MOV AX, 4C00H
    INT 21H
END INICIO
