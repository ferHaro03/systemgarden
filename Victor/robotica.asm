include robotica_print.lib 

.model small     
.stack
.data   
    interfaz    db 'Manejador de robot     ',10,13
                db 'Opciones:              ',10,13
                db '[1] Avanzar            ',10,13
                db '[2] Girar a la derecha ',10,13
                db '[3] Girar a la izquierda',10,13 
                db '[4] Salir ',10,13
                db 'Seleccion: [ ]$'
    opcion      db 0  
                
    imp_sincolor macro cadena
           mov ah, 9
           lea dx, cadena
           int 21h
    imp_sincolor endm 
    
    cursor macro ren, col, pag
           mov ah, 2
           mov dh, ren
           mov dl, col
           mov bh, pag
           int 10h
    cursor endm   
    
    leerCaracter macro caracter
        mov ah, 1
        int 21h
        mov caracter, al 
    leerCaracter endm
.code    
    mov ax, @data
    mov ds, ax
    mov es, ax     
    
    irinterfaz:
        cursor 0,0,0
        imp_sincolor interfaz
        cursor 6, 12, 0                   
        leerCaracter opcion 
        cmp opcion, '1'
        je funAvan
        cmp opcion, '2'
        je funGirDer
        cmp opcion, '3'
        je funGirIzq
        cmp opcion, '4'  
        je fin
        jmp irinterfaz
    
    funAvan:
        avanzar
        jmp irinterfaz
    
    funGirDer:
        girarDerecha
        jmp irinterfaz   
    
    funGirIzq:
        girarIzquierda
        jmp irinterfaz
    
    fin:
        mov ax, 4c00h
        int 21h
end 