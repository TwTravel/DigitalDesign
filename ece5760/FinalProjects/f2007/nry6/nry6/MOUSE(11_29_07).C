
#include "system.h"
#include "basic_io.h"
#include "LCD.h"
#include "Test.h"
//#include "sys/alt_irq.h"
//#include "VGA.h"


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
 

 x_min = 5;          // max and min points - boundaries
 x_max = 511;
 y_min = 3;
 y_max = 478;
 direction = 1;      // 1 = vertical, 0 = horizonal
 level++;            // level up


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

 do
  {
   if(lose)
   {
        break;
        printf(" YOU LOSE!!!!  Level %i.\n", level);
        printf(" Sorry, try again! \n\n\n\n\n");
   } 
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

  if(timecnt!=0) 
  {
    tog++;
  }

  IOWR(SEG7_DISPLAY_BASE,0,(pX<<16)+pY);
  IOWR(LED_RED_BASE,0,pX);
  IOWR(LED_GREEN_BASE,0,pY);
  
  cmdmouse = 0;
  cmdmouse = (pX) | (pY << 10);
  IOWR( MOUSE_XY_BASE, 0, cmdmouse );

  //Set_Cursor_XY(pX,pY);
  if(B==1)      //left click mouse - draw vertical line
  {
    direction = 1;
    cmdxy1 = 0;
    cmdxy1 = (pX+6)| (pY << 10) | ((pX+6) << 20) ;   
    IOWR( WIDEOUT_BASE, 0, cmdxy1 );
    
    cmdxy2 = 0;
    cmdxy2 = (pX+6) | (y_max << 10) | (y_min << 20) ;   
    IOWR( WIDEOUT1_BASE, 0, cmdxy2 );
    //Vga_Set_Pixel(VGA_0_BASE,pX,pY);
    printf("\nleft mouse was clicked on: %i and %i", cmdxy1, cmdxy2);
    printf("\nmouse on: %i and %i", pX, pY);
    
    for( i = 0; i < 100000; i++ )
    {       // delay
        if( ballx == (pX+6) )
        {
            printf("\n\nYOU LOSE!!!!  Level %i.\n", level);
            printf("\nSorry, try again! \n\n\n\n\n");
            lose = 1;
            break;
        }
    }
    
    // sets the new line to a max/min if necessary
    if( ballx < (pX+6) && pX < x_max )
    {
        x_max = pX+6;       // take care of offset
    }
    else if( ballx > (pX+6) && pX > x_min )
    {
        x_min = pX+6;
    }
    
  }
  else if(B==2)
  {
    direction = 0;      // draw horizontal
    cmdxy1 = 0;
    cmdxy1 = (pX+6) | (pY << 10) | ((x_min) << 20) ;  
    //cmdxy1 = (pX) | (x_min << 8) | (pY << 16) | (pY << 24);   
    IOWR( WIDEOUT_BASE, 0, cmdxy1 );
    
    cmdxy2 = 0;
    cmdxy2 = (x_max) | (pY << 10) | (pY << 20) ;   
    IOWR( WIDEOUT1_BASE, 0, cmdxy2 );
    //Vga_Clr_Pixel(VGA_0_BASE,pX,pY);
    printf("\nright mouse was clicked on: %i and %i", cmdxy1, cmdxy2);
    printf("\nmouse on: %i and %i", pX, pY);
    
    for( i = 0; i < 100000; i++ )
    {       // delay
        if( bally == (pY) )
        {
            printf("\nYOU LOSE!!!!  Level %i.\n", level);
            printf("\nSorry, try again! \n\n\n\n\n");
            lose = 1;
            break;
        }
    }
    
    // to set new max / min
    if( bally < pY && pY < y_max )
    {
        y_max = pY;
    }
    else if( bally > pY && pY > y_min )
    {
        y_min = pY;
    }
    
  } // end of B==2 statement
  
  if( (y_max - y_min) < (100/level) && (x_max - x_min) < (100/level) )
  {
     printf("\n\n ---------- CONGRATULATIONS! YOU WIN! ---------- \n");
     printf(" --------------- You beat level %i --------------- \n\n\n\n",level);
     printf("\n please press reset (KEY 0) to reset screen. \n");
     break;
  }
  
  }// end of do statement
  while( (r16(HcRhP2) & 0x01) == 0x01 );  // end of do/while loop
  
  //printf("\nMouse Not Detected");   
  for( i = 0; i < 50000000 ; i++ )
  {         // delay
  } 
  cmdxy1 = (512) | (239 << 10) | (512 << 20) ;
  cmdxy2 = (512) | (437 << 10) | (3 << 20) ;       
  IOWR(WIDEOUT_BASE, 0, cmdxy1);                // reset boundary
  IOWR(WIDEOUT1_BASE, 0, cmdxy2 );
}


