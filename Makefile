AFLAGS  =
LFLAGS  = -C apple1cartridge.cfg
BINFILE = applesoft-lite.bin
OBJS    = applesoft-lite.o io.o apple1serial.o

$(BINFILE): $(OBJS)
	ld65 $(LFLAGS) $(OBJS) -o $(BINFILE)

applesoft-lite.o: applesoft-lite.s
	ca65 $(AFLAGS) $<

wozmon.o: wozmon.s
	ca65 $(AFLAGS) $<

apple1serial.o: apple1serial.s
	ca65 $(AFLAGS) $<

io.o: io.s
	ca65 $(AFLAGS) $<

clean:
	rm $(OBJS) $(BINFILE)
