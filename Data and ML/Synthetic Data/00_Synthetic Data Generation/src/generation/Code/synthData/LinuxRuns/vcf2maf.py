#!/usr/bin/env python

import pandas as pd
import numpy as np
from Bio import SeqIO
from Bio.Seq import Seq
from Bio.Alphabet import generic_dna
import random
from datetime import datetime
import argparse

parser = argparse.ArgumentParser(description='Conver VCF to MAF')
parser.add_argument('-r', '--rand', type=int, help='Seed for rng')
parser.add_argument('run', type=str, help='Run Name')
parser.add_argument('genome', type=str, help='Genome file location')
parser.add_argument('vcf', type=str, help='VCF file to convert')
parser.add_argument('maf', type=str, help='MAF file save')

args = parser.parse_args()
if args.rand:
    random.seed(args.rand)
else:
    random.seed(datetime.now())

genomePath = args.genome
vcfPath = args.vcf
mafPath = args.maf


def make_index(identifier):
    idx = identifier.split()
    return int(idx[0])


fastaSeq = SeqIO.index(genomePath, 'fasta', key_function=make_index)
df = pd.read_csv(vcfPath, sep="\t", header=17)
if df.empty:
    exit(0)

df = df[['#CHROM', "POS", "REF", "ALT"]]
df = df.rename(columns={"#CHROM": "Gene"})


def MutClassifier(chrom, pos, alt):
    mutation = fastaSeq[chrom].seq
    cPos = pos - 1
    nPos = int(cPos % 3)
    cPos = cPos - nPos
    nuc = str(mutation[cPos:cPos + 3])
    if len(alt) > 1:
        altchoice = alt.split(',')
        alt = random.choice(altchoice)

    mut = nuc[:nPos] + alt + nuc[nPos + 1:]
    codon = Seq(nuc, generic_dna).translate()
    mutCodon = Seq(mut, generic_dna).translate()
    location = "p." + str(codon) + str(int(cPos / 3)) + str(mutCodon)
    if mutCodon == codon:
        return ["Silent", location, pos]
    else:
        if mutCodon == "*":
            return ["Nonsense_Mutation", location, pos]
        else:
            return ["Missense_Mutation", location, pos]


df[["Variant_Classification", "Protein_Change", "End_Position"]] = df.apply(
    lambda x: pd.Series(MutClassifier(x['Gene'], x["POS"], x["ALT"])), axis=1)
df = df.rename(columns={
    "POS": "Start_Position",
    "REF": "Reference_Allele",
    "ALT": "Tumor_Allele"
})
df["Tumor_Sample"] = args.run

df = df[[
    "Gene", "Tumor_Sample", "Start_Position", "End_Position",
    "Variant_Classification", "Reference_Allele", "Tumor_Allele",
    "Protein_Change"
]]


def filterMaf(x):
    # print(x)
    if (x == "Nonsense_Mutation").any():
        L = len(x) - 1
        result = np.zeros_like(x)
        r = random.randint(0, L)
        result[r] = 1
        return result
    result = np.ones_like(x)
    return result


# dp = df.Gene.unique()

dg = df.groupby(["Gene"])
df = df[dg.Variant_Classification.transform(filterMaf).astype(bool)]

# print(df[dp])
df.to_csv(mafPath, sep="\t", index=False, header=False)
