vlib questa_lib/work
vlib questa_lib/msim

vlib questa_lib/msim/xil_defaultlib

vmap xil_defaultlib questa_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+../../../../../../../../AMD/2025.2/data/rsb/busdef" "+incdir+../../../Project1.4.gen/sources_1/ip/clk_wiz_0" \
"../../../Project1.4.srcs/sources_1/new/vga_sync.v" \


vlog -work xil_defaultlib \
"glbl.v"

