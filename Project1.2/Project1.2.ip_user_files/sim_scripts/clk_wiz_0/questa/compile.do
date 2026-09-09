vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib

vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xil_defaultlib  -incr -mfcu  "+incdir+../../../ipstatic" "+incdir+../../../../../../../AMD/2026.1/Vivado/data/rsb/busdef" \
"../../../../Project1.2.gen/sources_1/ip/clk_wiz_0/clk_wiz_0_clk_wiz.v" \
"../../../../Project1.2.gen/sources_1/ip/clk_wiz_0/clk_wiz_0.v" \


vlog -work xil_defaultlib \
"glbl.v"

