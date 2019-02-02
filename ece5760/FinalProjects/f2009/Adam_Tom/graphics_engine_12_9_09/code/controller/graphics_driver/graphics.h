#ifndef GRAPHICS_H
#define GRAPHICS_H

#include <alt_types.h>

//Display specs.
#define GPU_DISP_WIDTH 480
#define GPU_DISP_HEIGHT 272

//Display layers.
#define GPU_LAYER_BG 1
#define GPU_LAYER_FG 0

//Initialize GPU.
void GPUInit(void);

//Clear screen.
void GPUClear(void);
void GPUClearLayer(alt_u8 layer);
void GPUClearRect(alt_u16 x, alt_u16 y,
                  alt_u16 width, alt_u16 height,
                  alt_u8 layer);

//Switch display layers.
void GPUSetLayer(alt_u8 layer);

//Set foreground layer visibility.
void GPUSetFGVisible(alt_u8 visible);

//Draw a single pixel using specified color.
inline void GPUDrawPixel(alt_u16 x, alt_u16 y,
                         alt_u8 r, alt_u8 g, alt_u8 b);

//Draw rectangle using specified color.
void GPUDrawRect(alt_u16 x, alt_u16 y,
                 alt_u16 width, alt_u16 height,
                 alt_u8 r, alt_u8 g, alt_u8 b);

//Draw line (Bresenham) using specified color.
void GPUDrawLine(alt_u16 x1, alt_u16 y1,
                 alt_u16 x2, alt_u16 y2,
                 alt_u8 r, alt_u8 g, alt_u8 b);

//Draw BMP image from memory location.
void GPUDrawBMP(alt_u16 x, alt_u16 y, void *image);
void GPUDrawBMPLP(alt_u16 x, alt_u16 y, void *image);

//String functions.
void GPULoadFont(alt_u8 charWidth, alt_u8 charHeight,
                 alt_u8 r, alt_u8 g, alt_u8 b,
                 void *image);
void GPUDrawString(alt_u16 x, alt_u16 y,
                   alt_u8 r, alt_u8 g, alt_u8 b,
                   const char *string);

#endif
