/*********************************************************************************************************
Claire Chen and Mark Zhao
ECE 5760, Spring 2017

Description: All image processing functions
*********************************************************************************************************/

#include "vision.h"
#include <math.h>

/*
* Given individual red, green, and blue values, convert to one 16-bit number
*/
unsigned int RGB_2_16(unsigned int red, unsigned int green, unsigned int blue){
	return ((red & 0x1f) << 11) | ((green & 0x3f) << 5) | (blue & 0x1f);
}

/*
* Prompt user to place a skittle at the drawn location. Block until user presses "enter" to calibrate
* @params: color_threshold_t threshold, vga_pixel_ptr, video_in_ptr, pushbutton_addr, 
*/
void calibrate_color(color_threshold_t* threshold, unsigned int* vga_pixel_ptr, unsigned int* video_in_ptr, unsigned int* vga_char_ptr, unsigned int* pushbutton_addr, int color_ID){
	unsigned int pixel_color;
	unsigned int pixel_R;
	unsigned int pixel_G;
	unsigned int pixel_B;
	char color_str[64];
	while(*pushbutton_addr != 8){ 		
		//Draw crosshairs at specific point
		VGA_pixel(160, 120, 0x07e0, vga_pixel_ptr);
		draw_delay();
		draw_delay();
		draw_delay();
		VGA_pixel(159, 120, 0x07e0, vga_pixel_ptr);
		draw_delay();
		draw_delay();
		draw_delay();
		VGA_pixel(161, 120, 0x07e0, vga_pixel_ptr);
		draw_delay();
		draw_delay();
		draw_delay();
		VGA_pixel(160, 121, 0x07e0, vga_pixel_ptr);
		draw_delay();
		draw_delay();
		draw_delay();
		VGA_pixel(160, 119, 0x07e0, vga_pixel_ptr);

		//Get the color and write it to the screen
		pixel_color = video_in_read_pixel(160, 120, video_in_ptr);
		pixel_R = (pixel_color >> 11) & 0x1f;
		pixel_G = (pixel_color >> 5) & 0x3f;
		pixel_B = (pixel_color & 0x1f);

		sprintf(color_str, "R=%d, G=%d, B=%d    ", pixel_R, pixel_G, pixel_B);
		VGA_text(1,58,color_str, vga_char_ptr);

		draw_delay();
		draw_delay();
		draw_delay();
		draw_delay();
		draw_delay();
		draw_delay();
		draw_delay();


	}

	unsigned int threshold_R;
	unsigned int threshold_G;
	unsigned int threshold_B;


	if(color_ID == RED_ID){
		threshold_R = RED_THRESHOLD_R;
		threshold_G = RED_THRESHOLD_G;
		threshold_B = RED_THRESHOLD_B;
	}
	else if(color_ID == GREEN_ID){
		threshold_R = GREEN_THRESHOLD_R;
		threshold_G = GREEN_THRESHOLD_G;
		threshold_B = GREEN_THRESHOLD_B;
	}
	else if(color_ID == ORANGE_ID){
		threshold_R = ORANGE_THRESHOLD_R;
		threshold_G = ORANGE_THRESHOLD_G;
		threshold_B = ORANGE_THRESHOLD_B;
	}
	else if(color_ID == PURPLE_ID){
		threshold_R = PURPLE_THRESHOLD_R;
		threshold_G = PURPLE_THRESHOLD_G;
		threshold_B = PURPLE_THRESHOLD_B;
	}
	else if(color_ID == YELLOW_ID){
		threshold_R = YELLOW_THRESHOLD_R;
		threshold_G = YELLOW_THRESHOLD_G;
		threshold_B = YELLOW_THRESHOLD_B;
	}
	else{
		return;
	}

	//Use ints to check for underflow
	int low_red = pixel_R - threshold_R;
	int high_red = pixel_R + threshold_R;
	int low_green = pixel_G - threshold_G;
	int high_green = pixel_G + threshold_G;
	int low_blue = pixel_B - threshold_B;
	int high_blue = pixel_B + threshold_B;

	if(low_red < 0){
		low_red = 0;
	}
	if(high_red > 31){
		high_red = 31;
	}
	if(low_green < 0){
		low_green = 0;
	}
	if(high_green > 63){
		high_green = 63;
	}
	if(low_blue < 0){
		low_blue = 0;
	}
	if(high_blue > 31){
		high_blue = 31;
	}

	//Write to the struct
	threshold->low_R = (unsigned int) low_red;
	threshold->high_R = (unsigned int)high_red;
	threshold->low_G = (unsigned int)low_green;
	threshold->high_G = (unsigned int)high_green;
	threshold->low_B = (unsigned int)low_blue;
	threshold->high_B = (unsigned int)high_blue;

	printf("R_low: %d, R_high: %d, G_low: %d, G_high: %d, B_low: %d, B_high: %d\n", threshold->low_R, threshold->high_R, threshold->low_G, threshold->high_G, threshold->low_B, threshold->high_B);

	delay();

}

