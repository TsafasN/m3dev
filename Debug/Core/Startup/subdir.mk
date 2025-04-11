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
# - SRC_DIR:    Source directory containing assembly files
# - BUILD_DIR:  Output directory for compiled files
# - S_SRCS:     List of assembly source files (automatically detected)
# - OBJS:       List of object files to be created
# - S_DEPS:     List of dependency files
#
# Requirements:
#   - arm-none-eabi-gcc toolchain must be in PATH
#   - CFLAGS must be defined in parent makefile
#

# Directory variables
SRC_DIR := ../Core/Startup
BUILD_DIR := ./Core/Startup

# Automatically find all source files
S_SRCS := $(wildcard $(SRC_DIR)/*.s)

OBJS += \
./Core/Startup/startup_stm32f103rbtx.o

S_DEPS += \
./Core/Startup/startup_stm32f103rbtx.d

# Rule to build object files from C sources
# Creates both .o and .su (size usage) files
# $< refers to the first prerequisite (the .c file)
# $@ refers to the target (.o file)
$(BUILD_DIR)/%.o: $(SRC_DIR)/%.s $(BUILD_DIR)/subdir.mk
	$(CC) $(SFLAGS) -o "$@" "$<"

# Clean target that depends on the directory-specific clean
clean: clean-Core-Startup

# Directory-specific clean target
# Removes all generated files (.o, .d)
clean-Core-Startup:
	-$(RM) $(BUILD_DIR)/*.d $(BUILD_DIR)/*.o
	@echo 'Cleaned object files'
	@echo ' '

# Mark clean target as .PHONY since it's not a real file
.PHONY: clean-Core-Startup
