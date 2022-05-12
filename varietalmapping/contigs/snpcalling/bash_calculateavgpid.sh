#!/bin/bash
awk '{printf "%.0f %.4f\n", ($4 / $7), $7}' $1 | awk '{print ($1 * $2), $1}' | awk '{suma+=$1; sumb+=$2;} END {printf "%.4f %.0f\n", suma, sumb}' | awk '{print $1 / $2}'
