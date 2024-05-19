#MIDAS environment
conda activate ~/conda_env/python3.6

#the path of metagenome
export data=~/metagenome/midas/data
#the path of saving result
export result=~/metagenome/midas/result
#the path of database
export db=~/metagenome/database/bee_gut_database

cat $data/<sample.list> | parallel --gnu -j 40 "
run_midas.py species $result/{} -1 $data/{}/{}_1.*fastq* -2 $data/{}/{}_2.*fastq* -t 2 -d $db

conda deactivate