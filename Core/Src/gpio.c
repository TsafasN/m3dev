#include "gpio.h"
#include "stm32f1xx_ll_bus.h"
#include "stm32f1xx_ll_exti.h"
#include "stm32f1xx_ll_utils.h"

volatile uint8_t ubButtonPress = 0;

void UserButton_Init(void)
{
    LL_APB2_GRP1_EnableClock(LL_APB2_GRP1_PERIPH_GPIOC);

    LL_GPIO_SetPinMode(USER_BUTTON_GPIO_PORT, USER_BUTTON_PIN, LL_GPIO_MODE_INPUT);

    LL_APB2_GRP1_EnableClock(LL_APB2_GRP1_PERIPH_AFIO);

    LL_GPIO_AF_SetEXTISource(LL_GPIO_AF_EXTI_PORTC, LL_GPIO_AF_EXTI_LINE13);

    LL_EXTI_EnableIT_0_31(LL_EXTI_LINE_13);
    LL_EXTI_EnableFallingTrig_0_31(LL_EXTI_LINE_13);

    NVIC_EnableIRQ(EXTI15_10_IRQn);
    NVIC_SetPriority(EXTI15_10_IRQn, 0x03);
}

void WaitForUserButtonPress(void)
{
    while (ubButtonPress == 0)
    {
        LL_GPIO_TogglePin(LED2_GPIO_PORT, LED2_PIN);
        LL_mDelay(LED_BLINK_FAST);
    }

    LL_GPIO_ResetOutputPin(LED2_GPIO_PORT, LED2_PIN);
}

void UserButton_Callback(void)
{
    ubButtonPress = 1;
}

void LED_Init(void)
{
    LL_APB2_GRP1_EnableClock(LL_APB2_GRP1_PERIPH_GPIOA);

    LL_GPIO_SetPinMode(LED2_GPIO_PORT, LED2_PIN, LL_GPIO_MODE_OUTPUT);
    LL_GPIO_SetPinOutputType(LED2_GPIO_PORT, LED2_PIN, LL_GPIO_OUTPUT_PUSHPULL);
    LL_GPIO_SetPinSpeed(LED2_GPIO_PORT, LED2_PIN, LL_GPIO_SPEED_FREQ_LOW);
    LL_GPIO_SetPinPull(LED2_GPIO_PORT, LED2_PIN, LL_GPIO_PULL_UP);
}

void LED_On(void)
{
    LL_GPIO_SetOutputPin(LED2_GPIO_PORT, LED2_PIN);
}

void LED_Off(void)
{
    LL_GPIO_ResetOutputPin(LED2_GPIO_PORT, LED2_PIN);
}

void LED_Blinking(uint32_t Period)
{
    LL_GPIO_SetOutputPin(LED2_GPIO_PORT, LED2_PIN);

    while (1)
    {
        LL_GPIO_TogglePin(LED2_GPIO_PORT, LED2_PIN);
        LL_mDelay(Period);
    }
}
