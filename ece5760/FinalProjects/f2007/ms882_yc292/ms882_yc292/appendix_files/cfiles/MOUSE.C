
#include "system.h"
#include "basic_io.h"
#include "sys/alt_irq.h"
#include "altera_avalon_pio_regs.h"


int maxmin(int no, int max, int min)
{
 if(no>max) {no=max;}
 if(no<min) {no=min;}

 return(no);
}

void play_mouse(unsigned int addr)
{
 unsigned int cbuf[128];
 unsigned int rbuf[128];

 //buffer information
 unsigned int atllen,ptllen,intllen;
 unsigned int int_start;

 //int parameters
 unsigned long int_skip=0xFFFFFFFE;
 unsigned long int_last=0x00000001;
 unsigned int  int_blk_size=64;

 unsigned int timecnt;
 unsigned int freq;

 signed char X=0,Y=0,B=0;

 unsigned int pX=320,pY=240;
 unsigned int oX=320,oY=240;

 unsigned int tog=0;
 
 /*******************************************************************************************
                    New Declaration
 *******************************************************************************************/
 unsigned int enable_stick;
 
 freq=0x00;
 erase_all();

 w16(HcBufStatus,0x00);

 //Setup Int Parameters
 w32(HcIntSkip,int_skip);
 w32(HcIntLast,int_last);
 w16(HcIntBlkSize,int_blk_size);

 //Setup Buffer
 atllen  =r16(HcATLLen);
 ptllen  =r16(HcPTLLen);
 intllen =r16(HcINTLen);

 int_start=ptllen+ptllen;

 /*******************************************************************************************
                    New initialization
 *******************************************************************************************/
    stick_length = 0;
    enable_stick = 0; 
    fStick_elongate = 0;
 do
  {
   //send out DATA IN packet
   make_int_ptd(cbuf,IN,1,4,tog%2,addr,addr,freq);
   timecnt=send_int(cbuf,rbuf);
   if(timecnt!=0)
   {
       X=(rbuf[4]>>8);
       Y=(rbuf[5]&0x00FF);
       B=(rbuf[4]&0x000F);
   }
   else
   {
       X=0;
       Y=0;
       B=0;
   }

   oX=pX;
   oY=pY;

   pX=pX+X;
   pY=pY+Y;

   pX=maxmin(pX,639,0);
   pY=maxmin(pY,479,0);

   if(timecnt!=0) {tog++;}


/********************************************************************************************* 
            Our Code Starts from here
*********************************************************************************************/
  Set_Cursor_XY(pX,pY);
 
    if(B==1){ // pressing the mouse
    fStick_elongate = 1;
    if (stick_length != 290) // not yet at max length
        stick_length++;      
    }
 
  // not pressing the mouse, decrement
    else{
    fStick_elongate = 0;
    if (stick_length >=5)
        stick_length = stick_length -5;
    else 
        stick_length = 0;    
    } 
    Set_Stick_Length(stick_length);     
      
  if(B==2){
    if (enable_stick == 0)     //enable stick display
        enable_stick++;
    else                       //disable stick display
        enable_stick--;
    
    Display_Stick(enable_stick);   
  }
  }
  while((r16(HcRhP2) & 0x01) ==0x01);
     printf("\nMouse Not Detected");
}

