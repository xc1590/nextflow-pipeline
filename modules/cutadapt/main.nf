process CUTADAPT {
    tag   "$meta.id"
    label 'process_medium'
    publishDir "${params.outdir}/cutadapt", mode: 'copy'

    container 'community.wave.seqera.io/library/cutadapt:4.5--h9ee0642_0'
    conda 'bioconda::cutadapt=4.5'

    input:
    tuple val(meta), path(reads)

    output:
    tuple val(meta), path("*.trim.fastq.gz"), emit: reads
    tuple val(meta), path("*.cutadapt.log"),  emit: log
    path  "versions.yml",                     emit: versions

    script:
    def prefix   = task.ext.prefix ?: "${meta.id}"
    def args     = task.ext.args   ?: '-q 20 -m 36'
    def adapters = meta.single_end ? '-a AGATCGGAAGAGC'
                                   : '-a AGATCGGAAGAGC -A AGATCGGAAGAGC'
    def out      = meta.single_end ? "-o ${prefix}.trim.fastq.gz"
                                   : "-o ${prefix}_1.trim.fastq.gz -p ${prefix}_2.trim.fastq.gz"
    """
    cutadapt \\
        --cores ${task.cpus} \\
        ${adapters} \\
        ${args} \\
        ${out} \\
        ${reads} \\
        > ${prefix}.cutadapt.log

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        cutadapt: \$(cutadapt --version)
    END_VERSIONS
    """
}
