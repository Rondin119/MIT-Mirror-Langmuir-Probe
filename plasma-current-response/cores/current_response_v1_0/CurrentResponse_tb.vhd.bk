-------------------------------------------------------------------------------
-- Test bench for the SetVolts vhdl module
-------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity tb_CurrentResponse is

end entity tb_CurrentResponse;

architecture behaviour of tb_CurrentResponse is

--------------------Block Ram Block Component---------------------------
COMPONENT blk_mem_gen_0
  PORT (
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(13 DOWNTO 0)
  );
END COMPONENT;

--------------------Divider Block Component---------------------------------
COMPONENT div_gen_0
  PORT (
    aclk : IN STD_LOGIC;
    s_axis_divisor_tvalid : IN STD_LOGIC;
    s_axis_divisor_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    s_axis_dividend_tvalid : IN STD_LOGIC;
    s_axis_dividend_tuser : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    s_axis_dividend_tdata : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    m_axis_dout_tvalid : OUT STD_LOGIC;
    m_axis_dout_tuser : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
    m_axis_dout_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
  );
END COMPONENT;

  -----------------------CurrentResponse Block Component-------------------------
  component CurrentResponse is
    port (
    adc_clk : in std_logic;             -- adc input clock
    T_electron_in : in signed(13 downto 0); 
    I_sat : in signed(13 downto 0);
    V_floating : in signed(13 downto 0);
    Expo_result : in signed(13 downto 0);
    Bias_voltage : in signed(13 downto 0);
    Resistence : in signed(13 downto 0);

    Expo_adress : out signed(13 downto 0);
    V_LP : out signed(13 downto 0);
    T_electron_out : out signed(13 downto 0);
    V_curr : out signed(13 downto 0)
      );
  end component CurrentResponse;
---------------------Signals for the CurrentResponse Block-----------------------
  -- input signals
  signal adc_clk : std_logic           := '0';
  signal T_electron_in   : signed(13 downto 0) := (others => '0');
  signal I_sat : signed(13 downto 0) := (others => '0');
  signal V_floating : signed(13 downto 0) := (others => '0');
  signal Expo_result : signed(13 downto 0) := (others => '0');
  signal Bias_voltage : signed(13 downto 0) := (others => '0');
  signal Resistence : signed(13 downto 0) := (others => '0');

  -- output signals
  signal Expo_adress : signed(13 downto 0) := (others => '0');
  signal V_LP : signed(13 downto 0) := (others => '0');
  signal T_electron_out : signed(13 downto 0) := (others => '0');
  signal V_curr : signed(13 downto 0) := (others => '0');

  constant adc_clk_period : time := 8 ns; 
  
  
  --------------- signals for the div_gen_0 block-----------------------
  signal s_axis_divisor_tvalid : std_logic := '0';
  signal s_axis_dividend_tvalid : std_logic := '0';  
  signal s_axis_dividend_tuser : std_logic_vector(0 downto 0) := (others => '0');
  signal T_electron_out_std : std_logic_vector(15 downto 0) := (others => '0'); 
  signal V_LP_std : std_logic_vector(15 downto 0) := (others => '0');
  signal m_axis_dout_tvalid : std_logic := '0';
  signal m_axis_dout_tuser : std_logic_vector(0 downto 0) := (others => '0'); 
  signal Div_result : std_logic_vector(31 downto 0) := (others => '0'); 
  
  
  ------- signals for the Memory access Block --------------------
  signal wea : std_logic_vector(0 downto 0) := (others => '0');
  signal addra : STD_LOGIC_VECTOR(13 DOWNTO 0) := (others => '0');
  signal dina : STD_LOGIC_VECTOR(13 DOWNTO 0) := (others => '0');
  signal douta : STD_LOGIC_VECTOR(13 DOWNTO 0) := (others => '0'); 
  

  
begin  -- architecture behaviour
  -- Instantiating test unit
  
  --Convert the outputs from the CurrentResponse Block to STDlogic vectors for use in the Divider Block
  T_electron_out_std <= "00" & std_logic_vector(T_electron_out);
  V_LP_std <= "00" & std_logic_vector(V_LP);
  
  
  your_instance_name : div_gen_0
    PORT MAP (
      aclk => adc_clk,
      s_axis_divisor_tvalid => s_axis_divisor_tvalid,
      s_axis_divisor_tdata => T_electron_out_std,
      s_axis_dividend_tvalid => s_axis_dividend_tvalid,
      s_axis_dividend_tuser => s_axis_dividend_tuser,
      s_axis_dividend_tdata => V_LP_std,
      m_axis_dout_tvalid => m_axis_dout_tvalid,
      m_axis_dout_tuser => m_axis_dout_tuser,
      m_axis_dout_tdata => Div_result
    );
  

  
  
  
  
  
  
  
  
  uut : CurrentResponse
    port map (
      -- Inputs
      adc_clk => adc_clk,
      T_electron_in => T_electron_in,
      I_sat => I_sat,
      V_floating => V_floating,
      Expo_result => Expo_result,
      Bias_voltage => Bias_voltage,
      Resistence => Resistence,

      -- Outputs
      Expo_adress => Expo_adress,
      V_LP => V_LP,
      T_electron_out => T_electron_out,
      V_curr => V_curr
      );
      
      your_instance_name_1   : blk_mem_gen_0
        PORT MAP (
          clka => adc_clk,
          wea => wea,
          addra => addra,
          dina => dina,
          douta => douta
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
    T_electron_in <= to_signed(10, T_electron_in'length);
    I_sat <= to_signed(15, I_sat'length);
    V_floating <= to_signed(-30,V_floating'length);
    Expo_result <= to_signed(15, Expo_result'length);
    Bias_voltage <= to_signed(15, Bias_voltage'length); 
    Resistence <= to_signed(50, Resistence'length); 
    
         
    wait for adc_clk_period*100;
   T_electron_in <= to_signed(20, T_electron_in'length);
    Bias_voltage <= to_signed(30, Bias_voltage'length); 
    Expo_result <= to_signed(30, Expo_result'length);
    
    
    wait for adc_clk_period*90;
       T_electron_in <= to_signed(22, T_electron_in'length);
    Expo_result <= to_signed(-10, Expo_result'length);
    Bias_voltage <= to_signed(-10, Bias_voltage'length); 
  end process;

end architecture behaviour;
