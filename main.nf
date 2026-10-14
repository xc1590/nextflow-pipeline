#!/usr/bin/env nextflow

include { CUTADAPT } from './modules/cutadapt/main'
include { FASTQC }   from './modules/fastqc/main'
include { SPADES }   from './modules/spades/main'
include { BOWTIE_MAPPING } from './modules/bowtie2/main'

workflow {

    ch_reads = Channel
        .fromPath(params.input, checkIfExists: true)
        .splitCsv(header: true)
        .map { row ->
            def meta  = [ id: row.sample, single_end: false ]
            def files = [ file(row.fastq_1, checkIfExists: true),
                          file(row.fastq_2, checkIfExists: true) ]
            [ meta, files ]
        }

    CUTADAPT( ch_reads )
    FASTQC( CUTADAPT.out.reads )
    SPADES( CUTADAPT.out.reads )
    BOWTIE_MAPPING( SPADES.out.contigs.join( CUTADAPT.out.reads ) ) // join the contigs and reads channels for mapping

}



