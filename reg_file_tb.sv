`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UMBC
// Engineer: Shawn P.
// 
// Create Date: 04/20/2026
// Module Name: reg_file_tb
// Description:
// Testbench for reg_file
//////////////////////////////////////////////////////////////////////////////////

module reg_file_tb ();
    logic CLK100MHZ = 0; // clk

    initial begin // set duty cycle
        forever #5 CLK100MHZ = !CLK100MHZ;
    end 
    
    
    logic [3:0] rf_ra_addr; // address that contains data a
    logic [3:0] rf_rb_addr; // address that contains data b
    logic [3:0] rf_wr_addr; // reg file write address
    logic [7:0] rf_write_data; // data that will be written to address
    logic       rf_write_en; // reg file write enable 
    logic       rf_rst; // reg file reset
    wire  [7:0] rf_data_a; // data output from port a  to alu 
    wire  [7:0] rf_data_b; // data output from port b to alu 
    
    reg_file u_reg_file ( // create a reg file instance
        .clk       (CLK100MHZ), // and map all the tb data to the reg file instance
        .rst       (rf_rst),
        .ra_addr   (rf_ra_addr),
        .rb_addr   (rf_rb_addr),
        .wr_addr   (rf_wr_addr),
        .write_data(rf_write_data),
        .write_en  (rf_write_en),
        .data_a    (rf_data_a),
        .data_b    (rf_data_b)
    );
    
    
    logic [15:0] SW; // 16 switches
    logic        BTNC; // button center
    logic        BTNR; // button reset 
    
    wire [2:0] LED; // LED
    wire [7:0] AN; // led sections 
    wire       CA;
    wire       CB;
    wire       CC;
    wire       CD;
    wire       CE;
    wire       CF;
    wire       CG;
    wire       DP;
    
    reg_file_wrap dut ( // device under test
        .CLK100MHZ(CLK100MHZ),
        .BTNC     (BTNC),
        .BTNR     (BTNR),
        .SW       (SW),
        .LED      (LED),
        .AN       (AN),
        .CA       (CA),
        .CB       (CB),
        .CC       (CC),
        .CD       (CD),
        .CE       (CE),
        .CF       (CF),
        .CG       (CG),
        .DP       (DP)
    );
    
    
    int errcnt = 0; // error count tracker
    int i; // iterator 
    logic [7:0] expected_mem [0:15]; // 16 mem address x 8 bit wide
    
    
    
    
    
   
    task press_btnc; // press center button
        begin
            @(negedge CLK100MHZ);
            BTNC = 1'b1;
            @(posedge CLK100MHZ);
            @(negedge CLK100MHZ);
            BTNC = 1'b0;
        end
    endtask
    
    task press_btnr; // press reset
        begin
            @(negedge CLK100MHZ);
            BTNR = 1'b1;
            @(posedge CLK100MHZ);
            @(negedge CLK100MHZ);
            BTNR = 1'b0;
        end
    endtask
    
    
    task check_display; // check display task
        input [7:0] exp_data;
        begin
            if (dut.alu_out[7:0] == exp_data)
                $display("Pass, ALU output %08b.", exp_data);
            else begin
                errcnt = errcnt + 1;
                $display("Fail, ALU output %08b, expected %08b.", dut.alu_out[7:0], exp_data);
            end
        end
    endtask
    
    task check_display_leds;
        input [7:0] exp_data;
        input       exp_c;
        input       exp_z;
        input       exp_n;
        begin
            if (dut.alu_out[7:0] == exp_data)
                $display("Pass, ALU output %08b.", exp_data);
            else begin
                errcnt = errcnt + 1;
                $display("Fail, ALU output %08b, expected %08b.", dut.alu_out[7:0], exp_data);
            end
            
            if (LED[0] == exp_c)
                $display("Pass, co LED correct.");
            else begin
                errcnt = errcnt + 1;
                $display("Fail, co LED incorrect.");
            end
            
            if (LED[1] == exp_z)
                $display("Pass, zo LED correct.");
            else begin
                errcnt = errcnt + 1;
                $display("Fail, zo LED incorrect.");
            end
            
            if (LED[2] == exp_n)
                $display("Pass, no LED correct.");
            else begin
                errcnt = errcnt + 1;
                $display("Fail, no LED incorrect.");
            end
        end
    endtask

// test
    initial begin
        rf_ra_addr    = 4'b0000; // set reg signals
        rf_rb_addr    = 4'b0000;
        rf_wr_addr    = 4'b0000;
        rf_write_data = 8'h00;
        rf_write_en   = 1'b0;
        rf_rst        = 1'b0;
    
        SW   = 16'h0000; // set switches and buttons
        BTNC = 1'b0;
        BTNR = 1'b0;
    
    for (i = 0; i < 16; i = i + 1) begin // create an array,
        expected_mem[i] = i[7:0]; // 16 address that each get 0-15
        // addr 0 = 0
        // addr 1 = 1
        // addr 15 = 15, for each addr expected mem
    end
    
    rf_rst = 1'b1; // reset the reg file
    @(posedge CLK100MHZ); // wait clock edges
    @(posedge CLK100MHZ);
    rf_rst = 1'b0; // turn reset down
    @(posedge CLK100MHZ); // wait block edges
    @(posedge CLK100MHZ);
    
    
    for (i = 0; i < 16; i = i + 1) begin  
        @(negedge CLK100MHZ);
        rf_wr_addr    = i[3:0]; // set write address to iterator
        rf_write_data = expected_mem[i]; // now set the data to the predetermined data
        rf_write_en   = 1'b1; // turn write on so wr_addr gets expected mem
        
        @(posedge CLK100MHZ); // wait clock edges
        @(negedge CLK100MHZ);
        rf_write_en   = 1'b0; // turn wr en off
        
        @(posedge CLK100MHZ); // wait clock edges
        @(posedge CLK100MHZ); 
        
    end
    
    for (i = 0; i < 16; i = i + 1) begin
        @(negedge CLK100MHZ);
        rf_ra_addr = i[3:0]; // set ra address to iterator
        rf_rb_addr = i[3:0]; // set rb address to iterator
        @(posedge CLK100MHZ);
        @(posedge CLK100MHZ);
    
        if (rf_data_a == expected_mem[i]) // see if recently wrote mem from ra is right
            $display("Pass, address %0d read correctly on port A.", rf_ra_addr);
        else begin // if not 
            errcnt = errcnt + 1; // increase error count by 1
            $display("Fail, address %0d in PA contains data = %08b. Need %08b.", i, rf_data_a, expected_mem[i]);
        end
    
        if (rf_data_b == expected_mem[i]) // same thing for port b
            $display("Pass, address %0d read correctly on port B.", rf_ra_addr);
        else begin
            errcnt = errcnt + 1;
            $display("Fail, address %0d in  PB = %08b. Need %08b.",
            i, rf_data_b, expected_mem[i]);
        end
    end
    
    @(negedge CLK100MHZ); // wait for neg clock edge 
    rf_ra_addr = 4'h0; // addr 0 for ra 
    rf_rb_addr = 4'h1; // addr 1 for rb 
    @(posedge CLK100MHZ);
    @(posedge CLK100MHZ);
    
    // at the same time, read both ra and rb
    if (rf_data_a == expected_mem[0]) // see if ra matches 0
        $display("Pass, simultaneous read port A correct.");
    else begin
        errcnt = errcnt + 1;
        $display("Fail, simultaneous read port A = %08b, expected %08b.", rf_data_a, expected_mem[3]);
    end
    
    if (rf_data_b == expected_mem[1]) // see if rb matches 1 
        $display("Pass, simultaneous read port B correct.");
    else begin
        errcnt = errcnt + 1;
        $display("Fail, simultaneous read port B = %08b, expected %08b.",rf_data_b, expected_mem[12]);
    end
    
    
    press_btnr;
    @(posedge CLK100MHZ);
    @(posedge CLK100MHZ);
    @(posedge CLK100MHZ);
    @(posedge CLK100MHZ);
    
    if (LED[1] == 1'b1) // after reset, make sure zo led is lit
        $display("Pass, reset lights zo LED.");
    else begin
        errcnt = errcnt + 1;
        $display("Fail, reset does not light zo LED.");
    end
    
    SW[15:12] = 4'b0111; // set rd address to 0111
    SW[11:8] = 4'h0; // address 0
    SW[7:0]  = 8'h05; // data 05
    
    press_btnc; // press btnc
    @(posedge CLK100MHZ); // wait clock edges
    @(posedge CLK100MHZ);
    @(posedge CLK100MHZ);
    @(posedge CLK100MHZ);
    $display("WRITE 05 to ADDR 0"); // check to see if 05 got wrote to addr 0
    check_display(8'h05); // and display the result
    
    SW[11:8] = 4'h1; // addr 1
    SW[7:0]  = 8'h35; // data 35
    
    press_btnc; // load data to addr
    @(posedge CLK100MHZ);
    @(posedge CLK100MHZ);
    @(posedge CLK100MHZ);
    @(posedge CLK100MHZ);
    $display("WRITE 35 to ADDR 1"); // check
    check_display(8'h35);
    
    SW[11:8] = 4'h8; // addr 8 
    SW[7:0]  = 8'h11; // data 11
    
    press_btnc;
    @(posedge CLK100MHZ);
    @(posedge CLK100MHZ);
    @(posedge CLK100MHZ);
    @(posedge CLK100MHZ);
    $display("WRITE 11 to ADDR 8"); // check
    check_display(8'h11);
    
    SW[11:8] = 4'hF; // addr 15
    SW[7:0]  = 8'h88; // data 88
    
    press_btnc;
    @(posedge CLK100MHZ);
    @(posedge CLK100MHZ);
    @(posedge CLK100MHZ);
    @(posedge CLK100MHZ);
    $display("WRITE 88 to ADDR 15"); // check
    check_display(8'h88);
    
    
    SW[15:12] = 4'h0; // rd address 0000
    SW[11:8]  = 4'h1; // wr addr 1
    SW[7:0]   = 8'h00; 
    
    @(posedge CLK100MHZ);
    @(posedge CLK100MHZ);
    @(posedge CLK100MHZ);
    @(posedge CLK100MHZ);
    $display("RD=0, WR=1, EXPECT 0011_1010, Flags: 0 0 0"); 
    check_display_leds(8'b0011_1010, 1'b0, 1'b0, 1'b0); //check to see if display and led flags match
    
    SW[15:12] = 4'h8; // rd address 8 
    SW[11:8]  = 4'hF; // wr address 15
    SW[7:0]   = 8'h00;
    
    @(posedge CLK100MHZ);
    @(posedge CLK100MHZ);
    @(posedge CLK100MHZ);
    @(posedge CLK100MHZ);
    $display("RD=8, WR=15, EXPECT 1001_1001, Flags: 0 0 1"); // check output and led flags
    check_display_leds(8'b1001_1001, 1'b0, 1'b0, 1'b1);
    
    SW[15:12] = 4'h1; // rd addr 1 
    SW[11:8]  = 4'h8; // wr addr 8
    SW[7:0]   = 8'h00;
    
    @(posedge CLK100MHZ);
    @(posedge CLK100MHZ);
    @(posedge CLK100MHZ);
    @(posedge CLK100MHZ);
    $display("RD=1, WR=8, EXPECT 0100_0110"); // only checking display, no flags legs
    check_display(8'b0100_0110);
    
    SW[15:12] = 4'hF; // rd addr 15 
    SW[11:8]  = 4'h0; // wr addr 0 
    SW[7:0]   = 8'h00;
    
    @(posedge CLK100MHZ);
    @(posedge CLK100MHZ);
    @(posedge CLK100MHZ);
    @(posedge CLK100MHZ);
    $display("RD=15, WR=0, EXPECT 1000_1101, Flags: 0 0 1"); // check display and NO flag leds
    check_display_leds(8'b1000_1101, 1'b0, 1'b0, 1'b1); 
    
    SW[15:12] = 4'hF; // rd addr 15 
    SW[11:8]  = 4'hF; // wr addr 15
    SW[7:0]   = 8'h00;
    @(posedge CLK100MHZ);
    @(posedge CLK100MHZ);
    @(posedge CLK100MHZ);
    @(posedge CLK100MHZ);
    $display("RD=15, WR=15 EXPECT 0001_0000, Flags: 1 0 0"); // check display and co flag led
    check_display_leds(8'b0001_0000, 1'b1, 1'b0, 1'b0);
    
    if (errcnt == 0)
    $display("PASS, no errors found");
    else
    $display("FAIL, error count = %0d", errcnt);
    
    $finish;
    end
    
endmodule 
