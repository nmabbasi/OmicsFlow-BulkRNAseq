process MULTIQC {
    label 'process_low'
    publishDir "${params.outdir}/multiqc", mode: params.publish_dir_mode

    input:
    path '*'

    output:
    path "multiqc_report.html", emit: report
    path "multiqc_data/", emit: data

    script:
    """
    multiqc .
    """
}
