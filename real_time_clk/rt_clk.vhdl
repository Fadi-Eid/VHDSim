library ieee;
use ieee.std_logic_1164.all;

package rt_utils is
  procedure observe_bit (name: string; s:bit);

  procedure realtime_init(ms : integer);
    attribute foreign of realtime_init :
      procedure is "VHPIDIRECT realtime_init";

  impure function realtime_delay return integer;
    attribute foreign of realtime_delay :
      function is "VHPIDIRECT realtime_delay";

  procedure realtime_exit;
    attribute foreign of realtime_exit :
      procedure is "VHPIDIRECT realtime_exit";
end rt_utils;

package body rt_utils is

  procedure observe_bit (name: string; s:bit) is
  begin
    report name & "=" & bit'image(s);
  end procedure;

-- Empty functions : C code implemented

  procedure realtime_init(ms : integer) is
  begin
    assert false report "VHPI" severity failure;
  end realtime_init;

  impure function realtime_delay return integer is
  begin
    assert false report "VHPI" severity failure;
  end realtime_delay;

  procedure realtime_exit is
  begin
    assert false report "VHPI" severity failure;
  end realtime_exit;

end rt_utils;

-----------------------------------------------------------
------------------    the clock    ------------------------
-----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library work;
use work.rt_utils.all;

entity rt_clk is
  generic(
    ms: integer:= 500 -- default : 1Hz
  );
  port(
    clk: buffer bit:='0';
    stop: in  bit:='0' -- set to '1' to stop the simulation
  );
end entity;

architecture simple of rt_clk is
begin
  process is
  begin
    realtime_init(ms);

    while stop='0' loop
      wait for ms * 1000 us;
      while realtime_delay=0 loop
        wait for 0 ns;  -- tourne un peu a vide
      end loop;
        clk <= not clk;
    end loop;

    realtime_exit;
    wait;
  end process;
end simple;