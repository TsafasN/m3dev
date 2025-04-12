# Project Include Paths
#
# Structure:
# - Core includes: Contains main application headers
# - Driver includes: Contains all necessary hardware abstraction layers
#   * STM32F1 HAL drivers
#   * CMSIS device-specific headers
#   * CMSIS core headers
#
# Note: All paths are relative to the Debug directory
#

INCLUDES :=

# Core includes
INCLUDES += \
-I../Core/Inc

# Driver includes
INCLUDES += \
-I../Drivers/STM32F1xx_HAL_Driver/Inc \
-I../Drivers/CMSIS/Device/ST/STM32F1xx/Include \
-I../Drivers/CMSIS/Include