/*
*	Write the thresholded values into the corresponding PIO ports, given the threshold struct and PIO addr
* @params: color_threshold_t threshold - struct for color thresholds. PIO_low - addr for low threshold PIO.
* PIO_high - address for high threshold PIO port
*/
void send_calibration(color_threshold_t* threshold, unsigned int* PIO_low, unsigned int* PIO_high){
	*PIO_low = RGB_2_16(threshold->low_R, threshold->low_G, threshold->low_B);
	*PIO_high = RGB_2_16(threshold->high_R, threshold->high_G, threshold->high_B);
}

/*
*  Perform erosion on a single binary frame of video input
*  @params:
*  in_matrix[][COLS] - input binary frame
*  out_matrix[][COLS] - eroded output frame
*  SE_delta: - (n-1)/2, assuming nxn SE
*/
void erosion(unsigned int in_matrix[ROWS][COLS], unsigned int out_matrix[ROWS][COLS], int SE_delta){
	int i;
	int j;
	int SE_i;
	int SE_j;

	for (i = 0; i < ROWS; i++){
		for(j = 0; j < COLS; j++){
			if (i < SE_delta || i >= ROWS-SE_delta || j < SE_delta || j >= COLS-SE_delta) {
				out_matrix[i][j] = 0; //if current pixel is at edge of matrix, make it 1
			}
			else {
				// iterate through all neighbors part of SE, check for 0
				for(SE_i = i-SE_delta; SE_i <= i+SE_delta; SE_i++){
					for(SE_j = j-SE_delta; SE_j <= j+SE_delta; SE_j++){
						if(in_matrix[SE_i][SE_j] == 0){
							// set SE_i and SE_j to max to break out of double for-loop if you find a 0
							// also set 
							out_matrix[i][j] = 0;
							SE_i = i+SE_delta;
							SE_j = j+SE_delta;
							break;
						}
						else{
							out_matrix[i][j] = 1;
						}
					}
				}
			}
		}
	}
}

/*
*  Perform dilation on a single binary frame of video input
*  @params:
*  in_matrix[][COLS] - input binary frame
*  out_matrix[][COLS] - dilated output frame
*  SE_delta: - (n-1)/2, assuming nxn SE
*/
void dilation(unsigned int in_matrix[ROWS][COLS], unsigned int out_matrix[ROWS][COLS], int SE_delta){
	int i;
	int j;
	int SE_i;
	int SE_j;

	for (i = 0; i < ROWS; i++){
		for(j = 0; j < COLS; j++){
			if (i < SE_delta || i >= ROWS-SE_delta || j < SE_delta || j >= COLS-SE_delta) {
				out_matrix[i][j] = 0; //if current pixel is at edge of matrix, make it 0
			}
			else {
				// iterate through all neighbors part of SE, check for 0
				for(SE_i = i-SE_delta; SE_i <= i+SE_delta; SE_i++){
					for(SE_j = j-SE_delta; SE_j <= j+SE_delta; SE_j++){
						if(in_matrix[SE_i][SE_j] == 1){
							// set SE_i and SE_j to max to break out of double for-loop if you find a 0
							// also set 
							out_matrix[i][j] = 1;
							SE_i = i+SE_delta;
							SE_j = j+SE_delta;
							break;
						}
						else{
							out_matrix[i][j] = 0;
						}
					}
				}
			}
		}
	}
}

