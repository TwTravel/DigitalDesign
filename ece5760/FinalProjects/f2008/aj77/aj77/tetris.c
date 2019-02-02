// system.h has peripheral base addresses, IRQ definitions, and cpu details
#include "system.h"
// Next include has definition of alt_irq_register
#include "sys/alt_irq.h"
//The next two includes are in syslib/DeviceDrivers[sopc_builder]
//They have the macros for setting values in peripherals

#include "altera_avalon_pio_regs.h"
// Next include contains usleep(microseconds)
#include <unistd.h> //e.g. //usleep(5000000); is 5 seconds
#include <stdio.h>
#include "tfunctions.h"
#include "altera_avalon_pio_regs.h"
#include <io.h>
#include "altera_avalon_uart_regs.h"
//#include "altera_avalon_irda_regs.h"

#define gridconst 0x12345678 


//I like these:
#define begin {
#define end }  

  //function for receiving data on the serial port
  void serialinterrupt(void* context , alt_u32 id)
  {
    unsigned long int tempdata ; 
    volatile int* count = (volatile int*) context;     
    unsigned long int data ;   
    int sr ; 
    sr = IORD_ALTERA_AVALON_UART_STATUS(UART1_BASE); 
   // printf("just got data   %x \n " , sr) ;
    //IOWR_ALTERA_AVALON_PIO_DATA(UART_BASE + 2,0);
   
    data = IORD_ALTERA_AVALON_UART_RXDATA(UART1_BASE); 
    //printf("just got data   %x \n " , data) ;
    
   // printf("count is %d \n " , *count) ;
    
    
    if(data == 0xff)
    {
        *count = 37 ;
    }
    else if (*count == 37)
    {
        *count = 0 ; 
        IOWR_ALTERA_AVALON_PIO_DATA(OTHERMADELINEWRITE_BASE , data) ;
    }
    else
    {
       if(*count == 0)
       {
        tempdata = IORD_ALTERA_AVALON_PIO_DATA(ROW191817READ_BASE) ;
        tempdata = tempdata & 0xfffffC1f ; 
        data = data & 0x0000001f ; 
        tempdata = tempdata | (data << 5) ;
        IOWR_ALTERA_AVALON_PIO_DATA(ROW191817WRITE_BASE, tempdata) ;
       }
       else if (*count == 1)
       {
        tempdata = IORD_ALTERA_AVALON_PIO_DATA(ROW191817READ_BASE) ;
        tempdata = tempdata & 0xffffffe0 ; 
        data = data & 0x0000001f ; 
        tempdata = tempdata |  data ;
        IOWR_ALTERA_AVALON_PIO_DATA(ROW191817WRITE_BASE, tempdata) ;
       }
       else if (*count == 2)
       {
        tempdata = IORD_ALTERA_AVALON_PIO_DATA(ROW191817READ_BASE) ;
        tempdata = tempdata & 0xfff07fff ; 
        data = data & 0x0000001f ; 
        tempdata = tempdata | (data  << 15) ;
        IOWR_ALTERA_AVALON_PIO_DATA(ROW191817WRITE_BASE, tempdata) ;
          
       }
       else if (*count == 3)
       {
        tempdata = IORD_ALTERA_AVALON_PIO_DATA(ROW191817READ_BASE) ;
        tempdata = tempdata & 0xffff83ff ; 
        data = data & 0x0000001f ; 
        tempdata = tempdata | (data << 10) ;
        IOWR_ALTERA_AVALON_PIO_DATA(ROW191817WRITE_BASE, tempdata) ;
       }
       else if (*count == 4)
       {
        tempdata = IORD_ALTERA_AVALON_PIO_DATA(ROW191817READ_BASE) ;
        tempdata = tempdata & 0x01ffffff ; 
        data = data & 0x0000001f ; 
        tempdata = tempdata | (data << 25) ;
        IOWR_ALTERA_AVALON_PIO_DATA(ROW191817WRITE_BASE, tempdata) ;
       }
       else if (*count == 5)
       {
        tempdata = IORD_ALTERA_AVALON_PIO_DATA(ROW191817READ_BASE) ;
        tempdata = tempdata & 0xfe0fffff ; 
        data = data & 0x0000001f ; 
        tempdata = tempdata | (data << 20) ;
        IOWR_ALTERA_AVALON_PIO_DATA(ROW191817WRITE_BASE, tempdata) ;
       }
       
       //************************************
       else if(*count == 6)
       {
        tempdata = IORD_ALTERA_AVALON_PIO_DATA(ROW161514READ_BASE) ;
        tempdata = tempdata & 0xfffffC1f ; 
        data = data & 0x0000001f ; 
        tempdata = tempdata | (data << 5) ;
        IOWR_ALTERA_AVALON_PIO_DATA(ROW161514WRITE_BASE, tempdata) ;
       }
       else if (*count == 7)
       {
        tempdata = IORD_ALTERA_AVALON_PIO_DATA(ROW161514READ_BASE) ;
        tempdata = tempdata & 0xffffffe0 ; 
        data = data & 0x0000001f ; 
        tempdata = tempdata |  data ;
        IOWR_ALTERA_AVALON_PIO_DATA(ROW161514WRITE_BASE, tempdata) ;
       }
       else if (*count == 8)
       {
        tempdata = IORD_ALTERA_AVALON_PIO_DATA(ROW161514READ_BASE) ;
        tempdata = tempdata & 0xfff07fff ; 
        data = data & 0x0000001f ; 
        tempdata = tempdata | (data  << 15) ;
        IOWR_ALTERA_AVALON_PIO_DATA(ROW161514WRITE_BASE, tempdata) ;
          
       }
       else if (*count == 9)
       {
        tempdata = IORD_ALTERA_AVALON_PIO_DATA(ROW161514READ_BASE) ;
        tempdata = tempdata & 0xffff83ff ; 
        data = data & 0x0000001f ; 
        tempdata = tempdata | (data << 10) ;
        IOWR_ALTERA_AVALON_PIO_DATA(ROW161514WRITE_BASE, tempdata) ;
       }
       else if (*count == 10)
       {
        tempdata = IORD_ALTERA_AVALON_PIO_DATA(ROW161514READ_BASE) ;
        tempdata = tempdata & 0x01ffffff ; 
        data = data & 0x0000001f ; 
        tempdata = tempdata | (data << 25) ;
        IOWR_ALTERA_AVALON_PIO_DATA(ROW161514WRITE_BASE, tempdata) ;
       }
       else if (*count == 11)
       {
        tempdata = IORD_ALTERA_AVALON_PIO_DATA(ROW161514READ_BASE) ;
        tempdata = tempdata & 0xfe0fffff ; 
        data = data & 0x0000001f ; 
        tempdata = tempdata | (data << 20) ;
        IOWR_ALTERA_AVALON_PIO_DATA(ROW161514WRITE_BASE, tempdata) ;
       }
       
       
       //*********************
       else if(*count == 12)
       {
        tempdata = IORD_ALTERA_AVALON_PIO_DATA(ROW131211READ_BASE) ;
        tempdata = tempdata & 0xfffffC1f ; 
        data = data & 0x0000001f ; 
        tempdata = tempdata | (data << 5) ;
        IOWR_ALTERA_AVALON_PIO_DATA(ROW131211WRITE_BASE, tempdata) ;
       }
       else if (*count == 13)
       {
        tempdata = IORD_ALTERA_AVALON_PIO_DATA(ROW131211READ_BASE) ;
        tempdata = tempdata & 0xffffffe0 ; 
        data = data & 0x0000001f ; 
        tempdata = tempdata |  data ;
        IOWR_ALTERA_AVALON_PIO_DATA(ROW131211WRITE_BASE, tempdata) ;
       }
       else if (*count == 14)
       {
        tempdata = IORD_ALTERA_AVALON_PIO_DATA(ROW131211READ_BASE) ;
        tempdata = tempdata & 0xfff07fff ; 
        data = data & 0x0000001f ; 
        tempdata = tempdata | (data  << 15) ;
        IOWR_ALTERA_AVALON_PIO_DATA(ROW131211WRITE_BASE, tempdata) ;
          
       }
       else if (*count == 15)
       {
        tempdata = IORD_ALTERA_AVALON_PIO_DATA(ROW131211READ_BASE) ;
        tempdata = tempdata & 0xffff83ff ; 
        data = data & 0x0000001f ; 
        tempdata = tempdata | (data << 10) ;
        IOWR_ALTERA_AVALON_PIO_DATA(ROW131211WRITE_BASE, tempdata) ;
       }
       else if (*count == 16)
       {
        tempdata = IORD_ALTERA_AVALON_PIO_DATA(ROW131211READ_BASE) ;
        tempdata = tempdata & 0x01ffffff ; 
        data = data & 0x0000001f ; 
        tempdata = tempdata | (data << 25) ;
        IOWR_ALTERA_AVALON_PIO_DATA(ROW131211WRITE_BASE, tempdata) ;
       }
       else if (*count == 17)
       {
        tempdata = IORD_ALTERA_AVALON_PIO_DATA(ROW131211READ_BASE) ;
        tempdata = tempdata & 0xfe0fffff ; 
        data = data & 0x0000001f ; 
        tempdata = tempdata | (data << 20) ;
        IOWR_ALTERA_AVALON_PIO_DATA(ROW131211WRITE_BASE, tempdata) ;
       }
       
       //***************************************************************
       else if(*count == 18)
       {
        tempdata = IORD_ALTERA_AVALON_PIO_DATA(ROW1098READ_BASE) ;
        tempdata = tempdata & 0xfffffC1f ; 
        data = data & 0x0000001f ; 
        tempdata = tempdata | (data << 5) ;
        IOWR_ALTERA_AVALON_PIO_DATA(ROW1098WRITE_BASE, tempdata) ;
       }
       else if (*count == 19)
       {
        tempdata = IORD_ALTERA_AVALON_PIO_DATA(ROW1098READ_BASE) ;
        tempdata = tempdata & 0xffffffe0 ; 
        data = data & 0x0000001f ; 
        tempdata = tempdata |  data ;
        IOWR_ALTERA_AVALON_PIO_DATA(ROW1098WRITE_BASE, tempdata) ;
       }
       else if (*count == 20)
       {
        tempdata = IORD_ALTERA_AVALON_PIO_DATA(ROW1098READ_BASE) ;
        tempdata = tempdata & 0xfff07fff ; 
        data = data & 0x0000001f ; 
        tempdata = tempdata | (data  << 15) ;
        IOWR_ALTERA_AVALON_PIO_DATA(ROW1098WRITE_BASE, tempdata) ;
          
       }
       else if (*count == 21)
       {
        tempdata = IORD_ALTERA_AVALON_PIO_DATA(ROW1098READ_BASE) ;
        tempdata = tempdata & 0xffff83ff ; 
        data = data & 0x0000001f ; 
        tempdata = tempdata | (data << 10) ;
        IOWR_ALTERA_AVALON_PIO_DATA(ROW1098WRITE_BASE, tempdata) ;
       }
       else if (*count == 22)
       {
        tempdata = IORD_ALTERA_AVALON_PIO_DATA(ROW1098READ_BASE) ;
        tempdata = tempdata & 0x01ffffff ; 
        data = data & 0x0000001f ; 
        tempdata = tempdata | (data << 25) ;
        IOWR_ALTERA_AVALON_PIO_DATA(ROW1098WRITE_BASE, tempdata) ;
       }
       else if (*count == 23)
       {
        tempdata = IORD_ALTERA_AVALON_PIO_DATA(ROW1098READ_BASE) ;
        tempdata = tempdata & 0xfe0fffff ; 
        data = data & 0x0000001f ; 
        tempdata = tempdata | (data << 20) ;
        IOWR_ALTERA_AVALON_PIO_DATA(ROW1098WRITE_BASE, tempdata) ;
       }
       
       //*****************************************************
       else if(*count == 24)
       {
        tempdata = IORD_ALTERA_AVALON_PIO_DATA(ROW765READ_BASE) ;
        tempdata = tempdata & 0xfffffC1f ; 
        data = data & 0x0000001f ; 
        tempdata = tempdata | (data << 5) ;
        IOWR_ALTERA_AVALON_PIO_DATA(ROW765WRITE_BASE, tempdata) ;
       }
       else if (*count == 25)
       {
        tempdata = IORD_ALTERA_AVALON_PIO_DATA(ROW765READ_BASE) ;
        tempdata = tempdata & 0xffffffe0 ; 
        data = data & 0x0000001f ; 
        tempdata = tempdata |  data ;
        IOWR_ALTERA_AVALON_PIO_DATA(ROW765WRITE_BASE, tempdata) ;
       }
       else if (*count == 26)
       {
        tempdata = IORD_ALTERA_AVALON_PIO_DATA(ROW765READ_BASE) ;
        tempdata = tempdata & 0xfff07fff ; 
        data = data & 0x0000001f ; 
        tempdata = tempdata | (data  << 15) ;
        IOWR_ALTERA_AVALON_PIO_DATA(ROW765WRITE_BASE, tempdata) ;
          
       }
       else if (*count == 27)
       {
        tempdata = IORD_ALTERA_AVALON_PIO_DATA(ROW765READ_BASE) ;
        tempdata = tempdata & 0xffff83ff ; 
        data = data & 0x0000001f ; 
        tempdata = tempdata | (data << 10) ;
        IOWR_ALTERA_AVALON_PIO_DATA(ROW765WRITE_BASE, tempdata) ;
       }
       else if (*count == 28)
       {
        tempdata = IORD_ALTERA_AVALON_PIO_DATA(ROW765READ_BASE) ;
        tempdata = tempdata & 0x01ffffff ; 
        data = data & 0x0000001f ; 
        tempdata = tempdata | (data << 25) ;
        IOWR_ALTERA_AVALON_PIO_DATA(ROW765WRITE_BASE, tempdata) ;
       }
       else if (*count == 29)
       {
        tempdata = IORD_ALTERA_AVALON_PIO_DATA(ROW765READ_BASE) ;
        tempdata = tempdata & 0xfe0fffff ; 
        data = data & 0x0000001f ; 
        tempdata = tempdata | (data << 20) ;
        IOWR_ALTERA_AVALON_PIO_DATA(ROW765WRITE_BASE, tempdata) ;
       }
       
       //************************************
      else if(*count == 30)
       {
        tempdata = IORD_ALTERA_AVALON_PIO_DATA(ROW432READ_BASE) ;
        tempdata = tempdata & 0xfffffC1f ; 
        data = data & 0x0000001f ; 
        tempdata = tempdata | (data << 5) ;
        IOWR_ALTERA_AVALON_PIO_DATA(ROW432WRITE_BASE, tempdata) ;
       }
       else if (*count == 31)
       {
        tempdata = IORD_ALTERA_AVALON_PIO_DATA(ROW432READ_BASE) ;
        tempdata = tempdata & 0xffffffe0 ; 
        data = data & 0x0000001f ; 
        tempdata = tempdata |  data ;
        IOWR_ALTERA_AVALON_PIO_DATA(ROW432WRITE_BASE, tempdata) ;
       }
       else if (*count == 32)
       {
        tempdata = IORD_ALTERA_AVALON_PIO_DATA(ROW432READ_BASE) ;
        tempdata = tempdata & 0xfff07fff ; 
        data = data & 0x0000001f ; 
        tempdata = tempdata | (data  << 15) ;
        IOWR_ALTERA_AVALON_PIO_DATA(ROW432WRITE_BASE, tempdata) ;
          
       }
       else if (*count == 33)
       {
        tempdata = IORD_ALTERA_AVALON_PIO_DATA(ROW432READ_BASE) ;
        tempdata = tempdata & 0xffff83ff ; 
        data = data & 0x0000001f ; 
        tempdata = tempdata | (data << 10) ;
        IOWR_ALTERA_AVALON_PIO_DATA(ROW432WRITE_BASE, tempdata) ;
       }
       else if (*count == 34)
       {
        tempdata = IORD_ALTERA_AVALON_PIO_DATA(ROW432READ_BASE) ;
        tempdata = tempdata & 0x01ffffff ; 
        data = data & 0x0000001f ; 
        tempdata = tempdata | (data << 25) ;
        IOWR_ALTERA_AVALON_PIO_DATA(ROW432WRITE_BASE, tempdata) ;
       }
       else if (*count == 35)
       {
        tempdata = IORD_ALTERA_AVALON_PIO_DATA(ROW432READ_BASE) ;
        tempdata = tempdata & 0xfe0fffff ; 
        data = data & 0x0000001f ; 
        tempdata = tempdata | (data << 20) ;
        IOWR_ALTERA_AVALON_PIO_DATA(ROW432WRITE_BASE, tempdata) ;
       }
       
       //*****************************************************************
       
       else if (*count == 36)
       {
        *count = 36 ;
       }
       
        
    *count = *count + 1 ; 
    }
  }
  
  


