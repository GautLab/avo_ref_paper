#!/bin/bash

awk 'NR%2==0 {print toupper($1)}' output1.gtf > output1.log
awk 'NR%2==0 {print toupper($1)}' output2.gtf > output2.log
diff output1.log output2.log
