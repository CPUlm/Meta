all: assembler vm build-asm

assembler:
	make -C ../../ assembler

vm:
	make -C ../../ vm

build-asm: assembler
	../../Assembler/asm screen_bird.ulm

print-encoded: assembler
	clear && ../../Assembler/asm screen_bird.ulm --print-encoded

run-vm: build-asm vm
	clear && ../../VirtualMachine/build/src/cpulm_vm screen_bird.po screen_bird.do

clean:
	-rm -f screen_bird.po
	-rm -f screen_bird.do

.PHONY: assembler vm build-asm print-encoded run-vm clean all