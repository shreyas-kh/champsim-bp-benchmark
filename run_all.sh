#!/bin/bash

WARMUP=10000000
SIM=50000000

predictors=("bimodal" "gshare" "hashed_perceptron")

benchmarks=(
"600.perlbench_s-210B.champsimtrace.xz"
"602.gcc_s-734B.champsimtrace.xz"
"605.mcf_s-472B.champsimtrace.xz"
)

mkdir -p results/raw

for predictor in "${predictors[@]}"
do
    echo "=================================="
    echo "Building $predictor"
    echo "=================================="

    ./config.sh configs/${predictor}.json
    make -j4

    for benchmark in "${benchmarks[@]}"
    do
        shortname=$(basename "$benchmark" .champsimtrace.xz)

        echo "Running $predictor on $shortname"

        bin/champsim \
        --warmup-instructions $WARMUP \
        --simulation-instructions $SIM \
        traces/$benchmark \
        > results/raw/${predictor}_${shortname}.txt
    done
done

echo "All runs complete."

