library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity user_circuit is
    port(
      clk : in bit;
      led : out bit
    );
end user_circuit;
  
architecture behavior of user_circuit is
begin
    process(clk)
    begin
        if clk='1' then
            report "clk = 1";
        else
            report "clk = 0";
        end if;
    end process;
end behavior;
  