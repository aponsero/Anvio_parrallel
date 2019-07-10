#!/bin/bash

#PBS -l select=1:ncpus=28:mem=6gb
#PBS -l walltime=24:00:00
#PBS -l place=free:shared

source activate anvio5

HOST=`hostname`
LOG="$STDOUT_DIR2/${HOST}.log"
ERRORLOG="$STDERR_DIR2/${HOST}.log"

if [ ! -f "$LOG" ] ; then
    touch "$LOG"
fi
echo "Started `date`">>"$LOG"
echo "Host `hostname`">>"$LOG"

SAMPLE=`head -n +${PBS_ARRAY_INDEX} $SAMPLE_LIST | tail -n 1`
CONTIG_BASE="${SAMPLE}_contigs"
FILE="$DIR/${CONTIG_BASE}.fa"
REPORT="$DIR/${CONTIG_BASE}.log"

FIXED="$DIR/${CONTIG_BASE}_fixed.fa"

QC_1="$RAW_DIR/${SAMPLE}_R1_QC.fq"
QC_2="$RAW_DIR/${SAMPLE}_R2_QC.fq"
BAM="$DIR/${CONTIG_BASE}.bam"

####Creating an anvi’o contigs database
DATABASE="$DIR/${CONTIG_BASE}.db"
anvi-gen-contigs-database -f $FIXED -o $DATABASE -n 'A test contigs datbase'

####HMM creation --> does not work in the current anvio but it is an optional step
#anvi-run-hmms -c $DATABASE

###COGS
anvi-run-ncbi-cogs -c $DATABASE -T 28

### profiling Anvio
anvi-profile -i $BAM -c $DATABASE --cluster-contigs

