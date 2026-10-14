process PRODIGAL {
    tag   "$meta.id"
    label 'process_low'
    publishDir "${params.outdir}/prodigal", mode: 'copy'

    container 'community.wave.seqera.io/library/prodigal_pigz:27b5cdb2d516f347'
    conda 'bioconda::prodigal=2.6.3' 
    
    input:
    tuple val(meta), path(contigs)

    output:
    tuple val(meta), path("${meta.id}.genes.gff"), emit: gff
    tuple val(meta), path("${meta.id}.proteins.faa"), emit: proteins
    tuple val(meta), path("${meta.id}.genes.fna"), emit: genes

    script:
    
    """
    prodigal \\
        -i ${contigs} \\
        -f gff \\
        -o ${meta.id}.genes.gff \\
        -a ${meta.id}.proteins.faa \\
        -d ${meta.id}.genes.fna \\
        -p meta
    """
}