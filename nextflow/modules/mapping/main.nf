process HISAT2_MAPPING {
    tag "$sample"
    label 'process_medium'
    publishDir "${params.outdir}/mapping", mode: params.publish_dir_mode

    input:
    tuple val(sample), path(fq1), path(fq2), val(condition)
    path index_dir  // Directory or prefix

    output:
    path "${sample}.sorted.bam", emit: bam_files
    path "${sample}.sorted.bam.bai", emit: bai_files
    path "${sample}_hisat2.log", emit: hisat2_logs

    script:
    """
    # Find the actual index prefix based on the provided path
    # If the user provides /path/to/genome, HISAT2 uses /path/to/genome
    
    hisat2 -p ${task.cpus} \\
        -x ${index_dir} \\
        -1 ${fq1} -2 ${fq2} \\
        2> ${sample}_hisat2.log | \\
        samtools view -bS - | \\
        samtools sort -@ ${task.cpus} -o ${sample}.sorted.bam -
        
    samtools index ${sample}.sorted.bam
    """
}
