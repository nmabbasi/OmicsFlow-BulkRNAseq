rule hisat2_mapping:
    input:
        fq1 = f"{config['outdir']}/trimming/{{sample}}_1.trimmed.fq.gz",
        fq2 = f"{config['outdir']}/trimming/{{sample}}_2.trimmed.fq.gz"
    output:
        bam = f"{config['outdir']}/mapping/{{sample}}.sorted.bam",
        bai = f"{config['outdir']}/mapping/{{sample}}.sorted.bam.bai",
        log = f"{config['outdir']}/mapping/{{sample}}_hisat2.log"
    conda:
        "../envs/omicsflow.yaml"
    threads: 8
    resources:
        mem_mb = 32768,
        time_min = 360
    shell:
        """
        hisat2 -p {threads} -x {config[hisat2_index]} \\
               -1 {input.fq1} -2 {input.fq2} 2> {output.log} | \\
        samtools view -bS - | \\
        samtools sort -@ {threads} -o {output.bam} -
        samtools index {output.bam}
        """
