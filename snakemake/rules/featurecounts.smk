rule featurecounts:
    input:
        bams=expand(f"{OUTDIR}/mapping/{{sample}}.sorted.bam", sample=SAMPLE_NAMES),
        gtf=config["gtf_file"],
    output:
        counts=f"{OUTDIR}/quantification/counts.txt",
        summary=f"{OUTDIR}/quantification/counts.txt.summary",
    params:
        feature_type=config["featurecounts"]["feature_type"],
        attribute_type=config["featurecounts"]["attribute_type"],
        strandedness=config["featurecounts"]["strandedness"],
    log:
        f"{OUTDIR}/logs/featurecounts/featurecounts.log",
    conda:
        "../envs/omicsflow.yaml"
    threads: 8
    resources:
        mem_mb=16384,
        time_min=240,
    shell:
        r"""
        set -euo pipefail
        featureCounts -T {threads} -p --countReadPairs \
                      -s {params.strandedness} \
                      -t {params.feature_type} \
                      -g {params.attribute_type} \
                      -a {input.gtf} \
                      -o {output.counts} {input.bams} \
                      > {log} 2>&1
        """
