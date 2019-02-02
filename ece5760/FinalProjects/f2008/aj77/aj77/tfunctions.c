#include "system.h"
#include "sys/alt_irq.h"
#include "altera_avalon_pio_regs.h"
#include <stdio.h>


#define white 250

//******referenced the paint brush application project for next 2 functions and initializescreen**************
//*****************************************************************
//***************drive the buses for sram***********************
void writesram (unsigned int x ,unsigned int y ,unsigned int b )   
{
    IOWR_ALTERA_AVALON_PIO_DATA(OUTPUTXCOORD_BASE , x);
    IOWR_ALTERA_AVALON_PIO_DATA(OUTPUTYCOORD_BASE , y);
    IOWR_ALTERA_AVALON_PIO_DATA(OUTPUTSRAMDATA_BASE , b );
}

//*********************************************************
//makes sure that value is read before updating the coordinates
void delay()            
{
    int i,max;
    max = 150;
    for(i=0;i<max;i++);
}


//*******************************************************************
//******delay used for deciding speed of the falling block
void delay1()           
{
    long i ;
    long max;
    max =1000000;
    for(i=0;i<max;i++);
}


//********************************************************
void delay2()           
{
    long i ;
    long max;
    max =10000;
    for(i=0;i<max;i++);
}



//*************************************************************************
//initialize the screen with the tetris map to play on  

void initializescreen()
{
    unsigned int x,y,b;
    b = white ;
    b = (b << 8)| white ;
    for(y=0;y<480;y++) 
    {
        for(x=0;x<640;x=x+2)
        {
                if( ((x >= 60) && (x <= 260)) && ((y >= 40) && (y <= 440)) )
                {
                    writesram(x , y , 0) ;
                    delay() ;
                }
                else if( ((x >= 380) && (x <= 580)) && ((y >= 40) && (y <= 440)) )
                {
                    writesram(x , y , 0) ;
                    delay() ;
                }
                else if (((x >= 270) && (x <= 370)) && ((y >= 40) && (y <= 120)))
                {
                    writesram(x , y , 0) ;
                    delay() ;
                }
                else if (((x >= 270) && (x <= 370)) && ((y >= 140) && (y <= 300)))
                {
                    writesram(x , y , 0) ;
                    delay() ;
                }
                else
                {
                    writesram(x ,y , b);
                    delay() ;
                }
        }
    }
} 


//creates unit given the coordinate of the biddle of a blocks
void createunit(unsigned int x ,unsigned int y , unsigned int color )
{
    unsigned int i , j , b ;
    b = color ;
    b = (b << 8)| color  ;
     for(j = y - 10; j <= y + 9 ; j++) 
    {
        for(i = x - 10 ; i <= x + 9 ;i = i + 2)
        {
            if(((j == y - 10) || (j == y + 9) || (i == x - 10) || (i == x + 9)) && (b != 0 ) ) 
            {
                writesram ( i , j , b - 30 ) ;               
                delay() ;
            }
            else
            {
            writesram ( i , j , b ) ;               
            delay() ;
            }   
        }
    }   
}



//*************************************************
//**********Struct for a coordinate****************
struct coordinate
{
    unsigned short int x ;
    unsigned short int y ;
};



//*******************************************************************
//*************struct for a tetris block*****************************
struct tetris_piece
{
  struct coordinate c1 ;
  struct coordinate c2 ;
  struct coordinate c3 ;
  struct coordinate c4 ;
  unsigned short int type ;                //type of piece.Needed for appropriate rotation.
  unsigned short int state;                //needed to know what orientation the piece is in 
  unsigned short int color ;
};


//***********************************************************************
//***********Draw a tetris based on the struct as input****************
void draw(struct tetris_piece t1) 
{
    createunit(t1.c1.x , t1.c1.y , t1.color); 
    createunit(t1.c2.x , t1.c2.y , t1.color); 
    createunit(t1.c3.x , t1.c3.y , t1.color); 
    createunit(t1.c4.x , t1.c4.y , t1.color); 
}

