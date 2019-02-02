
void send_iso(unsigned int *a_ptr,unsigned int bytesize,unsigned int ptl,unsigned int addr)
{
 random_write(a_ptr,addr,920);
}

unsigned int error_recorder(char mode,int ccode1, int ccode2)
{
 static int cnt=0;
 static int c1[2048];
 static int c2[2048];

 int data2return;

 if(mode=='W')
 {
  c1[cnt]=ccode1;
  c2[cnt]=ccode2;
  cnt++;

  if(cnt>2047) {cnt=2047;}
 }

 if(mode=='R')
 {
  data2return=c1[ccode1];
  data2return=data2return<<8;
  data2return|=c2[ccode2];
 }

 if(mode=='C')
 {
  data2return=cnt;
 }

 if(mode=='Z')
 {
  cnt=0;
 }

 return(data2return);
}

unsigned int addr_info(int addr,int mode,int dtype,int para)
{
 static unsigned int speed[8];
 static unsigned int maxpac[8];
 static unsigned int iman[8];
 static unsigned int ipro[8];

 unsigned int data2return;

 //Displaying data
 if(mode=='D')
 {
  printf("\nPort 1 : Speed[%2d] MPS[%4d] iMan[%2d] iPro[%2d]",speed[1],maxpac[1],iman[1],ipro[1]);
  printf("\nPort 2 : Speed[%2d] MPS[%4d] iMan[%2d] iPro[%2d]",speed[2],maxpac[2],iman[2],ipro[2]);
 }

 //Writing data
 if(mode=='W')
 {
  if(dtype=='S')
  {
   speed[addr]=para;
  }

  if(dtype=='M')
  {
   maxpac[addr]=para;
  }

  if(dtype=='O') //Manufaturer
  {
   iman[addr]=para;
  }

  if(dtype=='P') //Product
  {
   ipro[addr]=para;
  }
 }

 //Reading data
 if(mode=='R')
 {
  if(dtype=='S')
  {
   data2return=speed[addr];
  }

  if(dtype=='M')
  {
   data2return=maxpac[addr];
  }

  if(dtype=='O')
  {
   data2return=iman[addr];
  }

  if(dtype=='P')
  {
   data2return=ipro[addr];
  }
 }

 return(data2return);
}

unsigned int get_port_speed(unsigned int port)
{
 if(port==1) {return(port1speed);}
 if(port==2) {return(port2speed);}
}

void set_port_speed(unsigned int port, unsigned int speed)
{
 if(port==1)
 {
  port1speed=speed;
  addr_info(1,'W','S',speed);
 }

 if(port==2)
 {
  port2speed=speed;
  addr_info(2,'W','S',speed);
 }

 port_speed=speed;
}



void poll(unsigned int poll_len)
{
 unsigned int temp=0;

 do
  {
   temp++;
  }
 while(temp<poll_len);
}

struct ptd_struct
{
 unsigned int c_code;
 unsigned int active_bit;
 unsigned int toggle;
 unsigned int actual_size;
 unsigned int endpoint;
 unsigned int last_ptd;
 unsigned int speed;
 unsigned int max_size;
 unsigned int pid;
 unsigned int total_size;
 unsigned int format;
 unsigned int func_addr;
 unsigned char fm;
}
ptd2send;

