-------------------------------------------------------------------------------
-- Module to downsample the clock to provide clk_en where needed.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ClkCount is
  -- adjustment for non-divisible periods

  port (
    adc_clk : in std_logic;             -- adc input clock
    count   : in std_logic_vector(31 downto 0);

    out_en : out std_logic
    );

end entity ClkCount;

architecture Behavioral of ClkCount is

  signal counter  : unsigned(31 downto 0) := (others => '0');
  signal decision : std_logic             := '0';
  signal out_mask : std_logic             := '0';

begin  -- architecture Behavioral

  -- purpose: process to set the ouput enable given the input count and the adc_clk
  -- Type   : combination
  -- inputs : count
  -- outputs: out_en, decision
  decision_proc : process(adc_clk)
  begin
    if rising_edge(adc_clk) then
      if to_integer(unsigned(count)) = 0 then
        decision <= '0';
      else
        decision <= '1';
      end if;
    end if;
  end process decision_proc;


  -- purpose: process to set the ouput enable given the input count and the adc_clk
  -- Type   : combination
  -- inputs : adc_clk, counter
  -- outputs: out_en
  enable_proc : process(adc_clk)
  begin
    if (rising_edge(adc_clk)) then
      if decision = '1' then
        if counter = unsigned(count) - 1 then
          out_mask <= '1';
          counter  <= (others => '0');
        else
          out_mask <= '0';
          counter  <= counter + 1;
        end if;
      else
        counter <= (others => '0');
      end if;
    end if;
  end process enable_proc;

  out_proc : process(decision, adc_clk)
  begin
    if decision = '0' then
      out_en <= adc_clk;
    elsif decision = '1' then
      out_en <= out_mask;
    end if;
  end process out_proc;

end architecture Behavioral;