void delay(){
	int i;
	int j;
	for(i = 0; i  < 50; i++){
		for(j = 0; j < 1000000; j++){
			//spinnnnnnn
		}
	}
}



/*
* perform dfs on input matrix m, using label matrix label, starting at row i and col j, and label
* the connected component with curr_label
* PRECONDITION: non-labeled elements in "label" are set to 0
*/
void dfs(unsigned int m[ROWS][COLS], unsigned int label[ROWS][COLS], unsigned int reference_color, int i, int j, unsigned int curr_label){
	//Bounds check
	if(i < 0 || i >= ROWS || j < 0 || j >= COLS){
		return;
	}
	//If already labeled or background pixel or a different color, return
	if(label[i][j] != 0 || m[i][j] != reference_color){
		return;
	}

	//Label the current pixel 
	label[i][j] = curr_label;


	//Recursively label the neighbors
	dfs(m, label, reference_color, i, j+1, curr_label);
	dfs(m, label, reference_color, i, j-1, curr_label);
	dfs(m, label, reference_color, i+1, j, curr_label);
	dfs(m, label, reference_color, i-1, j, curr_label);
}

/*
* Returns the max label of the frame given by m. Also tracks objcets in between the current frame and previous frame label given by prev
*/
int count_components(unsigned int m[ROWS][COLS], unsigned int prev_frame_label[ROWS][COLS], 
	int prev_max_label, unsigned int* total_sprees, int* total_red, int* total_green, int* total_orange,
	int* total_purple, int* total_yellow, int* num_red, int* num_green,
	int* num_orange, int* num_purple, int* num_yellow, unsigned int* vga_pixel_ptr){
	
	int component_label = prev_max_label + 1;
	unsigned int label[ROWS][COLS] = {0}; //Array to hold the labels of all the components

	int i;
	int j;
	unsigned int curr_color;
	for(i = 0; i < ROWS; i++){
		for(j = 0; j < COLS; j++){
			//printf("Counting component: %d %d\n", i, j);
			//printf("component_label: %d\n", component_label);
			//Only run if this pixel is not labeled and it is foreground
			if(label[i][j] == 0 && m[i][j] != 0){
				//printf("Running DFS\n");
				//Label only the pixels that are of the same color.
				curr_color = m[i][j];
				dfs(m, label, curr_color, i, j, component_label++);
				//Increment the corresponding color's count
				if(curr_color == RED_LABEL){
					*num_red = *num_red + 1;
				}
				else if(curr_color == GREEN_LABEL){
					*num_green = *num_green + 1;
				}
				else if(curr_color == ORANGE_LABEL){
					*num_orange = *num_orange + 1;
				}
				else if(curr_color == PURPLE_LABEL){
					*num_purple = *num_purple + 1;
				}
				else if(curr_color == YELLOW_LABEL){
					*num_yellow = *num_yellow + 1;
				}
				else{
					printf("Unrecognized color: %d\n", curr_color);
				}

			}
		}
	}
	component_label--; //Subtract one to account for additional plus


	/*
	*	Object tracking. We have three conditions (but of course, glitches could cause more probs)
	*	1. An object moves in the frame, but still remains in FOV
	*   2. An object appears in the frame
	*   3. An object dissapears in the frame
	*/	
	//Now draw a point at the center of each identified component
	int num_components = component_label - prev_max_label;
	//printf("numcomponents:%d\n",num_components);
	coordinate_t centroid;
	for(i = 0; i < num_components; i++){
		//printf("Addingcentroid\n");
		//Draw a point at the centroid
		get_centroid(label, &centroid, (i+prev_max_label+1));
		//mark_centroid(vga_pixel_ptr, &centroid);

		//Identify the label at the centroid of the previous frame. IF THERE IS A LABEL THERE, consider that as a previously
		//existing component
		//CASE 1: An object moves location in the frame
		if(prev_frame_label[centroid.row][centroid.col] != 0){
			//Do nothing for now
		}
		//CASE 2: An object appeared in the frame
		//Just look at the lower half of the frame.
		else if(centroid.row > ROWS-70){
			//Checkifthere is something that appeared before
			int k;
			int flag = 0;
			for(k=centroid.row + 1; k < ROWS; k++){
				if(prev_frame_label[k][centroid.col] != 0){
					flag = 1;
					break;
				}
			}

			if(flag==1){
				//printf("Spreesthere previously\n");
				//A spree was previously directly below or above the current one. In this case, don't count this.
			}
			else{
				*total_sprees= *total_sprees+1;
				if(m[centroid.row][centroid.col] == RED_LABEL){
					*total_red = *total_red + 1;
				}
				else if(m[centroid.row][centroid.col] == GREEN_LABEL){
					*total_green = *total_green + 1;
				}
				else if(m[centroid.row][centroid.col] == ORANGE_LABEL){
					*total_orange = *total_orange + 1;
				}
				else if(m[centroid.row][centroid.col] == PURPLE_LABEL){
					*total_purple = *total_purple + 1;
				}
				else if(m[centroid.row][centroid.col] == YELLOW_LABEL){
					*total_yellow = *total_yellow + 1;
				}
				else{
					printf("Centroid over unidentified label: %d\n", m[centroid.row][centroid.col]);
				}
				//printf("NOSPREESTHERE\n");
			}
			//Increase the total spree count
			//Disregard edge of screen this prevents double counting in the event that a spree appears from edge of screen
		}
		else{ //Assume no sprees magically pop up in the middle of the screen.
			//*total_sprees = *total_sprees + 1;
						//printf("incrementingsprees\n");
		}
	}
	//CASE 3: An object dissapears from the frame.
	//DON'T CARE FOR NOW.


	//Copy this frame to the previous frame. Could do this with memcpy, but too lazy for now.
	for(i = 0; i < ROWS; i++){
		for(j = 0; j < COLS; j++){
			prev_frame_label[i][j] = label[i][j];
		}
	}

	return component_label; //Return the max component label.
}

