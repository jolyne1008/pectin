#!/bin/bash
prokka=~/genome/prokka
dbcan=~/genome/dbcan
db=~/genome/db
for i in `ls $prokka/`
do
run_dbcan.py $prokka/${i}/${i}.faa protein --db_dir $db --out_dir $dbcan/${i} --c $prokka/${i}/${i}.gff --cgc_substrate --dia_cpu 30 --hmm_cpu 30 --hotpep_cpu 30 
done

