#!/usr/bin/env bash
# Create Genome
gn=500 # Number of genes
gl=500 # gene length
gs=10 # Gene std
df=0.4 #driver gene fraction
of=0.5 # Onc fraction
gdir=genome_${gn}_${gl}_${gs}_${df/./p}_${of/./p} #Directory name

if [ ! -e ./genome/$gdir ]; then
    echo "Creating New Genome"
    genome -dir=genome/$gdir -df=$df -gl=$gl -gn=$gn -gs=$gs -of=$of
fi


# Get DNA
m=10
f=0.1
cd=.01
cv=0.2
k=2.5
wk=1e-6
ck=1e-6
b=500
snp=1.0
t=30
cpuprofile=cpu_new.prof
memprofile=mem_new.prof
nb=2000000
rdir=run_${m/./p}_${f/./p}_${k/./p}_${snp/./p}_${b}/patient


count=0
for i in {1..1}
do

    echo "Running ${rdir}_$i"
    synthData.exe -gdir=$gdir -rdir=${rdir}_${i} \
    		  -m=$m -f=$f -cd=$cd -cv=$cv -k=$k -nb=$nb -wk=$wk -ck=$ck -t=$t \
		  -b=$b -snp=$snp \
		  -cpuprofile=$cpuprofile -memprofile=$memprofile

done
