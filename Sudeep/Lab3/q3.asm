.model tiny
  .186
  .data 
  vowels db 'aeiouAEIOU'
  vowels_len dw 10

  max1 db 32
  act1 db ?
  inpstr db 32 dup(?)

  num dw ?

  .code 
  .startup

  ;String input
  lea dx, max1
  mov ah, 0ah
  int 21h

  lea di, inpstr
  lea si, vowels
  mov dx, vowels_len
  mov cl, act1
  xor ch, ch
  xor bx, bx
  xor ah, ah

  vowelLoop:
    mov al, [si]

    strLoop:
      mov cl, act1
      cld 
      repne scasb
      jnz Lite
      inc bx
      Lite:

    inc si
    dec dx
    jnz vowelLoop

  call outNewline
  mov ax, bx
  call showNum

  .exit

showNum:
  mov cx, 0
  mov bx, 10

convertLoop:
  mov dx, 0
  div bx
  push dx 
  inc cx 
  cmp ax, 0
  jnz convertLoop

printLoop:
  pop dx 
  add dl, '0'
  mov ah, 02h
  int 21h
  dec cx 
  jnz printLoop
  ret

 outNewline:
    mov dl, 10
    mov ah, 02h
    int 21h
    ret
end
