This process is mainly used for the annotation of bacterial genome and the search of carbohydrate-active enzymes.
1.	Gene annotation.
When we have the assembled genome, we annotate it in a generic way.
COMMAND: sh prokka.sh
2.	Gene prediction for CAZymes and CGCs.
The local annotation program of dbCAN was used to find the polysaccharide degrading genes.
COMMAND: sh dbcan.sh
3.	Additional gene annotation to further check gene function.
We used online software to further verify the results of the previous step.
Using EggNOG-mapper online annotation (version 2.1.9, http://eggnog-mapper.embl.de/)
4.	Drawing heatmap.
Finally, we can display the results through R or other online tools. 
Using circle-heatmap.R or using iTOL (https://itol.embl.de/).
