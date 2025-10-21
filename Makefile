###USER INPUTS
BOOT_SYSTEM ?= MULTIBOOT_V2
EXTRA ?= 
####

BIN_IMAGE := isodir/boot/damos.bin
SRC := src
BUILD := build
DEPS := $(shell find $(SRC) -type f -name "*.c")
OBJS := $(patsubst $(SRC)/%.c,$(BUILD)/%.o,$(DEPS))
ASM := nasm
CC := x86_64-elf-gcc
LD := x86_64-elf-ld
AFLAGS := -f elf64
CFLAGS := -ffreestanding -nostdlib -m64 $(EXTRA)
WARNINGS :=  -Wall -Wextra
FEATURES := -D$(BOOT_SYSTEM)

LINKER := $(SRC)/linker.ld

all: build grub_image run

show:
	$(info $(DEPS))

run: grub_image
	qemu-system-x86_64 \
		-s -S \
		-bios /usr/share/edk2-ovmf/x64/OVMF.4m.fd\
		-serial none\
		-cdrom damos.iso \
		-net none \
		&
	gdb

grub_image: $(BIN_IMAGE)
	$(shell  if ! grub-file --is-x86-multiboot2 $(BIN_IMAGE); then echo "damos.bin is not valid x86-multiboot format"; fi)
	grub-mkrescue -o damos.iso isodir

$(BIN_IMAGE): build

build: $(LINKER) $(OBJS)
	$(CC) -T $(LINKER) $(CFLAGS) $(WARNINGS) -o $(BIN_IMAGE) $(OBJS)

$(BUILD)/%.o: $(SRC)/%.c
	@mkdir -p $(dir $@)
	$(CC) -c -o $@ $< $(CFLAGS) $(FEATURES) $(WARNINGS)

clean:
	rm -rf ./isodir/boot/*.bin *.iso ./build

