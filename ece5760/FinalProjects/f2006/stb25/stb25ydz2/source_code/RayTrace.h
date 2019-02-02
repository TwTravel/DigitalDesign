`define ROffset 95:72
`define XSign 71
`define YSign 47
`define ZSign 23
`define XOffset 71:48 
`define YOffset 47:24
`define ZOffset 23:0
`define IsLight 207
`define R1Sign  206
`define R1Offset 206:183
`define R2Offset 182:135
`define RFOffset 134:123
`define TROffset 122:111
`define COffset  110:96
`define RCOffset 110:106
`define GCOffset 105:101
`define BCOffset 100:96
`define LastSphere 8 /*number of spheres minus 1*/
`define InitRay  0
`define Shadow0  1
`define Reflect1 2
`define Shadow1  3
`define Reflect2 4
`define Shadow2  5
`define Reflect3 6
`define Shadow3  7
`define IsRay    (raystate[0]==0)
`define IsShadow (raystate[0]==1)
`define MinWeight 12'h028 /*1% .01*/
//CheckerWidth4,A24,B24,C24,D24,Xn24,Yn24,Zn24,R5,G5,B5,HasLimits1,Reflec12,XL12,YL12,ZL12
`define ZLOffset 11:0
`define YLOffset 23:12
`define XLOffset 35:24
`define RfPOffset 47:36
`define HasLimits (Planes[planecount][48])
`define BPOffset 53:49
`define GPOffset 58:54
`define RPOffset 63:59
`define ZnOffset 87:64
`define ZnSign   87
`define YnOffset 111:88
`define YnSign   111
`define XnOffset 135:112
`define XnSign   135
`define DOffset  159:136
`define DSign    159
`define CpOffset  183:160
`define CpSign    183
`define BpOffset  207:184
`define BpSign    207
`define ApOffset  231:208
`define ApSign    231
`define CheckerWidth 235:232

//`define Shadow   1
//`define Ray      0
//wire [206:0] Spheres[7:0];
//1/Radius Radius^2 Reflectivity(fraction) Translucency(fraction) R G B Radius X Y Z					
//assign Spheres[0] = { 24'h000080 , 48'h000400000000 , 12'h000 , 12'h000 , 5'h00 , 5'h00 , 5'h00 , 24'h020000 , 24'h000000 , 24'h000000, 24'h100000 };

//Reflectivity(fraction) Translucency(fraction) R G B Radius X Y Z					
//assign Spheres[0] = {12'h , 12'h , 5'h , 5'h , 5'h , 24'h , 24'h , 24'h, 24'h };

`define vadd(a,b,out) out[`XOffset] <= a[`XOffset] + b[`XOffset]; \
					  out[`YOffset] <= a[`YOffset] + b[`YOffset]; \
					  out[`ZOffset] <= a[`ZOffset] + b[`ZOffset];

`define vsub(a,b,out) out[`XOffset] <= a[`XOffset] + b[`XOffset]; \
					  out[`YOffset] <= a[`YOffset] + b[`YOffset]; \
					  out[`ZOffset] <= a[`ZOffset] + b[`ZOffset];

`define vscale(a,k,out) out[`XOffset] <= ((a[`XOffset]*k)>>12); \
						out[`YOffset] <= ((a[`YOffset]*k)>>12); \
						out[`ZOffset] <= ((a[`ZOffset]*k)>>12); 
						
`define vmag(a,mag) mag <= smult24(a[`XOffset],a[`XOffset]) + smult24(a[`YOffset],a[`YOffset]) + smult24(a[`ZOffset],a[`ZOffset]);

`define smult24(a,b) ((a^b)?((~(((a[23])?((~a)+1):a)*((b[23])?((~b)+1):b)))+1):(((a[23])?((~a)+1):a)*((b[23])?((~b)+1):b)))

`define abs_fx(in,out) out <= (in[23])?((~in) + 1):in;