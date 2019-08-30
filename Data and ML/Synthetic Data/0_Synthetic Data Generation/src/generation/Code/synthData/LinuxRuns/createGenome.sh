#!/usr/bin/env bash
# Create Genome
gn=10000 # Number of genes
gl=1000 # gene length
gs=100 # Gene std
df=0.1 #driver gene fraction
of=0.5 # Onc fraction
gdir=genome_${gn}_${gl}_${gs}_${df/./p}_${of/./p} #Directory name

module load STAR/2.6.0c

if [[ ! -e ./genome/${gdir} ]]; then
    echo "Creating New Genome"
    genome/createGenome -dir=genome/$gdir -df=$df -gl=$gl -gn=$gn -gs=$gs -of=$of

    genome=./genome/${gdir}/genome.fasta
    echo "Indexing Genome"
    base=$(echo "l($gn*$gl)/l(2)/2" | bc -l)
    base=${base%.*}
    if (($base > 14))
    then
	base=14
    fi

    STAR --runMode genomeGenerate --genomeDir ./genome/$gdir --genomeFastaFiles $genome \
	 --runThreadN 8 --genomeSAindexNbases $base
fi
