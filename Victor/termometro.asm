MODULO_TERMOMETRO PROC
    interfaz_termometro:
        LIMPIAR_PANTALLA
        imp_color interfazTemperaturaTitulo, 22, 0, 0, 1, 26, 2ah               
        imp_color interfazTemperatura1, 24, 0, 0, 3, 25, 4eh
        imp_color interfazTemperatura2, 24, 0, 0, 5, 25, 4eh
        imp_color interfazTemperatura3, 24, 0, 0, 7, 25, 4eh
        imp_color interfazTemperatura4, 24, 0, 0, 9, 25, 4eh
        imp_color interfazTemperatura5, 24, 0, 0, 11, 25, 4eh
        imp_color interfazTemperatura6, 24, 0, 0, 13, 25, 4eh
        cursor 13, 33, 0 
        leerCaracter opcion_temperatura 
        
        cmp opcion_temperatura, '1'
        je encenderTermometro
        cmp opcion_temperatura, '2'
        je apagarTermometro
        cmp opcion_temperatura, '3'
        je leerTemperaturaSec
        cmp opcion_temperatura, '4'
        je finTermometro
        
    encenderTermometro:
        encTer
        jmp interfaz_termometro    
    apagarTermometro:        
        ApaTer
        jmp interfaz_termometro
    leerTemperaturaSec:
        mov al, 00000000b ;reiniciar seven segment
        mov dx, 2030h 
        out dx, al
        mov al, 00000000b
        mov dx, 2031h 
        out dx, al
        mov al, 00000000b
        mov dx, 2032h 
        out dx, al
        
        leerTer temp
        aam
        mov digitos[0], ah
        mov digitos[1], al
        
        mov si, 0
        mov puerto, 2030h 
        mov cx, 2
        cicloMen:  
            cmp digitos[si], 1
            je men1
            cmp digitos[si], 2
            je men2
            cmp digitos[si], 3
            je men3
            cmp digitos[si], 4
            je men4 
            cmp digitos[si], 5
            je men5
            cmp digitos[si], 6
            je men6
            cmp digitos[si], 7
            je men7
            cmp digitos[si], 8
            je men8
            cmp digitos[si], 9
            je men9
            cmp digitos[si], 10
            je men10
            cmp digitos[si], 11
            je men11
            cmp digitos[si], 12
            je men12  
            
            men1:
                sevSeg1 puerto
                jmp finMen 
            men2:
                sevSeg2 puerto
                jmp finMen    
            men3:
                sevSeg3 puerto
                jmp finMen
            men4:
                sevSeg4 puerto
                jmp finMen
            men5:
                sevSeg5 puerto
                jmp finMen
            men6:
                sevSeg6 puerto
                jmp finMen
            men7:
                sevSeg7 puerto
                jmp finMen
            men8:
                sevSeg8 puerto
                jmp finMen
            men9:
                sevSeg9 puerto
                jmp finMen
            men10:
                sevSeg10 puerto
                jmp finMay
            men11:
                sevSeg11 puerto
                jmp finMay
            men12:
                sevSeg12 puerto
                jmp finMay
                
            finMen:    
            inc si
            inc puerto
            jmp ciclo
            
            finMay:
            inc si
            inc puerto
            inc puerto
            
            ciclo:
            
            loop cicloMen
            jmp interfaz_termometro
                               
<<<<<<< HEAD
    finTermometro: 
        ret
=======
    finTermometro:
        RET 
>>>>>>> 293e6525288f81de799b8cb7ee0b5648cd390e37
MODULO_TERMOMETRO ENDP