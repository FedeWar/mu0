# MU0

VHDL implementation of the mu0 microprocessor, for educational purposes.

## Dependencies

To compile and execute the source code the following softwares are needed: `GHDL`, other simulators might work but were not tested; `GNU Make` for the makefile; `GTKWave` to plot signals; `python3` to execute the assembler, `python2` might work but was not tested.

All the dependencies are free and downloadable from your favourite package manager.

`$ dnf install make ghdl gtkwave python3`

The project was tested only on Linux Fedora.

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

- Execute the automatic tests with `make test`

  Automatic tests are performed inside the simulator to check the correctness of the implementation, error messages will be raised in case of a failed test. At this point in time not all tests that should be done are implemented.

- Execute the simulation with `make run`

  Runs the simulation of the microprocessor, the executable code is read from `out.hex`. The code has to end with a `STP` instruction, otherwise it will run forever and no useful output will be produced. In the end the memory and all the registers are dumped inside `dump.hex` (not yet implemented).

## Known bugs

Here goes the list of all the known bugs and flaws of the simulation and the assembler.

#### Microprocessor

- ~~The `SUB` instruction is not implemented;~~
- The `JGE` and `JNE` instructions are not implemented;
- In some unspecified cases the data bus is undefined;
- The memory dump is not implemented.

#### Assembler

- The `STP` instruction has to be followed by a number, it should not.

## How to contribute

You can't right now.
