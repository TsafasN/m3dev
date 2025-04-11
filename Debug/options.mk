# Compiler and assembler options for STM32F103xB (Cortex-M3) microcontroller
#
# CFLAGS: C compiler options
#   - CPU and architecture: Cortex-M3, Thumb instruction set, soft float ABI
#   - Debug: Level 3 debug info, DEBUG symbol defined
#   - MCU specific: STM32F103xB target, clock configurations, drivers
#   - Optimization: None (O0), separate sections for functions and data
#   - Warnings: Enable all warnings
#   - Dependencies: Generate dependency files (.d)
#   - Includes: Core, HAL drivers, and CMSIS paths
#
# SFLAGS: Assembly compiler options
#   - CPU and architecture: Same as CFLAGS
#   - Debug: Level 3 debug info, DEBUG symbol defined
#   - Process assembly with C preprocessor
#   - Dependencies: Generate dependency files (.d)

# CFLAGS: C compiler options
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

# SFLAGS: Assembly compiler options
SFLAGS = \
-mcpu=cortex-m3 \
-g3 \
-DDEBUG \
-c \
-x assembler-with-cpp \
-MMD \
-MP \
-MF"$(@:%.o=%.d)" \
-MT"$@" \
-mfloat-abi=soft \
-mthumb
