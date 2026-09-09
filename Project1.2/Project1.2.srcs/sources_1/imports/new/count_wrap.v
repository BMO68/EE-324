`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2026 12:47:54 PM
// Design Name: 
// Module Name: count_wrap
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


`timescale 1ns / 1ps

module count_wrap_tb;

    reg rst;
    reg clk;
    reg en;

    wire [9:0] a_val;
    wire [9:0] b_val;
    wire A;
    wire B;

    realtime t1;
    realtime t2;
    realtime period_7mhz;

    integer start_count;


    // --------------------------------------------------
    // Instantiate count_wrap
    // --------------------------------------------------

    count_wrap uut (
        .rst(rst),
        .clk(clk),
        .en(en),
        .a_val(a_val),
        .b_val(b_val),
        .A(A),
        .B(B)
    );


    // --------------------------------------------------
    // Generate 100 MHz input clock
    //
    // 10 ns period = 100 MHz
    // --------------------------------------------------

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end


    // --------------------------------------------------
    // Test sequence
    // --------------------------------------------------

    initial begin

        // Initial conditions
        rst = 1;
        en  = 1;

        // Keep reset asserted initially
        #200;

        // Release reset
        rst = 0;

        $display("-----------------------------------------");
        $display("Reset released at %0t", $time);
        $display("-----------------------------------------");


        // --------------------------------------------------
        // Wait for Clocking Wizard to lock
        // --------------------------------------------------

        wait (uut.locked == 1'b1);

        $display("PASS: Clocking Wizard locked at %0t", $time);


        // --------------------------------------------------
        // Measure generated 7 MHz clock
        // --------------------------------------------------

        @(posedge uut.clk_7mhz);
        t1 = $realtime;

        @(posedge uut.clk_7mhz);
        t2 = $realtime;

        period_7mhz = t2 - t1;

        $display("Measured 7 MHz clock period = %0.3f ns",
                 period_7mhz);


        // Expected period:
        // 1 / 7 MHz = 142.857 ns

        if ((period_7mhz > 142.7) &&
            (period_7mhz < 143.0))

            $display("PASS: Generated clock is approximately 7 MHz.");

        else
            $display("ERROR: Generated clock frequency is incorrect.");


        // --------------------------------------------------
        // Verify Counter A is counting
        // --------------------------------------------------

        @(posedge uut.clk_7mhz);
        #1;

        start_count = a_val;

        // Wait 10 generated clock cycles
        repeat (10)
            @(posedge uut.clk_7mhz);

        #1;

        if (a_val == start_count + 10)
            $display("PASS: Counter A counted 10 times in 10 clock cycles.");

        else
            $display("ERROR: Counter A count rate incorrect.");


        // --------------------------------------------------
        // Verify midpoint output A
        // --------------------------------------------------

        wait (a_val == 412);
        #1;

        if (A == 1)
            $display("PASS: A asserted at a_val = 412.");

        else
            $display("ERROR: A not asserted at a_val = 412.");


        // Next clock should make a_val = 413
        @(posedge uut.clk_7mhz);
        #1;

        if ((a_val == 413) && (A == 0))
            $display("PASS: A deasserted after 412.");

        else
            $display("ERROR: A output incorrect after 412.");


        // --------------------------------------------------
        // Verify Counter A overflow
        // --------------------------------------------------

        wait (a_val == 823);
        #1;

        $display("Counter A reached 823 at %0t", $time);

        if (b_val == 0)
            $display("PASS: Counter B still equals 0 before overflow.");

        else
            $display("ERROR: Counter B counted too soon.");


        // Next 7 MHz edge should:
        //
        // A: 823 -> 0
        // B:   0 -> 1
        // --------------------------------------------------

        @(posedge uut.clk_7mhz);
        #1;

        if (a_val == 0)
            $display("PASS: Counter A rolled over from 823 to 0.");

        else
            $display("ERROR: Counter A failed to roll over.");


        if (b_val == 1)
            $display("PASS: Counter B incremented after A overflow.");

        else
            $display("ERROR: Counter B did not increment.");


        // --------------------------------------------------
        // Verify B does not continuously count
        // --------------------------------------------------

        repeat (10)
            @(posedge uut.clk_7mhz);

        #1;

        if (b_val == 1)
            $display("PASS: Counter B only counts when A overflows.");

        else
            $display("ERROR: Counter B changed unexpectedly.");


        // --------------------------------------------------
        // Finish
        // --------------------------------------------------

        $display("");
        $display("-----------------------------------------");
        $display("TESTBENCH COMPLETE");
        $display("-----------------------------------------");

        $finish;

    end

endmodule

