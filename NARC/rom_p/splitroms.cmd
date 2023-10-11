@echo off
rem in here we handle splitting roms.
rem ROM_REGION16_LE( 0x100000, "user1", 0 ) /* 34010 code */
rem ROM_LOAD16_BYTE( "rev7_narc_game_rom_u42.u42", 0x80000, 0x20000, CRC(d1111b76) SHA1(9700261aaba6a1ac0415362874817499f90b142a) )
rem ROM_LOAD16_BYTE( "rev7_narc_game_rom_u24.u24", 0x80001, 0x20000, CRC(aa0d3082) SHA1(7da59098319c49842406e7daf06aceae80fbd0ed) )
rem ROM_LOAD16_BYTE( "rev7_narc_game_rom_u41.u41", 0xc0000, 0x20000, CRC(3903191f) SHA1(1ad89cb03956f6625d9403e98951383fc9219478) )
rem ROM_LOAD16_BYTE( "rev7_narc_game_rom_u23.u23", 0xc0001, 0x20000, CRC(7a316582) SHA1(f640966c79bab70b536f2f92d4f46475a021b5b1) )
rem use mame debug to save a bin: "saver narcromp.bin,80000,100000,:user1"
rem production rev7 bin: narcromp.bin
dd if=narcromp.bin of=1.bin bs=262144 count=1
dd if=narcromp.bin of=2.bin bs=262144 count=1 skip=1
c:\bin\far\srec_cat 1.bin -binary -split 2 0 -o rev7_narc_game_rom_u42.u42 -binary
c:\bin\far\srec_cat 1.bin -binary -split 2 1 -o rev7_narc_game_rom_u24.u24 -binary
c:\bin\far\srec_cat 2.bin -binary -split 2 0 -o rev7_narc_game_rom_u41.u41 -binary
c:\bin\far\srec_cat 2.bin -binary -split 2 1 -o rev7_narc_game_rom_u23.u23 -binary
del 1.bin
del 2.bin
