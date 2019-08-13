-------------------------------------------------------------------------------
-- Module to set 3 different voltages levels for inital MLP demonstration
-- Started on March 26th by Charlie Vincent
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity CurrentResponse is
  -- adjustment for non-divisible periods

  port (
    adc_clk            : in std_logic;  -- adc input clock
    T_electron_in      : in std_logic_vector(13 downto 0);
    I_sat              : in std_logic_vector(13 downto 0);
    V_floating         : in std_logic_vector(13 downto 0);
    Expo_result        : in std_logic_vector(13 downto 0);
    Expo_int_result    : in std_logic_vector(13 downto 0);
    Expo_result_tvalid : in std_logic;
    Bias_voltage       : in std_logic_vector(13 downto 0);
    Resistence         : in std_logic_vector(13 downto 0);


    V_LP                  : out std_logic_vector(13 downto 0);
    V_LP_tvalid           : out std_logic;
    T_electron_out        : out std_logic_vector(13 downto 0);
    T_electron_out_tvalid : out std_logic;
    V_curr                : out std_logic_vector(13 downto 0);
    Curr                  : out std_logic_vector(13 downto 0)
    );

end entity CurrentResponse;

architecture Behavioral of CurrentResponse is
  signal V_curr_mask        : integer := 0;
  signal V_curr_mask_hold_1 : integer := 0;
  signal V_curr_mask_hold_2 : integer := 0;

  signal Expo_int_result_pass_1 : std_logic_vector(13 downto 0) := (others => '0');
  signal Expo_int_result_pass_2 : std_logic_vector(13 downto 0) := (others => '0');
  signal Expo_int_result_pass_3 : std_logic_vector(13 downto 0) := (others => '0');

begin  -- architecture Behavioral
  T_electron_out_tvalid <= '1';
  V_LP_tvalid           <= '1';


  Pass_through : process(adc_clk)
    variable clock_timer : integer                       := 0;
    variable V_LP_mask   : std_logic_vector(13 downto 0) := (others => '0');
  begin
    if (rising_edge(adc_clk)) then
      -- Passing electron temerature through to the Div block 
      T_electron_out <= T_electron_in;

      -- Calculate the diffrence in voltages


      V_LP <= std_logic_vector(shift_right(signed(Bias_voltage), 2) - signed(V_floating));
      --V_LP_mask := std_logic_vector(signed(Bias_voltage) - signed(V_floating));
    -- V_LP <= V_LP_mask(13 downto 13) & "00" & V_LP_mask(12 downto 0);
    end if;
  end process;



  -- Take the input from Div and Expo blocks
  first_mltp : process(adc_clk)
  begin
    if (rising_edge(adc_clk)) then
      V_curr_mask_hold_1     <= to_integer(signed(Expo_result)) * 4;
      Expo_int_result_pass_1 <= Expo_int_result;
    end if;
  end process;

  -- Take the input from Div and Expo blocks
  second_mltp : process(adc_clk)
  begin
    if (rising_edge(adc_clk)) then
      V_curr_mask_hold_2     <= to_integer(signed(I_sat))* V_curr_mask_hold_1;
      Expo_int_result_pass_2 <= Expo_int_result_pass_1;
    end if;
  end process;

  third_mltp : process(adc_clk)
  begin
    if (rising_edge(adc_clk)) then
      V_curr_mask            <= to_integer(signed(Resistence))* V_curr_mask_hold_2;
      Expo_int_result_pass_3 <= Expo_int_result_pass_2;
    end if;
  end process;

  -- Take the input from Div and Expo blocks
  fourth_mltp : process(adc_clk)
  begin
    if (rising_edge(adc_clk)) then
      case to_integer(signed(Expo_int_result_pass_3)) is
        when 7      => V_curr <= std_logic_vector(shift_right(to_signed(V_curr_mask, 42), 1)(13 downto 0));
        when 6      => V_curr <= std_logic_vector(shift_right(to_signed(V_curr_mask, 42), 1)(13 downto 0));
        when 5      => V_curr <= std_logic_vector(shift_right(to_signed(V_curr_mask, 42), 1)(13 downto 0));
        when 4      => V_curr <= std_logic_vector(shift_right(to_signed(V_curr_mask, 42), 1)(13 downto 0));
        when 3      => V_curr <= std_logic_vector(shift_right(to_signed(V_curr_mask, 42), 6)(13 downto 0));
        when 2      => V_curr <= std_logic_vector(shift_right(to_signed(V_curr_mask, 42), 6)(13 downto 0));
        when 1      => V_curr <= std_logic_vector(shift_right(to_signed(V_curr_mask, 42), 6)(13 downto 0));
        when 0      => V_curr <= std_logic_vector(shift_right(to_signed(V_curr_mask, 42), 6)(13 downto 0));
        when others => V_curr <= std_logic_vector(shift_right(to_signed(V_curr_mask, 42), 13)(13 downto 0));
      end case;
    end if;
  end process;


--    Current_mltp : process(adc_clk)     
--    variable Curr_mask : integer := 0;
--    begin
--        if (rising_edge(adc_clk)) then
--            Curr_mask := to_integer(signed(I_sat))*(to_integer(signed(Expo_result)));
--            case to_integer(signed(Expo_int_result))  is
--                when 7 => Curr <=   std_logic_vector(shift_right(to_signed(Curr_mask,42), 1)(13 downto 0));
--                when 6 => Curr <=   std_logic_vector(shift_right(to_signed(Curr_mask,42), 2)(13 downto 0));
--                when 5 => Curr <=   std_logic_vector(shift_right(to_signed(Curr_mask,42), 4)(13 downto 0));
--                when 4 => Curr <=   std_logic_vector(shift_right(to_signed(Curr_mask,42), 5)(13 downto 0));
--                when 3 => Curr <=   std_logic_vector(shift_right(to_signed(Curr_mask,42), 7)(13 downto 0));
--                when 2 => Curr <=   std_logic_vector(shift_right(to_signed(Curr_mask,42), 8)(13 downto 0));
--                when 1 => Curr <=   std_logic_vector(shift_right(to_signed(Curr_mask,42), 10)(13 downto 0));
--                when 0 => Curr <=   std_logic_vector(shift_right(to_signed(Curr_mask,42), 12)(13 downto 0));
--                when others => Curr <=  std_logic_vector(shift_right(to_signed(Curr_mask,42), 13)(13 downto 0));
--            end case;
--        end if; 
--    end process;


end architecture Behavioral;
