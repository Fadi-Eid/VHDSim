library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.rt_utils.all;

entity clk_exemple is
  Generic(freq : integer := 10); -- Main real-time clock frequency (1000Hz max)
end entity;

architecture exemple of clk_exemple is
  signal rt_clk, stop: std_ulogic:='0';
begin

  -- real-time main clock:
  clock : entity work.rt_clk
    generic map(ms => (1000/(2*freq)))
    port map(clk => rt_clk, stop => stop);

  process(rt_clk) is
    variable counter: integer := 0;
  begin
    if rising_edge(rt_clk) then
      counter := counter + 1;
      if counter >= 10000000000 then -- run indefinetly
        stop <= '1';
      end if;
    end if;
  end process;

  observe_std_ulogic("clk",rt_clk);
end exemple;