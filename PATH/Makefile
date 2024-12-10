CC     := gcc
CFLAGS := -ansi -Wall -Wextra -Wpedantic -Werror

OUTP := PATH
SRCS := $(wildcard src/*.c)
OBJS := $(patsubst %.c,%.o,$(SRCS))
HDRS := $(wildcard src/*.h)

.PHONY: all
all: $(OUTP)

.PHONY: debug
debug: CFLAGS += -DDEBUG
debug: $(OUTP)

$(OUTP): $(OBJS)
	$(CC) -o $@ $^ $(CFLAGS)

$(OBJS): %.o: %.c $(HDRS)
	$(CC) -o $@ -c $< $(CFLAGS)

.PHONY: clean
clean:
	rm -f $(OUTP)
	rm -f $(OBJS)
