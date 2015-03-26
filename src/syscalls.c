
#include "conf.h"

extern UART_HandleTypeDef UartHandle;

int _write(int file, char *ptr, int len) 
{ 
  HAL_UART_Transmit(&UartHandle, (uint8_t*) ptr, len, 0xffff); 
  return len; 
}
