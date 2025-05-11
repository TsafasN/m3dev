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
#   - CORE_SRC_DIR:  Source directory path
#   - CORE_BUILD_DIR: Output directory path
#   - C_SRCS:   List of C source files
#   - OBJS:     List of object files to be generated
#   - C_DEPS:   List of dependency files to be generated
#
# Requirements:
#   - arm-none-eabi-gcc toolchain must be in PATH
#   - CFLAGS must be defined in parent makefile
#

# Directory variables
CORE_SRC_DIR := ../Core/Src
CORE_BUILD_DIR := ./Core/Src

# Automatically find all C source files
C_SRCS := $(wildcard $(CORE_SRC_DIR)/*.c)

# Define output files
OBJS += $(patsubst $(CORE_SRC_DIR)/%.c,$(CORE_BUILD_DIR)/%.o,$(C_SRCS))
C_DEPS += $(patsubst $(CORE_SRC_DIR)/%.c,$(CORE_BUILD_DIR)/%.d,$(C_SRCS))

# Rule to build object files from C sources
$(CORE_BUILD_DIR)/%.o $(CORE_BUILD_DIR)/%.su: $(CORE_SRC_DIR)/%.c $(CORE_BUILD_DIR)/subdir.mk
	$(CC) "$<" $(CFLAGS) -o "$@"

# Clean target that depends on the directory-specific clean
clean: clean-Core-Src

# Directory-specific clean target
# Removes all generated files
clean-Core-Src:
	-$(RM) $(CORE_BUILD_DIR)/*.d $(CORE_BUILD_DIR)/*.o $(CORE_BUILD_DIR)/*.su
	@echo 'Core/Src: Cleaned object files'

.PHONY: clean-Core-Src
