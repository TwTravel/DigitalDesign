#include "fpga_solver.h"

#include "constants.h"
#include <iostream>

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/ipc.h>
#include <sys/shm.h>
#include <sys/mman.h>
#include <sys/time.h>
#include <math.h>
#include <cairo/cairo.h>
#include <string.h>
#include <time.h>
#include <stdint.h>

#include <vector>

// video display
#define SDRAM_BASE            0xC0000000
#define SDRAM_END             0xC3FFFFFF
#define SDRAM_SPAN              0x04000000
// characters
#define FPGA_CHAR_BASE        0xC9000000
#define FPGA_CHAR_END         0xC9001FFF
#define FPGA_CHAR_SPAN        0x00002000
/* Cyclone V FPGA devices */
#define HW_REGS_BASE          0xff200000
//#define HW_REGS_SPAN        0x00200000
#define HW_REGS_SPAN          0x00005000


#define NUM_SLOTS 30


FPGASolver::FPGASolver() {
    // Open /dev/mem
    int fd = open( "/dev/mem", O_RDWR | O_SYNC);
    if (fd == -1)     {
        printf("ERROR: could not open \"/dev/mem\"...\n");
        exit(1);
    }

    // mmap the bus
    void* h2f_base_address = mmap(NULL, SDRAM_SPAN + 0x1000,
                                  PROT_READ | PROT_WRITE, MAP_SHARED,
                                  fd, SDRAM_BASE);
    if (h2f_base_address == MAP_FAILED) {
        printf("ERROR: mmap3() failed...\n");
        close(fd);
        exit(1);
    }

    // Addresses on the bus
    sram_base_ptr = (int16_t*)(h2f_base_address);
    fifo_ptr = (uint32_t*) ((uint8_t*)(h2f_base_address) + SDRAM_SPAN);
    fifo_control_ptr = fifo_ptr + 1;

    for (int i = 0; i < NUM_SLOTS; i++) {
        freeListAppend(sram_base_ptr + (i * Constants::TILE_WIDTH * Constants::TILE_HEIGHT));
    }
}

void FPGASolver::queueTile(std::shared_ptr<TileHeader> header) {
    Solver::data& data = inflight[header];

    int num_limbs = (Constants::TILE_SIZE_BITS + header->z + 26) / 27 + 1;
    int loc_shift = (27 - 1) - ((Constants::TILE_SIZE_BITS - 1 + header->z) % 27);

    complex origin = header->getOrigin();
    std::vector<uint32_t> real_limbs = origin.get_real_limbs(27);
    std::vector<uint32_t> imag_limbs = origin.get_imag_limbs(27);

    //Pad limb vectors with zeros to ensure that they are the correct size
    while (real_limbs.size() < num_limbs) real_limbs.push_back(0);
    while (imag_limbs.size() < num_limbs) imag_limbs.push_back(0);

    // Generate data for the FIFO
    const uint32_t fifo_start = 0x01;
    const uint32_t fifo_end = 0x02;
    const uint32_t BITST_OUT_ADDR   = (0x00 << 29);
    const uint32_t BITST_NUM_LIMBS  = (0x01 << 29);
    const uint32_t BITST_C_REAL     = (0x02 << 29);
    const uint32_t BITST_C_IMAG     = (0x03 << 29);
    const uint32_t BITST_MAX_ITER   = (0x04 << 29);
    const uint32_t BITST_LOC_SHIFT  = (0x05 << 29);

    std::vector<uint32_t> fifo_data;

    uint32_t fpga_ptr = (uint32_t)((uint8_t*) data.get() - (uint8_t*) sram_base_ptr);
    fifo_data.push_back(BITST_OUT_ADDR  | fpga_ptr);
    fifo_data.push_back(BITST_OUT_ADDR  | fpga_ptr); //TODO fix this
    fifo_data.push_back(BITST_NUM_LIMBS | num_limbs);

    for (uint32_t limb : real_limbs) {
        fifo_data.push_back(BITST_C_REAL | limb);
    }

    for (uint32_t limb : imag_limbs) {
        fifo_data.push_back(BITST_C_IMAG | limb);
    }

    fifo_data.push_back(BITST_MAX_ITER | header->iter_lim);

    // This is the number of bits to offset the x/y value of the pixel,
    // as measured from the right hand edge of the last limb.
    fifo_data.push_back(BITST_LOC_SHIFT | loc_shift);

    /*
    printf("Generating tile. z: %d num_limbs: %d, loc_shift: %d\n", header->z, num_limbs, loc_shift);

    printf("real: ");
    for (uint32_t limb : real_limbs) {
        printf("%x ", limb);
    }
    printf("\n");

    printf("imag: ");
    for (uint32_t limb : imag_limbs) {
        printf("%x ", limb);
    }
    printf("\n");
    */

    // Write our data to the fifo
    *fifo_control_ptr = fifo_start;

    for (int i = 0; i < fifo_data.size(); i++) {
        if (i == fifo_data.size() - 1) {
            *fifo_control_ptr = fifo_end;
        }

        *fifo_ptr = fifo_data[i];
    }
}
