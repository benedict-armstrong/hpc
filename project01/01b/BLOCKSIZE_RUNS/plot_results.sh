grep -e "# Average percentage of peak" -e "# Description:" timing_* | sed -E 's/.*= *([0-9]+\.?[0-9]*).*/\1/' | awk 'NR%2{printf "%s\t", $0;next;}1' >blocksize_run.data

gnuplot blocksize.gp
