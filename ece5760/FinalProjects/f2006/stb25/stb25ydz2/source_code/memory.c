#include <stdio.h>
#include "C:\final\final\software\memory_syslib\Debug\system_description\system.h"
//#include "altera_avalon_timer_regs.h" 
#include "altera_avalon_pio_regs.h" 
#include <math.h>

//initial all functions
void init(void);
void getsphere (int num);
void motion (int num);
void rotate (int direction, float theta);


//struct sphere contains the sphere information
struct sphereinfo {float r; float x; float y; float z; float vx; float vy; float vz; int reflect;  int color; float r_inv; float r2; int count;}; 
int length = 2; //number of all spheres including one light source


struct sphereinfo sphere[17];


int main (int argc, char *argv[]) 
{
    int color, sphere_num, done, scene;
    float theta = 0.03;
    //selects the different scenes stored in software
    //1 big green sphere with 6 embeded little spheres
    //2 gripes, 7 spheres clustered together
    //3 dynamic scene with bouncing spheres
    scene = 3;
    init(scene);
    int i;
    //assign the total number of spheres to the hardware
    IOWR_ALTERA_AVALON_PIO_DATA(SPHERE_BASE, (length-1)*16);
    while(1){
      //constantly read the done and rotz signal from the hardware
      done = IORD_ALTERA_AVALON_PIO_DATA(DONE_BASE);
      rotz = IORD_ALTERA_AVALON_PIO_DATA(ROTZ_BASE);
        //wait in this while loop when the frame is not done drawing
        while(!IORD_ALTERA_AVALON_PIO_DATA(DONE_BASE)){}

        for (i=0; i<length; i++)
        {
          //turn off valid bit, call get sphere function which sends out the 
          //sphere information, and then turn off the valid bit
          IOWR_ALTERA_AVALON_PIO_DATA(VALID_BASE, 0);
          getsphere(i);
        }
        //turn off valid bit
        IOWR_ALTERA_AVALON_PIO_DATA(VALID_BASE, 0);
        
      //performs motion and rotation functions, only does it once per frame 
      //and when done sending sphere list to the hardware so doesn't stall the 
      //state machine
       for (i=0; i<length; i++) motion(i);
       rotate (rotz, theta);
    }
}

