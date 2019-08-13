-------------------------------------------------------------------------------
-- Test bench for the SetVolts vhdl module
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity tb_PCR is

end entity tb_PCR;

architecture behaviour of tb_PCR is
  ----------------------PCR Moduels Block Component
component something_usefull is
port (
	input_clk : in std_logic := '0';
	T_input : in std_logic_vector(13 downto 0) := (others => '0');
	ISat_input : in std_logic_vector(13 downto 0) := (others => '0');
	V_floating_input : in std_logic_vector(13 downto 0) := (others => '0');
	input_voltage : in std_logic_vector(13 downto 0) := (others => '0');
	Resistence_input : in std_logic_vector(13 downto 0) := (others => '0');

	Output_voltage : out std_logic_vector(13 downto 0) := (others => '0')
	);
end component something_usefull;

signal  input_clk : std_logic := '0';
signal  T_input : std_logic_vector(13 downto 0) := (others => '0');
signal	ISat_input : std_logic_vector(13 downto 0) := (others => '0');
signal	V_floating_input : std_logic_vector(13 downto 0) := (others => '0');
signal	input_voltage : std_logic_vector(13 downto 0) := (others => '0');
signal	Resistence_input : std_logic_vector(13 downto 0) := (others => '0');

signal	Output_voltage : std_logic_vector(13 downto 0) := (others => '0');

constant adc_clk_period : time := 8 ns; 

begin  -- architecture behaviour
  instance_name : something_usefull
  port map (
-----------inputs----------------------------------------------------------------
input_clk => input_clk,
T_input => T_input,
ISat_input => ISat_input,
V_floating_input => V_floating_input,
input_voltage => input_voltage,
Resistence_input => Resistence_input,

Output_voltage => Output_voltage
);


-- Clock process definitions
  adc_clk_process : process
  begin
    input_clk <= '1';
    wait for adc_clk_period/2;
    input_clk <= '0';
    wait for adc_clk_period/2;
  end process;


stm_proc : process
begin
	wait for adc_clk_period*45;
	T_input <= std_logic_vector(to_signed(20,T_input'length));
	ISat_input <= std_logic_vector(to_signed(2,ISat_input'length));
	V_floating_input <= std_logic_vector(to_signed(3,V_floating_input'length));
	input_voltage <= std_logic_vector(to_signed(5,input_voltage'length));
	Resistence_input <= std_logic_vector(to_signed(1,Resistence_input'length));

	wait for adc_clk_period*45;
	T_input <= std_logic_vector(to_signed(30,T_input'length));
	ISat_input <= std_logic_vector(to_signed(2,ISat_input'length));
	V_floating_input <= std_logic_vector(to_signed(3,V_floating_input'length));
	input_voltage <= std_logic_vector(to_signed(5,input_voltage'length));
	Resistence_input <= std_logic_vector(to_signed(1,Resistence_input'length));

	wait for adc_clk_period*45;
	T_input <= std_logic_vector(to_signed(30,T_input'length));
	ISat_input <= std_logic_vector(to_signed(4,ISat_input'length));
	V_floating_input <= std_logic_vector(to_signed(3,V_floating_input'length));
	input_voltage <= std_logic_vector(to_signed(5,input_voltage'length));
	Resistence_input <= std_logic_vector(to_signed(1,Resistence_input'length));	


	wait for adc_clk_period*45;
	T_input <= std_logic_vector(to_signed(30,T_input'length));
	ISat_input <= std_logic_vector(to_signed(4,ISat_input'length));
	V_floating_input <= std_logic_vector(to_signed(3,V_floating_input'length));
	input_voltage <= std_logic_vector(to_signed(1,input_voltage'length));
	Resistence_input <= std_logic_vector(to_signed(1,Resistence_input'length));
	end process;

end architecture behaviour;
