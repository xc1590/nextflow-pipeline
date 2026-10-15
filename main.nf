#!/usr/bin/env nextflow

include { CUTADAPT } from './modules/cutadapt/main'
include { FASTQC }   from './modules/fastqc/main'
include { SPADES }   from './modules/spades/main'
include { BOWTIE_MAPPING } from './modules/bowtie2/main'
include { PRODIGAL } from './modules/prodigal/main'
include { MULTIQC } from './modules/multiQC/main'
include { METAPHLAN } from './modules/metaphlan/main'
include { METAPHLAN_MERGE } from './modules/metaphlan_merge/main'

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
    BOWTIE_MAPPING( SPADES.out.contigs.join( CUTADAPT.out.reads ))
    PRODIGAL( SPADES.out.contigs )
    ch_multiqc = FASTQC.out.zip.map { meta, f -> f }
    .mix( BOWTIE_MAPPING.out.flagstat )
    .collect()
    MULTIQC( ch_multiqc )
    if (params.metaphlan_db) {
    METAPHLAN( CUTADAPT.out.reads, file(params.metaphlan_db) ) // only when metaphlan_db is provided
    }
    METAPHLAN_MERGE( METAPHLAN.out.profile.map { meta, f -> f }.collect() )


}





