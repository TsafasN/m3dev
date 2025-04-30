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
#   - DRIVERS_SRC_DIR:  Source directory path
#   - DRIVERS_BUILD_DIR: Output directory path
#   - C_SRCS:   List of C source files
#   - OBJS:     List of object files to be generated
#   - C_DEPS:   List of dependency files to be generated
#
# Requirements:
#   - arm-none-eabi-gcc toolchain must be in PATH
#   - CFLAGS must be defined in parent makefile
#

# Directory variables
DRIVERS_SRC_DIR := ../Drivers/STM32F1xx_HAL_Driver/Src
DRIVERS_BUILD_DIR := ./Drivers/STM32F1xx_HAL_Driver/Src

# Automatically find all C source files
C_SRCS := $(wildcard $(DRIVERS_SRC_DIR)/*.c)

# Define output files
OBJS += $(patsubst $(DRIVERS_SRC_DIR)/%.c,$(DRIVERS_BUILD_DIR)/%.o,$(C_SRCS))
C_DEPS += $(patsubst $(DRIVERS_SRC_DIR)/%.c,$(DRIVERS_BUILD_DIR)/%.d,$(C_SRCS))

# Rule to build object files from C sources
$(DRIVERS_BUILD_DIR)/%.o $(DRIVERS_BUILD_DIR)/%.su: $(DRIVERS_SRC_DIR)/%.c $(DRIVERS_BUILD_DIR)/subdir.mk
	$(CC) "$<" $(CFLAGS) -o "$@"

# Clean target that depends on the directory-specific clean
clean: clean-Drivers

# Directory-specific clean target
# Removes all generated files
clean-Drivers:
	-$(RM) $(DRIVERS_BUILD_DIR)/*.d $(DRIVERS_BUILD_DIR)/*.o $(DRIVERS_BUILD_DIR)/*.su
	@echo 'Drivers: Cleaned object files'

.PHONY: clean-Drivers
