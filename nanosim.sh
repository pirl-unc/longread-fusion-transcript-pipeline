#!/bin/bash

for i in $(seq 1 10); do
sbatch nanosim_helper.sh $1 $i
done
