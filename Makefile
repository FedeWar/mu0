
all: app rom

app:
	make -C src

rom:
	python3 assembler assembler/test.asm
	mv out.hex src

%.hex: %.asm
	python3 assembler $<.asm
	mv out.hex src

test:
	make -C src runtest
	make -C src plottest

run:
	make -C src run
	make -C src plot

clean:
	make -C src clean

