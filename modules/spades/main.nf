process SPADES {
    tag   "$meta.id"
    label 'process_medium'

    publishDir "${params.outdir}/spades", mode: 'copy'

    container 'community.wave.seqera.io/library/spades:4.1.0--77799c52e1d1054a'
    conda 'bioconda::spades=4.1.0'

    input:
    tuple val(meta), path(reads)

    output:
    tuple val(meta), path("${meta.id}_spades/contigs.fasta"), emit: contigs
    path "${meta.id}_spades/spades.log",                       emit: log

    script:
    def args = task.ext.args ?: '--meta'
    """
    spades.py \\
        $args \\
        --threads ${task.cpus} \\
        -1 ${reads[0]} \\
        -2 ${reads[1]} \\
        -o ${meta.id}_spades
    """
}
