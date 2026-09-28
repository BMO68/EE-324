`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/16/2026 05:33:19 PM
// Design Name: 
// Module Name: vga_sync
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

module vga_sync
(
    input  clk,          // 25 MHz pixel clock
    input  rst,

    output hsync,
    output vsync,
    output video_active,

    // Optional, but useful later
    output [9:0] x,
    output [9:0] y
);

    // --------------------------------------------------
    // VGA 640x480 timing constants
    // --------------------------------------------------

    parameter H_ACTIVE = 640;
    parameter H_FRONT  = 16;
    parameter H_SYNC   = 96;
    parameter H_BACK   = 48;
    parameter H_TOTAL  = 800;

    parameter V_ACTIVE = 480;
    parameter V_FRONT  = 10;
    parameter V_SYNC   = 2;
    parameter V_BACK   = 33;
    parameter V_TOTAL  = 525;


    // --------------------------------------------------
    // Counter signals
    // --------------------------------------------------

    wire [9:0] h_count;
    wire [9:0] v_count;

    wire v_enable;


    // --------------------------------------------------
    // Horizontal counter
    //
    // Counts every pixel clock:
    // 0 through 799
    // --------------------------------------------------

    bin_count #(
        .MAX_COUNT(H_TOTAL - 1),
        .WIDTH(10)
    )
    horizontal_counter
    (
        .rst(rst),
        .clk(clk),
        .cen(1'b1),
        .val(h_count)
    );


    // --------------------------------------------------
    // Vertical counter enable
    //
    // Increment vertical position once at the
    // end of each horizontal line.
    // --------------------------------------------------

    assign v_enable = (h_count == H_TOTAL - 1);


    // --------------------------------------------------
    // Vertical counter
    //
    // Counts lines:
    // 0 through 524
    // --------------------------------------------------

    bin_count #(
        .MAX_COUNT(V_TOTAL - 1),
        .WIDTH(10)
    )
    vertical_counter
    (
        .rst(rst),
        .clk(clk),
        .cen(v_enable),
        .val(v_count)
    );


    // --------------------------------------------------
    // Pixel coordinates
    // --------------------------------------------------

    assign x = h_count;
    assign y = v_count;


    // --------------------------------------------------
    // Active video region
    //
    // Visible pixels:
    // x = 0 through 639
    // y = 0 through 479
    // --------------------------------------------------

    assign video_active =
        (h_count < H_ACTIVE) &&
        (v_count < V_ACTIVE);


    // --------------------------------------------------
    // Horizontal sync
    //
    // Sync begins after:
    // 640 active + 16 front porch = 656
    //
    // Low from 656 through 751
    // --------------------------------------------------

    assign hsync =
        ~((h_count >= H_ACTIVE + H_FRONT) &&
          (h_count <  H_ACTIVE + H_FRONT + H_SYNC));


    // --------------------------------------------------
    // Vertical sync
    //
    // Sync begins after:
    // 480 active + 10 front porch = 490
    //
    // Low for lines 490 and 491
    // --------------------------------------------------

    assign vsync =
        ~((v_count >= V_ACTIVE + V_FRONT) &&
          (v_count <  V_ACTIVE + V_FRONT + V_SYNC));


endmodule
