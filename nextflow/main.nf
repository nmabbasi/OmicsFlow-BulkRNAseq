#!/usr/bin/env nextflow
// ============================================================
// OmicsFlow-BulkRNAseq — Nextflow Pipeline
// Full bulk RNA-seq workflow: QC -> Trimming -> Mapping -> Quantification
// Author  : Nasir Mahmood Abbasi
// Version : 1.1.0
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
        nextflow run main.nf -profile slurm,conda --samplesheet samples.csv --hisat2_index /path/to/genome --gtf_file /path/to/annotation.gtf

    REQUIRED:
        --samplesheet         CSV file with columns: sample,fastq_1,fastq_2,condition
        --hisat2_index        Prefix to HISAT2 reference index (e.g. /path/to/genome where genome.1.ht2 exists)
        --gtf_file            Path to reference GTF file

    OPTIONAL:
        --outdir              Output directory (default: results)
        --trim_min_length     Minimum read length after trimming (default: 30)
        --fc_strandedness     featureCounts strandedness: 0=unstranded, 1=forward, 2=reverse (default: 0)

    PROFILES:
        slurm                 SLURM HPC executor
        conda                 Conda environment management
        local                 Local execution (testing)

    EXAMPLE:
        nextflow run main.nf \\
            -profile slurm,conda \\
            --samplesheet config/samplesheet_example.csv \\
            --hisat2_index /data/refs/grch38/genome \\
            --gtf_file /data/refs/grch38.gtf
    """.stripIndent()
}

if (params.help) { helpMessage(); exit 0 }

if (!params.samplesheet)  { error "Missing required parameter: --samplesheet" }
if (!params.hisat2_index) { error "Missing required parameter: --hisat2_index" }
if (!params.gtf_file)     { error "Missing required parameter: --gtf_file" }

workflow {
    ch_samples = Channel
        .fromPath(params.samplesheet, checkIfExists: true)
        .splitCsv(header: true)
        .map { row ->
            tuple(
                row.sample,
                file(row.fastq_1, checkIfExists: true),
                file(row.fastq_2, checkIfExists: true),
                row.condition
            )
        }

    ch_hisat2_index = Channel
        .fromPath("${params.hisat2_index}*.ht2")
        .ifEmpty { error "No HISAT2 index files (*.ht2) found matching: ${params.hisat2_index}*.ht2" }
        .collect()

    ch_gtf = file(params.gtf_file, checkIfExists: true)

    FASTQC(ch_samples)
    FASTP(ch_samples)
    HISAT2_MAPPING(FASTP.out.trimmed_reads, ch_hisat2_index)
    FEATURECOUNTS(HISAT2_MAPPING.out.bam_files.collect(), ch_gtf)

    ch_multiqc_files = Channel.empty()
        .mix(FASTQC.out.fastqc_zips.flatten())
        .mix(FASTP.out.fastp_json)
        .mix(HISAT2_MAPPING.out.hisat2_summary)
        .mix(FEATURECOUNTS.out.summary)
        .collect()

    MULTIQC(ch_multiqc_files)
}
