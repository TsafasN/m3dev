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
#
# OUTPUT FILES:
#   - Template.elf  	: Main executable
#   - Template.map  	: Memory mapping file
#   - Template.list 	: Disassembly listing
#   - Template.size 	: Size information
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
PROJECT_NAME	:= Template
MCU				:= cortex-m3
FLOAT_ABI		:= soft
LINKER_SCRIPT	:= /home/ntsafas/wd/m3dev/STM32F103RBTX_FLASH.ld

# Include tools definitions
ifneq ("$(wildcard tools.mk)","")
-include tools.mk
else
$(warning "Warning: tools.mk not found. Using default toolchain settings.")
CC		:= arm-none-eabi-gcc
LD		:= arm-none-eabi-ld
SIZE	:= arm-none-eabi-size
OBJDUMP	:= arm-none-eabi-objdump
RM		:= rm -f
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

# Include build options, warn if not found
ifneq ("$(wildcard options.mk)","")
-include options.mk
else
$(warning "Warning: options.mk not found. Using default options.")
endif

# Define output files
EXECUTABLES  	+= $(PROJECT_NAME).elf
MAP_FILES  		+= $(PROJECT_NAME).map
SIZE_OUTPUT 	+= $(PROJECT_NAME).size
OBJDUMP_LIST 	+= $(PROJECT_NAME).list

# Main build targets
all: check-tools main-build

# Main-build Target
main-build:	$(EXECUTABLES) $(MAP_FILES) $(SIZE_OUTPUT) $(OBJDUMP_LIST)
	@echo ' '
	@echo "Build completed at: $$(date)"
	@echo ' '
	@echo "Project: $(PROJECT_NAME)"
	@echo "MCU: $(MCU)"
	@echo "Build type: $(BUILD_TYPE)"
	@echo "Toolchain: $(CC)"
	@echo ' '

# Generate size information
$(SIZE_OUTPUT): $(EXECUTABLES) $(OBJS)
	$(SIZE)  $(EXECUTABLES) > $@
	@echo 'Finished building: $@'

# Generate disassembly listing
$(OBJDUMP_LIST): $(EXECUTABLES) $(OBJS)
	$(OBJDUMP) -h -S $(EXECUTABLES) > $@
	@echo 'Finished building: $@'

# Link executable and generate map file
$(EXECUTABLES) $(MAP_FILES): $(OBJS) $(LINKER_SCRIPT)
	@echo ' '
	@echo 'Building target: $@'
	@echo 'Invoking: Linker script: $(LINKER_SCRIPT)'
	$(CC) -o $(EXECUTABLES) $(OBJS) $(LDFLAGS)
	@echo 'Finished building target: $@'

# Clean build artifacts
clean:
	-$(RM) $(EXECUTABLES) $(OBJDUMP_LIST) $(MAP_FILES) $(SIZE_OUTPUT)
	-@echo 'Cleaned output files'

# Define phony targets
.PHONY: all clean dependents main-build
