vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xpm
vlib modelsim_lib/msim/xil_defaultlib

vmap xpm modelsim_lib/msim/xpm
vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xpm -64 -incr -mfcu  -sv "+incdir+../../../../../../../../AMD/2025.2/data/rsb/busdef" "+incdir+../../ipstatic" \
"/home/dabingster/Public/AMD/2025.2/data/ip/xpm/xpm_cdc/hdl/xpm_cdc.sv" \

vcom -work xpm -64 -93  \
"/home/dabingster/Public/AMD/2025.2/data/ip/xpm/xpm_VCOMP.vhd" \

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+../../../../../../../../AMD/2025.2/data/rsb/busdef" "+incdir+../../ipstatic" \
"../../../Project1.2.2025.gen/sources_1/ip/clk_wiz_0/clk_wiz_0_clk_wiz.v" \
"../../../Project1.2.2025.gen/sources_1/ip/clk_wiz_0/clk_wiz_0.v" \
"../../../Project1.2.2025.srcs/sources_1/new/count_wrap.v" \
"../../../Project1.2.2025.srcs/sources_1/imports/new/bin_count.v" \
"../../../Project1.2.2025.srcs/sim_1/new/testbench.v" \

vlog -work xil_defaultlib \
"glbl.v"

