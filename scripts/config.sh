export CWD=$PWD
# where programs are
export BIN_DIR="/rsgrps/bhurwitz/hurwitzlab/bin"
export BOWTIE="/rsgrps/bhurwitz/alise/tools/bowtie2-2.3.3.1-linux-x86_64"
# where the dataset to prepare is
export DIR=""
export SAMPLE_LIST=""
export RAW_DIR=""
####NOTES for naming conventions :
# Raw files should be as follow ${SAMPLE}_R1_QC.fq and ${SAMPLE}_R2_QC.fq
# Contigs should be as follow ${SAMPLE}_contigs.fa
#place to store the scripts
export SCRIPT_DIR="$PWD/scripts"
# User informations
export QUEUE="standard"
export GROUP=""
export MAIL_USER=""
export MAIL_TYPE="bea"

#
# --------------------------------------------------
function init_dir {
    for dir in $*; do
        if [ -d "$dir" ]; then
            rm -rf $dir/*
        else
            mkdir -p "$dir"
        fi
    done
}

# --------------------------------------------------
function lc() {
    wc -l $1 | cut -d ' ' -f 1
}
