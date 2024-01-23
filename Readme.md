# Meta Repository of the CPUlm Project

After cloning this repository, please do `make update`.

- To run the program `program.ulm` on the _CPUlm_ in real time: use `make run-cpu-sync`.
- To run the program `program.ulm` on the _CPUlm_ in fast-forward mode: use `make run-cpu-fast`.
- To run the program `program.ulm` on the _VirtualMachine_ in real time: use `make run-vm-sync`.
- To run the program `program.ulm` on the _VirtualMachine_ in fast-forward mode: use `make run-vm-fast`.

To use the _VirtualMachine_ please refer to the _VirtualMachine_ ReadMe.

All tools are automatically built if needed.
All generated files are in `build/`. Happy Hacking !

## Build with PGO (Profile Guided Optimisation)

First, we need to compile the _CPUlm_ simulator with instrumentation:
```bash
make build-cpu-prof
```
And run it on a sample program. By default, you can just type:
```bash
make run-cpu-prof
```
Which build the _CPUlm_ simulator with instrumentation and run it on `program.ulm`.

Now, we need to rebuild the _CPUlm_ simulator with the gathered data:
```bash
make build-cpu-pgo
```

The generated `cpulm` program is now compiled with PGO!