void getsphere (int num) {
    //given a sphere number and return all the relevant sphere information
    long int r2, x, y, z;
    r2 = pow(sphere[num].r, 2);
    x = (long int)(sphere[num].x*4096.0);
    y = (long int)(sphere[num].y*4096.0);
    z = (long int)(sphere[num].z*4096.0);
    IOWR_ALTERA_AVALON_PIO_DATA(RADIUS_BASE,(int)sphere[num].r);
    IOWR_ALTERA_AVALON_PIO_DATA(R2_BASE, (long int)sphere[num].r2);
    IOWR_ALTERA_AVALON_PIO_DATA(R_INV_BASE, (int)(sphere[num].r_inv*4096));
    IOWR_ALTERA_AVALON_PIO_DATA(X1_BASE, x);
    IOWR_ALTERA_AVALON_PIO_DATA(Y1_BASE, y);
    IOWR_ALTERA_AVALON_PIO_DATA(Z1_BASE, z);
    IOWR_ALTERA_AVALON_PIO_DATA(REFLECT_BASE, sphere[num].reflect);
    IOWR_ALTERA_AVALON_PIO_DATA(COLOR_BASE, sphere[num].color);
    IOWR_ALTERA_AVALON_PIO_DATA(SPHERE_BASE, (length-1)*16+num);
    //turns on valid bit
    IOWR_ALTERA_AVALON_PIO_DATA(VALID_BASE, 1);
}

    
void init (int scene) 
{
    //initialize spheres
    //various scenes are stoed in here
    
    //use the first scene, green sphere with six embedded spheres
    if (scene=1) 
    {
      sphere[0].x=(float)0;
      sphere[0].y=(float)0;
      sphere[0].z=((float) 0x5000)/4096.0;
      sphere[0].color=0x33F4;
      sphere[0].reflect=0x400;
      sphere[0].r=((float)0x3);
      sphere[0].r2=((float)0x9);
      sphere[0].r_inv=((float)0.333251);
          //initialize spheres
      sphere[1].x=((float)0xf000)/4096.0;
      sphere[1].y=((float)0);
      sphere[1].z=((float)0x5000)/4096.0;
      sphere[1].color=0x6F7B;
      sphere[1].reflect=0x400;
      sphere[1].r=((float)0x3);
      sphere[1].r2=((float)0x9);
      sphere[1].r_inv=((float)0.333251);
          //initialize spheres
      sphere[2].x=(float)0;
      sphere[2].y=((float)0xf000)/4096.0;
      sphere[2].z=((float)0x5000)/4096.0;
      sphere[2].color=0x001f1f;
      sphere[2].reflect=0x400;
      sphere[2].r=((float)0x3);
      sphere[2].r2=((float)0x9);
      sphere[2].r_inv=((float)0.333251);
          //initialize spheres
      sphere[3].x=((float)0xf000)/4096.0;
      sphere[3].y=((float)0xf000)/4096.0;
      sphere[3].z=((float)0x5000)/4096.0;
      sphere[3].color=0x7FE0;
      sphere[3].reflect=0x400;
      sphere[3].r=((float)0x3);
      sphere[3].r2=0x9;
      sphere[3].r_inv=0.333251;
          //initialize spheres
      sphere[4].x=0/4096.0;
      sphere[4].y=0x15000/4096.0;
      sphere[4].z=0x15000/4096.0;
      sphere[4].color=0x3E0;
      sphere[4].reflect=0x800;
      sphere[4].r=0xf;
      sphere[4].r2=0xe1;
      sphere[4].r_inv=0.06665;
          //initialize spheres
      sphere[5].x=0x15000/4096.0;
      sphere[5].y=0/4096.0;
      sphere[5].z=0x15000/4096.0;
      sphere[5].color=0x7C00;
      sphere[5].reflect=0x800;
      sphere[5].r=0xf;
      sphere[5].r2=0xe1;
      sphere[5].r_inv=0.06665;
          //initialize spheres
      sphere[6].x=0xf000/-4096.0;
      sphere[6].y=0xf000/-4096.0;
      sphere[6].z=0x5000/4096.0;
      sphere[6].color=0x00001f;
      sphere[6].reflect=0x400;
      sphere[6].r=0x3;
      sphere[6].r2=0x9;
      sphere[6].r_inv=0.333251;
          //initialize spheres
      sphere[7].x=0xf000/-4096.0;
      sphere[7].y=0/4096.0;
      sphere[7].z=0x5000/4096.0;
      sphere[7].color=0x3DFF;
      sphere[7].reflect=0x400;
      sphere[7].r=0x3;
      sphere[7].r2=0x9;
      sphere[7].r_inv=0.333251;
          //initialize spheres
      sphere[8].x=0xf000/4096.0;
      sphere[8].y=0xf000/-4096.0;
      sphere[8].z=0x5000/4096.0;
      sphere[8].color=0x57FF;
      sphere[8].reflect=0x400;
      sphere[8].r=0x3;
      sphere[8].r2=0x9;
      sphere[8].r_inv=0.333251;
      
      sphere[9].x=0/4096.0;
      sphere[9].y=0xf000/-4096.0;
      sphere[9].z=0x5000/4096.0;
      sphere[9].color=0x3DEF;
      sphere[9].reflect=0x400;
      sphere[9].r=0x3;
      sphere[9].r2=0x9;
      sphere[9].r_inv=0.333251;
      
      sphere[10].x=0xf000/-4096.0;
      sphere[10].y=0xf000/4096.0;
      sphere[10].z=0x5000/4096.0;
      sphere[10].color=0x3D8C;
      sphere[10].reflect=0x400;
      sphere[10].r=0x3;
      sphere[10].r2=0x9;
      sphere[10].r_inv=0.333251;
      
      sphere[11].x=0x15000/-4096.0;
      sphere[11].y=0/4096.0;
      sphere[11].z=0x15000/4096.0;
      sphere[11].color=0x3DE0;
      sphere[11].reflect=0x800;
      sphere[11].r=0xf;
      sphere[11].r2=0xe1;
      sphere[11].r_inv=0.06665;
      
      sphere[12].x=0/4096.0;
      sphere[12].y=0x15000/-4096.0;
      sphere[12].z=0x15000/4096.0;
      sphere[12].color=0x3C6C;
      sphere[12].reflect=0x800;
      sphere[12].r=0xf;
      sphere[12].r2=0xe1;
      sphere[12].r_inv=0.06665;
    }
    //picks the gripes scene with 7 spheres clustered together
    else if (scene=2)
    {
        sphere[0].x=-4;    sphere[0].y=0;    sphere[0].z=4;
    sphere[1].x=-4;    sphere[1].y=0;    sphere[1].z=8;
    sphere[2].x=-4;    sphere[2].y=0;    sphere[2].z=12;
    sphere[3].x=0;    sphere[3].y=0;    sphere[3].z=6;
    sphere[4].x=0;    sphere[4].y=0;    sphere[4].z=10;
    sphere[5].x=0;    sphere[5].y=0;    sphere[5].z=14;
    sphere[6].x=4;    sphere[6].y=0;    sphere[6].z=8;
    sphere[7].x=4;    sphere[7].y=0;    sphere[7].z=12;    
    sphere[8].x=-2;    sphere[8].y=3;    sphere[8].z=11;
    sphere[9].x=2;    sphere[9].y=3;    sphere[9].z=7;
    sphere[10].x=-2;    sphere[10].y=-3;    sphere[10].z=11;
    sphere[11].x=2;    sphere[11].y=-3;    sphere[11].z=7;
    
       sphere[12].x=5;    sphere[12].y=0;    sphere[12].z=17;
    sphere[12].color=0x3E0;
     sphere[12].reflect=0x400;    sphere[12].r=((float)0x3);    sphere[12].r2=((float)0x9);    sphere[12].r_inv=((float)0.333251);

    //set the velocity
      int i;   
      for (i=0; i<12; i++) {
        sphere[i].vx=0;
        sphere[i].vy=0;
        sphere[i].vz=0;
        sphere[i].count=0;
        sphere[i].color=0x3C6C;      sphere[i].reflect=0x400;    sphere[i].r=((float)0x2);    sphere[i].r2=((float)0x4);    sphere[i].r_inv=((float)0.5);
      }
         IOWR_ALTERA_AVALON_PIO_DATA(VALID_BASE, 0);
    }  
    
    //dynamic scene with bouncing spheres  
    else if (scene=3)
    {  
      int i;
      for (i=0; i<length; i++) {
         sphere[i].x=15*i;
         sphere[i].y=0.0;
         sphere[i].z=0;
         sphere[i].color=5000*(i+1);
         sphere[i].reflect=0;
         sphere[i].r=3;
         sphere[i].r2=pow(sphere[i].r, 2);
         sphere[i].r_inv=1/sphere[i].r;
         sphere[i].vx=1*(length+1);
         sphere[i].vy=1*(length+1);
         sphere[i].vz=1*(length+1);
         sphere[i].count=0;
      }
     IOWR_ALTERA_AVALON_PIO_DATA(VALID_BASE, 0);
    }
   
}


