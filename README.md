# ChampSim Branch Predictor Benchmarking

A comparative performance analysis of dynamic branch prediction algorithms on the [ChampSim](https://github.com/ChampSim/ChampSim) architectural simulator, establishing a baseline for the development of a custom reinforcement-learning (Q-learning) branch predictor.

**Author:** Shreyas · B.E. Electronics & Communication Engineering, BITS Pilani – Hyderabad Campus
**Status:** Phase 1 (baseline benchmarking) complete · Phase 2 (TAGE + branch-level logging) in progress

---

## Research question

Can an adaptive reinforcement-learning model — specifically a Q-learning agent operating under strict microarchitectural resource constraints — match or outperform classical hardware branch predictors (bimodal, gshare, hashed perceptron, and the industry-standard TAGE) on standard SPEC CPU workloads?

This repository contains the **baseline benchmarking phase**: the automation, configuration, and results used to characterize existing predictors before designing the custom predictor.

## Methodology

**Simulator:** ChampSim (modern, post-2023 modular branch-predictor interface), built on macOS (Apple Silicon, arm64) with clang++.

**Predictors evaluated:** bimodal · gshare · hashed perceptron

**Benchmarks (SPEC CPU, DPC3 traces):**

| Trace | Characteristic |
|---|---|
| `600.perlbench` | Branch-heavy |
| `602.gcc` | Compiler / control-flow-heavy |
| `605.mcf` | Memory-heavy |

**Simulation parameters:** 10M warmup instructions · 50M simulation instructions

**Metrics captured:** IPC · branch prediction accuracy · MPKI · average ROB occupancy

## Results

Baseline IPC across the three predictors and benchmarks:

| Predictor | perlbench | gcc | mcf |
|---|---|---|---|
| bimodal | 2.327 | 0.479 | 0.217 |
| gshare | 2.350 | 0.566 | 0.211 |
| **hashed_perceptron** | **2.452** | **0.568** | **0.229** |

The hashed perceptron leads on IPC and branch accuracy (99%+) across all three workloads, giving a strong, well-motivated baseline for the planned learning-based predictor. Full per-run metrics are in [`results/csv/baseline_results.csv`](results/csv/baseline_results.csv); raw simulator logs are preserved under [`results/raw/`](results/raw/) as evidence behind the summary.

## Repository structure

```
.
├── run_all.sh                    # Driver: builds each predictor, runs all benchmarks
├── test_run.sh                   # Quick smoke test (bimodal, short run)
├── extract_baseline_metrics.sh   # Parses raw simulator logs into the results CSV
├── configs/                      # ChampSim JSON configs (bimodal, gshare, hashed_perceptron)
└── results/
    ├── csv/baseline_results.csv  # Summary results table
    └── raw/                      # Per-run simulator output logs
```

## Reproducing

These scripts assume a built ChampSim checkout with SPEC traces available locally (see note below).

```bash
# From a configured ChampSim directory containing these scripts:
./run_all.sh                     # build predictors and run all benchmarks
./extract_baseline_metrics.sh    # parse raw logs into results/csv/baseline_results.csv
```

## Roadmap

- [x] Environment stabilization and baseline benchmarking (bimodal, gshare, hashed perceptron)
- [ ] Add TAGE baseline (industry-standard reference predictor)
- [ ] Branch-level log extraction (branch PC, prediction, outcome) for a selected benchmark
- [ ] Q-learning predictor design and integration into the ChampSim branch-predictor interface
- [ ] Comparative evaluation of the custom predictor against all baselines

## Notes and credit

Branch prediction and simulation are performed using [ChampSim](https://github.com/ChampSim/ChampSim); this repository contains only the benchmarking automation, configurations, and results produced for this project, not the simulator source.

**SPEC CPU traces are not included** in this repository due to their usage terms. They can be obtained from the [DPC3 trace repository](https://dpc3.compas.cs.stonybrook.edu/champsim-traces/speccpu/).
