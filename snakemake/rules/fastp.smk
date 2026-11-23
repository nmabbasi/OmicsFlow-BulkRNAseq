rule fastp:
    input:
        fq1=lambda wildcards: SAMPLES.loc[wildcards.sample, "fastq_1"],
        fq2=lambda wildcards: SAMPLES.loc[wildcards.sample, "fastq_2"],
    output:
        fq1=f"{OUTDIR}/trimming/{{sample}}_1.trimmed.fq.gz",
        fq2=f"{OUTDIR}/trimming/{{sample}}_2.trimmed.fq.gz",
        json=f"{OUTDIR}/trimming/{{sample}}_fastp.json",
        html=f"{OUTDIR}/trimming/{{sample}}_fastp.html",
    params:
        min_length=config["fastp"]["min_length"],
    log:
        f"{OUTDIR}/logs/fastp/{{sample}}.log",
    conda:
        "../envs/omicsflow.yaml"
    threads: 4
    resources:
        mem_mb=8192,
        time_min=120,
    shell:
        r"""
        set -euo pipefail
        fastp -i {input.fq1} -I {input.fq2} \
              -o {output.fq1} -O {output.fq2} \
              -j {output.json} -h {output.html} \
              -w {threads} \
              --length_required {params.min_length} \
              > {log} 2>&1
        """
