rule multiqc:
    input:
        fastqc=expand(f"{OUTDIR}/qc/fastqc/{{sample}}_R{{read}}_fastqc.zip", sample=SAMPLE_NAMES, read=["1", "2"]),
        fastp=expand(f"{OUTDIR}/trimming/{{sample}}_fastp.json", sample=SAMPLE_NAMES),
        hisat2=expand(f"{OUTDIR}/mapping/{{sample}}_hisat2.summary.txt", sample=SAMPLE_NAMES),
        counts=f"{OUTDIR}/quantification/counts.txt.summary",
    output:
        html=f"{OUTDIR}/multiqc/multiqc_report.html",
        data_dir=directory(f"{OUTDIR}/multiqc/multiqc_data"),
    params:
        outdir=lambda wc, output: os.path.dirname(output.html),
    log:
        f"{OUTDIR}/logs/multiqc/multiqc.log",
    conda:
        "../envs/omicsflow.yaml"
    threads: 2
    resources:
        mem_mb=4096,
        time_min=30,
    shell:
        r"""
        set -euo pipefail
        multiqc --force -o {params.outdir} {input.fastqc} {input.fastp} {input.hisat2} {input.counts} > {log} 2>&1
        """