void motion (int num) {
  float x, y, z, vx, vy, vz, radius;
  
    x = sphere[num].x;
    y = sphere[num].y;
    z =  sphere[num].z;
    vx = sphere[num].vx;
    vy =  sphere[num].vy;
    vz =  sphere[num].vz;
    radius = sphere[num].r;
  
  float bound, boing;
  bound = 30; //boundary for the world
  boing = 0.005; //elasticity coefficient
  
  //checks against left plane
  if (x-radius <= -bound) {
    vx = -vx;
    x= radius-bound;
    
    //put in damp force
    vx = vx-boing*vx;
    vy = vy-boing*vy;
    vz = vz-boing*vz;
  }
  
  //checks against right plane
  if (x+radius >= bound) {
    vx = -vx;
    x= bound-radius;
    //put in damp force
    vx = vx-boing*vx;
    vy = vy-boing*vy;
    vz = vz-boing*vz;
  }
  
  //checks against back plane
  if (y-radius <= -bound) {
    vy = -vy;
    y= radius-bound;
    
    //put in damp force
    vx = vx-boing*vx;
    vy = vy-boing*vy;
    vz = vz-boing*vz;
  }
  
  //checks against front plane
  if (y+radius >= bound) {
    vy = -vy;
    y= bound-radius;
    //put in damp force
    vx = vx-boing*vx;
    vy = vy-boing*vy;
    vz = vz-boing*vz;
  }
  
    //checks against bottom plane
  if (z-radius <= -16) {
    vz = -vz;
    z= radius-bound;
    
    //put in damp force
    vx = vx-boing*vx;
    vy = vy-boing*vy;
    vz = vz-boing*vz;
  }
  
  //checks against top plane
  if (z+radius >= -5) {
    vz = -vz;
    z= bound-radius;
    //put in damp force
    vx = vx-boing*vx;
    vy = vy-boing*vy;
    vz = vz-boing*vz;
  }
  
  
  //check against other balls
  float distance;
  float r[3], v[3], delta_v[3];
  int i, /*count,*/ j;
  //count = 0;
  for (i=0; i<length; i++)
  {
    if (i != num) 
    {
      //calculates the distance squared between the current ball and other balls
      distance = pow(x-sphere[i].x, 2) + pow(y-sphere[i].y, 2) + pow(z-sphere[i].z, 2);
      //if the distance squared is less than the sum of the radius squared, bounce happens
      if (distance <= pow((radius + sphere[i].r), 2) && sphere[num].count==0)
      {
         distance = sqrt(distance); //gets the real distance
         r[0] = x-sphere[i].x;
         r[1] = y-sphere[i].y;
         r[2] = z-sphere[i].z;
         v[0] = vx-sphere[i].vx;
         v[1] = vy-sphere[i].vy;
         v[2] = vz-sphere[i].vz;
         for (j=0; j<3; j++)
         {
            delta_v[j] = -(r[j]/distance)*((r[j]*v[j])/distance);
         }
         
         //update the velocity vector for both spheres
         vx = vx+delta_v[0];
         vy = vy+delta_v[1];
         vz = vz+delta_v[2];
         sphere[i].vx = sphere[i].vx-delta_v[0];
         sphere[i].vy = sphere[i].vy-delta_v[1];
         sphere[i].vz = sphere[i].vz-delta_v[2];
         
          //put in damp force
          /*
          vx = vx-boing*vx;
          vy = vy-boing*vy;
          vz = vz-boing*vz;
          sphere[i].vx = sphere[i].vx-boing*sphere[i].vx;
          sphere[i].vy = sphere[i].vy-boing*sphere[i].vy;
          sphere[i].vz = sphere[i].vz-boing*sphere[i].vz;
         */
          
         //set a counters so the balls dont get captured
         //each sphere keeps its own counters
         if ((vx<0.0001 || vy<0.0001 || vz<0.0001)/*&&(sphere[i].vx<0.0001 || sphere[i].vy<0.0001 || sphere[i].vz<0.0001)*/)
          sphere[num].count=100;
         else if ((vx<0.001 || vy<0.001 || vz<0.001)/*&&(sphere[i].vx<0.0001 || sphere[i].vy<0.0001 || sphere[i].vz<0.0001)*/)
          sphere[num].count =50;
         else
          sphere[num].count =10;
      }
      else if (sphere[num].count>0)
          sphere[num].count--;
    }
  }
  
  //put in effect of gravity
  //vz = vz-10;

  //move the pixel to new pixel location
  x = x+vx;
  y = y+vy;
  z = z+vz;

  //updates the sphere properties
  sphere[num].x = x;
  sphere[num].y = y;
  sphere[num].z = z;
  sphere[num].vx = vx;
  sphere[num].vy = vy;
  sphere[num].vz = vz;

}

