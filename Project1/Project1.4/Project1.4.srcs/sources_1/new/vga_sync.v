`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/08/2026 08:19:42 PM
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


module vga_sync(

    input clk,
    input rst,
    
    output hsync,
    output vsync,
    output video_active // Asserted whenever counters are in the active display area range.
                        // Suggestion: Add outputs that indicate active x and y coordinates?

    );
    
    wire clk_25MHz;
    
    
    //------------------------------------
    // Clock
    //------------------------------------
    
      clk_wiz_0 vga_clock
   (
    // Clock out ports
    .clk_out1(clk_25MHz),     // output clk_out1
    // Status and control signals
    .reset(rst), // input reset
    .locked(locked),       // output locked
   // Clock in ports
    .clk_in1(clk)      // input clk_in1
);

    
    
endmodule
