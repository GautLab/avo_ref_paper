#!/bin/bash

for i in $(ls *.gz)
do
   pigz -dk $i
done
