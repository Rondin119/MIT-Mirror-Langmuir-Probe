-------------------------------------------------------------------------------
-- Test bench for the SetVolts vhdl module
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity tb_FullTest is

end entity tb_FullTest;

architecture behaviour of tb_FullTest is
  ----------------------PCR Moduels Block Component 
component Current_response_test is
	port (
		clk : in STD_LOGIC := '0';
		Isat : in STD_LOGIC_vector(13 downto 0);
		Resistence : in STD_LOGIC_vector(13 downto 0);
		Temp : in STD_LOGIC_vector(13 downto 0);
		Vf : in STD_LOGIC_vector(13 downto 0);
		Bias : in STD_LOGIC_vector(13 downto 0);
        
        Bias_delay : out STD_LOGIC_VECTOR(13 downto 0);
		Current : out STD_LOGIC_vector(13 downto 0)
	);
end component Current_response_test;

signal  input_clk : std_logic := '0';
signal  Isat : STD_LOGIC_vector(13 downto 0) := (others => '0');
signal  Resistence : STD_LOGIC_vector(13 downto 0) := (others => '0');
signal  Temp : STD_LOGIC_vector(13 downto 0) := (others => '0');
signal  Vf : STD_LOGIC_vector(13 downto 0) := (others => '0');
signal  Bias : STD_LOGIC_vector(13 downto 0) := (others => '0');

signal  Bias_delay : STD_LOGIC_vector(13 downto 0) := (others => '0');
signal  Current : STD_LOGIC_vector(13 downto 0) := (others => '0');

constant adc_clk_period : time := 8 ns; 

begin  -- architecture behaviour
  
test_blks : Current_response_test
port map (
	clk => input_clk,
	Isat => Isat,
	Resistence => Resistence,
	Temp => Temp,
	Vf => Vf,
	Bias => Bias,
    
    Bias_delay => Bias_delay,
	Current => Current
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
	wait for adc_clk_period*100;
	Isat <= STD_LOGIC_vector(to_signed(-2,Isat'length));
	Resistence <= STD_LOGIC_vector(to_signed(50,Resistence'length));
	Temp <= STD_LOGIC_vector(to_signed(100,Temp'length));
	Vf <= STD_LOGIC_vector(to_signed(0,Vf'length));	
	
end process;

Temp_proc : process
begin
    Bias <= STD_LOGIC_vector(to_signed(0,Bias'length));
    wait for adc_clk_period*50;
    Bias <= STD_LOGIC_vector(to_signed(-600,Bias'length));
    wait for adc_clk_period*50;
    Bias <= STD_LOGIC_vector(to_signed(200,Bias'length));
    wait for adc_clk_period*50;
end process;
    

end architecture behaviour;
