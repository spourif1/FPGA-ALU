`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UMBC
// Engineer: Shawn P.
// 
// Create Date: 04/12/2026 08:29:32 PM
// Module Name: reg_file
//////////////////////////////////////////////////////////////////////////////////


module reg_file(
    input  logic       clk, //clk
    input  logic       rst, //reset
    input  logic [3:0] ra_addr, // read address for data_a
    input  logic [3:0] rb_addr, // read address for data_b
    input  logic [3:0] wr_addr, // write address
    input  logic [7:0] write_data, // data that is write
    input  logic       write_en, // write enable
    output logic [7:0] data_a, // address a
    output logic [7:0] data_b // address b
);

    logic [7:0] mem [0:15]; // 16 address that store 8 bits

    logic [3:0] ra_addr_q;  // flip flops for inputs
    logic [3:0] rb_addr_q; 
    logic [3:0] wr_addr_q;
    logic [7:0] write_data_q;
    logic       write_en_q;

    integer i;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin // set all inputs to zero
            ra_addr_q   <= 4'b0;
            rb_addr_q   <= 4'b0;
            wr_addr_q   <= 4'b0;
            write_data_q<= 8'b0;
            write_en_q  <= 1'b0;

            for (i = 0; i < 16; i = i + 1)
                mem[i] <= 8'b0; // for each address set to zero
        end
        else begin // set outputs to given inputs
            ra_addr_q    <= ra_addr;
            rb_addr_q    <= rb_addr;
            wr_addr_q    <= wr_addr;
            write_data_q <= write_data;
            write_en_q   <= write_en;

            if (write_en_q) // if write enable on
                mem[wr_addr_q] <= write_data_q; // take the write address and set it to the write data mem
        end
    end

    always_comb begin // outputs are
        data_a = mem[ra_addr_q]; // data = the mem location of data_a addr
        data_b = mem[rb_addr_q]; // data b = the mem location of data_b addr
    end

endmodule