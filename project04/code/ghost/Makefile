CC     = mpicc
CFLAGS =

build/ghost: ghost.c
	$(CC) $(CFLAGS) $^ -o $@

.PHONY: clean
clean:
	$(RM) build/ghost
