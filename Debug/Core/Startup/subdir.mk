# Core/Startup Makefile
#
# This makefile handles the compilation of startup assembly files for STM32F103RB
# microcontroller.
#
# Generated Files:
#   - *.o:   Object files
#   - *.d:   Dependency files for make
#
# Variables:
#   - STARTUP_SRC_DIR:  Source directory path
#   - STARTUP_BUILD_DIR: Output directory path
#   - C_SRCS:   List of C source files
#   - OBJS:     List of object files to be generated
#   - C_DEPS:   List of dependency files to be generated
#
# Requirements:
#   - arm-none-eabi-gcc toolchain must be in PATH
#   - SFLAGS must be defined in parent makefile
#

# Directory variables
STARTUP_SRC_DIR := ../Core/Startup
STARTUP_BUILD_DIR := ./Core/Startup

# Automatically find all source files
S_SRCS := $(wildcard $(STARTUP_SRC_DIR)/*.s)

# Define output files
OBJS += $(patsubst $(STARTUP_SRC_DIR)/%.c,$(STARTUP_BUILD_DIR)/%.o,$(S_SRCS))
S_DEPS += $(patsubst $(STARTUP_SRC_DIR)/%.c,$(STARTUP_BUILD_DIR)/%.d,$(S_SRCS))

# Rule to build object files from S sources
$(STARTUP_BUILD_DIR)/%.o: $(STARTUP_SRC_DIR)/%.s $(STARTUP_BUILD_DIR)/subdir.mk
	$(CC) $(SFLAGS) -o "$@" "$<"

# Clean target that depends on the directory-specific clean
clean: clean-Core-Startup

# Directory-specific clean target
# Removes all generated files
clean-Core-Startup:
	-$(RM) $(STARTUP_BUILD_DIR)/*.d $(STARTUP_BUILD_DIR)/*.o
	@echo 'Core/Startup: Cleaned object files'

.PHONY: clean-Core-Startup
