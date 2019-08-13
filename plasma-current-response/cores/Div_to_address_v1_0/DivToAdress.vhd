-------------------------------------------------------------------------------
-- Module to set 3 different voltages levels for inital MLP demonstration
-- Started on March 26th by Charlie Vincent
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DivToAdrress is
    -- adjustment for non-divisible periods

  port (
    adc_clk : in std_logic;             -- adc input clock
    divider_tvalid : in std_logic;
    divider_tdata : in std_logic_vector(24 downto 0);

    BRAM_addr       : out std_logic_vector(13 downto 0);  -- BRAM address out
    Address_gen_tvalid : out std_logic;
    divider_int_res : out std_logic_vector(13 downto 0)
    );

end entity DivToAdrress;

architecture Behavioral of DivToAdrress is
  signal divider_int_out : signed(13 downto 0) := (others => '0');
  signal divider_frac_out : signed(9 downto 0) := (others => '0');
begin  -- architecture Behavioral

--purpose: process to set the BRAM address for the look up table retrival
--Type   : combination
--inputs : adc_clk, divider_tdata
--outputs: BRAM_addr, waitBRAM
BRAM_proc : process (adc_clk) is
    variable divider_int : signed(13 downto 0) := (others => '0');
    variable divider_frac : signed(9 downto 0) := (others => '0');
    variable addr_mask   : integer         := 0;
  begin  -- process BRAM_proc
    if rising_edge(adc_clk) then
      if divider_tvalid = '1' then
  -- Extracting the integer part and the fractional part returned by the
  -- divider core to use in the bram address mapping
  divider_frac := signed(divider_tdata(9 downto 0));
  divider_int := signed(divider_tdata(23 downto 10));
  divider_int_res <= divider_tdata(23 downto 10);
--int_store   <= to_integer(divider_int);
--rem_store   <= to_integer(divider_frac);
  if divider_int = to_signed(-8, 14) then
    addr_mask := 0;
  elsif divider_int = to_signed(-7, 14) then
    addr_mask := 1024 + (to_integer(divider_frac)*2);
  elsif divider_int = to_signed(-6, 14) then
    addr_mask := 2048 + (to_integer(divider_frac)*2);
  elsif divider_int = to_signed(-5, 14) then
    addr_mask := 3072 + (to_integer(divider_frac)*2);
  elsif divider_int = to_signed(-4, 14) then
    addr_mask := 4096 + (to_integer(divider_frac)*2);
  elsif divider_int = to_signed(-3, 14) then
    addr_mask := 5120 + (to_integer(divider_frac)*2);
  elsif divider_int = to_signed(-2, 14) then
    addr_mask := 6144 + (to_integer(divider_frac)*2);
  elsif divider_int = to_signed(-1, 14) then
    addr_mask := 7168 + (to_integer(divider_frac)*2);
  elsif divider_int = to_signed(0, 14) then
    addr_mask := 8192 + (to_integer(divider_frac)*2);
  elsif divider_int = to_signed(1, 14) then
    addr_mask := 9216 + (to_integer(divider_frac)*2);
  elsif divider_int = to_signed(2, 14) then
    addr_mask := 10240 + (to_integer(divider_frac)*2);
  elsif divider_int = to_signed(3, 14) then
    addr_mask := 11264 + (to_integer(divider_frac)*2);
  elsif divider_int = to_signed(4, 14) then
    addr_mask := 12288 + (to_integer(divider_frac)*2);
  elsif divider_int = to_signed(5, 14) then
    addr_mask := 13312 + (to_integer(divider_frac)*2);
  elsif divider_int = to_signed(6, 14) then
    addr_mask := 14336 + (to_integer(divider_frac)*2);
  elsif divider_int = to_signed(7, 14) then
    addr_mask := 15360 + (to_integer(divider_frac)*2);
  else
    if divider_int < to_signed(-8, 14) then
      addr_mask := 0;
    elsif divider_int >= to_signed(8, 14) then
      addr_mask := 16383;
    end if;
  end if;
  --addr_mask_store <= addr_mask;
  divider_int_out <= divider_int;
  divider_frac_out <= divider_frac;
  BRAM_addr <= std_logic_vector(to_unsigned(addr_mask, 14));
  Address_gen_tvalid <= '1';
      else
   Address_gen_tvalid <= '0';
      end if;
    end if;
  end process BRAM_proc;


end architecture Behavioral;
