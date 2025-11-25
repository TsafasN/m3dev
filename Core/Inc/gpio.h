#ifndef __GPIO_H
#define __GPIO_H

#include <stdint.h>
#include "stm32f1xx_ll_gpio.h"

#define USER_BUTTON_PIN             LL_GPIO_PIN_13
#define USER_BUTTON_GPIO_PORT       GPIOC

#define LED2_PIN                    LL_GPIO_PIN_5
#define LED2_GPIO_PORT              GPIOA

enum {
    LED_BLINK_FAST = 200,
    LED_BLINK_SLOW = 500,
    LED_BLINK_ERROR = 1000
};

void LED_Init(void);
void LED_On(void);
void LED_Off(void);
void LED_Blinking(uint32_t Period);

void UserButton_Init(void);
void WaitForUserButtonPress(void);

#endif /* __GPIO_H */
