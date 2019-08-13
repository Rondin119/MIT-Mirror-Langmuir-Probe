-------------------------------------------------------------------------------
-- Module to set 3 different voltages levels for inital MLP demonstration
-- Started on March 26th by Charlie Vincent
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Cap is
    -- adjustment for non-divisible periods

  port (
    adc_clk : in std_logic;            -- adc input clock
    Curr : in std_logic_vector(13 downto 0);
    Capacitance : in std_logic_vector(13 downto 0);

    V_LP : out std_logic_vector(13 downto 0)  
    );

end entity Cap;

architecture Behavioral of Cap is

begin  -- architecture Behavioral

--purpose: process to set the BRAM address for the look up table retrival
--Type   : combination
--inputs : adc_clk, divider_tdata
--outputs: BRAM_addr, waitBRAM
BRAM_proc : process (adc_clk) is
	variable Cap_Charge : signed(13 downto 0) := (others => '0');
	variable Cap_Voltage : signed(13 downto 0) := (others => '0');
  begin  -- process BRAM_proc
    if rising_edge(adc_clk) then
      Cap_Charge := Cap_Charge + Curr;
    end if;
  end process BRAM_proc;


end architecture Behavioral;
