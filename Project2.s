.section .data
  prompt_msg:  .ascii "The double is: "
  prompt_len:  . - prompt_msg

.section .bss
  .lcomm buffer, 16
  .lcomm out_buf, 16

.section .text
  .globl _start

_start:
  # reading characters from input
  mov $0, %rax
  mov $0, %rdi
  mov $buffer, %rsi
  mov $16, %rdx
  syscall

  # string to int conversion
  xor %rax, %rax
  mov $buffer, %rsi
convert_input:
  movzx (%rsi), %rdx
  cmp $10, %dl
  je done_convert
  cmp $48, %dl
  jl skip_char
  cmp $57, %dl
  jg skip_char
  
  sub $48, %rdx
  imul $10, %rax
  add %rdx, %rax
  
skip_char:
  inc %rsi
  jmp convert_input

done_convert:
  # doubling the input
  add %rax, %rax
  
  # int back to string conversion for output
  mov $10, %rcx
  mov $out_buf, %rdi
  add $15, %rdi
  movb $10, (%rdi)
  
convert_loop:
  dec %rdi
  xor %rdx, %rdx
  div %rcx
  add $48, %dl
  mov %dl, (%rdi)
  cmp $0, %rax
  jne convert_loop

  # printing "The double is: "
  push $rdi
  mov $1, %rax
  mov $1, %rdi
  mov $prompt_msg, %rsi
  mov $prompt_len, %rdx
  syscall

  # printing the result of the doubling
  pop %rsi
  mov $out_buf, %rdx
  add $16, %rdx
  sub %rsi, %rdx
  mov $1, %rax
  mov $1, %rdi
  syscall

  mov $60, %rax
  xor %rdi, %rdi
  syscall
