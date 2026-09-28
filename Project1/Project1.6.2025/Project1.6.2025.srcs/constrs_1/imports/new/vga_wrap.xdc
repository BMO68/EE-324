#These constraints are for the Blackboard
set_property -dict { PACKAGE_PIN U19   IOSTANDARD TMDS_33 } [get_ports hdmi_clk_n]; #IO_L12N_T1_MRCC_34 Sch=HDMI_TX_CLK_N
set_property -dict { PACKAGE_PIN U18   IOSTANDARD TMDS_33 } [get_ports hdmi_clk_p]; #IO_L12P_T1_MRCC_34 Sch=HDMI_TX_CLK_P

set_property -dict { PACKAGE_PIN V18   IOSTANDARD TMDS_33 } [get_ports hdmi_tx_n[0]]; #IO_L21N_T3_DQS_34 Sch=HDMI_TX0_N
set_property -dict { PACKAGE_PIN P18   IOSTANDARD TMDS_33 } [get_ports hdmi_tx_n[1]]; #IO_L23N_T3_34 Sch=HDMI_TX1_N
set_property -dict { PACKAGE_PIN P19   IOSTANDARD TMDS_33 } [get_ports hdmi_tx_n[2]]; #IO_L13N_T2_MRCC_34 Sch=HDMI_TX2_N

set_property -dict { PACKAGE_PIN V17   IOSTANDARD TMDS_33 } [get_ports hdmi_tx_p[0]]; #IO_L21P_T3_DQS_34 Sch=HDMI_TX0_P
set_property -dict { PACKAGE_PIN N17   IOSTANDARD TMDS_33 } [get_ports hdmi_tx_p[1]]; #IO_L23P_T3_34 Sch=HDMI_TX1_P
set_property -dict { PACKAGE_PIN N18   IOSTANDARD TMDS_33 } [get_ports hdmi_tx_p[2]]; #IO_L13P_T2_MRCC_34 Sch=HDMI_TX2_P

##Clock
set_property -dict { PACKAGE_PIN H16   IOSTANDARD LVCMOS33 } [get_ports { clk }];
#Switches
set_property -dict { PACKAGE_PIN R17   IOSTANDARD LVCMOS33 } [get_ports { rst }];