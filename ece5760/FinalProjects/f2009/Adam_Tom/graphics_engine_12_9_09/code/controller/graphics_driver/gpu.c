#include <altera_avalon_pio_regs.h>
#include <sys/alt_irq.h>
#include <sys/alt_dma.h>
#include <string.h>
#include "system.h"
#include "gpu.h"
#include "graphics.h"

alt_dma_txchan dmaTX;
volatile alt_u8 dmaTransmitting;

void GPUInit(void)
{
    dmaTX=alt_dma_txchan_open(DMA_NAME);
    alt_dma_txchan_ioctl(dmaTX,ALT_DMA_SET_MODE_16,0);
    alt_dma_txchan_ioctl(dmaTX,ALT_DMA_TX_ONLY_ON,(void*)GPU_INTERFACE_BASE);
    dmaTransmitting=0;
}

void GPUClear(void)
{
    GPUClearLayer(GPU_LAYER_FG);
    GPUClearLayer(GPU_LAYER_BG);
}

void GPUClearLayer(alt_u8 layer)
{
    GPUIssueInstruction(GPU_INST(GPU_CMD_CLEAR,GPU_INST_PARAM_LAYER(layer)));
}

void GPUClearRect(alt_u16 x, alt_u16 y,
                  alt_u16 width, alt_u16 height,
                  alt_u8 layer)
{
    GPUSetXY1(x,y);
    GPUSetXY2(x+(width-1),y+(height-1));
    GPUIssueInstruction(GPU_INST(GPU_CMD_CLEAR_RECT,GPU_INST_PARAM_LAYER(layer)));
}

void GPUSetLayer(alt_u8 layer)
{
    GPUIssueInstruction(GPU_INST(GPU_CMD_SET_LAYER,GPU_INST_PARAM_LAYER(layer)));
}

void GPUSetFGVisible(alt_u8 visible)
{
    GPUIssueInstruction(GPU_INST(GPU_CMD_SHOW_FG,GPU_INST_PARAM_FG_EN(visible)));
}

inline void GPUDrawPixel(alt_u16 x, alt_u16 y,
                         alt_u8 r, alt_u8 g, alt_u8 b)
{
    GPUDrawRect(x,y,1,1,r,g,b);
}

void GPUDrawRect(alt_u16 x, alt_u16 y,
                 alt_u16 width, alt_u16 height,
                 alt_u8 r, alt_u8 g, alt_u8 b)
{
    GPUSetXY1(x,y);
    GPUSetXY2(x+(width-1),y+(height-1));
    GPUIssueInstruction(GPU_INST(GPU_CMD_DRAW_RECT,GPU_INST_PARAM_COLOR(r,g,b)));
}

void GPUDrawLine(alt_u16 x1, alt_u16 y1,
                 alt_u16 x2, alt_u16 y2,
                 alt_u8 r, alt_u8 g, alt_u8 b)
{
    GPUSetXY1(x1,y1);
    GPUSetXY2(x2,y2);
    GPUIssueInstruction(GPU_INST(GPU_CMD_DRAW_LINE,GPU_INST_PARAM_COLOR(r,g,b)));
}

void GPUDrawBMP(alt_u16 x, alt_u16 y, void *image)
{
    alt_u8 *data=(alt_u8*)image;
    alt_u32 fileSize;
    
    //Read file size (in Bytes) from BMP header.
    fileSize=(((alt_u32)data[5])<<24) |
             (((alt_u32)data[4])<<16) |
             (((alt_u32)data[3])<<8) |
             ((alt_u32)data[2]);
    
    //Draw image with display priority.
    GPUSetXY1(x,y);
    GPUDMASend(image,fileSize);
    GPUIssueInstruction(GPU_INST(GPU_CMD_DRAW_IMAGE,GPU_INST_PARAM_PRI(1)));
}

void GPUDrawBMPLP(alt_u16 x, alt_u16 y, void *image)
{
    alt_u8 *data=(alt_u8*)image;
    alt_u32 fileSize;
    
    //Read file size (in Bytes) from BMP header.
    fileSize=(((alt_u32)data[5])<<24) |
             (((alt_u32)data[4])<<16) |
             (((alt_u32)data[3])<<8) |
             ((alt_u32)data[2]);
    
    
    //Draw image without display priority.
    GPUSetXY1(x,y);
    GPUDMASend(image,fileSize);
    GPUIssueInstruction(GPU_INST(GPU_CMD_DRAW_IMAGE,GPU_INST_PARAM_PRI(0)));
}

void GPULoadFont(alt_u8 charWidth, alt_u8 charHeight,
                 alt_u8 r, alt_u8 g, alt_u8 b,
                 void *image)
{
    alt_u8 *data=(alt_u8*)image;
    alt_u32 fileSize;
    
    //Read file size (in Bytes) from BMP header.
    fileSize=(((alt_u32)data[5])<<24) |
             (((alt_u32)data[4])<<16) |
             (((alt_u32)data[3])<<8) |
             ((alt_u32)data[2]);
    
    GPUSetXY1(charWidth-1,charHeight-1);
    GPUDMASend(image,fileSize);
    GPUIssueInstruction(GPU_INST(GPU_CMD_LOAD_FONT,GPU_INST_PARAM_COLOR(r,g,b)));
}

void GPUDrawString(alt_u16 x, alt_u16 y,
                   alt_u8 r, alt_u8 g, alt_u8 b,
                   const char *string)
{
    GPUDMASend((void*)string,strlen(string)+1);
    GPUSetXY1(x,y);
    GPUIssueInstruction(GPU_INST(GPU_CMD_DRAW_STRING,GPU_INST_PARAM_COLOR(r,g,b)));
}

inline void GPUIssueInstruction(alt_u32 inst)
{
    //Wait until backpressure deasserted.
    while(IORD_ALTERA_AVALON_PIO_DATA(GPU_BP_IN_BASE));
    
    //Send instruction to GPU.
    IOWR_ALTERA_AVALON_PIO_DATA(GPU_DATA_OUT_BASE,GPU_INTF_INST_VALID|(inst&GPU_INTF_DATA_MASK));
    
    //Invalidate interface.
    IOWR_ALTERA_AVALON_PIO_DATA(GPU_DATA_OUT_BASE,0);
}

inline void GPUSetXY1(alt_u16 x, alt_u16 y)
{
    GPUIssueInstruction(GPU_INST(GPU_CMD_SET_XY1,GPU_INST_PARAM_XY(x,y)));
}

inline void GPUSetXY2(alt_u16 x, alt_u16 y)
{
    GPUIssueInstruction(GPU_INST(GPU_CMD_SET_XY2,GPU_INST_PARAM_XY(x,y)));
}

inline void GPUDMASend(void *data, alt_u32 length)
{
    //Note: 16b DMA transfer mode requires that the data
    //      length be 16b-aligned. Incrementing the length
    //      should be ok, as it won't cause additional word
    //      writes on the interface. It will only cause a
    //      garbage byte in the upper byte of the 16b word.
    if(length&0x01)length++;
    
    //Wait for previous transmission to complete,
    //then issue next send.
    while(dmaTransmitting);
    dmaTransmitting=1;
    alt_dma_txchan_send(dmaTX,
                        data,
                        length,
                        GPUDMADone,
                        0);
}

void GPUDMADone(void *handle)
{
    dmaTransmitting=0;
}
