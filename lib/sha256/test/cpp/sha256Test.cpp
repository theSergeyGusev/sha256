#include <string>
#include <verilated.h>
#include <iostream>
#include <iomanip>
#include <glog/logging.h>

#include "dut.h"
#include "sha256Top.h"

int sha256Tets(int trace_enable)
{
    DUT<sha256Top> dut;
    if (trace_enable) {
        dut.open_trace ("test.fst",99);
    }

    dut.reset();	   //reset to100
    dut.tick_idle(10); // wait 10 tick

    int count = 0;

    dut.m_core->in[0]  = 0x21222324;
    dut.m_core->in[1]  = 0x25262728;
    dut.m_core->in[2]  = 0x292a2b2c;
    dut.m_core->in[3]  = 0x2d2e2f30;
    dut.m_core->in[4]  = 0x31323334;
    dut.m_core->in[5]  = 0x35363738;
    dut.m_core->in[6]  = 0x393a3b3c;
    dut.m_core->in[7]  = 0x3d3e3f40;
    dut.m_core->in[8]  = 0x41424344;
    dut.m_core->in[9]  = 0x45464748;
    dut.m_core->in[10] = 0x494a4b4c;
    dut.m_core->in[11] = 0x4d4e4f50;
    dut.m_core->in[12] = 0x51525354;
    dut.m_core->in[13] = 0x55565780;
    dut.m_core->in[14] = 0x00000000;
    dut.m_core->in[15] = 0x000001b8;

    while(count!=10) {

        for (int i=0;i<64;i=i+1){
            VLOG(2) << "round " << i <<
                " w_in "  << std::setfill('0') << std::setw(8)  << std::right << std::hex << dut.m_core->dbg_w[i] << 
                " k_in "  << std::setfill('0') << std::setw(8)  << std::right << std::hex << dut.m_core->dbg_k[i] <<
                " a_in "  << std::setfill('0') << std::setw(8)  << std::right << std::hex << dut.m_core->dbg_abcdefgh_in [i][0] << 
                " b_in "  << std::setfill('0') << std::setw(8)  << std::right << std::hex << dut.m_core->dbg_abcdefgh_in [i][1] << 
                " c_in "  << std::setfill('0') << std::setw(8)  << std::right << std::hex << dut.m_core->dbg_abcdefgh_in [i][2] << 
                " d_in "  << std::setfill('0') << std::setw(8)  << std::right << std::hex << dut.m_core->dbg_abcdefgh_in [i][3] << 
                " e_in "  << std::setfill('0') << std::setw(8)  << std::right << std::hex << dut.m_core->dbg_abcdefgh_in [i][4] << 
                " f_in "  << std::setfill('0') << std::setw(8)  << std::right << std::hex << dut.m_core->dbg_abcdefgh_in [i][5] << 
                " g_in "  << std::setfill('0') << std::setw(8)  << std::right << std::hex << dut.m_core->dbg_abcdefgh_in [i][6] << 
                " h_in "  << std::setfill('0') << std::setw(8)  << std::right << std::hex << dut.m_core->dbg_abcdefgh_in [i][7] << 
                " a_out " << std::setfill('0') << std::setw(8)  << std::right << std::hex << dut.m_core->dbg_abcdefgh_out[i][0] << 
                " b_out " << std::setfill('0') << std::setw(8)  << std::right << std::hex << dut.m_core->dbg_abcdefgh_out[i][1] << 
                " c_out " << std::setfill('0') << std::setw(8)  << std::right << std::hex << dut.m_core->dbg_abcdefgh_out[i][2] << 
                " d_out " << std::setfill('0') << std::setw(8)  << std::right << std::hex << dut.m_core->dbg_abcdefgh_out[i][3] << 
                " e_out " << std::setfill('0') << std::setw(8)  << std::right << std::hex << dut.m_core->dbg_abcdefgh_out[i][4] << 
                " f_out " << std::setfill('0') << std::setw(8)  << std::right << std::hex << dut.m_core->dbg_abcdefgh_out[i][5] << 
                " g_out " << std::setfill('0') << std::setw(8)  << std::right << std::hex << dut.m_core->dbg_abcdefgh_out[i][6] << 
                " h_out " << std::setfill('0') << std::setw(8)  << std::right << std::hex << dut.m_core->dbg_abcdefgh_out[i][7] ; 
        }
        VLOG(2) << 
            "result_out0 "   << std::setfill('0') << std::setw(8)  << std::right << std::hex << dut.m_core->out[0] << 
            " result_out1 "  << std::setfill('0') << std::setw(8)  << std::right << std::hex << dut.m_core->out[1] << 
            " result_out2 "  << std::setfill('0') << std::setw(8)  << std::right << std::hex << dut.m_core->out[2] << 
            " result_out3 "  << std::setfill('0') << std::setw(8)  << std::right << std::hex << dut.m_core->out[3] << 
            " result_out4 "  << std::setfill('0') << std::setw(8)  << std::right << std::hex << dut.m_core->out[4] << 
            " result_out5 "  << std::setfill('0') << std::setw(8)  << std::right << std::hex << dut.m_core->out[5] << 
            " result_out6 "  << std::setfill('0') << std::setw(8)  << std::right << std::hex << dut.m_core->out[6] << 
            " result_out7 "  << std::setfill('0') << std::setw(8)  << std::right << std::hex << dut.m_core->out[7] ; 

        dut.tick();
        count = count + 1;

    }

    return EXIT_SUCCESS;
}
