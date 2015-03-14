

# Compiler collection
CC=arm-none-eabi-gcc
OBJCOPY=arm-none-eabi-gcc

# Compiler and linker flags
CFLAGS=-c -Wall -mcpu=cortex-m4 -mlittle-endian -mthumb -DSTM32F411xE -Os
LDFLAGS=-mcpu=cortex-m4 -mlittle-endian -mthumb -DSTM32F411xE -TSTM32F411RE_FLASH.ld -Wl,--gc-sections

# Sources
SOURCES=src/main.c src/stm32f4xx_it.c src/system_stm32f4xx.c src/stm32f4xx_hal_msp.c lib/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal.c lib/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_rcc.c lib/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_gpio.c lib/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_uart.c lib/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_dma.c lib/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_cortex.c 

# Includes
INC=-Iinclude -Ilib/CMSIS/Device/ST/STM32F4xx/Include -Ilib/CMSIS/Include -Ilib/STM32F4xx_HAL_Driver/Inc -Ilib/BSP/STM32F4xx-Nucleo

OBJECTS=$(SOURCES:.c=.o)
OBJECTS+=src/startup_stm32f411xe.o

# Name of executable
EXECUTABLE=stm32f411_nucleo_cube_gcc

all: $(SOURCES) $(EXECUTABLE).bin
    
flash: $(EXECUTABLE).bin
	st-flash --reset write $(EXECUTABLE).bin 0x8000000 
   
$(EXECUTABLE).bin: $(EXECUTABLE).elf
	arm-none-eabi-objcopy -O binary $(EXECUTABLE).elf $(EXECUTABLE).bin
    
$(EXECUTABLE).elf: $(OBJECTS) 
	$(CC) $(LDFLAGS) $(OBJECTS) -o $@  -lgcc -lc -lm -lrdimon

.c.o:
	$(CC) $(CFLAGS) $(INC) $< -o $@

.s.o:
	$(CC) $(CFLAGS) $(INC) $< -o $@
	
clean:
	rm $(OBJECTS) $(EXECUTABLE).bin $(EXECUTABLE).elf
	
