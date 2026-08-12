process FASTP {
    tag "$sample"
    label 'process_low'
    publishDir "${params.outdir}/trimming", mode: params.publish_dir_mode

    input:
    tuple val(sample), path(fq1), path(fq2), val(condition)

    output:
    tuple val(sample), path("${sample}_1.trimmed.fq.gz"), path("${sample}_2.trimmed.fq.gz"), val(condition), emit: trimmed_reads
    path "${sample}_fastp.json", emit: fastp_json
    path "${sample}_fastp.html", emit: fastp_html

    script:
    """
    fastp \\
        -i ${fq1} -I ${fq2} \\
        -o ${sample}_1.trimmed.fq.gz -O ${sample}_2.trimmed.fq.gz \\
        -j ${sample}_fastp.json \\
        -h ${sample}_fastp.html \\
        -w ${task.cpus} \\
        --length_required ${params.trim_min_length}
    """
}
