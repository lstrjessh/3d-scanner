# 3D Scanner

An infrared point cloud scanner using a Sharp GP2Y0A41SK0F distance sensor, stepper motors, and an ATmega328P. Captured coordinates are saved to an SD card for visualization and shape classification.

![Scanner prototype](prototype.png)

## Implementations

- **Bare-metal C:** `scanner_c_code.c` controls AVR registers for GPIO, timers, ADC, UART, and SPI, with FatFs for SD storage.
- **Arduino:** `3d_scanner.ino` provides a sketch using the Arduino SPI and SD libraries.

## Run

For the Arduino version, open `3d_scanner.ino` in Arduino IDE, select your board and port, and verify pin assignments against your wiring before uploading.

For the AVR version, install AVR-GCC, Make, and AVRDUDE. The Makefile targets an ATmega328P at 16 MHz; configure its programmer and port for your board.

```bash
make
make flash
```

The repository currently lacks `ffconf.h`, which `ff.h` requires. Supply a compatible FatFs configuration and review the SD driver before building the AVR version. Hardware operation has not been reverified for this documentation update.

## Resources

- [System design](system_design.png)
- [Program flow](program_flow.png)
- [PointNet shape classifier](https://github.com/lstrjessh/shape-classifier)
