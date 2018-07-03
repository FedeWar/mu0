# MU0

VHDL implementation of the mu0 microprocessor, for educational purposes.

## How to use the makefile

It is possible to invoke a few commands from the makefile to automatically compile and run the simulation.

- Compile everything with `make` or `make all`

  This command compiles the microprocessor simulator, the automatic tests and the ROM memory.

- Compile only the simulators with `make app`

  The simulators `mu0` and `dp_test` will be built inside src.

- Compile only the ROM with `make rom`

  The simulator needs to fetch the instructions to execute from a memory, to avoid the need to recompile everything whenever the code is changed the user code is kept in a file named `out.hex`, placed inside `src`. Invoking `make rom` reassembles `test.asm` to `out.hex`.

- Compile custom ROM with `make <filename>.hex`

  If the user wants to try to run its own code in the simulation it will have to compile its `asm` file in an `hex`. The result of the compilation will be automatically placed inside `src` for execution.

- `make test`

- `make run`

