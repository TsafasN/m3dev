# Project Build Configuration
#
# This makefile defines source file variables and subdirectories for building
# the project.
#
# Source File Variables:
# - S_SRCS:          Assembly source files
# - C_SRCS:          C source files
#
# Output File Variables:
# - SIZE_OUTPUT:     Size information output
# - OBJDUMP_LIST:    Object dump listing files
# - EXECUTABLES:     Final executable files
# - MAP_FILES:       Memory map files
# - OBJS:            Object files
# - SU_FILES:        Stack usage files
# - S_DEPS:          Assembly dependencies
# - C_DEPS:          C dependencies
#
# Subdirectories:
# - Core/Src:        Application source code
# - Core/Startup:    MCU startup code
# - Drivers:         STM32 HAL driver sources

# Source File Variables:
S_SRCS 		:=
C_SRCS 		:=

# Output File Variables:
SIZE_OUTPUT :=
OBJDUMP_LIST:=
EXECUTABLES :=
MAP_FILES 	:=
OBJS 		:=
SU_FILES 	:=
S_DEPS 		:=
C_DEPS 		:=

# Every subdirectory with source files must be described here
SUBDIRS := 	\
Core/Src 	\
Core/Startup\
Drivers/STM32F1xx_HAL_Driver/Src
