# Makefile for Drivers/STM32F1xx_HAL_Driver/Src

# Directory variables
SRC_DIR := ../Drivers/STM32F1xx_HAL_Driver/Src
BUILD_DIR := ./Drivers/STM32F1xx_HAL_Driver/Src

# Automatically find all C source files
C_SRCS := $(wildcard $(SRC_DIR)/*.c)

OBJS += \
./Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_ll_adc.o \
./Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_ll_crc.o \
./Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_ll_dac.o \
./Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_ll_dma.o \
./Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_ll_exti.o \
./Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_ll_gpio.o \
./Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_ll_i2c.o \
./Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_ll_pwr.o \
./Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_ll_rcc.o \
./Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_ll_rtc.o \
./Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_ll_spi.o \
./Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_ll_tim.o \
./Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_ll_usart.o \
./Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_ll_utils.o

C_DEPS += \
./Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_ll_adc.d \
./Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_ll_crc.d \
./Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_ll_dac.d \
./Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_ll_dma.d \
./Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_ll_exti.d \
./Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_ll_gpio.d \
./Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_ll_i2c.d \
./Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_ll_pwr.d \
./Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_ll_rcc.d \
./Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_ll_rtc.d \
./Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_ll_spi.d \
./Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_ll_tim.d \
./Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_ll_usart.d \
./Drivers/STM32F1xx_HAL_Driver/Src/stm32f1xx_ll_utils.d

# Rule to build object files from C sources
# Creates both .o and .su (size usage) files
# $< refers to the first prerequisite (the .c file)
# $@ refers to the target (.o file)
$(BUILD_DIR)/%.o $(BUILD_DIR)/%.su: $(SRC_DIR)/%.c $(SRC_DIR)/subdir.mk
	arm-none-eabi-gcc "$<" $(CFLAGS) -o "$@"

# Clean target that depends on the directory-specific clean
clean: clean-Drivers-2f-STM32F1xx_HAL_Driver-2f-Src

# Directory-specific clean target
# Removes all generated files (.o, .d, .su)
clean-Drivers-2f-STM32F1xx_HAL_Driver-2f-Src:
	-$(RM) $(BUILD_DIR)/*.d $(BUILD_DIR)/*.o $(BUILD_DIR)/*.su

# Mark clean target as .PHONY since it's not a real file
.PHONY: clean-Drivers-2f-STM32F1xx_HAL_Driver-2f-Src
