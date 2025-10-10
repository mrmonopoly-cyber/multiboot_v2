%ifndef IO
%define IO

;print a byte on a port
;stack layout:
;+0: ret ptr
;+4: port
;+8: value
extern outb

%endif

