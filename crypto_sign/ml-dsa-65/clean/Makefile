# This Makefile can be used with GNU Make or BSD Make

# LIB=libml-kem-768_clean.a
# HEADERS=api.h cbd.h indcpa.h kem.h ntt.h params.h poly.h polyvec.h reduce.h symmetric.h verify.h 
# OBJECTS=cbd.o indcpa.o kem.o ntt.o poly.o polyvec.o reduce.o symmetric-shake.o verify.o 

# CFLAGS=-O3 -Wall -Wextra -Wpedantic -Werror -Wmissing-prototypes -Wredundant-decls -std=c99 -I../../../common $(EXTRAFLAGS)

# all: $(LIB)

# %.o: %.c $(HEADERS)
# 	$(CC) $(CFLAGS) -c -o $@ $<

# $(LIB): $(OBJECTS)
# 	$(AR) -r $@ $(OBJECTS)

# clean:
# 	$(RM) $(OBJECTS)
# 	$(RM) $(LIB)

LIB=libml-dsa-65_clean.a
HEADERS=api.h ntt.h packing.h params.h poly.h polyvec.h reduce.h rounding.h sign.h symmetric.h 
OBJECTS=ntt.o packing.o poly.o polyvec.o reduce.o rounding.o sign.o symmetric-shake.o 
CFLAGS=-O3 -Wall -Wextra -Wpedantic -Werror -Wmissing-prototypes -Wredundant-decls -std=c99 -I../../../common $(EXTRAFLAGS)

all: $(LIB) main

%.o: %.c $(HEADERS)
	$(CC) $(CFLAGS) -c -o $@ $<

$(LIB): $(OBJECTS)
	$(AR) -r $@ $(OBJECTS)

main: main.o $(LIB)
	$(CC) $(CFLAGS) -o $@ $^
	
clean:
	$(RM) $(OBJECTS) $(LIB) main.o main
