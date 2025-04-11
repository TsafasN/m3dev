# Makefile for Core/Src
#
# This Makefile is responsible for managing the build process for the source files
# located in the Core/Src directory. It includes rules for compiling source files,
# generating object files, and cleaning up build artifacts.
#
# Variables:
# - SRC_DIR: Specifies the directory containing the source files.
# - BUILD_DIR: Specifies the directory where the build artifacts (object files, dependency files) will be stored.
# - C_SRCS: Automatically detects all C source files in the SRC_DIR.
# - OBJS: A list of object files corresponding to the source files.
# - C_DEPS: A list of dependency files corresponding to the source files.
#
# Rules:
# - $(BUILD_DIR)/%.o $(BUILD_DIR)/%.su: Compiles each C source file into an object file (.o) and a supplementary file (.su).
#   Uses the `arm-none-eabi-gcc` compiler with the specified CFLAGS.
#
# - clean: Removes all build artifacts (object files, dependency files, and supplementary files) in the BUILD_DIR.
#   This is achieved through the `clean-Core-2f-Src` target.
#
# - clean-Core-2f-Src: A helper target for cleaning up build artifacts specific to the Core/Src directory.

# Directory variables
SRC_DIR := ../Core/Src
BUILD_DIR := ./Core/Src

# Automatically find all C source files
C_SRCS := $(wildcard $(SRC_DIR)/*.c)

OBJS += \
./Core/Src/main.o \
./Core/Src/stm32f1xx_it.o \
./Core/Src/system_stm32f1xx.o

C_DEPS += \
./Core/Src/main.d \
./Core/Src/stm32f1xx_it.d \
./Core/Src/system_stm32f1xx.d

# Rule to build object files from C sources
# Creates both .o and .su (size usage) files
# $< refers to the first prerequisite (the .c file)
# $@ refers to the target (.o file)
$(BUILD_DIR)/%.o $(BUILD_DIR)/%.su: $(SRC_DIR)/%.c $(BUILD_DIR)/subdir.mk
	arm-none-eabi-gcc "$<" $(CFLAGS) -o "$@"

# Clean target that depends on the directory-specific clean
clean: clean-Core-2f-Src

# Directory-specific clean target
# Removes all generated files (.o, .d, .su)
clean-Core-2f-Src:
	-$(RM) $(BUILD_DIR)/*.d $(BUILD_DIR)/*.o $(BUILD_DIR)/*.su

# Mark clean target as .PHONY since it's not a real file
.PHONY: clean-Core-2f-Src