unsigned int send_control(unsigned int *a_ptr,unsigned int *r_ptr)
{
 unsigned int cnt=retry;
 unsigned int active_bit;
 unsigned int abuf[128];
 unsigned int UpInt;
 unsigned int ccode;
 unsigned int timeout=9;
 unsigned int ccode1=0,ccode2=0;

 do
 {
  cnt=retry;

  write_atl(a_ptr,8);  //write 16 bytes

  w16(HcUpInt,0x100);
  r32(HcATLDone); //read and clear done map, enables ATL interrupt
  r32(HcATLDone); //read and clear done map, enables ATL interrupt
  w16(HcBufStatus,0x08);
  do
   {
    UpInt=r16(HcUpInt);
    if( (UpInt&0x100)!=0) {active_bit=0;}
    else {active_bit=1;}    
    poll(50);
    cnt--;
   }
  while((cnt!=0)   &&   (active_bit!=0));
  w16(HcBufStatus,0x00);
  read_atl(r_ptr,72);

  //This part does 1 retry if ccode!=0, and records the errors
  ccode=((*r_ptr)&(0xF000))>>12;
  if(timeout==9) {ccode1=ccode;}
  if(timeout==8) {ccode2=ccode;}

  timeout--;
 }
 while(  (ccode!=0) && (timeout!=0)  );

 if(ccode1!=0 && ccode2!=0)
 {
  error_recorder('W',ccode1,ccode2);
 }
 return(cnt);
}
/************************************************************************************************
                    Change the Send Int, 
                    so stick can increment while holding the mouse botton, without moving mouse
************************************************************************************************/
unsigned int send_int(unsigned int *a_ptr,unsigned int *r_ptr)
{
 unsigned int cnt=retry;
 unsigned int active_bit;
 unsigned int abuf[128];
 unsigned int UpInt;

// unsigned int far *dptr;
 unsigned int  *dptr;

 dptr=a_ptr;

 write_int(a_ptr,8);  //write 16 bytes

 w16(HcUpInt,0x0080);
 w16(HcBufStatus,0x04);

 r32(HcIntDone); //read and clear done map, enables ATL interrupt

 do
  {
   UpInt=r16(HcUpInt);
   // while in the loop of no active bit,
   // if the mouse was pressed, it will still elongate the stick
   if(cnt%8==0)
        Continue_Stick(); // continue the previous motion for the stick if no mouse event
   if( (UpInt&0x80)!=0) {active_bit=0;}
   else {active_bit=1;}
    
   poll(50);
   cnt--;
  }
 while((cnt>0)   &&   (active_bit!=0));
 w16(HcBufStatus,0x00);

 read_int(r_ptr,72);
 return(cnt);
}

void full_ptd(int *rptr,char token,char ep,int max,int total,char tog,char addr,char port)
{
 ptd2send.c_code=0x0F;
 ptd2send.active_bit=1;
 ptd2send.toggle=tog;
 ptd2send.actual_size=0;
 ptd2send.endpoint=ep;
 ptd2send.last_ptd=0;

 ptd2send.speed=port_speed;
 if(port==1) {ptd2send.speed=port1speed;}
 if(port==2) {ptd2send.speed=port2speed;}

 ptd2send.max_size=max;
 ptd2send.total_size=total;
 ptd2send.pid= token;
 ptd2send.format=0;
 ptd2send.fm=0;
 ptd2send.func_addr=addr;

 *(rptr+0)= (ptd2send.c_code        &0x0000)<<12
           |(ptd2send.active_bit    &0x0001)<<11
           |(ptd2send.toggle        &0x0001)<<10
           |(ptd2send.actual_size   &0x03FF);

 *(rptr+1)=  (ptd2send.endpoint     &0x000F)<<12
           |(ptd2send.last_ptd      &0x0001)<<11
           |(ptd2send.speed         &0x0001)<<10
           |(ptd2send.max_size      &0x03FF);

 *(rptr+2)=  (0x0000                &0x000F)<<12
           |(ptd2send.pid           &0x0003)<<10
           |(ptd2send.total_size    &0x03FF);

 *(rptr+3)=  (ptd2send.fm            &0x00FF)<<8
           |(ptd2send.format        &0x0001)<<7
           |(ptd2send.func_addr     &0x007F);
}

void make_ptd(int *rptr,char token,char ep,int max,char tog,char addr,char port)
{
 ptd2send.c_code=0x0F;
 ptd2send.active_bit=1;
 ptd2send.toggle=tog;
 ptd2send.actual_size=0;
 ptd2send.endpoint=ep;
 ptd2send.last_ptd=0;

 ptd2send.speed=port_speed;
 if(port==1) {ptd2send.speed=port1speed;}
 if(port==2) {ptd2send.speed=port2speed;}

 ptd2send.max_size=max;
 ptd2send.total_size=max;
 ptd2send.pid= token;
 ptd2send.format=0;
 ptd2send.fm=0;
 ptd2send.func_addr=addr;

 *(rptr+0)= (ptd2send.c_code        &0x0000)<<12
           |(ptd2send.active_bit    &0x0001)<<11
           |(ptd2send.toggle        &0x0001)<<10
           |(ptd2send.actual_size   &0x03FF);

 *(rptr+1)=  (ptd2send.endpoint     &0x000F)<<12
           |(ptd2send.last_ptd      &0x0001)<<11
           |(ptd2send.speed         &0x0001)<<10
           |(ptd2send.max_size      &0x03FF);

 *(rptr+2)=  (0x0000                &0x000F)<<12
           |(ptd2send.pid           &0x0003)<<10
           |(ptd2send.total_size    &0x03FF);

 *(rptr+3)=  (ptd2send.fm            &0x00FF)<<8
           |(ptd2send.format        &0x0001)<<7
           |(ptd2send.func_addr     &0x007F);
}

