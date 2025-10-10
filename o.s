
isodir/boot/damos.bin:     file format elf32-i386

Contents of section .text:
 1000 d65052e8 00000000 2a000000 00afad17  .PR.....*.......
 1010 05000000 14000000 00000000 00000000  ................
 1020 00000000 00000800 00006690 66906690  ..........f.f.f.
 1030 31c031d2 668b5424 048a4424 08eec390  1.1.f.T$..D$....
 1040 8b442404 04305068 f8030000 e8dfffff  .D$..0Ph........
 1050 ff83c408 c331c031 db31c931 d25589e5  .....1.1.1.1.U..
 1060 83ec04c7 45fc0000 00008b5d 0889d8ba  ....E......]....
 1070 00000000 8b4d0cf7 f152ff45 fc83f800  .....M...R.E....
 1080 740489c3 ebe78b4d fc83f900 7409e8ad  t......M....t...
 1090 ffffff58 49ebf289 ec5dc36a 0d68f803  ...XI....].j.h..
 10a0 0000e889 ffffff83 c4086a0a 68f80300  ..........j.h...
 10b0 00e87aff ffff83c4 08c331c0 31db8a44  ..z.......1.1..D
 10c0 24045068 f8030000 e863ffff ff83c408  $.Ph.....c......
 10d0 c38b7424 048a063c 00741631 c0668b06  ..t$...<.t.1.f..
 10e0 5068f803 0000e845 ffffff83 c40846eb  Ph.....E......F.
 10f0 e4c36690 66906690 66906690 66906690  ..f.f.f.f.f.f.f.
 1100 fabc0080 00003d89 62d73674 0d680020  ......=.b.6t.h. 
 1110 0000e8ba ffffff83 c40489c6 6a0a53e8  ............j.S.
 1120 31ffffff 83c4086a 206a20e8 25ffffff  1......j j .%...
 1130 83c408e8 63ffffff 83c40468 0e200000  ....c......h. ..
 1140 e88cffff ff83c404 ebfe               ..........      
Contents of section .rodata:
 2000 696e7661 6c69645f 626f6f74 0d0a6865  invalid_boot..he
 2010 6c6c6f0d 0a                          llo..           
Contents of section .data:
 3000 0c000000                             ....            

Disassembly of section .text:

00001000 <multiboot2_header>:
    1000:	d6                   	(bad)
    1001:	50                   	push   %eax
    1002:	52                   	push   %edx
    1003:	e8 00 00 00 00       	call   1008 <multiboot2_header+0x8>
    1008:	2a 00                	sub    (%eax),%al
    100a:	00 00                	add    %al,(%eax)
    100c:	00                   	.byte 0
    100d:	af                   	scas   %es:(%edi),%eax
    100e:	ad                   	lods   %ds:(%esi),%eax
    100f:	17                   	pop    %ss

00001010 <framebuffer_tag>:
    1010:	05 00 00 00 14       	add    $0x14000000,%eax
	...

00001024 <end_tag>:
    1024:	00 00                	add    %al,(%eax)
    1026:	08 00                	or     %al,(%eax)
	...

0000102a <multiboot2_header_end>:
    102a:	66 90                	xchg   %ax,%ax
    102c:	66 90                	xchg   %ax,%ax
    102e:	66 90                	xchg   %ax,%ax

00001030 <outb>:
    1030:	31 c0                	xor    %eax,%eax
    1032:	31 d2                	xor    %edx,%edx
    1034:	66 8b 54 24 04       	mov    0x4(%esp),%dx
    1039:	8a 44 24 08          	mov    0x8(%esp),%al
    103d:	ee                   	out    %al,(%dx)
    103e:	c3                   	ret
    103f:	90                   	nop

00001040 <write_base_10_unit>:
    1040:	8b 44 24 04          	mov    0x4(%esp),%eax
    1044:	04 30                	add    $0x30,%al
    1046:	50                   	push   %eax
    1047:	68 f8 03 00 00       	push   $0x3f8
    104c:	e8 df ff ff ff       	call   1030 <outb>
    1051:	83 c4 08             	add    $0x8,%esp
    1054:	c3                   	ret

00001055 <write_base_u8_int>:
    1055:	31 c0                	xor    %eax,%eax
    1057:	31 db                	xor    %ebx,%ebx
    1059:	31 c9                	xor    %ecx,%ecx
    105b:	31 d2                	xor    %edx,%edx
    105d:	55                   	push   %ebp
    105e:	89 e5                	mov    %esp,%ebp
    1060:	83 ec 04             	sub    $0x4,%esp
    1063:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    106a:	8b 5d 08             	mov    0x8(%ebp),%ebx

