rule featurecounts:
    input:
        bams = expand(f"{config['outdir']}/mapping/{{sample}}.sorted.bam", sample=SAMPLE_NAMES)
    output:
        counts = f"{config['outdir']}/quantification/counts.txt",
        summary = f"{config['outdir']}/quantification/counts.txt.summary"
    conda:
        "../envs/omicsflow.yaml"
    threads: 8
    resources:
        mem_mb = 16384,
        time_min = 240
    shell:
        """
        featureCounts -T {threads} -p \\
                      -t {config[featurecounts][feature_type]} \\
                      -g {config[featurecounts][attribute_type]} \\
                      -a {config[gtf_file]} \\
                      -o {output.counts} {input.bams}
        """
