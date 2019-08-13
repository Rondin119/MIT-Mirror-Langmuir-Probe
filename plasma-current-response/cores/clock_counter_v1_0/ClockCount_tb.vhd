-------------------------------------------------------------------------------
-- Test bench for the SetVolts vhdl module
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity tb_ClkCount is

end entity tb_ClkCount;

architecture behaviour of tb_ClkCount is

  ---------------------- ProfileSweep Block Component-------------------------
  component ClkCount is
    port (
      adc_clk : in std_logic;             -- adc input clock
      count : in std_logic_vector(31 downto 0);

      out_en: out std_logic
    );
  end component ClkCount;

---------------------Signals for the ProfileSweep Block-----------------------
  -- input signals
  signal adc_clk : std_logic           := '0';
  signal count : std_logic_vector(31 downto 0) := std_logic_vector(to_unsigned(20, 32));
  signal out_en : std_logic := '0';

  constant adc_clk_period : time := 8 ns; 
  
  


  
begin  -- architecture behaviour
  -- Instantiating test unit
  
 
  
  ClkCount_inst : ClkCount
    PORT MAP (
    	-- Inputs
      adc_clk => adc_clk,
      count => count,

  		-- Outputs
      out_en => out_en
    );
  
  
  -- Clock process definitions
  adc_clk_process : process
  begin
    adc_clk <= '0';
    wait for adc_clk_period/2;
    adc_clk <= '1';
    wait for adc_clk_period/2;
  end process;

  -- Stimulus process
  stim_proc : process
  begin
    wait for adc_clk_period*200;
    count <= std_logic_vector(to_unsigned(0, 32));
    wait for adc_clk_period*200;
    count <= std_logic_vector(to_unsigned(10, 32));

end process;









end architecture behaviour;
