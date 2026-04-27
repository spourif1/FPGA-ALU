## Project Title
FPGA ALU

## Project Description
FPGA ALU done in Vivado. Use switches to load memory address with data and to load in opcode to then do an ALU operation using Artix 7 FPGA. Contains wrappers and a testbench for testing of the FPGA and register file wrapper.


## How to Compile and Run TicTacToe Game
1. Open Vivado
2. Unzip vivadoprojectzip.zip
3. Open aluprojectp1.xpr in Vivado
4. Run Synthesis to ensure code opens correctly
5. Run Simulation to ensure timing behavior is correct
6. Plug in Artix 7 FPGA to computer to load code into FPGA
7. Generate Bitstream to FPGA
8. Run on FPGA interacting with switches and buttons


## Languages Used
Most of the code is written in System Verilog (ALU, reg_file, reg_file_testbench) however the regfile wrapper is written in Verilog.

## Scope
All the unzipped files are written by me and within the zip file, there are a few drivers that were provided (LED_DRIVER) from the class. 
