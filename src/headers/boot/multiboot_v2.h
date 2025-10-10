;doc info: https:/www.gnu.org/software/grub/manual/multiboot2/multiboot.html

%define MAGIC 0xE85250D6                                          ;from specs
%define ARCH 0                                                    ;32-bit (protected mode) of i386 
%define HEADER_LENGTH (multiboot2_header_end - multiboot2_header) ;header size
%define CHECKSUM -(MAGIC + ARCH + HEADER_LENGTH)                  ;added to ‘magic’,‘architecture’,‘header_length’, = zero.


section .multiboot
align 8
multiboot2_header:
dd MAGIC
dd ARCH 
dd HEADER_LENGTH 
dd CHECKSUM

;*tags
framebuffer_tag:
dw 5 ;type=5 (frame buffer)
dw 0 ;flags
dd (framebuffer_tag_end - framebuffer_tag);size
dd 0;width
dd 0;height
dd 0;depth
framebuffer_tag_end:

end_tag:
dw 0 ;type=0 (end)
dd 8 ;size=8
multiboot2_header_end:
