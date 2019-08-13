-------------------------------------------------------------------------------
-- Module to set 3 different voltages levels for inital MLP demonstration
-- Started on March 26th by Charlie Vincent
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DivIntDelay is
    -- adjustment for non-divisible periods

  port (
    adc_clk : in std_logic;             -- adc input clock
    Int_in : in std_logic_vector(13 downto 0);

    Int_out : out std_logic_vector(13 downto 0)
    );

end entity DivIntDelay;

architecture Behavioral of DivIntDelay is

begin  -- architecture Behavioral




--purpose: process to set the BRAM address for the look up table retrival
--Type   : combination
--inputs : adc_clk, divider_tdata
--outputs: BRAM_addr, waitBRAM

  Process(adc_clk)
  variable timer : integer := 0;
  variable Int_out_mask : std_logic_vector(13 downto 0) := (others => '1');
  begin 
    if (rising_edge(adc_clk)) then
      if Int_in /= Int_out_mask then
    	  if timer /= 1 then 
    	   	timer := timer + 1;
    	  elsif timer = 1 then
          Int_out_mask := Int_in;
    		  Int_out <= Int_in;
    	  end if;
      elsif (Int_in = Int_out_mask) then
        timer := 0;
      else
        timer := 0;
    end if;
    end if;
  end process;

end architecture Behavioral;
