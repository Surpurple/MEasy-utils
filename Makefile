# make all demoes at one time

#export PRU_CGT=$HOME/toolchain_linaro/ti-cgt-pru_2.1.3

PREFIX ?= $(shell pwd)/rootfs

#uncomment to install to exported NFS root directory
#PREFIX = $HOME/export/rootfs_c437x

#CROSS_COMPILE ?= arm-linux-gnueabihf-
CROSS_COMPILE := arm-myir-linux-gnueabihf-

ifeq ($(OPTION), MYD-C437X-EVM)
SUBDIRS=framebuffer keypad rtc eeprom led can tty gpio camera
endif

ifeq ($(OPTION), MYD-C437X-PRU)
SUBDIRS=framebuffer keypad rtc eeprom led can tty gpio pru_led
endif

ifeq ($(OPTION), MYD-C437X-EVM)
SUBDIRS=audio camera framebuffer keypad rtc eeprom led can tty gpio
endif

ifeq ($(OPTION), MYD-AM335X-SERIES)
SUBDIRS= audio framebuffer rtc tty can network mtd led
endif

ifeq ($(OPTION), MYD-AM335X-X)
SUBDIRS=audio framebuffer keypad rtc eeprom led can tty gpio
endif

ifeq ($(OPTION), MYD-AM335X-Y)
SUBDIRS=audio framebuffer keypad rtc eeprom led can tty gpio
endif

ifeq ($(OPTION), MYD-AM335X-J)
SUBDIRS=audio framebuffer keypad rtc eeprom led can tty gpio
endif

ifeq ($(OPTION), MYD-YA157C)
SUBDIRS=framebuffer keypad rtc eeprom led can rs232 rs485 gpio watchdog
endif

all: $(SUBDIRS)

$(SUBDIRS):
	@$(MAKE) -C $@

clean:
	@for d in $(SUBDIRS); do (cd $$d; $(MAKE) clean ); done
	
install:
	mkdir -p $(PREFIX)/lib/firmware
	mkdir -p $(PREFIX)/usr/bin
ifeq ($(OPTION), MYD-C437X-PRU)
	cp pru_led/PRU_RPMsg_Echo_Interrupt0_0/gen/PRU_RPMsg_Echo_Interrupt0_0.out  $(PREFIX)/lib/firmware/am437x-pru0_0-fw
	cp pru_led/PRU_RPMsg_LED0_1/gen/PRU_RPMsg_LED0_1.out  $(PREFIX)/lib/firmware/am437x-pru0_1-fw
endif
	@for d in $(SUBDIRS); do (cd $$d; cp $$d"_test" $(PREFIX)/usr/bin/ ); done


.PHONY: all clean $(SUBDIRS) install



