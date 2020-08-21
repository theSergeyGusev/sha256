default: all

OPT = -O2
FLAGS = --cc
# Optimize
FLAGS += $(OPT) -x-assign 0 -sv --threads 4
# Warn abount lint issues; may not want this on less solid designs
FLAGS += --Wall --Wno-fatal
# Make waveforms
FLAGS += --trace-fst-thread --trace-max-array 2048 --trace-depth 99
#define
#FLAGS += +define+SIMULATION
#
#FLAGS += --trace-structs
#
FLAGS += --assert


export CXXFLAGS = -g -std=gnu++14
export LDFLAGS = -g -std=gnu++14

SRC = \
	../../../type.sv \
	../../../round/round.sv \
	../../../sha256/sha256.sv \
	../rtl/sha256_top.sv \

PREFIX = sha256Top
TOP    = sha256_top

clean:
	rm -rf ./obj_dir 
	rm -rf ./$(PREFIX)
	rm -rf ./$(PREFIX).xml
	rm -rf ./log/$(PREFIX).*

lint:
	verilator --lint-only $(FLAGS) $(SRC) --top-module $(TOP)

vl-build:
	$(info ******************** start vl-build ********************)

	verilator $(FLAGS) $(SRC) --prefix $(PREFIX) --top-module $(TOP)
	make -C ./obj_dir -j -f $(PREFIX).mk

	g++ -g -std=gnu++14 -I.  -MMD -I/usr/local/share/verilator/include -I/usr/local/share/verilator/include/vltstd -DVL_PRINTF=printf -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TRACE=1 -faligned-new -Wno-bool-operation -Wno-sign-compare -Wno-uninitialized -Wno-unused-but-set-variable -Wno-unused-parameter -Wno-unused-variable -Wno-shadow -DVL_THREADED -std=gnu++14 -c -o ./obj_dir/verilated.o /usr/local/share/verilator/include/verilated.cpp
	g++ -g -std=gnu++14 -I.  -MMD -I/usr/local/share/verilator/include -I/usr/local/share/verilator/include/vltstd -DVL_PRINTF=printf -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TRACE=1 -faligned-new -Wno-bool-operation -Wno-sign-compare -Wno-uninitialized -Wno-unused-but-set-variable -Wno-unused-parameter -Wno-unused-variable -Wno-shadow -DVL_THREADED -DVL_TRACE_THREADED -std=gnu++14 -c -o ./obj_dir/verilated_fst_c.o /usr/local/share/verilator/include/verilated_fst_c.cpp
	g++ -g -std=gnu++14 -I.  -MMD -I/usr/local/share/verilator/include -I/usr/local/share/verilator/include/vltstd -DVL_PRINTF=printf -DVM_COVERAGE=0 -DVM_SC=0 -DVM_TRACE=1 -faligned-new -Wno-bool-operation -Wno-sign-compare -Wno-uninitialized -Wno-unused-but-set-variable -Wno-unused-parameter -Wno-unused-variable -Wno-shadow -DVL_THREADED -DVL_TRACE_THREADED -std=gnu++14 -c -o ./obj_dir/verilated_threads.o /usr/local/share/verilator/include/verilated_threads.cpp

cpp-build:
	$(info ******************** start cpp-build ********************)
	#g++ $(OPT) -g3 -std=gnu++14 -I./../../../test/verilator_common -c -o ./obj_dir/common.o ./../../../test/verilator_common/common.cpp
	#g++ $(OPT) -g3 -std=gnu++14 -I./../../../test/verilator_common -c -o ./obj_dir/crc32.o ./../../../test/verilator_common/crc32.cpp
	g++ $(OPT) -g3 -std=gnu++14 -I./../../../test/verilator_common -c -o ./obj_dir/test.o test.cpp
	g++ $(OPT) -g3 -std=gnu++14 -I./../../../test/verilator_common -I. -I./obj_dir/ -I/usr/local/share/verilator/include -I/usr/local/share/verilator/include/vltstd -DVL_THREADED -std=gnu++14  -c -o ./obj_dir/sha256Test.o sha256Test.cpp

build:
	$(info ******************** start build ********************)
	g++ -g -std=gnu++14 $(OPT) -g3 ./obj_dir/test.o ./obj_dir/sha256Test.o ./obj_dir/verilated.o ./obj_dir/verilated_fst_c.o ./obj_dir/verilated_threads.o ./obj_dir/$(PREFIX)__ALL.a /usr/local/lib/libglog.a /usr/local/lib/libgtest.a /usr/local/lib/libgtest_main.a -lz -pthread -lpthread -latomic -o $(PREFIX) -lm -lstdc++ 

test:
	$(info ******************** start test ********************)
	GLOG_log_dir="./log/" GLOG_v=2 GLOG_log_prefix=0 ./$(PREFIX) --gtest_output="xml:./$(PREFIX).xml"

all: clean vl-build cpp-build build test
