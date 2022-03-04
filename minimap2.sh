#!/bin/bash

for i in $(seq 1 $4); do
sbatch minimap2_helper.sh $1 $2 $3 $i -e err.log -o out.log
done
