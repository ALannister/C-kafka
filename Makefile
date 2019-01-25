include $(CONFIG_FILE)

SRC_DIR = ./src
INC    += -I./include

ifeq ($(G_DEVTOOLS), i386_gcc_linux)
	CFLAG  = -DI386_DEV=1 -g -Wall
endif

ifeq ($(G_DEVTOOLS), arm_gcc_linux)
	CFLAG  = -DARM_DEV=1 -g -Wall
endif

ifeq ($(G_DEVTOOLS), mips_gcc_linux)
	CFLAG  = -DMIPS_DEV=1 -g -Wall
endif

ifeq ($(VERSION), 434)
	CFLAG += -DG_ENDIAN=1
endif
ifeq ($(VERSION), 346)
	CFLAG += -DG_ENDIAN=1
endif

SRC := $(wildcard $(SRC_DIR)/*.c) $(wildcard $(SRC_DIR)/*/*.c)
OBJ := $(patsubst %.c,%.o,$(SRC))

LIB_FILE  = librdkafka.a

all:$(LIB_FILE) clean

$(LIB_FILE):$(OBJ)
	rm -f $@
	$(AR) $(LIB_FILE) $(OBJ)
	mkdir -p $(OUTPUT_DIR)/include
	mkdir -p $(OUTPUT_DIR)/lib
	cp ./include/rdkafka.h $(OUTPUT_DIR)/include
	cp ./$(LIB_FILE) $(OUTPUT_DIR)/lib

%.o:%.c
	$(CC) -c $(INC) $(CFLAG) $< -o $@

clean:
	rm -f $(OBJ)
	rm -f $(LIB_FILE)
	@echo "$(G_DEVTOOLS)_$(VERSION) static lib make success!"
	@echo ""
