#ifndef GPU_H
#define GPU_H

#include <alt_types.h>
#include "graphics.h"

//Instruction field widths.
#define GPU_INST_CMD_WIDTH 6
#define GPU_INST_PARAM_WIDTH 24

//Interface definition.
#define GPU_INTF_INST_VALID (1<<(GPU_INST_CMD_WIDTH+GPU_INST_PARAM_WIDTH))
#define GPU_INTF_DATA_MASK ((1<<(GPU_INST_CMD_WIDTH+GPU_INST_PARAM_WIDTH))-1)

//Display specs.
#define GPU_DISP_X_WIDTH 9 //log2(GPU_DISP_WIDTH)
#define GPU_DISP_Y_WIDTH 9 //log2(GPU_DISP_HEIGHT)

//Color bit-widths.
#define GPU_COLOR_R_WIDTH 5
#define GPU_COLOR_G_WIDTH 6
#define GPU_COLOR_B_WIDTH 5

//Command types.
#define GPU_CMD_SET_XY1     1
#define GPU_CMD_SET_XY2     2
#define GPU_CMD_CLEAR       3
#define GPU_CMD_DRAW_RECT   4
#define GPU_CMD_DRAW_LINE   5
#define GPU_CMD_DRAW_IMAGE  6
#define GPU_CMD_SET_LAYER   7
#define GPU_CMD_CLEAR_RECT  8
#define GPU_CMD_SHOW_FG     9
#define GPU_CMD_LOAD_FONT   10
#define GPU_CMD_DRAW_STRING 11

//Instruction parameter field positions.
//Note: Positions are from the LSB.
#define GPU_INST_POS_R (GPU_COLOR_G_WIDTH+GPU_COLOR_B_WIDTH)
#define GPU_INST_POS_G GPU_COLOR_B_WIDTH
#define GPU_INST_POS_B 0
#define GPU_INST_POS_Y GPU_DISP_X_WIDTH
#define GPU_INST_POS_X 0
#define GPU_INST_POS_LAYER 0
#define GPU_INST_POS_PRI 1
#define GPU_INST_POS_FG_EN 0

//Instruction macros.
#define GPU_INST(cmd,param) ((((alt_u32)cmd)<<GPU_INST_PARAM_WIDTH)|param)
#define GPU_INST_PARAM(param,shift) ((alt_u32)param)<<shift
#define GPU_INST_PARAM_XY(x,y) (GPU_INST_PARAM(y,GPU_INST_POS_Y) | \
                                GPU_INST_PARAM(x,GPU_INST_POS_X))
#define GPU_INST_PARAM_COLOR(r,g,b) (GPU_INST_PARAM((r>>(8-GPU_COLOR_R_WIDTH)),GPU_INST_POS_R) | \
                                     GPU_INST_PARAM((g>>(8-GPU_COLOR_G_WIDTH)),GPU_INST_POS_G) | \
                                     GPU_INST_PARAM((b>>(8-GPU_COLOR_B_WIDTH)),GPU_INST_POS_B))
#define GPU_INST_PARAM_LAYER(layer) GPU_INST_PARAM(layer,GPU_INST_POS_LAYER)
#define GPU_INST_PARAM_PRI(pri) GPU_INST_PARAM(pri,GPU_INST_POS_PRI)
#define GPU_INST_PARAM_FG_EN(visible) GPU_INST_PARAM(visible,GPU_INST_POS_FG_EN)

//Issue instruction to GPU.
inline void GPUIssueInstruction(alt_u32 inst);

//Set (X1,Y1) register.
inline void GPUSetXY1(alt_u16 x, alt_u16 y);

//Set (X2,Y2) register.
inline void GPUSetXY2(alt_u16 x, alt_u16 y);

//Send DMA transfer.
inline void GPUDMASend(void *data, alt_u32 length);

//DMA TX complete callback.
void GPUDMADone(void *handle);

#endif