void mouse(void)
{
 unsigned int rbuf[128];
 unsigned int dev_req[4]={0x0680,0x0100,0x0000,0x0008};
 unsigned int uni_req[4]={0x0500,3,0x0000,0x0000};

 //buffer information
 unsigned int atllen,ptllen,intllen;
 unsigned int atl_start;

 //atl parameters
 unsigned long atl_skip=0xFFFFFFFE;
 unsigned long atl_done=0;
 unsigned long atl_last=0x00000001;
 unsigned int  atl_blk_size=64;
 unsigned int  atl_cnt=1;
 unsigned int  atl_timeout=200;
 unsigned int mycode;
 unsigned int iManufacturer,iProduct;
 unsigned int starty=5;
 unsigned int status;
 unsigned int mouse01=0,mouse02=0;
 unsigned int g=0;

while(1)
{
  dev_req[0]=0x0680;
  dev_req[1]=0x0100;
  dev_req[2]=0x0000;
  dev_req[3]=0x0008;
  uni_req[0]=0x0500;
  uni_req[1]=3;
  uni_req[2]=0x0000;
  uni_req[3]=0x0000;


 //atl parameters
  atl_skip=0xFFFFFFFE;
  atl_done=0;
  atl_last=0x00000001;
  atl_blk_size=64;
  atl_cnt=1;
  atl_timeout=200;
  starty=5;
  mouse01=0,mouse02=0;
 

 set_operational();
 enable_port();

 reset_usb();
 erase_all();
 set_operational();
 enable_port();

 
 w16(HcControl,0x6c0);
 w16(HcUpInt,0x1a9);
 //delay(300);

 w16(HcBufStatus,0x00);

 //Setup ATL Parameters
 w32(HcATLSkip,atl_skip);
 w32(HcATLLast,atl_last);
 w16(HcATLBlkSize,atl_blk_size);
 w16(HcATLThrsCnt,atl_cnt);
 w16(HcATLTimeOut,atl_timeout);

 //Setup ATL Buffer
 atllen  =r16(HcATLLen);
 ptllen  =r16(HcPTLLen);
 intllen =r16(HcINTLen);

 atl_start=ptllen+ptllen+intllen;

 status=assign_address(1,2,0);
 status=assign_address(1,2,0);

 if(g==0)
 {
  printf("ISP1362 Mouse Demo.....\n");
  g=1;
 }

 w16(HcUpIntEnable,0x120);

 if( (status&0x0001)!=0) //port 2 active
 {
//  Check port 2 for mouse
  mycode=get_control(rbuf,2,'D',0,2);
  if(mycode==0x0300)
  {
   iManufacturer = rbuf[7]&0xFF;
   iProduct = (rbuf[7]&0xFF00)>>8;
   addr_info(2,'W','O',iManufacturer);
   addr_info(2,'W','P',iProduct);
   mycode=get_control(rbuf,2,'H',addr_info(2,'R','P',0),2);
   if( *(rbuf+1)==0x0209  )
   {
	   printf("\nMouse Detected");
	   mouse02=1;
   }
  }
 }

 if((mouse02==1)&&(mouse01==0))
 {
  mycode=set_config(2,1);
  if(mycode==0)
  play_mouse(2);
 }
 usleep(100000);
}
}

/********************************************************************************************
   New Functions for Cursor display
********************************************************************************************/

void Set_Cursor_XY(unsigned int X,unsigned int Y)
{
  IOWR_ALTERA_AVALON_PIO_DATA(CURSOR_COORD_BASE, ( (Y<<10)+X ) );
}
//-------------------------------------------------------------------------
void Set_Cursor_Color(unsigned int R,unsigned int G,unsigned int B)
{
  IOWR_ALTERA_AVALON_PIO_DATA(CURSOR_COLOR_BASE,( (R<<20)+(G<<10)+B ) );

}
/********************************************************************************************
   New Functions for Stick display
********************************************************************************************/
void Set_Stick_Length(unsigned int length)
{
  IOWR_ALTERA_AVALON_PIO_DATA(STICK_LENGTH_BASE, length); 
}

// external function so the other classes, namely the ptd.c, can use it.
extern void Continue_Stick(void)
{
    if (fStick_elongate){  // continue to elongate the stick
      if (stick_length != 290) // not yet at max length
        stick_length++;      
    }  
    else{ // shorten the stick
        if (stick_length >=5)
            stick_length = stick_length -5;
        else 
            stick_length = 0;    
    } 
    Set_Stick_Length(stick_length);       
}

void Display_Stick(unsigned int enable)
{
  IOWR_ALTERA_AVALON_PIO_DATA(STICK_STATUS_BASE, enable);
}   