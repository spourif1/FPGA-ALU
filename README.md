## Project Title
FPGA ALU

## Project Overview
FPGA ALU done in Vivado. Use switches to load memory address with data and to load in opcode to then do an ALU operation using Artix 7 FPGA. Contains wrappers and a testbench for testing of the FPGA and register file wrapper.


## How to Compile
1. Open Vivado
2. Unzip vivadoprojectzip.zip
3. Open aluprojectp1.xpr in Vivado
4. Run Synthesis to ensure code opens correctly
5. Run Simulation to ensure timing behavior is correct
6. Plug in Artix 7 FPGA to computer to load code into FPGA
7. Generate Bitstream to FPGA
8. Run on FPGA interacting with switches and buttons

## Purpose
This was an assignment in class to teach how to program logic devices, in this case an Artix 7 FPGA. The ALU acts as the foundation for processors and this assignment taught how to program an ALU and to have it interact with other important parts (register files) of a processor for computation.

## Key Features
This implementation of an ALU has implementation of opcodes listed below. The FPGA using the switches on the board to get memory address, data to be written to the address which then coordinates with the ALU to provide Data A and Data B and an opcode which gets performed. The output then gets displayed and saved in a flip-flop.

ADC: Add with Carry
ADD: Add without carry
AND: Logical And 
ASR: Arithmetic Shift Right
LSL: Logical Shift Left
LSR: Logical Shift Right
MULS: Multiply Signed
MULT: Multiply Unsigned
NEG: Two's Complement
OR: Logical Or
ROL: Rotate Left Through Carry
ROR: Rotate Right Through Carry
SUB: Subtact Without Carry
SUBC: Subtract With Carry
XOR: Logical Exclusive OR
CLF: Clear Flags
STF: Set Flags
NOP: Increment Program Counter



## Languages Used
Most of the code is written in System Verilog (ALU, reg_file, reg_file_testbench) however the regfile wrapper is written in Verilog.

## Technologies Used
The Artix 7 FPGA is used as well as Vivado 2024.1 for uploading and coding to the FPGA.

## Scope
All the unzipped files are written by me and within the zip file, there are a few drivers that were provided (LED_DRIVER) from the class. 


## Sample Output from Testbench

Pass, address 0 read correctly on port A.  
Pass, address 0 read correctly on port B.
Pass, address 1 read correctly on port A.
Pass, address 1 read correctly on port B.
Pass, address 2 read correctly on port A.
Pass, address 2 read correctly on port B.
Pass, address 3 read correctly on port A.
Pass, address 3 read correctly on port B.
Pass, address 4 read correctly on port A.
Pass, address 4 read correctly on port B.
Pass, address 5 read correctly on port A.
Pass, address 5 read correctly on port B.
Pass, address 6 read correctly on port A.
Pass, address 6 read correctly on port B.
Pass, address 7 read correctly on port A.
Pass, address 7 read correctly on port B.
Pass, address 8 read correctly on port A.
Pass, address 8 read correctly on port B.
Pass, address 9 read correctly on port A.
Pass, address 9 read correctly on port B.
Pass, address 10 read correctly on port A.
Pass, address 10 read correctly on port B.
Pass, address 11 read correctly on port A.
Pass, address 11 read correctly on port B.
Pass, address 12 read correctly on port A.
Pass, address 12 read correctly on port B.
Pass, address 13 read correctly on port A.
Pass, address 13 read correctly on port B.
Pass, address 14 read correctly on port A.
Pass, address 14 read correctly on port B.
Pass, address 15 read correctly on port A.
Pass, address 15 read correctly on port B.
Pass, simultaneous read port A correct.
Pass, simultaneous read port B correct.
Pass, reset lights zo LED.
WRITE 05 to ADDR 0
Pass, ALU output 00000101.
run all
WRITE 35 to ADDR 1
Pass, ALU output 00110101.
WRITE 11 to ADDR 8
Pass, ALU output 00010001.
WRITE 88 to ADDR 15
Pass, ALU output 10001000.
RD=0, WR=1, EXPECT 0011_1010, Flags: 0 0 0
Pass, ALU output 00111010.
Pass, co LED correct.
Pass, zo LED correct.
Pass, no LED correct.
RD=8, WR=15, EXPECT 1001_1001, Flags: 0 0 1
Pass, ALU output 10011001.
Pass, co LED correct.
Pass, zo LED correct.
Pass, no LED correct.
RD=1, WR=8, EXPECT 0100_0110
Pass, ALU output 01000110.
RD=15, WR=0, EXPECT 1000_1101, Flags: 0 0 1
Pass, ALU output 10001101.
Pass, co LED correct.
Pass, zo LED correct.
Pass, no LED correct.
RD=15, WR=15 EXPECT 0001_0000, Flags: 1 0 0
Pass, ALU output 00010000.
Pass, co LED correct.
Pass, zo LED correct.
Pass, no LED correct.
PASS, no errors found
$finish called at time : 1305 ns : File "C:/Users/shh/Documents/vivado/aluprojectp3/aluprojectp1.srcs/sim_1/new/reg_file_tb.sv" Line 359
