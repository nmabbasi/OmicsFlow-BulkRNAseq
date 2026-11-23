rule hisat2_mapping:
    input:
        fq1=f"{OUTDIR}/trimming/{{sample}}_1.trimmed.fq.gz",
        fq2=f"{OUTDIR}/trimming/{{sample}}_2.trimmed.fq.gz",
        # Assumes standard .ht2 index files exist at the configured prefix
        idx=f"{config['hisat2_index']}.1.ht2",
    output:
        bam=f"{OUTDIR}/mapping/{{sample}}.sorted.bam",
        bai=f"{OUTDIR}/mapping/{{sample}}.sorted.bam.bai",
        summary=f"{OUTDIR}/mapping/{{sample}}_hisat2.summary.txt",
    params:
        index=lambda wc, input: input.idx.removesuffix(".1.ht2"),
    log:
        hisat2=f"{OUTDIR}/logs/mapping/{{sample}}_hisat2.log",
        samtools=f"{OUTDIR}/logs/mapping/{{sample}}_samtools.log",
    conda:
        "../envs/omicsflow.yaml"
    threads: 8
    resources:
        mem_mb=32768,
        time_min=360,
    shell:
        r"""
        set -euo pipefail
        SORT_THREADS=$(( {threads} > 2 ? 2 : 1 ))
        ALIGN_THREADS=$(( {threads} > 2 ? {threads} - 2 : 1 ))
        hisat2 -p "$ALIGN_THREADS" \
               -x {params.index} \
               -1 {input.fq1} -2 {input.fq2} \
               --new-summary --summary-file {output.summary} \
               2> {log.hisat2} \
          | samtools sort -@ "$SORT_THREADS" -o {output.bam} - 2> {log.samtools}
        samtools index -@ "$SORT_THREADS" {output.bam} 2>> {log.samtools}
        """
