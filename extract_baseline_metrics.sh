#!/bin/bash

mkdir -p results/csv

echo "Benchmark,Predictor,IPC,Branch_Accuracy,MPKI,ROB_Occupancy" > results/csv/baseline_results.csv

for file in results/raw/*.txt
do
    filename=$(basename "$file" .txt)

    predictor=""
    for p in "hashed_perceptron" "bimodal" "gshare"; do
        if [[ "$filename" == ${p}_* ]]; then
            predictor="$p"
            break
        fi
    done

    benchmark="${filename#${predictor}_}"

    ipc=$(grep "CPU 0 cumulative IPC:" "$file" | tail -1 | awk '{print $5}')
    accuracy=$(grep "Branch Prediction Accuracy:" "$file" | awk '{print $6}' | tr -d '%')
    mpki=$(grep "Branch Prediction Accuracy:" "$file" | awk '{print $8}')
    rob=$(grep "Branch Prediction Accuracy:" "$file" | awk '{print $NF}')

    echo "$benchmark,$predictor,$ipc,$accuracy,$mpki,$rob" >> results/csv/baseline_results.csv
done

echo "CSV generated at results/csv/baseline_results.csv"
