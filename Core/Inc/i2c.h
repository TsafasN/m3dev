#ifndef __I2C_H
#define __I2C_H

#include "stm32f1xx_ll_i2c.h"

#define I2C_TIMEOUT     1000
#define I2C_MAX_DELAY   0xFFFFFFFFU

#define I2C_GPIOB_PERIPH_CLOCK_EN   LL_APB2_GRP1_PERIPH_GPIOB
#define I2C_I2C1_PERIPH_CLOCK_EN    LL_APB1_GRP1_PERIPH_I2C1

#define I2C_SCL_PIN     LL_GPIO_PIN_6
#define I2C_SDA_PIN     LL_GPIO_PIN_7

/**
 * @brief Enumeration of I2C operation results
 *
 * This enumeration defines the possible results of I2C operations:
 * - I2C_SUCCESS    Operation completed successfully
 * - I2C_ERROR      Operation failed
 */
typedef enum {
    I2C_SUCCESS = 0x00,
    I2C_ERROR = 0x01
} I2C_Result_t;

/**
 * @typedef I2C_Instance_t
 * @brief Type definition for I2C peripheral instance pointer
 *
 * This type is an alias for a pointer to I2C_TypeDef structure, which represents
 * an I2C peripheral instance in the microcontroller. It is used to simplify
 * the declaration and handling of I2C peripheral pointers throughout the code.
 */
typedef I2C_TypeDef *   I2C_Instance_t;

/**
 * @typedef I2C_Handle_t
 * @brief Typedef for I2C initialization handler
 *
 * This structure holds the initialization data and state for an I2C peripheral.
 * It encapsulates the peripheral configuration parameters and tracks whether
 * the peripheral has been initialized.
 *
 * @note This structure is used internally by the I2C driver
 *       and should not be modified directly by the user.
 */
typedef struct I2C_Handle_s I2C_Handle_t;

/**
 * @brief  Initialize an I2C peripheral
 * @param  I2Cx: I2C peripheral instance to be initialized
 * @param  pI2CHandle: Pointer to I2C handle structure containing configuration settings
 * @return I2C_Result_t: Status of initialization
 */
I2C_Result_t I2C_Init(const I2C_Instance_t I2Cx, const I2C_Handle_t *pI2CHandle);

I2C_Result_t I2C_Write_Polling(const I2C_Handle_t * const pI2CHandle, const uint16_t destAddress, const uint8_t * const pData, const uint16_t dataSize);
I2C_Result_t I2C_Read_Polling(const I2C_Handle_t * const pI2CHandle, const uint16_t destAddress, uint8_t * const pData, const uint16_t dataSize);

I2C_Result_t I2C_Write_Interrupt(const I2C_Handle_t * const pI2CHandle, const uint16_t destAddress, const uint8_t * const pData, const uint16_t dataSize);
I2C_Result_t I2C_Read_Interrupt(const I2C_Handle_t * const pI2CHandle, const uint16_t destAddress, uint8_t * const pData, const uint16_t dataSize);

I2C_Result_t I2C_Write_DMA(const I2C_Handle_t * const pI2CHandle, const uint16_t destAddress, const uint8_t * const pData, const uint16_t dataSize);
I2C_Result_t I2C_Read_DMA(const I2C_Handle_t * const pI2CHandle, const uint16_t destAddress, uint8_t * const pData, const uint16_t dataSize);

I2C_Result_t I2C_WriteRegister(I2C_Handle_t *pI2CHandle, uint16_t DevAddress, uint16_t MemAddress, uint8_t *pData, uint16_t Size);
I2C_Result_t I2C_ReadRegister(I2C_Handle_t *pI2CHandle, uint16_t DevAddress, uint16_t MemAddress, uint8_t *pData, uint16_t Size);

void I2C_Error_Handler(void);

#endif /* __I2C_H */