void rotate (int direction, float theta)
{
  int i;
  
  switch (direction)
  {
    //direction =1 rotate right, CCW around z
    case 32:{
      for (i=0; i<length; i++)
      {
        sphere[i].x = sphere[i].x*cos(-theta) + sphere[i].y*sin(-theta);
        sphere[i].y = -sphere[i].x*sin(-theta) + sphere[i].y*cos(-theta);
      }
    break;}
  //direction =2 rotate right, CW around z
    case 16:{
  
      for (i=0; i<length; i++)
      {
        sphere[i].x = sphere[i].x*cos(theta) + sphere[i].y*sin(theta);
        sphere[i].y = -sphere[i].x*sin(theta) + sphere[i].y*cos(theta);
      }
    break;
    }
  //direction =3 rotate left, CCW around x
    case 8:{
      for (i=0; i<length; i++)
      {
        sphere[i].y = sphere[i].y*cos(-theta) + sphere[i].z*sin(-theta);
        sphere[i].z = -sphere[i].y*sin(-theta) + sphere[i].z*cos(-theta);
      }
    break;}
  //direction =4 rotate right, CW around x
    case 4:{
      for (i=0; i<length; i++)
      {
        sphere[i].y = sphere[i].y*cos(theta) + sphere[i].z*sin(theta);
        sphere[i].z = -sphere[i].y*sin(theta) + sphere[i].z*cos(theta);
      }
    break;}
  
  //direction =5 rotate left, CCW around y
   case 2:{
      for (i=0; i<length; i++)
      {
        sphere[i].x = sphere[i].x*cos(-theta) + sphere[i].z*sin(-theta);
        sphere[i].z = -sphere[i].x*sin(-theta) + sphere[i].z*cos(-theta);
      }
   break;}
  //direction =6 rotate right, CW around y
   case 1:{
    for (i=0; i<length; i++)
    {
      sphere[i].x = sphere[i].x*cos(theta) + sphere[i].z*sin(theta);
      sphere[i].z = -sphere[i].x*sin(theta) + sphere[i].z*cos(theta);
    }
   break;}
  }
   
}
    