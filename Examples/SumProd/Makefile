all: assembler vm build-asm

assembler:
	make -C ../../ assembler

vm:
	make -C ../../ vm

build-asm: assembler
	../../Assembler/asm sum_prod.ulm

print-encoded: assembler
	clear && ../../Assembler/asm sum_prod.ulm --print-encoded

run-vm: build-asm vm
	clear && ../../VirtualMachine/build/src/cpulm_vm sum_prod.po sum_prod.do

clean:
	-rm -f sum_prod.po
	-rm -f sum_prod.do

.PHONY: assembler vm build-asm print-encoded run-vm clean all