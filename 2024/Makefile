CFLAGS = -f elf64 -g

day01: lib.o day01.asm
	nasm $(CFLAGS) -o day01.o day01.asm
	ld -o day01 day01.o lib.o

lib.o: lib.asm
	nasm $(CFLAGS) -o lib.o lib.asm

test: lib.o test.asm
	nasm $(CFLAGS) -o test.o test.asm
	ld -o test test.o lib.o

clean:
	rm -rf *.o day01 test

.PHONY: clean
