# Nextflow pipeline: 
This repository contains a small Nextflow pipeline I wrote while learning to build reproducible workflows. My goal is to move the analysis steps I ran on an HPC cluster into Nextflow ultimately, so that everything can be reproduced and shared.

## What it does: 
```
samplesheet.csv --> CUTADAPT --> FASTQC -----------------+
                       |                                 |
                       +--> SPADES --> PRODIGAL          +--> MULTIQC
                       |       |                         |
                       |       +--> BOWTIE_MAPPING ------+
                       |                  ^
                       +------------------+  (trimmed reads)
                       |
                       +--> METAPHLAN  (optional: needs --metaphlan_db)
```

**CUTADAPT** trims adapters and low-quality ends from the paired reads.
**FASTQC** makes a quality report on the tßrimmed reads.
**SPADES** assembles the trimmed reads into contigs (metaSPAdes, `--meta`).
**BOWTIE_MAPPING** maps the trimmed reads back to those contigs with Bowtie2, then sorts and indexes the alignments with samtools and counts mapped reads.
**PROFIGAL** predicts coding protein region from metagonome 
**MULTIQC** reds the report and log files from other tools write and puts them all into on HTML page. 
**METAPLAN** is optional. To run it, download the newest metaphlan4 database. When MetaPhlAn finishes, the per-sample profiles are merged automatically into one abundance table (`merged_abundance_table.txt`) with `merge_metaphlan_tables.py`.

1. **Input:** a CSV with columns `sample,fastq_1,fastq_2` (paired-end reads)
2. **Output** (under `results/`): trimmed reads and cutadapt logs, FastQC reports, SPAdes contigs, and sorted BAM files with indexes, flagstat and Bowtie2 logs

# Run it 
1. Install Nextflow and conda 
2. Download two small public test samples (from nf-core/test-datasets,taxprofiler branch)
3. nextflow run . -profile conda --input data/samplesheet.csv

## Tested
- Nextflow 26.04.3 on macOS with `-profile conda`: cutadapt, FastQC and SPAdes, bowtie2 mapping (metaSPAdes, `--meta`), Prodigal, and MultiQC, completed on two small public test samples (6 tasks, about 50 min, mostly building the conda environments the first time).
- Tested optional MetaPhlAn4.0.6 and metaphlan_merged.py. The Metaphlan step was also run through Slurm on an HPC cluster and successfully passed the test. 

## Next

