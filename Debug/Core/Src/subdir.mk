# Makefile for Core/Src

# Add inputs and outputs from these tool invocations to the build variables 
C_SRCS += \
../Core/Src/main.c \
../Core/Src/stm32f1xx_it.c \
../Core/Src/system_stm32f1xx.c

OBJS += \
./Core/Src/main.o \
./Core/Src/stm32f1xx_it.o \
./Core/Src/system_stm32f1xx.o

C_DEPS += \
./Core/Src/main.d \
./Core/Src/stm32f1xx_it.d \
./Core/Src/system_stm32f1xx.d


# Each subdirectory must supply rules for building sources it contributes
Core/Src/%.o Core/Src/%.su: ../Core/Src/%.c Core/Src/subdir.mk
	arm-none-eabi-gcc \
		"$<" \
		$(CFLAGS) \
		-o "$@"

clean: clean-Core-2f-Src

clean-Core-2f-Src:
	-$(RM) ./Core/Src/main.d ./Core/Src/main.o ./Core/Src/main.su ./Core/Src/stm32f1xx_it.d ./Core/Src/stm32f1xx_it.o ./Core/Src/stm32f1xx_it.su ./Core/Src/system_stm32f1xx.d ./Core/Src/system_stm32f1xx.o ./Core/Src/system_stm32f1xx.su

.PHONY: clean-Core-2f-Src

