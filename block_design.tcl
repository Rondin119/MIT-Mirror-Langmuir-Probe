source $board_path/config/ports.tcl

# Add PS and AXI Interconnect
set board_preset $board_path/config/board_preset.tcl
source $sdk_path/fpga/lib/starting_point.tcl

# Add ADCs and DACs
source $sdk_path/fpga/lib/redp_adc_dac.tcl
set adc_dac_name adc_dac
add_redp_adc_dac $adc_dac_name

# Rename clocks
set adc_clk $adc_dac_name/adc_clk

# Add processor system reset synchronous to adc clock
set rst_adc_clk_name proc_sys_reset_adc_clk
cell xilinx.com:ip:proc_sys_reset:5.0 $rst_adc_clk_name {} {
  ext_reset_in $ps_name/FCLK_RESET0_N
  slowest_sync_clk $adc_clk
}

# Add config and status registers
source $sdk_path/fpga/lib/ctl_sts.tcl
add_ctl_sts $adc_clk $rst_adc_clk_name/peripheral_aresetn

# Connect LEDs
connect_port_pin led_o [get_slice_pin [ctl_pin led] 7 0]

# Connect ADC to status register
for {set i 0} {$i < [get_parameter n_adc]} {incr i} {
  connect_pins [sts_pin adc$i] adc_dac/adc[expr $i + 1]
}

# Add DAC controller
source $sdk_path/fpga/lib/bram.tcl
set dac_bram_name [add_bram dac]

# connect_pins adc_dac/dac1 [get_slice_pin $dac_bram_name/doutb 13 0]
# connect_pins adc_dac/dac2 [get_slice_pin $dac_bram_name/doutb 29 16]

connect_cell $dac_bram_name {
 web  [get_constant_pin 0 4]
 dinb [get_constant_pin 0 32]
 clkb $adc_clk
 rstb $rst_adc_clk_name/peripheral_reset
}


# Use AXI Stream clock converter (ADC clock -> FPGA clock)
set intercon_idx 0
set idx [add_master_interface $intercon_idx]
cell xilinx.com:ip:axis_clock_converter:1.1 adc_clock_converter {
  TDATA_NUM_BYTES 4
} {
  s_axis_aresetn $rst_adc_clk_name/peripheral_aresetn
  m_axis_aresetn [set rst${intercon_idx}_name]/peripheral_aresetn
  s_axis_aclk $adc_clk
  m_axis_aclk [set ps_clk$intercon_idx]
}

# Add AXI stream FIFO to read pulse data from the PS
cell xilinx.com:ip:axi_fifo_mm_s:4.1 adc_axis_fifo {
  C_USE_TX_DATA 0
  C_USE_TX_CTRL 0
  C_USE_RX_CUT_THROUGH true
  C_RX_FIFO_DEPTH 32768
  C_RX_FIFO_PF_THRESHOLD 32760
} {
  s_axi_aclk [set ps_clk$intercon_idx]
  s_axi_aresetn [set rst${intercon_idx}_name]/peripheral_aresetn
  S_AXI [set interconnect_${intercon_idx}_name]/M${idx}_AXI
  AXI_STR_RXD adc_clock_converter/M_AXIS
}

assign_bd_address [get_bd_addr_segs adc_axis_fifo/S_AXI/Mem0]
set memory_segment  [get_bd_addr_segs /${::ps_name}/Data/SEG_adc_axis_fifo_Mem0]
set_property offset [get_memory_offset adc_fifo] $memory_segment
set_property range  [get_memory_range adc_fifo]  $memory_segment

