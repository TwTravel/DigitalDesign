#include "system.h"
#include "stdio.h"
#include "stdlib.h"
#include "unistd.h"
#include "fcntl.h"
#include "string.h"

// Next include has definition of alt_irq_register
#include "sys/alt_irq.h"
//The next two includes are in syslib/DeviceDrivers[sopc_builder]
//They have the macros for setting values in peripherals
#include "altera_avalon_pio_regs.h"

void boarddisp(char b[]);
int board2int(char b[]);
void int2board(int boardnum, char *b);
int compete2(int x, int y, char *board);
void randomize(char b[][19683], int min, int max);
void mutate(char b[][19683], int min, int max, int prev_winner);
int winningplayer(void);
int competeasx(void);
int competeaso(void);
char *itoa(int n, char *s, int b);
char *strrev(char *str);

char boardtemp[9];
char organism[100][19683];

//if winflag = 0, illegal move = loss
//if winflag = 1, 3 in a row required
char winflag = 0;

int winfactor  =  0;
int drawfactor =  0;
int losefactor = -1;
int numrandom  = 30;
int pmutate    = 500; // out of 10000
int test = 43;
char buf[10];
int uart;
    
int main(void)
{
   
    int x,z,iter=0;
    uart=open("/dev/uart",O_RDWR);
    randomize(organism,0,99);
    printf ("iteration : %d \n",iter);
    while (1)
    {
        z = IORD_ALTERA_AVALON_PIO_DATA(SW_BASE);
        IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE, 0);
          
        while (1)
        {  
            z = IORD_ALTERA_AVALON_PIO_DATA(SW_BASE);
            if(z == 131072 || z == 65536 || z == 32768)
                break;
        }
        if (z == 65536)
        {
            printf("COMPETING AS X\n"); 
            x = competeasx();
            switch(x)
            {
                case 0: printf("YOU FAIL!\n"); break;
                case 1: printf("YOU WIN!\n"); break;
                case 2: printf("meh...draw\n"); break;
            }
        }
        else if(z == 32768)
        {
            printf("COMPETING AS O\n"); 
            x = competeaso();
            switch(x)
            {
                case 0: printf("YOU WIN!\n"); break;
                case 1: printf("YOU FAIL!\n"); break;
                case 2: printf("meh...draw\n"); break;
            }
        }
        else if (z == 131072)
        {
            x = winningplayer();
            iter = iter + 1;
            printf ("\niteration : %d \n",iter);
            mutate(organism,1,99,x);
        }
    }
    close(uart);
}
//display board formatted
void boarddisp(char b[])
{
    int i;
    for(i=0;i<9;i++)
    {
        if(i==0 || i==3 || i==6)
        {
            printf(" "); 
        }
        if(b[i]==0)
        {
            printf("  ");
        }
        else if(b[i]==1)
        {
            printf("X ");
        }
        else
        {
            printf("O ");
        }
        if(i==0 || i==1 || i==3 || i==4 || i==6 || i==7)
        {
            printf("| ");
        }
        if(i==2 || i==5)
        {
            printf("\n---+---+---\n"); 
        }
        else if(i==8)
        {
            printf("\n"); 
        }
    }
}

int board2int(char b[])
{
    return (   1*b[0])+
           (   3*b[1])+
           (   9*b[2])+
           (  27*b[3])+
           (  81*b[4])+
           ( 243*b[5])+ 
           ( 729*b[6])+
           (2187*b[7])+
           (6561*b[8]);
}

void int2board(int boardnum, char *b)
{
    int i;
    char num;
    for(i=0;i<9;i++)
    {
        num = boardnum % 3;
        boardnum = boardnum / 3;
        b[i]=num;
    }
}


