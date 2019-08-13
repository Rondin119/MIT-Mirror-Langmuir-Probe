
################################################################
# This is a generated script based on design: something_usefull
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2017.4
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   catch {common::send_msg_id "BD_TCL-109" "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source something_usefull_script.tcl


# The design that will be created by this Tcl script contains the following 
# module references:
# CurrentResponse, DivToAdrress

# Please add the sources of those modules before sourcing this Tcl script.

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xc7z010clg400-1
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name something_usefull

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_msg_id "BD_TCL-001" "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_msg_id "BD_TCL-002" "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_msg_id "BD_TCL-003" "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_msg_id "BD_TCL-004" "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_msg_id "BD_TCL-005" "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_msg_id "BD_TCL-114" "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:blk_mem_gen:8.4\
xilinx.com:ip:div_gen:5.1\
"

   set list_ips_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

##################################################################
# CHECK Modules
##################################################################
set bCheckModules 1
if { $bCheckModules == 1 } {
   set list_check_mods "\ 
CurrentResponse\
DivToAdrress\
"

   set list_mods_missing ""
   common::send_msg_id "BD_TCL-006" "INFO" "Checking if the following modules exist in the project's sources: $list_check_mods ."

   foreach mod_vlnv $list_check_mods {
      if { [can_resolve_reference $mod_vlnv] == 0 } {
         lappend list_mods_missing $mod_vlnv
      }
   }

   if { $list_mods_missing ne "" } {
      catch {common::send_msg_id "BD_TCL-115" "ERROR" "The following module(s) are not found in the project: $list_mods_missing" }
      common::send_msg_id "BD_TCL-008" "INFO" "Please add source files for the missing module(s) above."
      set bCheckIPsPassed 0
   }
}

if { $bCheckIPsPassed != 1 } {
  common::send_msg_id "BD_TCL-1003" "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_msg_id "BD_TCL-100" "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_msg_id "BD_TCL-101" "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports

  # Create ports
  set ISat_input [ create_bd_port -dir I -from 13 -to 0 ISat_input ]
  set Output_voltage [ create_bd_port -dir O -from 13 -to 0 Output_voltage ]
  set Resistence_input [ create_bd_port -dir I -from 13 -to 0 Resistence_input ]
  set T_input [ create_bd_port -dir I -from 13 -to 0 T_input ]
  set V_floating_input [ create_bd_port -dir I -from 13 -to 0 V_floating_input ]
  set input_clk [ create_bd_port -dir I -type clk input_clk ]
  set_property -dict [ list \
   CONFIG.FREQ_HZ {125000000} \
 ] $input_clk
  set input_voltage [ create_bd_port -dir I -from 13 -to 0 input_voltage ]

  # Create instance: CurrentResponse_0, and set properties
  set block_name CurrentResponse
  set block_cell_name CurrentResponse_0
  if { [catch {set CurrentResponse_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $CurrentResponse_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: DivToAdrress_0, and set properties
  set block_name DivToAdrress
  set block_cell_name DivToAdrress_0
  if { [catch {set DivToAdrress_0 [create_bd_cell -type module -reference $block_name $block_cell_name] } errmsg] } {
     catch {common::send_msg_id "BD_TCL-105" "ERROR" "Unable to add referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   } elseif { $DivToAdrress_0 eq "" } {
     catch {common::send_msg_id "BD_TCL-106" "ERROR" "Unable to referenced block <$block_name>. Please add the files for ${block_name}'s definition into the project."}
     return 1
   }
  
  # Create instance: blk_mem_gen_0, and set properties
  set blk_mem_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen_0 ]
  set_property -dict [ list \
   CONFIG.Byte_Size {9} \
   CONFIG.Coe_File {../../../../../../../../../../../../../../../instruments/plasma-current-response/cores/current_response_v1_0/exp_lut.coe} \
   CONFIG.EN_SAFETY_CKT {false} \
   CONFIG.Enable_32bit_Address {false} \
   CONFIG.Enable_A {Always_Enabled} \
   CONFIG.Load_Init_File {true} \
   CONFIG.Operating_Mode_A {READ_FIRST} \
   CONFIG.Read_Width_A {14} \
   CONFIG.Read_Width_B {14} \
   CONFIG.Register_PortA_Output_of_Memory_Primitives {false} \
   CONFIG.Use_Byte_Write_Enable {false} \
   CONFIG.Use_RSTA_Pin {false} \
   CONFIG.Write_Depth_A {16384} \
   CONFIG.Write_Width_A {14} \
   CONFIG.Write_Width_B {14} \
   CONFIG.use_bram_block {Stand_Alone} \
 ] $blk_mem_gen_0

  # Create instance: div_gen_0, and set properties
  set div_gen_0 [ create_bd_cell -type ip -vlnv xilinx.com:ip:div_gen:5.1 div_gen_0 ]
  set_property -dict [ list \
   CONFIG.dividend_and_quotient_width {14} \
   CONFIG.divisor_width {14} \
   CONFIG.fractional_width {13} \
   CONFIG.latency {31} \
   CONFIG.remainder_type {Fractional} \
 ] $div_gen_0

  # Create port connections
  connect_bd_net -net CurrentResponse_0_T_electron_out [get_bd_pins CurrentResponse_0/T_electron_out] [get_bd_pins div_gen_0/s_axis_divisor_tdata]
  connect_bd_net -net CurrentResponse_0_T_electron_out_tvalid [get_bd_pins CurrentResponse_0/T_electron_out_tvalid] [get_bd_pins div_gen_0/s_axis_divisor_tvalid]
  connect_bd_net -net CurrentResponse_0_V_LP [get_bd_pins CurrentResponse_0/V_LP] [get_bd_pins div_gen_0/s_axis_dividend_tdata]
  connect_bd_net -net CurrentResponse_0_V_LP_tvalid [get_bd_pins CurrentResponse_0/V_LP_tvalid] [get_bd_pins div_gen_0/s_axis_dividend_tvalid]
  connect_bd_net -net CurrentResponse_0_V_curr [get_bd_ports Output_voltage] [get_bd_pins CurrentResponse_0/V_curr]
  connect_bd_net -net DivToAdrress_0_Address_gen_tvalid [get_bd_pins CurrentResponse_0/Expo_result_tvalid] [get_bd_pins DivToAdrress_0/Address_gen_tvalid]
  connect_bd_net -net DivToAdrress_0_BRAM_addr [get_bd_pins DivToAdrress_0/BRAM_addr] [get_bd_pins blk_mem_gen_0/addra]
  connect_bd_net -net ISat_input_1 [get_bd_ports ISat_input] [get_bd_pins CurrentResponse_0/I_sat]
  connect_bd_net -net Resistence_input_1 [get_bd_ports Resistence_input] [get_bd_pins CurrentResponse_0/Resistence]
  connect_bd_net -net T_input_1 [get_bd_ports T_input] [get_bd_pins CurrentResponse_0/T_electron_in]
  connect_bd_net -net V_floating_input_1 [get_bd_ports V_floating_input] [get_bd_pins CurrentResponse_0/V_floating]
  connect_bd_net -net blk_mem_gen_0_douta [get_bd_pins CurrentResponse_0/Expo_result] [get_bd_pins blk_mem_gen_0/douta]
  connect_bd_net -net div_gen_0_m_axis_dout_tdata [get_bd_pins DivToAdrress_0/divider_tdata] [get_bd_pins div_gen_0/m_axis_dout_tdata]
  connect_bd_net -net div_gen_0_m_axis_dout_tvalid [get_bd_pins DivToAdrress_0/divider_tvalid] [get_bd_pins div_gen_0/m_axis_dout_tvalid]
  connect_bd_net -net input_clk_1 [get_bd_ports input_clk] [get_bd_pins CurrentResponse_0/adc_clk] [get_bd_pins DivToAdrress_0/adc_clk] [get_bd_pins blk_mem_gen_0/clka] [get_bd_pins div_gen_0/aclk]
  connect_bd_net -net input_voltage_1 [get_bd_ports input_voltage] [get_bd_pins CurrentResponse_0/Bias_voltage]

  # Create address segments


  # Restore current instance
  current_bd_instance $oldCurInst

  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


common::send_msg_id "BD_TCL-1000" "WARNING" "This Tcl script was generated from a block design that has not been validated. It is possible that design <$design_name> may result in errors during validation."

