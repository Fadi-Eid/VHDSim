library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.rt_utils.all;

entity clk_exemple is
end entity;

architecture exemple of clk_exemple is
  signal clk, stop: bit:='0';
begin

  -- real-time main clock:
  clock : entity work.rt_clk
    generic map(ms => 1) -- half period in ms
    port map(clk => clk, stop => stop);

  observe_bit("clk",clk);
end exemple;