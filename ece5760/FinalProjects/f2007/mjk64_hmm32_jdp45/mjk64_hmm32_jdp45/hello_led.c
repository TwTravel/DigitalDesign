
#include "basic_io.h"
#include "test.h"
#include "LCD.h"
#include "DM9000A.C"

#include <string.h>
#include "system.h"
#include "altera_avalon_pio_regs.h"

#define MAX_ETH 1024

#define NONE_TYPE 0
#define ARP_TYPE 1
#define IP_TYPE  2

#define ET_PRE 0x08
#define ET_IP  0x00
#define ET_ARP 0x06

#define PIO_READ  IORD_ALTERA_AVALON_PIO_DATA
#define PIO_WRITE IOWR_ALTERA_AVALON_PIO_DATA

//unsigned int aaa,rx_len,i,packet_num;
//unsigned char RXT[68];

unsigned const char broadcast[] = {0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF};
unsigned const char my_mac[] = {0x01,0x60,0x6E,0x11,0x02,0x0F};

void ethernet_interrupts()
{
    int i;
    unsigned int rp_err, rx_len, type, data, ip_len;
    unsigned char RXT[MAX_ETH], mac_addr[6];

    type = NONE_TYPE;

    printf("ethernet interrupt...\n");

    rp_err=ReceivePacket (RXT,&rx_len);
    if(!rp_err) {
        //good debug info may be to print this whole ethernet packet here before processing it
        printf("receiving packet... (len %d)\n",rx_len);
        for(i=0;i<rx_len;i++) {
            if(i%8==0)
                printf("\n");
            printf("0x%02X,",RXT[i]);
        }
        printf("\n");
        //get the dest addr
        for(i=0; i<6; i++) {
            mac_addr[i] = RXT[i];
        }
        //compare the dest addr to the broadcast addr and our mac addr
        //if it is not one of them then throw the packet away
        if (memcmp(mac_addr, broadcast, 6)==0 || memcmp(mac_addr, my_mac, 6)==0) {
            //now check the ether type
            if (RXT[12]==ET_PRE && RXT[13]==ET_IP) {
                printf("\ngot an ip packet\n");
                type = IP_TYPE;
            } else if (RXT[12]==ET_PRE && RXT[13]==ET_ARP) {
                printf("\ngot an arp packet\n");
                type = ARP_TYPE;
            } else {
                type = NONE_TYPE;
            }
            //if we got an ip or arp packet, send it to the recv buffer to be processed
            //if (type != NONE_TYPE) {
            if (type == ARP_TYPE) {
                //byte 14 is where the data begins, the last 4 bytes are the checksum
                //TODO make sure the last 4 bytes are actually the checksum and that it didn't chop this off already
                //always send exactly 7 words, otherwise arp breaks
                for (i=14; i<42; i+=4) {
                    //send(RXT[i:i+4]);
                    //get 32bit word from next 4 bytes, careful not to overflow the buffer
                    data = RXT[i] << 24;
                    if ((i+1) < rx_len-14) data |= RXT[i+1] << 16;
                    if ((i+2) < rx_len-14) data |= RXT[i+2] << 8;
                    if ((i+3) < rx_len-14) data |= RXT[i+3];
                    //send the data and the type (type also serves as handshake)
                    PIO_WRITE(DATA_IN_BASE, data);
                    //printf("%08x ",data);
                    PIO_WRITE(DATA_TYPE_BASE, type);
                    //do the handshake
                    while(!PIO_READ(DATA_ACK_BASE)); //wait for ack to go high
                    PIO_WRITE(DATA_TYPE_BASE, NONE_TYPE);//set type low
                    while(PIO_READ(DATA_ACK_BASE));//wait for ack to go low
                }
                printf("\n");
            }
            if (type == IP_TYPE) {
                //byte 14 is where the data begins, the last 4 bytes are the checksum
                //TODO make sure the last 4 bytes are actually the checksum and that it didn't chop this off already
                //only send the ip packet, don't send ethernet padding
                ip_len = (RXT[16] << 8) | RXT[17]; 
                //printf("ip len: %d\n",ip_len);
                for (i=14; i<ip_len+14; i+=4) {
                    //get 32bit word from next 4 bytes, careful not to overflow the buffer
                    data = RXT[i] << 24;
                    if ((i+1) < ip_len+14) data |= RXT[i+1] << 16;
                    if ((i+2) < ip_len+14) data |= RXT[i+2] << 8;
                    if ((i+3) < ip_len+14) data |= RXT[i+3];
                    //send the data and the type (type also serves as handshake)
                    PIO_WRITE(DATA_IN_BASE, data);
                    printf("%08x ",data);
                    PIO_WRITE(DATA_TYPE_BASE, type);
                    //do the handshake
                    while(!PIO_READ(DATA_ACK_BASE)); //wait for ack to go high
                    PIO_WRITE(DATA_TYPE_BASE, NONE_TYPE);//set type low
                    while(PIO_READ(DATA_ACK_BASE));//wait for ack to go low
                }
                printf("\n");
            }
        }
    }
}
/*
int main(void)
{
  unsigned char TXT[] = { 0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,
                          0x01,0x60,0x6E,0x11,0x02,0x0F,
                          0x08,0x00,0x11,0x22,0x33,0x44,
                          0x55,0x66,0x77,0x88,0x99,0xAA,
                          0x55,0x66,0x77,0x88,0x99,0xAA,
                          0x55,0x66,0x77,0x88,0x99,0xAA,
                          0x55,0x66,0x77,0x88,0x99,0xAA,
                          0x55,0x66,0x77,0x88,0x99,0xAA,
                          0x55,0x66,0x77,0x88,0x99,0xAA,
                          0x55,0x66,0x77,0x88,0x99,0xAA,
                          0x00,0x00,0x00,0x20 };
  LCD_Test();
  DM9000_init();
  alt_irq_register( DM9000A_IRQ, NULL, (void*)ethernet_interrupts ); 
  //packet_num=0;
  printf("starting...\n");
  while (1)
  {
    TransmitPacket(TXT,0x40);
    msleep(500);
  }

  return 0;
}*/

