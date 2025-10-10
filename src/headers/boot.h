%ifndef BOOT
%define BOOT

;check if the registers are in a valid state right after the _start,
;if check failed loop else terminate
;stack layout:
;+0: ret ptr
extern check_boot

%endif

