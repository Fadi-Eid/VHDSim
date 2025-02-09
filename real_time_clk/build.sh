gcc -c rt_functions.c &&
ghdl -a rt_clk.vhdl user_circuit.vhdl binder.vhdl &&
ghdl -e -Wl,rt_functions.o binder &&
rm work-obj93.cf *.o