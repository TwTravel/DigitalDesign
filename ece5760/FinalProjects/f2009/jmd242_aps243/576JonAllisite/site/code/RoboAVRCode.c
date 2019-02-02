/*----------------------------------------------------------------
-----------------HEADER FILES-------------------------------------
-----------------------------------------------------------------*/

#include<avr/io.h>
#include<avr/interrupt.h>
#include<util/delay.h>

/*----------------------------------------------------------------
-----------------GlOBAL VARIABLES---------------------------------
-----------------------------------------------------------------*/

volatile uint8_t count;

/*----------------------------------------------------------------
-----------------DEFINITIONS------------------------------------
-----------------------------------------------------------------*/
//baud rate calculations
#define USART_BAUDRATE 19200
#define BAUD_PRESCALE (((F_CPU / (USART_BAUDRATE * 16UL))) - 1) 

//serial packets
#define MES_STOP 'S'
#define MES_LOW_SPEED 'L'
#define MES_HIGH_SPEED 'H'
#define MES_PING 'P'
#define MES_FORWARD 'F'
#define MES_BACKWARD 'B'
#define MES_CLOCK 'C'
#define MES_COUNTER 'U'
#define MES_ALCOHOL 'A'
#define MES_GOOD 'G'

//pins
#define SOUND_OUT PD7
#define MOTOR_PWM PD5
#define MOTOR_A1 PA0
#define MOTOR_A2 PA1
#define MOTOR_B1 PA2
#define MOTOR_B2 PA3

/*----------------------------------------------------------------
-----------------FUNCTIONS---------------------------------------
-----------------------------------------------------------------*/

void init(void);
void InitUART(void);
unsigned char ReceiveByte( void );
void TransmitByte( unsigned char data );
void Init_Ports(void);
void initADC(void);

/*----------------------------------------------------------------
-----------------MAIN FUNCTION------------------------------------
-----------------------------------------------------------------*/
int main(void){
	init();

	unsigned char in;

  for(;;)              /* Forever */
  {
		in=ReceiveByte();	//Receive the data
		switch(in){
			case MES_STOP:
				OCR1A=0;
			break;
			case MES_LOW_SPEED:
				OCR1A=100;
			break;
			case MES_HIGH_SPEED:
				OCR1A=200;
			break;
			case MES_PING:
				TCCR2|=_BV(COM20)|_BV(WGM21)|_BV(CS21)|_BV(CS20);
			break;
			case MES_FORWARD:
				PORTA=0b0110;
			break;
			case MES_BACKWARD:
				PORTA=0b1001;
			break;
			case MES_CLOCK:
				PORTA=0b1010;
			break;
			case MES_COUNTER:
				PORTA=0b0101;
			break;
			case MES_ALCOHOL:
				do{
				 	TransmitByte(ADCL);
					_delay_ms(100);
				 }while(!(UCSRA &  (_BV(RXC))));
				 ReceiveByte();
				do{
				 	TransmitByte(ADCH);
					_delay_ms(100);
				 }while(!(UCSRA &  (_BV(RXC))));
				 ReceiveByte();
			break;
		}
  }
}


 

/*----------------------------------------------------------------
------------FUNCTIONS TO Initialize AVR--------------------------
-----------------------------------------------------------------*/

void initADC(){
  //use 5V Vcc for reference and alcohol sensor is on pin A7
	ADMUX=_BV(REFS0)|0b111;
  //start continuously taking samples as accurately as possible
	ADCSRA=_BV(ADEN)|_BV(ADSC)|_BV(ADATE)|_BV(ADPS2)|_BV(ADPS1)|_BV(ADPS0);
}

void init(){
	InitUART();
  
  //PD5 is the PWM for motor control
  //PD7 is the PWM for speaker control
	DDRD|=_BV(5)|_BV(7);
  
  //initialize count for controlling ping duration
	count=0;
  
	//timer2 controls ping frequency
  //when timer is on it uses a 32 prescaler
  //ping freq=16MHz/32/96/2 ~=2.6kHz
	OCR2=95;
	TIMSK|=_BV(OCIE2);
	
	initADC();
	
  //timer1 controls motor speed control PWM at 15.6kHz
	OCR1A=0;
	TCCR1A|=_BV(COM1A1)|_BV(WGM11)|_BV(WGM10);
	TCCR1B|=_BV(WGM12)|_BV(CS10);

  //PORTA0-3 control motor direction
	PORTA=0b0110;
	DDRA=0b1111;
  
  //enable interupts
	sei();
}  
  

/*----------------------------------------------------------------
------------FUNCTIONS TO USE UART--------------------------
-----------------------------------------------------------------*/

void InitUART( )
{
  UBRRL =  BAUD_PRESCALE;                    /*  Set the baud rate */
  UBRRH = (BAUD_PRESCALE >> 8);
  UCSRB = (UCSRB | _BV(RXEN) | _BV(TXEN) );  /* Enable UART   receiver and transmitter */
}
/*----------------------------------------------------------------
------------FUNCTIONS TO READ UART-------------------------------
-----------------------------------------------------------------*/
unsigned char ReceiveByte( void )
{
  while ( !(UCSRA &  (_BV(RXC))) );     /*  Wait for incomming data   */
  return UDR;/* Return the   data */
}

/*----------------------------------------------------------------
------------FUNCTIONS TO WRITE UART-------------------------------
-----------------------------------------------------------------*/
void TransmitByte( unsigned char data )
{
  while ( !(UCSRA & (_BV(UDRE))) );        /* Wait for   empty transmit buffer */
  UDR =  data;  /* Start transmittion   */
}


ISR(TIMER2_COMP_vect){
  //continue pinging until count reaches 40
  //duration=40/(16MHz/32/96)= 7.68ms
	if(count++>40){
		TCCR2=0;
		TCNT2=0;
		count=0;
	}
}