int compete2(int x, int y, char *board)
{
    int i, movex, moveo;
    for(i=0;i<9;i++)
        board[i]=0;

    for(i=0;i<9;i++)
    {
        if((board[0]==board[1] && board[1]==board[2] && board[0] != 0) ||
           (board[3]==board[4] && board[4]==board[5] && board[3] != 0) ||
           (board[6]==board[7] && board[7]==board[8] && board[6] != 0) ||
           (board[0]==board[3] && board[3]==board[6] && board[0] != 0) ||
           (board[1]==board[4] && board[4]==board[7] && board[1] != 0) ||
           (board[2]==board[5] && board[5]==board[8] && board[2] != 0) ||
           (board[0]==board[4] && board[4]==board[8] && board[0] != 0) ||
           (board[2]==board[4] && board[4]==board[6] && board[2] != 0) )
        {
            return i%2;
        }
        int boardnum = board2int(board);

        if(i%2 == 0)
        {
            movex = organism[x][boardnum];
            if(winflag)
            {
                while(board[movex] != 0)
                {
                    movex = (movex+4)%9;
                }
                organism[x][boardnum] = movex;
            }
            else
            {
                if(board[movex] != 0)
                {
                    return i%2;
                }
            }
            board[movex] = 1;
        }
        else
        {
            moveo = organism[y][boardnum];
            if(winflag)
            {
                while(board[moveo] != 0)
                {
                    moveo = (moveo+4)%9;
                }
                organism[y][boardnum] = moveo;
            }
            else
            {
                if(board[moveo] != 0)
                {
                    return i%2;
                }
            }
            board[moveo] = 2;
        }
    }
    if((board[0]==board[1] && board[1]==board[2] && board[0] != 0) ||
       (board[3]==board[4] && board[4]==board[5] && board[3] != 0) ||
       (board[6]==board[7] && board[7]==board[8] && board[6] != 0) ||
       (board[0]==board[3] && board[3]==board[6] && board[0] != 0) ||
       (board[1]==board[4] && board[4]==board[7] && board[1] != 0) ||
       (board[2]==board[5] && board[5]==board[8] && board[2] != 0) ||
       (board[0]==board[4] && board[4]==board[8] && board[0] != 0) ||
       (board[2]==board[4] && board[4]==board[6] && board[2] != 0) )
    {
        return i%2;
    }
    return 2;
}

void randomize(char b[][19683], int min, int max)
{
    int i,j;
    for(i=min;i<max+1;i++)
    {
        for (j=0;j<19683;j++)
        {
            organism[i][j] = rand()%9;
        } 
        IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE, i);    
    }
    IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE, 0);    
}

