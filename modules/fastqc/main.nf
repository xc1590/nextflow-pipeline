process FASTQC {
    tag   "$meta.id"
    label 'process_medium'

    publishDir "${params.outdir}/fastqc", mode: 'copy'

    container 'community.wave.seqera.io/library/fastqc:0.13.0--b342db7b694c9af4'
    conda 'bioconda::fastqc=0.13.0'

    input:
    tuple val(meta), path(reads)

    output:
    tuple val(meta), path("*.html"), emit: html
    tuple val(meta), path("*.zip"),  emit: zip
    path  "versions.yml",            emit: versions

    script:
    """
    fastqc --threads ${task.cpus} ${reads}

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        fastqc: \$(fastqc --version | sed 's/FastQC v//')
    END_VERSIONS
    """
}
