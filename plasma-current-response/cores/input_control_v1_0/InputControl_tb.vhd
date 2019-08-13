-------------------------------------------------------------------------------
-- Test bench for the SetVolts vhdl module
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity tb_InputControl is

end entity tb_InputControl;

architecture behaviour of tb_InputControl is

  ---------------------- Input_Control Block Component-------------------------
  component Input_Control is
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
  end component Input_Control;

---------------------Signals for the Input_Control Block-----------------------
  -- input signals

  signal adc_clk : std_logic := '0';
  signal switch : std_logic_vector(31 downto 0) := (others => '0');
  signal T_e_const : std_logic_vector(13 downto 0) := (others => '0');
  signal T_e_prof : std_logic_vector(13 downto 0) := (others => '1');
  signal  V_f_const : std_logic_vector(13 downto 0) := (others => '0');
  signal V_f_prof : std_logic_vector(13 downto 0) := (others => '1');
  signal  ISat_const : std_logic_vector(13 downto 0) := (others => '0');
  signal  ISat_prof : std_logic_vector(13 downto 0) := (others => '1');

  signal   T_e : std_logic_vector(13 downto 0) := (others => '0');
  signal   V_f : std_logic_vector(13 downto 0) := (others => '0');
  signal   Isat : std_logic_vector(13 downto 0) := (others => '0');

  constant adc_clk_period : time := 8 ns; 
  
  


  
begin  -- architecture behaviour
  -- Instantiating test unit
  
 
  
  your_instance_name : Input_Control
    PORT MAP (
    	-- Inputs
      adc_clk => adc_clk,
      switch => switch,
      T_e_const => T_e_const,
      T_e_prof => T_e_prof,
      V_f_const => V_f_const,
      V_f_prof => V_f_prof,
      ISat_prof => ISat_prof,
      ISat_const => ISat_const,
      -- Outputs      
      T_e => T_e,
      V_f => V_f,
      Isat => Isat
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
    switch <= "00000000000000000000000000000000" ; 
    wait for adc_clk_period*10;
    switch <= "00000000000000000000000000000001" ;
    wait for adc_clk_period*10;
    switch <= "00000000000000000000000000000000" ;

end process;









end architecture behaviour;
