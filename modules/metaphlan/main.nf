process METAPHLAN {
    tag   "$meta.id"
    label 'process_high'
    publishDir "${params.outdir}/metaphlan", mode: 'copy'

    //module 'metaphlan/4.0.6' only on slurm 
    container 'quay.io/biocontainers/metaphlan:4.1.1--pyhdfd78af_0'
    conda 'bioconda::metaphlan=3.0.12'

    input:
    tuple val(meta), path(reads)
    path db

    output:
    tuple val(meta), path("${meta.id}_profile.txt"), emit:profile
    tuple val(meta), path("${meta.id}_bowtie2out.txt"), emit:bowtie2out

    script:
    def args = task.ext.args ?: ''
    """
    metaphlan ${reads[0]},${reads[1]} \\
        --input_type fastq \\
        --bowtie2db ${db} \\
        --bowtie2out ${meta.id}_bowtie2out.txt \\
        -o ${meta.id}_profile.txt \\
        $args
    """
}
