rule cutadapt:
    input:
        read1 = lambda wildcards: f"resources/reads/{sample_layout.loc[wildcards.sample, "R1_file"]}",
        read2 = lambda wildcards: f"resources/reads/{sample_layout.loc[wildcards.sample, "R2_file"]}"
    params:
        Nfwd = lambda wildcards: sample_layout.loc[wildcards.sample, "N_forward"],
        Nrev = lambda wildcards: sample_layout.loc[wildcards.sample, "N_reverse"]
    output:
        read1 = 'results/1_trim/{sample}_trimmed.R1.fastq.gz',
        read2 = 'results/1_trim/{sample}_trimmed.R2.fastq.gz'
    resources:
        threads = 10,
        time = lambda _, attempt: f'00:{attempt*12}:00'
    log:
        'logs/1_trim/cutadapt-sample={sample}.stats'
    conda:
        'envs/cutadapt.yaml'
    envmodules:
        # Update the following, run module avail to see installed modules and versions
        'cutadapt/4.9'
    shell:
        r"""
        cutadapt -e 0.15 \
        --no-indels \
        --discard-untrimmed \
        --cores={threads} \
        -g {params.Nfwd} -G {params.Nrev} \
        -o {output.read1} -p {output.read2} \
        {input.read1} {input.read2} &> {log}
        """