----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/18/2025 01:35:02 AM
-- Design Name: 
-- Module Name: testbench1 - Behavioral
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

-- tb_counter_with_is_max_1cmp.vhd
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.env.all;  -- finish

entity tb_counter_with_is_max_1cmp is
end entity;

architecture sim of tb_counter_with_is_max_1cmp is
  ---------------------------------------------------------------------------
  -- 125 MHz clock (8 ns period)
  ---------------------------------------------------------------------------
  signal clk : std_logic := '0';

  ---------------------------------------------------------------------------
  -- Component declaration (per your request)
  ---------------------------------------------------------------------------
  component counter_with_is_max_1cmp is
    generic (
      MAX  : natural := 6;
      BITS : natural := 3
    );
    port (
      clk    : in  std_logic;
      count  : out std_logic_vector(BITS-1 downto 0);
      is_max : out std_logic
    );
  end component;

  -- Signals for three instances
  signal count_def : std_logic_vector(2 downto 0);
  signal ismax_def : std_logic;

begin
  ---------------------------------------------------------------------------
  -- Clock generation
  ---------------------------------------------------------------------------
  clk <= not clk after 4 ns;  -- 8 ns total period

  ---------------------------------------------------------------------------
  -- DUT #0: FIRST TEST = DEFAULT generics (MAX=6, BITS=3)
  -- (Explicitly mapping to mirror the entity defaults.)
  ---------------------------------------------------------------------------
  U_DEF: counter_with_is_max_1cmp
    generic map (MAX => 6, BITS => 3)
    port map    (clk => clk, count => count_def, is_max => ismax_def);



  ---------------------------------------------------------------------------
  -- Self-checker for DEFAULT instance (MAX=6, BITS=3)
  ---------------------------------------------------------------------------
  chk_default: block
    constant MAXC : natural := 6;
    signal   c    : std_logic_vector(2 downto 0);
    signal   f    : std_logic;
  begin
    c <= count_def;  f <= ismax_def;

    process
      variable cnt    : integer := 0;
      variable cycles : integer := 0;
    begin
      wait until rising_edge(clk);  -- start aligned to a clock
      while cycles < 3*(MAXC+2) loop
        cnt := to_integer(unsigned(c));

        -- Flag must be high iff count == MAX
        assert ((f = '1' and cnt = MAXC) or
                (f = '0' and cnt /= MAXC))
          report "DEF: is_max mismatch at count=" & integer'image(cnt)
          severity error;

        -- If we are at MAX now, NEXT cycle must wrap to 0
        if cnt = MAXC then
          wait until rising_edge(clk);
          cnt := to_integer(unsigned(c));
          assert cnt = 0
            report "DEF: no wrap to 0 after MAX"
            severity error;
        else
          wait until rising_edge(clk);
        end if;

        cycles := cycles + 1;
      end loop;

      report "DEFAULT (MAX=6,BITS=3): PASS";
      wait;
    end process;
  end block;


end architecture;