void new_make_ptd(int *rptr,char token,char ep,int max,char tog,char addr,char port, unsigned int total)
{
 ptd2send.c_code=0x0F;
 ptd2send.active_bit=1;
 ptd2send.toggle=tog;
 ptd2send.actual_size=0;
 ptd2send.endpoint=ep;
 ptd2send.last_ptd=0;

 ptd2send.speed=port_speed;
 if(port==1) {ptd2send.speed=port1speed;}
 if(port==2) {ptd2send.speed=port2speed;}

 ptd2send.max_size=max;
 ptd2send.total_size=total;
 ptd2send.pid= token;
 ptd2send.format=0;
 ptd2send.fm=0;
 ptd2send.func_addr=addr;

 *(rptr+0)= (ptd2send.c_code        &0x0000)<<12
           |(ptd2send.active_bit    &0x0001)<<11
           |(ptd2send.toggle        &0x0001)<<10
           |(ptd2send.actual_size   &0x03FF);

 *(rptr+1)=  (ptd2send.endpoint     &0x000F)<<12
           |(ptd2send.last_ptd      &0x0001)<<11
           |(ptd2send.speed         &0x0001)<<10
           |(ptd2send.max_size      &0x03FF);

 *(rptr+2)=  (0x0000                &0x000F)<<12
           |(ptd2send.pid           &0x0003)<<10
           |(ptd2send.total_size    &0x03FF);

 *(rptr+3)=  (ptd2send.fm            &0x00FF)<<8
           |(ptd2send.format        &0x0001)<<7
           |(ptd2send.func_addr     &0x007F);
}



void make_int_ptd(int *rptr,char token,char ep,int max,char tog,char addr,char port,int freq)
{
 ptd2send.c_code=0x0F;
 ptd2send.active_bit=1;
 ptd2send.toggle=tog;
 ptd2send.actual_size=0;
 ptd2send.endpoint=ep;
 ptd2send.last_ptd=0;

 ptd2send.speed=port_speed;
 if(port==1) {ptd2send.speed=port1speed;}
 if(port==2) {ptd2send.speed=port2speed;}

 ptd2send.max_size=max;
 ptd2send.total_size=max;
 ptd2send.pid= token;
 ptd2send.format=0;
 ptd2send.fm=freq;
 ptd2send.func_addr=addr;

 *(rptr+0)= (ptd2send.c_code        &0x0000)<<12
           |(ptd2send.active_bit    &0x0001)<<11
           |(ptd2send.toggle        &0x0001)<<10
           |(ptd2send.actual_size   &0x03FF);

 *(rptr+1)=  (ptd2send.endpoint     &0x000F)<<12
           |(ptd2send.last_ptd      &0x0001)<<11
           |(ptd2send.speed         &0x0001)<<10
           |(ptd2send.max_size      &0x03FF);

 *(rptr+2)=  (0x0000                &0x000F)<<12
           |(ptd2send.pid           &0x0003)<<10
           |(ptd2send.total_size    &0x03FF);

 *(rptr+3)=  (ptd2send.fm            &0x00FF)<<8
           |(ptd2send.format        &0x0001)<<7
           |(ptd2send.func_addr     &0x007F);
}


