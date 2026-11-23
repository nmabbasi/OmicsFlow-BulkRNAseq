# Snakemake Pipeline — Step-by-Step Guide

**OmicsFlow-BulkRNAseq | Snakemake Edition**

## Prerequisites

1. Snakemake (>= 7.0)
2. Conda / Mamba
3. SLURM workload manager (for HPC execution)

## Step 1 — Edit Your Samplesheet

Open `snakemake/config/samplesheet.csv` and specify your input files:

```csv
sample,fastq_1,fastq_2,condition
Sample1,/data/Sample1_R1.fastq.gz,/data/Sample1_R2.fastq.gz,control
Sample2,/data/Sample2_R1.fastq.gz,/data/Sample2_R2.fastq.gz,treated
```

## Step 2 — Edit the Config File

Open `snakemake/config/config.yaml` to specify the HISAT2 index prefix, GTF annotation, and `featureCounts` strandedness (`0`, `1`, or `2`):

```yaml
samplesheet: "config/samplesheet.csv"
outdir: "results"
hisat2_index: "/path/to/hisat2_index"
gtf_file: "/path/to/annotation.gtf"
fastp:
  min_length: 30
featurecounts:
  feature_type: "exon"
  attribute_type: "gene_id"
  strandedness: 0
```

## Step 3 — Run the Pipeline

```bash
cd snakemake/
conda activate snakemake

# Dry run (validate DAG and inspect commands)
snakemake --cores 4 --dry-run -p --configfile config/config.yaml

# Submit jobs to SLURM
snakemake \
    --executor slurm \
    --default-resources slurm_partition=normal \
    --cores all \
    --jobs 50 \
    --configfile config/config.yaml \
    --use-conda \
    --rerun-incomplete
```
