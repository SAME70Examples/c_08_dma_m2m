#include "same70.h"                     // Device header
#include "board.h"
#include "delay.h"
#include "watchdogs.h"
#include "cmsis_os.h"                   // ARM::CMSIS:RTOS:Keil RTX
#include "os_usart_same70.h"
#include "os_serial_stdio.h"

/*----------------------------------------------------------------------------
 *      Thread 1 'Thread_Name': Led blinker
 *---------------------------------------------------------------------------*/

void Thread1 (void const *argument);                             // thread function
osThreadId tid_Thread1;                                          // thread id
osThreadDef (Thread1, osPriorityNormal, 1, 0);                   // thread object

int Thread1_init(void){
  tid_Thread1 = osThreadCreate (osThread(Thread1), NULL);
  if(!tid_Thread1) return(-1);

  return(0);
}

void Thread1(void const *argument) {
  while(1){
	//TODO
	led_setState(LED_ON);
	osDelay(500);
	led_setState(LED_OFF);
	osDelay(500);
  }
}

int main(){
	//PreKernelConfigration
	SystemCoreClockUpdate();
	watchdogs_disable_all();
	//Initialize kernel
	osKernelInitialize();
	//Initialized hardware
	os_usart1_init(9600);
	button_init();
	led_init();
	os_serial_init();
	//Initialize os objects
	Thread1_init();
	//Start kernel and thread switching
	osKernelStart();
	//User application
	char myBuffer[80];
	int lineCounter = 1;

	os_usart1_puts("System ready!\n");

	while(1){
		os_usart1_gets(myBuffer);
		os_serial_printf(os_usart1_puts,">>%s\n",myBuffer);
		lineCounter++;
	}
}
