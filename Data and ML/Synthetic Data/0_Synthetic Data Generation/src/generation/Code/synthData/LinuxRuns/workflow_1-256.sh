#!/usr/bin/env bash
#$ -N runs_1_256
#$ -q math
#$ -pe openmp 64
#$ -ckpt blcr
#$ -l mem_size=300
#$ -m beas

START=1
STOP=1

RUNDIR=runs_${START}_${STOP}
mkdir -p /scratch/$USER/$RUNDIR/genome
cd /scratch/$USER/$RUNDIR
cp /pub/$USER/LinuxRuns/vcf2maf.py .
cp /pub/$USER/LinuxRuns/createDNA .



module load anaconda
module load STAR/2.6.0c
PATH=$PATH:$HOME/bin


# Create Genome
gn=10000 # Number of genes
gl=1000 # gene length
gs=100 # Gene std
df=0.05 #driver gene fraction
of=0.5 # Onc fraction
gdir=genome_${gn}_${gl}_${gs}_${df/./p}_${of/./p} #Directory name

cp -r /pub/$USER/LinuxRuns/genome/$gdir genome/


# Get DNA
m=1        # Mutation per 100,000,000 basepairs
f=1.0      # Fraction of mutations that get repaired
cd=.01     #Cancer cell death
cv=0.2     #Cancer cell cycle rate
k=5.5      # Cancer threshold
wk=1.5e-7  #Wildtype o2 threshold
ck=1e-7    #Cancer o2 threshold
b=500      #Cells taken in a biopsy
snp=1.0    # Number of snps in gene before mutations
t=75       # Time in years
cpuprofile=cpu.pb.gz
memprofile=mem.pb.gz
nb=20000000
rdir=result_${m/./p}_${f/./p}_${k/./p}_${snp/./p}_${b}

mkdir -p /pub/$USER/LinuxRuns/result/${gdir}/${rdir}


foo (){
    gn=${2} # Number of genes
    gl=${3} # gene length
    gs=${4} # Gene std
    df=${5} #driver gene fraction
    of=${6} # Onc fraction
    gdir=${7} #Directory name

    # Get DNA
    m=${8} # Mutation per 100,000,000 basepairs
    f=${9} # Fraction of mutations that get repaired
    cd=${10} #Cancer cell death
    cv=${11} #Cancer cell cycle rate
    k=${12} # Cancer threshold
    wk=${13} #Wildtype o2 threshold
    ck=${14} #Cancer o2 threshold
    b=${15} #Cells taken in a biopsy
    snp=${16} # Number of snps in gene before mutations
    t=${17} # Time in years
    cpuprofile=${18}
    memprofile=${19}
    nb=${20}
    rdir=${21}/patient
    s=100

    echo "Running ${rdir}_$1"
    createDNA -gdir=$gdir -rdir=${rdir}_$1 \
   		-m=$m -f=$f -cd=$cd -cv=$cv -k=$k -nb=$nb -wk=$wk -ck=$ck -t=$t \
		-b=$b -snp=$snp -r=$1 -s=$s
    #-cpuprofile=$cpuprofile -memprofile=$memprofile

    genome=./genome/${gdir}/genome.fasta

    for i in $(eval echo "{000..$(($s - 1))}")
    do
        vcffile=./result/$gdir/${rdir}_$1/cells_${i}.vcf
        maffile=./result/$gdir/${rdir}_$1/cells_${i}.maf
	# # Run Python

	vcf2maf.py patient_$1 $genome $vcffile $maffile
        rm $vcffile
    done

    wait

    mafdir=./result/$gdir/${rdir}_${1}
    ls -1 $mafdir/*.maf > /dev/null 2>&1
    [ "$?" = 0 ] && cat $(ls -v $mafdir/*.maf) > $mafdir/patient_${1}.maf
    rm -r $mafdir/cells*

    mv ${mafdir} /pub/$USER/LinuxRuns/result/$gdir/${21}


    echo $1
}



export -f foo

parallel -j32 -u foo ::: $( eval echo "{${START}..${STOP}}" ) ::: $gn ::: $gl ::: $gs ::: $df ::: $of ::: $gdir ::: $m ::: $f ::: $cd ::: $cv ::: $k ::: $wk ::: $ck ::: $b ::: $snp ::: $t ::: $cpuprofile ::: $memprofile ::: $nb ::: $rdir

rm -rf /scratch/$USER/$RUNDIR


 mafdir=./result/$gdir/${rdir}
 cd $mafdir
 echo -e "Gene\tTumor_Sample\tStart_Position\tEnd_Position\tVariant_Classification\tReference_Allele\tTumor_Allele\tProtein_Change" > mutation.maf   ## writing the header to the final file
 ls -1 **/*.maf > /dev/null 2>&1
 [ "$?" = 0 ] && cat $(ls -v **/*.maf) >> mutation.maf
