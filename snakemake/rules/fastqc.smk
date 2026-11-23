rule fastqc:
    input:
        fq=lambda wildcards: SAMPLES.loc[wildcards.sample, f"fastq_{wildcards.read}"],
    output:
        html=f"{OUTDIR}/qc/fastqc/{{sample}}_R{{read}}_fastqc.html",
        zip=f"{OUTDIR}/qc/fastqc/{{sample}}_R{{read}}_fastqc.zip",
    wildcard_constraints:
        read="1|2",
    log:
        f"{OUTDIR}/logs/fastqc/{{sample}}_R{{read}}.log",
    conda:
        "../envs/omicsflow.yaml"
    threads: 2
    resources:
        mem_mb=4096,
        time_min=60,
    shell:
        r"""
        set -euo pipefail
        TMPD=$(mktemp -d)
        trap 'rm -rf "$TMPD"' EXIT
        case "{input.fq}" in
            *.gz) EXT=.fastq.gz ;;
            *)    EXT=.fastq ;;
        esac
        ln -s "$(realpath "{input.fq}")" "$TMPD/{wildcards.sample}_R{wildcards.read}$EXT"
        fastqc -t {threads} --outdir "$TMPD" "$TMPD/{wildcards.sample}_R{wildcards.read}$EXT" > {log} 2>&1
        mv "$TMPD/{wildcards.sample}_R{wildcards.read}_fastqc.html" {output.html}
        mv "$TMPD/{wildcards.sample}_R{wildcards.read}_fastqc.zip" {output.zip}
        """
