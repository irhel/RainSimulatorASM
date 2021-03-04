JMP main



; Mini Colorful Rain Simulator - Make sure the processor runs at 1kHz. ;
; To change the color of the rain press any key. ;


welcome: DB "Rain Simulator" ;This is the title that we will display to the user ;
DB 0

waitcount: DW 0 
waitlimit: DW 50 ;This is the amount of time we are waiting before we redraw a droplet;

white: DB 255 ; We use this to clear a drawing ;
currentcolor: DB 0 ;Initially our droplet are all black. ;

;We maintain the state of the animation so that we may clear the previous position of the droplets ;
previouspos1: DW 0
currentpos1: DW 0x0300
previouspos2: DW 0 
currentpos2: DW 0x0302
previouspos3: DW 0 
currentpos3: DW 0x0304
previouspos4: DW 0 
currentpos4: DW 0x0306

previouspos5: DW 0 
currentpos5: DW 0x0308

previouspos6: DW 0 
currentpos6: DW 778


previouspos7: DW 0 
currentpos7: DW 780

previouspos8: DW 0 
currentpos8: DW 782

; The rate of streams of rain - some streams of rain fall much faster than others - this in turn gives it a bit more natural look. ;
rate1: DW 16
rate2: DW 32
rate3: DW 32
rate4: DW 16
rate5: DW 48
rate6: DW 16
rate7: DW 32
rate8: DW 16




;We wait some amount before redrawing. ;

wait:
    MOV A, [waitcount]
    MOV B, [waitlimit]
    CMP A, B
    JE done
    JMP tick
tick:
    MOV A, [waitcount]
    ADD A, 1
    MOV [waitcount], A
    JMP wait
done:
    MOV A, 0
    MOV [waitcount], A
    RET

;We clear the previous positions of all the droplets. ;

clear:
    MOV A, [previouspos1]
    MOVB BL, [white]
    MOVB [A], BL
    
    
    MOV A, [previouspos2]
    MOVB BL, [white]
    MOVB [A], BL
    
    
    MOV A, [previouspos3]
    MOVB BL, [white]
    MOVB [A], BL
    
    MOV A, [previouspos4]
    MOVB BL, [white]
    MOVB [A], BL
    
    
    MOV A, [previouspos5]
    MOVB BL, [white]
    MOVB [A], BL
    
    MOV A, [previouspos6]
    MOVB BL, [white]
    MOVB [A], BL
    
    MOV A, [previouspos7]
    MOVB BL, [white]
    MOVB [A], BL
    
    MOV A, [previouspos8]
    MOVB BL, [white]
    MOVB [A], BL
    
    RET
    
;We draw the streams in the currentcolor. ;
drawstream: 
    MOVB BL, [currentcolor]
    MOV A, [currentpos1]
    MOVB [A], BL
    
    MOVB BL, [currentcolor]
    MOV A, [currentpos2]
    MOVB [A], BL
    
    MOVB BL, [currentcolor]
    MOV A, [currentpos3]
    MOVB [A], BL
    
    MOVB BL, [currentcolor]
    MOV A, [currentpos4]
    MOVB [A], BL
    
    MOVB BL, [currentcolor]
    MOV A, [currentpos5]
    MOVB [A], BL
    
    MOVB BL, [currentcolor]
    MOV A, [currentpos6]
    MOVB [A], BL
    
    MOVB BL, [currentcolor]
    MOV A, [currentpos7]
    MOVB [A], BL
    
    MOVB BL, [currentcolor]
    MOV A, [currentpos8]
    MOVB [A], BL
    RET
    
    
update:
    MOV A, [currentpos1]
    MOV [previouspos1], A
    ADD A, [rate1]
    CMP A, 1024
    JAE reset1
    MOV [currentpos1], A
    
cont1: 
    MOV A, [currentpos2]
    MOV [previouspos2], A
    ADD A, [rate2]
    CMP A, 1024
    JAE reset2
    MOV [currentpos2], A
 
cont2:   
    MOV A, [currentpos3]
    MOV [previouspos3], A
    ADD A, [rate3]
    CMP A, 1024
    JAE reset3
    MOV [currentpos3], A
cont3:
    MOV A, [currentpos4]
    MOV [previouspos4], A
    ADD A, [rate4]
    CMP A, 1024
    JAE reset4
    MOV [currentpos4], A
    
cont4:
    MOV A, [currentpos5]
    MOV [previouspos5], A
    ADD A, [rate5]
    CMP A, 1024
    JAE reset5
    MOV [currentpos5], A
    
cont5:
    MOV A, [currentpos6]
    MOV [previouspos6], A
    ADD A, [rate6]
    CMP A, 1024
    JAE reset6
    MOV [currentpos6], A
    
cont6:
    MOV A, [currentpos7]
    MOV [previouspos7], A
    ADD A, [rate7]
    CMP A, 1024
    JAE reset7
    MOV [currentpos7], A
cont7:
    MOV A, [currentpos8]
    MOV [previouspos8], A
    ADD A, [rate8]
    CMP A, 1024
    JAE reset8
    MOV [currentpos8], A
cont8:
    RET
    
reset1:
    MOV [currentpos1], 0x0300
    JMP cont1

reset2:
    MOV [currentpos2], 0x0302
    JMP cont2

reset3:
    MOV [currentpos3], 0x0304
    JMP cont3

reset4:
    MOV [currentpos4], 0x0306
    JMP cont4

reset5:
    MOV [currentpos5], 0x0308
    JMP cont5
    
reset6:
    MOV [currentpos6], 778
    JMP cont6
    
reset7:
    MOV [currentpos7], 780
    JMP cont7
    
reset8:
    MOV [currentpos8], 782
    JMP cont8

resetcolor:
    MOVB [currentcolor], 0
    JMP skip
anim:

    ;Since anim is like our animation loop we can use it
    ; to poll and check the keyboard and when key is pressed
    ; we change color;
    IN 5
    CMP A, 1
    JNE skip
    IN 6
    
    MOVB BL, [currentcolor]
    ADDB BL, 10
    CMPB BL, 255
    JAE resetcolor
    MOVB [currentcolor], BL
    
  
skip:
    CALL drawstream
    
    CALL clear
    CALL wait
    
    CALL update
    CALL anim
    
    
printWelcome:
    MOV B, 0x02e0
printchar:
    MOVB CL, [A]
    CMPB CL, 0
    JE doneprinting
    MOVB [B], CL
    INC A
    INC B
    JMP printchar
doneprinting:
    RET

main:
    MOV SP, 0x02df

    MOV A, welcome
    CALL printWelcome
    CALL anim
    
    
    HLT
