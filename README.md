
This project is a small example of how to use `STM32CubeF4`'s HAL library with the `Nucleo STM32F411` board on Linux. 

The program in `src/main.c` is quite simple;

 - The clock system is configured to run at 100 MHz from the internal RC oscillator 
 - GPIOA Pin 5 is set up as output (pull-up) and toggled in the main loop
 - UART is started (115200, 8N1) and prints a message at every iteration in the main loop
 
