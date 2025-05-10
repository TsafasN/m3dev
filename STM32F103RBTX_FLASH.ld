/* STM32F103RBTX Linker Script
 *
 * This linker script defines the memory layout and section placement for the
 * STM32F103RBTX microcontroller. It specifies:
 *
 * Memory Regions:
 * - RAM
 * - FLASH
 *
 * Key Memory Allocations:
 * - Minimum Heap Size
 * - Minimum Stack Size
 *
 * Section Placement:
 * In FLASH:
 * - .isr_vector:     Interrupt vector table
 * - .text:           Program code
 * - .rodata:         Read-only data
 * - .ARM.extab:      ARM exception tables
 * - .ARM:            ARM-specific data
 * - .preinit_array:  Pre-initialization functions
 * - .init_array:     Initialization functions
 * - .fini_array:     Finalization functions
 *
 * In RAM:
 * - .data:           Initialized data (copied from FLASH)
 * - .bss:            Uninitialized data
 * - ._user_heap_stack: Heap and stack space
 *
 * Special Features:
 * - Discards unused sections from standard libraries to optimize size
 * - Includes ARM-specific attributes
 * - Ensures proper alignment of sections
 * - Maintains startup code and initialization functions
*/

/* Entry point of the program. The first function executed after a reset. */
ENTRY(Reset_Handler)

/* Top of the stack, which is at the end of the RAM region. */
_estack = ORIGIN(RAM) + LENGTH(RAM);
/* Reserve memory for the heap and stack. */
_Min_Heap_Size = 0x200;   /* required amount of heap */
_Min_Stack_Size = 0x400;  /* required amount of stack */

/* Memory Regions. */
MEMORY
{
  RAM    (xrw)    : ORIGIN = 0x20000000,   LENGTH = 20K
  FLASH    (rx)    : ORIGIN = 0x8000000,   LENGTH = 128K
}

/* Sections. Map program sections to specific memory regions. */
SECTIONS
{
  /* Places the interrupt vector table in the FLASH */
  .isr_vector :
  {
    . = ALIGN(4);
    KEEP(*(.isr_vector)) /* Startup code */
    . = ALIGN(4);
  } >FLASH

  /* Places program code and Read-Only data into FLASH */
  .text :
  {
    . = ALIGN(4);
    *(.text)           /* Code */
    *(.text*)          /* Additional code */
    *(.glue_7)         /* ARM-to-Thumb glue code */
    *(.glue_7t)        /* Thumb-to-ARM glue code */
    *(.eh_frame)       /* Exception handling frame */

    KEEP (*(.init))    /* Initialization code */
    KEEP (*(.fini))    /* Finalization code */

    . = ALIGN(4);
    _etext = .;        /* define a global symbols at end of code */
  } >FLASH

  /* Read-Only data into FLASH */
  .rodata :
  {
    . = ALIGN(4);
    *(.rodata)         /* Constants and strings */
    *(.rodata*)        /* Additional constants */
    . = ALIGN(4);
  } >FLASH

  .ARM.extab (READONLY) : /* The "READONLY" keyword is only supported in GCC11 and later, remove it if using GCC10 or earlier. */
  {
    . = ALIGN(4);
    *(.ARM.extab* .gnu.linkonce.armextab.*)
    . = ALIGN(4);
  } >FLASH

  .ARM (READONLY) : /* The "READONLY" keyword is only supported in GCC11 and later, remove it if using GCC10 or earlier. */
  {
    . = ALIGN(4);
    __exidx_start = .;
    *(.ARM.exidx*)
    __exidx_end = .;
    . = ALIGN(4);
  } >FLASH

  .preinit_array (READONLY) : /* The "READONLY" keyword is only supported in GCC11 and later, remove it if using GCC10 or earlier. */
  {
    . = ALIGN(4);
    PROVIDE_HIDDEN (__preinit_array_start = .);
    KEEP (*(.preinit_array*))
    PROVIDE_HIDDEN (__preinit_array_end = .);
    . = ALIGN(4);
  } >FLASH

  .init_array (READONLY) : /* The "READONLY" keyword is only supported in GCC11 and later, remove it if using GCC10 or earlier. */
  {
    . = ALIGN(4);
    PROVIDE_HIDDEN (__init_array_start = .);
    KEEP (*(SORT(.init_array.*)))
    KEEP (*(.init_array*))
    PROVIDE_HIDDEN (__init_array_end = .);
    . = ALIGN(4);
  } >FLASH

  .fini_array (READONLY) : /* The "READONLY" keyword is only supported in GCC11 and later, remove it if using GCC10 or earlier. */
  {
    . = ALIGN(4);
    PROVIDE_HIDDEN (__fini_array_start = .);
    KEEP (*(SORT(.fini_array.*)))
    KEEP (*(.fini_array*))
    PROVIDE_HIDDEN (__fini_array_end = .);
    . = ALIGN(4);
  } >FLASH

  /* Used by the startup to initialize data */
  _sidata = LOADADDR(.data);

  /* Place initialized data in RAM but load it from FLASH during startup. */
  .data :
  {
    . = ALIGN(4);
    _sdata = .;        /* create a global symbol at data start */
    *(.data)           /* Initialized variables */
    *(.data*)          /* Additional initialized variables */
    *(.RamFunc)        /* Functions in RAM */
    *(.RamFunc*)       /* Additional RAM functions */

    . = ALIGN(4);
    _edata = .;        /* define a global symbol at data end */

  } >RAM AT> FLASH

  /* Place uninitialized data in RAM */
  . = ALIGN(4);
  .bss :
  {
    /* This is used by the startup in order to initialize the .bss section */
    _sbss = .;         /* define a global symbol at bss start */
    __bss_start__ = _sbss;
    *(.bss)            /* Uninitialized variables */
    *(.bss*)           /* Additional uninitialized variables */
    *(COMMON)          /* Common symbols */

    . = ALIGN(4);
    _ebss = .;         /* define a global symbol at bss end */
    __bss_end__ = _ebss;
  } >RAM

  /* Reserve space for the heap and stack in RAM. User_heap_stack section, used to check that there is enough "RAM" left */
  ._user_heap_stack :
  {
    . = ALIGN(8);
    PROVIDE ( end = . );
    PROVIDE ( _end = . );
    . = . + _Min_Heap_Size;
    . = . + _Min_Stack_Size;
    . = ALIGN(8);
  } >RAM

  /* Exclude unused sections from standard libraries to reduce binary size. */
  /DISCARD/ :
  {
    libc.a ( * )
    libm.a ( * )
    libgcc.a ( * )
  }

  /* Include ARM-specific attributes in the output file. */
  .ARM.attributes 0 : { *(.ARM.attributes) }
}
