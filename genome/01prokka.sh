#!/bin/bash
data=~/genome/data
prokka=~/genome/prokka
for i in `ls $data/`
do
j=`echo $i | sed 's/.fasta//'`
prokka $data/$i --kingdom Bacteria --outdir $prokka/$j --locustag $j --prefix $j --cpus 5
done
