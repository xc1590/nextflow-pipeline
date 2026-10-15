process METAPHLAN_MERGE {
    label 'process_single'
    publishDir "${params.outdir}/metaphlan_merged", mode: 'copy'

    //module 'metaphlan/4.0.6' only on slurm 
    container 'quay.io/biocontainers/metaphlan:4.1.1--pyhdfd78af_0'
    conda 'bioconda::metaphlan=3.0.12'

    input:
    path profiles

    output:
    path "merged_abundance_table.txt_profile.txt", emit:merged_table

    script:
    """
    merge_metaphlan_tables.py *_profile.txt > merged_abundance_table.txt
    """
}
