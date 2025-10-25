#ifndef __GDT_TABLE__
#define __GDT_TABLE__

#include <stdint.h>

/*
 * INFO: BASE:
 *
 *  A 32-bit value containing the linear address where the segment begins.
 *
 * INFO: LIMIT:
 *
 *  A 20-bit value, tells the maximum addressable unit, either in 1 byte units, or in 4KiB pages.
 *  Hence, if you choose page granularity and set the Limit value to 0xFFFFF the segment will span the full 4 GiB address space in 32-bit mode.
 *
 * INFO: ACCESS BYTE:
 *
 * P: Present bit. Allows an entry to refer to a valid segment. Must be set (1) for any valid segment.
 *
 * DPL: Descriptor privilege level field. Contains the CPU Privilege level of the segment. 0 = highest privilege (kernel), 3 = lowest privilege (user applications).
 *
 * S: Descriptor type bit. If clear (0) the descriptor defines a system segment (eg. a Task State Segment). If set (1) it defines a code or data segment.
 *
 * E: Executable bit. If clear (0) the descriptor defines a data segment. If set (1) it defines a code segment which can be executed from.
 *
 * DC: Direction bit/Conforming bit.
 *     For data selectors: Direction bit. If clear (0) the segment grows up. If set (1) the segment grows down, ie. the Offset has to be greater than the Limit.
 *     For code selectors: Conforming bit.
 *       If clear (0) code in this segment can only be executed from the ring set in DPL.
 *       If set (1) code in this segment can be executed from an equal or lower privilege level. 
 *       For example, code in ring 3 can far-jump to conforming code in a ring 2 segment. 
 *       The DPL field represent the highest privilege level that is allowed to execute the segment. 
 *       For example, code in ring 0 cannot far-jump to a conforming code segment where DPL is 2, while code in ring 2 and 3 can. 
 *       Note that the privilege level remains the same, ie. a far-jump from ring 3 to a segment with a DPL of 2 remains in ring 3 after the jump.
 *
 * RW: Readable bit/Writable bit.
 *   For code segments: Readable bit. If clear (0), read access for this segment is not allowed. If set (1) read access is allowed. Write access is never allowed for code segments.
 *   For data segments: Writeable bit. If clear (0), write access for this segment is not allowed. If set (1) write access is allowed. Read access is always allowed for data segments.
 *
 * A:  Accessed bit. The CPU will set it when the segment is accessed unless set to 1 in advance. 
 *     This means that in case the GDT descriptor is stored in read only pages and this bit is set to 0, the CPU trying to set this bit will trigger a page fault.
 *     Best left set to 1 unless otherwise needed.
 *
 * INFO: FLAGS:
 *
 * L: Long-mode code flag. 
 *    If set (1), the descriptor defines a 64-bit code segment. When set, DB should always be clear. 
 *    For any other type of segment (other code types or any data segment), it should be clear (0).
 *
 * DB: Size flag. 
 *  If clear (0), the descriptor defines a 16-bit protected mode segment. 
 *  If set (1) it defines a 32-bit protected mode segment. A GDT can have both 16-bit and 32-bit selectors at once.
 *
 * G: Granularity flag, indicates the size the Limit value is scaled by. 
 *  If clear (0), the Limit is in 1 Byte blocks (byte granularity). 
 *  If set (1), the Limit is in 4 KiB blocks (page granularity).
*/

typedef enum 
{
  GDTSECTOR_FLAGS_L = (1<<1),
  GDTSECTOR_FLAGS_DB = (1<<2),
  GDTSECTOR_FLAGS_G = (1<<3),
}GDTsectorFlag ;

typedef enum 
{
  GDTSECTOR_PERMISSION_A = (1<<0),
  GDTSECTOR_PERMISSION_RW = (1<<1),
  GDTSECTOR_PERMISSION_DC = (1<<2),
  GDTSECTOR_PERMISSION_E = (1<<3),
  GDTSECTOR_PERMISSION_S = (1<<4),
  GDTSECTOR_PERMISSION_DPL_HIGH = (0), //INFO: kernel level permissions
  GDTSECTOR_PERMISSION_DPL_LOW = ((1<<5) | (1<<6)), //INFO: user level permissions
  GDTSECTOR_PERMISSION_P = (1<<7),
}GDTsectorPersmission ;

typedef uint8_t SegmentDescriptor;
#define EMPTY_DESCRIPTOR (SegmentDescriptor) {0}

typedef struct __attribute__((__packed__, aligned(4)))
{
  SegmentDescriptor entry[];
}GDTTable;

int8_t gdt_new_descriptor(
    SegmentDescriptor* const o_descriptor,
    const uint8_t base,
    const uint8_t limit,
    const uint8_t flags,
    const uint8_t access);

//INFO: limit is size of *base -1
void gdt_load(const GDTTable* const base, const uint16_t limit);

#endif // !__GDT_TABLE__
