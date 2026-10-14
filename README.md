# Nextflow pipeline: adaptor trimming and QC 

This repository contains a small Nextflow pipeline I wrote while learning to build reproducible workflows. My goal is to move the analysis steps I currently run on an HPC cluster into Nextflow, so that everything can be reproduced and shared.

The pipeline trims adapters with cutadapt, then runs FastQC on the trimmed reads. It started as a step in the metagenomic preprocessing workflow I use on the cluster.

## What it does: 
samplesheet.csv --> CUTADAPT --> FASTQC 
 
-input: a CSV with columns "sample, fastq1, fastq2" (paired-end reads)
-output: trimmed reads, cutadapt logs, FastQC reports, and tools version, all under "result" 

# Run it 
1. Install Nextflow and conda 
2. Download two small public test samples (from nf-core/test-datasets,taxprofiler branch)
3. nextflow run . -profile conda --input data/samplesheet.csv

## Tested
- Nextflow 26.04.3 on macOS with `-profile conda`: all 4 tasks completed (~6 min, mostly building the conda environments the first time).

## Next
- Add MultiQC
- Add taxonomic profiling (Kraken2 or MetaPhlAn)