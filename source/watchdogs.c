#include "watchdogs.h"
#include "same70.h"                     // Device header

void watchdogs_disable_all(void){
    watchdogs_disable_wdt();
    watchdogs_disable_rswdt();
}

void watchdogs_disable_wdt(void){
    WDT->WDT_CR = WDT_CR_KEY_PASSWD;
    WDT->WDT_MR = WDT_MR_WDDIS;
}

void watchdogs_disable_rswdt(void){
    RSWDT->RSWDT_CR = RSWDT_CR_KEY_PASSWD;
    RSWDT->RSWDT_MR = RSWDT_MR_WDDIS | RSWDT_MR_ALLONES_Msk;
}
