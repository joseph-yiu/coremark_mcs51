#ifndef COREMARK_MCS51_8052_DEVICE_H
#define COREMARK_MCS51_8052_DEVICE_H

void Timer2_ISR(void) __interrupt(5);
void timer_config(void);
void stdio_init(void);
unsigned long get_100Hz_value(void);

#endif /* COREMARK_MCS51_8052_DEVICE_H */
