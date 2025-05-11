#include "main.h"

#include "stdio.h"
#include "stdbool.h"
#include "gpio.h"
#include "i2c.h"

const uint8_t aLedOn[]                  = "LED ON";

volatile uint16_t ubNbDataToTransmit    = sizeof(aLedOn);
uint8_t* pTransmitBuffer                = (uint8_t*)aLedOn;

uint8_t  aReceiveBuffer[0xF]            = {0};

void SystemClock_Config(void);

int main(void)
{
    /* Reset of all peripherals, Initializes the Flash interface and the Systick. */
    LL_APB2_GRP1_EnableClock(LL_APB2_GRP1_PERIPH_AFIO);
    LL_APB1_GRP1_EnableClock(LL_APB1_GRP1_PERIPH_PWR);

    /* System interrupt init*/
    NVIC_SetPriorityGrouping(NVIC_PRIORITYGROUP_4);

    /* Configure the system clock */
    SystemClock_Config();

    /* Initialize LED2 */
    LED_Init();

    /* Set LED2 Off */
    LED_Off();

    /* Initialize User push-button in EXTI mode */
    UserButton_Init();

    const I2C_Handle_t *pI2CHandle1 = NULL;
    const I2C_Handle_t *pI2CHandle2 = NULL;

    if (I2C_Init(I2C1, &pI2CHandle1) == I2C_ERROR)
    {
        Error_Handler();
    }

    if (I2C_Init(I2C2, &pI2CHandle2) == I2C_ERROR)
    {
        Error_Handler();
    }

    /* Wait for User push-button press to start transfer */
    WaitForUserButtonPress();

    uint32_t destAddress = 0;
    I2C_Get_Address(pI2CHandle2, &destAddress);

    I2C_Read_Interrupt(pI2CHandle2, aReceiveBuffer, sizeof(aReceiveBuffer));

    I2C_Write_Polling(pI2CHandle1, destAddress, pTransmitBuffer, ubNbDataToTransmit);

    LED_On();

    /* Infinite loop */
    while (1)
    {
    }

}

void SystemClock_Config(void)
{
    LL_FLASH_SetLatency(LL_FLASH_LATENCY_1);
    while(LL_FLASH_GetLatency()!= LL_FLASH_LATENCY_1)
    {
    }
    LL_RCC_HSI_SetCalibTrimming(16);
    LL_RCC_HSI_Enable();

     /* Wait till HSI is ready */
    while(LL_RCC_HSI_IsReady() != 1)
    {

    }
    LL_RCC_LSI_Enable();

     /* Wait till LSI is ready */
    while(LL_RCC_LSI_IsReady() != 1)
    {

    }
    LL_RCC_PLL_ConfigDomain_SYS(LL_RCC_PLLSOURCE_HSI_DIV_2, LL_RCC_PLL_MUL_8);
    LL_RCC_PLL_Enable();

     /* Wait till PLL is ready */
    while(LL_RCC_PLL_IsReady() != 1)
    {

    }
    LL_RCC_SetAHBPrescaler(LL_RCC_SYSCLK_DIV_1);
    LL_RCC_SetAPB1Prescaler(LL_RCC_APB1_DIV_1);
    LL_RCC_SetAPB2Prescaler(LL_RCC_APB2_DIV_1);
    LL_RCC_SetSysClkSource(LL_RCC_SYS_CLKSOURCE_PLL);

     /* Wait till System clock is ready */
    while(LL_RCC_GetSysClkSource() != LL_RCC_SYS_CLKSOURCE_STATUS_PLL)
    {

    }
    LL_Init1msTick(32000000);
    LL_SetSystemCoreClock(32000000);
}

void Error_Handler(void)
{
    __disable_irq();
    while (1)
    {
    }
}

void Error_Callback(void)
{
    NVIC_DisableIRQ(I2C1_EV_IRQn);
    NVIC_DisableIRQ(I2C1_ER_IRQn);

    NVIC_DisableIRQ(I2C2_EV_IRQn);
    NVIC_DisableIRQ(I2C2_ER_IRQn);

    LED_Blinking(LED_BLINK_ERROR);
}
