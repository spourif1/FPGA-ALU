`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UMBC   
// Engineer:  Shawn P.
// 
// Create Date: 03/06/2026 11:16:40 PM
// Design Name: CMPE316 ALU HW#3 P1
// Module Name: alu
// 
//////////////////////////////////////////////////////////////////////////////////

module alu (
    input logic clk, //100 MHz clock
    input logic rst, // async active high reset
    input logic [7:0] data_a, // 8bit input a
    input logic [7:0] data_b, // 8bit input b
    input logic [4:0] opcode, // 5bit opcode
    input logic ci, // carry in
    input logic zi, // zero in
    input logic ni, // negative in
    output logic [15:0] data_o, // 16bit output
    output logic co, // carry out
    output logic zo, // zero out
    output logic no // negative out
);




    //  input registered flip-flops
    reg [4:0] opcode_d; // inputs of flip flop
    reg [7:0] data_a_d; // i dont really understand the flipflop
    reg [7:0] data_b_d; // and will ask questions about it soon
    reg ci_d; // it just says i need to use it
    reg zi_d;
    reg ni_d;
    reg co_d;
    reg zo_d;
    reg no_d;
    logic [15:0] data_o_d;
    // output  flip-flops
    reg [15:0] data_o_q;
    reg co_q;
    reg zo_q;
    reg no_q;
    reg data;
    logic [15:0] data_o_q2;


    // opcodes
    // 000101 ADDC
    // 00100 ADD
    // 00001 AND
    // 01101 ASR
    // 01011 LSL
    // 01100 LSR
    // 01001 MULS
    // 01000 MULT
    // 01010 NEG
    // 00010 OR
    // 01110 ROL
    // 01111 ROR
    // 00110 SUB
    // 00111 SUBC
    // 00011 XOR
    // 10000 CLF
    // 10001 STF
    // 00000 NOP

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin // sync all the signals to zero through the flipflop
            opcode_d <= 5'b0; // nonblocking
            data_a_d <= 8'b0;
            data_b_d <= 8'b0;
            ci_d <= 1'b0;
            zi_d <= 1'b0;
            ni_d <= 1'b0;
            data_o_q <= 16'b0;
            co_q <= 1'b0;
            zo_q <= 1'b0;
            no_q <= 1'b0;
        end
        else begin
            opcode_d <= opcode;
            data_a_d <= data_a;
            data_b_d <= data_b;
            ci_d <= ci;
            zi_d <= zi;
            ni_d <= ni;
            data_o_q <= data_o_d;
            data_o_q2 <= data_o_q;
            co_q <= co_d;
            zo_q <= zo_d;
            no_q <= no_d;
        end
    end 
    always @(*) begin // based on the operation, perform computation
        co_d = co_q; // computation formulas found from slides posted
        zo_d = zo_q; // all blocking assignments
        no_d = no_q;
        data_o_d = data_o_q;
        case (opcode_d)
            5'b00101: begin // ADDC add with carry
                data_o_d = {8'b0, data_a_d} + {8'b0, data_b_d} + {{15{1'b0}}, ci_d};
                zo_d = ~|data_o_d[7:0];
                no_d = data_o_d[7];
                co_d = data_o_d[8];
            end
            5'b00100: begin // ADD add without carry
                data_o_d = {8'b0, data_a_d} + {8'b0, data_b_d};
                zo_d = ~|data_o_d[7:0];
                no_d = data_o_d[7];
                co_d = data_o_d[8];
            end
            5'b00001: begin // AND logical and 
                data_o_d = data_a_d & data_b_d;
                zo_d = ~|data_o_d[7:0];
                no_d = data_o_d[7];
            end
            5'b01101: begin // ASR arithmetic shift right 
                data_o_d = {data_a_d[7], data_a_d[7:1]};
                zo_d = ~|data_o_d[7:0];
                no_d = data_o_d[7];
                co_d = data_a_d[0];
            end
            5'b01011: begin // LSL logical shift left
                data_o_d = {data_a_d[6:0], 1'b0};
                zo_d = ~|data_o_d[7:0];
                no_d = data_o_d[7];
                co_d = data_a_d[7];
            end
            5'b01100: begin // LSR logical shift right 
                data_o_d = {1'b0, data_a_d[7:1]};
                zo_d = ~|data_o_d[7:0];
                no_d = 1'b0;
                co_d = data_a_d[0];
            end
            5'b01001: begin // MULS multiply signed
                data_o_d = data_a_d * data_b_d;
                zo_d = ~|data_o_d;
                no_d = 1'b0;
                co_d = data_o_d[15];
            end
            5'b01000: begin // MULT multiply unsigned 
                data_o_d = data_a_d * data_b_d;
                zo_d = ~|data_o_d;
                no_d = 1'b0;
                co_d = data_o_d[15];
            end
            5'b01010: begin // NEG twos complement
                data_o_d ={8'b0, ~data_a_d + 1'b1};
                zo_d = ~|data_o_d[7:0];
                no_d = data_o_d[7];
                co_d =  ~zo_d;
            end
            5'b00010: begin // OR logical or 
                data_o_d = data_a_d | data_b_d;
                zo_d = ~|data_o_d[7:0];
                no_d = data_o_d[7];
            end
            5'b01110: begin // ROL rotate left through carry
                data_o_d = {8'd0, data_a_d[6:0], co_q};
                zo_d = ~|data_o_d;
                no_d = data_o_d[7];
                co_d = data_a_d[7];
            end
            5'b01111: begin // ROR rotate right through carry
                data_o_d = {8'd0, co_q, data_a_d[7:1]}; 
                zo_d = ~|data_o_d;
                no_d = data_o_d[7];
                co_d = data_a_d[0];
            end
            5'b00110: begin // SUB subtract without carry
                data_o_d = {8'b0, data_a_d} - {8'b0, data_b_d};
                zo_d = ~|data_o_d[7:0];
                no_d = data_o_d[7];
                co_d = (~data_a_d[7] & data_b_d[7]) | (~data_a_d[7] & data_o_d[7]) | (data_b_d[7] & data_o_d[7]);
            end
            5'b00111: begin // SUBC subtract with carry 
                data_o_d = {8'b0, data_a_d} - {8'b0, data_b_d} - { {15{1'b0}}, ci_d};
                zo_d = ~|data_o_d[7:0];
                no_d = data_o_d[7];
                co_d = (~data_a_d[7] & data_b_d[7]) | (~data_a_d[7] & data_o_d[7]) | (data_b_d[7] & data_o_d[7]);
            end
            5'b00011: begin // XOR logical exclusive or 
                data_o_d = data_a_d ^ data_b_d;
                no_d = data_o_d[7];
                zo_d = ~|data_o_d[7:0];
            end
            5'b10000: begin // CLF clear flags
                data_o_d = data_o_q;
                co_d = 1'b0;
                zo_d = 1'b0;
                no_d = 1'b0;
            end
            5'b10001: begin // STF set flags
                data_o_d = data_o_q2;
                co_d = ci_d;
                zo_d = zi_d;
                no_d = ni_d;
            end
            5'b00000: begin // NOP increment program counter
                data_o_d = data_o_q;
                co_d = co_q;
                zo_d = zo_q;
                no_d = no_q;
            end
        endcase
    end
    assign data_o = data_o_q;
    assign co     = co_q;
    assign zo     = zo_q;
    assign no     = no_q;
endmodule
