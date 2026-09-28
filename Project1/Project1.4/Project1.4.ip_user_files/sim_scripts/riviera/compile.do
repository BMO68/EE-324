transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib riviera/xil_defaultlib

vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../../../../../../AMD/2025.2/data/rsb/busdef" "+incdir+../../../Project1.4.gen/sources_1/ip/clk_wiz_0" -l xil_defaultlib \
"../../../Project1.4.srcs/sources_1/new/vga_sync.v" \


vlog -work xil_defaultlib \
"glbl.v"

