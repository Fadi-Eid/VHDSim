library ieee;
use ieee.std_logic_1164.all;

library work;
use work.rt_utils.all;

entity clk_exemple is
  -- empty
end entity;

architecture exemple of clk_exemple is
  -- Initialize the clock to '0' so it can oscillate
  signal clk, stop: std_ulogic:='0';

begin
  -- instantiate the clock package :
  horloge : entity work.rt_clk
    generic map(ms => 500) -- 1Hz
    port map(clk => clk, stop => stop);

  process(clk) is
    variable counter: integer := 0;
  begin
    if rising_edge(clk) then
      counter := counter + 1;
      if counter >= 10 then
        stop <= '1';
      end if;
    end if;
  end process;

  observe_std_ulogic("clk",clk);

end exemple;