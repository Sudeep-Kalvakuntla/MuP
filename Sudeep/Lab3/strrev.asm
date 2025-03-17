.model tiny
  .186
  .data 
  max1 db 32
  act1 db ?
  inpstr db 32 dup(?)

  reved db 32 dup(?)

  .code 
  .startup
    ;String input
    lea dx, max1
    mov ah, 0ah
    int 21h

    std
    mov cl, act1
    xor ch, ch
    lea bx, inpstr
    ;lea dx, act1
    mov di, cx
    lea si, [bx + di - 1]
    lea di, reved
    rep movsb


    mov cl, act1
    xor ch, ch
    lea bx, inpstr
    ;lea dx, act1
    mov di, cx
    lea si, [bx + di - 1]
    mov byte ptr [si], '$'

    mov dl, 10
    mov ah, 02h
    int 21h
    ret

    lea dx, reved
    mov ah, 09h
    int 21h
    ret
  .exit
end
