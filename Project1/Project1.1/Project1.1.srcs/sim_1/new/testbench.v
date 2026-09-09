`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2026 01:06:02 PM
// Design Name: 
// Module Name: testbench
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module count_wrap_tb;

    reg rst;
    reg clk;
    reg en;

    wire [9:0] a_val;
    wire [9:0] b_val;
    wire A;
    wire B;

    // Instantiate the wrapper
    count_wrap uut (
        .rst(rst),
        .clk(clk),
        .a_val(a_val),
        .b_val(b_val),
        .en(en),
        .A(A),
        .B(B)
    );

    // --------------------------------------------------
    // Generate clock
    // 10 ns period
    // --------------------------------------------------
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // --------------------------------------------------
    // Test sequence
    // --------------------------------------------------
    initial begin

        // Initial values
        rst = 1;
        en  = 1;

        // Keep reset asserted for a couple clock cycles
        repeat (2) @(posedge clk);
        #1;

        // Check reset
        if ((a_val != 0) || (b_val != 0))
            $display("ERROR: Counters did not reset.");
        else
            $display("PASS: Counters reset to zero.");

        // Release reset away from the rising clock edge
        @(negedge clk);
        rst = 0;


        // --------------------------------------------------
        // Check counter A
        // --------------------------------------------------

        // Wait until A reaches its midpoint
        wait (a_val == 412);
        #1;

        if (A == 1)
            $display("PASS: A asserted when a_val = 412.");
        else
            $display("ERROR: A not asserted at a_val = 412.");


        // On the next count A should turn off
        @(posedge clk);
        #1;

        if ((a_val == 413) && (A == 0))
            $display("PASS: A deasserted after midpoint.");
        else
            $display("ERROR: A output incorrect after midpoint.");


        // --------------------------------------------------
        // Check counter A overflow and counter B increment
        // --------------------------------------------------

        wait (a_val == 823);
        #1;

        if (b_val == 0)
            $display("PASS: B has not counted before A overflow.");
        else
            $display("ERROR: B counted too early.");

        // At next rising edge:
        // A should go 823 -> 0
        // B should go 0 -> 1
        @(posedge clk);
        #1;

        if ((a_val == 0) && (b_val == 1))
            $display("PASS: A overflow increments counter B.");
        else
            $display("ERROR: A overflow/B increment incorrect.");


        // --------------------------------------------------
        // Verify B does NOT count continuously
        // --------------------------------------------------

        wait (a_val == 100);
        #1;

        if (b_val == 1)
            $display("PASS: B only changes when A overflows.");
        else
            $display("ERROR: B changed without an A overflow.");


        // --------------------------------------------------
        // Check counter B midpoint/output
        // --------------------------------------------------

        wait (b_val == 300);
        #1;

        if (B == 1)
            $display("PASS: B asserted when b_val = 300.");
        else
            $display("ERROR: B not asserted at b_val = 300.");


        // Wait for next A overflow, which increments B to 301
        wait (a_val == 823);
        @(posedge clk);
        #1;

        if ((b_val == 301) && (B == 0))
            $display("PASS: B deasserted after midpoint.");
        else
            $display("ERROR: B output incorrect after midpoint.");


        $display("-----------------------------------------");
        $display("Testbench complete.");
        $display("-----------------------------------------");

        $finish;

    end

endmodule
