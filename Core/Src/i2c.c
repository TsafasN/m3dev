#include "i2c.h"
#include "stm32f1xx_ll_bus.h"
#include "stm32f1xx_ll_gpio.h"
#include "stdbool.h"
#include "stdio.h"

/**
 * @brief The I2C slave address of this device.
 */
#define I2C_SLAVE_OWN_ADDRESS   0x5A

/**
 * @brief Master Transfer Request Direction
 */
#define I2C_REQUEST_WRITE                       0x00
#define I2C_REQUEST_READ                        0x01

#define TX_BUFFER_SIZE_BYTES  100
#define RX_BUFFER_SIZE_BYTES  100

static uint8_t sTxBuf[TX_BUFFER_SIZE_BYTES] = {0x0};
static uint8_t sRxBuf[RX_BUFFER_SIZE_BYTES] = {0x0};


/**
 * @brief Structure for managing I2C peripheral configuration and state
 * @note  This structure is used internally by the I2C driver
 */
struct I2C_Handle_s {
    LL_I2C_InitTypeDef data;    /* I2C peripheral initialization structure */
    I2C_Instance_t hwInstance;    /* Pointer to the I2C peripheral instance */
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
        .hwInstance = I2C1,
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

static inline I2C_Result_t sSetupI2CPins(I2C_Instance_t I2Cx){
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

I2C_Result_t I2C_Init(const I2C_Instance_t I2Cx, const I2C_Handle_t *pI2CHandle){

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

I2C_Result_t I2C_Write_Polling(const I2C_Handle_t * const pI2CHandle, const uint16_t destAddress, const uint8_t * const pData, const uint16_t dataSize){
    /* Prepare acknowledge for Master data reception */
    LL_I2C_AcknowledgeNextData(pI2CHandle->hwInstance, LL_I2C_ACK);

    /* Master Generate Start condition */
    LL_I2C_GenerateStartCondition(pI2CHandle->hwInstance);

    /* Loop until Start Bit transmitted (SB flag raised) */
    /* Wait for the start condition to be generated */
    while (!LL_I2C_IsActiveFlag_SB(pI2CHandle->hwInstance));

    /* Send Slave address for a write request */
    LL_I2C_TransmitData8(pI2CHandle->hwInstance, destAddress | I2C_REQUEST_WRITE);

    /* Loop until Address Acknowledgement received (ADDR flag raised) */
    while (!LL_I2C_IsActiveFlag_ADDR(pI2CHandle->hwInstance));

    /* Clear the ADDR flag value in ISR register */
    LL_I2C_ClearFlag_ADDR(pI2CHandle->hwInstance);

    uint16_t dataSizeLeft = dataSize;
    uint8_t *pDataIndex = (uint8_t)pData;

    /* Loop until end of transfer (ubNbDataToTransmit == 0) */
    while (dataSizeLeft > 0)
    {
        /* Loop until TXE flag is raised  */
        while (!LL_I2C_IsActiveFlag_TXE(pI2CHandle->hwInstance));

        /* Write data in Transmit Data register. TXE flag is cleared by writing data in TXDR register */
        LL_I2C_TransmitData8(pI2CHandle->hwInstance, *pDataIndex);
        pDataIndex++;
        dataSizeLeft--;
    }

    /* End of transfer, Generate Stop condition */
    LL_I2C_GenerateStopCondition(pI2CHandle->hwInstance);

    return I2C_SUCCESS;
}

I2C_Result_t I2C_Read_Polling(const I2C_Handle_t * const pI2CHandle, const uint16_t destAddress, uint8_t * const pData, const uint16_t dataSize){
    /* Prepare acknowledge for Slave address reception */
    LL_I2C_AcknowledgeNextData(pI2CHandle->hwInstance, LL_I2C_ACK);

    /* Wait ADDR flag and check address match code and direction */
    while(!LL_I2C_IsActiveFlag_ADDR(pI2CHandle->hwInstance));

    /* Verify the transfer direction, direction at Read enter receiver mode */
    if(LL_I2C_GetTransferDirection(pI2CHandle->hwInstance) == LL_I2C_DIRECTION_READ)
    {
        /* Clear ADDR flag value in ISR register */
        LL_I2C_ClearFlag_ADDR(pI2CHandle->hwInstance);
    }
    else
    {
        /* Clear ADDR flag value in ISR register */
        LL_I2C_ClearFlag_ADDR(pI2CHandle->hwInstance);

        return I2C_ERROR;
    }

    uint8_t dataReceiveIndex = 0;

    /* Loop until end of transfer received (STOP flag raised) */
    while(!LL_I2C_IsActiveFlag_STOP(pI2CHandle->hwInstance))
    {
        /* Check RXNE flag value in ISR register */
        if(LL_I2C_IsActiveFlag_RXNE(pI2CHandle->hwInstance))
        {
            /* Read character in Receive Data register.
            RXNE flag is cleared by reading data in DR register */
            pData[dataReceiveIndex++] = LL_I2C_ReceiveData8(pI2CHandle->hwInstance);
        }

        /* Check BTF flag value in ISR register */
        if(LL_I2C_IsActiveFlag_BTF(pI2CHandle->hwInstance))
        {
            /* Read character in Receive Data register.
            BTF flag is cleared by reading data in DR register */
            pData[dataReceiveIndex++] = LL_I2C_ReceiveData8(pI2CHandle->hwInstance);
        }
    }

    /* Clear pending flags, Check Data consistency */

    /* End of I2C_SlaveReceiver_MasterTransmitter_DMA Process */
    LL_I2C_ClearFlag_STOP(I2C1);

    /* Check if data request to turn on the LED2 */
    if(Buffercmp8((uint8_t*)pData, (uint8_t*)sTxBuf, (dataReceiveIndex-1)) == 0)
    {
        /* Turn LED2 On:
        *  - Expected bytes have been received
        *  - Slave Rx sequence completed successfully
        */
        LED_On();
    }
    else
    {
        /* Call Error function */
        Error_Callback();
    }

    return I2C_SUCCESS;
}