################################### Make all the Blocks ################################################3
create_bd_cell -type ip -vlnv PSFC:user:current_response:1.0 current_response_0
create_bd_cell -type ip -vlnv PSFC:user:Div_to_address:1.0 Div_to_address_0
create_bd_cell -type ip -vlnv xilinx.com:ip:div_gen:5.1 div_gen_0
create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0
create_bd_cell -type ip -vlnv PSFC:user:Profile_Sweep:1.0 Profile_Sweep_0
create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_ISAT
create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_Temp
create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_Vfloating
create_bd_cell -type ip -vlnv PSFC:user:input_control:1.0 input_control_0
create_bd_cell -type ip -vlnv PSFC:user:Div_int_delay:1.0 Div_int_delay_0
create_bd_cell -type ip -vlnv PSFC:user:manual_calibration:1.0 manual_calibration_0
create_bd_cell -type ip -vlnv PSFC:user:data_collector:1.0 data_collector_0
create_bd_cell -type ip -vlnv PSFC:user:acquire_trigger:1.0 acquire_trigger_0
create_bd_port -dir I Ext_trigger
create_bd_cell -type ip -vlnv xilinx.com:ip:util_vector_logic:2.0 trigger_OR
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 trigger_to_trigger
create_bd_cell -type ip -vlnv PSFC:user:clock_counter:1.0 clock_counter_data
create_bd_cell -type ip -vlnv PSFC:user:clock_counter:1.0 clock_counter_BRAM
create_bd_cell -type ip -vlnv PSFC:user:clock_counter:1.0 clock_counter_Temp
create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 Temp_data_constant
create_bd_cell -type ip -vlnv PSFC:user:output_mux:1.0 mux_temp
create_bd_cell -type ip -vlnv PSFC:user:output_mux:1.0 mux_isat
create_bd_cell -type ip -vlnv PSFC:user:output_mux:1.0 mux_vfloat
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 switch_to_mux
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 temp_slice
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 isat_slice
create_bd_cell -type ip -vlnv xilinx.com:ip:xlslice:1.0 vfloat_slice
#create_bd_cell -type ip -vlnv PSFC:user:delay_signal:1.0 LB_delay
################################### All Blocks Made #####################################################

################################### Connect All the Blocks ##############################################
#################################### Current Response Module  #####################################################
connect_bd_net [get_bd_pins current_response_0/adc_clk] [get_bd_pins adc_dac/adc_clk]
connect_bd_net [get_bd_pins current_response_0/T_electron_out] [get_bd_pins div_gen_0/s_axis_divisor_tdata]
connect_bd_net [get_bd_pins current_response_0/V_LP] [get_bd_pins div_gen_0/s_axis_dividend_tdata]
connect_bd_net [get_bd_pins current_response_0/V_LP_tvalid] [get_bd_pins div_gen_0/s_axis_dividend_tvalid]
connect_bd_net [get_bd_pins current_response_0/T_electron_out_tvalid] [get_bd_pins div_gen_0/s_axis_divisor_tvalid]
connect_bd_net [get_bd_pins current_response_0/V_curr] [get_bd_pins adc_dac/dac1]
connect_bd_net [get_bd_pins current_response_0/V_curr] [get_bd_pins sts/Current]
connect_bd_net [get_bd_pins current_response_0/Resistence] [get_bd_pins ctl/Resistence]
connect_bd_net [get_bd_pins data_collector_0/v_out] [get_bd_pins current_response_0/V_curr]
#connect_bd_net [get_bd_pins data_collector_0/v_out] [get_bd_pins adc_dac/adc1]
##################################### Current Response Module #######################################################

##################################### Div_to_address ################################################################
connect_bd_net [get_bd_pins Div_to_address_0/adc_clk] [get_bd_pins adc_dac/adc_clk]
connect_bd_net [get_bd_pins Div_to_address_0/BRAM_addr] [get_bd_pins blk_mem_gen_0/addra]
connect_bd_net [get_bd_pins Div_to_address_0/Address_gen_tvalid] [get_bd_pins current_response_0/Expo_result_tvalid]
connect_bd_net [get_bd_pins Div_to_address_0/divider_int_res] [get_bd_pins Div_int_delay_0/Int_in]
##################################### Div_to_address ################################################################

##################################### Divider Module ################################################################
set_property -dict [list CONFIG.dividend_and_quotient_width.VALUE_SRC USER CONFIG.divisor_width.VALUE_SRC USER] [get_bd_cells div_gen_0]
set_property -dict [list CONFIG.dividend_and_quotient_width {14} CONFIG.remainder_type {Fractional}]  [get_bd_cells div_gen_0]
set_property -dict [list CONFIG.divisor_width {14} CONFIG.fractional_width {10} CONFIG.latency {31}] [get_bd_cells div_gen_0]
connect_bd_net [get_bd_pins div_gen_0/aclk] [get_bd_pins adc_dac/adc_clk]
connect_bd_net [get_bd_pins div_gen_0/m_axis_dout_tdata] [get_bd_pins Div_to_address_0/divider_tdata]
connect_bd_net [get_bd_pins div_gen_0/m_axis_dout_tvalid] [get_bd_pins Div_to_address_0/divider_tvalid]
##################################### Divider Module ################################################################

