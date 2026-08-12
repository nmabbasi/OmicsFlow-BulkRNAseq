rule fastqc:
    input:
        fq1 = lambda wildcards: SAMPLES.loc[wildcards.sample, "fastq_1"],
        fq2 = lambda wildcards: SAMPLES.loc[wildcards.sample, "fastq_2"]
    output:
        html = f"{config['outdir']}/qc/fastqc/{{sample}}_fastqc.html",
        zip = f"{config['outdir']}/qc/fastqc/{{sample}}_fastqc.zip"
    conda:
        "../envs/omicsflow.yaml"
    threads: 2
    resources:
        mem_mb = 4096,
        time_min = 60
    shell:
        """
        fastqc -t {threads} --outdir {config[outdir]}/qc/fastqc {input.fq1} {input.fq2}
        """
