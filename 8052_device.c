#include <8052.h>
#include <stdio.h>

volatile int count = 0;

void timer_config(void); /* Initialize a timer peripheral */
void stdio_init(void);   /* Initialize printf support (e.g. UART) */
unsigned long get_100Hz_value(void); /* Read a timer value with 0.01 sec resolution */

void Timer2_ISR(void) __interrupt (5) {
    count++; // Increment count on each Timer 2 interrupt
}


/* UART initialization for 11.0592 MHz crystal, 9600 baud */
void uart_init(void)
{
//#ifndef MONITOR51
//    SCON  = 0x50;		        /* SCON: mode 1, 8-bit UART, enable rcvr      */
//    TMOD |= 0x20;               /* TMOD: timer 1, mode 2, 8-bit reload        */
//    TH1   = 221;                /* TH1:  reload value for 1200 baud @ 16MHz   */
//    TR1   = 1;                  /* TR1:  timer 1 run                          */
//    TI    = 1;                  /* TI:   set TI to send first char of UART    */
//#endif

    SCON = 0x50;      // Mode 1, 8-bit UART, receiver enabled

    TMOD &= 0x0F;
    TMOD |= 0x20;     // Timer1 Mode2 (8-bit auto reload)

    TH1 = 0xFD;       // 9600 baud @11.0592MHz
    TL1 = 0xFD;

    TR1 = 1;          // Start Timer1
    TI = 1;           // Ready to transmit
    printf("\nHello, World!\r\n");

    return;
}

void timer2_init(void)
{
    //TMOD |= 0x20; // Set Timer 2 in mode 2 (8-bit auto-reload)
    //TH2 = 0x00;   // Load TH2 with the reload value
    //TR2 = 1;      // Start Timer 2
    //ET2 = 1;      // Enable Timer 2 interrupt
    //EA = 1;       // Enable global interrupts
  	T2CON = 0x00;       // Timer mode, auto-reload
    RCAP2H = 0xCB;      // Reload value = 0xCBEB
    RCAP2L = 0xEB;

    TH2 = RCAP2H;       // Initial counter value
    TL2 = RCAP2L;	
    TR2 = 1;      // Start Timer 2
    ET2 = 1;      // Enable Timer 2 interrupt
    EA = 1;       // Enable global interrupts    
    return;
}

/* SDCC uses putchar() for printf() */
int putchar(int c)
{
    if (TI) TI=0;
    SBUF = c;
    
    while (!TI);

    TI = 0; 

    return c;
}

void timer_config(void)
{
  timer2_init();
  return;
}

void stdio_init(void)
{
  uart_init();
  return;
}

unsigned long get_100Hz_value(void)
{
  return (count);
}  


