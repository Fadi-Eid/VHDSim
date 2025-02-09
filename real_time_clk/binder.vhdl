library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.rt_utils.all;

entity binder is
end binder;

architecture binder of binder is
  signal clk, stop: bit:='0';
begin

  -- real-time main clock:
  clock : entity work.rt_clk
    generic map(ms => 1) -- half period in ms
    port map(clk => clk, stop => stop);

  user : entity work.user_circuit
    port map(clk => clk); -- Direct connection
end binder;