##################################### BRAM Module ###################################################################
set_property -dict [list CONFIG.Enable_32bit_Address {false} CONFIG.Use_Byte_Write_Enable {false} CONFIG.Byte_Size {9} CONFIG.Write_Width_A {16} CONFIG.Write_Depth_A {16384} CONFIG.Read_Width_A {16} CONFIG.Operating_Mode_A {READ_FIRST} CONFIG.Enable_A {Always_Enabled} CONFIG.Write_Width_B {14} CONFIG.Read_Width_B {14} CONFIG.Register_PortA_Output_of_Memory_Primitives {true} CONFIG.Load_Init_File {true} CONFIG.Coe_File {/home1/william/Koheron/koheron-sdk/instruments/plasma-current-response-Charlie-Final-Version/cores/current_response_v1_0/current_lut.coe} CONFIG.Use_RSTA_Pin {false} CONFIG.use_bram_block {Stand_Alone} CONFIG.EN_SAFETY_CKT {false}] [get_bd_cells blk_mem_gen_0]
connect_bd_net [get_bd_pins blk_mem_gen_0/clka] [get_bd_pins adc_dac/adc_clk]
connect_bd_net [get_bd_pins blk_mem_gen_0/douta] [get_bd_pins current_response_0/Expo_result]
##################################### BRAM Module ###################################################################

##################################### Profile Sweeper ###############################################################
connect_bd_net [get_bd_pins Profile_Sweep_0/adc_clk] [get_bd_pins adc_dac/adc_clk]
connect_bd_net [get_bd_pins Profile_Sweep_0/clk_en] [get_bd_pins clock_counter_BRAM/out_en]
connect_bd_net [get_bd_pins Profile_Sweep_0/clk_rst] [get_bd_pins acquire_trigger_0/clear_pulse]
connect_bd_net [get_bd_pins Profile_Sweep_0/Profile_address] [get_bd_pins blk_mem_gen_ISAT/addra]
connect_bd_net [get_bd_pins Profile_Sweep_0/Profile_address] [get_bd_pins blk_mem_gen_Temp/addra]
connect_bd_net [get_bd_pins Profile_Sweep_0/Profile_address] [get_bd_pins blk_mem_gen_Vfloating/addra]
connect_bd_net [get_bd_pins Profile_Sweep_0/Profile_address] [get_bd_pins blk_mem_gen_dac/addrb]
##################################### Profile Sweeper ###############################################################

##################################### ISAT MemBlock   ##################################################################
set_property -dict [list CONFIG.use_bram_block {Stand_Alone} CONFIG.Enable_32bit_Address {false} CONFIG.Use_Byte_Write_Enable {false} CONFIG.Byte_Size {9} CONFIG.Write_Width_A {14} CONFIG.Write_Depth_A {8192} CONFIG.Read_Width_A {14} CONFIG.Operating_Mode_A {READ_FIRST} CONFIG.Enable_A {Always_Enabled} CONFIG.Write_Width_B {13} CONFIG.Read_Width_B {13} CONFIG.Register_PortA_Output_of_Memory_Primitives {true} CONFIG.Use_RSTA_Pin {false} CONFIG.EN_SAFETY_CKT {false}] [get_bd_cells blk_mem_gen_ISAT]
connect_bd_net [get_bd_pins blk_mem_gen_ISAT/clka] [get_bd_pins adc_dac/adc_clk]
set_property -dict [list CONFIG.Load_Init_File {true} CONFIG.Coe_File {/home1/william/Koheron/koheron-sdk/instruments/plasma-current-response-Charlie-Final-Version/Profiles/1160628014/iSat.coe}] [get_bd_cells blk_mem_gen_ISAT]
##################################### ISAT MemBlock ####################################################################