int winningplayer(void)
{
    int winner,i,j,x;
    int recordwin[100];
    int recordlose[100];
    int recorddraw[100];
    for(i=0;i<100;i++)
    {
        recordwin[i] =0;
        recordlose[i]=0;
        recorddraw[i]=0;
    }
    for(i=0;i<100;i++)
    {
        for(j=0;j<100;j++)
        {
            if(i != j)
            {
                winner = compete2(i,j,boardtemp);
                if(winner == 0)
                {
                    recordwin[j]++;
                    recordlose[i]++;
                }
                else if(winner == 1)
                {
                    recordwin[i]++;
                    recordlose[j]++;
                }
                else
                {
                    recorddraw[i]++;
                    recorddraw[j]++;
                }
            }
        }
    }

    int recordscore[100];
    for(i=0;i<100;i++)
    {
        recordscore[i] = (winfactor*recordwin[i])+(drawfactor*recorddraw[i])+(losefactor*recordlose[i]);
    }

    printf("Player NO: WIN - LOS - DRW : SCORE\n"); 
    //display win-lose-draw records
    int mostwins   =recordwin[1] ;
    int leastwins  =recordwin[1] ;
    int mostlosses =recordlose[1];
    int leastlosses=recordlose[1];
    int mostdraws  =recorddraw[1];
    int leastdraws =recorddraw[1];
    int mostscore  =recordscore[1];
    int leastscore =recordscore[1];

    for(i=0;i<100;i++)
    {
        if(mostwins    < recordwin[i])
            mostwins = recordwin[i];
        if(leastwins   > recordwin[i])
            leastwins = recordwin[i];
        if(mostlosses  < recordlose[i])
            mostlosses  = recordlose[i];
        if(leastlosses > recordlose[i])
            leastlosses = recordlose[i];
        if(mostdraws   < recorddraw[i])
            mostdraws = recorddraw[i];
        if(leastdraws  > recorddraw[i])
            leastdraws = recorddraw[i];
        if(mostscore   < recordscore[i])
            mostscore = recordscore[i];
        if(leastscore  > recordscore[i])
            leastscore = recordscore[i];
        printf("Player %2d: %3d - %3d - %3d : %4d\n",i,recordwin[i],recordlose[i],recorddraw[i],recordscore[i]);
    }
    
    for(i=0;i<100;i++)
    {
        printf("\n Most  Wins  : %4d : ",mostwins);
        for(i=0;i<100;i++)
        {
            if(mostwins    == recordwin[i])
            {
                printf("%2d ",i);
            }
        }
        
        printf("\n Most  Losses: %4d : ",mostlosses); 
        for(i=0;i<100;i++)
        {
            if(mostlosses  == recordlose[i])
            {
                printf("%2d ",i);
            }
        }

        printf("\n Most  Draws : %4d : ",mostdraws); 
        for(i=0;i<100;i++)
        {
            if(mostdraws   == recorddraw[i])
            {
                printf("%2d ",i);
            }
        }


        printf("\n Least Wins  : %4d : ",leastwins);
        for(i=0;i<100;i++)
        {
            if(leastwins    == recordwin[i])
            {
                printf("%2d ",i);
            }
        }
        
        printf("\n Least Losses: %4d : ",leastlosses); 
        for(i=0;i<100;i++)
        {
            if(leastlosses  == recordlose[i])
            {
                printf("%2d ",i);
            }
        }

        printf("\n Least Draws : %4d : ",leastdraws); 
        for(i=0;i<100;i++)
        {
            if(leastdraws   == recorddraw[i])
            {
                printf("%2d ",i);
            }
        }

        printf("\n Most  Score : %4d : ",mostscore); 
        itoa(mostscore,buf,10); write(uart,strcat(&buf,","),10);
        for(i=0;i<100;i++)
        {
            if(mostscore   == recordscore[i])
            {
                printf("%2d ",i); x=i;
            }
        }

        printf("\n Least Score : %4d : ",leastscore); 
        for(i=0;i<100;i++)
        {
            if(leastscore   == recordscore[i])
            {
                printf("%2d ",i);
            }
        }


    }
    printf("\n Best Organism      :%3d\n",x);
    return x;
}

void mutate(char b[][19683], int min, int max, int prev_winner)
{
    int i,j;
    for(j=0;j<19683;j++)
    {
        organism[0][j] = organism [prev_winner][j];
    }
    for(i=min;i<max+1;i++)
    {
        for (j=0;j<19683;j++)
        {
            if(rand()%10000 < pmutate)
            {
                organism[i][j] = rand()%9;
            }
            else
                organism[i][j] = organism[0][j]; 
        } 
        IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE, i);    
    }
    IOWR_ALTERA_AVALON_PIO_DATA(LED_BASE, 0);    
}