//***********************************************************************
//***********Clear a tetris based on the struct as input****************
void clear(struct tetris_piece t1) 
{
    createunit(t1.c1.x , t1.c1.y , 0); 
    createunit(t1.c2.x , t1.c2.y , 0); 
    createunit(t1.c3.x , t1.c3.y , 0); 
    createunit(t1.c4.x , t1.c4.y , 0); 
}




//*******************************************************************************************************
//***********Draw a tetris based on the struct as input in the box showing the next piece****************
void drawnextpiece(struct tetris_piece t2) 
{
    createunit(t2.c1.x + 160 , t2.c1.y + 20, t2.color); 
    createunit(t2.c2.x + 160 , t2.c2.y + 20, t2.color); 
    createunit(t2.c3.x + 160 , t2.c3.y + 20, t2.color); 
    createunit(t2.c4.x + 160 , t2.c4.y + 20, t2.color); 
}

//*************************************************************************
//**********************move the piece down********************************
struct tetris_piece movedown(struct tetris_piece t3)
{
    struct tetris_piece temp ;
    temp.c1.x = t3.c1.x ;
    temp.c1.y = t3.c1.y + 20 ;
    temp.c2.x = t3.c2.x ;
    temp.c2.y = t3.c2.y + 20;
    temp.c3.x = t3.c3.x ;
    temp.c3.y = t3.c3.y + 20;
    temp.c4.x = t3.c4.x ;
    temp.c4.y = t3.c4.y + 20 ;
    temp.type = t3.type ; 
    temp.state = t3.state ; 
    temp.color = t3.color ;
    return temp ; 
}

//*************************************************************************
//**********Rotate the piece when up is pressed****************************
struct tetris_piece rotate(struct tetris_piece t4)
{
    struct tetris_piece temp ;
    unsigned short type  = t4.type ; 
    unsigned short state = t4.state ; 
    unsigned short newstate  ; 
    unsigned short newtype   ; 
    struct coordinate c1 ; 
    struct coordinate c2 ;
    struct coordinate c3 ;
    struct coordinate c4 ;
    
