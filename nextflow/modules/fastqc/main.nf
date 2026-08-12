process FASTQC {
    tag "$sample"
    label 'process_low'
    publishDir "${params.outdir}/qc/fastqc", mode: params.publish_dir_mode

    input:
    tuple val(sample), path(fq1), path(fq2), val(condition)

    output:
    path "*_fastqc.html", emit: fastqc_html
    path "*_fastqc.zip",  emit: fastqc_zips

    script:
    """
    fastqc -t ${task.cpus} ${fq1} ${fq2}
    """
}
