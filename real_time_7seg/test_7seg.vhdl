library ieee;
use ieee.std_logic_1164.all;
library work;
use work.rt_utils.all; -- l'horloge temps réel
use work.segment.all;  -- l'afficheur à 7 segments
use work.fb_ghdl.all;

entity test_7seg is
  -- pas d'entrées-sorties
end test_7seg;

architecture test of test_7seg is
  -- contrôle de l'horloge temps réel
  signal clk_rt, stop_rt: std_ulogic:='0';
  -- les fils à afficher :
  signal segs : std_ulogic_vector(28 downto 0);
begin

 -- horloge temps réel pour ralentire la simulation
 horloge : entity work.rt_clk
  generic map(ms => 20) -- 25 Hz
  port map(clk => clk_rt, stop => stop_rt);

  rt: process
    variable i, j : integer;
  begin
    -- initialisation
    segs <= (0=>'1', others=>'0');

    -- fait clignoter les segments
    for i in 0 to 400 loop
      wait until rising_edge(clk_rt);

      -- LFSR à 29 bits, le polynôme provient de 
      -- http://www.physics.otago.ac.nz/px/research/
      --   electronics/papers/technical-reports/lfsr_table.pdf
      segs <= segs(27 downto 0) & (segs(28) xor segs(27) xor segs(26) xor segs(24));
      report "Cycle: " severity note;
    end loop;

    stop_rt <= '1'; -- arrête l'horloge pour terminer la simulation
    wait;
  end process;

  -- l'affichage :
  display1: entity work.seg7
    generic map(x=>50, y=>50)
    port map(seg => segs(6 downto 0));
  display2: entity work.seg7
    generic map(x=>170, y=>50)
    port map(seg => segs(13 downto 7));
  segment_point(275,85, 15, segs(14));
  segment_point(275,155,15, segs(14));
  display3: entity work.seg7
    generic map(x=>320, y=>50)
    port map(seg => segs(21 downto 15));
  display4: entity work.seg7
    generic map(x=>440, y=>50)
    port map(seg => segs(28 downto 22));
end test;