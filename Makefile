###USER INPUTS
BOOT_SYSTEM ?= MULTIBOOT_V2
####

BIN_IMAGE := isodir/boot/damos.bin
SRC := src
BUILD := build
DEPS := $(shell find $(SRC) -type f -name "*.S")
OBJS := $(patsubst $(SRC)/%.S,$(BUILD)/%.o,$(DEPS))
CC := nasm
LD := ./i686-elf/bin/i686-elf-ld
CFLAGS := -f elf32
WARNINGS := 
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
	$(CC) -o $@ $< $(CFLAGS) $(FEATURES) $(WARNINGS)

clean:
	rm -rf ./isodir/boot/*.bin *.iso ./build/*