//This PTD is used to simple bulk test to check the mechanism of Skip/Last
void make_xbulk(char ep,char addr,int *rptr)
{
 unsigned int *ptd_ptr;

 ptd2send.c_code=0x0F;
 ptd2send.active_bit=1;
 ptd2send.toggle=0;
 ptd2send.actual_size=0;
 ptd2send.endpoint=ep;
 ptd2send.last_ptd=0;
 ptd2send.speed=0;
 ptd2send.max_size=128;
 ptd2send.total_size=128;
 ptd2send.pid= OUT;
 ptd2send.format=0;
 ptd2send.fm=0;
 ptd2send.func_addr=addr;

 *(rptr+0)= (ptd2send.c_code        &0x0000)<<12
           |(ptd2send.active_bit    &0x0001)<<11
           |(ptd2send.toggle        &0x0001)<<10
           |(ptd2send.actual_size   &0x03FF);

 *(rptr+1)= (ptd2send.endpoint      &0x000F)<<12
           |(ptd2send.last_ptd      &0x0001)<<11
           |(ptd2send.speed         &0x0001)<<10
           |(ptd2send.max_size      &0x03FF);

 *(rptr+2)= (0x0002                 &0x000F)<<12
           |(ptd2send.pid           &0x0003)<<10
           |(ptd2send.total_size    &0x03FF);

 *(rptr+3)= (ptd2send.fm            &0x00FF)<<8
           |(ptd2send.format        &0x0001)<<7
           |(ptd2send.func_addr     &0x007F);
}

void send_ptl(unsigned int *a_ptr,unsigned int bytesize,unsigned int ptl,unsigned int addr)
{
 unsigned int abuf[8];

 abuf[0]=*(a_ptr+0);
 abuf[1]=*(a_ptr+1);
 abuf[2]=*(a_ptr+2);
 abuf[3]=*(a_ptr+3);

 random_write(abuf,addr,176);
}

unsigned int ptl_ptd(char type_ptd,char last,char ep,unsigned int max,char tog,char addr,unsigned char frame_no)
{
 unsigned int *ptd_ptr;

 ptd2send.c_code=0x0F;
 ptd2send.active_bit=1;
 ptd2send.toggle=tog;
 ptd2send.actual_size=0;
 ptd2send.endpoint=ep;
 ptd2send.last_ptd=last;
 ptd2send.speed=port1speed;
 ptd2send.max_size=max;
 ptd2send.total_size=max;
 ptd2send.pid= type_ptd;
 ptd2send.format=1;
 ptd2send.fm=frame_no;
 ptd2send.func_addr=addr;

 c_ptd[0]=  (ptd2send.c_code        &0x0000)<<12
           |(ptd2send.active_bit    &0x0001)<<11
           |(ptd2send.toggle        &0x0001)<<10
           |(ptd2send.actual_size   &0x03FF);

 c_ptd[1]=  (ptd2send.endpoint      &0x000F)<<12
           |(ptd2send.last_ptd      &0x0001)<<11
           |(ptd2send.speed         &0x0001)<<10
           |(ptd2send.max_size      &0x03FF);

 c_ptd[2]=  (0x0000                 &0x000F)<<12
           |(ptd2send.pid           &0x0003)<<10
           |(ptd2send.total_size    &0x03FF);

 c_ptd[3]=  (ptd2send.fm            &0x00FF)<<8
           |(ptd2send.format        &0x0001)<<7
           |(ptd2send.func_addr     &0x007F);

 ptd_ptr=c_ptd;

 return(ptd_ptr);
}

void iso_ptd(unsigned int *iso,char type_ptd,char last,char ep,unsigned int max,char tog,char addr,unsigned char frame_no)
{
 ptd2send.c_code=0x0F;
 ptd2send.active_bit=1;
 ptd2send.toggle=tog;
 ptd2send.actual_size=0;
 ptd2send.endpoint=ep;
 ptd2send.last_ptd=last;
 ptd2send.speed=port1speed;
 ptd2send.max_size=max;
 ptd2send.total_size=max;
 ptd2send.pid= type_ptd;
 ptd2send.format=1;
 ptd2send.fm=frame_no;
 ptd2send.func_addr=addr;

 *(iso+0)=  (ptd2send.c_code        &0x0000)<<12
           |(ptd2send.active_bit    &0x0001)<<11
           |(ptd2send.toggle        &0x0001)<<10
           |(ptd2send.actual_size   &0x03FF);

 *(iso+1)=  (ptd2send.endpoint      &0x000F)<<12
           |(ptd2send.last_ptd      &0x0001)<<11
           |(ptd2send.speed         &0x0001)<<10
           |(ptd2send.max_size      &0x03FF);

 *(iso+2)=  (0x0000                 &0x000F)<<12
           |(ptd2send.pid           &0x0003)<<10
           |(ptd2send.total_size    &0x03FF);

 *(iso+3)=  (ptd2send.fm            &0x00FF)<<8
           |(ptd2send.format        &0x0001)<<7
           |(ptd2send.func_addr     &0x007F);
}

