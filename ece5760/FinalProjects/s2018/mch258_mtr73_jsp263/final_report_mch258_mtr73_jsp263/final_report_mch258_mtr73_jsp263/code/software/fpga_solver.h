#ifndef __FPGA_SOLVER_H__
#define __FPGA_SOLVER_H__


#include "solver.h"


class FPGASolver : public Solver {
private:
    // Addresses on the bus
    volatile int16_t* sram_base_ptr;
    volatile uint32_t* fifo_ptr;
    volatile uint32_t* fifo_control_ptr;

protected:
    void queueTile(std::shared_ptr<TileHeader> header);

public:
    FPGASolver();

};


#endif
