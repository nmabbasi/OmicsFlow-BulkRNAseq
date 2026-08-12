process FEATURECOUNTS {
    label 'process_medium'
    publishDir "${params.outdir}/quantification", mode: params.publish_dir_mode

    input:
    path bam_files
    path gtf_file

    output:
    path "counts.txt", emit: counts
    path "counts.txt.summary", emit: summary

    script:
    """
    featureCounts \\
        -T ${task.cpus} \\
        -p \\
        -t ${params.fc_feature_type} \\
        -g ${params.fc_attribute_type} \\
        -a ${gtf_file} \\
        -o counts.txt \\
        ${bam_files}
    """
}
