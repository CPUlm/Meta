# Meta Repository of the CPUlm Project

After cloning it, please do `make update`.

- To run the program `program.ulm` on the CPUlm: use `make run-cpu`.
- To run the program `program.ulm` on the Virtual Machine: use `make run-vm`.

All tools are automatically built if needed.
All generated files are in `build/`. Happy Hacking !

## Build with PGO (Profile Guided Optimisation)

First, we need to compile the CPUlm simulator with instrumentation:
```bash
make build-cpu-prof
```
And run it on a sample program. By default, you can just type:
```bash
make run-cpu-prof
```
Which build the CPUlm simulator with instrumentation and run it on `program.ulm`.

Now, we need to rebuild the CPUlm simulator with the gathered data:
```bash
make build-cpu-pgo
```

The generated `cpulm` program is now compiled with PGO!
