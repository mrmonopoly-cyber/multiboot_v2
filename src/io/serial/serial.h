%ifndef IO_SERIAL
%define IO_SERIAL

;print a base 10 number to COM1 port
;stack_layout:
;+0: ret ptr
;+4: byte value
extern write_base_10_unit


;print a u8 number to COM1 port in base 10
;stack_layout:
;+0: ret ptr
;+4: byte value
;+8: base 
extern write_base_u8_int

;print newline to COM1 port
;stack_layout:
;+0: ret ptr
extern write_new_line

;print a char to COM1 port
;stack_layout:
;+0: ret ptr
;+4: byte value
extern write_char

;print a string to COM1 port
;stack layout:
;+0: ret ptr
;+4: str ptr
extern write_str

%endif
