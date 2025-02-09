gcc -c rt_functions.c &&
ghdl -a rt_clk.vhdl clk_exemple.vhdl &&
ghdl -e -Wl,rt_functions.o clk_exemple &&
rm work-obj93.cf *.o