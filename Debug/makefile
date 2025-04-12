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
#   - Template.size 	: Size information
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
	@echo "  Template.size 	  : Size information of the executable"
	@echo ""
	@echo "Build options:"
	@echo "  make -j          : Enable parallel build"
	@echo "  make V=1         : Enable verbose output"
	@echo ""

# Configuration
PROJECT_NAME 	:= Template
MCU         	:= cortex-m3
FLOAT_ABI   	:= soft
LINKER_PATH 	:= /home/ntsafas/wd/m3dev/STM32F103RBTX_FLASH.ld

# Include tools definitions
ifneq ("$(wildcard tools.mk)","")
-include tools.mk
else
$(error "Error: tools.mk not found. This file is required for build tools configuration.")
endif

# Include paths configuration
ifneq ("$(wildcard includes.mk)","")
-include includes.mk
else
$(warning "Warning: includes.mk not found. Using default include paths.")
endif

# Include Core sources, warn if not found
ifneq ("$(wildcard sources.mk)","")
-include sources.mk
else
$(warning "Warning: sources.mk not found. Using default options.")
endif

# Include HAL driver sources, warn if not found
ifneq ("$(wildcard Drivers/STM32F1xx_HAL_Driver/Src/subdir.mk)","")
-include Drivers/STM32F1xx_HAL_Driver/Src/subdir.mk
else
$(warning "Warning: Drivers/STM32F1xx_HAL_Driver/Src/subdir.mk not found. Using default options.")
endif

# Include startup code, warn if not found
ifneq ("$(wildcard Core/Startup/subdir.mk)","")
-include Core/Startup/subdir.mk
else
$(warning "Warning: Core/Startup/subdir.mk not found. Using default options.")
endif

# Include core application sources, warn if not found
ifneq ("$(wildcard Core/Src/subdir.mk)","")
-include Core/Src/subdir.mk
else
$(warning "Warning: Core/Src/subdir.mk not found. Using default options.")
endif

# Include object file definitions, warn if not found
ifneq ("$(wildcard objects.mk)","")
-include objects.mk
else
$(warning "Warning: objects.mk not found. Using default options.")
endif

# Include build options, warn if not found
ifneq ("$(wildcard options.mk)","")
-include options.mk
else
$(warning "Warning: options.mk not found. Using default options.")
endif

# Include dependencies if not cleaning
ifneq ($(MAKECMDGOALS),clean)
ifneq ($(strip $(S_DEPS)),)
-include $(S_DEPS)
endif
ifneq ($(strip $(C_DEPS)),)
-include $(C_DEPS)
endif
endif

# Define output files
EXECUTABLES  	+= $(PROJECT_NAME).elf
MAP_FILES  		+= $(PROJECT_NAME).map
SIZE_OUTPUT 	+= $(PROJECT_NAME).size
OBJDUMP_LIST 	+= $(PROJECT_NAME).list

# Main build targets
all: check-tools main-build

# Main-build Target
main-build: $(ELF) secondary-outputs
	@echo "Build completed at: $$(date)"
	@echo "Toolchain: $(CC)"
	@echo "Build type: $(BUILD_TYPE)"
	@echo ' '

# Link executable and generate map file
Template.elf Template.map: $(OBJS) $(USER_OBJS) /home/ntsafas/wd/m3dev/STM32F103RBTX_FLASH.ld makefile objects.list
	$(CC) -o "Template.elf" @"objects.list" $(USER_OBJS) $(LIBS) -mcpu=cortex-m3 -T"/home/ntsafas/wd/m3dev/STM32F103RBTX_FLASH.ld" -Wl,-Map="Template.map" -Wl,--gc-sections -static -mfloat-abi=soft -mthumb -Wl,--start-group -lc -lm -Wl,--end-group
	@echo 'Finished building target: $@'
	@echo ' '

# Generate size information
Template.size: $(EXECUTABLES) makefile objects.list
	$(SIZE)  $(EXECUTABLES) > "Template.size"
	@echo 'Finished building: $@'
	@echo ' '

# Generate disassembly listing
Template.list: $(EXECUTABLES) makefile objects.list
	$(OBJDUMP) -h -S $(EXECUTABLES) > "Template.list"
	@echo 'Finished building: $@'
	@echo ' '

# Clean build artifacts
clean:
	-$(RM) $(EXECUTABLES) $(OBJDUMP_LIST) $(MAP_FILES) $(SIZE_OUTPUT)
	-@echo 'Cleaned output files'
	@echo ' '

# Generate secondary outputs
secondary-outputs: $(SIZE_OUTPUT) $(OBJDUMP_LIST)

version:
	@$(CC) --version
	@echo "Project: $(PROJECT_NAME)"
	@echo "MCU: $(MCU)"
	@echo "Build type: $(BUILD_TYPE)"

# Error handlers for linker script issues
fail-specified-linker-script-missing:
	@echo 'Error: Cannot find the specified linker script. Check the linker settings in the build configuration.'
	@exit 2

warn-no-linker-script-specified:
	@echo 'Warning: No linker script specified. Check the linker settings in the build configuration.'

# Define phony targets
.PHONY: all clean version dependents main-build fail-specified-linker-script-missing warn-no-linker-script-specified
