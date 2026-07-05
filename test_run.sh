#!/bin/bash

WARMUP=1000000
SIM=5000000

predictor="bimodal"
benchmark="600.perlbench_s-210B.champsimtrace.xz"

echo "Building $predictor"

./config.sh configs/${predictor}.json
make -j4

echo "Running simulation..."

bin/champsim \
--warmup-instructions $WARMUP \
--simulation-instructions $SIM \
traces/$benchmark \
> results/raw/test_output.txt

echo "Done"

