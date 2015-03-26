

CC=arm-none-eabi-gcc
CXX=arm-none-eabi-g++
LD=arm-none-eabi-ld
AR=arm-none-eabi-ar
AS=arm-none-eabi-as
CP=arm-none-eabi-objcopy
OD=arm-none-eabi-objdump
NM=arm-none-eabi-nm
SIZE=arm-none-eabi-size
A2L=arm-none-eabi-addr2line

BINDIR=bin
BINELF=outp.elf
BIN=outp.bin

INCLUDES= \
   -Iinclude \
   -Ilib/BSP/STM32F4xx-Nucleo \
   -Ilib/STM32F4xx_HAL_Driver/Inc \
   -Ilib/CMSIS/Include \
   -Ilib/CMSIS/Device/ST/STM32F4xx/Include \

ASOURCES= \
	src/startup_stm32f411xe.s

CSOURCES= \
	src/syscalls.c \
	src/stm32f4xx_it.c \
	src/system_stm32f4xx.c \
	src/stm32f4xx_hal_msp.c \
	lib/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal.c \
	lib/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_rcc.c \
	lib/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_gpio.c \
	lib/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_uart.c \
	lib/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_dma.c \
	lib/STM32F4xx_HAL_Driver/Src/stm32f4xx_hal_cortex.c

CXXSOURCES=	\
	src/main.cpp \
	src/foo.cpp

INCLUDES_LIBS=
LINK_LIBS=

OBJECTS=$(ASOURCES:%.s=%.o)
OBJECTS+=$(CSOURCES:%.c=%.o)
OBJECTS+=$(CXXSOURCES:%.cpp=%.o)

CFLAGS=-c -Wall -mcpu=cortex-m4 -mlittle-endian -mthumb -DSTM32F411xE \
    -Os -flto -ffunction-sections -fdata-sections -fno-builtin -fno-exceptions $(INCLUDES) 

CXXFLAGS=-c -Wall -mcpu=cortex-m4 -mlittle-endian -mthumb -DSTM32F411xE \
    -Os -flto -ffunction-sections -fdata-sections -fno-builtin -fno-rtti -fno-exceptions $(INCLUDES) -std=c++11

LDFLAGS=-mcpu=cortex-m4 -mlittle-endian -mthumb -DSTM32F411xE -TSTM32F411RE_FLASH.ld \
    -Wl,--gc-sections --specs=nano.specs --specs=nosys.specs -Wl,--start-group -lgcc -lc -Wl,--end-group

all: $(SOURCES) $(BINDIR)/$(BIN)
    
flash: $(BINDIR)/$(BIN)
	st-flash --reset write $(BINDIR)/$(BIN) 0x8000000 
   
$(BINDIR)/$(BIN): $(BINDIR)/$(BINELF)
	$(CP) -O binary $< $@
    
$(BINDIR)/$(BINELF): $(OBJECTS)
	$(CXX) $(OBJECTS) $(LDFLAGS) -o $@
	@echo "Linking complete!\n"
	$(SIZE) $(BINDIR)/$(BINELF)

%.o: %.cpp
	$(CXX) $(CXXFLAGS) $< -o $@
	@echo "Compiled "$<"!\n"

%.o: %.c
	$(CC) $(CFLAGS) $< -o $@
	@echo "Compiled "$<"!\n"

%.o: %.s
	$(CC) $(CFLAGS) $< -o $@
	@echo "Assembled "$<"!\n"

clean:
	rm -f $(OBJECTS) $(BINDIR)/$(BINELF) $(BINDIR)/$(BIN) $(BINDIR)/output.map
