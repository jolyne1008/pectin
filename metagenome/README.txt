This pipeline comprises three components, with a primary focus on eliminating host reads, constructing a bee gut microbiota database, and conducting taxonomic profiling. Note that these scripts require customization to suit your specific application needs.
PART I: The preprocessing of shotgun sequencing data.
1.	The process of quality control.
COMMAND: sh 01fastp.sh
2.	Removing host (Apis mellifera or Apis cerana) reads.
COMMAND: sh 02RemoveHost.sh
PART II: Building bee gut microbiota database.
Subsequently, a bee gut microbiota database will be constructed based on the MIDAS pipeline using genomes obtained from NCBI. 
1.	The process of data preparation for constructing a database.
The prearrangement of two files:
(1)	The file "name_cluster_fna_gff_faa_ffn" is delimited by tab key and consists of 6 columns: a) genome file name, b) cluster to which the strain belongs, c) absolute path of the genome file (.fna), d) absolute path of the gff file (.gff), e) absolute path of the protein sequence file (.faa), f) absolute path of the genes file (.ffn).
(2)	The file "all_genomes.mapfile" is delimited by tab key and consists of three columns: a) the name of the genome file, b) the cluster to which the strain belongs, and c) a boolean value. A value of '1' indicates that the strain is the representative strain of the cluster, while '0' indicates otherwise.
2.	The construction of the MIDAS database.
COMMAND: sh 03process.sh
The script will perform the following tasks: a) Organize and arrange the bee gut microbial genome in a designated folder named 'bee_gut_genome' using the previously prepared file 'name_cluster_fna_gff_faa_ffn'; b) Generate a genes file; c) Construct the MIDAS database by utilizing both the 'bee_gut_genome' folder and the aforementioned file 'all_genomes.mapfile'. 
PART III: The process of taxonomic profiling.
The taxonomic profiling was conducted by employing the MIDAS pipeline to align reads against a comprehensive database of bee gut microbiota. 
1.	Estimate SDP profile in individual by mapping reads to marker genes (run_midas.py species);
COMMAND: sh 04midas.sh
2.	Merging SDP abundance files across samples.
COMMAND: sh 05result_merge.sh
PART IV: The analysis and visualization of results.
The data should be transferred to Excel for analysis and visualization.

