#ifndef TFUNCTIONS_H_
#define TFUNCTIONS_H_

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




void delay() ;
void writesram (unsigned int x ,unsigned int y ,unsigned int b ) ;
void initializescreen();
void createunit(unsigned int x ,unsigned int y , unsigned int color ) ;
void delay1();
void delay2();
void draw(struct tetris_piece t1) ;
void clear(struct tetris_piece t1) ;  //clear tetris piece
void drawnextpiece(struct tetris_piece t2) ;            //draws the next piece to come
struct tetris_piece movedown(struct tetris_piece t3) ;
struct tetris_piece moveleft(struct tetris_piece t5) ; //move piece left
struct tetris_piece moveright(struct tetris_piece t6) ; //move piece right
struct tetris_piece rotate(struct tetris_piece t4)  ;  //rotates a piece when up is pressed
void drawpiece_tnext(struct tetris_piece t1 , struct tetris_piece t2) ; //update piece on screen
struct coordinate coord_change(struct coordinate t9) ;   //coordinate change from screen space to grid space
void clearnextpiecearea() ;                             //clearnextpiecearea
void final_message() ;                                  //final message  


//***********************************************************************************
//****************Definitions for the different teris blocks*************************
unsigned short int piecessprites [7][11] = {{150 , 50 , 170 , 50 , 150 , 70 , 170 , 70 , 1 ,0 , 90},
                                            {130 , 50 , 150 , 50 , 170 , 50 , 190 , 50 , 2 ,0 , 100},
                                            {150 , 50 , 170 , 50 , 170 , 70 , 190 , 70 , 3 ,0 , 110},
                                            {190 , 50 , 170 , 50 , 170 , 70 , 150 , 70 , 4 ,0 , 120},
                                            {150 , 70 , 150 , 50 , 170 , 50 , 190 , 50 , 5 ,0 , 180},
                                            {150 , 50 , 170 , 50 , 190 , 50 , 190 , 70 , 6 ,0 , 70},
                                            {150 , 50 , 170 , 50 , 170 , 70 , 190 , 50 , 7 ,0 , 190} } ; 



unsigned short int tetris1 [] = {150 , 50 , 170 , 50 , 150 , 70 , 170 , 70 , 1 ,0} ;            //square
unsigned short int tetris2 [] = {130 , 50 , 150 , 50 , 170 , 50 , 190 , 50 , 2 ,0} ;                  //line
unsigned short int tetris3 [] = {150 , 50 , 170 , 50 , 170 , 70 , 190 , 70 , 3 ,0} ;                  //Z
unsigned short int tetris4 [] = {190 , 50 , 170 , 50 , 170 , 70 , 150 , 70 , 4 ,0} ;                  //S
unsigned short int tetris5 [] = {150 , 70 , 150 , 50 , 170 , 50 , 190 , 50 , 5 ,0} ;                 //|----
unsigned short tetris6 [] = {150 , 50 , 170 , 50 , 190 , 50 , 190 , 70 , 6 ,0} ;                      //----|
unsigned short tetris7 [] = {150 , 50 , 170 , 50 , 170 , 70 , 190 , 50 , 7 ,0} ;                     //T

#endif /*TFUNCTIONS_H_*/
