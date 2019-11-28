# Anvio_parrallel
Pipeline for parrallel Anvi'o on HPC (PBS scheduler) 

## Requirements

### Anvio
This pipeline requires to download and install [anvio v6](http://merenlab.org/2016/06/26/installation-v2/)on the HPC. 
### Bowtie2
This pipeline requires to download and install [anvio v6](http://bowtie-bio.sourceforge.net/bowtie2/manual.shtml)on the HPC.

## Quick start

### Edit scripts/config.sh file

please modify the

  - DIR= Directory of contigs to process
  - SAMPLE_LIST= List of samples to process
  - RAW_DIR= directory containing raw fastq files

  - MAIL_USER = indicate here your arizona.edu email
  - GROUP = indicate here your group affiliation

You can also modify

  - BIN = change for your own bin directory.
  - MAIL_TYPE = change the mail type option. By default set to "bea".
  - QUEUE = change the submission queue. By default set to "standard".

## Naming convention
Raw files should be as follow ${SAMPLE}_R1_QC.fq and ${SAMPLE}_R2_QC.fq
Contigs should be as follow ${SAMPLE}_contigs.fa

  ### Run pipeline
  
  Run 
  ```bash
  ./submit.sh
  ```
  This command will place two jobs in queue.