0000106d <write_base_u8_int.store_unit>:
    106d:	89 d8                	mov    %ebx,%eax
    106f:	ba 00 00 00 00       	mov    $0x0,%edx
    1074:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    1077:	f7 f1                	div    %ecx
    1079:	52                   	push   %edx
    107a:	ff 45 fc             	incl   -0x4(%ebp)
    107d:	83 f8 00             	cmp    $0x0,%eax
    1080:	74 04                	je     1086 <write_base_u8_int.print_digits>
    1082:	89 c3                	mov    %eax,%ebx
    1084:	eb e7                	jmp    106d <write_base_u8_int.store_unit>

00001086 <write_base_u8_int.print_digits>:
    1086:	8b 4d fc             	mov    -0x4(%ebp),%ecx

00001089 <write_base_u8_int.print_digits_loop>:
    1089:	83 f9 00             	cmp    $0x0,%ecx
    108c:	74 09                	je     1097 <write_base_u8_int.exit>
    108e:	e8 ad ff ff ff       	call   1040 <write_base_10_unit>
    1093:	58                   	pop    %eax
    1094:	49                   	dec    %ecx
    1095:	eb f2                	jmp    1089 <write_base_u8_int.print_digits_loop>

00001097 <write_base_u8_int.exit>:
    1097:	89 ec                	mov    %ebp,%esp
    1099:	5d                   	pop    %ebp
    109a:	c3                   	ret

0000109b <write_new_line>:
    109b:	6a 0d                	push   $0xd
    109d:	68 f8 03 00 00       	push   $0x3f8
    10a2:	e8 89 ff ff ff       	call   1030 <outb>
    10a7:	83 c4 08             	add    $0x8,%esp
    10aa:	6a 0a                	push   $0xa
    10ac:	68 f8 03 00 00       	push   $0x3f8
    10b1:	e8 7a ff ff ff       	call   1030 <outb>
    10b6:	83 c4 08             	add    $0x8,%esp
    10b9:	c3                   	ret

000010ba <write_char>:
    10ba:	31 c0                	xor    %eax,%eax
    10bc:	31 db                	xor    %ebx,%ebx
    10be:	8a 44 24 04          	mov    0x4(%esp),%al
    10c2:	50                   	push   %eax
    10c3:	68 f8 03 00 00       	push   $0x3f8
    10c8:	e8 63 ff ff ff       	call   1030 <outb>
    10cd:	83 c4 08             	add    $0x8,%esp
    10d0:	c3                   	ret

000010d1 <write_str>:
    10d1:	8b 74 24 04          	mov    0x4(%esp),%esi

000010d5 <write_str.next_char>:
    10d5:	8a 06                	mov    (%esi),%al
    10d7:	3c 00                	cmp    $0x0,%al
    10d9:	74 16                	je     10f1 <write_str.done_str>
    10db:	31 c0                	xor    %eax,%eax
    10dd:	66 8b 06             	mov    (%esi),%ax
    10e0:	50                   	push   %eax
    10e1:	68 f8 03 00 00       	push   $0x3f8
    10e6:	e8 45 ff ff ff       	call   1030 <outb>
    10eb:	83 c4 08             	add    $0x8,%esp
    10ee:	46                   	inc    %esi
    10ef:	eb e4                	jmp    10d5 <write_str.next_char>

000010f1 <write_str.done_str>:
    10f1:	c3                   	ret
    10f2:	66 90                	xchg   %ax,%ax
    10f4:	66 90                	xchg   %ax,%ax
    10f6:	66 90                	xchg   %ax,%ax
    10f8:	66 90                	xchg   %ax,%ax
    10fa:	66 90                	xchg   %ax,%ax
    10fc:	66 90                	xchg   %ax,%ax
    10fe:	66 90                	xchg   %ax,%ax

00001100 <_start>:
    1100:	fa                   	cli
    1101:	bc 00 80 00 00       	mov    $0x8000,%esp
    1106:	3d 89 62 d7 36       	cmp    $0x36d76289,%eax
    110b:	74 0d                	je     111a <_start.start_boot_check>
    110d:	68 00 20 00 00       	push   $0x2000
    1112:	e8 ba ff ff ff       	call   10d1 <write_str>
    1117:	83 c4 04             	add    $0x4,%esp

0000111a <_start.start_boot_check>:
    111a:	89 c6                	mov    %eax,%esi
    111c:	6a 0a                	push   $0xa
    111e:	53                   	push   %ebx
    111f:	e8 31 ff ff ff       	call   1055 <write_base_u8_int>
    1124:	83 c4 08             	add    $0x8,%esp
    1127:	6a 20                	push   $0x20
    1129:	6a 20                	push   $0x20
    112b:	e8 25 ff ff ff       	call   1055 <write_base_u8_int>
    1130:	83 c4 08             	add    $0x8,%esp
    1133:	e8 63 ff ff ff       	call   109b <write_new_line>
    1138:	83 c4 04             	add    $0x4,%esp
    113b:	68 0e 20 00 00       	push   $0x200e
    1140:	e8 8c ff ff ff       	call   10d1 <write_str>
    1145:	83 c4 04             	add    $0x4,%esp

00001148 <_hlt>:
    1148:	eb fe                	jmp    1148 <_hlt>
