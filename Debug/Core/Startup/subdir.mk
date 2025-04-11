# Makefile for Core/Startup

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
	arm-none-eabi-gcc "$<" $(SFLAGS) -o "$@"

# Clean target that depends on the directory-specific clean
clean: clean-Core-2f-Startup

# Directory-specific clean target
# Removes all generated files (.o, .d, .su)
clean-Core-2f-Startup:
	-$(RM) $(BUILD_DIR)/*.d $(BUILD_DIR)/*.o

# Mark clean target as .PHONY since it's not a real file
.PHONY: clean-Core-2f-Startup