##################################### Temp MemBlock ###################################################################
set_property -dict [list CONFIG.use_bram_block {Stand_Alone} CONFIG.Enable_32bit_Address {false} CONFIG.Use_Byte_Write_Enable {false} CONFIG.Byte_Size {9} CONFIG.Write_Width_A {14} CONFIG.Write_Depth_A {8192} CONFIG.Read_Width_A {14} CONFIG.Operating_Mode_A {READ_FIRST} CONFIG.Enable_A {Always_Enabled} CONFIG.Write_Width_B {13} CONFIG.Read_Width_B {13} CONFIG.Register_PortA_Output_of_Memory_Primitives {true} CONFIG.Use_RSTA_Pin {false} CONFIG.EN_SAFETY_CKT {false}] [get_bd_cells blk_mem_gen_Temp]
connect_bd_net [get_bd_pins blk_mem_gen_Temp/clka] [get_bd_pins adc_dac/adc_clk]
set_property -dict [list CONFIG.Load_Init_File {true} CONFIG.Coe_File {/home1/william/Koheron/koheron-sdk/instruments/plasma-current-response-Charlie-Final-Version/Profiles/1160628014/Temp.coe}] [get_bd_cells blk_mem_gen_Temp]
##################################### Temp MemBlock ###################################################################

##################################### Vfloating MemBlock ###################################################################
set_property -dict [list CONFIG.use_bram_block {Stand_Alone} CONFIG.Enable_32bit_Address {false} CONFIG.Use_Byte_Write_Enable {false} CONFIG.Byte_Size {9} CONFIG.Write_Width_A {14} CONFIG.Write_Depth_A {8192} CONFIG.Read_Width_A {14} CONFIG.Operating_Mode_A {READ_FIRST} CONFIG.Enable_A {Always_Enabled} CONFIG.Write_Width_B {13} CONFIG.Read_Width_B {13} CONFIG.Register_PortA_Output_of_Memory_Primitives {true} CONFIG.Use_RSTA_Pin {false} CONFIG.EN_SAFETY_CKT {false}] [get_bd_cells blk_mem_gen_Vfloating]
connect_bd_net [get_bd_pins blk_mem_gen_Vfloating/clka] [get_bd_pins adc_dac/adc_clk]
set_property -dict [list CONFIG.Load_Init_File {true} CONFIG.Coe_File {/home1/william/Koheron/koheron-sdk/instruments/plasma-current-response-Charlie-Final-Version/Profiles/1160628014/vFloat.coe}] [get_bd_cells blk_mem_gen_Vfloating]
##################################### Vfloating MemBlock ###################################################################

####################################### Multiplex for Temp, iSat and vFloat ################################################
set_property -dict [list CONFIG.DIN_FROM {1} CONFIG.DIN_TO {1}] [get_bd_cells switch_to_mux]
connect_bd_net [get_bd_pins switch_to_mux/Din] [get_bd_pins ctl/Switch]
connect_bd_net [get_bd_pins switch_to_mux/Dout] [get_bd_pins mux_isat/switch]
connect_bd_net [get_bd_pins switch_to_mux/Dout] [get_bd_pins mux_temp/switch]
connect_bd_net [get_bd_pins switch_to_mux/Dout] [get_bd_pins mux_vfloat/switch]

connect_bd_net [get_bd_pins mux_isat/adc_clk] [get_bd_pins adc_dac/adc_clk]
connect_bd_net [get_bd_pins isat_slice/Din] [get_bd_pins blk_mem_gen_dac/doutb]
connect_bd_net [get_bd_pins mux_isat/signal_1] [get_bd_pins blk_mem_gen_ISAT/douta]
connect_bd_net [get_bd_pins mux_isat/signal_2] [get_bd_pins isat_slice/Dout]
set_property -dict [list CONFIG.DIN_FROM {9} CONFIG.DIN_TO {0}] [get_bd_cells isat_slice]

