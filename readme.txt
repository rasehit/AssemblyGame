Compile options:
	nasm -f elf64 <filemane>.asm
Linking options:
	ld -m elf_x86_64 <filename>.o -o <output>
Startup options:
	./<output> <mapname>.txt

<mapname> - file which contains map for the game
In this version filed1.txt in the only one
