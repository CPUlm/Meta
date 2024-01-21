update:
	@git submodule update --init --recursive --remote
	mkdir -p build/

assembler:
	make -C ./Assembler

cpulm:
	make -C ./CPUlm

csimulator:
	make -C ./CSimulator

vm:
	mkdir -p ./VirtualMachine/build
	cmake -S ./VirtualMachine/ ./VirtualMachine/build
	cmake --build ./VirtualMachine/build

build-cpu: csimulator cpulm
	./CSimulator/csimulator ./CPUlm/cpulm.net ./build/
	cd build/ && clang *.c -o cpulm

build-prog: assembler
	gcc -E -C program.ulm -o program_tmp.ulm
	./Assembler/asm program_tmp.ulm
	mv program_tmp.po ./build/program.po
	mv program_tmp.do ./build/program.do
	rm program_tmp.ulm

run-cpu: build-cpu build-prog
	./build/cpulm -p ./build/program.po -d ./build/program.do

run-vm:	build-prog vm
	./VirtualMachine/build/src/cpulm_vm ./build/program.po ./build/program.do