connect_bd_net [get_bd_pins mux_temp/adc_clk] [get_bd_pins adc_dac/adc_clk]
connect_bd_net [get_bd_pins temp_slice/Din] [get_bd_pins blk_mem_gen_dac/doutb]
connect_bd_net [get_bd_pins mux_temp/signal_1] [get_bd_pins blk_mem_gen_Temp/douta]
connect_bd_net [get_bd_pins mux_temp/signal_2] [get_bd_pins temp_slice/Dout]
set_property -dict [list CONFIG.DIN_FROM {19} CONFIG.DIN_TO {10}] [get_bd_cells temp_slice]

connect_bd_net [get_bd_pins mux_vfloat/adc_clk] [get_bd_pins adc_dac/adc_clk]
connect_bd_net [get_bd_pins vfloat_slice/Din] [get_bd_pins blk_mem_gen_dac/doutb]
connect_bd_net [get_bd_pins mux_vfloat/signal_1] [get_bd_pins blk_mem_gen_Vfloating/douta]
connect_bd_net [get_bd_pins mux_vfloat/signal_2] [get_bd_pins vfloat_slice/Dout]
set_property -dict [list CONFIG.DIN_FROM {29} CONFIG.DIN_TO {20}] [get_bd_cells vfloat_slice]
####################################### Multiplex for Temp, iSat and vFloat ################################################

##################################### input control block #################################################################
connect_bd_net [get_bd_pins input_control_0/adc_clk] [get_bd_pins adc_dac/adc_clk]
connect_bd_net [get_bd_pins ctl/Switch] [get_bd_pins input_control_0/switch]
connect_bd_net [get_bd_pins ctl/Temperature] [get_bd_pins input_control_0/T_e_const]
connect_bd_net [get_bd_pins ctl/ISat] [get_bd_pins input_control_0/ISat_const]
connect_bd_net [get_bd_pins ctl/Vfloating] [get_bd_pins input_control_0/V_f_const]
connect_bd_net [get_bd_pins mux_isat/signal_out] [get_bd_pins input_control_0/ISat_prof]
connect_bd_net [get_bd_pins mux_temp/signal_out] [get_bd_pins input_control_0/T_e_prof]
connect_bd_net [get_bd_pins mux_vfloat/signal_out] [get_bd_pins input_control_0/V_f_prof]
connect_bd_net [get_bd_pins input_control_0/T_e] [get_bd_pins current_response_0/T_electron_in]
connect_bd_net [get_bd_pins input_control_0/V_f] [get_bd_pins current_response_0/V_floating]
connect_bd_net [get_bd_pins input_control_0/Isat] [get_bd_pins current_response_0/I_sat]
connect_bd_net [get_bd_pins data_collector_0/Temp] [get_bd_pins input_control_0/T_e]
connect_bd_net [get_bd_pins data_collector_0/iSat] [get_bd_pins input_control_0/Isat]
connect_bd_net [get_bd_pins data_collector_0/vFloat] [get_bd_pins input_control_0/V_f]
##################################### input control block #################################################################

##################################### Clock counter blocks ################################################################
connect_bd_net [get_bd_pins clock_counter_data/adc_clk] [get_bd_pins adc_dac/adc_clk]
connect_bd_net [get_bd_pins clock_counter_data/count] [get_bd_pins ctl/Downsample]

connect_bd_net [get_bd_pins clock_counter_BRAM/adc_clk] [get_bd_pins adc_dac/adc_clk]
connect_bd_net [get_bd_pins clock_counter_BRAM/count] [get_bd_pins ctl/led]

connect_bd_net [get_bd_pins clock_counter_Temp/adc_clk] [get_bd_pins adc_dac/adc_clk]
connect_bd_net [get_bd_pins clock_counter_Temp/count] [get_bd_pins Temp_data_constant/dout]
set_property -dict [list CONFIG.CONST_WIDTH {32} CONFIG.CONST_VAL {125}] [get_bd_cells Temp_data_constant]
##################################### Clock counter blocks ################################################################

##################################### int delay block #####################################################################
connect_bd_net [get_bd_pins Div_int_delay_0/Int_out] [get_bd_pins current_response_0/Expo_int_result]
connect_bd_net [get_bd_pins Div_int_delay_0/adc_clk] [get_bd_pins adc_dac/adc_clk]
##################################### int delay block #####################################################################