    if (type == 1)
    {
        //none of the coordinates would change and the state and type remain the same as well
        //just assigning the new fields using the current input fields of the block 
        //printf("this is a square\n");
        c1 = t4.c1 ;
        c2 = t4.c2 ;
        c3 = t4.c3 ;
        c4 = t4.c4 ;
        newstate = t4.state ; 
        newtype  = t4.type  ;
    }
    else if (type == 2)    //handle the rotation of a line 
    {
        //printf("this is a line\n");
        if (state == 0)             //line is horizontal
        {
            c1.x = t4.c1.x + 20 ;
            c1.y = t4.c1.y - 20 ; 
            c2   = t4.c2 ;                    //remains the same when the rotation happens
            c3.x = t4.c3.x - 20 ;
            c3.y = t4.c3.y + 20 ;
            c4.x = t4.c4.x - 40 ;             //shifts left by 2 
            c4.y = t4.c4.y + 40 ;             //goes down by 2 
            newstate = 1 ;                     //line is vertical
            newtype  = t4.type ;
           
        }
        else if (state == 1)                //line is vertical
        {
            c1.x = t4.c1.x - 20 ;
            c1.y = t4.c1.y + 20 ; 
            c2   = t4.c2 ;                    //remains the same
            c3.x = t4.c3.x + 20 ;
            c3.y = t4.c3.y - 20 ;
            c4.x = t4.c4.x + 40 ;             //
            c4.y = t4.c4.y - 40 ;             //
            newstate = 0 ;                     //line is horizontal
            newtype  = t4.type ;
            
        }
        
    }
    else if (type == 3)     //handle a Z shape here
    {
       // printf("this is a Z\n");
        if (state == 0)
        {
            c1.x = t4.c1.x + 20 ;
            c1.y = t4.c1.y - 20 ; 
            c2   = t4.c2 ;                    //remains the same
            c3.x = t4.c3.x - 20 ;
            c3.y = t4.c3.y - 20 ;
            c4.x = t4.c4.x - 40 ;             
            c4.y = t4.c4.y  ;             
            newstate = 1 ;                     //updating the state
            newtype  = t4.type ;
        }
        else if (state == 1)
        {
            c1.x = t4.c1.x - 20 ;
            c1.y = t4.c1.y + 20 ; 
            c2   = t4.c2 ;                    //remains the same
            c3.x = t4.c3.x + 20 ;
            c3.y = t4.c3.y + 20 ;
            c4.x = t4.c4.x + 40 ;             
            c4.y = t4.c4.y  ;             
            newstate = 0 ;                     //updating the state
            newtype  = t4.type ; 
        }
    }
    else if (type == 4)         //handle a S shape here
    {
        //printf("this is a S\n");
        if (state == 0)
        {
            c1.x = t4.c1.x - 20 ;
            c1.y = t4.c1.y - 20 ; 
            c2   = t4.c2 ;                    //remains the same
            c3.x = t4.c3.x + 20 ;
            c3.y = t4.c3.y - 20 ;
            c4.x = t4.c4.x + 40 ;             
            c4.y = t4.c4.y  ;             
            newstate = 1 ;                     //updating the state
            newtype  = t4.type ;
        }
        else if (state == 1)
        {
            c1.x = t4.c1.x + 20 ;
            c1.y = t4.c1.y + 20 ; 
            c2   = t4.c2 ;                    //remains the same
            c3.x = t4.c3.x - 20 ;
            c3.y = t4.c3.y + 20 ;
            c4.x = t4.c4.x - 40 ;             
            c4.y = t4.c4.y  ;             
            newstate = 0 ;                     //updating the state
            newtype  = t4.type ;
            
        }
    }
    else if (type == 5) 
    {
        //printf("this is a |---\n");
        if (state == 0)
        {
            c1.x = t4.c1.x  ;
            c1.y = t4.c1.y - 40 ; 
            c2.x = t4.c2.x + 20 ;
            c2.y = t4.c2.y - 20 ;                  
            c3   = t4.c3 ;                    //remains the same
            c4.x = t4.c4.x - 20 ;             
            c4.y = t4.c4.y + 20 ;             
            newstate = 1 ;                     //updating the state
            newtype  = t4.type ;
            
        }
        else if (state == 1)
        {
            c1.x = t4.c1.x + 40 ;
            c1.y = t4.c1.y  ; 
            c2.x = t4.c2.x + 20 ;
            c2.y = t4.c2.y + 20 ;                  
            c3   = t4.c3 ;                    //remains the same
            c4.x = t4.c4.x - 20 ;             
            c4.y = t4.c4.y - 20 ;             
            newstate = 2 ;                     //updating the state
            newtype  = t4.type ;
            
        }
        else if (state == 2)
        {
            c1.x = t4.c1.x  ;
            c1.y = t4.c1.y + 40 ; 
            c2.x = t4.c2.x - 20 ;
            c2.y = t4.c2.y + 20 ;                  
            c3   = t4.c3 ;                    //remains the same
            c4.x = t4.c4.x + 20 ;             
            c4.y = t4.c4.y - 20 ;             
            newstate = 3 ;                     //updating the state
            newtype  = t4.type ;
            
        }
        else if (state == 3)
        {
            c1.x = t4.c1.x - 40 ;
            c1.y = t4.c1.y  ; 
            c2.x = t4.c2.x - 20 ;
            c2.y = t4.c2.y - 20 ;                  
            c3   = t4.c3 ;                    //remains the same
            c4.x = t4.c4.x + 20 ;             
            c4.y = t4.c4.y + 20 ;              
            newstate = 0 ;                     //updating the state
            newtype  = t4.type ;
            
        }
    }
    else if (type == 6) 
    {
        //printf("this is a ---|\n");
        if (state == 0)
        {
            c1.x = t4.c1.x + 20 ;
            c1.y = t4.c1.y - 20 ; 
            c2   = t4.c2 ;                    //remains the same
            c3.x = t4.c3.x - 20 ;
            c3.y = t4.c3.y + 20 ;
            c4.x = t4.c4.x - 40 ;             
            c4.y = t4.c4.y  ;             
            newstate = 1 ;                     //updating the state
            newtype  = t4.type ; 
        }
        else if (state == 1)
        {
            c1.x = t4.c1.x + 20 ;
            c1.y = t4.c1.y + 20 ; 
            c2   = t4.c2 ;                    //remains the same
            c3.x = t4.c3.x - 20 ;
            c3.y = t4.c3.y - 20 ;
            c4.x = t4.c4.x  ;             
            c4.y = t4.c4.y - 40 ;             
            newstate = 2 ;                     //updating the state
            newtype  = t4.type ; 
        }
        else if (state == 2)
        {
            c1.x = t4.c1.x - 20 ;
            c1.y = t4.c1.y + 20 ; 
            c2   = t4.c2 ;                    //remains the same
            c3.x = t4.c3.x + 20 ;
            c3.y = t4.c3.y - 20 ;
            c4.x = t4.c4.x + 40 ;             
            c4.y = t4.c4.y  ;             
            newstate = 3 ;                     //updating the state
            newtype  = t4.type ;          
        }
        else if (state == 3)
        {
            c1.x = t4.c1.x - 20 ;
            c1.y = t4.c1.y - 20 ; 
            c2   = t4.c2 ;                    //remains the same
            c3.x = t4.c3.x + 20 ;
            c3.y = t4.c3.y + 20 ;
            c4.x = t4.c4.x  ;             
            c4.y = t4.c4.y + 40 ;             
            newstate = 0 ;                     //updating the state
            newtype  = t4.type ;    
        }
    }
    else if (type == 7) 
    {
        //printf("this is a T\n");
        if (state == 0)
        {
            c1.x = t4.c1.x + 20 ;
            c1.y = t4.c1.y - 20 ; 
            c2   = t4.c2 ;                    //remains the same
            c3.x = t4.c3.x - 20 ;
            c3.y = t4.c3.y - 20 ;
            c4.x = t4.c4.x - 20 ;             
            c4.y = t4.c4.y + 20 ;                
            newstate = 1 ;                     //updating the state
            newtype  = t4.type ;
        }
        else if (state == 1)
        {
            c1.x = t4.c1.x + 20 ;
            c1.y = t4.c1.y + 20 ; 
            c2   = t4.c2 ;                    //remains the same
            c3.x = t4.c3.x + 20 ;
            c3.y = t4.c3.y - 20 ;
            c4.x = t4.c4.x - 20 ;             
            c4.y = t4.c4.y - 20 ;             
            newstate = 2 ;                     //updating the state
            newtype  = t4.type ;
            
        }
        else if (state == 2)
        {
            c1.x = t4.c1.x - 20 ;
            c1.y = t4.c1.y + 20 ; 
            c2   = t4.c2 ;                    //remains the same
            c3.x = t4.c3.x + 20 ;
            c3.y = t4.c3.y + 20 ;
            c4.x = t4.c4.x + 20 ;             
            c4.y = t4.c4.y - 20 ;             
            newstate = 3 ;                     //updating the state
            newtype  = t4.type ;
            
        }
        else if (state == 3)
        {
            c1.x = t4.c1.x - 20 ;
            c1.y = t4.c1.y - 20 ; 
            c2   = t4.c2 ;                    //remains the same
            c3.x = t4.c3.x - 20 ;
            c3.y = t4.c3.y + 20 ;
            c4.x = t4.c4.x + 20 ;             
            c4.y = t4.c4.y + 20 ;             
            newstate = 0 ;                     //updating the state
            newtype  = t4.type ;
        }
    }
    
