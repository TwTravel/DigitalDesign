#include <alt_types.h>
#include <altera_avalon_pio_regs.h>
#include <sys/alt_irq.h>
#include <sys/alt_alarm.h>
#include <sys/alt_dma.h>
#include <stdio.h>
#include "system.h"
#include "graphics.h"
#include "gui.h"
#include "picture_frame.h"

int heartbeat_led;
static alt_alarm heartbeat_alarm;

// Image bitmap arrays
#include "bruce_wire_hair.c"
#include "gradient.c"
#include "tom_and_adam.c"
#include "xkcd.c"

// Font bitmap array
#include "../../courier_new_12pt_7x10.c"


alt_u32 Heartbeat(void *context)
{
    //Toggle heartbeat LED.
    heartbeat_led=~heartbeat_led;
    IOWR_ALTERA_AVALON_PIO_DATA(HEARTBEAT_LED_BASE,heartbeat_led);
    return alt_ticks_per_second();
}

int main(void)
{
    alt_u8 btn=0;
    alt_u16 i;
    int heartbeat_led_last=0;
    int slideshow_speed = FAST;
    int timer_count = 0;
    int slideshow_active = 1;
    int draw_captions = 1;
    int main_menu_open = 0;
    int speed_select_menu_open = 0;
    int j;
    Menu *activeMenu = NULL;
    
    //Declare menus
    Menu mainMenu = {
        "Main Menu",
        {"Pause","Select Slideshow Speed","Hide Image Titles"},
        3,
        {0,0,0},
        {CLOSE_ON_SELECT, CLOSE_ON_SELECT, TOGGLE_SELECT},
        0,
        0
    };
    
    Menu speedSelectMenu = {
        "Select Slideshow Speed",
        {"Slow (10s)", "Medium (5s)", "Fast (2s)"},
        3,
        {0,1,0},
        {CLOSE_ON_SELECT, CLOSE_ON_SELECT, CLOSE_ON_SELECT},
        0,
        0
    };
    
    //Enable heartbeat timer.
    alt_alarm_start(&heartbeat_alarm,alt_ticks_per_second(),Heartbeat,0);
    
    GPUInit();
    GPUClear();
    
    i = 0;
    
    //Load the main font
    GPULoadFont(7,10,255,255,255,(void*)courier_new_12pt);
    
    while(1)
    { 
        if(heartbeat_led_last != heartbeat_led)
        { 
            if (slideshow_active) {
                timer_count++;
            }
            heartbeat_led_last = heartbeat_led;
        }
        
        if (timer_count >= slideshow_speed) {
            
            timer_count = 0;
            GPUSetLayer(GPU_LAYER_BG);

            if (i == 0) {
                GPUDrawBMP(0,0,(void*)xkcd);
                if (draw_captions) {
                    GPUDrawRect(100,0,250,10,0,0,0);
                    GPUDrawString(101,1,255,255,255,"www.xkcd.com");
                }
            }
            else if (i == 1) {
                GPUDrawBMP(0,0,(void*)bruce);
                if (draw_captions) {
                    GPUDrawRect(100,0,250,10,0,0,0);
                    GPUDrawString(101,1,255,255,255,"Our Fearless Leader");
                }
            }
            else if (i == 2) {
                GPUDrawBMP(0,0,(void*)gradient);
                if (draw_captions) {
                    GPUDrawRect(100,0,250,10,0,0,0);
                    GPUDrawString(101,1,255,255,255,"Color Test");
                }
            }
            else if (i == 3) {
                GPUDrawBMP(0,0,(void*)tom_and_adam);
                if (draw_captions) {
                    GPUDrawRect(100,0,250,10,0,0,0);
                    GPUDrawString(101,1,255,255,255,"Our Very Professional Design Team");
                }
            }

            // Wrap slideshow
            i++;
            if (i > 3) {
                i = 0;
            }
        }
        
        //If key3 is pressed, open the main menu
        if(IORD_ALTERA_AVALON_PIO_DATA(GPI_BASE)&0x04)
        {
            if(btn&0x04)continue;
            btn|=0x04;

            main_menu_open = !main_menu_open;
            if (main_menu_open) {
                drawMenu(&mainMenu);
                activeMenu = &mainMenu;
            }
            else {
                GPUClearLayer(GPU_LAYER_FG);   
            }
        }
        else btn&=~0x04;
        
        //If key2 is pressed, move up one option in active menu
        if(IORD_ALTERA_AVALON_PIO_DATA(GPI_BASE)&0x02)
        {
            if(btn&0x02)continue;
            btn|=0x02;

            if (activeMenu != NULL) {
                GPUSetLayer(GPU_LAYER_FG);
                
                //Find the active item
                for (j = 0; j < activeMenu->numItems; j++) {
                    if (activeMenu->selected[j] == 1) {
                        break;
                    }
                }
                
                printf("%i\n",j);
                
                activeMenu->selected[j] = 0;
                //Decide what the next item up is
                if (j == activeMenu->numItems) { 
                    j = activeMenu->numItems - 1;
                }
                else if (j == 0) {
                    j = activeMenu->numItems - 1;
                    deselectItem(activeMenu,0);
                }
                else {
                    deselectItem(activeMenu,j);
                    j = j - 1;
                }
                
                //Select one item above that
                selectItem(activeMenu,j);
                activeMenu->selected[j] = 1;
            }

        }
        else btn&=~0x02;
        
        //If key1 is pressed, move down one option
        if(IORD_ALTERA_AVALON_PIO_DATA(GPI_BASE)&0x01)
        {
            if(btn&0x01)continue;
            btn|=0x01;
 
            if (activeMenu != NULL) {

                if (activeMenu == &mainMenu) {
                    if (activeMenu->selected[0] == 1) {
                        slideshow_active = !slideshow_active;
                        GPUClearLayer(GPU_LAYER_FG);
                        if (slideshow_active) {
                            activeMenu->menuItems[0] = "Pause";
                        }
                        else {
                            activeMenu->menuItems[0] = "Unpause";
                        }
                        activeMenu=NULL;
                    }
                    else if (activeMenu->selected[1] == 1) {
                        GPUClearLayer(GPU_LAYER_FG);
                        drawMenu(&speedSelectMenu);
                        activeMenu = &speedSelectMenu;
                    }
                    else if (activeMenu->selected[2] == 1) {
                        draw_captions = !draw_captions;
                        GPUClearLayer(GPU_LAYER_FG);
                        if (draw_captions) {
                            activeMenu->menuItems[2] = "Hide Image Titles";
                        }
                        else {
                            activeMenu->menuItems[2] = "Show Image Titles";
                        }
                        activeMenu=NULL;
                    }                    
                }
                else {
                    if (activeMenu->selected[0] == 1)
                        slideshow_speed = SLOW;                        
                    if (activeMenu->selected[1] == 1)
                        slideshow_speed = MEDIUM;
                    if (activeMenu->selected[2] == 1)
                        slideshow_speed = FAST;
                    GPUClearLayer(GPU_LAYER_FG);
                    activeMenu = NULL;
                }
            }            
        }
        else btn&=~0x01;
    }

    return 0;
}
