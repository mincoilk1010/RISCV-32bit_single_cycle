Markdown
# RISC-V 32-bit Single-Cycle CPU

A single-cycle 32-bit RISC-V processor implementation (RV32I architecture) written in Verilog. This project is designed at the Register-Transfer Level (RTL), integrates automated testing workflows, and is targeted for FPGA synthesis.

## Key Features
* Architecture: Supports the RV32I Base Integer Instruction Set.
* Design: Single-Cycle Datapath complete with all core functional blocks (ALU, Register File, Control Unit, Instruction/Data Memory, Immediate Generator).
* Verification: Successfully passes the standard `riscv-tests` suite from the RISC-V Foundation, covering ALU operations, branch/jump control flows, and unaligned memory load/store operations.
* Development Environment:
  * Simulation: Icarus Verilog & GTKWave.
  * Synthesis: Gowin EDA.
  * Target Hardware: Tang Nano 9K (GW1NR-9 FPGA).

## Directory Structure
```text
RISCV_32_Single_Cycle/
├── src/                 # Verilog source code for the CPU hardware
├── sim/                 # System testbench files (riscv_top_tb.v)
├── riscv-tests/         # Standard RISC-V Foundation test suite (Assembly/C)
├── run_test.sh          # Bash script for automated testbench execution
└── README.md
Simulation Guide
The project utilizes run_test.sh to fully automate the testing process: Compiling Assembly via GCC -> Extracting ROM/RAM via objcopy -> Running Icarus Verilog simulation.

Requirements:

Operating System: Linux (Ubuntu/Debian, etc.)

RISC-V GNU Compiler Toolchain (riscv64-unknown-elf-gcc)

Icarus Verilog (iverilog, vvp)

To run a specific test, open the terminal at the project root and pass the test file path to the script. For example, to test the andi instruction:

Bash
./run_test.sh riscv-tests/isa/rv32ui/andi.S
Note: Upon successful execution, the script will automatically report the result (PASS/FAIL) via the terminal and generate a riscv_top_wave_form.vcd file for waveform analysis in GTKWave.

Hardware Synthesis on FPGA
The project has been synthesized and evaluated using Gowin EDA for the Tang Nano 9K development board.

Due to the inherent nature of the Single-Cycle architecture, the entire instruction execution (Fetch -> Decode -> Execute -> Memory -> WriteBack) must complete within a single clock cycle. This results in a critical path that traverses approximately 19 logic levels.

The maximum operating frequency (Fmax) is constrained to approximately 21.8 MHz.

Hardware Implementation Note: If programming directly to the board, an rPLL IP Core must be configured to step down the default 27 MHz oscillator to 20 MHz to avoid Setup/Hold time timing violations.

Future Work
Upgrade the microarchitecture to a 5-stage Pipelined CPU to resolve the single-cycle Fmax bottleneck.

Integrate a Forwarding Unit and a Hazard Detection Unit to completely resolve Data Hazards and Control Hazards.