    temp.c1 = c1 ; 
    temp.c2 = c2 ;
    temp.c3 = c3 ;
    temp.c4 = c4 ;
    temp.type = newtype ;
    temp.state = newstate ;
    temp.color = t4.color ;

    return temp ; 
}

//*************************************************************************
//**********************move the piece left********************************
struct tetris_piece moveleft(struct tetris_piece t5)
{
    struct tetris_piece temp ;
    temp.c1.x = t5.c1.x - 20;
    temp.c1.y = t5.c1.y  ;
    temp.c2.x = t5.c2.x - 20;
    temp.c2.y = t5.c2.y ;
    temp.c3.x = t5.c3.x - 20;
    temp.c3.y = t5.c3.y ;
    temp.c4.x = t5.c4.x - 20;
    temp.c4.y = t5.c4.y  ;
    temp.type = t5.type ; 
    temp.state = t5.state ; 
    temp.color = t5.color ;
    return temp ; 
}

//*************************************************************************
//**********************move the piece right********************************
struct tetris_piece moveright(struct tetris_piece t6)
{
    struct tetris_piece temp ;
    temp.c1.x = t6.c1.x + 20;
    temp.c1.y = t6.c1.y  ;
    temp.c2.x = t6.c2.x + 20;
    temp.c2.y = t6.c2.y ;
    temp.c3.x = t6.c3.x + 20;
    temp.c3.y = t6.c3.y ;
    temp.c4.x = t6.c4.x + 20;
    temp.c4.y = t6.c4.y  ;
    temp.type = t6.type ; 
    temp.state = t6.state ; 
    temp.color = t6.color ;
    return temp ; 
}


