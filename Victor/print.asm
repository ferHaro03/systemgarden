include print.lib
.model small
.stack
.data            
    interfaz    db 'A continuacion las notificaciones', 10,13
                db 'Presiones 1 para salir [ ]$'  
                
    car         db 0    
    
    msjAnomalia db 'Se ha detectado una anomalia', 10,13
    msjRevCult  db 'Es necesario revisar las plantaciones', 10,13
    msjRevVent  db 'Es necesario revisar la ventilacion', 10,13
    msjRevFuga  db 'Se ha detectado una fuga de calor', 10,13
    msjPeligro  db 'Cultivos en peligro, revisar pronto', 10,13  
    
.code 
    mov ax, @data
    mov es, ax
    mov ds, ax
    
    interfazir:
        imp_sincolor interfaz
         
        mrevcult
         
        cursor 1, 22, 0 
        leerCaracter car
        cmp car, 1
        je fin
    
    fin:
        mov ax, 4c00h
        int 21h    
end  