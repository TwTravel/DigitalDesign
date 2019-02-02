/*********************************************************************************************************
Claire Chen and Mark Zhao
ECE 5760, Spring 2017

Description: All image processing functions
*********************************************************************************************************/

#ifndef VISION_H
#define VISION_H

#include <stdio.h>


#define RED_ID 0
#define GREEN_ID 1
#define ORANGE_ID 2
#define PURPLE_ID 3
#define YELLOW_ID 4

#define RED_COLOR      0xf801
#define GREEN_COLOR	   0x07e0
#define ORANGE_COLOR   0xfc01
#define PURPLE_COLOR   0xffe0
#define YELLOW_COLOR   0x803f

#define BACKGROUND_LABEL 0
#define RED_LABEL 1
#define GREEN_LABEL 2
#define ORANGE_LABEL 3
#define PURPLE_LABEL 4
#define YELLOW_LABEL 5


#define RED_THRESHOLD_R			4
#define RED_THRESHOLD_G			6
#define RED_THRESHOLD_B			5
#define GREEN_THRESHOLD_R		5
#define GREEN_THRESHOLD_G		10
#define GREEN_THRESHOLD_B		8
#define ORANGE_THRESHOLD_R		3
#define ORANGE_THRESHOLD_G		5
#define ORANGE_THRESHOLD_B		3
#define PURPLE_THRESHOLD_R		5
#define PURPLE_THRESHOLD_G		5
#define PURPLE_THRESHOLD_B		5
#define YELLOW_THRESHOLD_R		2
#define YELLOW_THRESHOLD_G		5
#define YELLOW_THRESHOLD_B		5

#define COLS 320
#define ROWS 240

//Struct for holding the thresholds of colors
typedef struct color_threshold{
	unsigned int low_R;
	unsigned int high_R;
	unsigned int low_G;
	unsigned int high_G;
	unsigned int low_B;
	unsigned int high_B;
} color_threshold_t;

//Struct for holding the coordinate of a pixel on the screen
typedef struct coordinate{
	unsigned int row;
	unsigned int col;
} coordinate_t;

// typedef struct spree{
// 	unsigned int row;
// 	unsigned int col;
// 	int component_id;
// 	unsigned int prev_row;
// 	unsigned int prev_col;
// 	int color_id;
// } spree_t;

unsigned int RGB_2_16(unsigned int red, unsigned int green, unsigned int blue);
void calibrate_color(color_threshold_t* threshold, unsigned int* vga_pixel_ptr, unsigned int* video_in_ptr, unsigned int* vga_char_ptr, unsigned int* pushbutton_addr,int color_ID);
void send_calibration(color_threshold_t* threshold, unsigned int* PIO_low, unsigned int* PIO_high);
void delay();
void erosion(unsigned int in_matrix[ROWS][COLS], unsigned int out_matrix[ROWS][COLS], int SE_delta);
void dilation(unsigned int in_matrix[ROWS][COLS], unsigned int out_matrix[ROWS][COLS], int SE_delta);
void dfs(unsigned int m[ROWS][COLS], unsigned int label[ROWS][COLS], unsigned int reference_color, int i, int j, unsigned int curr_label);
int count_components(unsigned int m[ROWS][COLS], unsigned int prev_frame_label[ROWS][COLS], 
	int prev_max_label, unsigned int* total_sprees, int* total_red, int* total_green, int* total_orange,
	int* total_purple, int* total_yellow, int* num_red, int* num_green,
	int* num_orange, int* num_purple, int* num_yellow, unsigned int* vga_pixel_ptr);
void get_centroid(unsigned int label[ROWS][COLS], coordinate_t* centroid, int component);
void mark_centroid(unsigned int* vga_pixel_ptr, coordinate_t* centroid);

#endif