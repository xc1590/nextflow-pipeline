process MULTIQC {
    label 'process_single'

    conda 'bioconda::multiqc=1.35'     // copy the version from nf-core multiqc environment.yml
    container 'community.wave.seqera.io/library/multiqc:1.35--c17fb751507e9dfc'                       // copy from nf-core multiqc main.nf

    publishDir "${params.outdir}/multiqc", mode: 'copy'

    input:
    path multiqc_files

    output:
    path "multiqc_report.html", emit: report
    path "multiqc_data",        emit: data

    script:
    """
    multiqc . --force
    """
}