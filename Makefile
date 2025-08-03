#
#  Lecture sample programs
#

CC	= gcc
CFLAGS	= -O0 -Wall -MMD -g 
LDFLAGS	=

TARGET = \
	hello_world	\
	hello_world2	\
	a_plus_b	\
	plus		\
	multi		\
	multi_flat	\
	square		\
	get_mem		\
	get_mem2	\
	get_stack	\
	get_stack2	\
	fork_mem	\
	fork_exec	\
	fork_exec2	\
	fork_exec2.1	\
	fork_exec2.2	\
	fork_exec2.3	\
	fork_exec3	\
	fork_exec3.1	\
	plus_main	\
	plus_main_s	\
	plus_main_d	\


SRC_DIR = src

.PHONY:	all clean


all:	$(TARGET)

clean:
	rm -f $(TARGET) *.d *.i *.s *.o *.a *.so

-include *.d

%:	$(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -c $^ -o $@.o
	$(CC) $(CFLAGS) $@.o -o $@

plus_main.o: $(SRC_DIR)/plus_main.c
	$(CC) $(CFLAGS) -E $< -o $(@:%.o=%.i)
	$(CC) $(CFLAGS) -S $(@:%.o=%.i) -o $(@:%.o=%.s)
	$(CC) $(CFLAGS) -c $(@:%.o=%.s) -o $@
	
plus_func.o: $(SRC_DIR)/plus_func.c
	$(CC) $(CFLAGS) -E $< -o $(@:%.o=%.i)
	$(CC) $(CFLAGS) -S $(@:%.o=%.i) -o $(@:%.o=%.s)
	$(CC) $(CFLAGS) -c $(@:%.o=%.s) -o $@

plus_main: plus_main.o plus_func.o
	$(CC) $(CFLAGS) $^ -o $@

libplus_func_s.a: plus_func.o
	$(AR) rcs $@ $<

CFLAGS_SHARED = $(CFLAGS) -shared -fPIC

plus_func_d.o: $(SRC_DIR)/plus_func.c
	$(CC) $(CFLAGS_SHARED) -E $< -o $(@:%.o=%.i)
	$(CC) $(CFLAGS_SHARED) -S $(@:%.o=%.i) -o $(@:%.o=%.s)
	$(CC) $(CFLAGS_SHARED) -c $(@:%.o=%.s) -o $@

libplus_func_d.so: plus_func_d.o
	$(CC) $(CFLAGS_SHARED) $< -o $@

plus_main_s: plus_main.o libplus_func_s.a
	$(CC) $(CFLAGS) -o $@ $< -L. -lplus_func_s

plus_main_d: plus_main.o libplus_func_d.so
	$(CC) $(CFLAGS) -o $@ $< -L. -lplus_func_d

# comment: Set "export LD_LIBRARY_PATH=./" to execute plus_main_d
