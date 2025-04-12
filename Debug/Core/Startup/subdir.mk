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
#   - SRC_DIR:  Source directory path
#   - BUILD_DIR: Output directory path
#   - C_SRCS:   List of C source files
#   - OBJS:     List of object files to be generated
#   - C_DEPS:   List of dependency files to be generated
#
# Requirements:
#   - arm-none-eabi-gcc toolchain must be in PATH
#   - SFLAGS must be defined in parent makefile
#

# Directory variables
SRC_DIR := ../Core/Startup
BUILD_DIR := ./Core/Startup

# Automatically find all source files
S_SRCS := $(wildcard $(SRC_DIR)/*.s)

# Define output files
OBJS += \
./Core/Startup/startup_stm32f103rbtx.o
S_DEPS += \
./Core/Startup/startup_stm32f103rbtx.d

# Rule to build object files from S sources
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.s $(BUILD_DIR)/subdir.mk
	$(CC) $(SFLAGS) -o "$@" "$<"

# Clean target that depends on the directory-specific clean
clean: clean-Core-Startup

# Directory-specific clean target
# Removes all generated files
clean-Core-Startup:
	-$(RM) $(BUILD_DIR)/*.d $(BUILD_DIR)/*.o
	@echo 'Core/Startup: Cleaned object files'

.PHONY: clean-Core-Startup
