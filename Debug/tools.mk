# Tool definitions and checks
#
# This makefile segment defines the required cross-compilation toolchain for ARM
# and provides a verification mechanism to ensure all tools are available.
#
# Tools defined:
# - CC      : ARM GCC Compiler
# - LD      : ARM Linker
# - SIZE    : Binary size analysis tool
# - OBJDUMP : Object file inspection tool
# - RM      : File removal utility
#
# The check-tools target validates the presence of all required tools in the
# system PATH and fails with an error if any tool is missing.

CC      := arm-none-eabi-gcc
LD 		:= arm-none-eabi-ld
SIZE    := arm-none-eabi-size
OBJDUMP := arm-none-eabi-objdump
RM      := rm -rf

# Check required tools
check-tools:
	@which $(CC) >/dev/null || (echo "Error: $(CC) not found"; exit 1)
	@which $(LD) >/dev/null || (echo "Error: $(LD) not found"; exit 1)
	@which $(SIZE) >/dev/null || (echo "Error: $(SIZE) not found"; exit 1)
	@which $(OBJDUMP) >/dev/null || (echo "Error: $(OBJDUMP) not found"; exit 1)

.PHONY: check-tools
