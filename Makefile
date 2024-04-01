CFLAGS = -m32 -fno-stack-protector -fno-builtin

all: clean kernel boot image

clean:
	rm -rf *.o

kernel:
	gcc $(CFLAGS) -c kernel.c -o kernel.o
	gcc $(CFLAGS) -c vga.c -o vga.o
	gcc $(CFLAGS) -c gdt.c -o gdt.o
	gcc $(CFLAGS) -c util.c -o util.o
	gcc $(CFLAGS) -c interrupts/idt.c -o idt.o

boot:
	nasm -f elf32 boot.s -o boot.o
	nasm -f elf32 gdt.s -o gdts.o
	nasm -f elf32 interrupts/idt.s -o idts.o

image:
	ld -m elf_i386 -T linker.ld -o kernel boot.o kernel.o vga.o gdt.o gdts.o util.o idt.o idts.o

	mv kernel majesticOS/boot/kernel
	grub-mkrescue -o kernel.iso majesticOS/

rm *.o
