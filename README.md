# applesoft-lite-sdcard

This is a stripped-down version of Applesoft BASIC (Microsoft 6502 BASIC) for the Apple-1,
forked from [applesoft-lite](https://github.com/txgx42/applesoft-lite). 

It has been modified to perform `LOAD` and `SAVE` operations via the SD Card interface by P-LAB.

Changes:
- commands `LOAD`, `SAVE`, `MENU` for SD card operations
- zero page memory locations below `$4A` have been relocated to avoid conflicts with the SD Card firmware
- `GOWARM` and `GOSTROUT` zero page entry points have been removed (saving 6 bytes)
- added cold boot message to differentiate it from warm boot
- keyboard routine updates locations `$4e` and `$4f` to be used as random number or random seed for the `RND()` function (e.g. `LET R=RND(-PEEK(78)-PEEK(79)*256)`)

## Other forks

### applesoft-lite

This is a stripped-down version of Applesoft BASIC (Microsoft 6502 BASIC) for the Apple-1.

See https://cowgod.org/replica1/applesoft/

### apple1serial

This fork has been modified to perform LOAD and SAVE operations via Apple-1 Serial interface.

See https://github.com/flowenol/apple1serial

### apple1cartridge

This fork has been modified to allow loading programs from Apple-1 RAM/ROM Cartridge via the `STARTFROMCART` routine.

See https://github.com/flowenol/apple1cartridge
