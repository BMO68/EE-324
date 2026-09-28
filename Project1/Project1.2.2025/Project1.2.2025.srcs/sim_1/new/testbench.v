`timescale 1ns / 1ps

module count_wrap_tb;

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

        rst = 1;
        en  = 1;

        // Hold reset
        #200;
        rst = 0;


        // --------------------------------------------------
        // Wait for Clock Wizard to lock
        // --------------------------------------------------

        wait (uut.locked == 1'b1);

        $display("Clock Wizard locked at %0t", $time);


        // --------------------------------------------------
        // Measure the 7 MHz clock
        // --------------------------------------------------

        @(posedge uut.clk_7mhz);
        time1 = $realtime;

        @(posedge uut.clk_7mhz);
        time2 = $realtime;

        clock_period = time2 - time1;

        $display("Clock period = %0.3f ns", clock_period);


        if ((clock_period > 142.7) &&
            (clock_period < 143.0))

            $display("PASS: Clock is approximately 7 MHz.");

        else
            $display("ERROR: Clock frequency is incorrect.");


        // --------------------------------------------------
        // Verify Counter A counts
        // --------------------------------------------------

        wait (a_val == 10);

        $display("PASS: Counter A is counting.");


        // --------------------------------------------------
        // Check A output at midpoint
        // --------------------------------------------------

        wait (a_val == 412);
        #1;

        if (A == 1)
            $display("PASS: A is high at a_val = 412.");
        else
            $display("ERROR: A should be high at 412.");


        // Next clock: 412 -> 413
        @(posedge uut.clk_7mhz);
        #1;

        if ((a_val == 413) && (A == 0))
            $display("PASS: A goes low after 412.");
        else
            $display("ERROR: A output incorrect after 412.");


        // --------------------------------------------------
        // Wait for Counter A maximum
        // --------------------------------------------------

        wait (a_val == 823);
        #1;

        $display("Counter A reached 823.");

        if (b_val == 0)
            $display("PASS: Counter B is still 0.");
        else
            $display("ERROR: Counter B counted too early.");


        // --------------------------------------------------
        // Next clock:
        // A rolls from 823 -> 0
        // B increments from 0 -> 1
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
        // Verify Counter B holds until next A rollover
        // --------------------------------------------------

        repeat (10)
            @(posedge uut.clk_7mhz);

        #1;

        if (b_val == 1)
            $display("PASS: Counter B only increments on A rollover.");
        else
            $display("ERROR: Counter B changed unexpectedly.");


        // --------------------------------------------------
        // End simulation
        // --------------------------------------------------

        $display("---------------------------------------");
        $display("TEST COMPLETE");
        $display("---------------------------------------");

        $finish;

    end

endmodule