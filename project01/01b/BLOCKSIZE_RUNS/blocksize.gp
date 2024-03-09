set title "Blocksize vs. Performance"
set xlabel "Blocksize"
set ylabel "Performance (GFlops/s)"
set grid

set terminal pdf
set output "blocksize.pdf"

plot "blocksize_run.data"

