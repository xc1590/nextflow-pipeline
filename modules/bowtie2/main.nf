process BOWTIE_MAPPING {
    tag   "$meta.id"
    label 'process_high'
    publishDir "${params.outdir}/bowtie2_mapping", mode: 'copy'

    container 'community.wave.seqera.io/library/bowtie2_htslib_samtools_pigz:edeb13799090a2a6'
    conda 'bioconda::bowtie2=2.5.4 bioconda::htslib=1.21 bioconda::samtools=1.21' 
    // adding all the dependencies in the conda environment to avoid any missing dependencies
    // here we include bowtie2, samtools, and pigz for compression

    input:
    tuple val(meta), path(contigs),path(reads)

    output:
    tuple val(meta), path("${meta.id}.sorted.bam"), path("${meta.id}.sorted.bam.bai"), emit: reads
    path "${meta.id}.flagstat.txt",   emit: flagstat
    path("${meta.id}.bowtie2.err"),  emit: err


    script:
    
    """
    bowtie2-build --threads ${task.cpus} ${contigs} ${meta.id}_index

    bowtie2 \\
        --end-to-end \\
        --very-sensitive \\
        -p ${task.cpus} \\
        -x ${meta.id}_index \\
        -1 ${reads[0]} -2 ${reads[1]} \\
        2> ${meta.id}.bowtie2.err | \\
        samtools view -u -@ ${task.cpus} - | \\
        samtools sort -@ ${task.cpus} -o ${meta.id}.sorted.bam -

        samtools index ${meta.id}.sorted.bam
        samtools flagstat ${meta.id}.sorted.bam > ${meta.id}.flagstat.txt
    
    """
}