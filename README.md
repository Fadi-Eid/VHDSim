To be able to compile the 7segment demo do the following:

* build ghdl from source:
git clone https://github.com/ghdl/ghdl.git

* install llvm
sudo apt-get update
sudo apt-get install llvm

* install clang
sudo apt install clang

* get the path of the llvm-config and copy it
which llvm-config

* Go to the ghdl directory and configure llvm
cd ghdl
mkdir build
cd build
../configure --with-llvm-config=</path/to/llvm-config>

* build and install llvm
make
sudo make install
