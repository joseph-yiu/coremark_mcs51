SDCCCFLAGS = -mmcs51
SDCCCFLAGS += --iram-size 256
#SDCCCFLAGS += --stack-auto
#SDCCCFLAGS += --int-long-reent
#SDCCCFLAGS += --model-small
#SDCCCFLAGS += --model-medium
SDCCCFLAGS += --model-large
#SDCCCFLAGS += --model-huge
SDCCCFLAGS += --std-c11
SDCCCFLAGS += --opt-code-size
#SDCCCFLAGS += --opt-code-speed
#SDCCCFLAGS += --max-allocs-per-node
#DCCCFLAGS += --nooverlay

SDCCCFLAGS += --xram-loc  0
SDCCCFLAGS += --xram-size 65536
SDCCCFLAGS += --xstack
SDCCCFLAGS += --xstack-loc 0xD000
SDCCCFLAGS += --data-loc   0x0000

#SDCCCFLAGS += --stack-loc=21
#SDCCCFLAGS += --stack-size=128
SDCCCFLAGS += --idata-loc 8
#SDCCCFLAGS += --stack-loc 0x80
SDCC_LIB=/home/joseph/projects/tools/sdcc-4.6.0/share/sdcc/lib/large/
#SDCC_LIB=/home/joseph/projects/tools/sdcc-4.6.0/share/sdcc/lib/large-stack-auto/
#SDCC_LIB=/home/joseph/projects/tools/sdcc-4.6.0/share/sdcc/lib/huge/

DEF_MACROS = -DITERATIONS=1000 -DSTANDALONE -DPERFORMANCE_RUN=1 

DEPLIST = makefile coremark/coremark.h

REL_FILES = 8052_device.rel core_portme.rel \
  core_util.rel core_state.rel core_matrix.rel core_list_join.rel



core_list_join.rel: $(DEPLIST) coremark/core_list_join.c
	sdcc   -c coremark/core_list_join.c \
	       -I coremark -I . \
	       $(SDCCCFLAGS) $(DEF_MACROS) -L $(SDCC_LIB)

core_matrix.rel: $(DEPLIST) coremark/core_matrix.c
	sdcc   -c coremark/core_matrix.c \
	       -I coremark -I . \
	       $(SDCCCFLAGS) $(DEF_MACROS) -L $(SDCC_LIB)

core_state.rel: $(DEPLIST) coremark/core_state.c
	sdcc   -c coremark/core_state.c \
	       -I coremark -I . \
	       $(SDCCCFLAGS) $(DEF_MACROS) -L $(SDCC_LIB)

core_util.rel: $(DEPLIST) coremark/core_util.c
	sdcc   -c coremark/core_util.c \
	       -I coremark -I . \
	       $(SDCCCFLAGS) $(DEF_MACROS) -L $(SDCC_LIB)

core_portme.rel: $(DEPLIST) core_portme.c core_portme.h
	sdcc   -c core_portme.c \
	       -I coremark -I . \
	       $(SDCCCFLAGS) $(DEF_MACROS) -L $(SDCC_LIB)

8052_device.rel: $(DEPLIST)  8052_device.c
	sdcc   -c 8052_device.c \
	       -I coremark -I . \
	       $(SDCCCFLAGS) $(DEF_MACROS) -L $(SDCC_LIB)

all: coremark/core_main.c  $(DEPLIST) $(REL_FILES)
	sdcc   coremark/core_main.c  $(REL_FILES) \
	       -I coremark -I . -o coremark \
	       $(SDCCCFLAGS) $(DEF_MACROS) -L $(SDCC_LIB)

# Simulate using uCSim
# -a 256 : internal RAM size
# -G: go
sim:
	s51 -a 256 -G -S out=/dev/stdout coremark.ihx

clean:
	rm coremark.* 
	rm *.rel *.asm *.lst *.sym *.rst 
	
	
	

	       
