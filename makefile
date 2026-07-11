SDCCCFLAGS = -mmcs51
SDCCCFLAGS += --iram-size 256
SDCCCFLAGS += --stack-auto
#SDCCCFLAGS += --int-long-reent
#SDCCCFLAGS += --model-small
#SDCCCFLAGS += --model-medium
SDCCCFLAGS += --model-large
#SDCCCFLAGS += --model-huge
SDCCCFLAGS += --std-c11
#SDCCCFLAGS += --xstack

DEF_MACROS = -DITERATIONS=1000 -DSTANDALONE -DPERFORMANCE_RUN=1 

DEPLIST = makefile coremark/coremark.h

REL_FILES = 8052_device.rel core_portme.rel \
  core_util.rel core_state.rel core_matrix.rel core_list_join.rel



core_list_join.rel: $(DEPLIST) coremark/core_list_join.c
	sdcc   -c coremark/core_list_join.c \
	       -I coremark -I . \
	       $(SDCCCFLAGS) $(DEF_MACROS)

core_matrix.rel: $(DEPLIST) coremark/core_matrix.c
	sdcc   -c coremark/core_matrix.c \
	       -I coremark -I . \
	       $(SDCCCFLAGS) $(DEF_MACROS)

core_state.rel: $(DEPLIST) coremark/core_state.c
	sdcc   -c coremark/core_state.c \
	       -I coremark -I . \
	       $(SDCCCFLAGS) $(DEF_MACROS)

core_util.rel: $(DEPLIST) coremark/core_util.c
	sdcc   -c coremark/core_util.c \
	       -I coremark -I . \
	       $(SDCCCFLAGS) $(DEF_MACROS)

core_portme.rel: $(DEPLIST) core_portme.c core_portme.h
	sdcc   -c core_portme.c \
	       -I coremark -I . \
	       $(SDCCCFLAGS) $(DEF_MACROS)

8052_device.rel: $(DEPLIST)  8052_device.c
	sdcc   -c 8052_device.c \
	       -I coremark -I . \
	       $(SDCCCFLAGS) $(DEF_MACROS)

all: coremark/core_main.c  $(DEPLIST) $(REL_FILES)
	sdcc   coremark/core_main.c  $(REL_FILES) \
	       -I coremark -I . -o coremark \
	       $(SDCCCFLAGS) $(DEF_MACROS)

sim:
	s51 -S out=/dev/stdout coremark.ihx

clean:
	rm coremark.* 
	rm *.rel *.asm *.lst *.sym *.rst 
	
	
	

	       
