
#include "system.h"
#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <time.h>
#include "altera_avalon_pio_regs.h"
#include "sys/alt_irq.h"
#include <unistd.h> //e.g. //usleep(5000000); is 5 seconds


// compute perspective projection given a list of vertices of triangles
// then clip it based on the field of view and output the new set of vertices

#define MAX_POLYGONS 30

#define true
#define false

// by calculating these unchanging constants ahead of time, we can get rid of 
// any floating point divides
// c1 = 2/(tan(FOVx*(pi/180)/2) * 2*nearPlane)
// c2 = 2/(tan(FOVy*(pi/180)/2) * 2*nearPlane)
// c3 = -(n+f)/(n-f)
// c4 = 2nf/(f-n)
#define c1 -0.2680
#define c2 -0.6682
#define c3 -1.0455
#define c4 -4.0909

// coordinate arithmetic 
#define ADD 0x01
#define SUBTRACT 0x02
#define SCALE 0x03
#define DOT 0x04
#define CROSS 0x05
#define SET 0x06

typedef struct {
    unsigned short x;
    unsigned short y;
    unsigned short z;
} coord;

typedef struct {
    float x;
    float y;
    float z;
} fcoord;


coord camerLoc, cameraVec, upDir;
fcoord u, v, w, edot;
fcoord g, up, e;

float globalXmin, globalXmax, globalYmin, globalYmax, globalZmin, globalZmax;

coord invertex[MAX_POLYGONS][3];
fcoord tvertex[MAX_POLYGONS][6];
coord outvertex[MAX_POLYGONS][6];

int nv[MAX_POLYGONS];
unsigned short pcolor[MAX_POLYGONS];
unsigned int totalPolygons = 0;

void convertWorldToCanonical(fcoord*);
void fcmath(fcoord*, fcoord*, fcoord*,  float, unsigned char);
void vertexOut(int, int);
char SutherlandHodgman(fcoord*);
coord mc(unsigned short, unsigned short, unsigned short);
fcoord mf(float, float, float);
void updateMax(unsigned int);
void performConversion(int);
void updateCamera(void);
void sendVertices(void);

void testProgram1(void);
void testProgram2(void);
void testProgram3(void);

int main(void) {
    int i, j;
    char numvert, index;
    float m, n;
    fcoord a, b, q, r;
    fcoord p[6];

    updateMax(0);

	testProgram1();
	testProgram2();
    testProgram3();
    
}

// this program draws 3 walls and moves the camera back and forward
void testProgram1(void) {
    int i, j, index;
    char idir, jdir;
    
    idir = 1;
    jdir = 1;
    
    invertex[0][0] = mc(0, 0, 0);
    invertex[0][2] = mc(0, 50, 0);
    invertex[0][1] = mc(50, 0, 0);
    invertex[1][0] = mc(50, 50, 0);
    invertex[1][2] = mc(0, 50, 0);
    invertex[1][1] = mc(50, 0, 0); 
    pcolor[0] = 0xF800;
    pcolor[1] = 0x8000;

    invertex[2][0] = mc(0, 0, 0);
    invertex[2][2] = mc(0, 0, 20);
    invertex[2][1] = mc(50, 0, 0);
    invertex[3][0] = mc(50, 0, 20);
    invertex[3][2] = mc(0, 0, 20);
    invertex[3][1] = mc(50, 0, 0);
    pcolor[2] = 0x003E;
    pcolor[3] = 0x0020;

    // left wall
    invertex[4][0] = mc(50, 0, 0);
    invertex[4][2] = mc(50, 0, 20);
    invertex[4][1] = mc(50, 50, 0);
    invertex[5][0] = mc(50, 50, 20);
    invertex[5][2] = mc(50, 0, 20);
    invertex[5][1] = mc(50, 50, 0);    
    pcolor[4] = 0x4820;
    pcolor[5] = 0x4820; 
    
    i = 25;
    j = 10;
    
    while (1) {
            i = i + idir;
            j = j + jdir;
            if (i == 45) { idir = -1; }
            else if (i == 5) { idir = 1; }
            if (j == 15) { jdir = -1; }
            else if (j == 5) { jdir = 1; }
            
            g = mf(1, 1, 0);
            e = mf(25,i,j);
            updateCamera();
            updateMax(0);
             for (index = 0; index < 6 ; index++) {
                performConversion(index);
                usleep(100);
             }
                
            sendVertices();           
            usleep(750000);
       }          
    
}

