----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Andre Grigorian 202650168
-- 
-- Create Date: 10/18/2025 01:23:17 AM
-- Design Name: 
-- Module Name: counter_with_is_max_1cmp - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


-- counter_with_is_max_1cmp.vhd  (final-final)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_with_is_max_1cmp is
  generic (
    MAX  : natural := 6;  -- counts 0..MAX
    BITS : natural := 3
  );
  port (
    clk    : in  std_logic;
    count  : out std_logic_vector(BITS-1 downto 0);
    is_max : out std_logic
  );
end entity;

architecture rtl of counter_with_is_max_1cmp is
  signal i : natural range 0 to MAX := 0;

begin
  process (clk)
  begin
    if rising_edge(clk) then  -- per course slides:contentReference[oaicite:2]{index=2}
      -- SINGLE comparator on current value
      if i = MAX then
        is_max <= '1';
        i      <= 0;          -- wrap immediately after the MAX cycle
      else
        is_max <= '0';
        i      <= i + 1;
      end if;
    end if;
  end process;

  count <= std_logic_vector(to_unsigned(i, BITS));
end architecture;


