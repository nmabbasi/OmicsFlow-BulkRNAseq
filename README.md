# OmicsFlow-BulkRNAseq 🧬

**End-to-end bulk RNA-seq analysis pipeline for HPC clusters**  
From raw FASTQ files → QC → Trimming → Mapping → Quantification → MultiQC Report

[![Nextflow](https://img.shields.io/badge/Nextflow-≥22.10-brightgreen)](https://www.nextflow.io/)
[![Snakemake](https://img.shields.io/badge/Snakemake-≥7.0-blue)](https://snakemake.readthedocs.io/)
[![SLURM](https://img.shields.io/badge/HPC-SLURM-orange)](https://slurm.schedmd.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## Pipeline Overview

This repository provides two complete, parallel implementations of the same bulk RNA-seq workflow:

| Step | Description | Tool |
|------|-------------|------|
| 1 | Quality Control | FastQC |
| 2 | Read Trimming & Filtering | fastp |
| 3 | Alignment to Reference Genome | HISAT2 |
| 4 | Gene Quantification | featureCounts |
| 5 | Aggregate Reporting | MultiQC |

---

## Repository Structure

```
OmicsFlow-BulkRNAseq/
├── nextflow/               # Nextflow DSL2 pipeline
│   ├── main.nf             # Main pipeline entry point
│   ├── nextflow.config     # All parameters & SLURM config
│   ├── modules/            # One module per analysis step
│   └── envs/               # Conda environment file
│
├── snakemake/              # Snakemake pipeline
│   ├── Snakefile           # Main pipeline entry point
│   ├── config/             # Configuration and sample sheets
│   ├── rules/              # One rule file per analysis step
│   └── envs/               # Conda environment file
│
└── legacy_scripts/         # Original bash scripts for reference
```

---

## Quick Start: Running the Workflows

### Option A: Nextflow (DSL2)

Run on an HPC cluster with SLURM and Conda:
```bash
cd nextflow
nextflow run main.nf -profile slurm,conda --reads "../data/*_{1,2}.fastq.gz"
```
For detailed configuration options and test profiles, see [docs/README_NEXTFLOW.md](docs/README_NEXTFLOW.md).

### Option B: Snakemake

Run on an HPC cluster with Conda:
```bash
cd snakemake
snakemake -s Snakefile --use-conda --profile slurm -j 20
```
For sample sheet definitions and rule customization, see [docs/README_SNAKEMAKE.md](docs/README_SNAKEMAKE.md).

---

## Key Features

- **Multi-sample parallel processing**: all samples dispatch concurrently through SLURM job arrays.
- **Reproducible environments**: isolated Conda and Mamba environments for each pipeline tool.
- **Legacy script reference**: original standalone bash scripts are preserved under `legacy_scripts/`.

---

## Citation & Contact

If you use this pipeline, please cite the underlying tools (fastp, HISAT2, featureCounts, MultiQC).

**Author:** Nasir Mahmood Abbasi, PhD  
- Portfolio: [nmabbasi.github.io](https://nmabbasi.github.io/)  
- HPC Guide: [nmabbasi.github.io/HPC](https://nmabbasi.github.io/HPC/)  
- GitHub: [@nmabbasi](https://github.com/nmabbasi)
