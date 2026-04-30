.section .data
  prompt_msg:  .ascii "The double is: "
  prompt_len:  .quad . - prompt_msg
  newline:     .ascii "\n"

.section .bss
  .lcomm buffer, 16
  .lcomm out_buf, 16

.section .text
  .globl _start

_start:
  mov $0, %rax
  mov $0, %rdi
  mov $buffer, %rsi
  mov $16, %rdx
  syscall

  movzbq (buffer), %rax
  sub $48, %rax

  add %rax, %rax

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

  mov $1, %rax
  mov $1, %rdi
  mov $prompt_msg, %rsi
  mov $prompt_len, %rdx
  syscall

  mov $1, %rax
  mov $1, %rdi
  mov %rdi, %rsi
  mov $out_buf, %rdx
  add $16, %rdx
  sub %rsi, %rdx
  mov $1, %rdi
  syscall

  mov $60, %rax
  xor %rdi, %rdi
  syscall
