# Tool definitions and checks
CC      := arm-none-eabi-gcc
OBJDUMP := arm-none-eabi-objdump
SIZE    := arm-none-eabi-size
RM      := rm -rf

# Check required tools
check-tools:
	@which $(CC) >/dev/null || (echo "Error: $(CC) not found"; exit 1)
	@which $(OBJDUMP) >/dev/null || (echo "Error: $(OBJDUMP) not found"; exit 1)
	@which $(SIZE) >/dev/null || (echo "Error: $(SIZE) not found"; exit 1)

.PHONY: check-tools