// this program moves a five-sided figure along a depth-varying rectangle to illustrate z-buffering
void testProgram2(void) {
    int i = 0;
    int j;
    int idir = 1;
 
    outvertex[0][0] = mc(25, 100, 5);
    outvertex[0][1] = mc(600, 100, 100);
    outvertex[0][2] = mc(600, 150, 100);
    outvertex[0][3] = mc(25, 150, 5);
    
    outvertex[1][0] = mc(550, 300, 5);
    outvertex[1][1] = mc(600, 300, 100);
    outvertex[1][2] = mc(600, 350, 100);
    outvertex[1][3] = mc(550, 350, 5);

    outvertex[3][0] = mc(25, 100, 5);
    outvertex[3][1] = mc(600, 100, 100);
    outvertex[3][2] = mc(600, 150, 100);
    outvertex[3][3] = mc(25, 150, 5);
        
    
    pcolor[0] = 0x4820;
    pcolor[1] = 0x8000;
    pcolor[2] = 0x0DF0;    
 
    nv[0] = 4;
    nv[1] = 4;
    nv[2] = 5;
    
    
    updateMax(3);
 
     while (1) {
            if (i >= 500) {
                  idir = -10;
            } else if (i <= 0) {
                  idir = 10;
            }            
            i = i + idir;

            outvertex[2][2] = mc(30+i, 120, 50);
            outvertex[2][3] = mc(70+i, 80, 50);
            outvertex[2][4] = mc(110+i, 120, 50);
            outvertex[2][0] = mc(90+i, 150, 50);
            outvertex[2][1] = mc(60+i, 160, 50);    

            for (j =0 ; j < totalPolygons; j++) {
                vertexOut(j, nv[j]);
            }            
            usleep(100000);
       }        
       
    
}

// this program moves six simultaneous triangles with varying depths
void testProgram3(void) {
    int i = 0;
    int k = 0;
    int j;
    int idir = 1;
    int kdir = 1;
 
    nv[0] = 3;
    nv[1] = 3;
    nv[2] = 3;
    nv[3] = 3;
    nv[4] = 3;
    nv[5] = 3;    
    
    updateMax(6);
 
 
      while (1) {
            if (i >= 500) {
                  idir = -5;
            } else if (i <= 0) {
                  idir = 5;
            }   
            if (k >= 380) {
                  kdir = -5;
            } else if (k <= 0) {
                  kdir = 5;
            }               
            i = i + idir;
            k = k + kdir;
                   
            outvertex[0][0] = mc(i, 25, 4);
            outvertex[0][1] = mc(i+50, 60, 30);
            outvertex[0][2] = mc(i, 90, 100);
            
            outvertex[1][0] = mc(i, 150, 100);
            outvertex[1][1] = mc(i+50, 150, 20);
            outvertex[1][2] = mc(i+50, 225, 69);
        
            outvertex[2][0] = mc(i+25, 300, 5);
            outvertex[2][1] = mc(i, 350, 5);
            outvertex[2][2] = mc(i+50, 400, 100);
        
            outvertex[3][0] = mc(80, k, 54);
            outvertex[3][1] = mc(140, k, 290);
            outvertex[3][2] = mc(90, k+50, 2);
            
            outvertex[4][0] = mc(200, k, 20);
            outvertex[4][1] = mc(200, k+50, 130);
            outvertex[4][2] = mc(280, k+50, 60);
        
            outvertex[5][0] = mc(390, k, 5);
            outvertex[5][1] = mc(450, k, 100);
            outvertex[5][2] = mc(490, k+50, 58);
 

            for (j =0 ; j < totalPolygons; j++) {
                vertexOut(j, nv[j]);
            }            
            usleep(50000);
       }        
       
    
}

