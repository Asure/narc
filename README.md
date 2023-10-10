- run fixer.py in SYS and NARC to update old GSP assembler format directives and constants to ones that work with 6.10
-- this will fix up the source files in the OLD folder and put them in the main folder
- run gmake -m in the SYS folder
- run gmake allnarc -m in the NARC folder
- run nothing in the DIAG folder, it appears precompiled(!)
- run NARCROMS.BAT, now you have NARCFC and NARCFE files. these are 27010 ROM images.
- for MAME, rename the ROMs as follows:  
	NARCFC.0 -> NARCREV7.U42, NARCFC.1 -> NARCREV7.U24,
	NARCFE.0 -> NARCREV7.U41, NARCFE.1 -> NARCREV7.U23

current problems:
- the DMA1 version of LOAD doesn't seem to be available anywhere, so I can't produce graphics ROMs until
  that's reverse-engineered or found
- fortunately the graphics and sound are pre-built...
- ...except for the mugshots, title screen, and FBI logo which are all linked into the program ROMs by LOAD.

Update:
- The production roms have this data inside them at FFF93000 -> FFFFDA00 so we can dump it.
- We learned from mk2 and others how they insert files into the program area if gfx rom is full.
- Then use load2.exe to turn this BIN file into irw with a custom .lod file
- Then update the LRN files to use this new IRW file.
- We don't touch narcmugs.lod this way, and we can't since the refs are now hardcoded.
- We don't need to unless we change so much that the game becomes larger.
