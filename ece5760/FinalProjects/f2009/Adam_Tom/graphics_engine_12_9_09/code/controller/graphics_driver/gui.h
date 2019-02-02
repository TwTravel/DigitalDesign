#ifndef GUI_H_
#define GUI_H_

#ifndef NULL
#define NULL 0
#endif

//////////////////////////
// Menu frame properties
//////////////////////////

#define MENU_FRAME_COLOR_R 0        // The color of the lines
#define MENU_FRAME_COLOR_G 0        // outlining a menu.
#define MENU_FRAME_COLOR_B 255      //

#define MENU_HIGHLIGHTED_SHADE_COLOR_R 0   // The color shading a
#define MENU_HIGHLIGHTED_SHADE_COLOR_G 0   // highlighted menu item.
#define MENU_HIGHLIGHTED_SHADE_COLOR_B 150 //

#define MENU_SELECTED_SHADE_COLOR_R 0   // The color shading a
#define MENU_SELECTED_SHADE_COLOR_G 150 // selected menu item.
#define MENU_SELECTED_SHADE_COLOR_B 0   //

#define MENU_TITLE_SHADE_COLOR_R 0      // The color shading the menu
#define MENU_TITLE_SHADE_COLOR_G 100    // title bar.
#define MENU_TITLE_SHADE_COLOR_B 200    //

#define MENU_TEXT_COLOR_R 255           // The color of menu text.
#define MENU_TEXT_COLOR_G 255           //
#define MENU_TEXT_COLOR_B 255           //

#define MENU_SELECTED_TEXT_COLOR_R 0             // The color of menu text
#define MENU_SELECTED_TEXT_COLOR_G 255           // when a menu item has
#define MENU_SELECTED_TEXT_COLOR_B 0             // been selected.


#define MENU_ITEM_HEIGHT 15 // The height and width of a
#define MENU_ITEM_WIDTH 200  // menu item.
#define MENU_FRAME_WIDTH MENU_ITEM_WIDTH + 2

//////////////////////////////////////
// Menu item selection action options
//////////////////////////////////////
#define DO_NOTHING      0
#define CLOSE_ON_SELECT 1
#define TOGGLE_SELECT   2

// Define the "menu" struct
typedef struct
{
    char *menuName;         // Name of the currently selected menu 
    char *menuItems[32];    // Array of menu items - 32 character max per item string
    int numItems;           // Number of menu items
    //FIXME Generalize these array sizes
    int selected[3];        // For each item in the list, 1 indicates selected, 0 indicates not selected
    int actionOnSelect[3];  // Choose the action to perform when a menu item is selected
    
    int menuLocX;           // X-location of top-left corner of menu
    int menuLocY;           // Y-location of top-left corner of menu
} Menu;

//Prototype menu functions
void drawMenu(Menu* menu);
void selectItem(Menu* menu, int selected);
void deselectItem(Menu* menu, int deselected);

#endif /*GUI_H_*/
