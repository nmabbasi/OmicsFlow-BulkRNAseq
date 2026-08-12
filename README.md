# OmicsFlow-BulkRNAseq 🧬

**End-to-end bulk RNA-seq analysis pipeline for HPC clusters**  
From raw FASTQ files → QC → Trimming → Mapping → Quantification → MultiQC Report

[![Nextflow](https://img.shields.io/badge/Nextflow-≥22.10-brightgreen)](https://www.nextflow.io/)
[![Snakemake](https://img.shields.io/badge/Snakemake-≥7.0-blue)](https://snakemake.readthedocs.io/)
[![SLURM](https://img.shields.io/badge/HPC-SLURM-orange)](https://slurm.schedmd.com/)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

---

## 📋 What Does This Pipeline Do?

This repository provides two complete, parallel implementations of the same bulk RNA-seq workflow:

| Step | Description | Tool |
|------|-------------|------|
| 1 | Quality Control | FastQC |
| 2 | Read Trimming & Filtering | fastp |
| 3 | Alignment to Reference Genome | HISAT2 |
| 4 | Gene Quantification | featureCounts |
| 5 | Aggregate Reporting | MultiQC |

---

## 🗂️ Repository Structure

```
OmicsFlow-BulkRNAseq/
├── nextflow/               ← Nextflow DSL2 pipeline
│   ├── main.nf             ← Main pipeline entry point
│   ├── nextflow.config     ← All parameters & SLURM config
│   ├── modules/            ← One module per analysis step
│   └── envs/               ← Conda environment file
│
├── snakemake/              ← Snakemake pipeline
│   ├── Snakefile           ← Main pipeline entry point
│   ├── config/             ← Configuration and sample sheets
│   ├── rules/              ← One rule file per analysis step
│   └── envs/               ← Conda environment file
│
└── legacy_scripts/         ← Original bash scripts
```

---

## 🚀 Quick Start — Choose Your Pipeline

- **Nextflow** → See [docs/README_NEXTFLOW.md](docs/README_NEXTFLOW.md)
- **Snakemake** → See [docs/README_SNAKEMAKE.md](docs/README_SNAKEMAKE.md)

---

## 💡 Key Features

- **Multi-sample parallel processing** — all samples run simultaneously on SLURM
- **Reproducible environments** — fully integrated with Conda/Mamba
- **Legacy Support** — the original bash scripts are preserved in `legacy_scripts/` for reference

---

## 📧 Citation & Contact

If you use this pipeline, please cite the tools used in your methods section (fastp, HISAT2, featureCounts, MultiQC).

**Author:** Nasir Mahmood Abbasi, PhD  
**GitHub:** [@nmabbasi](https://github.com/nmabbasi)
