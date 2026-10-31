DEVICE     ?= atmega328p
CLOCK      ?= 16000000
PORT       ?= COM3
BAUD       ?= 115200
PROGRAMMER ?= -c arduino -b $(BAUD) -P $(PORT)

AVR_CC      ?= avr-gcc
AVR_OBJCOPY ?= avr-objcopy
AVR_SIZE    ?= avr-size
AVR_OBJDUMP ?= avr-objdump
AVRDUDE     ?= avrdude

AVR_DIR    := firmware/avr
FATFS_DIR  := vendor/fatfs
BUILD_DIR  := build/avr
TARGET     := $(BUILD_DIR)/scanner
CONFIG     := $(AVR_DIR)/include/ffconf.h
OBJECTS    := $(BUILD_DIR)/main.o $(BUILD_DIR)/diskio.o $(BUILD_DIR)/ff.o

CPPFLAGS += -DF_CPU=$(CLOCK)UL -I$(AVR_DIR)/include -I$(FATFS_DIR)
CFLAGS   += -std=gnu99 -Wall -Wextra -Os -mmcu=$(DEVICE) -ffunction-sections -fdata-sections
LDFLAGS  += -mmcu=$(DEVICE) -Wl,--gc-sections -Wl,-Map,$(TARGET).map -Wl,-u,vfprintf
LDLIBS   += -lprintf_flt -lm

.PHONY: all flash clean size disasm cpp help
.DEFAULT_GOAL := all

all: $(TARGET).hex

$(BUILD_DIR):
	mkdir -p "$@"

$(CONFIG):
	@echo "Missing $(CONFIG). Supply a matching FatFs configuration (FFCONF_DEF=80286)."
	@echo "The SD adapter also needs implementation. See docs/firmware.md."
	@exit 1

$(BUILD_DIR)/%.o: $(AVR_DIR)/src/%.c $(CONFIG) | $(BUILD_DIR)
	$(AVR_CC) $(CPPFLAGS) $(CFLAGS) -MMD -MP -c $< -o $@

$(BUILD_DIR)/ff.o: $(FATFS_DIR)/ff.c $(CONFIG) | $(BUILD_DIR)
	$(AVR_CC) $(CPPFLAGS) $(CFLAGS) -MMD -MP -c $< -o $@

$(TARGET).elf: $(OBJECTS)
	$(AVR_CC) $(LDFLAGS) $^ $(LDLIBS) -o $@

$(TARGET).hex: $(TARGET).elf
	$(AVR_OBJCOPY) -j .text -j .data -O ihex $< $@
	$(AVR_SIZE) --format=avr --mcu=$(DEVICE) $<

flash: all
	$(AVRDUDE) $(PROGRAMMER) -p $(DEVICE) -U flash:w:$(TARGET).hex:i

size: $(TARGET).elf
	$(AVR_SIZE) --format=avr --mcu=$(DEVICE) $<

disasm: $(TARGET).elf
	$(AVR_OBJDUMP) -d $<

cpp: $(CONFIG)
	$(AVR_CC) $(CPPFLAGS) $(CFLAGS) -E $(AVR_DIR)/src/main.c

clean:
	rm -f $(OBJECTS) $(OBJECTS:.o=.d) $(TARGET).elf $(TARGET).hex $(TARGET).map

help:
	@echo "make             Build AVR firmware after completing the SD port"
	@echo "make flash       Upload AVR firmware; override PORT for your board"
	@echo "make size        Show AVR memory usage"
	@echo "make disasm      Print AVR disassembly"
	@echo "make clean       Remove generated AVR files"
	@echo "Arduino sketch:  firmware/arduino/3d_scanner/3d_scanner.ino"

-include $(OBJECTS:.o=.d)
