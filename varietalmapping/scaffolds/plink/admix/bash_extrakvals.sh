#!/bin/bash

rm -f ngsadmixKvals.log

for i in {1..7}
  do for j in $(ls K${i}/*.log)
    do echo $i $(grep -Po "like=\K[^ ]+" $j) | awk '{print $1"\t"$2}' >> ngsadmixKvals.log
  done
done
