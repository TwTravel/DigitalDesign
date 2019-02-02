/*
 *lockin control program.
 *handle user interface and outputs configuration settings to lockin hardware
 *also processes low frequency outputs
 *
 * written by Tristan Rocheleau, Nov 2008
 */

#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <math.h>

int main()
{
   volatile int*    user_input                 =  (int*)  0x01001400;       //first 18 bits are switches, next 3 are key[3:1]
   
   int*             character_buffer_base      =  (int*)  0x01001000;       //length is 0x3ff
   int*             image_buffer_base          =  (int*)  0x01002000;       //this is not used in the current version
   
   int*             user_frequency             =  (int*)  0x01001430;       //output set DDS frequency in 25.5 fixed format
   
   //control register.  bit 0: on=PLL, off=int ref
   //bit 3-1: port A output control.  000: input, 001: X before filtering, 010: X, 100: I quad of ref
   //bit 6-4: Port B output control.  Same as port A
   int*             control                    =  (int*)  0x01001420;       
   
   
   //time constant output.  Wired to filter.  time constant is e^-1/d, where d is number of cycles decay time
   //Clock is 50MHz 
   int*             time_constant              =  (int*)  0x01001440;       
   
   volatile int*    other_in                   =  (int*)  0x010014a0;       //8 bits of random input signals.  These don't actually seem to be neccessary
   
   int*             other_out                  =  (int*)  0x01001450;       //32 bits other output.  [9:0] = cursor location.
   
   volatile int*             I_in              =  (int*)  0x01001480;       //measured X quad in.  
   volatile int*             Q_in              =  (int*)  0x01001490;       //measure Y quad in.
   volatile int*    freq_in                    =  (int*)  0x010014b0;       //frequency signal running to DDS from PLL
   //int*             processed_I                =  (int*)  0x01001460;     //these are available for additional nios controll analog output
   //int*             processed_Q                =  (int*)  0x01001470;     //they are not used currently
   
   //first 3 columns are not visible.  First visible address is 2.
    char    tempbuf[50];                //character buffer to write strings to.  This is a cheap a dirty way of getting the output out properly
    int     i;

    int     cursor = 4;                 //index indicating current location of cursor
    
    
    int     output_A_mode = 3;          //modes are: 1: input/ref in(A/B), 2: mixed signal I/Q, 3: filtered signal I/Q, 4: ref I/Q
    int     output_B_mode = 3;
    
    int     source = 1;                 //initial source setting: use local oscillator

  
    
    int     control_local = 0x24;           //intital settings: output X, Y, use local oscillator
    
    int     previous_user_input;            //used to detect button presses
    
    int     user_frequency_local = 200000;     //intial settings
   
    float   volt_scale, f1, f2, X, Y, R, Theta, freq_float, freq_scale;
    float   time_constant_local;
    float   time_constant_upper, time_constant_lower; 
        
    
    //300mVrms input gives .132 * full scale of input register.  
    volt_scale = 2.27f / 2147483647.0f;      //output of filter is in 2.34 format, input to NIOS is [35:4] 
      
    freq_scale = 1.0f / 128.0f;             
    
    f1 = 1.331 / 2;
    
    
    *other_out = 5*70 + 20;                 //set initial cursor location
    *control = control_local; 
    *user_frequency = user_frequency_local * 128;
    previous_user_input = *user_input;
    
    
    time_constant_upper = 100.0f;    //time constant is stored in two variables, upper is ms, lower is us.  
    time_constant_lower = 0.0f;
    time_constant_local = time_constant_upper + 0.001 * time_constant_lower;       //inital setting is 0.1s
    
    f2 = (1.0 -  exp(-1.0f / (50000.0f * time_constant_local))) * (float) 0x100000000; //50 clock cycls to the microsecond, times 2^32 for the floating point action.
    
    *time_constant = (int) (f2 + 0.5f);
    
    
    printf("floating point test?: %f, %f", f1, f2);
    
    
///////////////////////////////////////////////////////
//inital text display
    sprintf(tempbuf, "LOCKIN MEASUREMENTS:  ");            
    for(i=0; i<20; i++) {
        *(character_buffer_base + 2 + i) = tempbuf[i];
    }   
    
    sprintf(tempbuf, "X(V):             ");            
    for(i=0; i<20; i++) {
        *(character_buffer_base + 1*70 + 2 + i) = tempbuf[i];
    }   
    
    sprintf(tempbuf, "Y(V):              ");            
    for(i=0; i<20; i++) {
        *(character_buffer_base + 2*70 + 2 + i) = tempbuf[i];
    }    
    
    sprintf(tempbuf, "R(V):               ");            
    for(i=0; i<20; i++) {
        *(character_buffer_base + 1*70 + 20 + i) = tempbuf[i];
    }   
    
    sprintf(tempbuf, "THETA(DEG):          ");            
    for(i=0; i<20; i++) {
        *(character_buffer_base + 2*70 + 20 + i) = tempbuf[i];
    }   
    
    
    sprintf(tempbuf, "TIME CONSTANT(MS):   ");            
    for(i=0; i<20; i++) {
        *(character_buffer_base + 5*70 + 2 + i) = tempbuf[i];
    } 
    
    
    sprintf(tempbuf, "ANALOG OUT A:                     ");            
    for(i=0; i<25; i++) {
        *(character_buffer_base + 7*70 + 2 + i) = tempbuf[i];
    } 
    
    sprintf(tempbuf, "ANALOG OUT B:                     ");            
    for(i=0; i<25; i++) {
        *(character_buffer_base + 8*70 + 2 + i) = tempbuf[i];
    } 
    
    
    sprintf(tempbuf, "REFERENCE SOURCE:  ");            
    for(i=0; i<20; i++) {
        *(character_buffer_base + 10*70 + 2 + i) = tempbuf[i];
    } 
    
    sprintf(tempbuf, "INTERNAL REFERENCE FREQUENCY(HZ):  ");            
    for(i=0; i<35; i++) {
        *(character_buffer_base + 11*70 + 2 + i) = tempbuf[i];
    } 
    
    sprintf(tempbuf, "OUTPUT FREQUENCY(HZ):  ");            
    for(i=0; i<25; i++) {
        *(character_buffer_base + 12*70 + 2 + i) = tempbuf[i];
    } 
  
  
////////////////////////////////////////////////////////
//initial displayed settings  
    sprintf(tempbuf, "X          ");            
    for(i=0; i<15; i++) {
        *(character_buffer_base + 7*70 + 16 + i) = tempbuf[i];
    } 
    
    sprintf(tempbuf, "Y          ");            
    for(i=0; i<15; i++) {
        *(character_buffer_base + 8*70 + 16 + i) = tempbuf[i];
    } 
    

    
    sprintf(tempbuf, "%d         ", user_frequency_local);            
    for(i=0; i<9; i++) {
        *(character_buffer_base + 11*70 + 36 + i) = tempbuf[i];
    } 
    
    
    sprintf(tempbuf, "INTERNAL      ");            
    for(i=0; i<15; i++) {
        *(character_buffer_base + 10*70 + 20 + i) = tempbuf[i];
    } 
  
    sprintf(tempbuf, "%f         ", time_constant_local);            
    for(i=0; i<9; i++) {
        *(character_buffer_base + 5*70 + 21 + i) = tempbuf[i];
    } 
    
    
    
    
  
    
    while(1) {  //main loop... do forever.
    
        if(((*user_input & 0x1C0000) ^ (previous_user_input & 0x1C0000)) != 0) { //if a button has been pressed,
          
            
            if(((*user_input & 0x100000) == 0) && ((previous_user_input & 0x100000) == 0x100000)) {    //if KEY[3] is just pressed  
                cursor--;           
                if(cursor == 0) 
                    cursor = 5;
            }
            
            if(((*user_input & 0x80000) == 0) && ((previous_user_input & 0x80000) == 0x80000)) {    //if KEY[2] is just pressed  
                cursor++;
                if(cursor == 6) 
                    cursor = 1;
            }
            
            if(((*user_input & 0x40000) == 0) && ((previous_user_input & 0x40000) == 0x40000)) {    //if KEY[1] is just pressed, change a setting
                switch(cursor) {
                    case 1:
                        time_constant_lower = (float) ((*user_input & 0xff) * 4);
                        time_constant_upper = (float) ((*user_input & 0x3ff00) >> 8);
                        
                        if(time_constant_lower > 999.0f)        //set max at 999us/ms
                            time_constant_lower = 999.0f;
       
                        if(time_constant_upper > 1000.0f)        //set max at 999us/ms
                            time_constant_upper = 1000.0f;
                            
                        time_constant_local = time_constant_upper + 0.001f * time_constant_lower;       //inital setting is 0.1s
                        *time_constant = (int) ((1.0 -  exp(-1.0f / (50000.0f * time_constant_local))) * (float) 0x100000000 + 0.5f);  //output time constant in 0.32 format
                        
                        sprintf(tempbuf, "%f         ", time_constant_local);            
                        for(i=0; i<9; i++) {
                            *(character_buffer_base + 5*70 + 21 + i) = tempbuf[i];
                        } 
                    break;
                    
                    case 2:             //analog out A settings
                        output_A_mode++;
                        if(output_A_mode == 5)
                            output_A_mode = 1;
                            
                        switch(output_A_mode) {
                            case 1:
                                control_local = (control_local & 0x3fff1) + 0x0;    //set control to output input.  
                                *control = control_local;
                                
                                sprintf(tempbuf, "INPUT          ");            
                                for(i=0; i<15; i++) {
                                    *(character_buffer_base + 7*70 + 16 + i) = tempbuf[i];
                                } 
                            break;
                            case 2:
                                control_local = (control_local & 0x3fff1) + 0x2;    //set control to output X before filtering.  
                                *control = control_local;
                                
                                sprintf(tempbuf, "X(BEFORE FILTERING)         ");            
                                for(i=0; i<15; i++) {
                                    *(character_buffer_base + 7*70 + 16 + i) = tempbuf[i];
                                } 
                            
                            break;
                            case 3:
                                control_local = (control_local & 0x3fff1) + 0x4;    //set control to output X.  
                                *control = control_local;
                                
                                sprintf(tempbuf, "X            ");            
                                for(i=0; i<15; i++) {
                                    *(character_buffer_base + 7*70 + 16 + i) = tempbuf[i];
                                } 
                            break;
                            case 4:
                                control_local = (control_local & 0x3fff1) + 0x8;    //set control to output I quad of ref.  
                                *control = control_local;
                                
                                sprintf(tempbuf, "REFERENCE(I)         ");            
                                for(i=0; i<15; i++) {
                                    *(character_buffer_base + 7*70 + 16 + i) = tempbuf[i];
                                } 
                            break;
                        }
                    break;
                    
                    
                    case 3:                 //analog out B settings
                        output_B_mode++;
                        if(output_B_mode == 5)
                            output_B_mode = 1;
                            
                        switch(output_B_mode) {
                            case 1:
                                control_local = (control_local & 0x3ff8F) + 0x0;    //set control to output reference.  
                                *control = control_local;
                                
                                sprintf(tempbuf, "REFERENCE IN          ");            
                                for(i=0; i<15; i++) {
                                    *(character_buffer_base + 8*70 + 16 + i) = tempbuf[i];
                                } 
                            break;
                            case 2:
                                control_local = (control_local & 0x3ff8F) + 0x10;    //set control to output X before filtering.  
                                *control = control_local;
                                
                                sprintf(tempbuf, "Y(BEFORE FILTERING)         ");            
                                for(i=0; i<15; i++) {
                                    *(character_buffer_base + 8*70 + 16 + i) = tempbuf[i];
                                } 
                            
                            break;
                            case 3:
                                control_local = (control_local & 0x3ff8f) + 0x20;    //set control to output X.  
                                *control = control_local;
                                
                                sprintf(tempbuf, "Y            ");            
                                for(i=0; i<15; i++) {
                                    *(character_buffer_base + 8*70 + 16 + i) = tempbuf[i];
                                } 
                            break;
                            case 4:
                                control_local = (control_local & 0x3ff8f) + 0x40;    //set control to output Q quad of ref.  
                                *control = control_local;
                                
                                sprintf(tempbuf, "REFERENCE(Q)         ");            
                                for(i=0; i<15; i++) {
                                    *(character_buffer_base + 8*70 + 16 + i) = tempbuf[i];
                                } 
                            break;
                        }
                    break;
                    
                    case 4:                     //if currently on internal source, change to external
                        if(source == 1) {                       
                            source = 2;
                            control_local = (control_local & 0x3fffe) + 0x1;    //set control to take input from PLL
                            *control = control_local;
                            
                            sprintf(tempbuf, "EXTERNAL      ");            
                            for(i=0; i<15; i++) {
                                *(character_buffer_base + 10*70 + 20 + i) = tempbuf[i];
                            }
                        } 
                        else {                   //and vice versa
                            source = 1;
                            control_local = (control_local & 0x3fffe);    //set control to take input from nios
                            *control = control_local;
                            
                            sprintf(tempbuf, "INTERNAL      ");            
                            for(i=0; i<15; i++) {
                                *(character_buffer_base + 10*70 + 20 + i) = tempbuf[i];
                            }
                        }
                    break;
                    
                    case 5:                         //set local oscilator frequency from switches
                        user_frequency_local = (*user_input & 0x3ffff) * 4;     //to get full range, output must be 4 * key number
                        *user_frequency = user_frequency_local * 128;               //output frequency to logic, shifted by 6 bits since f is in 25.5 format
                        
                        sprintf(tempbuf, "%d           ", user_frequency_local);    //and update display         
                        for(i=0; i<9; i++) {
                            *(character_buffer_base + 11*70 + 36 + i) = tempbuf[i];
                        } 
                    break;
                    
                }
                
            }
               
            
            //every button press, update cursor location
            switch(cursor) {
                case 1:
                    *other_out = 5*70 + 21;
                break;
                case 2:
                    *other_out = 7*70 + 16;
                break;
                case 3:
                    *other_out = 8*70 + 16;
                break;
                case 4:
                    *other_out = 10*70 + 20;
                break;
                
                case 5:
                    *other_out = 11*70 + 36;
                break;
          
            }
           
            
        }
     
        previous_user_input = *user_input;      //store current input settings
        
        
////////////////////////////////////////////////////////
//every cycle, update changing values to display        
        X = (float) (*I_in) * volt_scale;       //scaling is based on (semi)arbitrary reference voltage of A/D board
        Y = (float) (*Q_in) * volt_scale;
        
        R = sqrt(X*X + Y*Y);
        Theta = 180.0f / 3.14159f * atan(X/Y);
        freq_float = freq_scale * (float) *freq_in; 
        
             
        sprintf(tempbuf, "%f   ", X);
        for(i=0; i<9; i++) {
            *(character_buffer_base + 1*70 + 8 + i) = tempbuf[i];
        }   
        
        sprintf(tempbuf, "%f   ", Y);
        for(i=0; i<9; i++) {
            *(character_buffer_base + 2*70 + 8 + i) = tempbuf[i];
        } 
        
        sprintf(tempbuf, "%f   ", R);
        for(i=0; i<9; i++) {
            *(character_buffer_base + 1*70 + 33 + i) = tempbuf[i];
        }   
        
        sprintf(tempbuf, "%f   ", Theta);
        for(i=0; i<9; i++) {
            *(character_buffer_base + 2*70 + 33 + i) = tempbuf[i];
        }
        
        sprintf(tempbuf, "%f   ", freq_float);
        for(i=0; i<9; i++) {
            *(character_buffer_base + 12*70 + 24 + i) = tempbuf[i];
        }
        
    }    
    
                        

        
    
        
        
    
    return 0;
}


