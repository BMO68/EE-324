`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2026 08:38:58 PM
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


module testbench;

    // --------------------------------------------------
    // Testbench signals
    // --------------------------------------------------

    reg rst;
    reg clk;
    reg en;

    wire [9:0] a_val;
    wire [9:0] b_val;

    wire A;
    wire B;

    realtime time1;
    realtime time2;
    realtime clock_period;


    // --------------------------------------------------
    // Instantiate the design
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
    // Period = 10 ns
    // Frequency = 100 MHz
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


        // --------------------------------------------------
        // Hold reset for a short time
        // --------------------------------------------------

        #200;

        rst = 0;

        $display("----------------------------------------");
        $display("Reset released at time %0t", $time);
        $display("----------------------------------------");


        // --------------------------------------------------
        // Wait for Clocking Wizard to lock
        // --------------------------------------------------

        wait (uut.locked == 1'b1);

        $display("PASS: Clocking Wizard locked.");
        $display("Lock time = %0t", $time);


        // --------------------------------------------------
        // Measure the generated 7 MHz clock
        // --------------------------------------------------

        @(posedge uut.clk_7mhz);
        time1 = $realtime;

        @(posedge uut.clk_7mhz);
        time2 = $realtime;

        clock_period = time2 - time1;

        $display("");
        $display("Measured clock period = %0.3f ns",
                 clock_period);


        // A 7 MHz clock should have a period
        // of approximately 142.857 ns

        if ((clock_period > 142.7) &&
            (clock_period < 143.0))

            $display("PASS: Clock frequency is approximately 7 MHz.");

        else
            $display("ERROR: Clock frequency is not 7 MHz.");


        // --------------------------------------------------
        // Check that Counter A is counting
        // --------------------------------------------------

        wait (a_val == 10);

        $display("");
        $display("PASS: Counter A reached 10.");
        $display("a_val = %0d", a_val);


        // --------------------------------------------------
        // Check output A
        //
        // A should be high through count 412
        // --------------------------------------------------

        wait (a_val == 412);
        #1;

        if (A == 1)
            $display("PASS: A is high when a_val = 412.");
        else
            $display("ERROR: A should be high at a_val = 412.");


        // Next 7 MHz clock makes count 413
        @(posedge uut.clk_7mhz);
        #1;

        if ((a_val == 413) && (A == 0))
            $display("PASS: A goes low after count 412.");
        else
            $display("ERROR: A did not go low after count 412.");


        // --------------------------------------------------
        // Check Counter A maximum count
        // --------------------------------------------------

        wait (a_val == 823);
        #1;

        $display("");
        $display("Counter A reached its maximum value.");
        $display("a_val = %0d", a_val);


        // Counter B should still be zero immediately
        // before A rolls over
        if (b_val == 0)
            $display("PASS: Counter B is still 0 before A rollover.");
        else
            $display("ERROR: Counter B counted too early.");


        // --------------------------------------------------
        // Next clock:
        //
        // Counter A: 823 -> 0
        // Counter B:   0 -> 1
        // --------------------------------------------------

        @(posedge uut.clk_7mhz);
        #1;

        if (a_val == 0)
            $display("PASS: Counter A rolled over to 0.");
        else
            $display("ERROR: Counter A did not roll over.");

        if (b_val == 1)
            $display("PASS: Counter B incremented to 1.");
        else
            $display("ERROR: Counter B did not increment.");


        // --------------------------------------------------
        // Verify B does not count every clock cycle
        // --------------------------------------------------

        repeat (10)
            @(posedge uut.clk_7mhz);

        #1;

        if (b_val == 1)
            $display("PASS: Counter B only counts when A rolls over.");
        else
            $display("ERROR: Counter B changed unexpectedly.");


        // --------------------------------------------------
        // Finish simulation
        // --------------------------------------------------

        $display("");
        $display("----------------------------------------");
        $display("TESTBENCH COMPLETE");
        $display("----------------------------------------");

        $finish;

    end

endmodule
