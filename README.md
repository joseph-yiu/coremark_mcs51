# coremark_mcs51

** Do Not Use for Production **

This is an experimental repo for testing CoreMark with the MCS51 architecture (e.g. 8051/8052).
The work is for addressing https://github.com/eembc/coremark/issues/71
This repo is to store my test setup.

Current status:
Project builds and works in Keil C51. Tested in C51 simulator only.
(I do not have the hardware to test this.)

The project
- Use large memory model
- Preprocessing options: ITERATIONS=10 STANDALONE PERFORMANCE_RUN=1
  (Feel free to adjust these) 
- Use UART for printf
- LARGE model reentrant stack enabled (STARTUP.A51: XBPSTACK EQU 1)
  Reentrant stack top set to 0xFF00 (XBPSTACKTOP  EQU  0xFF00)  

When using Keil C51, currently MEM_METHOD must be set to MEM_STATIC.
I haven't implement and test other configurations.

There are some code changes compares to original CoreMark C files
because "size", "data" and "pdata" are reserved key words in Keil C51.
Also, some functions that are called recusively must be declared with 
reentrant attribute (See __COREMARK_REENTRANT macro).

Additionally, Keil C51 has the following limitations: stdint.h and
PRIu32 are not supported.

---

I have also attempted to setup a makefile for SDCC. This (makefile.sdcc)
can get the project to compile, but unfortunately the program is not 
functional due to stack size restriction.

In theory, putting stack in the external SRAM (using --xstack) should 
be able to overcome the stack limitation. However, when using --xstack
the C library must also be recompiled because SDCC does not include
a variant of C runtime with xstack enabled by default.
(Available libraries are in {SDCC_PATH}/sdcc-4.6.0/share/sdcc/lib/ ) 
Since there is no out-of-box solution for SDCC, I put this effort on hold.


