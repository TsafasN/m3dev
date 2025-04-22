#include "i2c.h"
#include "stdbool.h"
#include "stdio.h"

/**
 * @brief The I2C slave address of this device.
 */
#define I2C_SLAVE_OWN_ADDRESS   0x5A

struct I2C_Handle_s {
    LL_I2C_InitTypeDef data;    /* I2C peripheral initialization structure */
    bool isInitialized;         /* Flag to ensure initialization happens only once */
};

/**
 * @brief Initializes an I2C handle for the specified I2C instance
 *
 * @param I2Cx The I2C instance to initialize (I2C1, I2C2, etc)
 * @param pI2CHandle Pointer to I2C handle structure to initialize
 * @return I2C_Result_t Status of the initialization operation
 */
static inline I2C_Result_t sInitI2CHandle(I2C_Instance_t I2Cx, I2C_Handle_t *pI2CHandle);

/**
 * @brief  Configure the I2C pins
 *
 * @param I2Cx The I2C instance to initialize (I2C1, I2C2, etc)
 * @return I2C_Result_t Status of the initialization operation
 */
static inline I2C_Result_t sSetupI2CPins(I2C_Instance_t I2Cx);

/**
 * @brief  Configure the I2C peripheral
 *
 * @param I2Cx The I2C instance to initialize (I2C1, I2C2, etc)
 * @param pI2CHandle Pointer to I2C handle structure to initialize
 * @return I2C_Result_t Status of the initialization operation
 */
static inline I2C_Result_t sSetupI2CPeriph(I2C_Instance_t I2Cx, I2C_Handle_t *pI2CHandle);

static inline I2C_Result_t sInitI2CHandle(I2C_Instance_t I2Cx, I2C_Handle_t *pI2CHandle){

    /* I2C handler instance in memory */
    static I2C_Handle_t sI2CHandle = (I2C_Handle_t){
        .data = (LL_I2C_InitTypeDef){
            .PeripheralMode  = LL_I2C_MODE_I2C,
            .ClockSpeed      = LL_I2C_MAX_SPEED_STANDARD,
            .DutyCycle       = LL_I2C_DUTYCYCLE_2,
            .OwnAddress1     = I2C_SLAVE_OWN_ADDRESS,
            .TypeAcknowledge = LL_I2C_ACK,
            .OwnAddrSize     = LL_I2C_OWNADDRESS1_7BIT
        },
        .isInitialized = false
    };

    /* Singleton pattern */
    if (sI2CHandle.isInitialized == false){

        sI2CHandle.isInitialized = true;
        pI2CHandle = &sI2CHandle;

        return I2C_SUCCESS;
    }else{
        /* Already initialized */
        return I2C_ERROR;
    }
}

static inline I2C_Result_t sSetupI2CPins(I2C_Instance_t I2Cx)
{
    /* Enable the peripheral clock of GPIOB */
    LL_APB2_GRP1_EnableClock(LL_APB2_GRP1_PERIPH_GPIOB);

    /* Configure SCL Pin as : Alternate function, High Speed, Open drain, Pull up */
    LL_GPIO_SetPinMode(GPIOB, LL_GPIO_PIN_6, LL_GPIO_MODE_ALTERNATE);
    LL_GPIO_SetPinSpeed(GPIOB, LL_GPIO_PIN_6, LL_GPIO_SPEED_FREQ_HIGH);
    LL_GPIO_SetPinOutputType(GPIOB, LL_GPIO_PIN_6, LL_GPIO_OUTPUT_OPENDRAIN);
    LL_GPIO_SetPinPull(GPIOB, LL_GPIO_PIN_6, LL_GPIO_PULL_UP);

    /* Configure SDA Pin as : Alternate function, High Speed, Open drain, Pull up */
    LL_GPIO_SetPinMode(GPIOB, LL_GPIO_PIN_7, LL_GPIO_MODE_ALTERNATE);
    LL_GPIO_SetPinSpeed(GPIOB, LL_GPIO_PIN_7, LL_GPIO_SPEED_FREQ_HIGH);
    LL_GPIO_SetPinOutputType(GPIOB, LL_GPIO_PIN_7, LL_GPIO_OUTPUT_OPENDRAIN);
    LL_GPIO_SetPinPull(GPIOB, LL_GPIO_PIN_7, LL_GPIO_PULL_UP);
}

static inline I2C_Result_t sSetupI2CPeriph(I2C_Instance_t I2Cx, I2C_Handle_t *pI2CHandle){
    /* Enable the peripheral clock for I2C1 */
    LL_APB1_GRP1_EnableClock(LL_APB1_GRP1_PERIPH_I2C1);

    NVIC_SetPriority(I2C1_EV_IRQn, 0);
    NVIC_EnableIRQ(I2C1_EV_IRQn);

    NVIC_SetPriority(I2C1_ER_IRQn, 0);
    NVIC_EnableIRQ(I2C1_ER_IRQn);

    if (LL_I2C_DeInit(I2C1) != SUCCESS)
    {
        return I2C_ERROR;
    }

    /* Initialize I2C instance according to parameters defined in initialization structure. */
    if (LL_I2C_Init(I2C1, &(pI2CHandle->data)) != SUCCESS)
    {
        return I2C_ERROR;
    }

    /* Disable I2C1 (to prevent misplaced start/stop conditions) */
    LL_I2C_Disable(I2C1);

    return I2C_SUCCESS;
}

