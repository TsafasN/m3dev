# Project Build Configuration
#
# This makefile defines source file variables and subdirectories for building
# the project.
#
# Source File Variables:
# - ELF_SRCS:        ELF format source files
# - OBJ_SRCS:        Object source files
# - S_SRCS:          Assembly source files
# - C_SRCS:          C source files
# - S_UPPER_SRCS:    Upper case assembly source files
# - O_SRCS:          Object files
#
# Output File Variables:
# - SIZE_OUTPUT:     Size information output
# - OBJDUMP_LIST:    Object dump listing files
# - SU_FILES:        Stack usage files
# - EXECUTABLES:     Final executable files
# - OBJS:            Object files
# - MAP_FILES:       Memory map files
# - S_DEPS:          Assembly dependencies
# - C_DEPS:          C dependencies
#
# Subdirectories:
# - Core/Src:        Application source code
# - Core/Startup:    MCU startup code
# - Drivers:         STM32 HAL driver sources

# Source File Variables:
ELF_SRCS :=
OBJ_SRCS :=
S_SRCS :=
C_SRCS :=
S_UPPER_SRCS :=
O_SRCS :=

# Output File Variables:
SIZE_OUTPUT :=
OBJDUMP_LIST :=
SU_FILES :=
EXECUTABLES :=
OBJS :=
MAP_FILES :=
S_DEPS :=
C_DEPS :=

# Every subdirectory with source files must be described here
SUBDIRS := \
Core/Src \
Core/Startup \
Drivers/STM32F1xx_HAL_Driver/Src \
