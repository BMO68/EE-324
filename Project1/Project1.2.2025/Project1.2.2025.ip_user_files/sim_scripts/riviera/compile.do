transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib riviera/xpm
vlib riviera/xil_defaultlib

vmap xpm riviera/xpm
vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xpm  -incr "+incdir+../../../../../../../../AMD/2025.2/data/rsb/busdef" "+incdir+../../ipstatic" -l xpm -l xil_defaultlib \
"/home/dabingster/Public/AMD/2025.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -93  -incr \
"/home/dabingster/Public/AMD/2025.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../../../../../../AMD/2025.2/data/rsb/busdef" "+incdir+../../ipstatic" -l xpm -l xil_defaultlib \
"../../../Project1.2.2025.gen/sources_1/ip/clk_wiz_0/clk_wiz_0_clk_wiz.v" \
"../../../Project1.2.2025.gen/sources_1/ip/clk_wiz_0/clk_wiz_0.v" \
"../../../Project1.2.2025.srcs/sources_1/new/count_wrap.v" \
"../../../Project1.2.2025.srcs/sources_1/imports/new/bin_count.v" \
"../../../Project1.2.2025.srcs/sim_1/new/testbench.v" \

vlog -work xil_defaultlib \
"glbl.v"

