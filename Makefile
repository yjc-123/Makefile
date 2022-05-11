CURDIR = $(shell pwd)
DIR_BIN := bin
DIR_OBJ := obj
DIR_DEP := dep
DIRS    := $(DIR_OBJ) $(DIR_DEP) $(DIR_BIN)

SRC  = $(wildcard  *.c src/first/*.c src/second/*.c)
DEPS = $(notdir $(SRC:.c=.d))
#OBJS = $(notdir $(SRC:.c=.o))
OBJS = $(addprefix $(DIR_OBJ)/,$(notdir $(SRC:.c=.o)))

CC  = gcc
CXX = g++
AR  = ar
LD  = ld

$(shell [ -e $(DIR_DEP) ] || mkdir  $(DIR_DEP))
$(shell [ -e $(DIR_OBJ) ] || mkdir  $(DIR_OBJ))
$(shell [ -e $(DIR_BIN) ] || mkdir 	$(DIR_BIN))

VPATH = ./src:./src/first:./src/second

CFLAGS := -g -Wall 
CFLAGS += -I ./include/

TARGET := main

$(TARGET) : pre $(OBJS) 
	gcc  -o $(TARGET) $(CFLAGS) $(OBJS)
	mv $(TARGET) $(DIR_BIN)

-include $(DIR_DEP)/$(DEPS)

pre:
	@echo $(SRC) $(OBJS)


$(DIR_OBJ)/%.o: %.c
	@ echo "Creating %.o: %.c $@:$^ file..."
	gcc  -c  $<  -o $@

$(DIR_DEP)/%.d: %.c
	@ echo "Creating %.d: %.c $@ file..."
	#gcc -MM -MD -c $< -o $@
	@set -e; rm -f $@; \
	$(CC) -MM $(CFLAGS) $< > $@.$$$$; \
	sed 's,\($*\)\.o[ :]*,\$(DIR_OBJ)/$*.o $@ : ,g' < $@.$$$$ > $@; \
	rm -f $@.$$$$



.PHONY: clean
clean:
	rm -rf $(DIR_OBJ)
	rm -rf $(DIR_BIN)
	rm -rf $(DIR_DEP)
	rm -rf ./hello
	rm -rf *.d
	rm -rf *.o
