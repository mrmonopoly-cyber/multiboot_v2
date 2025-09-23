BIN_IMAGE := isodir/boot/damos.bin
SRC := src
BUILD := build
DEPS := $(shell find $(SRC) -type f -name "*.S")
OBJS := $(patsubst $(SRC)/%.S,$(BUILD)/%.o,$(DEPS))
CC := ./i686-elf/bin/i686-elf-gcc
CFLAGS := -std=gnu99 -ffreestanding -O2 
WARNINGS := -Wall -Wextra

all: build grub_image run

show:
	$(info $(DEPS))

run: grub_image
	qemu-system-i386 -cdrom damos.iso

grub_image: build $(BIN_IMAGE)
	$(shell  if ! grub-file --is-x86-multiboot2 $(BIN_IMAGE); then echo "damos.bin is not valid x86-multiboot format"; fi)
	grub-mkrescue -o damos.iso isodir


build: linker.ld $(OBJS)
	$(CC) -T linker.ld -o $(BIN_IMAGE) $(OBJS) -ffreestanding -O2 -nostdlib -lgcc


$(BUILD)/%.o: $(SRC)/%.S
	@mkdir -p $(dir $@)
	$(CC) -c -o $@ $< $(CFLAGS) $(WARNINGS)

clean:
	rm -rf ./isodir/boot/*.bin *.iso ./build/*

