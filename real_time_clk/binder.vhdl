library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library work;
use work.rt_utils.all;

entity binder is

end binder;

architecture binder of binder is
    signal clk : bit:='0';
begin

    -- circuit creating the real-time clock signal
    clock : entity work.rt_clk
    generic map(ms => 1) 
    port map(clk => clk);

    -- circuit using the clock signal
    user : entity work.user_circuit
    port map(clk => clk); 
    
end binder;