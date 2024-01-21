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
	./Assembler/asm program.ulm
	mv program.po ./build
	mv program.do ./build

run-cpu: build-cpu build-prog
	./build/cpulm -p ./build/program.po -d ./build/program.do
