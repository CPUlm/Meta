all: assembler vm cpulm csimulator build-cpu

update:
	@git submodule update --init --recursive --remote
	mkdir -p build/


# Build tools
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


# Build the CPU
build-netlist: csimulator cpulm
	./CSimulator/csimulator ./CPUlm/cpulm.net ./build/

build-cpu: build-netlist
	cd build/ && clang *.c -o cpulm


# Synchronized mode
preprocess-prog-sync:
	gcc -x c -P -E -nostdinc program.ulm -o program_tmp.ulm

build-prog-sync: assembler preprocess-prog-sync
	./Assembler/asm program_tmp.ulm
	mv program_tmp.po ./build/program.po
	mv program_tmp.do ./build/program.do
	rm program_tmp.ulm

run-cpu-sync: build-cpu build-prog-sync
	./build/cpulm -p ./build/program.po -d ./build/program.do

run-vm-sync: build-prog-sync vm
	./VirtualMachine/build/src/cpulm_vm ./build/program.po ./build/program.do

# Fast mode compilation
preprocess-prog-fast:
	gcc -x c -D FAST_FORWARD -P -E -nostdinc program.ulm -o program_tmp.ulm

build-prog-fast: assembler preprocess-prog-fast
	./Assembler/asm program_tmp.ulm
	mv program_tmp.po ./build/program.po
	mv program_tmp.do ./build/program.do
	rm program_tmp.ulm

run-cpu-fast: build-cpu build-prog-fast
	./build/cpulm -p ./build/program.po -d ./build/program.do

run-vm-fast: build-prog-fast vm
	./VirtualMachine/build/src/cpulm_vm ./build/program.po ./build/program.do

# PGO Build
build-cpu-prof: build-netlist
	cd build/ && clang *.c -O2 -fprofile-instr-generate -o cpulm

build-cpu-pgo: build-netlist build/cpulm.profdata
	cd build/ && clang *.c -O2 -fprofile-use=cpulm.profdata -o cpulm

run-cpu-prof: build-cpu-prof build-prog
	LLVM_PROFILE_FILE="build/cpulm-%p.profraw" ./build/cpulm -p ./build/program.po -d ./build/program.do

build/cpulm.profdata:
	llvm-profdata-14 merge -output=build/cpulm.profdata $(wildcard build/cpulm-*.profraw)

# Clean
clean:
	make -C Examples/SumProd/ clean
	make -C Examples/4BitAdder/ clean