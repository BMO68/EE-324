`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/16/2026 05:28:50 PM
// Design Name: 
// Module Name: vga_wrapper
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


module vga_wrapper(
    input clk,
    input rst,

    output hdmi_clk_n,
    output hdmi_clk_p,
    output [2:0] hdmi_tx_n,
    output [2:0] hdmi_tx_p
);

    // --------------------------------------------------
    // Internal signals
    // --------------------------------------------------

    wire clk_25MHz;
    wire clk_125MHz;

    wire locked;
    wire vga_rst;

    wire hsync;
    wire vsync;
    wire vde;

    wire [7:0] red;
    wire [7:0] green;
    wire [7:0] blue;

    wire [9:0] x_pix;
    wire [9:0] y_pix;


    // --------------------------------------------------
    // Clock Wizard
    //
    // Input:
    //     100 MHz
    //
    // Outputs:
    //     25 MHz  pixel clock
    //     125 MHz 5x pixel clock
    // --------------------------------------------------

    clk_wiz_0 clk_wiz (
        .clk_out1(clk_25MHz),
        .clk_out2(clk_125MHz),
        .reset(rst),
        .locked(locked),
        .clk_in1(clk)
    );


    // --------------------------------------------------
    // Hold VGA logic in reset until the
    // Clock Wizard has locked
    // --------------------------------------------------

    assign vga_rst = rst | ~locked;


    // --------------------------------------------------
    // VGA Sync Generator
    // --------------------------------------------------

    vga_sync vga (
        .clk(clk_25MHz),
        .rst(vga_rst),

        .hsync(hsync),
        .vsync(vsync),
        .video_active(vde),

        .x(x_pix),
        .y(y_pix)
    );


    // --------------------------------------------------
    // Display solid white
    //
    // Maximum value on all RGB channels = white
    // --------------------------------------------------

    assign red   = 8'hFF;
    assign green = 8'hFF;
    assign blue  = 8'hFF;


    // --------------------------------------------------
    // Real Digital VGA-to-HDMI converter
    // --------------------------------------------------

    hdmi_tx_0 vga_to_hdmi (

        // Clocking and Reset
        .pix_clk(clk_25MHz),
        .pix_clkx5(clk_125MHz),
        .pix_clk_locked(locked),

        // Reset is active HIGH
        .rst(rst),

        // Color and Sync Signals
        .red(red),
        .green(green),
        .blue(blue),

        .hsync(hsync),
        .vsync(vsync),
        .vde(vde),

        // Auxiliary Data - unused
        .aux0_din(4'b0),
        .aux1_din(4'b0),
        .aux2_din(4'b0),
        .ade(1'b0),

        // Differential HDMI outputs
        .TMDS_CLK_P(hdmi_clk_p),
        .TMDS_CLK_N(hdmi_clk_n),

        .TMDS_DATA_P(hdmi_tx_p),
        .TMDS_DATA_N(hdmi_tx_n)
    );


endmodule