//********************************************************************************//
//**********************function to clear area where next piece is**********************
void clearnextpiecearea()
{
    createunit( 280, 50, 0);
    createunit( 300, 50, 0);
    createunit( 320, 50, 0);
    createunit( 340, 50, 0);
    createunit( 360, 50, 0);
     createunit( 280, 70, 0);
    createunit( 300, 70, 0);
    createunit( 320, 70, 0);
    createunit( 340, 70, 0);
    createunit( 360, 70, 0);
     createunit( 280, 90, 0);
    createunit( 300, 90, 0);
    createunit( 320, 90, 0);
    createunit( 340, 90, 0);
    createunit( 360, 90, 0);
     createunit( 280, 110, 0);
    createunit( 300, 110, 0);
    createunit( 320, 110, 0);
    createunit( 340, 110, 0);
    createunit( 360, 110, 0);
  
}






//****************************************************************************************
//**********************function to draw just the no overlapping parts of two*************
//***********************tetris pieces in time clearing the previous**********************
void drawpiece_tnext(struct tetris_piece t1 , struct tetris_piece t2)
{
     if( ((t1.c1.x == t2.c1.x)&&(t1.c1.y == t2.c1.y)) ||  ((t1.c1.x == t2.c2.x)&&(t1.c1.y == t2.c2.y)) ||
          ((t1.c1.x == t2.c3.x)&&(t1.c1.y == t2.c3.y)) ||  ((t1.c1.x == t2.c4.x)&&(t1.c1.y == t2.c4.y)) ) {}
     else
     {  
     createunit(t1.c1.x , t1.c1.y , 0);  //clear that block as no overlap
     }
          
     if( ((t1.c2.x == t2.c1.x)&&(t1.c2.y == t2.c1.y)) ||  ((t1.c2.x == t2.c2.x)&&(t1.c2.y == t2.c2.y)) ||
          ((t1.c2.x == t2.c3.x)&&(t1.c2.y == t2.c3.y)) ||  ((t1.c2.x == t2.c4.x)&&(t1.c2.y == t2.c4.y)) ) {}
     else
     {  
     createunit(t1.c2.x , t1.c2.y , 0);  //clear that block as no overlap
     }
     
     if( ((t1.c3.x == t2.c1.x)&&(t1.c3.y == t2.c1.y)) ||  ((t1.c3.x == t2.c2.x)&&(t1.c3.y == t2.c2.y)) ||
          ((t1.c3.x == t2.c3.x)&&(t1.c3.y == t2.c3.y)) ||  ((t1.c3.x == t2.c4.x)&&(t1.c3.y == t2.c4.y)) ) {}
     else  
     {
        createunit(t1.c3.x , t1.c3.y , 0);  //clear that block as no overlap
     }
     
     if( ((t1.c4.x == t2.c1.x)&&(t1.c4.y == t2.c1.y)) ||  ((t1.c4.x == t2.c2.x)&&(t1.c4.y == t2.c2.y)) ||
          ((t1.c4.x == t2.c3.x)&&(t1.c4.y == t2.c3.y)) ||  ((t1.c4.x == t2.c4.x)&&(t1.c4.y == t2.c4.y)) ) {}
     else
     {  
     createunit(t1.c4.x , t1.c4.y , 0);  //clear that block as no overlap
     }
     
     //have removed any non overlapping pieces
     //now have to draw the non overlapping pieces
     
     if( ((t2.c1.x == t1.c1.x)&&(t2.c1.y == t1.c1.y)) ||  ((t2.c1.x == t1.c2.x)&&(t2.c1.y == t1.c2.y)) ||
          ((t2.c1.x == t1.c3.x)&&(t2.c1.y == t1.c3.y)) ||  ((t2.c1.x == t1.c4.x)&&(t2.c1.y == t1.c4.y)) ) {}
     else  createunit(t2.c1.x , t2.c1.y , t2.color);  //clear that block as no overlap
          
     if( ((t2.c2.x == t1.c1.x)&&(t2.c2.y == t1.c1.y)) ||  ((t2.c2.x == t1.c2.x)&&(t2.c2.y == t1.c2.y)) ||
          ((t2.c2.x == t1.c3.x)&&(t2.c2.y == t1.c3.y)) ||  ((t2.c2.x == t1.c4.x)&&(t2.c2.y == t1.c4.y)) ) {}
     else  createunit(t2.c2.x , t2.c2.y , t2.color);  //clear that block as no overlap
     
     if( ((t2.c3.x == t1.c1.x)&&(t2.c3.y == t1.c1.y)) ||  ((t2.c3.x == t1.c2.x)&&(t2.c3.y == t1.c2.y)) ||
          ((t2.c3.x == t1.c3.x)&&(t2.c3.y == t1.c3.y)) ||  ((t2.c3.x == t1.c4.x)&&(t2.c3.y == t1.c4.y)) ) {}
     else  createunit(t2.c3.x , t2.c3.y , t2.color);  //clear that block as no overlap
     
     if( ((t2.c4.x == t1.c1.x)&&(t2.c4.y == t1.c1.y)) ||  ((t2.c4.x == t1.c2.x)&&(t2.c4.y == t1.c2.y)) ||
          ((t2.c4.x == t1.c3.x)&&(t2.c4.y == t1.c3.y)) ||  ((t2.c4.x == t1.c4.x)&&(t2.c4.y == t1.c4.y)) ) {}
     else  createunit(t2.c4.x , t2.c4.y , t2.color);  //clear that block as no overlap
          
}



