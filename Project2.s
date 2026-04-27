.section .data
  prompt_msg:  .ascii "The double is: "
  prompt_len:  .quad . - prompt_msg
  newline:
