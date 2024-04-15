CC     = mpicc
CFLAGS =

rbuild/ring_sum: ring_sum.c
	$(CC) $(CFLAGS) $^ -o $@

.PHONY: clean
clean:
	$(RM) build/ring_sum
