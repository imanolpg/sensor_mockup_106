## This file is a general .xdc for the Basys3 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## Clock signal
set_property PACKAGE_PIN W5 [get_ports clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]
 
 set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets paro_IBUF]
 
### Switches
set_property PACKAGE_PIN V17 [get_ports {pwmEnt[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {pwmEnt[0]}]
set_property PACKAGE_PIN V16 [get_ports {pwmEnt[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {pwmEnt[1]}]
set_property PACKAGE_PIN W16 [get_ports {pwmEnt[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {pwmEnt[2]}]
set_property PACKAGE_PIN W17 [get_ports {pwmEnt[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {pwmEnt[3]}]
#set_property PACKAGE_PIN W15 [get_ports {sw[4]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[4]}]
set_property PACKAGE_PIN V15 [get_ports {sw[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[0]}]
set_property PACKAGE_PIN W14 [get_ports {sw[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[1]}]
set_property PACKAGE_PIN W13 [get_ports {sw[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[2]}]
set_property PACKAGE_PIN V2 [get_ports {sw[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {sw[3]}]
#set_property PACKAGE_PIN T3 [get_ports {sel[1]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sel[1]}]
set_property PACKAGE_PIN T2 [get_ports {modo[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {modo[0]}]
set_property PACKAGE_PIN R3 [get_ports {modo[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {modo[1]}]
#set_property PACKAGE_PIN W2 [get_ports {modo[1]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {modo[1]}]
set_property PACKAGE_PIN U1 [get_ports {paro}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {paro}]
set_property PACKAGE_PIN T1 [get_ports {enableSwS}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {enableSwS}]
set_property PACKAGE_PIN R2 [get_ports {enableSw}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {enableSw}]
 

## LEDs
set_property PACKAGE_PIN U16 [get_ports {led[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]
set_property PACKAGE_PIN E19 [get_ports {led[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]
set_property PACKAGE_PIN U19 [get_ports {led[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]
set_property PACKAGE_PIN V19 [get_ports {led[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]
set_property PACKAGE_PIN W18 [get_ports {led[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {led[4]}]
set_property PACKAGE_PIN U15 [get_ports {led[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {led[5]}]
set_property PACKAGE_PIN U14 [get_ports {led[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {led[6]}]
set_property PACKAGE_PIN V14 [get_ports {led[7]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {led[7]}]
set_property PACKAGE_PIN V13 [get_ports {led[8]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {led[8]}]
set_property PACKAGE_PIN V3 [get_ports {led[9]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {led[9]}]
set_property PACKAGE_PIN W3 [get_ports {led[10]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {led[10]}]
set_property PACKAGE_PIN U3 [get_ports {led[11]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {led[11]}]
set_property PACKAGE_PIN P3 [get_ports {led[12]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {led[12]}]
set_property PACKAGE_PIN N3 [get_ports {led[13]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {led[13]}]
set_property PACKAGE_PIN P1 [get_ports {led[14]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {led[14]}]
set_property PACKAGE_PIN L1 [get_ports {led[15]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {led[15]}]
	
	
##7 segment display
set_property PACKAGE_PIN W7 [get_ports {segmentos[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {segmentos[6]}]
set_property PACKAGE_PIN W6 [get_ports {segmentos[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {segmentos[5]}]
set_property PACKAGE_PIN U8 [get_ports {segmentos[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {segmentos[4]}]
set_property PACKAGE_PIN V8 [get_ports {segmentos[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {segmentos[3]}]
set_property PACKAGE_PIN U5 [get_ports {segmentos[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {segmentos[2]}]
set_property PACKAGE_PIN V5 [get_ports {segmentos[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {segmentos[1]}]
set_property PACKAGE_PIN U7 [get_ports {segmentos[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {segmentos[0]}]

#set_property PACKAGE_PIN V7 [get_ports dp]							
	#set_property IOSTANDARD LVCMOS33 [get_ports dp]
	
##Pmod Header JB
##Sch name = JB1
set_property PACKAGE_PIN A14 [get_ports {alarma}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {alarma}]
##Sch name = JB2
set_property PACKAGE_PIN A16 [get_ports {cale}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {cale}]
##Sch name = JB3
set_property PACKAGE_PIN B15 [get_ports {dir}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {dir}]
##Sch name = JB4
set_property PACKAGE_PIN B16 [get_ports {pwmPos}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {pwmPos}]
##Sch name = JB7
#set_property PACKAGE_PIN A15 [get_ports {JB[4]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {JB[4]}]
##Sch name = JB8
set_property PACKAGE_PIN A17 [get_ports {step}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {step}]
##Sch name = JB9
set_property PACKAGE_PIN C15 [get_ports {enableSteper}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {enableSteper}]
##Sch name = JB10 
set_property PACKAGE_PIN C16 [get_ports {pwmNeg}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {pwmNeg}]
	
	##Pmod Header JC
##Sch name = JC1
set_property PACKAGE_PIN K17 [get_ports {dcEnc[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {dcEnc[0]}]
##Sch name = JC2
set_property PACKAGE_PIN M18 [get_ports {echo}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {echo}]
##Sch name = JC3
set_property PACKAGE_PIN N17 [get_ports {fc1Calle}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {fc1Calle}]
##Sch name = JC4
set_property PACKAGE_PIN P18 [get_ports {crc_en}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {crc_en}]
##Sch name = JC7
set_property PACKAGE_PIN L17 [get_ports {dcEnc[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {dcEnc[1]}]
##Sch name = JC8
set_property PACKAGE_PIN M19 [get_ports {trigger}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {trigger}]
##Sch name = JC9
set_property PACKAGE_PIN P17 [get_ports {fc2Tarj}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {fc2Tarj}]
##Sch name = JC10
set_property PACKAGE_PIN R18 [get_ports {ds_data_bus}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {ds_data_bus}]


set_property PACKAGE_PIN U2 [get_ports {enable_seg[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {enable_seg[0]}]
set_property PACKAGE_PIN U4 [get_ports {enable_seg[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {enable_seg[1]}]
set_property PACKAGE_PIN V4 [get_ports {enable_seg[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {enable_seg[2]}]
set_property PACKAGE_PIN W4 [get_ports {enable_seg[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {enable_seg[3]}]


###Buttons
set_property PACKAGE_PIN U18 [get_ports inicio]						
	set_property IOSTANDARD LVCMOS33 [get_ports inicio]
set_property PACKAGE_PIN T18 [get_ports btnU]						
	set_property IOSTANDARD LVCMOS33 [get_ports btnU]
set_property PACKAGE_PIN W19 [get_ports btnL]						
	set_property IOSTANDARD LVCMOS33 [get_ports btnL]
set_property PACKAGE_PIN T17 [get_ports btnR]						
	set_property IOSTANDARD LVCMOS33 [get_ports btnR]
set_property PACKAGE_PIN U17 [get_ports btnD]						
	set_property IOSTANDARD LVCMOS33 [get_ports btnD]