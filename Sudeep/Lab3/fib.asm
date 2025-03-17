;C Code   
;------
;#include <stdio.h>

;int fibonacci(int n);

;int main(){
;	int n;
;	int fib;
;	printf("Enter the number:");
;	scanf("%d",&n);
;	fib = fibonacci(n);
;	printf("%d\n",fib);
;	return 0;
;}

;int fibonacci(int n){
;	int tmp1,tmp2,tmp3;
;	if(n==0 || n==1)
;		return 1;
;	else{
;		tmp1 = fibonacci(n-1);
;		tmp2 = fibonacci(n-2);
;		tmp3 = tmp1+tmp2;
;		return tmp3;
;	}
;}

;stack frame format        

;argument
;bp
;return address 
;return value from first function call
;argument for first function (n-1) 
;bp
;return value from second function call
;argument for second function (n-2) 
;bp


.model tiny
.186
.data  
message db 'Enter the number:$' ;Message to display 
n dw 8                          ;Variable to store number entered by user                    
fib dw 1 dup(?)                 ;Fibonacci number calculated by the recursive function
.code
.startup
main:        
    ;display Enter num string
    lea dx,message  ; Load string address
    mov ah, 09H     ; argument to print string
    int 21H         ; Call interrupt 21    
    ;read the number from keyboard
    call readNum      
                
   ;call to fibonacci function
    push ax ;dummy to store final return
    push n  ;function argument
    push bp ;always push bp to stack before a subroutine call
    call fibonacci     
    pop bp  ;always restore bp once returned from subroutine
    pop ax  ;pop and discard function argument
    pop fib ;store final result to memory    

    ;print the result on screen
    add dl, 10    ; move the display prompt to a new line
    mov ah, 02H    ; INT21 argument to print one character
    int 21H
    mov ax,fib
    call showNum
.exit


;subroutine to read a number from keyboard. There is no sanity check to confirm number can
;be stored using 16 bits
readNum:    
    ;Read number from keyboard
    mov bx, 0                ; BX will store the final number
    readLoop:
        mov AH, 01H               ; argument to read 1 character from keyboard
        int 21H                   ; Read from keyboard
        cmp AL, 13                ; Check if user pressed enter
        je  storeNum              ; If Enter is pressed, store the number

        sub al, '0'               ; else ASCII to integer
        cmp al, 9                 ; Ensure it's a valid digit
        ja  readLoop             ; Ignore invalid input

       
        mov ch, 0
        mov cl, al                ; store newly entered digit in cx
        mov ax, bx                ; copy current number to ax                  
        mov dx, 10
        mul dx                    ; ax = ax*10 
        add ax, cx                ; ax = ax*10 + cx 
        mov bx, ax                ; store the new number in bx
        jmp readLoop              ; continue reading
    storeNum:
        mov n, bx             ; Store the final number 
        ret

;Fibonacci subroutine
;Assumes the input is a 16 bit number and output is also a 16 bit number
;No sanity check for overflow
fibonacci:
    mov bp,sp     ;copy sp to bp (base of stack frame)
    mov bx,[bp+4] ;get function argument to bx
    cmp bx,0      ;compare n == 0?
    jz fib1       ;if n==0, return 1
    cmp bx,1      ;compare n == 1?
    jz fib1       ;if n==1, return 1
    push ax       ;dummy to store recursive function return value
    dec bx        ;n-1
    push bx       ;argument for next function call (n-1) 
    push bp       ;always push bp to stack before a subroutine call
    call fibonacci     
    pop bp        ;always restore bp once returned from subroutine
    mov bx,[bp+4] ;get function argument to bx
    sub bx,2      ;n-2
    push ax       ;dummy for next function return value
    push bx       ;arment for next function call (n-2)  
    push bp       ;always push bp to stack before a subroutine call
    call fibonacci 
    pop bp        ;always restore bp once returned from subroutine
    pop bx        ;pop and remove second function argument (n-2)
    pop bx        ;get the return value from function call (n-2)     
    pop cx        ;pop and remove first function argument (n-1)
    pop cx        ;get return value from function call (n-1)
    add bx,cx     ;f(n-1)+f(n-2)
    mov [bp+6],bx ;store the return value in the stack frame of calling function
    ret           ;return
    fib1:
        mov word ptr [bp+6],1
        ret    
        
        
        
;Subroutine to display a number on screen. Assumes the number to be printed is in AX register        
showNum:
    mov cx, 0       ; CX = digit count
    mov bx, 10      ; Divisor

convertLoop:
    mov dx, 0       ; Clear DX for division
    div bx          ; AX / 10, remainder in DX
    push dx         ; using stack here since the last digit needs to be displayed first
    inc cx          ; Increment digit count
    cmp ax,0        ; Check if AX is 0
    jnz convertLoop ; Continue if not zero

printLoop:
    pop dx         ; Get digit from stack
    add dl, '0'    ; Convert to ASCII
    mov ah, 02H    ; INT21 argument to print one character
    int 21H
    dec cx
    jnz printLoop             ; Repeat for all digits
    ret
   
end        
