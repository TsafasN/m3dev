# Compiler and assembler options for STM32F103xB (Cortex-M3) microcontroller
#
# CFLAGS: C compiler options
#
# SFLAGS: Assembly compiler options
#
# LDFLAGS: Linker options
#

# Build type (debug/release)
# If BUILD_TYPE wasn't defined yet, it will be set to debug
BUILD_TYPE ?= debug

# CFLAGS: C compiler options
CFLAGS = \
-mcpu=$(MCU) \
-mthumb \
-mfloat-abi=$(FLOAT_ABI) \
-std=gnu11 \
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
$(INCLUDES) \
-ffunction-sections \
-fdata-sections \
-fstack-usage \
-Wall \
-MMD \
-MP \
-MF"$(@:%.o=%.d)" \
-MT"$@"

ifeq ($(BUILD_TYPE),debug)
# Debug build settings
CFLAGS += \
-g3 \
-O0 \
-DDEBUG \
-Wextra
else
# Release build settings
CFLAGS += \
-O2 \
-DNDEBUG
endif

# SFLAGS: Assembly compiler options
SFLAGS = \
-mcpu=$(MCU) \
-mthumb \
-mfloat-abi=$(FLOAT_ABI) \
-g3 \
-DDEBUG \
-c \
-x assembler-with-cpp \
-MMD \
-MP \
-MF"$(@:%.o=%.d)" \
-MT"$@"

# Linker flags
LDFLAGS = \
-mcpu=cortex-m3 \
-T$(LINKER_SCRIPT) \
-Wl,-Map=$(MAP_FILES) \
-Wl,--gc-sections \
-static \
-mfloat-abi=soft \
-mthumb \
-Wl,--start-group \
-lc \
-lm \
-Wl,--end-group