// END OF TEST PROGRAMS
// START OF HELPER ROUTINES AND FUNCTIONS

// sends out the vertex corresponding to outvertex[polynum]
void vertexOut(int polynum, int numberVertices) {
    coord in;
    int i, j, vnum;
    for (i = 0; i < 6; i++) { 
        vnum = (i >= numberVertices)? numberVertices - 1: i;
        in = outvertex[polynum][vnum];
        printf("outputting {%d %d %d, %x} vertex %d polygon %d\n",in.x,in.y,in.z,pcolor[polynum],i,polynum);        
        IOWR_ALTERA_AVALON_PIO_DATA(XOUT_BASE, in.x);
        IOWR_ALTERA_AVALON_PIO_DATA(YOUT_BASE, in.y);
        IOWR_ALTERA_AVALON_PIO_DATA(ZOUT_BASE, in.z);
        IOWR_ALTERA_AVALON_PIO_DATA(VERTEXNUM_BASE, i);
        IOWR_ALTERA_AVALON_PIO_DATA(POLYCOLOR_BASE, pcolor[polynum]);   
        IOWR_ALTERA_AVALON_PIO_DATA(POLYOUT_BASE, polynum);
        IOWR_ALTERA_AVALON_PIO_DATA(READY_BASE, 0xF);
        usleep(100);
        IOWR_ALTERA_AVALON_PIO_DATA(READY_BASE, 0x0);
    }
    //while (polynum == 3) { }
    
}

// updates the total number of polygons in the scene
void updateMax(unsigned int x) {
    if (x > 10) { x = 10; }
    IOWR_ALTERA_AVALON_PIO_DATA(MAXPOLYGONS_BASE, x);
    totalPolygons = x;
}

// converts all the vertices in a polygon to canonincal, clips them, 
// and returns the result, still in canonincal form
void performConversion(int polynum) {   
    fcoord tv[6];  
    int i, j;
    
    for (i=0;i<3;i++) {
        tv[i].x = (float)(invertex[polynum][i].x);
        tv[i].y = (float)(invertex[polynum][i].y);
        tv[i].z = (float)(invertex[polynum][i].z);                                
        convertWorldToCanonical(&tv[i]);
        //printf("\n{%f, %f, %f}", tv[i].x, tv[i].y, tv[i].z);
    }
    
    j = SutherlandHodgman(tv);   
    
    if (j > 1) {
        for (i=0;i<j;i++) {
            globalXmin = tv[i].x < globalXmin ? tv[i].x : globalXmin;
            globalXmax = tv[i].x > globalXmax ? tv[i].x : globalXmax;
            globalYmin = tv[i].y < globalYmin ? tv[i].y : globalYmin;
            globalYmax = tv[i].y > globalYmax ? tv[i].y : globalYmax;
            globalZmin = tv[i].z < globalZmin ? tv[i].z : globalZmin;
            globalZmax = tv[i].z > globalZmax ? tv[i].z : globalZmax; 
            tvertex[totalPolygons][i].x = tv[i].x;
            tvertex[totalPolygons][i].y = tv[i].y;
            tvertex[totalPolygons][i].z = tv[i].z;
            nv[totalPolygons] = j;
            printf("outputting {%f %f %f} vertex %d polygon %d\n",tv[i].x,tv[i].y,tv[i].z,i,polynum);
        }
        //printf("Sending polygon %d as %d..\n", polynum, totalPolygons);
        //vertexOut(totalPolygons, j);
        updateMax(totalPolygons + 1);
    }
}

