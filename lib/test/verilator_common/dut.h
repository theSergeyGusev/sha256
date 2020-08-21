#pragma once

#include <verilated_fst_c.h>

template <class MODULE> class DUT {
public:

	unsigned long	m_tickcount;
	MODULE	*m_core;
    VerilatedFstC* m_trace;

    DUT(void) : m_trace(nullptr) {
        //m_core = new to100Top;
        m_core = new MODULE;
        m_tickcount = 0l;
        m_core->clk = 0;
        m_core->rst = 1;
    }

	virtual ~DUT(void) {
		delete m_core;
		m_core = NULL;
	}

	virtual void reset(void) {
		m_core->rst = 1;
		this->tick();
		this->tick();
		this->tick();
		m_core->rst = 0;
	}

    void open_trace(const char *fstname, int level) {
        if (!m_trace) {
            Verilated::traceEverOn(true);
            m_trace = new VerilatedFstC;
            m_core->trace(m_trace, level);
            m_trace->open(fstname);
        }
    }

    void close_trace(void) {
        if (m_trace) {
            m_trace->close();
            delete m_trace;
            m_trace = nullptr;
        }
    }

    void tick_idle(int n=1) {
        for(int i=0; i<n; ++i) {
            tick();
        }
    }

    virtual void tick(void) {
		m_tickcount++;
		m_core->clk = 1;
		m_core->eval();
        if (m_trace) { m_trace->dump(m_tickcount); }
        
		m_tickcount++;
		m_core->clk = 0;
		m_core->eval();
        if (m_trace) { m_trace->dump(m_tickcount); m_trace->flush(); }
	}

	virtual bool done(void) { return (Verilated::gotFinish()); }
};