int competeasx(void)
{
    int i, movex, moveo, z;
    for(i=0;i<9;i++)
        boardtemp[i]=0;

    for(i=0;i<9;i++)
    {
        printf("\n"); 
        boarddisp(boardtemp);
        printf("\n"); 
        if((boardtemp[0]==boardtemp[1] && boardtemp[1]==boardtemp[2] && boardtemp[0] != 0) ||
           (boardtemp[3]==boardtemp[4] && boardtemp[4]==boardtemp[5] && boardtemp[3] != 0) ||
           (boardtemp[6]==boardtemp[7] && boardtemp[7]==boardtemp[8] && boardtemp[6] != 0) ||
           (boardtemp[0]==boardtemp[3] && boardtemp[3]==boardtemp[6] && boardtemp[0] != 0) ||
           (boardtemp[1]==boardtemp[4] && boardtemp[4]==boardtemp[7] && boardtemp[1] != 0) ||
           (boardtemp[2]==boardtemp[5] && boardtemp[5]==boardtemp[8] && boardtemp[2] != 0) ||
           (boardtemp[0]==boardtemp[4] && boardtemp[4]==boardtemp[8] && boardtemp[8] != 0) ||
           (boardtemp[2]==boardtemp[4] && boardtemp[4]==boardtemp[6] && boardtemp[2] != 0) )
        {
            return i%2;
        }
        int boardnum = board2int(boardtemp);

        if(i%2 == 0)
        {
            while(1)
            {
                z = IORD_ALTERA_AVALON_PIO_DATA(SW_BASE);
                if(z == 1 && boardtemp[8] == 0)
                {   movex = 8;  break;  }
                else if(z == 2 && boardtemp[7] == 0)
                {   movex = 7;  break;  }
                else if(z == 4 && boardtemp[6] == 0)
                {   movex = 6;  break;  }
                else if(z == 8 && boardtemp[5] == 0)
                {   movex = 5;  break;  }
                else if(z == 16 && boardtemp[4] == 0)
                {   movex = 4;  break;  }
                else if(z == 32 && boardtemp[3] == 0)
                {   movex = 3;  break;  }
                else if(z == 64 && boardtemp[2] == 0)
                {   movex = 2;  break;  }
                else if(z == 128 && boardtemp[1] == 0)
                {   movex = 1;  break;  }
                else if(z == 256 && boardtemp[0] == 0)
                {   movex = 0;  break;  }
            }
            printf("X's move: %d\n",movex);
            boardtemp[movex] = 1;
        }
        else
        {
            moveo = organism[0][boardnum];
            if(winflag)
            {
                while(boardtemp[moveo] != 0)
                {
                    moveo = (moveo+4)%9;
                }
            }
            else
            {
                if(boardtemp[moveo] != 0)
                {
                    printf(" INVALID MOVE!\n"); 
                    return i%2;
                }
            }
            printf("O's move: %d\n",moveo);
            boardtemp[moveo] = 2;
        }
    }
    if((boardtemp[0]==boardtemp[1] && boardtemp[1]==boardtemp[2] && boardtemp[0] != 0) ||
       (boardtemp[3]==boardtemp[4] && boardtemp[4]==boardtemp[5] && boardtemp[3] != 0) ||
       (boardtemp[6]==boardtemp[7] && boardtemp[7]==boardtemp[8] && boardtemp[6] != 0) ||
       (boardtemp[0]==boardtemp[3] && boardtemp[3]==boardtemp[6] && boardtemp[0] != 0) ||
       (boardtemp[1]==boardtemp[4] && boardtemp[4]==boardtemp[7] && boardtemp[1] != 0) ||
       (boardtemp[2]==boardtemp[5] && boardtemp[5]==boardtemp[8] && boardtemp[2] != 0) ||
       (boardtemp[0]==boardtemp[4] && boardtemp[4]==boardtemp[8] && boardtemp[0] != 0) ||
       (boardtemp[2]==boardtemp[4] && boardtemp[4]==boardtemp[6] && boardtemp[2] != 0) )
    {
        return i%2;
    }
    return 2;

    printf("\nWinning board:\n"); 
    boarddisp(boardtemp);
}

