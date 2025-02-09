library ieee;
use ieee.std_logic_1164.all;

library work;
use work.rt_utils.all;

entity clk_exemple is
  -- rien
end entity;

architecture exemple of clk_exemple is
  -- ne pas oublier d'initialiser clk
  -- sinon l'horloge ne peut pas osciller
  -- aussi, stop doit etre maintenu à '0'
  signal clk, stop: std_ulogic:='0';

begin
  -- instanciation de l'horloge :
  horloge : entity work.rt_clk
    generic map(ms => 500) -- 1Hz
    port map(clk => clk, stop => stop);

  process(clk) is
    variable compteur: integer := 0;
  begin
    if rising_edge(clk) then
      compteur := compteur + 1;
      if compteur >= 10 then
        stop <= '1';
      end if;
    end if;
  end process;

  observe_std_ulogic("clk",clk);

end exemple;