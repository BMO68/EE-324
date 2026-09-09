#Individual LEDS
set_property -dict { PACKAGE_PIN N20   IOSTANDARD LVCMOS33 } [get_ports { led[0] }]; #IO_L14P_T2_SRCC_34 Schematic=LD0
set_property -dict { PACKAGE_PIN P20   IOSTANDARD LVCMOS33 } [get_ports { led[1] }]; #IO_L14N_T2_SRCC_34 Schematic=LD1

#Switches
set_property -dict { PACKAGE_PIN R17   IOSTANDARD LVCMOS33 } [get_ports { sw[0] }]; #IO_L19N_T3_VREF_34 Schematic=SW0
set_property -dict { PACKAGE_PIN U20   IOSTANDARD LVCMOS33 } [get_ports { rst }]; #IO_L15N_T2_DQS_34 Schematic=SW1

##Clock
set_property -dict { PACKAGE_PIN H16   IOSTANDARD LVCMOS33 } [get_ports { clk }];