# Project Makefile
#
# This makefile manages the build process for an STM32F103 microcontroller project.
# It includes the following main features:
#
# BUILD TARGETS:
#   - help     			: Displays available make targets and build options
#   - all      			: Main build target (alias for main-build)
#   - main-build		: Builds the Template.elf executable and secondary outputs
#   - clean    			: Removes all build artifacts
#
# INCLUDED MAKEFILES:
#   - sources.mk                              		: Source file definitions
#   - Drivers/STM32F1xx_HAL_Driver/Src/subdir.mk 	: HAL driver sources
#   - Core/Startup/subdir.mk                  		: Startup code
#   - Core/Src/subdir.mk                      		: Core application sources
#   - objects.mk                              		: Object file definitions
#   - options.mk                              		: Build options
#
# OUTPUT FILES:
#   - Template.elf  	: Main executable
#   - Template.map  	: Memory mapping file
#   - Template.list 	: Disassembly listing
#   - default.size 		: Size information
#
# BUILD CONFIGURATION:
#   - Toolchain    		: arm-none-eabi-gcc
#   - Target MCU   		: STM32F103RB (Cortex-M3)
#   - Float ABI    		: Soft
#   - Linker Script		: STM32F103RBTX_FLASH.ld
#
# DEPENDENCIES:
#   Automatically handles dependencies for .s, .c files and optional tool dependencies
#
# USAGE:
#   make          		: Build the project
#   make clean   	 	: Clean build artifacts
#   make -j       		: Parallel build
#   make V=1      		: Verbose output
#

# Help target should be first so it shows up when just typing make help
help:
	@echo "Available targets:"
	@echo "  all              : Build the project (same as main-build)"
	@echo "  main-build       : Build Template.elf and generate size/objdump outputs"
	@echo "  clean            : Remove all build outputs and intermediate files"
	@echo ""
	@echo "Output files:"
	@echo "  Template.elf     : The final executable"
	@echo "  Template.map     : Memory map file"
	@echo "  Template.list    : Disassembly listing"
	@echo "  default.size 	  : Size information of the executable"
	@echo ""
	@echo "Build options:"
	@echo "  make -j          : Enable parallel build"
	@echo "  make V=1         : Enable verbose output"
	@echo ""

ifneq ("$(wildcard sources.mk)","")
-include sources.mk
else
$(warning "Warning: sources.mk not found. Using default options.")
endif

ifneq ("$(wildcard Drivers/STM32F1xx_HAL_Driver/Src/subdir.mk)","")
-include Drivers/STM32F1xx_HAL_Driver/Src/subdir.mk
else
$(warning "Warning: Drivers/STM32F1xx_HAL_Driver/Src/subdir.mk not found. Using default options.")
endif

ifneq ("$(wildcard Core/Startup/subdir.mk)","")
-include Core/Startup/subdir.mk
else
$(warning "Warning: Core/Startup/subdir.mk not found. Using default options.")
endif

ifneq ("$(wildcard Core/Src/subdir.mk)","")
-include Core/Src/subdir.mk
else
$(warning "Warning: Core/Src/subdir.mk not found. Using default options.")
endif

ifneq ("$(wildcard objects.mk)","")
-include objects.mk
else
$(warning "Warning: objects.mk not found. Using default options.")
endif

ifneq ("$(wildcard options.mk)","")
-include options.mk
else
$(warning "Warning: options.mk not found. Using default options.")
endif

RM := rm -rf

ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(S_DEPS)),)
-include $(S_DEPS)
endif
ifneq ($(strip $(S_UPPER_DEPS)),)
-include $(S_UPPER_DEPS)
endif
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
endif

-include ../makefile.defs

OPTIONAL_TOOL_DEPS := \
$(wildcard ../makefile.defs) \
$(wildcard ../makefile.init) \
$(wildcard ../makefile.targets) \

# Add inputs and outputs from these tool invocations to the build variables
EXECUTABLES += \
Template.elf \

MAP_FILES += \
Template.map \

SIZE_OUTPUT += \
default.size \

OBJDUMP_LIST += \
Template.list \


# All Target
all: main-build

# Main-build Target
main-build: Template.elf secondary-outputs

# Tool invocations
Template.elf Template.map: $(OBJS) $(USER_OBJS) /home/ntsafas/wd/m3dev/STM32F103RBTX_FLASH.ld makefile objects.list $(OPTIONAL_TOOL_DEPS)
	arm-none-eabi-gcc -o "Template.elf" @"objects.list" $(USER_OBJS) $(LIBS) -mcpu=cortex-m3 -T"/home/ntsafas/wd/m3dev/STM32F103RBTX_FLASH.ld" -Wl,-Map="Template.map" -Wl,--gc-sections -static -mfloat-abi=soft -mthumb -Wl,--start-group -lc -lm -Wl,--end-group
	@echo 'Finished building target: $@'
	@echo ' '

default.size: $(EXECUTABLES) makefile objects.list $(OPTIONAL_TOOL_DEPS)
	arm-none-eabi-size  $(EXECUTABLES) > "default.size"
	@echo 'Finished building: $@'
	@echo ' '

Template.list: $(EXECUTABLES) makefile objects.list $(OPTIONAL_TOOL_DEPS)
	arm-none-eabi-objdump -h -S $(EXECUTABLES) > "Template.list"
	@echo 'Finished building: $@'
	@echo ' '

# Other Targets
clean:
	-$(RM) Template.elf Template.list Template.map default.size
	-@echo ' '

secondary-outputs: $(SIZE_OUTPUT) $(OBJDUMP_LIST)

fail-specified-linker-script-missing:
	@echo 'Error: Cannot find the specified linker script. Check the linker settings in the build configuration.'
	@exit 2

warn-no-linker-script-specified:
	@echo 'Warning: No linker script specified. Check the linker settings in the build configuration.'

.PHONY: all clean dependents main-build fail-specified-linker-script-missing warn-no-linker-script-specified

-include ../makefile.targets
