#!/bin/bash

(for i in {1..10}; do (for log in `ls K${i}/*.log`; do echo $i $(grep -Po 'like=\K[^ ]+' $log); done) ; done) > logfiles.txt
