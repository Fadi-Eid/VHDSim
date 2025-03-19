## Brief:
VHDSim is a real-time VHDL simulator where you can write your test code and monitor the output in real-time with a configurable 500Hz real-time clock.

To be able to compile and use the demo do the following:

* build ghdl from source: `git clone https://github.com/ghdl/ghdl.git`

* install llvm: `sudo apt-get update && sudo apt-get install llvm`

* install clang: `sudo apt install clang`

* get the path of the llvm-config and copy it: `which llvm-config`

* install gnat: `sudo apt-get install gnat`

* Go to the ghdl directory and configure llvm
  * `cd ghdl`
  * `mkdir build`
  * `cd build`
  * `../configure --with-llvm-config=</path/to/llvm-config>`

* build and install ghdl:
  * `make`
  * `sudo make install`
 
 * Write your code in the user_circuit.vhdl file, you can make use of `clk : in bit;` but do not change it.
 * Build you GHDL code: `bash build.sh`
 * Run the generated executable.
