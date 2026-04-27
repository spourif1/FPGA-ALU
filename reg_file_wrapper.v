`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UMBC
// Engineer: Shawn
// 
// Module Name: reg_file_wrap
//////////////////////////////////////////////////////////////////////////////////

module reg_file_wrap(
    input  wire        CLK100MHZ,
    input  wire        BTNC,
    input  wire        BTNR,
    input  wire [15:0] SW,

    output wire [2:0]  LED,
    output wire [7:0]  AN,
    output wire        CA,
    output wire        CB,
    output wire        CC,
    output wire        CD,
    output wire        CE,
    output wire        CF,
    output wire        CG,
    output wire        DP
);

    // edge-detect BTNC so one press gives one write pulse
    reg  BTNC_d;
    wire write_en;

    // register file inputs from switches
    wire [3:0] ra_addr;
    wire [3:0] rb_addr;
    wire [3:0] wr_addr;
    wire [7:0] wr_data;

    // register file outputs
    wire [7:0] data_a;
    wire [7:0] data_b;

    // ALU signals
    wire [15:0] alu_out;
    wire        co;
    wire        zo;
    wire        no;
    wire [4:0]  opcode;

    assign write_en = BTNC & ~BTNC_d;

    // switch mapping
    assign ra_addr = SW[15:12];
    assign wr_addr = SW[11:8];
    assign rb_addr = SW[11:8];   // second read port shares wr_addr switches
    assign wr_data = SW[7:0];

    // opcode fixed to ADD
    assign opcode = 5'b00100;

    // store previous BTNC for edge detection
    always @(posedge CLK100MHZ or posedge BTNR) begin
        if (BTNR)
            BTNC_d <= 1'b0;
        else
            BTNC_d <= BTNC;
    end

    // register file instance
    reg_file u_reg_file (
        .clk        (CLK100MHZ),
        .rst        (BTNR),
        .ra_addr    (ra_addr),
        .rb_addr    (rb_addr),
        .wr_addr    (wr_addr),
        .write_data (wr_data),
        .write_en   (write_en),
        .data_a     (data_a),
        .data_b     (data_b)
    );

    // ALU instance
    alu u_alu (
        .clk    (CLK100MHZ),
        .rst    (BTNR),
        .data_a (data_a),
        .data_b (data_b),
        .opcode (opcode),
        .ci     (1'b0),
        .zi     (1'b0),
        .ni     (1'b0),
        .data_o (alu_out),
        .co     (co),
        .zo     (zo),
        .no     (no)
    );

    // LED outputs for flags
    assign LED[0] = co;
    assign LED[1] = zo;
    assign LED[2] = no;

    // 7-segment driver instance
    // Displays alu_out[7:0] as 8 individual bits across the 8 digits
    led_driver u_led_driver (
        .clk    (CLK100MHZ),
        .rst    (BTNR),
        .data   (alu_out[3:0]),
        .data_e (alu_out[7:4]),
        .an     (AN),
        .ca     (CA),
        .cb     (CB),
        .cc     (CC),
        .cd     (CD),
        .ce     (CE),
        .cf     (CF),
        .cg     (CG),
        .dp     (DP)
    );

endmodule
