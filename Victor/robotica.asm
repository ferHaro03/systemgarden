   
robot proc
    #start=Robot.exe#     
    
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
endp 