# STM32F1xx Low-Layer (LL) Driver Makefile
#
# Description:
#   This makefile handles the compilation of STM32F1xx LL driver source files.
#
# Generated Files:
#   - *.o:   Object files
#   - *.d:   Dependency files for make
#   - *.su:  Size usage information
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
#   - CFLAGS must be defined in parent makefile
#

# Directory variables
SRC_DIR := ../Drivers/STM32F1xx_HAL_Driver/Src
BUILD_DIR := ./Drivers/STM32F1xx_HAL_Driver/Src

# Automatically find all C source files
C_SRCS := $(wildcard $(SRC_DIR)/*.c)

# Define output files
OBJS += $(patsubst $(SRC_DIR)/%.c,$(BUILD_DIR)/%.o,$(C_SRCS))
C_DEPS += $(patsubst $(SRC_DIR)/%.c,$(BUILD_DIR)/%.d,$(C_SRCS))

# Rule to build object files from C sources
$(BUILD_DIR)/%.o $(BUILD_DIR)/%.su: $(SRC_DIR)/%.c $(SRC_DIR)/subdir.mk
	$(CC) "$<" $(CFLAGS) -o "$@"

# Clean target that depends on the directory-specific clean
clean: clean-Drivers

# Directory-specific clean target
# Removes all generated files
clean-Drivers:
	-$(RM) $(BUILD_DIR)/*.d $(BUILD_DIR)/*.o $(BUILD_DIR)/*.su
	@echo 'Drivers: Cleaned object files'

.PHONY: clean-Drivers