int main(void)
{
    /*unsigned char TXT_INIT[] = { 0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,//dest addr
                                 0x01,0x60,0x6E,0x11,0x02,0x0F,//src addr
                                 0x08,0x00, //ethertype
                                 0x45, 0x00, 0x00, 0x44,
                                 0x35, 0xE3, 0x00, 0x00,
                                 0x40, 0x11, 0x90, 0x34,
                                 0xCA, 0xE8, 0x0F, 0x66,
                                 0xCA, 0xE8, 0x0F, 0x62,
                                 0x04, 0x00, 0x04, 0x00,
                                 0x00, 0x30, 0x00, 0x00,
                                 0x16, 0x72, 0x89, 0xE4,
                                 0x80, 0x18, 0x44, 0x70,
                                 0x40, 0x60, 0x00, 0x00,
                                 0x01, 0x01, 0x08, 0x0A,
                                 0x00, 0x03, 0xBF, 0x65,
                                 0x00, 0x03, 0xBF, 0x65,
                                 0x00, 0x00, 0x95, 0xFE,
                                 0x00, 0x00, 0x00, 0x0A,
                                 0x00, 0x00, 0x00, 0x0A,
                                 0x00, 0x00, 0x00, 0x0A,
                                 0xDE, 0xAD, 0xBE, 0xEF };*/

//arp packet
    unsigned char TXT_INIT[] = { 0xFF,0xFF,0xFF,0xFF,0xFF,0xFF,//dest addr
                                 0x01,0x60,0x6E,0x11,0x02,0x0F,//src addr
                                 0x08,0x06, //ethertype
                                 0x00, 0x01, 0x08, 0x00,
                                 0x06, 0x04, 0x00, 0x01,
                                 0x01, 0x60, 0x6E, 0x11,
                                 0x02, 0x0F, 0xC0, 0xA8,
                                 0x01, 0x02, 0x00, 0x00,
                                 0x00, 0x00, 0x00, 0x00,
                                 0xC0, 0xA8, 0x01, 0x03 };


    unsigned char TXT[MAX_ETH];
    unsigned int mac_addr_l, data;
    unsigned short mac_addr_h;
    unsigned char len;
    int i, ti, c;
    
    //init
    LCD_Test();
    DM9000_init();
    alt_irq_register( DM9000A_IRQ, NULL, (void*)ethernet_interrupts ); 
    c=0;
    
    printf("starting...\n");

    /*for(i=0; i<5; i++) {
        TransmitPacket(TXT_INIT, 42);
        msleep(500);
    }*/
    
    //main loop
    while (1) {
        //msleep(500);
        //don't just keep sending the same packet here
        //send packets our hardware tells us to send!
        if (PIO_READ(CPU_IP_READY_BASE)) {
            printf("trying to send an ip packet\n");
            //first get and set the dest addr
            mac_addr_h = PIO_READ(CPU_IP_MAC_H_BASE);
            mac_addr_l = PIO_READ(CPU_IP_MAC_L_BASE);
            TXT[0] = (mac_addr_h >> 8) & 0xFF;
            TXT[1] = (mac_addr_h) & 0xFF;
            TXT[2] = (mac_addr_l >> 24) & 0xFF;
            TXT[3] = (mac_addr_l >> 16) & 0xFF;
            TXT[4] = (mac_addr_l >> 8) & 0xFF;
            TXT[5] = (mac_addr_l) & 0xFF;
            //now set the src addr - which is always our addr
            for(i=0; i<6; i++) {
                TXT[i+6] = my_mac[i];
            }
            //now set ether type to ip
            TXT[12] = ET_PRE;
            TXT[13] = ET_IP;
            //now fill in with data
            ti = 14;//start after the ehter type
            len = PIO_READ(CPU_IP_LENGTH_BASE);
            for (i=0; i<len; i++) {
                PIO_WRITE(CPU_IP_INDEX_BASE, i);
                //TODO this should be fine, but make sure it is reading right data for index here
                data = PIO_READ(CPU_IP_DATA_BASE);
                TXT[ti++] = (data >> 24) & 0xFF;
                TXT[ti++] = (data >> 16) & 0xFF;
                TXT[ti++] = (data >> 8) & 0xFF;
                TXT[ti++] = data & 0xFF;
            }
            //read all data, finish handshake
            PIO_WRITE(CPU_IP_DONE_BASE, 1);
            while(PIO_READ(CPU_IP_READY_BASE));
            PIO_WRITE(CPU_IP_DONE_BASE, 0);
            //send packet TODO make sure ti is correct here
            //print TXT before sending?
            printf("transmitting...\n");
            TransmitPacket(TXT,ti);
        }
        if (PIO_READ(CPU_ARP_READY_BASE)) {
            printf("trying to send an arp packet\n");
            //first get and set the dest addr
            mac_addr_h = PIO_READ(CPU_ARP_MAC_H_BASE);
            mac_addr_l = PIO_READ(CPU_ARP_MAC_L_BASE);
            TXT[0] = (mac_addr_h >> 8) & 0xFF;
            TXT[1] = (mac_addr_h) & 0xFF;
            TXT[2] = (mac_addr_l >> 24) & 0xFF;
            TXT[3] = (mac_addr_l >> 16) & 0xFF;
            TXT[4] = (mac_addr_l >> 8) & 0xFF;
            TXT[5] = (mac_addr_l) & 0xFF;
            //now set the src addr - which is always our addr
            for(i=0; i<6; i++) {
                TXT[i+6] = my_mac[i];
            }
            //now set ether type to arp
            TXT[12] = ET_PRE;
            TXT[13] = ET_ARP;
            //now fill in with data
            ti = 14;//start after the ether type
            for (i=0; i<7; i++) {
                PIO_WRITE(CPU_ARP_INDEX_BASE, i);
                //TODO this should be fine, but make sure it is reading right data for index here
                data = PIO_READ(CPU_ARP_DATA_BASE);
				//printf("send arp: %08x\n",data);
                TXT[ti++] = (data >> 24) & 0xFF;
                TXT[ti++] = (data >> 16) & 0xFF;
                TXT[ti++] = (data >> 8) & 0xFF;
                TXT[ti++] = data & 0xFF;
            }
            //read all data, finish handshake
            PIO_WRITE(CPU_ARP_DONE_BASE, 1);
            while(PIO_READ(CPU_ARP_READY_BASE));
            PIO_WRITE(CPU_ARP_DONE_BASE, 0);
            //send packet TODO make sure ti is correct here
            //print TXT before sending?
			//for(i=0; i<ti; i++){
			//	if(i%4==0) printf("\n");
			//	printf("%02x ",TXT[i]);
			//}
            printf("transmitting...\n");
            TransmitPacket(TXT,ti);
        }
    }

    return 0;
}

//-------------------------------------------------------------------------