void move_ball(void)
{       
    ballxy = IORD(BALL_H2S_BASE, 0);
    ballx = ((ballxy << 22) >> 22);                 // [9:0]
    bally = (((ballxy >> 10) << 22) >> 22);         // [19:0]
    printf("\nBALL should be at: (%i,%i) or else %i\n", ballx,bally, ballxy);

    if( ballx == (x_max-2) )        // >=
    {
        dx = -1;
    }
    else if( ballx == (x_min+2) )   // <=
    {
        dx = 1;
    }
    ballx = ballx + dx;
    
    if( bally == (y_max-1) )        // >=
    {
        dy = -1;
    }
    else if( bally == (y_min+1) )   // <=
    {
        dy = 1;
    }
    bally = bally + dy;
        
       // to detect when the ball hits a line while drawing.... does not work.
//    i = ( ballxy >> 31 );                 // [3]
//    printf("i is %i (line is finished drawing if 1)\n",i);
//    if( direction)
//    { 
//        ballxy = IORD(WIDEOUT_BASE,0);
//        j = ( (ballxy << 22) >> 22 );
//        if( (i == 0) && (ballx == j) )
//        {
//            printf("\n\nYOU LOSE!!!!  Level %i.\n", level);
//            printf("\nSorry, try again! \n\n\n\n\n");
//            lose = 1;
//        }
//        else if ( i )
//        {
//            // sets the new line to a max/min if necessary
//            if( (ballx < j) && (j < x_max) )
//            {
//                x_max = j;       // take care of offset
//            }
//            else if( (ballx > pX) && (pX > x_min) )
//            {
//                x_min = j;
//            }
//        }
//    }
//    else if( direction == 0  )
//    {   
//        ballxy = IORD(WIDEOUT1_BASE,0);
//        j = ( (ballxy << 22) >> 22 );
//        if( (i == 0) && (bally == j) )
//        {
//            printf("\n\nYOU LOSE!!!!  Level %i.\n", level);
//            printf("\nSorry, try again! \n\n\n\n\n");
//            lose = 1;
//        }
//        else if ( i ) 
//        {
//            // to set new max / min
//            if( bally < j && j < y_max )
//            {
//                y_max = j;
//            }
//            else if( bally > j && j > y_min )
//            {
//                y_min = j;
//            }
//        }
//    }
         
    cmdball = 0;
    cmdball = (ballx) | (bally << 10);    // add 6 to offset x_corr
    IOWR(BALL_XY_BASE, 0, cmdball);
    printf("BALL value passed is: %i or else (%i,%i)\n", cmdball,ballx,bally); 
}


void color_in(void)
{
    // to fill in outside of the ball roaming area
    if(direction)
    {
        // color in the rest of the outside area
        if( ballx < (pX+6) && pX < x_max )
        {
            for( i = (pX+7); i < x_max; i++ )
            {
                cmdxy1 = 0;
                cmdxy1 = (i)| (pY << 10) | ((i) << 20) | 1 << 30 ; 
                cmdxy2 = 0;
                cmdxy2 = (i) | (y_max << 10) | (y_min << 20) | 1 << 30 ;  
                IOWR( WIDEOUT_BASE, 0, cmdxy1 );
                IOWR( WIDEOUT1_BASE, 0, cmdxy2 );
                for( j = 0; j < 1000000; j++ )
                {       // delay
                }
            } 
        }
        else if( ballx > (pX+6) && pX > x_min )
        {
            for( i = (pX+5); i > x_min; i-- )
            {
                cmdxy1 = 0;
                cmdxy1 = (i)| (pY << 10) | ((i) << 20) | 1 << 30 ; 
                cmdxy2 = 0;
                cmdxy2 = (i) | (y_max << 10) | (y_min << 20) | 1 << 30 ;  
                IOWR( WIDEOUT_BASE, 0, cmdxy1 );
                IOWR( WIDEOUT1_BASE, 0, cmdxy2 );
                for( j = 0; j < 1000000; j++ )
                {       // delay
                }
            } 
        }
    }
    else
    {
        // color in the rest of the outside area
        if( bally < pY && pY< y_max )
        {
            for( i = pY; i < y_max; i++ )
            {
                cmdxy1 = 0;
                cmdxy1 = (pX+6) | (i << 10) | ((x_min) << 20) | 1 << 30 ;    
                cmdxy2 = 0;
                cmdxy2 = (x_max) | (i << 10) | (i << 20) | 1 << 30 ; 
                IOWR( WIDEOUT_BASE, 0, cmdxy1 );  
                IOWR( WIDEOUT1_BASE, 0, cmdxy2 );
                for( j = 0; j < 1000000; j++ )
                {       // delay
                }
            } 
        }
        else if( bally > pY && pY > y_min )
        {
            for( i = pY; i > y_min; i-- )
            {
                cmdxy1 = 0;
                cmdxy1 = (pX+6) | (i << 10) | ((x_min) << 20) | 1 << 30;    
                cmdxy2 = 0;
                cmdxy2 = (x_max) | (i << 10) | (i << 20) | 1 << 30 ; 
                IOWR( WIDEOUT_BASE, 0, cmdxy1 );  
                IOWR( WIDEOUT1_BASE, 0, cmdxy2 );
                for( j = 0; j < 1000000; j++ )
                {       // delay
                }
            } 
        } 
    }
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
  printf("Welcome to Jezzball.....\n");
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

 if(lose)
 {
    break;
    printf("\n\nYOU LOSE!!!!  Level %i.\n", level);
    printf("Sorry, try again! \n\n\n\n\n");
 }
 usleep(100000);
}
}

