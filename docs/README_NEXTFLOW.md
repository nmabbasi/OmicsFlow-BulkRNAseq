# Nextflow Pipeline — Step-by-Step Guide

**OmicsFlow-BulkRNAseq | Nextflow DSL2 Edition**

## Prerequisites

1. Nextflow (>= 22.10)
2. Conda / Mamba
3. SLURM workload manager (for HPC execution)

## Step 1 — Prepare Your Samplesheet

Copy and edit `nextflow/config/samplesheet_example.csv` to match your data:

```csv
sample,fastq_1,fastq_2,condition
Sample1,/data/Sample1_R1.fastq.gz,/data/Sample1_R2.fastq.gz,control
Sample2,/data/Sample2_R1.fastq.gz,/data/Sample2_R2.fastq.gz,treated
```

## Step 2 — Edit the Configuration

Open `nextflow/nextflow.config` and update the SLURM account and default parameters (including `fc_strandedness`) if needed.

## Step 3 — Run the Pipeline

```bash
cd nextflow/

# Stub run (validate DSL2 DAG, channels, and outputs without bioinformatics tools)
nextflow run main.nf -profile local -stub-run \
  --samplesheet config/samplesheet_example.csv \
  --hisat2_index /path/to/reference/genome \
  --gtf_file /path/to/annotation.gtf

# Run on SLURM HPC with Conda
nextflow run main.nf -profile slurm,conda \
  --samplesheet config/samplesheet_example.csv \
  --hisat2_index /path/to/reference/genome \
  --gtf_file /path/to/annotation.gtf
```