// scales all the vertices appropriately, then changes them into window space and sends them out sequentially
void sendVertices(void) {
    int i, j;
    float xavg, yavg, xdiv, ydiv, zavg, zdiv;
    //while (1) { }
    fcoord tmp;
    xavg = (globalXmax + globalXmin) / 2;
    yavg = (globalYmax + globalYmin) / 2;
    zavg = (globalZmax + globalZmin) / 2;
    xdiv = 2 / (globalXmax - globalXmin);
    ydiv = 2 / (globalYmax - globalYmin);
    zdiv = 2 / (globalZmax - globalZmin);
    for (i = 0 ; i < totalPolygons; i++) {
        for (j = 0; j < nv[i]; j++) {   
            tmp = tvertex[i][j];
            outvertex[i][j].x = (unsigned short)(((tvertex[i][j].x - xavg) * xdiv) * 295 + 320);
            outvertex[i][j].y = 480 - (unsigned short)(((tvertex[i][j].y - yavg) * ydiv) * 215 + 240);
            outvertex[i][j].z = (unsigned short)((((tvertex[i][j].z - zavg) * zdiv) + 1) * 200) + 10;
            //outvertex[i][j].x = (unsigned short)(tvertex[i][j].x * 590 + 320);
            //outvertex[i][j].y = (unsigned short)(tvertex[i][j].y * 215 + 240);
            //outvertex[i][j].z = (unsigned short)(tvertex[i][j].z * 300 + 300);                        
        
        }
        vertexOut(i, nv[i]);
    }    
}

// converts from world space to canonincal space
void convertWorldToCanonical(fcoord* fin) {
    fcoord tmp, in;
    float h;
    in = (fcoord) (*fin);
    tmp.x = (c1 * edot.x) - (c1 * u.x * in.x) - (c1 * u.y * in.y) - (c1 * u.z * in.z);
    tmp.y = (c2 * edot.y) - (c2 * v.x * in.x) - (c2 * v.y * in.y) - (c2 * v.z * in.z);
    tmp.z = (c3 * edot.z) - (c3 * w.x * in.x) - (c3 * w.y * in.y) - (c3 * w.z * in.z) + c4;
    h = w.x*in.x + w.y*in.y + w.z*in.z - edot.z;
    //tmp.z = tmp.z;
    fcmath(&tmp, &tmp, NULL, 1/h, SCALE); 
    *fin = tmp;        
}

// an instantiation of the Sutherland-Hodgman algorithm for clipping
char SutherlandHodgman(fcoord* in) {
    fcoord temp[6];
    fcoord a, b, t1, delta;
    
    float t;
    int i, j, k, n, p, q;
    char numVertices = 3;
    
    for (i=0;i<6;i++) {
        n = 0; 
        for (j=0;j<numVertices;j++) {
            a = in[j];
            b = ((j+1) == numVertices) ? in[0] : in[j+1];
            
            fcmath(&delta, &a, &b, 0, SUBTRACT);
            switch (i) {
                case 0: p = a.x < -1; q = b.x < -1; break;
                case 1: p = a.x > 1; q = b.x > 1; break;
                case 2: p = a.y < -1; q = b.y < -1; break;                                
                case 3: p = a.y > 1; q = b.y > 1; break;
                case 4: p = a.z < -1; q = b.z < -1; break;
                case 5: p = a.z > 1; q = b.z > 1; break;                                            
            }
            //printf("\n p: %d q: %d", p, q);
            if (!p && p==q) {
                fcmath(&temp[n++], &b, NULL, 0, SET);
            } else if (p==q) {
                // do nothing
            } else if (q==0) {
                switch (i) {
                    case 0: t = (-1 - a.x) / delta.x; break;
                    case 1: t = (1 - a.x) / delta.x; break;
                    case 2: t = (-1 - a.y) / delta.y; break;
                    case 3: t = (1 - a.y) / delta.y; break;
                    case 4: t = (-1 - a.z) / delta.z; break;
                    case 5: t = (1 - a.z) / delta.z; break;
                }
                fcmath(&t1, &delta, NULL, t, SCALE);
                fcmath(&temp[n++], &a, &t1, 0, ADD);
                fcmath(&temp[n++], &b, NULL, 0, SET);
            } else if (p==0) {
                switch (i) {
                    case 0: t = (-1 - b.x) / delta.x; break;
                    case 1: t = (1 - b.x) / delta.x; break;
                    case 2: t = (-1 - b.y) / delta.y; break;
                    case 3: t = (1 - b.y) / delta.y; break;
                    case 4: t = (-1 - b.z) / delta.z; break;
                    case 5: t = (1 - b.z) / delta.z; break;
                }      
                fcmath(&t1, &delta, NULL, t, SCALE);
                fcmath(&temp[n++], &b, &t1, 0, ADD); 
            }                         
        }
        
        numVertices = n;
        //printf("----\n");
        for (k=0;k<numVertices;k++) {
            fcmath(&in[k], &temp[k], NULL, 0, SET);
            //in[k] = temp[k];
            //printf("Iteration %d, vertex %d: {%f, %f, %f}\n", i, k, in[k].x, in[k].y, in[k].z);
        }                           
    }
    //while (1) { }
    return numVertices;
}

