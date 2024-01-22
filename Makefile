all: assembler vm cpulm csimulator build-cpu build-prog

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
	cmake -S ./VirtualMachine/ -B ./VirtualMachine/build
	cmake --build ./VirtualMachine/build

build-netlist: csimulator cpulm
	./CSimulator/csimulator ./CPUlm/cpulm.net ./build/

build-cpu: build-netlist
	cd build/ && clang *.c -o cpulm

build-cpu-step: csimulator cpulm
	./CSimulator/csimulator ./CPUlm/cpulm.net ./build/ --debug --pause
	cd build/ && clang *.c -o cpulm

preprocess-prog:
	gcc -x c -P -E -nostdinc program.ulm -o program_tmp.ulm

build-prog: assembler preprocess-prog
	./Assembler/asm program_tmp.ulm
	mv program_tmp.po ./build/program.po
	mv program_tmp.do ./build/program.do
	rm program_tmp.ulm

run-cpu: build-cpu build-prog
	./build/cpulm -p ./build/program.po -d ./build/program.do

run-cpu-step: build-cpu-step build-prog
	./build/cpulm -p ./build/program.po -d ./build/program.do

run-vm:	build-prog vm
	./VirtualMachine/build/src/cpulm_vm ./build/program.po ./build/program.do

build-cpu-prof: build-netlist
	cd build/ && clang *.c -O2 -fprofile-instr-generate -o cpulm

build-cpu-pgo: build-netlist build/cpulm.profdata
	cd build/ && clang *.c -O2 -fprofile-use=cpulm.profdata -o cpulm

run-cpu-prof: build-cpu-prof build-prog
	LLVM_PROFILE_FILE="build/cpulm-%p.profraw" ./build/cpulm -p ./build/program.po -d ./build/program.do

build/cpulm.profdata:
	llvm-profdata-14 merge -output=build/cpulm.profdata $(wildcard build/cpulm-*.profraw)
