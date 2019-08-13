-------------------------------------------------------------------------------
-- Module to set 3 different voltages levels for inital MLP demonstration
-- Started on March 26th by Charlie Vincent
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ProfileSweep is
  -- adjustment for non-divisible periods

  port (
    adc_clk : in std_logic;             -- adc input clock
    clk_en  : in std_logic;
    clk_rst : in std_logic;

    Profile_address : out std_logic_vector(13 downto 0)
    );

end entity ProfileSweep;

architecture Behavioral of ProfileSweep is

  signal addr_mask         : std_logic_vector(13 downto 0) := (others => '0');
  signal rising_or_falling : std_logic                     := '1';

begin  -- architecture Behavioral

  ----purpose: process to set the BRAM address for the look up table retrival 
  ----Type   : combination
  ----inputs : adc_clk
  ----outputs: Profile_address
  --profile_proc : process(adc_clk)
  --begin
  --  if (rising_edge(adc_clk)) then
  --    if clk_rst = '1' then
  --      addr_mask <= (others => '0');
  --      rising_or_falling <= '1';
  --    else
  --      if (rising_or_falling = '1') then

  --        addr_mask       <= std_logic_vector(signed(addr_mask) + 1);
  --        Profile_address <= addr_mask;

  --        if (addr_mask = "11111111111110") then
  --          rising_or_falling <= '0';
  --        end if;

  --      elsif (rising_or_falling = '0') then

  --        addr_mask       <= std_logic_vector(signed(addr_mask) - 1);
  --        Profile_address <= addr_mask;

  --        if (addr_mask = "00000000000000") then
  --          rising_or_falling <= '1';
  --        end if;

  --      end if;
  --    end if;
  --  end if;
  --end process profile_proc;

  --purpose: process to set the BRAM address for the look up table retrieval 
  --Type   : combination
  --inputs : adc_clk
  --outputs: Profile_address
  profile_proc : process(adc_clk)
  begin
    if (rising_edge(adc_clk)) then
      if clk_rst = '1' then
        addr_mask <= (others => '0');
      else
        if clk_en = '1' then
           addr_mask       <= std_logic_vector(signed(addr_mask) + 1);
           Profile_address <= addr_mask;
        end if;       
      end if;
    end if;
  end process profile_proc;

end architecture Behavioral;
