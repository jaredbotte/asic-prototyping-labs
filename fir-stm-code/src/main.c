/**
  ******************************************************************************
  * @file    main.c
  * @author  Ac6
  * @version V1.0
  * @date    01-December-2013
  * @brief   Default main function.
  ******************************************************************************
*/


#include "stm32f0xx.h"
			
#define RATE 48000
#define BUFF_LEN 4800

uint16_t samples_in[BUFF_LEN];
uint16_t samples_out[BUFF_LEN];

// Use a half transfer to start the DAC.

// DMA1 Channel1 for ADC
// DMA1 Channel3 for DAC_Channel1
// DMA1 Channel4 for SPI2_RX
// DMA1 Channel5 for SPI2_TX

// Use TIM3 to trigger both DAC and ADC

void setup_adc(){
    RCC -> AHBENR |= RCC_AHBENR_GPIOAEN;
    GPIOA -> MODER |= GPIO_MODER_MODER3;
    RCC -> APB2ENR |= RCC_APB2ENR_ADC1EN;
    RCC -> CR2 |= RCC_CR2_HSI14ON;
    while(!(RCC -> CR2 & RCC_CR2_HSI14RDY));
    ADC1 -> CR |= ADC_CR_ADEN;
    while(!(ADC1 -> ISR & ADC_ISR_ADRDY));
    while(ADC1 -> CR & ADC_CR_ADSTART);
    ADC1 -> CHSELR |= ADC_CHSELR_CHSEL3;
    // Now let's try adding DMA into the mix
    ADC1 -> CFGR1 |= ADC_CFGR1_DMACFG | ADC_CFGR1_DMAEN;
    RCC -> AHBENR |= RCC_AHBENR_DMA1EN;
    DMA1_Channel1 -> CCR |= DMA_CCR_MSIZE_0 | DMA_CCR_PSIZE_0 | DMA_CCR_MINC;
    DMA1_Channel1 -> CCR |= DMA_CCR_CIRC | DMA_CCR_HTIE;
    DMA1_Channel1 -> CNDTR = BUFF_LEN;
    DMA1_Channel1 -> CPAR = (uint32_t) &(ADC1 -> DR);
    DMA1_Channel1 -> CMAR = (uint32_t) samples_in;
    NVIC -> ISER[0] = 1 << DMA1_Ch1_IRQn;
    DMA1_Channel1 -> CCR |= DMA_CCR_EN;
}

void setup_dac(){
    // setup_adc has already configured GPIOA
    RCC -> APB1ENR |= RCC_APB1ENR_DACEN;
    //DAC -> CR |= DAC_CR_TSEL1 | DAC_CR_TEN1 | DAC_CR_DMAEN1;
    DMA1_Channel3 -> CCR |= DMA_CCR_MSIZE_0 | DMA_CCR_PSIZE_0 | DMA_CCR_MINC;
    DMA1_Channel3 -> CCR |= DMA_CCR_CIRC | DMA_CCR_DIR;
    DMA1_Channel3 -> CNDTR = BUFF_LEN;
    DMA1_Channel3 -> CPAR = (uint32_t) &(DAC -> DHR12R1);
    DMA1_Channel3 -> CMAR = (uint32_t) samples_out;
    DMA1_Channel3 -> CCR |= DMA_CCR_EN;
    DAC -> CR |= DAC_CR_EN1;
}

void TIM3_IRQHandler(){
    // I wish I didn't have to have this but for whatever reason
    // having the timer directly trigger the ADC is not working
    TIM3 -> SR = ~(TIM_SR_UIF);
    ADC1 -> CR |= ADC_CR_ADSTART;
    //DAC -> SWTRIGR  = DAC_SWTRIGR_SWTRIG1;
}

void setup_tim3(){
    RCC -> APB1ENR |= RCC_APB1ENR_TIM3EN;
    //TIM3 -> CR2 |= TIM_CR2_MMS_1; // TRGO on Update Event
    TIM3 -> PSC = 100 - 1;
    TIM3 -> ARR = ((48000000 / (TIM3 -> PSC + 1)) / RATE) - 1;
    TIM3 -> DIER |= TIM_DIER_UIE | TIM_DIER_UDE;
    NVIC -> ISER[0] = 1 << TIM3_IRQn;
    TIM3 -> CR1 |= TIM_CR1_CEN;
}

void setup_spi2(){
    RCC -> APB1ENR |= RCC_APB1ENR_SPI2EN;
    RCC -> AHBENR |= RCC_AHBENR_GPIOBEN;
    // PB12 - NSS
    // PB13 - SCK
    // PB14 - MISO
    // PB15 - MOSI
    GPIOB -> MODER |= GPIO_MODER_MODER12_1 | GPIO_MODER_MODER13_1 | GPIO_MODER_MODER14_1 | GPIO_MODER_MODER15_1;
    SPI2 -> CR1 &= ~SPI_CR1_SPE;
    SPI2 -> CR1 |= SPI_CR1_BR_1 | SPI_CR1_MSTR;
    SPI2 -> CR2 = 0x0B00 | SPI_CR2_TXDMAEN | SPI_CR2_RXDMAEN | SPI_CR2_NSSP | SPI_CR2_SSOE;
    // Setup receive DMA
    DMA1_Channel4 -> CCR |= DMA_CCR_MSIZE_0 | DMA_CCR_PSIZE_0 | DMA_CCR_MINC;
    DMA1_Channel4 -> CCR |= DMA_CCR_CIRC;
    DMA1_Channel4 -> CNDTR = BUFF_LEN;
    DMA1_Channel4 -> CMAR = (uint32_t) samples_out;
    DMA1_Channel4 -> CPAR = (uint32_t) &(SPI2 -> DR);
    DMA1_Channel4 -> CCR |= DMA_CCR_EN;
    // Setup transmit DMA
    DMA1_Channel5 -> CCR |= DMA_CCR_MSIZE_0 | DMA_CCR_PSIZE_0 | DMA_CCR_MINC;
    DMA1_Channel5 -> CCR |= DMA_CCR_CIRC | DMA_CCR_DIR;
    DMA1_Channel5 -> CNDTR = BUFF_LEN;
    DMA1_Channel5 -> CMAR = (uint32_t) samples_in;
    DMA1_Channel5 -> CPAR = (uint32_t) &(SPI2 -> DR);
    DMA1_Channel5 -> CCR |= DMA_CCR_EN;
    SPI2 -> CR1 |= SPI_CR1_SPE;
}

void DMA1_CH1_IRQHandler(){
    // Acknowledge interrupt
    DMA1 -> IFCR = DMA_IFCR_CHTIF1;
    setup_spi2();
    // Disable interrupt
    DMA1_Channel1 -> CCR &= ~(DMA_CCR_HTIE);
    NVIC -> ICER[0] = 1 << DMA1_Ch1_IRQn;
}

int main(void)
{
    setup_adc();
    setup_dac();
    setup_tim3();
	for(;;) {
	    asm("wfi");
	}
}
