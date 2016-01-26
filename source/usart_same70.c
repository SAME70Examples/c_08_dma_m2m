#include "usart_same70.h"
#include "same70.h"                     // Device header
#include "extra_defines_same70.h"

void usart1_init(int baudrate){
    //Configure pio pins for usart operation PA21:RXD1 PB4:TXD1

    MATRIX->CCFG_SYSIO |= CCFG_SYSIO_SYSIO4;//Transfer control from SYSIO:TDI to PIOB

    PMC->PMC_PCR = (PMC_PCR_EN)|(PMC_PCR_CMD_WRITE)|(PMC_PCR_PID_PIOA);//Enable PIOA Peripheral
    PIOA->PIO_PDR = PIO_PDR_P21;//Disable direct control of PA21
    PIOA->PIO_PUER = PIO_PUER_P21;//Enable pull ups
    PIOA->PIO_PPDDR = PIO_PPDDR_P21;//Disable pull downs
    PIOA->PIO_ABCDSR[0] &= ~(PIO_ABCDSR_P21);//Select peripheral A for RXD1
    PIOA->PIO_ABCDSR[1] &= ~(PIO_ABCDSR_P21);//Select peripheral A for RXD1

    PMC->PMC_PCR = (PMC_PCR_EN)|(PMC_PCR_CMD_WRITE)|(PMC_PCR_PID_PIOB);//Enable PIOB Peripheral
    PIOB->PIO_PUDR = PIO_PUDR_P4;//Disable pull ups
    PIOB->PIO_PPDDR = PIO_PPDDR_P4;//Disable pull downs
    PIOB->PIO_ABCDSR[0] |= PIO_ABCDSR_P4;//Select peripheral D for TXD1
    PIOB->PIO_ABCDSR[1] |= PIO_ABCDSR_P4;//Select peripheral D for TXD1
    PIOB->PIO_PDR = PIO_PDR_P4;//Disable direct control of PB4

    PMC->PMC_PCR = (PMC_PCR_EN)|(PMC_PCR_CMD_WRITE)|(PMC_PCR_PID_USART1);//Enable USART1 Peripheral
    USART1->US_MR = 0;
    USART1->US_MR = (US_MR_USART_MODE_NORMAL | US_MR_USCLKS_MCK
    | US_MR_CHRL_8_BIT | US_MR_PAR_NO);
    USART1->US_BRGR = (4<<16)|(987<<0);//(fractional divider)|(integer dividier) 9600bps@150Mhz peripheral clock
    USART1->US_CR = US_CR_RXEN | US_CR_TXEN;//Enable receiver and transmitter

    NVIC_EnableIRQ(USART1_IRQn);//Enble interrup reception from NVIC
}

void usart1_putc(char c){
    while(!(USART1->US_CSR & US_CSR_TXRDY));
    USART1->US_THR = c;
}

char usart1_getc(void){
    while(!(USART1->US_CSR & US_CSR_RXRDY));
    return USART1->US_RHR;
}

void usart1_puts(const char* pString){
    char c;
    int index = 0;
    c = pString[index];

    while(c != '\0'){
        usart1_putc(c);
        index++;
        c = pString[index];
    }
}

volatile int usart1_tx_complete = 1;
volatile const char *  pTxData;
volatile int usart1_tx_data_size = 0;
volatile int txData_index = 0;
void (*usart1_tx_complete_callback)(void);

void usart1_async_puts(const char* pString, void (*tx_complete_callback)(void)){
    if(pString[0] != '\0'){
        usart1_tx_complete = 0;
        txData_index = 0;
        pTxData = pString;
        usart1_tx_complete_callback = tx_complete_callback;
        USART1->US_IER = US_IER_TXRDY;
    }
}

volatile int usart1_rx_complete = 1;
volatile char* usart1_rx_buffer;
volatile int usart1_rx_data_counter = 0;
void (*usart1_rx_complete_callback)(int);

void usart1_async_gets(char* pString, void (*rx_complete_callback)(int)){
    usart1_rx_data_counter = 0;
    usart1_rx_buffer = pString;
    usart1_rx_complete_callback = rx_complete_callback;
    usart1_rx_complete = 0;
    USART1->US_IER = US_IER_RXRDY;//Enable Rx interrupt
}

void USART1_Handler(void){
    uint32_t usart1_status = USART1->US_CSR;
    if((usart1_status & US_CSR_TXRDY) && (usart1_tx_complete == 0)){
        USART1->US_THR = pTxData[txData_index];
        txData_index++;
        if(pTxData[txData_index] == '\0'){
            USART1->US_IDR = US_IDR_TXRDY;
            usart1_tx_complete = 1;
            usart1_tx_complete_callback();
        }
    }
    if((usart1_status & US_CSR_RXRDY) && (usart1_rx_complete == 0)){
        char rx_new_data = USART1->US_RHR;
        if(rx_new_data == '\r'){
            usart1_rx_buffer[usart1_rx_data_counter] = '\0';//append string termination
            USART1->US_IDR = US_IDR_RXRDY;//Disable rx irq
            usart1_rx_complete = 1;
            usart1_rx_complete_callback(usart1_rx_data_counter);
        }else{
            usart1_rx_buffer[usart1_rx_data_counter] = rx_new_data;
            usart1_rx_data_counter++;
        }
    }
}
