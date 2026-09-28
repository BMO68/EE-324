transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+vga_sync  -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.vga_sync xil_defaultlib.glbl

do {vga_sync.udo}

run 1000ns

endsim

quit -force
