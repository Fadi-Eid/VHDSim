library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity user_circuit is
    port(
      clk : in bit; -- this signal is driven by a virtual external clock (500Hz)
      
      led : out bit;
      btn : in bit
    );
end user_circuit;
  
architecture behavior of user_circuit is
begin
    process(clk)
    begin
        if clk'event and clk='1' then
            report "CLOCK ON";
        else
            report "CLOCK OFF";
        end if;
    end process;
end behavior;
  