int competeaso(void)
{
    int i, movex, moveo, z;
    for(i=0;i<9;i++)
        boardtemp[i]=0;

    for(i=0;i<9;i++)
    {
        boarddisp(boardtemp);
        if((boardtemp[0]==boardtemp[1] && boardtemp[1]==boardtemp[2] && boardtemp[0] != 0) ||
           (boardtemp[3]==boardtemp[4] && boardtemp[4]==boardtemp[5] && boardtemp[3] != 0) ||
           (boardtemp[6]==boardtemp[7] && boardtemp[7]==boardtemp[8] && boardtemp[6] != 0) ||
           (boardtemp[0]==boardtemp[3] && boardtemp[3]==boardtemp[6] && boardtemp[0] != 0) ||
           (boardtemp[1]==boardtemp[4] && boardtemp[4]==boardtemp[7] && boardtemp[1] != 0) ||
           (boardtemp[2]==boardtemp[5] && boardtemp[5]==boardtemp[8] && boardtemp[2] != 0) ||
           (boardtemp[0]==boardtemp[4] && boardtemp[4]==boardtemp[8] && boardtemp[8] != 0) ||
           (boardtemp[2]==boardtemp[4] && boardtemp[4]==boardtemp[6] && boardtemp[2] != 0) )
        {
            return i%2;
        }
        int boardnum = board2int(boardtemp);

        if(i%2 == 0)
        {
            movex = organism[0][boardnum];
            if(winflag)
            {
                while(boardtemp[movex] != 0)
                {
                    movex = (movex+4)%9;
                }
            }
            else
            {
                if(boardtemp[movex] != 0)
                {
                    printf(" INVALID MOVE!\n"); 
                    return i%2;
                }
            }
            printf("X's move: %d\n",movex);
            boardtemp[movex] = 1;
        }
        else
        {
            while(1)
            {
                z = IORD_ALTERA_AVALON_PIO_DATA(SW_BASE);
                if(z == 1 && boardtemp[8] == 0)
                {   moveo = 8;  break;  }
                else if(z == 2 && boardtemp[7] == 0)
                {   moveo = 7;  break;  }
                else if(z == 4 && boardtemp[6] == 0)
                {   moveo = 6;  break;  }
                else if(z == 8 && boardtemp[5] == 0)
                {   moveo = 5;  break;  }
                else if(z == 16 && boardtemp[4] == 0)
                {   moveo = 4;  break;  }
                else if(z == 32 && boardtemp[3] == 0)
                {   moveo = 3;  break;  }
                else if(z == 64 && boardtemp[2] == 0)
                {   moveo = 2;  break;  }
                else if(z == 128 && boardtemp[1] == 0)
                {   moveo = 1;  break;  }
                else if(z == 256 && boardtemp[0] == 0)
                {   moveo = 0;  break;  }
            }
            printf("O's move: %d\n",moveo);
            boardtemp[moveo] = 2;
        }
    }
    if((boardtemp[0]==boardtemp[1] && boardtemp[1]==boardtemp[2] && boardtemp[0] != 0) ||
       (boardtemp[3]==boardtemp[4] && boardtemp[4]==boardtemp[5] && boardtemp[3] != 0) ||
       (boardtemp[6]==boardtemp[7] && boardtemp[7]==boardtemp[8] && boardtemp[6] != 0) ||
       (boardtemp[0]==boardtemp[3] && boardtemp[3]==boardtemp[6] && boardtemp[0] != 0) ||
       (boardtemp[1]==boardtemp[4] && boardtemp[4]==boardtemp[7] && boardtemp[1] != 0) ||
       (boardtemp[2]==boardtemp[5] && boardtemp[5]==boardtemp[8] && boardtemp[2] != 0) ||
       (boardtemp[0]==boardtemp[4] && boardtemp[4]==boardtemp[8] && boardtemp[0] != 0) ||
       (boardtemp[2]==boardtemp[4] && boardtemp[4]==boardtemp[6] && boardtemp[2] != 0) )
    {
        return i%2;
    }
    return 2;

    printf("\nWinning board:\n");
    boarddisp(boardtemp);
}

char *itoa(int n, char *s, int b) 
{
    static char digits[] = "0123456789abcdefghijklmnopqrstuvwxyz";
    int i=0, sign;
    
    if ((sign = n) < 0)
        n = -n;

    do {
        s[i++] = digits[n % b];
    } while ((n /= b) > 0);

    if (sign < 0)
        s[i++] = '-';
    s[i] = '\0';

    return strrev(s);
}

char *strrev(char *str) 
{
    char *p1, *p2;

    if (!str || !*str)
        return str;

    for (p1 = str, p2 = str + strlen(str) - 1; p2 > p1; ++p1, --p2) {
        *p1 ^= *p2;
        *p2 ^= *p1;
        *p1 ^= *p2;
    }

    return str;
}