//*******************************************************************************************
//*********function to convert coordinates from screen space to grid space******************

struct coordinate coord_change(struct coordinate t9)
{
    struct coordinate output ; 
    output.x = (t9.y - 50)/20 ;
    output.y = (t9.x - 70)/20 ;
    return output ;
}


//******************************************************************************
//************************Printing you lose ************************************
void finalmessage()
{ 
    int x ; 
    int y ; 
    for(y = 40; y < 445 ;y++) 
    {
        for( x = 60; x < 260 ;x=x+2)
        {
             writesram(x , y , 0) ;
             delay() ;
        }
    }
    
    //*******drawing the Y*******************
    createunit( 80 + 5  ,  340 - 100 , 110);
    createunit( 80 + 5 ,   360 - 100, 110);
    createunit( 100 + 5,   360 - 100, 110);
    createunit( 120 + 5 ,   360 - 100, 110);
    createunit( 120 + 5 ,  340 - 100, 110);
    createunit( 120 + 5 ,  380 - 100, 110);
    createunit( 120 + 5 ,  400 - 100, 110);
    
     //*******drawing the O*******************
    createunit( 150  ,  340 - 100, 110);
    createunit( 150  ,  360 - 100, 110);
    createunit( 150  ,  380 - 100, 110);
    createunit( 170 ,   340 - 100, 110);
    createunit( 170 ,   380 - 100, 110);
    createunit( 190  ,  340 - 100, 110);
    createunit( 190  ,  360 - 100, 110);
    createunit( 190  ,  380 - 100, 110);
    
     //*******drawing the U*******************
    createunit( 225 - 10  ,  340 - 100, 110);
    createunit( 225 - 10  ,  360 - 100, 110);
    createunit( 225 - 10  ,  380 - 100, 110);
    createunit( 245 - 10 ,   380 - 100, 110);
    createunit( 265 - 10  ,  340 - 100, 110);
    createunit( 265 - 10  ,  360 - 100, 110);
    createunit( 265 - 10  ,  380 - 100, 110);
    
    
     //*******drawing the L*******************
    createunit( 290 - 10 - 200 ,   340 , 110);
    createunit( 290 - 10 - 200 ,   360 , 110);
    createunit( 290 - 10 - 200 ,   380 , 110);
    createunit( 290 - 10 - 200 ,   400 , 110);  
    createunit( 290 - 10 - 200,    420 , 110);
    createunit( 310 - 10 - 200,    420 , 110);
    createunit( 330 - 10 - 200,    420 , 110);
    
    
     //*******drawing the O*******************
    createunit( 355 - 10  - 200,  340 , 110);
    createunit( 355 - 10 - 200 ,  360 , 110);
    createunit( 355 - 10 - 200 ,  380 , 110);
    createunit( 355 - 10 - 200 ,  400 , 110);
    createunit( 355 - 10  - 200,  420 , 110);
    createunit( 375 - 10 - 200,   340 , 110);
    createunit( 375 - 10 - 200,   420 , 110);
    createunit( 395 - 10 - 200 ,  340 , 110);
    createunit( 395 - 10  - 200,  360 , 110);
    createunit( 395 - 10 - 200 ,  380 , 110);
    createunit( 395 - 10  - 200,  400 , 110);
    createunit( 395 - 10  - 200,  420 , 110);
    
     //*******drawing the S*******************
    createunit( 410 - 200 ,   340 , 110);
    createunit( 410  - 200,   360 , 110);
    createunit( 410  - 200,   380 , 110);
    createunit( 410  - 200,   420 , 110);
    
    createunit( 430  - 200,   340 , 110);
    createunit( 430 - 200 ,   380 , 110);
    createunit( 430  - 200,   420 , 110);
    
    createunit( 450 - 200 ,   340 , 110);
    createunit( 450 - 200 ,   380 , 110);
    createunit( 450 - 200 ,   400 , 110);
    createunit( 450 - 200 ,   420 , 110);
    
    
     //*******drawing the E*******************
    createunit( 475 -  200 ,   340 , 110);
    createunit( 475  - 200,   360 , 110);
    createunit( 475  - 200,   380 , 110);
    createunit( 475  - 200,   400 , 110);
    createunit( 475  - 200,   420 , 110);
    
    createunit( 495  - 200,   340 , 110);
    createunit( 495 -  200 ,  380 , 110);
    createunit( 495  - 200,   420 , 110);
    
    createunit( 515  - 200,   340 , 110);
    createunit( 515 -  200 ,  380 , 110);
    createunit( 515  - 200,   420 , 110);
    
    
}




