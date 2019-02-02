/*********************************************************************************************************
Claire Chen and Mark Zhao
ECE 5760, Spring 2017

Description: Perform color thresholding for all target colors
*********************************************************************************************************/

module color_thresholds (
	red_high,
	red_low,
	green_high,
	green_low,
	orange_high,
	orange_low,
	yellow_high,
	yellow_low,
	purple_high,
	purple_low,
	current_pixel_color,
	is_red,
	is_green,
	is_orange,
	is_yellow,
	is_purple
);

	// Threshold high and low values are from PIO ports
	input [15:0] red_high;
	input [15:0] red_low;
	input [15:0] green_high;
	input [15:0] green_low;
	input [15:0] orange_high;
	input [15:0] orange_low;
	input [15:0] yellow_high;
	input [15:0] yellow_low;
	input [15:0] purple_high;
	input [15:0] purple_low;

	// Video-in data
	input [15:0] current_pixel_color;
	
	output is_red, is_green, is_orange, is_yellow, is_purple;
	
	// RGB fields of all 16-bit threshold values and current pixel color
	wire [4:0] red_high_R, red_high_B;
	wire [5:0] red_high_G;
	wire [4:0] red_low_R, red_low_B;
	wire [5:0] red_low_G;
	
	wire [4:0] green_high_R, green_high_B;
	wire [5:0] green_high_G;
	wire [4:0] green_low_R,green_low_B;
	wire [5:0] green_low_G;
	
	wire [4:0] orange_high_R, orange_high_B;
	wire [5:0] orange_high_G;
	wire [4:0] orange_low_R, orange_low_B;
	wire [5:0] orange_low_G;
	
	wire [4:0] yellow_high_R, yellow_high_B;
	wire [5:0] yellow_high_G;
	wire [4:0] yellow_low_R, yellow_low_B;
	wire [5:0] yellow_low_G;
	
	wire [4:0] purple_high_R, purple_high_B;
	wire [5:0] purple_high_G;
	wire [4:0] purple_low_R, purple_low_B;
	wire [5:0] purple_low_G;

	wire [4:0] current_pixel_color_R, current_pixel_color_B;
	wire [5:0] current_pixel_color_G;

	assign red_high_R = red_high[15:11];
	assign red_high_G = red_high[10:5];
	assign red_high_B = red_high[4:0];

	assign red_low_R = red_low[15:11];
	assign red_low_G = red_low[10:5];
	assign red_low_B = red_low[4:0];
	
	assign green_high_R = green_high[15:11];
	assign green_high_G = green_high[10:5];
	assign green_high_B = green_high[4:0];

	assign green_low_R = green_low[15:11];
	assign green_low_G = green_low[10:5];
	assign green_low_B = green_low[4:0];
	
	assign orange_high_R = orange_high[15:11];
	assign orange_high_G = orange_high[10:5];
	assign orange_high_B = orange_high[4:0];

	assign orange_low_R = orange_low[15:11];
	assign orange_low_G = orange_low[10:5];
	assign orange_low_B = orange_low[4:0];
	
	assign yellow_high_R = yellow_high[15:11];
	assign yellow_high_G = yellow_high[10:5];
	assign yellow_high_B = yellow_high[4:0];

	assign yellow_low_R = yellow_low[15:11];
	assign yellow_low_G = yellow_low[10:5];
	assign yellow_low_B = yellow_low[4:0];
	
	assign purple_high_R = purple_high[15:11];
	assign purple_high_G = purple_high[10:5];
	assign purple_high_B = purple_high[4:0];

	assign purple_low_R = purple_low[15:11];
	assign purple_low_G = purple_low[10:5];
	assign purple_low_B = purple_low[4:0];

	assign current_pixel_color_R = current_pixel_color[15:11];
	assign current_pixel_color_G = current_pixel_color[10:5];
	assign current_pixel_color_B = current_pixel_color[4:0];

	// Check to see if current pixel color RGB values fall within color ranges

	assign is_red = (current_pixel_color_R <= red_high_R) 
						&& (current_pixel_color_R >= red_low_R)
						&& (current_pixel_color_G <= red_high_G)
						&& (current_pixel_color_G >= red_low_G)
						&& (current_pixel_color_B <= red_high_B)
						&& (current_pixel_color_B >= red_low_B);
						
	assign is_green = (current_pixel_color_R <= green_high_R) 
						&& (current_pixel_color_R >= green_low_R)
						&& (current_pixel_color_G <= green_high_G)
						&& (current_pixel_color_G >= green_low_G)
						&& (current_pixel_color_B <= green_high_B)
						&& (current_pixel_color_B >= green_low_B);

	assign is_orange = (current_pixel_color_R <= orange_high_R) 
						&& (current_pixel_color_R >= orange_low_R)
						&& (current_pixel_color_G <= orange_high_G)
						&& (current_pixel_color_G >= orange_low_G)
						&& (current_pixel_color_B <= orange_high_B)
						&& (current_pixel_color_B >= orange_low_B);

	assign is_yellow = (current_pixel_color_R <= yellow_high_R) 
						&& (current_pixel_color_R >= yellow_low_R)
						&& (current_pixel_color_G <= yellow_high_G)
						&& (current_pixel_color_G >= yellow_low_G)
						&& (current_pixel_color_B <= yellow_high_B)
						&& (current_pixel_color_B >= yellow_low_B);

	assign is_purple = (current_pixel_color_R <= purple_high_R) 
						&& (current_pixel_color_R >= purple_low_R)
						&& (current_pixel_color_G <= purple_high_G)
						&& (current_pixel_color_G >= purple_low_G)
						&& (current_pixel_color_B <= purple_high_B)
						&& (current_pixel_color_B >= purple_low_B);					
endmodule