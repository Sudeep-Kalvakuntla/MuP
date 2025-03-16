.model tiny
  .186
  .data
  prompt1 db 'Enter Username $'

  maxuserinp db 10
  actuserinp db ?
  userinp db 10 dup(?)
  
  maxpassinp db 8
  actpassinp db ?
  passinp db 8 dup(?)

  user1 db 'illusion$'
  user1len dw 8h
  pass1 db 'sudeep$'
  pass1len dw 6h

  works db 'Hello $'
  star db '*$'

  .code
  .startup

  ;Printing the prompt and going to next line
  lea dx, prompt1
  call outString

  call outNewline

  ;Taking input of username
  lea dx, maxuserinp
  mov ah, 0Ah
  int 21h

  lea bx, userinp
  mov dl, actuserinp
  xor dh, dh
  mov si, dx
  mov byte ptr [bx + si], '$'

  ;Checking if both the usernames are the same
  cld
  lea di, userinp
  lea si, user1
  mov cx, user1len

  ;Debugging by printing
  ;call outNewline
  ;lea dx, userinp
  ;call outString
  ;call outNewline
  ;lea dx, user1
  ;call outString

  repe cmpsb
  jne Exit
  call outNewline
  
  ;Taking input of password
  mov si, 0h
  lea bx, passinp

  readLoop:
  inc si
  mov ah, 08h
  int 21h

  cmp al, 13
  je ReadPassDone

  mov dl, maxpassinp
  xor dh, dh
  cmp si, dx
  jae ReadPassDone

  mov byte ptr [bx + si], al

  lea dx, star
  call outString

  jna readLoop

  lea bx, passinp
  ;mov dl, cl
  ;xor dh, dh
  ;mov si, dx
  mov byte ptr [bx + si - 1], '$'

  ReadPassDone:
  call outNewline
  lea dx, passinp
  call outString
  call outNewline
  lea dx, pass1
  call outString

  ;Checking if both the usernames are the same
  cld
  mov cx, si
  lea di, passinp
  lea si, pass1

  ;Debugging by printing
  ;call outNewline
  ;lea dx, userinp
  ;call outString
  ;call outNewline
  ;lea dx, user1
  ;call outString

  repe cmpsb
  jne Exit
  call outNewline
  lea dx, works
  call outString
  call outNewline

  Exit:
  .exit

  outString:
    mov ah, 09h
    int 21h
    ret

  outNewline:
    mov dl, 10
    mov ah, 02h
    int 21h
    ret

end
