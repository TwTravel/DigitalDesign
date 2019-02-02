#include "altera_up_avalon_usb.h"
#include "altera_up_avalon_usb_mouse_driver.h"
#include "altera_up_avalon_usb_high_level_driver.h"
#include "altera_up_avalon_usb_low_level_driver.h"
#include "altera_up_avalon_usb_regs.h"

/********************************************************************************
 * This program demonstrates use of the USB in the DE2 Media Computer
 *
 * It: 
 *  -- Displays the x location and y location of the mouse on LEDRs and LEDGs
 * 	-- Displays the button status of the mouse on HEX0 - HEX2
********************************************************************************/

int main(void){
	// 1.Open the USB device
    alt_up_usb_dev * usb_device;
    usb_device = alt_up_usb_open_dev("/dev/USB");	
    if (usb_device != NULL) {
        //printf("usb_device->base %08x, please check if this matches the USB's base address in Qsys\n", usb_device->base);
        unsigned int mycode;
        int port = -1;
        int addr = -1;
        int config = -1;
        int HID = -1; //Human Interface Device Descriptor number.
        while (1) {
            port = -1;
            addr = -1;

            // 2. Set up the USB and get the connected port number and its address
            HID = alt_up_usb_setup(usb_device, &addr, &port);

            if (port != -1 && HID == 0x0209) {
                // 3. After confirming that the device is connected is a mouse, the host must choose a configuration on the device
                config = 1;
                mycode = alt_up_usb_set_config(usb_device, addr, port, config);
                if (mycode == 0) {
                    // 4. Set up and play mouse
                    alt_up_usb_play_mouse(usb_device, addr, port);
                }
            }
        }
    }else {
        printf("Error: could not open USB device\n");
    }	
	return 0;
}

