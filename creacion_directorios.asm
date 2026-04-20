;****************************************************************************
; Proyecto INVERNADERO - ATLANTIC CORP
; Documentado por Barrera, Enciso, Haro e Ibarra
;****************************************************************************
  
INCLUDE BIBLIOTECA.LIB

.MODEL SMALL
.STACK
.DATA
    ;VARIABLE DE CONTROL PARA EL ID DEL ARCHIVO
    ID          dw 0

    ;DEFINICIÓN DE RUTAS (RAÍZ Y CARPETAS DE DEVICES)
    ; --DANIEL BARRERA (CREACIÓN DE RUTAS PRINCIPALES)
    raiz        db 'C:\PROY_ATLANTIC', 0
    dir_termo   db 'C:\PROY_ATLANTIC\TERMO', 0
    dir_motor   db 'C:\PROY_ATLANTIC\MOTOR', 0
    dir_leds    db 'C:\PROY_ATLANTIC\LEDS', 0
    dir_print   db 'C:\PROY_ATLANTIC\PRINT', 0
    dir_LCD     db 'C:\PROY_ATLANTIC\LCDDISPLAY', 0
    dir_seven   db 'C:\PROY_ATLANTIC\SEVEN', 0
    dir_dot     db 'C:\PROY_ATLANTIC\DOTMATRX', 0
    dir_traffic  db 'C:\PROY_ATLANTIC\TRAFFIC', 0
    dir_robot    db 'C:\PROY_ATLANTIC\ROBOT', 0

    ; --- Definición de Archivos TXT ---
    file_termo  db 'C:\PROY_ATLANTIC\TERMO\termo.txt', 0 ;ENCISO RAMIREZ (DESARROLLO DE TERMOMETRO)
    file_motor  db 'C:\PROY_ATLANTIC\MOTOR\motor.txt', 0 ;HARO CANDELARIO (DESARROLLO DE MOTOR)
    file_leds   db 'C:\PROY_ATLANTIC\LEDS\leds.txt', 0   ;HARO CANDELARIO (DESARROLLO DE LEDS)
    file_print  db 'C:\PROY_ATLANTIC\PRINT\print.txt', 0 ;IBARRA GARCIA (DESARROLLO DE PRINT)
    file_LCD     db 'C:\PROY_ATLANTIC\LCDDISPLAY\lcd.txt', 0 ;DANIEL BARRERA (DESARROLLO DE LCD)
    file_seven  db 'C:\PROY_ATLANTIC\SEVEN\seven.txt', 0 ;IBARRA GARCIA (SEVEN SEGMENT)
    file_dot    db 'C:\PROY_ATLANTIC\DOTMATRX\dot.txt', 0 ;HARO CANDELARIO (DESARROLLO DE DOTMATRIX)
    file_traffic db 'C:\PROY_ATLANTIC\TRAFFIC\traffic.txt', 0 ;ENCISO RAMIREZ (DESARROLLO DE TRAFFIC LIGHTS)
    file_robot   db 'C:\PROY_ATLANTIC\ROBOT\robot.txt', 0 ;HARO CANDELARIO (DESARROLLO DE ROBOT)

    ; --- Contenido de los Archivos (Descripciones del Invernadero) ---
    msg_termo   db 'DEVICE: Termometro. USO: Monitoreo de temperatura para activacion de extractores. $'
    len_termo   dw  82

    msg_motor   db 'DEVICE: Motor Pasos. USO: Control de apertura automatica de ventilas laterales. $'
    len_motor   dw 80

    msg_leds    db 'DEVICE: Barra LED. USO: Indicadores visuales de nivel critico de humedad. $'
    len_leds    dw 74

    msg_print   db 'DEVICE: Impresora. USO: Generacion de bitacora diaria de condiciones climaticas. $'
    len_print   dw 81
    
    msg_lcd     db 'DEVICE: LCD Display. USO: Registro y control de inventario de insumos del invernadero. $'
    len_lcd     dw 88

    msg_seven   db 'DEVICE: Seven Segment. USO: Visualizacion de temperatura actual y temporizadores de riego. $'
    len_seven   dw 90

    msg_dot     db 'DEVICE: Dot Matrix. USO: Interfaz grafica para mostrar iconos de estado ambiental y alertas de texto dinamico. $'
    len_dot     dw 110

    msg_traffic  db 'DEVICE: Traffic Lights. USO: Control de semaforos para el area de carga y descarga. $'
    len_traffic  dw 83

    msg_robot    db 'DEVICE: Robot. USO: Brazo articulado para seleccion y empaque de producto terminado. $'
    len_robot    dw 84

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
    ; 1.- CREACIÓN DE CARPETAS (Directorios)
    ; ==========================================================
    
    ; CREAR RAÍZ
    CREAR_CARPETA raiz
    
    ; Crear Subcarpetas de Dispositivos
    CREAR_CARPETA dir_termo
    CREAR_CARPETA dir_motor
    CREAR_CARPETA dir_leds
    CREAR_CARPETA dir_print
    CREAR_CARPETA dir_LCD
    CREAR_CARPETA dir_seven
    CREAR_CARPETA dir_dot
    CREAR_CARPETA dir_traffic
    CREAR_CARPETA dir_robot

    ; ==========================================================
    ; 2.- CREACIÓN DE ARCHIVOS Y ESCRITURA DE USOS
    ; ==========================================================
    
    ; --- TERMOMETRO --- ENCISO RAMIREZ
    CREAR_ARCHIVO file_termo, 32   
    ESCRIBIR_ARCHIVO ID, len_termo, msg_termo
    CERRAR_ARCHIVO ID

    ; --- MOTOR --- HARO CANDELARIO
    CREAR_ARCHIVO file_motor, 32
    ESCRIBIR_ARCHIVO ID, len_motor, msg_motor
    CERRAR_ARCHIVO ID

    ; --- LEDS --- HARO CANDELARIO
    CREAR_ARCHIVO file_leds, 32
    ESCRIBIR_ARCHIVO ID, len_leds, msg_leds
    CERRAR_ARCHIVO ID

    ; --- IMPRESORA --- IBARRA GARCIA
    CREAR_ARCHIVO file_print, 32
    ESCRIBIR_ARCHIVO ID, len_print, msg_print
    CERRAR_ARCHIVO ID
    
    ; --- LCD --- DANIEL BARRERA
    CREAR_ARCHIVO file_LCD, 32
    ESCRIBIR_ARCHIVO ID, len_lcd, msg_lcd
    CERRAR_ARCHIVO ID

    ; --- Seven Segment --- IBARRA GARCIA
    CREAR_ARCHIVO file_seven, 32
    ESCRIBIR_ARCHIVO ID, len_seven, msg_seven
    CERRAR_ARCHIVO ID

    ; --- DOT MATRIX --- HARO CANDELARIO
    CREAR_ARCHIVO file_dot, 32
    ESCRIBIR_ARCHIVO ID, len_dot, msg_dot
    CERRAR_ARCHIVO ID

    ; --- Traffic Lights --- ENCISO RAMIREZ
    CREAR_ARCHIVO file_traffic, 32
    ESCRIBIR_ARCHIVO ID, len_traffic, msg_traffic
    CERRAR_ARCHIVO ID

    ; --- Robot --- HARO CANDELARIO
    CREAR_ARCHIVO file_robot, 32
    ESCRIBIR_ARCHIVO ID, len_robot, msg_robot
    CERRAR_ARCHIVO ID

    ; DETECCIÓN DE ERRORES
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
END
