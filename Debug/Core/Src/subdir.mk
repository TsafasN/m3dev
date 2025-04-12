# Core/Src Makefile
#
# This Makefile is responsible for managing the build process for the source files
# located in the Core/Src directory.
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
SRC_DIR := ../Core/Src
BUILD_DIR := ./Core/Src

# Automatically find all C source files
C_SRCS := $(wildcard $(SRC_DIR)/*.c)

# Define output files
OBJS += \
./Core/Src/main.o \
./Core/Src/stm32f1xx_it.o \
./Core/Src/system_stm32f1xx.o
C_DEPS += \
./Core/Src/main.d \
./Core/Src/stm32f1xx_it.d \
./Core/Src/system_stm32f1xx.d

# Rule to build object files from C sources
$(BUILD_DIR)/%.o $(BUILD_DIR)/%.su: $(SRC_DIR)/%.c $(BUILD_DIR)/subdir.mk
	$(CC) "$<" $(CFLAGS) -o "$@"

# Clean target that depends on the directory-specific clean
clean: clean-Core-Src

# Directory-specific clean target
# Removes all generated files
clean-Core-Src:
	-$(RM) $(BUILD_DIR)/*.d $(BUILD_DIR)/*.o $(BUILD_DIR)/*.su
	@echo 'Core/Src: Cleaned object files'

.PHONY: clean-Core-Src
