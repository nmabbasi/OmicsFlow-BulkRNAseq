rule multiqc:
    input:
        expand(f"{config['outdir']}/qc/fastqc/{{sample}}_fastqc.zip", sample=SAMPLE_NAMES),
        expand(f"{config['outdir']}/trimming/{{sample}}_fastp.json", sample=SAMPLE_NAMES),
        expand(f"{config['outdir']}/mapping/{{sample}}_hisat2.log", sample=SAMPLE_NAMES),
        f"{config['outdir']}/quantification/counts.txt.summary"
    output:
        html = f"{config['outdir']}/multiqc/multiqc_report.html",
        data_dir = directory(f"{config['outdir']}/multiqc/multiqc_data")
    conda:
        "../envs/omicsflow.yaml"
    threads: 2
    resources:
        mem_mb = 4096,
        time_min = 30
    shell:
        """
        multiqc {config[outdir]} -o {config[outdir]}/multiqc
        """
