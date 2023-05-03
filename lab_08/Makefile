CC=g++

.PHONY: ft st clean disassembly_example

ft:
	$(CC) operations.cpp -mno-80387 -o operations.exe
	./operations.exe

	$(CC) operations.cpp -m80387 -o operations.exe
	./operations.exe

	$(CC) operations.cpp -DASM -masm=intel -O0 -o operations.exe
	./operations.exe

st:
	$(CC) sin.cpp -masm=intel -o sin.exe
	./sin.exe

disassembly_example:
	objdump.exe -M intel-mnemonic -s .\operations.o >> test.txt

clean:
	- srm *.exe