#include <string.h>
#include "system.h"
#include "gpu.h"
#include "graphics.h"
#include "gui.h"

void drawMenu(Menu* menu)
{
    int i;
    
    GPUSetLayer(GPU_LAYER_FG);
    
    // Draw menu border
    GPUDrawRect(menu->menuLocX,
                menu->menuLocY,
                MENU_FRAME_WIDTH,
                ((menu->numItems)+1) * MENU_ITEM_HEIGHT,
                MENU_FRAME_COLOR_R,
                MENU_FRAME_COLOR_G,
                MENU_FRAME_COLOR_B);

    // Draw menu title
    GPUDrawRect(menu->menuLocX + 3,
                menu->menuLocY + 2,
                MENU_FRAME_WIDTH - 4,
                MENU_ITEM_HEIGHT - 4,
                MENU_TITLE_SHADE_COLOR_R,
                MENU_TITLE_SHADE_COLOR_G,
                MENU_TITLE_SHADE_COLOR_B);
                
    GPUDrawString(menu->menuLocX + 2,
                  menu->menuLocY + 3,
                  MENU_SELECTED_TEXT_COLOR_R,
                  MENU_SELECTED_TEXT_COLOR_G,
                  MENU_SELECTED_TEXT_COLOR_B,
                  menu->menuName);
                
    // Draw menu items
    for (i = 0; i < menu->numItems; i++) {
        
        // Draw item outline frame
        GPUDrawRect(menu->menuLocX + 2,
                    (menu->menuLocY) + (i+1)*MENU_ITEM_HEIGHT + 1,
                    MENU_ITEM_WIDTH - 2,
                    MENU_ITEM_HEIGHT - 2,
                    0,0,0);                    

        // Draw string
        GPUDrawString(menu->menuLocX + 3,
                      (menu->menuLocY) + (i+1)*MENU_ITEM_HEIGHT+3,
                      MENU_TEXT_COLOR_R,
                      MENU_TEXT_COLOR_G,
                      MENU_TEXT_COLOR_B,
                      menu->menuItems[i]);
    }  
}

void selectItem(Menu* menu, int selected)
{
        GPUDrawRect(menu->menuLocX + 2,
                    (menu->menuLocY) + (selected+1)*MENU_ITEM_HEIGHT + 1,
                    MENU_ITEM_WIDTH - 2,
                    MENU_ITEM_HEIGHT - 2,
                    MENU_SELECTED_SHADE_COLOR_R,
                    MENU_SELECTED_SHADE_COLOR_G,
                    MENU_SELECTED_SHADE_COLOR_B);                    

        // Draw string
        GPUDrawString(menu->menuLocX + 3,
                      (menu->menuLocY) + (selected+1)*MENU_ITEM_HEIGHT+2,
                      MENU_SELECTED_TEXT_COLOR_R,
                      MENU_SELECTED_TEXT_COLOR_G,
                      MENU_SELECTED_TEXT_COLOR_B,
                      menu->menuItems[selected]);
     
    
}

void deselectItem(Menu* menu, int deselected)
{
 
        // Draw item outline frame
        GPUDrawRect(menu->menuLocX + 2,
                    (menu->menuLocY) + (deselected+1)*MENU_ITEM_HEIGHT + 1,
                    MENU_ITEM_WIDTH - 2,
                    MENU_ITEM_HEIGHT - 2,
                    0,0,0);                    

        // Draw string
        GPUDrawString(menu->menuLocX + 3,
                      (menu->menuLocY) + (deselected+1)*MENU_ITEM_HEIGHT+3,
                      MENU_TEXT_COLOR_R,
                      MENU_TEXT_COLOR_G,
                      MENU_TEXT_COLOR_B,
                      menu->menuItems[deselected]); 
    
}

