#!/usr/bin/env nextflow
// ============================================================
// OmicsFlow-BulkRNAseq — Nextflow Pipeline
// Full bulk RNA-seq workflow: QC → Trimming → Mapping → Quantification
// Author  : Nasir Mahmood Abbasi
// Version : 1.0.0
// ============================================================

nextflow.enable.dsl = 2

include { FASTQC         } from './modules/fastqc/main'
include { FASTP          } from './modules/trimming/main'
include { HISAT2_MAPPING } from './modules/mapping/main'
include { FEATURECOUNTS  } from './modules/featurecounts/main'
include { MULTIQC        } from './modules/multiqc/main'

def helpMessage() {
    log.info """
    ╔══════════════════════════════════════════════════════════════╗
    ║          OmicsFlow-BulkRNAseq  •  Nextflow Pipeline          ║
    ╚══════════════════════════════════════════════════════════════╝

    USAGE:
        nextflow run main.nf -profile slurm,conda --samplesheet samples.csv

    REQUIRED:
        --samplesheet         CSV file with columns: sample,fastq_1,fastq_2,condition
        --hisat2_index        Path to HISAT2 reference index (e.g. /path/to/genome)
        --gtf_file            Path to reference GTF file

    PROFILES:
        slurm                 SLURM HPC executor
        conda                 Conda environment management
        local                 Local execution (testing)

    EXAMPLE:
        nextflow run main.nf \\
            -profile slurm,conda \\
            --samplesheet samples.csv \\
            --hisat2_index /data/refs/grch38/genome \\
            --gtf_file /data/refs/grch38.gtf
    """.stripIndent()
}

if (params.help) { helpMessage(); exit 0 }

workflow {
    ch_samples = Channel
        .fromPath(params.samplesheet, checkIfExists: true)
        .splitCsv(header: true)
        .map { row -> tuple(row.sample, file(row.fastq_1), file(row.fastq_2), row.condition) }

    FASTQC(ch_samples)
    FASTP(ch_samples)
    HISAT2_MAPPING(FASTP.out.trimmed_reads, params.hisat2_index)
    FEATURECOUNTS(HISAT2_MAPPING.out.bam_files.collect(), params.gtf_file)
    MULTIQC(
        FASTQC.out.fastqc_zips.collect().mix(
            FASTP.out.fastp_json.collect(),
            HISAT2_MAPPING.out.hisat2_logs.collect(),
            FEATURECOUNTS.out.summary
        ).collect()
    )
}
