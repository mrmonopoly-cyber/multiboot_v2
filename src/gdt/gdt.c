#include "gdt.h"
#include <stdint.h>


int8_t gdt_new_descriptor(
    SegmentDescriptor* const o_descriptor,
    const uint8_t base,
    const uint8_t limit,
    const uint8_t flags,
    const uint8_t access)
{
  return 0;
}

void gdt_load(const GDTTable* const base, const uint16_t limit)
{
  struct __attribute__((__packed__))
  {
    uint16_t size;
    uint64_t addr;
  }GDTR = 
  {
    .addr = (uint64_t) base,
    .size = limit,
  };

  asm volatile("lgdt (%0)" : : "r"(&GDTR): "memory"); //load the gdt table
}
