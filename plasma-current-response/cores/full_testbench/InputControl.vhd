-------------------------------------------------------------------------------
-- Module to set 3 different voltages levels for inital MLP demonstration
-- Started on March 26th by Charlie Vincent
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Input_control is
    -- adjustment for non-divisible periods

  port (
    adc_clk : in std_logic;             -- adc input clock
    switch : in std_logic_vector(31 downto 0);
    T_e_const : in std_logic_vector(13 downto 0);
    T_e_prof : in std_logic_vector(13 downto 0);
    V_f_const : in std_logic_vector(13 downto 0);
    V_f_prof : in std_logic_vector(13 downto 0);
    ISat_const : in std_logic_vector(13 downto 0);
    ISat_prof : in std_logic_vector(13 downto 0);

    T_e : out std_logic_vector(13 downto 0);
    V_f : out std_logic_vector(13 downto 0);
    Isat : out std_logic_vector(13 downto 0)
    );

end entity Input_control;

architecture Behavioral of Input_control is

signal switch_mask : std_logic_vector(0 downto 0) := "0";


begin  -- architecture Behavioral




--purpose: process to set the BRAM address for the look up table retrival
--Type   : combination
--inputs : adc_clk, divider_tdata
--outputs: BRAM_addr, waitBRAM

  Process(adc_clk)
  begin 
    if (rising_edge(adc_clk)) then
    switch_mask <= switch(0 downto 0);
      if (switch_mask = "1") then
      T_e <= T_e_const;
      V_f <= V_f_const;
      Isat <= ISat_const;
      elsif (switch_mask = "0") then
      T_e <= T_e_prof;
      V_f <= V_f_prof;
      Isat <= ISat_prof; 
      end if;

    end if;
  end process;

end architecture Behavioral;
