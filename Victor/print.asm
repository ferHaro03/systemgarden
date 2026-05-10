.model small
.stack
.data            
    interfaz    db 'A continuacion las notificaciones', 10,13
                db 'Presiones 1 para salir [ ]$'  
                
    car         db 0
    
.code 
    mov ax, @data
    mov es, ax
    mov ds, ax
    
    interfazir:
        imp_sincolor interfaz
        
        ;notificaciones
        
        cursor 1, 22, 0 
        leerCaracter car
        cmp car, 1
        je fin
    
    fin:
        
end  