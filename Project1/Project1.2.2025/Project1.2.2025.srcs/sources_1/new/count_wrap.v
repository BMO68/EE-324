`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/07/2026 08:37:07 PM
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


module count_wrap
(
    input rst,
    input clk,
    input en,

    output [9:0] a_val,
    output [9:0] b_val,

    output A,
    output B
);

    // --------------------------------------------------
    // Internal signals
    // --------------------------------------------------

    wire clk_7mhz;
    wire locked;

    wire a_en;
    wire b_en;

    wire counter_rst;


    // --------------------------------------------------
    // Clocking Wizard
    //
    // Input clock  = 100 MHz
    // Output clock = 7 MHz
    // --------------------------------------------------

  clk_wiz_0 clock_generator
   (
    // Clock out ports
    .clk_out1(clk_7mhz),     // output clk_out1
    // Status and control signals
    .reset(rst), // input reset
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1(clk)      // input clk_in1
);

    // Keep the counters in reset until the
    // Clocking Wizard has locked.
    assign counter_rst = rst | ~locked;


    // --------------------------------------------------
    // Counter A
    //
    // 10-bit counter
    // Counts 0 through 823
    // --------------------------------------------------

    bin_count #(
        .MAX_COUNT(823),
        .WIDTH(10)
    )
    cntrA
    (
        .rst(counter_rst),
        .clk(clk_7mhz),
        .cen(a_en),
        .val(a_val)
    );


    // --------------------------------------------------
    // Counter B
    //
    // 10-bit counter
    // Counts 0 through 600
    // --------------------------------------------------

    bin_count #(
        .MAX_COUNT(600),
        .WIDTH(10)
    )
    cntrB
    (
        .rst(counter_rst),
        .clk(clk_7mhz),
        .cen(b_en),
        .val(b_val)
    );


    // --------------------------------------------------
    // Enable logic
    // --------------------------------------------------

    // Counter A always counts
    assign a_en = 1'b1;

    // Counter B counts only when Counter A
    // reaches its maximum value
    assign b_en = (a_val == 823);


    // --------------------------------------------------
    // Output logic
    // --------------------------------------------------

    assign A = (a_val <= 412);

    assign B = (b_val <= 300);


endmodule
