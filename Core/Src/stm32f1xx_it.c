#include "main.h"
#include "stm32f1xx_it.h"
#include "stm32f1xx_ll_i2c.h"


/******************************************************************************/
/*           Cortex-M3 Processor Interruption and Exception Handlers          */
/******************************************************************************/
/**
    * @brief This function handles Non maskable interrupt.
    */
void NMI_Handler(void)
{
     while (1)
    {

    }
}

/**
    * @brief This function handles Hard fault interrupt.
    */
void HardFault_Handler(void)
{
    while (1)
    {

    }
}

/**
    * @brief This function handles Memory management fault.
    */
void MemManage_Handler(void)
{
    while (1)
    {

    }
}

/**
    * @brief This function handles Prefetch fault, memory access fault.
    */
void BusFault_Handler(void)
{
    while (1)
    {

    }
}

/**
    * @brief This function handles Undefined instruction or illegal state.
    */
void UsageFault_Handler(void)
{
    while (1)
    {

    }
}

/**
    * @brief This function handles System service call via SWI instruction.
    */
void SVC_Handler(void)
{

}

/**
    * @brief This function handles Debug monitor.
    */
void DebugMon_Handler(void)
{

}

/**
    * @brief This function handles Pendable request for system service.
    */
void PendSV_Handler(void)
{

}

/**
    * @brief This function handles System tick timer.
    */
void SysTick_Handler(void)
{

}

/**
    * @brief This function handles EXTI line[15:10] interrupts.
    */
void EXTI15_10_IRQHandler(void)
{
    if (LL_EXTI_IsActiveFlag_0_31(LL_EXTI_LINE_13) != RESET)
    {
        LL_EXTI_ClearFlag_0_31(LL_EXTI_LINE_13);

        /* Manage code in main.c.*/
        UserButton_Callback();
    }
}

 void I2C2_EV_IRQHandler(void)
 {
    /* Check ADDR flag value in ISR register */
    if(LL_I2C_IsActiveFlag_ADDR(I2C2))
    {
        /* Verify the slave transfer direction, a read direction, Slave enters receiver mode */
        if(LL_I2C_GetTransferDirection(I2C2) == LL_I2C_DIRECTION_READ)
        {
            /* Enable Buffer Interrupts */
            LL_I2C_EnableIT_BUF(I2C2);

            /* Clear ADDR flag value in ISR register */
            LL_I2C_ClearFlag_ADDR(I2C2);
        }
        else
        {
            /* Clear ADDR flag value in ISR register */
            LL_I2C_ClearFlag_ADDR(I2C2);
        }
    }
    /* Check RXNE flag value in ISR register */
    else if(LL_I2C_IsActiveFlag_RXNE(I2C2))
    {
        /* Call function Slave Reception Callback */
        Slave_Reception_Callback();
    }
    /* Check BTF flag value in ISR register */
    else if(LL_I2C_IsActiveFlag_BTF(I2C2))
    {
        /* Call function Slave Reception Callback */
        Slave_Reception_Callback();
    }
    /* Check STOP flag value in ISR register */
    else if(LL_I2C_IsActiveFlag_STOP(I2C2))
    {
        /* Clear STOP flag value in ISR register */
        LL_I2C_ClearFlag_STOP(I2C2);

        /* Call function Slave Complete Callback */
        Slave_Complete_Callback();
    }
 }

 void I2C2_ER_IRQHandler(void)
 {
    /* Call Error function */
    Error_Callback();
 }
