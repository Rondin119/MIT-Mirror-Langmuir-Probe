-------------------------------------------------------------------------------
-- Test bench for the SetVolts vhdl module
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity tb_DivIntDelay is

end entity tb_DivIntDelay;

architecture behaviour of tb_DivIntDelay is

  ---------------------- DivIntDelay Block Component-------------------------
  component DivIntDelay is
    port (
    adc_clk : in std_logic;             -- adc input clock
    Int_in : in std_logic_vector(13 downto 0);

    Int_out : out std_logic_vector(13 downto 0)
      );
  end component DivIntDelay;

---------------------Signals for the DivIntDelay Block-----------------------
  -- input signals

  signal adc_clk : std_logic := '0';
  signal Int_in : std_logic_vector(13 downto 0) := (others => '0');

  signal   Int_out : std_logic_vector(13 downto 0) := (others => '0');

  constant adc_clk_period : time := 8 ns; 
  
  


  
begin  -- architecture behaviour
  -- Instantiating test unit
  
 
  
  your_instance_name : DivIntDelay
    PORT MAP (
    	-- Inputs
      adc_clk => adc_clk,
      Int_in => Int_in,

      -- Outputs      
      Int_out => Int_out
    );
  
  
  -- Clock process definitions
  adc_clk_process : process
  begin
    adc_clk <= '1';
    wait for adc_clk_period/2;
    adc_clk <= '0';
    wait for adc_clk_period/2;
  end process;

  -- Stimulus process
  stim_proc : process
  begin
      Int_in <= "00000000000001";
    wait for adc_clk_period*10;
      Int_in <= "00000000000011";
    wait for adc_clk_period*10;
      Int_in <= "00000000000111";
    wait for adc_clk_period*10;
end process;









end architecture behaviour;
