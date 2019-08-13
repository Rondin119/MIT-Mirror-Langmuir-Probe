-------------------------------------------------------------------------------
-- Test bench for the SetVolts vhdl module
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity tb_DivToAdress is

end entity tb_DivToAdress;

architecture behaviour of tb_DivToAdress is

  -----------------------DivTo_adress Block Component-------------------------
  component DivTo_adress is
    port (
    adc_clk : in std_logic;             -- adc input clock
    divider_tvalid : in std_logic;
    divider_tdata : in std_logic_vector(31 downto 0);

    BRAM_addr       : out std_logic_vector(13 downto 0);  -- BRAM address out
    Address_gen_tvalid : out std_logic
      );
  end component DivTo_adress;

---------------------Signals for the DivTo_adress Block-----------------------
  -- input signals
  signal adc_clk : std_logic           := '0';
  signal divider_tvalid : std_logic := '0';
  signal divider_tdata : std_logic_vector(31 downto 0) := (others => '0');

  signal BRAM_addr : std_logic_vector(13 downto 0) := (others => '0');
  signal Address_gen_tvalid : std_logic := '0';

  constant adc_clk_period : time := 8 ns; 
  
  


  
begin  -- architecture behaviour
  -- Instantiating test unit
  
 
  
  your_instance_name : DivTo_adress
    PORT MAP (
    	-- Inputs
      adc_clk => adc_clk,
      divider_tvalid => divider_tvalid,
      divider_tdata => divider_tdata,

		-- Outputs
      BRAM_addr => BRAM_addr,
      Address_gen_tvalid => Address_gen_tvalid
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
    wait for adc_clk_period*10;
    divider_tvalid <= '0';
    divider_tdata <= "00000000000000000000000000000000";
    wait for adc_clk_period*10;
    divider_tvalid <= '1';
    wait for adc_clk_period*10;
    divider_tvalid <= '0';
    divider_tdata <= "00000000000000000000000000001000"; 
    wait for adc_clk_period*10;
    divider_tvalid <= '1';
    wait for adc_clk_period*10;
    divider_tvalid <= '0';
    divider_tdata <= "00000000000000000010000000000000";
    wait for adc_clk_period*10;
    divider_tvalid <= '1';
    wait for adc_clk_period*10;
    divider_tvalid <= '0';
    divider_tdata <= "00000000010000000000000000000000";
    wait for adc_clk_period*10;
    divider_tvalid <= '1';
    wait for adc_clk_period*10;
    divider_tvalid <= '0';
    divider_tdata <= "01000000000000000000000000000000";
    

end process;









end architecture behaviour;
