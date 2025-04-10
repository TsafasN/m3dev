# Makefile compiler build options

# Use software floating-point operations as the target hardware does not support hardware floating-point.
# Enable the Thumb instruction set for reduced code size, trading off some performance

CFLAGS = \
-mcpu=cortex-m3 \
-std=gnu11 \
-g3 \
-DDEBUG \
-DUSE_FULL_LL_DRIVER \
-DHSE_VALUE=8000000 \
-DHSE_STARTUP_TIMEOUT=100 \
-DLSE_STARTUP_TIMEOUT=5000 \
-DLSE_VALUE=32768 \
-DHSI_VALUE=8000000 \
-DLSI_VALUE=40000 \
-DVDD_VALUE=3300 \
-DPREFETCH_ENABLE=1 \
-DSTM32F103xB \
-c \
-I../Core/Inc \
-I../Drivers/STM32F1xx_HAL_Driver/Inc \
-I../Drivers/CMSIS/Device/ST/STM32F1xx/Include \
-I../Drivers/CMSIS/Include \
-O0 \
-ffunction-sections \
-fdata-sections \
-Wall \
-fstack-usage \
-MMD \
-MP \
-MF"$(@:%.o=%.d)" \
-MT"$@" \
-mfloat-abi=soft \
-mthumb