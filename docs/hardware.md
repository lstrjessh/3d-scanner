# Hardware

The scanner uses a Sharp GP2Y0A41SK0F infrared distance sensor, a turntable stepper, a Z-axis stepper and lead screw, a limit switch, a scan button, and SD storage.

[Overview drawing](images/drawing-overview.png) · [Internal drawing](images/drawing-internal.png) · [System design](images/system-design.png)

## Pin assignments in the source

The table records the current code, not a verified wiring diagram. Digital pin numbers refer to the ATmega328P Arduino Uno mapping.

| Signal | Arduino sketch | Bare-metal AVR |
| --- | --- | --- |
| Distance sensor | A0 | ADC0 / PC0 |
| Scan button | D2 | PD2 / INT0 |
| Limit switch | D10 | PB2 / D10 |
| Turntable direction | D7 | PD7 / D7 |
| Turntable step | D8 | PB0 / D8 |
| Turntable enable | D9 | PB1 / D9 |
| Z-axis direction | D3 | PD3 / D3 |
| Z-axis step | D5 | PD5 / D5 |
| Z-axis enable | D6 | PD6 / D6 |
| SD chip select | D4 | PB4 / D12 in the macro; its original comment says D4 |
| SPI MOSI | D11 | PB3 / D11 |
| SPI MISO | D12 | PB4 / D12 |
| SPI clock | D13 | PB5 / D13 |
| Status LED | Board LED | PB5 / D13 |

In the AVR source, SD chip select overlaps MISO, the limit switch shares PB2 with the SPI SS configuration, and the status LED shares SCK. These assignments need a hardware-specific resolution; the reorganization preserves the original definitions.

## Scanner settings

Both versions expose scan averaging, layer height, motor steps per turn, distance to the turntable center, and object-detection thresholds near the top of the source. Review these against the mechanical setup and measured sensor response.

The original ADC code selects the internal reference but calculates voltage using 3.3 V. Verify the reference, sensor calibration, and units before relying on the saved coordinates.
