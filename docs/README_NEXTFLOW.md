# Nextflow Pipeline — Step-by-Step Guide

**OmicsFlow-BulkRNAseq | Nextflow DSL2 Edition**

## 🛠️ Prerequisites

1. Nextflow (>= 22.10)
2. Conda / Mamba
3. SLURM workload manager

## 📝 Step 1 — Prepare Your Samplesheet

Copy and edit `nextflow/config/samplesheet_example.csv` to match your data:

```csv
sample,fastq_1,fastq_2,condition
Sample1,/data/Sample1_R1.fastq.gz,/data/Sample1_R2.fastq.gz,control
Sample2,/data/Sample2_R1.fastq.gz,/data/Sample2_R2.fastq.gz,treated
```

## ⚙️ Step 2 — Edit the Configuration

Open `nextflow/nextflow.config` and change the HPC account and parameters if needed.

## 🚀 Step 3 — Run the Pipeline

```bash
cd nextflow/

# Dry run
nextflow run main.nf -profile slurm,conda \\
  --samplesheet samplesheet.csv \\
  --hisat2_index /path/to/reference/genome \\
  --gtf_file /path/to/annotation.gtf \\
  -dry-run

# Run for real
nextflow run main.nf -profile slurm,conda \\
  --samplesheet samplesheet.csv \\
  --hisat2_index /path/to/reference/genome \\
  --gtf_file /path/to/annotation.gtf
```
