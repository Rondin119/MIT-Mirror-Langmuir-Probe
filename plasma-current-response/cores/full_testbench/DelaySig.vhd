-------------------------------------------------------------------------------
-- Title      : Dealy signal
-- Project    : 
-------------------------------------------------------------------------------
-- File       : DelaySig.vhd
-- Author     : Vincent  <charlesv@cmodws122.psfc.mit.edu>
-- Company    : 
-- Created    : 2018-05-31
-- Last update: 2018-05-31
-- Platform   : 
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: Module to delay a signal by a pre-defined number of clock cycles
-------------------------------------------------------------------------------
-- Copyright (c) 2018 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author  Description
-- 2018-05-31  1.0      charlesv        Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity DelaySig is

  generic (
    Cycles : integer := 34
    );

  port (
    adc_clk : in  std_logic;
    input   : in  std_logic_vector(13 downto 0);
    output  : out std_logic_vector(13 downto 0)
    );

end entity DelaySig;

architecture Behavioural of DelaySig is

  type sig_Memory is array(0 to Cycles) of std_logic_vector(13 downto 0);
  signal input_holder : sig_Memory := (others => (others => '0'));

begin  -- architecture Behavioural

  -- purpose: Process to store and delay the input
  -- type   : sequential
  -- inputs : adc_clk, input
  -- outputs: input_holder
  delay_proc : process (adc_clk) is
  begin  -- process delay_proc
    if rising_edge(adc_clk) then        -- rising clock edge
      input_holder(0) <= input;
      for index in 0 to Cycles - 1 loop
        input_holder(index + 1) <= input_holder(index);
      end loop;  -- index
    end if;
  end process delay_proc;

  -- purpose: Process to set the module output
  -- type   : sequential
  -- inputs : adc_clk, input_holder
  -- outputs: output
  out_proc : process (adc_clk) is
  begin  -- process out_proc
    if rising_edge(adc_clk) then        -- rising clock edge
      output <= input_holder(Cycles);
    end if;
  end process out_proc;

end architecture Behavioural;
