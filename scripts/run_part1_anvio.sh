#!/bin/bash

#PBS -l select=1:ncpus=28:mem=6gb
#PBS -l walltime=24:00:00
#PBS -l place=free:shared

source activate anvio5
HOST=`hostname`
LOG="$STDOUT_DIR/${HOST}.log"
ERRORLOG="$STDERR_DIR/${HOST}.log"

if [ ! -f "$LOG" ] ; then
    touch "$LOG"
fi
echo "Started `date`">>"$LOG"
echo "Host `hostname`">>"$LOG"


SAMPLE=`head -n +${PBS_ARRAY_INDEX} $SAMPLE_LIST | tail -n 1`
CONTIG_BASE="${SAMPLE}_contigs"
FILE="$DIR/${CONTIG_BASE}.fa"
REPORT="$DIR/${CONTIG_BASE}.log"

####fixing header 
FIXED="$DIR/${CONTIG_BASE}_fixed.fa"
anvi-script-reformat-fasta $FILE -o $FIXED -l 0 --simplify-names --report-file $REPORT

#####mapping the files
MAP="$DIR/${CONTIG_BASE}"
$BOWTIE/bowtie2-build $FIXED $MAP 


####index the mapping file
QC_1="$RAW_DIR/${SAMPLE}_R1_QC.fq"
QC_2="$RAW_DIR/${SAMPLE}_R2_QC.fq"
SAM="$DIR/${CONTIG_BASE}.sam"
RAW_BAM="$DIR/${CONTIG_BASE}-RAW.bam"
BAM="$DIR/${CONTIG_BASE}.bam"
$BOWTIE/bowtie2 --threads 20 -x $MAP -1 $QC_1 -2 $QC_2 -S $SAM
samtools view -F 4 -bS $SAM > $RAW_BAM
anvi-init-bam $RAW_BAM -o $BAM
rm $SAM $RAW_BAM
rm *.bt2


