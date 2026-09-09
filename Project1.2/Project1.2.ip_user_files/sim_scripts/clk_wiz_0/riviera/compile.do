transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

vlib work
vlib riviera/xil_defaultlib

vmap xil_defaultlib riviera/xil_defaultlib

vlog -work xil_defaultlib  -incr -v2k5 "+incdir+../../../ipstatic" "+incdir+../../../../../../../AMD/2026.1/Vivado/data/rsb/busdef" -l xil_defaultlib \
"../../../../Project1.2.gen/sources_1/ip/clk_wiz_0/clk_wiz_0_clk_wiz.v" \
"../../../../Project1.2.gen/sources_1/ip/clk_wiz_0/clk_wiz_0.v" \


vlog -work xil_defaultlib \
"glbl.v"