I2C_Result_t I2C_Init(I2C_Instance_t I2Cx, I2C_Handle_t *pI2CHandle){

    if (sInitI2CHandle(I2Cx, pI2CHandle) == I2C_ERROR){
        return I2C_ERROR;
    }

    if (sSetupI2CPins(I2Cx) == I2C_ERROR){
        return I2C_ERROR;
    }

    if (sSetupI2CPeriph(I2Cx, pI2CHandle) == I2C_ERROR){
        return I2C_ERROR;
    }

    return I2C_SUCCESS;
}

// ErrorStatus I2C_Write(I2C_TypeDef *I2Cx, uint16_t DevAddress, uint8_t *pData, uint16_t Size){
//     // Start the I2C transmission
//     LL_I2C_GenerateStart(I2Cx);

//     // Wait for the start condition to be generated
//     while (!LL_I2C_IsActiveFlag_SB(I2Cx));

//     // Send the device address
//     LL_I2C_TransmitData8(I2Cx, DevAddress << 1);

//     // Wait for the address to be acknowledged
//     while (!LL_I2C_IsActiveFlag_ADDR(I2Cx));

//     // Clear the ADDR flag
//     LL_I2C_ClearFlag_ADDR(I2Cx);

//     // Transmit data
//     for (uint16_t i = 0; i < Size; i++) {
//         LL_I2C_TransmitData8(I2Cx, pData[i]);
//         while (!LL_I2C_IsActiveFlag_TXE(I2Cx));
//     }

//     // Generate stop condition
//     LL_I2C_GenerateStop(I2Cx);

//     return SUCCESS;
// }

// ErrorStatus I2C_Read(I2C_TypeDef *I2Cx, uint16_t DevAddress, uint8_t *pData, uint16_t Size){
//     // Start the I2C transmission
//     LL_I2C_GenerateStart(I2Cx);

//     // Wait for the start condition to be generated
//     while (!LL_I2C_IsActiveFlag_SB(I2Cx));

//     // Send the device address with read bit
//     LL_I2C_TransmitData8(I2Cx, (DevAddress << 1) | 0x01);

//     // Wait for the address to be acknowledged
//     while (!LL_I2C_IsActiveFlag_ADDR(I2Cx));

//     // Clear the ADDR flag
//     LL_I2C_ClearFlag_ADDR(I2Cx);

//     // Receive data
//     for (uint16_t i = 0; i < Size; i++) {
//         while (!LL_I2C_IsActiveFlag_RXNE(I2Cx));
//         pData[i] = LL_I2C_ReceiveData8(I2Cx);
//     }

//     // Generate stop condition
//     LL_I2C_GenerateStop(I2Cx);

//     return SUCCESS;
// }

// ErrorStatus I2C_WriteRegister(I2C_TypeDef *I2Cx, uint16_t DevAddress, uint16_t MemAddress, uint8_t *pData, uint16_t Size){
//     // Start the I2C transmission
//     LL_I2C_GenerateStart(I2Cx);

//     // Wait for the start condition to be generated
//     while (!LL_I2C_IsActiveFlag_SB(I2Cx));

//     // Send the device address with write bit
//     LL_I2C_TransmitData8(I2Cx, DevAddress << 1);

//     // Wait for the address to be acknowledged
//     while (!LL_I2C_IsActiveFlag_ADDR(I2Cx));

//     // Clear the ADDR flag
//     LL_I2C_ClearFlag_ADDR(I2Cx);

//     // Send the memory address
//     LL_I2C_TransmitData8(I2Cx, MemAddress);

//     // Wait for the data register to be empty
//     while (!LL_I2C_IsActiveFlag_TXE(I2Cx));

//     // Transmit data
//     for (uint16_t i = 0; i < Size; i++) {
//         LL_I2C_TransmitData8(I2Cx, pData[i]);
//         while (!LL_I2C_IsActiveFlag_TXE(I2Cx));
//     }

//     // Generate stop condition
//     LL_I2C_GenerateStop(I2Cx);

//     return SUCCESS;
// }

// ErrorStatus I2C_ReadRegister(I2C_TypeDef *I2Cx, uint16_t DevAddress, uint16_t MemAddress, uint8_t *pData, uint16_t Size){
//     // Start the I2C transmission
//     LL_I2C_GenerateStart(I2Cx);

//     // Wait for the start condition to be generated
//     while (!LL_I2C_IsActiveFlag_SB(I2Cx));

//     // Send the device address with write bit
//     LL_I2C_TransmitData8(I2Cx, DevAddress << 1);

//     // Wait for the address to be acknowledged
//     while (!LL_I2C_IsActiveFlag_ADDR(I2Cx));

//     // Clear the ADDR flag
//     LL_I2C_ClearFlag_ADDR(I2Cx);

//     // Send the memory address
//     LL_I2C_TransmitData8(I2Cx, MemAddress);

//     // Wait for the data register to be empty
//     while (!LL_I2C_IsActiveFlag_TXE(I2Cx));

//     // Generate repeated start condition
//     LL_I2C_GenerateStart(I2Cx);

//     // Wait for the start condition to be generated
//     while (!LL_I2C_IsActiveFlag_SB(I2Cx));

//     // Send the device address with read bit
//     LL_I2C_TransmitData8(I2Cx, (DevAddress << 1) | 0x01);

//     // Wait for the address to be acknowledged
//     while (!LL_I2C_IsActiveFlag_ADDR(I2Cx));

//     // Clear the ADDR flag
//     LL_I2C_ClearFlag_ADDR(I2Cx);

//     // Receive data
//     for (uint16_t i = 0; i < Size; i++) {
//         while (!LL_I2C_IsActiveFlag_RXNE(I2Cx));
//         pData[i] = LL_I2C_ReceiveData8(I2Cx);
//         if (i == Size - 1) {
//             LL_I2C_GenerateStop(I2Cx);
//         }
//     }

//     return SUCCESS;
// }
