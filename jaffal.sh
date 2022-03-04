#!/bin/bash

for i in $(seq 1 10); do
sbatch jaffal_helper.sh $1 $2 $3 $i -e err.log -o out.log
done
