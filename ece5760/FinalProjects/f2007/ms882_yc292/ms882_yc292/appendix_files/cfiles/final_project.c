#include "system.h"
#include "basic_io.h"
#include "sys/alt_irq.h"
#include "HAL4D13.C"


#include "isa290.h"
#include "reg.h"
#include "buf_man.h"
#include "port.h"
#include "usb.h"
#include "ptd.h"
#include "cheeyu.h"
#include "mouse.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <io.h>
#include <fcntl.h>
#include "mouse.c"
#include "cheeyu.c"
#include "ptd.c"
#include "usb.c"
#include "buf_man.c"
#include "reg.c"
#include "port.c"

unsigned int        hc_data;
unsigned int        hc_com;
unsigned int        dc_data;
unsigned int        dc_com;

int main(void)
{

  Set_Cursor_Color(0,1023,0);

  w16(HcReset,0x00F6);//reset      
  reset_usb();//config  
  mouse();
  return 0;
}