int main(void)
{
    char spcount1, spcount2 , spcount3, spcount4 ; 
    int score_lines = 0 ; 
    volatile int count ;
    count = 0 ; 
    volatile int othermadeline ; 
    
    int edgeregister =  0 ; 
    int previouscount = 0 ; 
    int currentcount = 0 ; 
    int w  , cgover;
    
    char boardgrid[20][10] , tempgrid[20][10] , tempgrid1[20][10] , tempgrid2[20][10];
    int i , j ;
    for (i = 0 ; i < 20 ; i++)          //initializing the grid before the game starts
    {
        for(j = 0 ; j < 10 ; j++)
        {
            boardgrid[i][j] = 0 ;
            tempgrid [i][j] = 0 ;
        }
    }
   
    //printf("hello world \n") ;
    initializescreen();
    int gameover = 0 ; 
    int random = rand() % 7  ; 
     
    struct tetris_piece current_blk , uu , current_blk1;
    
    current_blk.c1.x = piecessprites[random][0] ;
    current_blk.c1.y = piecessprites[random][1] ;
    current_blk.c2.x = piecessprites[random][2] ;
    current_blk.c2.y = piecessprites[random][3] ;
    current_blk.c3.x = piecessprites[random][4] ;
    current_blk.c3.y = piecessprites[random][5] ;
    current_blk.c4.x = piecessprites[random][6] ;
    current_blk.c4.y = piecessprites[random][7] ;
    current_blk.type = piecessprites[random][8] ;
    current_blk.state =piecessprites[random][9] ;
    current_blk.color =piecessprites[random][10] ;
    
    current_blk1 = current_blk ;
   
   
   //**********************************************************************
   //********************serial port stuff*********************************
   volatile int flag ; 
   alt_irq_register(UART1_IRQ, (void*)&count, serialinterrupt );

    
   
   
   //*******************main loop *****************************************
   
     while(gameover == 0)
     {

    //assigning the initial piece
    current_blk = current_blk1 ;
    
    random = rand() % 7; 
    
    current_blk1.c1.x = piecessprites[random][0] ;
    current_blk1.c1.y = piecessprites[random][1] ;
    current_blk1.c2.x = piecessprites[random][2] ;
    current_blk1.c2.y = piecessprites[random][3] ;
    current_blk1.c3.x = piecessprites[random][4] ;
    current_blk1.c3.y = piecessprites[random][5] ;
    current_blk1.c4.x = piecessprites[random][6] ;
    current_blk1.c4.y = piecessprites[random][7] ;
    current_blk1.type = piecessprites[random][8] ;
    current_blk1.state =piecessprites[random][9] ;
    current_blk1.color =piecessprites[random][10] ;
        
    draw(current_blk); 
    
    //have to draw the next piece to come 
    //*****************************************
    
    clearnextpiecearea();
    drawnextpiece (current_blk1) ;
    
    char collison = 0  ;
    while (collison != 1)
    {
        int response ;
        for(response = 0 ; response < 30 ; response++)
        {
            
        
        edgeregister = IORD_ALTERA_AVALON_PIO_DATA(KEYBOARDSCANCODE_BASE);
        previouscount = currentcount ;
        currentcount = IORD_ALTERA_AVALON_PIO_DATA(KEYCOUNTER_BASE);
        
        //resetting in case some keystroke got carried over
            if(response == 0)
            {
                currentcount = previouscount ; 
            }
       
       
       //printf("the keyboard code is %x \n" , edgeregister) ; 
        
        if(currentcount > previouscount)        //read the keyboard
            {
                if((edgeregister == 0xebf060) | (edgeregister == 0x60eb60) | (edgeregister == 0xeb60eb))//0xe0f06b)               //left 
                { 
                    uu = moveleft(current_blk) ;  
                } 
                else if((edgeregister == 0xe4f070) | (edgeregister == 0x70e470) | (edgeregister == 0xe470e4))//0xe0f074)  //right
                {
                    uu = moveright(current_blk);   
                }           
                else if((edgeregister == 0xe5f070) | (edgeregister == 0x70e570) | (edgeregister == 0xe570e5)) //0xe0f075)  //up
                {
                    uu = rotate(current_blk);
                }
                else if((edgeregister == 0xe2f070) | (edgeregister == 0x70e270) | (edgeregister == 0xe270e2))                       //down
               {
                    uu = movedown(current_blk);
                    uu = movedown(uu) ;
               } 
                 else if(edgeregister == 0x29f920)//((edgeregister == 0xe2f070) | (edgeregister == 0x70e270) | (edgeregister == 0xe270e2) )//0x29f029)   //spacebar
                {
                   //have to move the piece down to the lowest possible coordinates
                    struct coordinate g1 , g2 , g3 , g4 ; 
                    g1 = coord_change(current_blk.c1);
                    g2 = coord_change(current_blk.c2);
                    g3 = coord_change(current_blk.c3);
                    g4 = coord_change(current_blk.c4);
                    
                    //need to keep track of how many we move down for each of the coordinates
                    
                    spcount1 = 0 ; 
                    spcount2 = 0 ; 
                    spcount3 = 0 ; 
                    spcount4 = 0 ; 
                    
                    
                    while( (tempgrid[g1.x + 1][g1.y] != 1) && (g1.x < 19))
                    {
                        g1.x = g1.x + 1 ;
                        spcount1 = spcount1 + 1 ; 
                    }
                    
                    while( (tempgrid[g2.x + 1][g2.y] != 1) && (g2.x < 19))
                    {
                        g2.x = g2.x + 1 ;
                        spcount2 = spcount2 + 1 ; 
                    }
                    
                    while( (tempgrid[g3.x + 1][g3.y] != 1) && (g3.x < 19))
                    {
                        g3.x = g3.x + 1 ;
                        spcount3= spcount3 + 1 ; 
                    }
                    
                    while( (tempgrid[g4.x + 1][g4.y] != 1) && (g4.x < 19))
                    {
                        g4.x = g4.x + 1 ;
                        spcount4 = spcount4 + 1 ; 
                    }
                    
                    char min_x_down_allowed ; 
                    min_x_down_allowed = spcount1 ;
                    if (spcount2 < min_x_down_allowed) min_x_down_allowed = spcount2 ;
                    if (spcount3 < min_x_down_allowed) min_x_down_allowed = spcount3 ;
                    if (spcount4 < min_x_down_allowed) min_x_down_allowed = spcount4 ;
                    
                    //printf("the min count %d \n" , min_x_down_allowed) ;
                    
                    uu = current_blk ; 
                    uu.c1.y = uu.c1.y  + 20 * min_x_down_allowed ; 
                    uu.c2.y = uu.c2.y  + 20 * min_x_down_allowed ; 
                    uu.c3.y = uu.c3.y  + 20 * min_x_down_allowed ; 
                    uu.c4.y = uu.c4.y  + 20 * min_x_down_allowed ; 
                    
                   
                    
                } 
                
                
                       
              
                //have seen if what the next piece might be 
                //now to check if the corrdinates are already full the move is illegal
                struct coordinate g1 , g2 , g3 , g4 ; 
                g1 = coord_change(uu.c1);
                g2 = coord_change(uu.c2);
                g3 = coord_change(uu.c3);
                g4 = coord_change(uu.c4);
                
                //check if gris already occupied
                if( (tempgrid[g1.x][g1.y] == 1) || (tempgrid[g2.x][g2.y] == 1) ||(tempgrid[g3.x][g3.y] == 1) 
                    || (tempgrid[g4.x][g4.y] == 1) )
                {
                    //the grid is already occupied.Dont update the piece
                   // printf("11111111111111111111\n") ;
                    uu = current_blk ;
                }
                //now check if any of the coordinates are outside the boundaries
                else if( ((uu.c1.x < 70) || (uu.c2.x < 70) || (uu.c3.x < 70) || (uu.c4.x < 70))
                        || ((uu.c1.x > 250) || (uu.c2.x >250) || (uu.c3.x > 250) || (uu.c4.x > 250))  )
                {
                    //the piece might go outside the left and right edge
                    //printf("222222222222222222222\n") ;
                    uu = current_blk ;
                }
                else if (((uu.c1.y < 50) || (uu.c2.y < 50) || (uu.c3.y < 50) || (uu.c4.y < 50))
                        || ((uu.c1.y > 430) || (uu.c2.y > 430) || (uu.c3.y > 430) || (uu.c4.y > 430)))
                {
                     //the piece might go outside the top and bottom edges
                    // printf("333333333333333333333\n") ;
                    uu = current_blk ;
                }
                else
                {
                    //can draw based on the input 
                    //printf("44444444444444444444444\n") ;
                    drawpiece_tnext(current_blk , uu) ;
                    
                    current_blk = uu ; 
                }
                int u ; 
                for (u = 0 ; u < 60 ; u++)
                    {
                      delay2();
                    }

            } //have ended reading from the keyboard
            
            
        }
           //****************************Read from keyboard again***************************************************************
           
            
           
           
           
           
           
            //if there is a collison set collision to 1 set the tempgrid bits
            //there is a collision if the grid bits are set at y below or the lowest 
            //y is already the bottom
           
            //first check if the y lowest on the grid is already at the bottom 
            unsigned short int max_y ; 
            max_y = current_blk.c1.y ; 
            if (current_blk.c2.y > max_y) max_y = current_blk.c2.y ; 
            if (current_blk.c3.y > max_y) max_y = current_blk.c3.y ; 
            if (current_blk.c4.y > max_y) max_y = current_blk.c4.y ;
           
           //**********************************************
           //******need to see if there is a collison with anything on the grid
           int ymax1 , tempxcoord , c1set , c2set, c3set , c4set; 
           c1set =  0 ; 
           c2set =  0 ;
           c3set =  0 ;
           c4set =  0 ;
           struct coordinate yy1 , yyy1  ; 
           tempxcoord = current_blk.c1.x ; 
           
           ymax1  = current_blk.c1.y ; 
           if ( (current_blk.c2.y > ymax1) && (current_blk.c2.x == tempxcoord)) ymax1 = current_blk.c2.y ; 
           if ( (current_blk.c3.y > ymax1) && (current_blk.c3.x == tempxcoord)) ymax1 = current_blk.c3.y ; 
           if ( (current_blk.c4.y > ymax1) && (current_blk.c4.x == tempxcoord)) ymax1 = current_blk.c4.y ; 
           yy1.x = tempxcoord ; 
           yy1.y = ymax1 + 20 ; 
           yyy1  = coord_change(yy1) ;
           if( tempgrid[yyy1.x][yyy1.y] == 1) c1set = 1 ; 
           
           tempxcoord = current_blk.c2.x ; 
           
           ymax1  = current_blk.c2.y ; 
           if ( (current_blk.c1.y > ymax1) && (current_blk.c1.x == tempxcoord)) ymax1 = current_blk.c1.y ; 
           if ( (current_blk.c3.y > ymax1) && (current_blk.c3.x == tempxcoord)) ymax1 = current_blk.c3.y ; 
           if ( (current_blk.c4.y > ymax1) && (current_blk.c4.x == tempxcoord)) ymax1 = current_blk.c4.y ; 
           yy1.x = tempxcoord ; 
           yy1.y = ymax1 + 20 ; 
           yyy1  = coord_change(yy1) ;
           if( tempgrid[yyy1.x][yyy1.y] == 1) c2set = 1 ; 
           
           tempxcoord = current_blk.c3.x ; 
           
           ymax1  = current_blk.c3.y ; 
           if ( (current_blk.c1.y > ymax1) && (current_blk.c1.x == tempxcoord)) ymax1 = current_blk.c1.y ; 
           if ( (current_blk.c2.y > ymax1) && (current_blk.c2.x == tempxcoord)) ymax1 = current_blk.c2.y ; 
           if ( (current_blk.c4.y > ymax1) && (current_blk.c4.x == tempxcoord)) ymax1 = current_blk.c4.y ; 
           yy1.x = tempxcoord ; 
           yy1.y = ymax1 + 20 ; 
           yyy1  = coord_change(yy1) ;
           if( tempgrid[yyy1.x][yyy1.y] == 1) c3set = 1 ; 
           
           tempxcoord = current_blk.c4.x ; 
           
           ymax1  = current_blk.c4.y ; 
           if ( (current_blk.c1.y > ymax1) && (current_blk.c1.x == tempxcoord)) ymax1 = current_blk.c1.y ; 
           if ( (current_blk.c2.y > ymax1) && (current_blk.c2.x == tempxcoord)) ymax1 = current_blk.c2.y ; 
           if ( (current_blk.c3.y > ymax1) && (current_blk.c3.x == tempxcoord)) ymax1 = current_blk.c3.y ; 
           yy1.x = tempxcoord ; 
           yy1.y = ymax1 + 20 ; 
           yyy1  = coord_change(yy1) ;
           if( tempgrid[yyy1.x][yyy1.y] == 1) c4set = 1 ; 
           

           
           //****************************************************************** 
           //*********actual body which checks the collison and sets the grid 
           
           if(max_y == 430)         //piece is at the bottom of the grid
           {
            //printf("at the bottom of the screen\n") ;
            //set the grid and update collison 
            collison = 1 ; 
            struct coordinate f1 , f2 , f3 , f4 ; 
                f1 = coord_change(current_blk.c1);
                f2 = coord_change(current_blk.c2);
                f3 = coord_change(current_blk.c3);
                f4 = coord_change(current_blk.c4);
                tempgrid[f1.x][f1.y] = 1 ; 
                tempgrid[f2.x][f2.y] = 1 ; 
                tempgrid[f3.x][f3.y] = 1 ; 
                tempgrid[f4.x][f4.y] = 1 ;     
           }
           else if((c4set + c3set + c2set + c1set) > 0 )        //checking for if the there is grid point set underneath the piece 
           {
            collison = 1 ; 
            struct coordinate f1 , f2 , f3 , f4 ; 
                f1 = coord_change(current_blk.c1);
                f2 = coord_change(current_blk.c2);
                f3 = coord_change(current_blk.c3);
                f4 = coord_change(current_blk.c4);
                tempgrid[f1.x][f1.y] = 1 ; 
                tempgrid[f2.x][f2.y] = 1 ; 
                tempgrid[f3.x][f3.y] = 1 ; 
                tempgrid[f4.x][f4.y] = 1 ;   
           }
           else
           {
            uu = movedown(current_blk);
            drawpiece_tnext(current_blk , uu) ;
            delay1();  

           }
            
                 
             current_blk = uu ;       //updating for  next iteration of the loop in case the piece moved      
       
  
    } //have ended the collison loop 
   

    
    //************************************************************
    //**********have to update the matrix with lines gone 
    
   
    
    int r , c , t , sum;
    r = 19 ;
    t = 0 ; 
 
    sum = 0 ;
    for (i = 19 ; i >= 0  ; i--)
    {
        for (j = 0 ; j < 10 ; j++)
        {
            sum = sum + tempgrid[i][j] ;
        }
        if(sum == 10)
        {
        t = t + 1 ;
        }
        else  //if not all one copy the row to new updated array
        {
        for (c = 0 ; c < 10 ; c++)
            {
            tempgrid1[r][c] = tempgrid[i][c] ;
            }
            r = r - 1 ;
        }
        sum = 0 ;
    }
   
   
    for (i = 0 ; i < t ; i++)
    {
        for(j = 0 ; j < 10 ; j++)
        {
        tempgrid1[i][j] = 0 ;
        }
    }
    
    //******************************************************
    //*****************update the score*********************
    score_lines = score_lines + t ; 
    //printf("the score is %d\n" , score_lines) ; 
    IOWR_ALTERA_AVALON_PIO_DATA(SCOREOFPLAYER_BASE,score_lines);
    
    //***************************************
    //this section generates the random line 
    othermadeline = IORD_ALTERA_AVALON_PIO_DATA(OTHERMADELINEREAD_BASE) ;
    if(othermadeline > 3)
    {
        int p , o ;
        for (o = 0 ; o < 10 ; o++)
        {
            tempgrid2[16][o] = rand()%2 ;
            tempgrid2[17][o] = rand()%2 ;
            tempgrid2[18][o] = rand()%2 ;
            tempgrid2[19][o] = rand()%2 ;
        }
        for(p = 15 ; p >= 0 ; p--)
        {
            for (o = 0 ; o < 10 ; o++)
            {
                tempgrid2[p][o] = tempgrid1[p+4][o] ;
            }
        }
        
        for(p = 19 ; p >= 0 ; p--)
        {
            for (o = 0 ; o < 10 ; o++)
            {
                tempgrid1[p][o] = tempgrid2[p][o] ;
            }
        }
        IOWR_ALTERA_AVALON_PIO_DATA(OTHERMADELINEWRITE_BASE , 0) ;
    }
    else if(othermadeline == 3 )
    {
        int p , o ;
        for (o = 0 ; o < 10 ; o++)
        {
            tempgrid2[17][o] = rand()%2 ;
            tempgrid2[18][o] = rand()%2 ;
            tempgrid2[19][o] = rand()%2 ;
        }
        for(p = 16 ; p >= 0 ; p--)
        {
            for (o = 0 ; o < 10 ; o++)
            {
                tempgrid2[p][o] = tempgrid1[p+3][o] ;
            }
        }
        
        for(p = 19 ; p >= 0 ; p--)
        {
            for (o = 0 ; o < 10 ; o++)
            {
                tempgrid1[p][o] = tempgrid2[p][o] ;
            }
        }
        IOWR_ALTERA_AVALON_PIO_DATA(OTHERMADELINEWRITE_BASE , 0) ;
    }
    else if(othermadeline == 2 )
    {
        int p , o ;
        for (o = 0 ; o < 10 ; o++)
        {
            tempgrid2[18][o] = rand()%2 ;
            tempgrid2[19][o] = rand()%2 ;
        }
        for(p = 17 ; p >= 0 ; p--)
        {
            for (o = 0 ; o < 10 ; o++)
            {
                tempgrid2[p][o] = tempgrid1[p+2][o] ;
            }
        }
        
        for(p = 19 ; p >= 0 ; p--)
        {
            for (o = 0 ; o < 10 ; o++)
            {
                tempgrid1[p][o] = tempgrid2[p][o] ;
            }
        }
        IOWR_ALTERA_AVALON_PIO_DATA(OTHERMADELINEWRITE_BASE , 0) ;
    }
    else if (othermadeline == 1)            //go up by one line
    {
        int p , o ;
        for (o = 0 ; o < 10 ; o++)
        {
            tempgrid2[19][o] = rand()%2 ;
        }
        for(p = 18 ; p >= 0 ; p--)
        {
            for (o = 0 ; o < 10 ; o++)
            {
                tempgrid2[p][o] = tempgrid1[p+1][o] ;
            }
        }
        
        for(p = 19 ; p >= 0 ; p--)
        {
            for (o = 0 ; o < 10 ; o++)
            {
                tempgrid1[p][o] = tempgrid2[p][o] ;
            }
        }
        IOWR_ALTERA_AVALON_PIO_DATA(OTHERMADELINEWRITE_BASE , 0) ;
    }
  
  /*
   int d , s ; 
   for (d = 16 ; d < 20 ; d++)
    {
        for(s = 0 ; s < 10 ; s++)
        {
        printf( " %d " , tempgrid[d][s] ) ;
        }
        printf("\n");
    }
    
     for (d = 16 ; d < 20 ; d++)
    {
        for(s = 0 ; s < 10 ; s++)
        {
        printf( " %d " , tempgrid1[d][s] ) ;
        }
        printf("\n");
    }
  */
  
  //****************************************************************************************
  //*******Now we have the updated grid.We have to check what differences there are between
  //*******the the boardgrid and the tempgrid1 and draw accordingly. Then update the 
  //*******board grid and the tempgrid arrays
   int d , s ; 
   for (d = 0 ; d < 20 ; d++)
   {
    for (s = 0 ; s < 10 ; s++)
    {
        if(tempgrid[d][s] == tempgrid1[d][s])
        {
            //dont have to do anything as the blocks are the same
        }
        else
        {
            if(tempgrid[d][s] == 1)
            {
                createunit(20*s + 70 , 20*d + 50 , 0 );
                tempgrid[d][s] = 0 ;
            }
            else
            {
                createunit(20*s + 70 , 20*d + 50 , 50 );
                tempgrid[d][s] = 1 ;
            }
        }
    }
   }
   
   
   
   
   //*******************************************************************************
   //********************sending through the serial port****************************
   unsigned char row19_1 , row19_2 , row18_1 , row18_2 , row17_1 , row17_2 , row16_1 , row16_2 , row15_1 , row15_2,
                 row14_1 , row14_2 , row13_1 , row13_2 , row12_1 , row12_2 , row11_1 , row11_2 , row10_1 , row10_2,
                 row9_1 , row9_2 , row8_1 , row8_2 , row7_1 , row7_2 , row6_1 , row6_2 , row5_1 , row5_2,
                 row4_1 , row4_2 , row3_1 , row3_2 , row2_1 , row2_2 , row1_1 , row1_2 , row0_1 , row0_2 ;
                 
       //initialize the gris to be sent          
   row19_1 = 0 ; 
   row19_2 = 0 ;  
   row18_1 = 0 ; 
   row18_2 = 0 ; 
   row17_1 = 0 ; 
   row17_2 = 0 ; 
   row16_1 = 0 ; 
   row16_2 = 0 ; 
   row15_1 = 0 ; 
   row15_2 = 0 ; 
   row14_1 = 0 ; 
   row14_2 = 0 ; 
   row13_1 = 0 ; 
   row13_2 = 0 ; 
   row12_1 = 0 ; 
   row12_2 = 0 ; 
   row11_1 = 0 ; 
   row11_2 = 0 ; 
   row10_1 = 0 ; 
   row10_2 = 0 ; 
   row9_1 = 0 ; 
   row9_2 = 0 ;  
   row8_1 = 0 ; 
   row8_2 = 0 ; 
   row7_1 = 0 ; 
   row7_2 = 0 ; 
   row6_1 = 0 ; 
   row6_2 = 0 ; 
   row5_1 = 0 ; 
   row5_2 = 0 ; 
   row4_1 = 0 ; 
   row4_2 = 0 ; 
   row3_1 = 0 ; 
   row3_2 = 0 ; 
   row2_1 = 0 ; 
   row2_2 = 0 ; 
   row1_1 = 0 ; 
   row1_2 = 0 ; 
   row0_1 = 0 ; 
   row0_2 = 0 ; 
   
    for (s = 0 ; s < 5 ; s++)
    {
       // printf(" tt %d \n " , tempgrid[19][s]) ; 
        row19_1 = (row19_1 << 1) | tempgrid[19][s] ;
        row19_2 = (row19_2 << 1) | tempgrid[19][s + 5] ;
        
        row18_1 = (row18_1 << 1) | tempgrid[18][s] ;
        row18_2 = (row18_2 << 1) | tempgrid[18][s + 5] ;
        
        row17_1 = (row17_1 << 1) | tempgrid[17][s] ;
        row17_2 = (row17_2 << 1) | tempgrid[17][s + 5] ;
        
        row16_1 = (row16_1 << 1) | tempgrid[16][s] ;
        row16_2 = (row16_2 << 1) | tempgrid[16][s + 5] ;
        
        row15_1 = (row15_1 << 1) | tempgrid[15][s] ;
        row15_2 = (row15_2 << 1) | tempgrid[15][s + 5] ;
        
        row14_1 = (row14_1 << 1) | tempgrid[14][s] ;
        row14_2 = (row14_2 << 1) | tempgrid[14][s + 5] ;
        
        row13_1 = (row13_1 << 1) | tempgrid[13][s] ;
        row13_2 = (row13_2 << 1) | tempgrid[13][s + 5] ;
        
        row12_1 = (row12_1 << 1) | tempgrid[12][s] ;
        row12_2 = (row12_2 << 1) | tempgrid[12][s + 5] ;
        
        row11_1 = (row11_1 << 1) | tempgrid[11][s] ;
        row11_2 = (row11_2 << 1) | tempgrid[11][s + 5] ;
        
        row10_1 = (row10_1 << 1) | tempgrid[10][s] ;
        row10_2 = (row10_2 << 1) | tempgrid[10][s + 5] ;
        
        row9_1 = (row9_1 << 1) | tempgrid[9][s] ;
        row9_2 = (row9_2 << 1) | tempgrid[9][s + 5] ;
        
        row8_1 = (row8_1 << 1) | tempgrid[8][s] ;
        row8_2 = (row8_2 << 1) | tempgrid[8][s + 5] ;
        
        row7_1 = (row7_1 << 1) | tempgrid[7][s] ;
        row7_2 = (row7_2 << 1) | tempgrid[7][s + 5] ;
        
        row6_1 = (row6_1 << 1) | tempgrid[6][s] ;
        row6_2 = (row6_2 << 1) | tempgrid[6][s + 5] ;
        
        row5_1 = (row5_1 << 1) | tempgrid[5][s] ;
        row5_2 = (row5_2 << 1) | tempgrid[5][s + 5] ;
        
        row4_1 = (row4_1 << 1) | tempgrid[4][s] ;
        row4_2 = (row4_2 << 1) | tempgrid[4][s + 5] ;
        
        row3_1 = (row3_1 << 1) | tempgrid[3][s] ;
        row3_2 = (row3_2 << 1) | tempgrid[3][s + 5] ;
        
        row2_1 = (row2_1 << 1) | tempgrid[2][s] ;
        row2_2 = (row2_2 << 1) | tempgrid[2][s + 5] ;
        
        row1_1 = (row1_1 << 1) | tempgrid[1][s] ;
        row1_2 = (row1_2 << 1) | tempgrid[1][s + 5] ;
        
        row0_1 = (row0_1 << 1) | tempgrid[0][s] ;
        row0_2 = (row0_2 << 1) | tempgrid[0][s + 5] ;
    }
   
   //printf("row19_1 is %x \n " , row19_1) ;
   
   
   
   IOWR_ALTERA_AVALON_UART_TXDATA(UART1_BASE, row19_1) ;
   while((IORD_ALTERA_AVALON_UART_STATUS(UART1_BASE) & 0x040) != 0x040)
   { ;}
   IOWR_ALTERA_AVALON_UART_TXDATA(UART1_BASE, row19_2) ;
   while((IORD_ALTERA_AVALON_UART_STATUS(UART1_BASE) & 0x040) != 0x040)
   { ;}
   
   IOWR_ALTERA_AVALON_UART_TXDATA(UART1_BASE, row18_1) ;
   while((IORD_ALTERA_AVALON_UART_STATUS(UART1_BASE) & 0x040) != 0x040)
   { ;}
   IOWR_ALTERA_AVALON_UART_TXDATA(UART1_BASE, row18_2) ;
   while((IORD_ALTERA_AVALON_UART_STATUS(UART1_BASE) & 0x040) != 0x040)
   { ;}
   
   IOWR_ALTERA_AVALON_UART_TXDATA(UART1_BASE, row17_1) ;
   while((IORD_ALTERA_AVALON_UART_STATUS(UART1_BASE) & 0x040) != 0x040)
   { ;}
   IOWR_ALTERA_AVALON_UART_TXDATA(UART1_BASE, row17_2) ;
   while((IORD_ALTERA_AVALON_UART_STATUS(UART1_BASE) & 0x040) != 0x040)
   { ;}
   
   IOWR_ALTERA_AVALON_UART_TXDATA(UART1_BASE, row16_1) ;
   while((IORD_ALTERA_AVALON_UART_STATUS(UART1_BASE) & 0x040) != 0x040)
   { ;}
   IOWR_ALTERA_AVALON_UART_TXDATA(UART1_BASE, row16_2) ;
   while((IORD_ALTERA_AVALON_UART_STATUS(UART1_BASE) & 0x040) != 0x040)
   { ;}
   
   IOWR_ALTERA_AVALON_UART_TXDATA(UART1_BASE, row15_1) ;
   while((IORD_ALTERA_AVALON_UART_STATUS(UART1_BASE) & 0x040) != 0x040)
   { ;}
   IOWR_ALTERA_AVALON_UART_TXDATA(UART1_BASE, row15_2) ;
   while((IORD_ALTERA_AVALON_UART_STATUS(UART1_BASE) & 0x040) != 0x040)
   { ;}
   
   IOWR_ALTERA_AVALON_UART_TXDATA(UART1_BASE, row14_1) ;
   while((IORD_ALTERA_AVALON_UART_STATUS(UART1_BASE) & 0x040) != 0x040)
   { ;}
   IOWR_ALTERA_AVALON_UART_TXDATA(UART1_BASE, row14_2) ;
   while((IORD_ALTERA_AVALON_UART_STATUS(UART1_BASE) & 0x040) != 0x040)
   { ;}
   
   IOWR_ALTERA_AVALON_UART_TXDATA(UART1_BASE, row13_1) ;
   while((IORD_ALTERA_AVALON_UART_STATUS(UART1_BASE) & 0x040) != 0x040)
   { ;}
   IOWR_ALTERA_AVALON_UART_TXDATA(UART1_BASE, row13_2) ;
   while((IORD_ALTERA_AVALON_UART_STATUS(UART1_BASE) & 0x040) != 0x040)
   { ;}
   
   IOWR_ALTERA_AVALON_UART_TXDATA(UART1_BASE, row12_1) ;
   while((IORD_ALTERA_AVALON_UART_STATUS(UART1_BASE) & 0x040) != 0x040)
   { ;}
   IOWR_ALTERA_AVALON_UART_TXDATA(UART1_BASE, row12_2) ;
   while((IORD_ALTERA_AVALON_UART_STATUS(UART1_BASE) & 0x040) != 0x040)
   { ;}
   
   IOWR_ALTERA_AVALON_UART_TXDATA(UART1_BASE, row11_1) ;
   while((IORD_ALTERA_AVALON_UART_STATUS(UART1_BASE) & 0x040) != 0x040)
   { ;}
   IOWR_ALTERA_AVALON_UART_TXDATA(UART1_BASE, row11_2) ;
   while((IORD_ALTERA_AVALON_UART_STATUS(UART1_BASE) & 0x040) != 0x040)
   { ;}
   
   IOWR_ALTERA_AVALON_UART_TXDATA(UART1_BASE, row10_1) ;
   while((IORD_ALTERA_AVALON_UART_STATUS(UART1_BASE) & 0x040) != 0x040)
   { ;}
   IOWR_ALTERA_AVALON_UART_TXDATA(UART1_BASE, row10_2) ;
   while((IORD_ALTERA_AVALON_UART_STATUS(UART1_BASE) & 0x040) != 0x040)
   { ;}
   
   IOWR_ALTERA_AVALON_UART_TXDATA(UART1_BASE, row9_1) ;
   while((IORD_ALTERA_AVALON_UART_STATUS(UART1_BASE) & 0x040) != 0x040)
   { ;}
   IOWR_ALTERA_AVALON_UART_TXDATA(UART1_BASE, row9_2) ;
   while((IORD_ALTERA_AVALON_UART_STATUS(UART1_BASE) & 0x040) != 0x040)
   { ;}
   
   IOWR_ALTERA_AVALON_UART_TXDATA(UART1_BASE, row8_1) ;
   while((IORD_ALTERA_AVALON_UART_STATUS(UART1_BASE) & 0x040) != 0x040)
   { ;}
   IOWR_ALTERA_AVALON_UART_TXDATA(UART1_BASE, row8_2) ;
   while((IORD_ALTERA_AVALON_UART_STATUS(UART1_BASE) & 0x040) != 0x040)
   { ;}
   
   IOWR_ALTERA_AVALON_UART_TXDATA(UART1_BASE, row7_1) ;
   while((IORD_ALTERA_AVALON_UART_STATUS(UART1_BASE) & 0x040) != 0x040)
   { ;}
   IOWR_ALTERA_AVALON_UART_TXDATA(UART1_BASE, row7_2) ;
   while((IORD_ALTERA_AVALON_UART_STATUS(UART1_BASE) & 0x040) != 0x040)
   { ;}
   
   IOWR_ALTERA_AVALON_UART_TXDATA(UART1_BASE, row6_1) ;
   while((IORD_ALTERA_AVALON_UART_STATUS(UART1_BASE) & 0x040) != 0x040)
   { ;}
   IOWR_ALTERA_AVALON_UART_TXDATA(UART1_BASE, row6_2) ;
   while((IORD_ALTERA_AVALON_UART_STATUS(UART1_BASE) & 0x040) != 0x040)
   { ;}
   
   
   IOWR_ALTERA_AVALON_UART_TXDATA(UART1_BASE, row5_1) ;
   while((IORD_ALTERA_AVALON_UART_STATUS(UART1_BASE) & 0x040) != 0x040)
   { ;}
   IOWR_ALTERA_AVALON_UART_TXDATA(UART1_BASE, row5_2) ;
   while((IORD_ALTERA_AVALON_UART_STATUS(UART1_BASE) & 0x040) != 0x040)
   { ;}
   
   IOWR_ALTERA_AVALON_UART_TXDATA(UART1_BASE, row4_1) ;
   while((IORD_ALTERA_AVALON_UART_STATUS(UART1_BASE) & 0x040) != 0x040)
   { ;}
   IOWR_ALTERA_AVALON_UART_TXDATA(UART1_BASE, row4_2) ;
   while((IORD_ALTERA_AVALON_UART_STATUS(UART1_BASE) & 0x040) != 0x040)
   { ;}
   
   IOWR_ALTERA_AVALON_UART_TXDATA(UART1_BASE, row3_1) ;
   while((IORD_ALTERA_AVALON_UART_STATUS(UART1_BASE) & 0x040) != 0x040)
   { ;}
   IOWR_ALTERA_AVALON_UART_TXDATA(UART1_BASE, row3_2) ;
   while((IORD_ALTERA_AVALON_UART_STATUS(UART1_BASE) & 0x040) != 0x040)
   { ;}
   
   IOWR_ALTERA_AVALON_UART_TXDATA(UART1_BASE, row2_1) ;
   while((IORD_ALTERA_AVALON_UART_STATUS(UART1_BASE) & 0x040) != 0x040)
   { ;}
   IOWR_ALTERA_AVALON_UART_TXDATA(UART1_BASE, row2_2) ;
     while((IORD_ALTERA_AVALON_UART_STATUS(UART1_BASE) & 0x040) != 0x040)
   { ;}
   
   
   IOWR_ALTERA_AVALON_UART_TXDATA(UART1_BASE, 0xff) ;
   while((IORD_ALTERA_AVALON_UART_STATUS(UART1_BASE) & 0x040) != 0x040)
   { ;}
   
   
   //this is the numbers of lines cleared
   IOWR_ALTERA_AVALON_UART_TXDATA(UART1_BASE, t) ;
        
   
   
   //********************************************************************************
   //check if the top row of the gris is full and stop the loop. Basically game over
       cgover = 0 ;
       for (w = 0 ; w < 10 ; w++)
       {
        cgover = cgover + tempgrid[1][w] ;
       }
       if(cgover > 0 ) gameover = 1 ; 
       
       
       
       
 
     } //this is the end of the second while loop
    
    
    finalmessage();
   
    
}



