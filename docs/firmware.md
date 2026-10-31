# Firmware

## Arduino

Open [3d_scanner.ino](../firmware/arduino/3d_scanner/3d_scanner.ino) in Arduino IDE. The folder name matches the sketch name. The sketch uses `SPI`, `SD`, and the math library; install the Arduino SD library if it is not available in your IDE.

Select the board and serial port for your hardware, review the [pin assignments](hardware.md), then compile and upload. Serial output runs at 9600 baud. Files use the `SCANxxx.TXT` naming pattern and contain X, Y, Z coordinates after three header lines.

## Bare-metal AVR

- [main.c](../firmware/avr/src/main.c): scanner control, register-level GPIO, timers, ADC, UART, and SPI.
- [diskio.c](../firmware/avr/src/diskio.c): FatFs disk interface skeleton.
- [FatFs](../vendor/fatfs): bundled filesystem implementation and disk interface header.

The root Makefile targets an ATmega328P at 16 MHz. It requires GNU Make, AVR-GCC, AVR binutils, and AVRDUDE. On Windows, run it in a POSIX shell such as MSYS2. Generated files stay in `build/avr/`.

```sh
make
make size
make flash PORT=COM5
make clean
```

`make` builds without uploading. `make flash` performs the upload. `PORT`, `BAUD`, `DEVICE`, `CLOCK`, and `PROGRAMMER` can be overridden for the board. Floating-point formatting and the math library are linked because the firmware uses float-based coordinates and formatted output.

### SD integration

The committed AVR port is incomplete:

1. Supply `firmware/avr/include/ffconf.h` for the bundled FatFs revision, using `FFCONF_DEF=80286`. The scanner requires read/write file operations. The original configuration was not included in the source.
2. Implement the SD block-device interface in `firmware/avr/src/diskio.c`. The existing file is ChaN's generic skeleton and references unimplemented `RAM_disk_*`, `MMC_disk_*`, and `USB_disk_*` functions. Adding the configuration header alone will not produce a working firmware image.
3. Reconcile the AVR [pin assignments](hardware.md) with the actual wiring before uploading. The current definitions overlap SPI signals.

The firmware sources are preserved from the original repository. Hardware operation has not been reverified during this reorganization.