##################################### Man Calibration #####################################################################
connect_bd_net [get_bd_pins manual_calibration_0/adc_clk] [get_bd_pins adc_dac/adc_clk]
#connect_bd_net [get_bd_pins ctl/led] [get_bd_pins manual_calibration_0/volt_in] ; # Set number operation
connect_bd_net [get_bd_pins adc_dac/adc1] [get_bd_pins manual_calibration_0/volt_in] ; # Normal operation
connect_bd_net [get_bd_pins manual_calibration_0/volt_out] [get_bd_pins current_response_0/Bias_voltage]
connect_bd_net [get_bd_pins manual_calibration_0/volt_out] [get_bd_pins adc_dac/dac2] ; # Comment out when adding delay
#connect_bd_net [get_bd_pins manual_calibration_0/volt_out] [get_bd_pins LB_delay/input]
connect_bd_net [get_bd_pins manual_calibration_0/volt_out] [get_bd_pins sts/Bias]
connect_bd_net [get_bd_pins ctl/Calibration_offset] [get_bd_pins manual_calibration_0/offset]
connect_bd_net [get_bd_pins ctl/Calibration_scale] [get_bd_pins manual_calibration_0/scale]
connect_bd_net [get_bd_pins data_collector_0/v_in] [get_bd_pins manual_calibration_0/volt_out] ; # comment out when adding delay
##################################### Man Calibration #####################################################################

##################################### Data Collector ######################################################################
connect_bd_net [get_bd_pins data_collector_0/adc_clk] [get_bd_pins adc_dac/adc_clk]
connect_bd_net [get_bd_pins data_collector_0/tdata] [get_bd_pins adc_clock_converter/s_axis_tdata]
connect_bd_net [get_bd_pins data_collector_0/tvalid] [get_bd_pins adc_clock_converter/s_axis_tvalid]
connect_bd_net [get_bd_pins data_collector_0/volt_valid] [get_bd_pins clock_counter_data/out_en]
connect_bd_net [get_bd_pins data_collector_0/Temp_valid] [get_bd_pins clock_counter_Temp/out_en]
##################################### Data Collector ######################################################################

##################################### Acquisition Trigger #################################################################
connect_bd_net [get_bd_pins acquire_trigger_0/adc_clk] [get_bd_pins adc_dac/adc_clk]
connect_bd_net [get_bd_pins acquire_trigger_0/acquire_valid] [get_bd_pins data_collector_0/clk_en]
set_property -dict [list CONFIG.C_SIZE {1} CONFIG.C_OPERATION {or}] [get_bd_cells trigger_OR]
set_property -dict [list CONFIG.DIN_TO {0} CONFIG.DIN_FROM {0} CONFIG.DIN_WIDTH {32}] [get_bd_cells trigger_to_trigger]
connect_bd_net [get_bd_ports Ext_trigger] [get_bd_pins trigger_OR/Op1]
connect_bd_net [get_bd_pins ctl/trigger] [get_bd_pins trigger_to_trigger/Din]
connect_bd_net [get_bd_pins trigger_to_trigger/Dout] [get_bd_pins trigger_OR/Op2]

connect_bd_net [get_bd_pins acquire_trigger_0/acquire_valid] [get_bd_pins blk_mem_gen_dac/enb]
connect_bd_net [get_bd_pins acquire_trigger_0/trigger] [get_bd_pins trigger_OR/Res]
connect_bd_net [get_bd_pins ctl/Time_in] [get_bd_pins acquire_trigger_0/AcqTime]
connect_bd_net [get_bd_pins acquire_trigger_0/timestamp] [get_bd_pins sts/Time_out]
##################################### Acquisition Trigger #################################################################

# ###################################### Loopback delay #####################################################################
# connect_bd_net [get_bd_pins LB_delay/adc_clk] [get_bd_pins adc_dac/adc_clk]
# connect_bd_net [get_bd_pins LB_delay/output] [get_bd_pins adc_dac/dac2]
# connect_bd_net [get_bd_pins data_collector_0/v_in] [get_bd_pins LB_delay/output]
# ###################################### Loopback delay #####################################################################
##################################### Connected all the Blocks ######################################################



























