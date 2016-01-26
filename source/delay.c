#include "delay.h"
#include <stdint.h>

extern uint32_t  SystemCoreClock;

#define DELAY_SCALE_FACTOR_US 2

void delay_ms(int time_ms){
    delay_us(time_ms*1000);
}

void delay_us(int time_us){
    unsigned int total_time  = time_us * (SystemCoreClock /(1000000 * DELAY_SCALE_FACTOR_US));
    for(unsigned int i = 0; i< total_time; i++){
    }
}
