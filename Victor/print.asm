
modulo_print proc 
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
        
include print.lib   
modulo_print endp  