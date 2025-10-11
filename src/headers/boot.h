%ifndef BOOT
%define BOOT

;check if the registers are in a valid state right after the _start,
;if check failed loop else terminate
;stack layout:
;+0: ret ptr
extern boot_check

;return value of the requested info based on the protocol if exist, else -1
;stack layout:
;+0: ret ptr
;+4: parameter specifier (u32 according to the protocol)
extern boot_get_info

%endif
