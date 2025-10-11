###USER INPUTS
BOOT_SYSTEM ?= MULTIBOOT_V2
####

BIN_IMAGE := isodir/boot/damos.bin
SRC := src
BUILD := build
DEPS := $(shell find $(SRC) -type f -name "*.S")
OBJS := $(patsubst $(SRC)/%.S,$(BUILD)/%.o,$(DEPS))
ASM := nasm
CC := ./i686-elf/bin/i686-elf-gcc
LD := ./i686-elf/bin/i686-elf-ld
AFLAGS := -f elf32
CFLAGS := -ffrestanding -nostdlib
WARNINGS :=  -Wall -Wextra
FEATURES := -D$(BOOT_SYSTEM)

all: build grub_image run

show:
	$(info $(DEPS))

run: grub_image
	qemu-system-i386 -serial stdio -cdrom damos.iso

grub_image: build $(BIN_IMAGE)
	$(shell  if ! grub-file --is-x86-multiboot2 $(BIN_IMAGE); then echo "damos.bin is not valid x86-multiboot format"; fi)
	grub-mkrescue -o damos.iso isodir


build: linker.ld $(OBJS)
	$(LD) -T linker.ld -o $(BIN_IMAGE) $(OBJS)


$(BUILD)/%.o: $(SRC)/%.S
	@mkdir -p $(dir $@)
	$(ASM) -o $@ $< $(AFLAGS) $(FEATURES)

$(BUILD)/%.o: $(SRC)/%.c
	@mkdir -p $(dir $@)
	$(CC) -o $@ $< $(CFLAGS) $(FEATURES) $(WARNINGS)

clean:
	rm -rf ./isodir/boot/*.bin *.iso ./build/*