// a subroutine to update u, v, w and associated values after the camera position
// or angle has been changed
void updateCamera(void) {
    fcoord a;
    
    globalXmin = 1000;
    globalYmin = 1000;
    globalXmax = -1000;
    globalYmax = -1000;
    globalZmin = 1000;
    globalZmax = -1000;
    
    fcmath(&w, &g, NULL, -1.0, SCALE);
    fcmath(&u, &up, &w, 0, CROSS);
    fcmath(&v, &w, &u, 0, CROSS);
    
    fcmath(&a, &u, &u, 0, DOT);
    fcmath(&u, &u, NULL, 1/sqrt(a.x), SCALE);

    fcmath(&a, &v, &v, 0, DOT);
    fcmath(&v, &v, NULL, 1/sqrt(a.x), SCALE);
    
    fcmath(&a, &w, &w, 0, DOT);
    fcmath(&w, &w, NULL, 1/sqrt(a.x), SCALE);
    
    fcmath(&a, &e, &u, 0, DOT);
    edot.x = a.x;
    fcmath(&a, &e, &v, 0, DOT);
    edot.y = a.x;
    fcmath(&a, &e, &w, 0, DOT);
    edot.z = a.x;
    
}

// vector math with floating point coordinates
void fcmath(fcoord* fout, fcoord* fin1, fcoord* fin2,  float c, unsigned char ptype) {
    fcoord out, in1, in2;
    out = (fcoord) (*fout);
    in1 = (fcoord) (*fin1);
    in2 = (fcoord) (*fin2);
    switch (ptype) {
        case ADD:
            out.x = in1.x + in2.x;
            out.y = in1.y + in2.y;
            out.z = in1.z + in2.z; 
            break;
        case SUBTRACT:
            out.x = in1.x - in2.x;
            out.y = in1.y - in2.y;
            out.z = in1.z - in2.z; 
            break;
        case SCALE:
            out.x = in1.x * c;
            out.y = in1.y * c;
            out.z = in1.z * c; 
            break;           
        case DOT:
            out.x = (in1.x * in2.x) + (in1.y * in2.y) + (in1.z * in2.z);
            out.y = out.x;
            out.z = out.x; 
            break;              
        case CROSS:
            out.x = (in1.y * in2.z) - (in1.z * in2.y);
            out.y = (in1.z * in2.x) - (in1.x * in2.z);
            out.z = (in1.x * in2.y) - (in1.y * in2.x);
            break; 
        case SET:
            out.x = in1.x;
            out.y = in1.y;
            out.z = in1.z;
            break;
    }
    *fout = out;
       
}

// created a regular, short coordinate
coord mc(unsigned short inx, unsigned short iny, unsigned short inz) {
    coord out;
    out.x = inx;
    out.y = iny;
    out.z = inz;
    return out;   
}
// create a floating point coordinate
fcoord mf(float inx, float iny, float inz) {
    fcoord out;
    out.x = inx;
    out.y = iny;
    out.z = inz;
    return out;   
}
