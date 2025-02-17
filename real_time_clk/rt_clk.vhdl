library ieee;
use ieee.std_logic_1164.all;

package rt_utils is
    procedure realtime_init(ms : integer);
        attribute foreign of realtime_init :
            procedure is "VHPIDIRECT realtime_init";

    impure function realtime_delay return integer;
        attribute foreign of realtime_delay :
            function is "VHPIDIRECT realtime_delay";
end rt_utils;


package body rt_utils is
-- Empty functions : C code implemented
    procedure realtime_init(ms : integer) is
    begin
        assert false report "VHPI" severity failure;
    end realtime_init;

    impure function realtime_delay return integer is
    begin
        assert false report "VHPI" severity failure;
    end realtime_delay;
end rt_utils;

-----------------------------------------------------------
------------------    the clock    ------------------------
-----------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
library work;
use work.rt_utils.all;

entity rt_clk is
    generic(ms: integer:= 1); -- default : 500Hz
    port(
        clk: inout bit:='0'
    );
end entity;

architecture behavior of rt_clk is
begin
    process is
    begin
        realtime_init(ms); -- initialize the delay (half period)

        while TRUE loop
            wait for ms * 1000 us; -- for correct simulation time (no real-time effect)

            while realtime_delay=0 loop
                wait for 0 ns;  -- empty loop
            end loop;

            clk <= not clk;
        end loop;
    end process;
end behavior;