#include <stdint.h>

#define V2_MAGIC (0xE85250D6)
#define V2_ARCH (0)
#define HEADER_LENGTH ((uint32_t) sizeof(multiboot_v2))

typedef struct
{
  uint16_t type;
  uint16_t flags;
  uint32_t size;
}MulitbootGeneralTag;

#define END_TAG (MulitbootGeneralTag){.type=0, .flags=0, .size=8,}
#define EFI_BOOT_SERIVE_TAG (MulitbootGeneralTag){.type=7, .flags=0, .size=8,}

typedef struct
{
  uint16_t type;
  uint16_t flags;
  uint32_t size;
}EfiBootServiceTag;

static struct 
{
  uint32_t magic;
  uint32_t arch;
  uint32_t header_length;
  uint32_t checksum;

  MulitbootGeneralTag tags[];

}multiboot_v2 = 
{
  .magic = V2_MAGIC,
  .arch = V2_ARCH,
  .header_length = HEADER_LENGTH,
  .checksum = -(V2_MAGIC + V2_ARCH + HEADER_LENGTH),

  .tags = 
  {
    EFI_BOOT_SERIVE_TAG,

    END_TAG, //INFO: must be at the end
  }
};

__attribute__((__section__(".bss"))) //16 KB
uint16_t stack[16384];


__attribute__((__naked__))
void _start(void)
{
  asm volatile("cli");

  asm volatile("hlt");
}