/*
* Writes the row and col coords of the center of mass of a connected component
* defined by the specified component label in the input matrix to the provided coordinate_t
*/
void get_centroid(unsigned int label[ROWS][COLS], coordinate_t* centroid, int component){
	int i;
	int j;

	int sum_row = 0;
	int sum_col = 0;
	int num_pixels = 0;

	for(i = 0; i <ROWS; i++){
		for(j = 0; j < COLS; j++){
			if(label[i][j] == component){
				sum_row = sum_row + i;
				sum_col = sum_col + j;
				num_pixels++;
			}
		}
	}

	//Calculate the centroid. Can safely ignore int division rounding
	centroid->row = (int)(sum_row / (float)num_pixels);
	centroid->col = (int)(sum_col / (float)num_pixels);
}

/**
* Draw a marker for the centroid of a connected component
*/
void mark_centroid(unsigned int* vga_pixel_ptr, coordinate_t* centroid){
	int row = centroid->row+240;
	int col = centroid->col+320;

	//Bounds check
	if(row < 1 || row >= 480-2 || col < 1 || col >= 640-2){
		return;
	}
	
	//Draw the center
	VGA_pixel(col, row, 0x00ff, vga_pixel_ptr);
	draw_delay();
	draw_delay();
	draw_delay();
	VGA_pixel(col-1, row, 0x00ff, vga_pixel_ptr);
	draw_delay();
	draw_delay();
	draw_delay();
	VGA_pixel(col+1, row, 0x00ff, vga_pixel_ptr);
	draw_delay();
	draw_delay();
	draw_delay();
	VGA_pixel(col, row-1, 0x00ff, vga_pixel_ptr);
	draw_delay();
	draw_delay();
	draw_delay();
	VGA_pixel(col, row+1, 0x00ff, vga_pixel_ptr);
}

/**
* Calculate the distance between two coordinate points
*/
// float calc_distance(coordinate_t* a, coordinate_t* b){
// 	float x2 = a->col * b->col;
// 	float y2 = a->row * b->row;
// 	return math.sqrt(x2 + y2);
// }


