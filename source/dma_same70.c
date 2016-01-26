#include "dma_same70.h"
#include "same70.h"                     // Device header
#include "extra_defines_same70.h"

static volatile int dma_xfer_in_progress;

void dma_init(void){
    PMC->PMC_PCR = (PMC_PCR_EN)|(PMC_PCR_CMD_WRITE)|(PMC_PCR_PID_XDMAC);//Enable XDMAC Peripheral
    NVIC_EnableIRQ(XDMAC_IRQn);
}

void dma_xfer(void * source, void * destiny, int size){
    int dumy = XDMAC->XDMAC_CHID[0].XDMAC_CIS;//read the CIS to clear pending interrupts
    XDMAC->XDMAC_CHID[0].XDMAC_CSA = (uint32_t)source;
    XDMAC->XDMAC_CHID[0].XDMAC_CDA = (uint32_t)destiny;
    XDMAC->XDMAC_CHID[0].XDMAC_CUBC = size;
    XDMAC->XDMAC_CHID[0].XDMAC_CC = (XDMAC_CC_TYPE_MEM_TRAN | XDMAC_CC_MBSIZE_FOUR
    | XDMAC_CC_DAM_INCREMENTED_AM | XDMAC_CC_SAM_INCREMENTED_AM| XDMAC_CC_DWIDTH_BYTE
    | XDMAC_CC_SIF_AHB_IF0 | XDMAC_CC_DIF_AHB_IF1 | XDMAC_CC_SWREQ_SWR_CONNECTED);
    XDMAC->XDMAC_CHID[0].XDMAC_CNDC = 0;
    XDMAC->XDMAC_CHID[0].XDMAC_CBC = 0;
    XDMAC->XDMAC_CHID[0].XDMAC_CDS_MSP = 0;
    XDMAC->XDMAC_CHID[0].XDMAC_CSUS = 0;
    XDMAC->XDMAC_CHID[0].XDMAC_CDUS = 0;

    dma_xfer_in_progress = 1;

    XDMAC->XDMAC_CHID[0].XDMAC_CIE =  XDMAC_CIE_BIE;
    XDMAC->XDMAC_GIE = XDMAC_GIE_IE0;
    
    XDMAC->XDMAC_GE = XDMAC_GE_EN0;
    XDMAC->XDMAC_GSWR = XDMAC_GSWR_SWREQ0;
    while(dma_xfer_in_progress);
}

void XDMAC_Handler(void){
    dma_xfer_in_progress = 0;
    int dumy = XDMAC->XDMAC_CHID[0].XDMAC_CIS;//read the CIS to clear pending interrupts
}
