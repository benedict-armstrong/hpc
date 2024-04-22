MPICC     = mpicc
CFLAGS =

build/ghost: ghost.c
	$(MPICC) $(CFLAGS) $^ -o $@

.PHONY: clean
clean:
	$(RM) build/ghost
