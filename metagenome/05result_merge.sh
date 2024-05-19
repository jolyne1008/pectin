#MIDAS environment
conda activate ~/conda_env/python3.6

#the path of result
export result=~/metagenome/midas/result
#a list of the path about every sample 
export sample=~/metagenome/midas/result/<sample name>
#the path of database
export db=~/metagenome/database/bee_gut_database/

merge_midas.py species $result/species_merge -i $sample -t list -d $db

conda deactivate