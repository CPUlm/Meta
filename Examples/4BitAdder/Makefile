all: csimulator

csimulator:
	make -C ../../ csimulator
	mkdir -p cprog/

show-blocks: csimulator
	../../CSimulator/csimulator --print-blocks 4bitadd.net > cprog/4bitadd.dot
	dot -Tpdf cprog/4bitadd.dot -o cprog/4bitadd.pdf
	xdg-open cprog/4bitadd.pdf

build: csimulator
	../../CSimulator/csimulator --disable-tick --disable-screen 4bitadd.net cprog

simulate: build
	cd cprog && clang -O2 *.c -o 4bitadd && cd ..
	clear && ./cprog/4bitadd

clean:
	rm -rf cprog/

.PHONY: clean all csimulator