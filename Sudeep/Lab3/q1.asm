.model tiny
  .186
  .data
    max1 db 21
    act1 db ?
    str1 db 21 dup(?)
  .code
  .startup

    ; Taking string input
    lea bx, str1
    
    call readStr
    
    mov cl, act1
    xor ch, ch
    mov si, cx
    mov byte ptr [bx + si], '$'

    ; Printing new line
    mov dl, 0Ah
    call outChar

    ; Printing the string that was input earlier
    lea dx, str1
    call outStr
    

  .exit

readStr:
  lea dx, max1
  mov ah, 0ah
  int 21h

  ret

outChar:
  mov ah, 02h
  int 21h

  ret

outStr:
  mov ah, 09h
  int 21h
  ret

  end
