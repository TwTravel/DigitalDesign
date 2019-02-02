/*********************************************************************************************************
Claire Chen and Mark Zhao
ECE 5760, Spring 2017

Attribution: Bruce Land

Description: All functions related to VGA graphics
*********************************************************************************************************/

#ifndef GRAPHICS_H
#define GRAPHICS_H

// pixel macro

#define SWAP(X,Y) do{int temp=X; X=Y; Y=temp;}while(0) 
#define NOP10() asm("nop;nop;nop;nop;nop;nop;nop;nop;nop;nop")


/* function prototypes */
void VGA_text(int x, int y, char * text_ptr, unsigned int* vga_char_ptr);
void VGA_text_clear(unsigned int* vga_char_ptr);
void VGA_box(int x1, int y1, int x2, int y2, short pixel_color, unsigned int* vga_pixel_ptr);
void VGA_line(int x1, int y1, int x2, int y2, short c, unsigned int* vga_pixel_ptr) ;
void VGA_disc(int x, int y, int r, short pixel_color, unsigned int* vga_pixel_ptr);
int  VGA_read_pixel(int x, int y, unsigned int* vga_pixel_ptr) ;
int  VGA_read_pixel_16(int x, int y, unsigned int* vga_pixel_ptr);
int  video_in_read_pixel(int x, int y, unsigned int * video_in_ptr);
void VGA_pixel(int x, int y, int color, unsigned int* vga_pixel_ptr);
void draw_delay(void) ;
void VGA_setup_screen(unsigned int* vga_pixel_ptr, unsigned int* vga_char_ptr);


#endif