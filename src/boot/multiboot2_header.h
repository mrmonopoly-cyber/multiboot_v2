#ifndef MULTIBOOT2
#define MULTIBOOT2
#include <stdint.h>

#define V2_MAGIC (0xE85250D6)
#define V2_ARCH (0)
#define HEADER_LENGTH(TAGS_NUM) ((uint32_t) sizeof(multiboot_v2) + TAGS_NUM * (uint32_t) sizeof(MulitbootGeneralTag))

typedef struct
{
  uint16_t type;
  uint16_t flags;
  uint32_t size;
}MulitbootGeneralTag;

#define END_TAG (MulitbootGeneralTag){.type=0, .flags=0, .size=8,}
#define EFI_BOOT_SERIVE_TAG (MulitbootGeneralTag){.type=7, .flags=0, .size=8,}

typedef struct __attribute__((aligned(8)))
{
  uint32_t magic;
  uint32_t arch;
  uint32_t header_length;
  uint32_t checksum;

  MulitbootGeneralTag tags[];

}MultibootV2Header;

#endif // !MULTIBOOT2
