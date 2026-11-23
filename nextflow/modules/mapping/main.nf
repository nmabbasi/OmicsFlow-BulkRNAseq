process HISAT2_MAPPING {
    tag "$sample"
    label 'process_medium'
    publishDir "${params.outdir}/mapping", mode: params.publish_dir_mode

    input:
    tuple val(sample), path(fq1), path(fq2), val(condition)
    path index_files

    output:
    path "${sample}.sorted.bam",         emit: bam_files
    path "${sample}.sorted.bam.bai",     emit: bai_files
    path "${sample}_hisat2.summary.txt", emit: hisat2_summary

    script:
    def first_idx     = (index_files instanceof List) ? index_files[0] : index_files
    def index_prefix  = first_idx.getFileName().toString().replaceAll(/\.\d+\.ht2l?$/, '')
    def sort_threads  = task.cpus > 2 ? 2 : 1
    def align_threads = task.cpus > 2 ? task.cpus - 2 : 1
    """
    set -euo pipefail
    hisat2 -p ${align_threads} \
        -x ${index_prefix} \
        -1 ${fq1} -2 ${fq2} \
        --new-summary --summary-file ${sample}_hisat2.summary.txt | \
        samtools sort -@ ${sort_threads} -o ${sample}.sorted.bam -

    samtools index -@ ${sort_threads} ${sample}.sorted.bam
    """

    stub:
    """
    touch ${sample}.sorted.bam
    touch ${sample}.sorted.bam.bai
    touch ${sample}_hisat2.summary.txt
    """
}
