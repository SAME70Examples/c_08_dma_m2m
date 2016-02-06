SOURCE_DIRS:= device/source ../source ../retarget/source ../mdk/RTE/CMSIS
INCLUDE_DIRS:= device/include cmsis/include ../include ../retarget/include ./CMSIS_RTX/include  ../mdk/RTE
LINKER_DIRS:=

OUTPUT_EXEC:= salida.elf

C_SOURCE_FILES:= system_same70.c RTX_Conf_CM.c board.c watchdogs.c safe_stdlib.c
C_SOURCE_FILES += main.c os_serial_stdio.c dma_same70.c os_usart_same70.c delay.c usart_same70.c serial_stdio.c

CXX_SOURCE_FILES:=
ASM_SOURCE_FILES:= startup_ARMCM7.S
LINKER_FILES:= $(RTX_PATH)/4.3.0/libRTX_CM4.a

LD_SCRIPTS:= gcc_arm.ld

TARGET_CHIP:= __SAME70Q21__
ARCH_FLAGS:= -mthumb -mcpu=cortex-m7 -mfloat-abi=hard -mfpu=fpv5-d16
COMMON_FLAGS:= -Wall -g -ffunction-sections -fdata-sections -fno-exceptions
USER_CPP_FLAGS:=
USER_DEFINES:=
USER_ASM_FLAGS:= -std=c99
USER_C_FLAGS:= -std=c99
USER_CXX_FLAGS:= -std=c++11 -flto -O1
USER_LINKER_FLAGS:= -Wl,--gc-sections -specs=nano.specs --specs=nosys.specs -flto -O1

CPP_DEFINES:= $(TARGET_CHIP) $(USER_DEFINES)
CPP_DEFINE_FLAGS:=$(patsubst %,-D%,$(CPP_DEFINES))
INCLUDE_FLAGS:= $(patsubst %,-I%,$(INCLUDE_DIRS))
CPP_FLAGS:= $(CPP_DEFINE_FLAGS) $(INCLUDE_FLAGS) $(USER_CPP_FLAGS)

#LINKER OPTIONS
#The linker script for the microcontroller
LD_SCRIPTS:= gcc_arm.ld
#the directories for linker files
LIB_DIRS:= device/
#the libraries to link
LIB_NAMES:=
#linker flags
LFLAGS:= $(patsubst %,-L%,$(LIB_DIRS)) $(patsubst %,-l%,$(LIB_NAMES)) -T$(LD_SCRIPTS)

ASM_FLAGS:= $(ARCH_FLAGS) $(COMMON_FLAGS) $(USER_ASM_FLAGS)
C_FLAGS:= $(ARCH_FLAGS) $(COMMON_FLAGS) $(USER_C_FLAGS)
CXX_FLAGS:= $(ARCH_FLAGS) $(COMMON_FLAGS) $(USER_CXX_FLAGS)
LINKER_FLAGS:= $(ARCH_FLAGS) $(COMMON_FLAGS) $(USER_LINKER_FLAGS) $(patsubst %,-L%,$(LIB_DIRS)) $(patsubst %,-l%,$(LIB_NAMES)) -T$(LD_SCRIPTS)

DEPDIR := .d
DEPFLAGS = -MT $@ -MMD -MP -MF $(DEPDIR)/$*.Td
POSTCOMPILE = mv -f $(DEPDIR)/$*.Td $(DEPDIR)/$*.d

OBJECTS_DIR:= objects
BIN_DIR:= bin

DIRS_TO_CREATE:= $(OBJECTS_DIR) $(BIN_DIR) $(DEPDIR)

C_OBJECTS:= $(patsubst %,$(OBJECTS_DIR)/%.o,$(basename $(C_SOURCE_FILES)))
CXX_OBJECTS:= $(patsubst %,$(OBJECTS_DIR)/%.o,$(basename $(CXX_SOURCE_FILES)))
ASM_OBJECTS:= $(patsubst %,$(OBJECTS_DIR)/%.o,$(basename $(ASM_SOURCE_FILES)))

OBJECTS:= $(C_OBJECTS) $(CXX_OBJECTS) $(ASM_OBJECTS)

CC=arm-none-eabi-gcc
CXX=arm-none-eabi-g++
AS=arm-none-eabi-gcc
LN=arm-none-eabi-gcc

vpath %.c $(SOURCE_DIRS)
vpath %.cc $(SOURCE_DIRS)
vpath %.S $(SOURCE_DIRS)
vpath %.a $(LINKER_DIRS)

.PHONY: disp clean debug burn

all: $(BIN_DIR)/$(OUTPUT_EXEC)
$(BIN_DIR)/$(OUTPUT_EXEC): $(OBJECTS) $(LINKER_FILES) | $(BIN_DIR)
	$(LN) $^ $(LINKER_FLAGS) -o $@
	arm-none-eabi-size $@
$(DIRS_TO_CREATE): %:
	mkdir $@
$(C_OBJECTS): $(OBJECTS_DIR)/%.o : %.c $(DEPDIR)/%.d | $(OBJECTS_DIR) $(DEPDIR)
	$(CC) -c $< $(C_FLAGS) $(CPP_FLAGS) $(DEPFLAGS) -o $@
	$(POSTCOMPILE)
$(ASM_OBJECTS): $(OBJECTS_DIR)/%.o : %.S | $(OBJECTS_DIR)
	$(AS) -c $< $(ASM_FLAGS) $(CPP_FLAGS) -o $@
$(CXX_OBJECTS): $(OBJECTS_DIR)/%.o : %.cc $(DEPDIR)/%.d | $(OBJECTS_DIR) $(DEPDIR)
	$(CXX) -c $< $(CXX_FLAGS) $(CPP_FLAGS) $(DEPDIR) -o $@
	$(POSTCOMPILE)
clean:
	rm -rf $(DIRS_TO_CREATE)
dist_clean: clean

$(DEPDIR)/%.d: ;
.PRECIOUS: $(DEPDIR)/%.d

-include $(patsubst %, $(DEPDIR)/%.d,$(basename $(C_SOURCE_FILES)))
-include $(patsubst %, $(DEPDIR)/%.d,$(basename $(CXX_SOURCE_FILES)))

burn: $(BIN_DIR)/$(OUTPUT_EXEC)
	openocd -f board/atmel_same70_xplained.cfg -c"init" -c"sleep 300"  -c"program erase $<" -c"sleep 300" -c"reset" -c"shutdown"
debug: $(BIN_DIR)/$(OUTPUT_EXEC)
	openocd -f board/atmel_same70_xplained.cfg >/dev/null &
	sleep 1 ;
	! echo "reset" | telnet localhost 4444 ;
	! echo "reset halt" | telnet localhost 4444 ;
	sleep 1 ;
	arm-none-eabi-gdb --tui --eval-command="target remote localhost:3333" $<;
	! echo "reset" | telnet localhost 4444 ;
	sleep 1 ;
	! echo "shutdown" | telnet localhost 4444 ;
