# FatFs

Bundled FatFs R0.15 with patch 3 by ChaN. `ff.c`, `ff.h`, and `diskio.h` are preserved from the original scanner repository, including their copyright notices and redistribution terms.

- `ff.c`: filesystem implementation.
- `ff.h`: public API, revision ID 80286.
- `diskio.h`: block-device interface declarations.

The project-specific configuration belongs in `firmware/avr/include/ffconf.h`. Its SD adapter is in `firmware/avr/src/diskio.c`.

Upstream documentation: http://elm-chan.org/fsw/ff/
