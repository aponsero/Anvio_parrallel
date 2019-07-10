#!/bin/sh
set -u
#
# Checking args
#

source scripts/config.sh

if [[ ! -d "$DIR" ]]; then
    echo "$DIR directory does not exist. Please provide a directory containing contigs to process. Job terminated."
    exit 1
fi

if [[ ! -d "$RAW_DIR" ]]; then
    echo "$RAW_DIR directory does not exist. Please provide a directory containing raw files to process. Job terminated."
    exit 1
fi

if [[ -f "$SAMPLE_LIST" ]]; then
   echo "$SAMPLE_LIST does not exist. Please provide a file containing sample names to process. Job terminated."
    exit 1
fi

export NUM_FILES=$(wc -l < "$SAMPLE_LIST")

if [[ $NUM_FILES -eq 0 ]]; then
  echo "Empty sample list, please correct config file. Job terminated."
  exit 1
fi

#
# Job submission
#

PREV_JOB_ID=""
ARGS="-q $QUEUE -W group_list=$GROUP -M $MAIL_USER -m $MAIL_TYPE"

#
## 01-run mapping
#

PROG="01-run-mapping"
export STDERR_DIR="$SCRIPT_DIR/err/$PROG"
export STDOUT_DIR="$SCRIPT_DIR/out/$PROG"
init_dir "$STDERR_DIR" "$STDOUT_DIR"


echo "launching $SCRIPT_DIR/run_part1_anvio.sh "

JOB_ID=`qsub $ARGS -v SAMPLE_LIST,DIR,RAW_DIR,STDERR_DIR,STDOUT_DIR,BOWTIE -N run_part1_anvio -e "$STDERR_DIR" -o "$STDOUT_DIR" -J 1-$NUM_FILES $SCRIPT_DIR/run_part1_anvio.sh`

if [ "${JOB_ID}x" != "x" ]; then
      echo Job: \"$JOB_ID\"
      PREV_JOB_ID=$JOB_ID 
else
      echo Problem submitting job. Job terminated
fi
echo "job successfully submited"


#
## 02- anvio profiling
#

PROG2="02-anvio"
export STDERR_DIR="$SCRIPT_DIR/err/$PROG2"
export STDOUT_DIR="$SCRIPT_DIR/out/$PROG2"

init_dir "$STDERR_DIR2" "$STDOUT_DIR2"

JOB_ID=`qsub -v SAMPLE_LIST,DIR,RAW_DIR,STDERR_DIR2,STDOUT_DIR2 -N run_part2_anvio -e "$STDERR_DIR2" -o "$STDOUT_DIR2" -W depend=afterok:$PREV_JOB_ID $SCRIPT_DIR/run_part2_anvio.sh`

if [ "${JOB_ID}x" != "x" ]; then
    echo Job: \"$JOB_ID\"
else
    echo Problem submitting job.
fi

