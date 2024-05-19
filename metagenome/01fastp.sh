#!/bin/bash
usage()
{
    echo $0 '-i <input_folder> -o <output folder> -n <number of threads>'
}

thread=1	#Specifies the default number of concurrent requests.
Primary_DIR=$(pwd)
Script_DIR="$( cd "$( dirname "$0"  )" && pwd  )"

while getopts "hi:o:n:" opt
do
	case $opt in
		h)
		  usage
		  exit 0;;
		i)
		  if [ -d "$OPTARG" ]
            then 
            echo '-i: '$OPTARG
            input_folder=$OPTARG
          else
            echo "$OPTARG dose not exit!"
            usage
            exit 0
          fi;;
        o)
        if [ -d "$OPTARG" ]
            then 
            echo '-o: '$OPTARG
            output_folder=$OPTARG
          else
            echo "$OPTARG dose not exit!"
            usage
            exit 0
          fi;;
        n)
		  thread=$OPTARG;;
		?)
		  echo "invalid option"
		  echo $OPTARG
		  exit 1;;
	esac
done



#Defines a function that gets the file ID (flowcell_lane_barcode)#
file_id_func()
{
    file_basename=`basename $file` #Gets the file name without a path.
    file_left=${file_basename%%.*} #Intercept the file name before the first decimal point from left to right.
    file_right=${file_basename#*.} #Intercept the file name after the first decimal point from left to right.
    file_id=${file_left%_*} #Intercept the file name before the last "_" from left to right, flowcell_lane_barcode.
}

fastp_function()
{
    time fastp -i $i -I $I -o $o -O $O \
    -q 20 -u 40\
    -w 4 -h $h -j $j # -w: 4 internal threads。

}

tmpfile=$$.fifo    #Create a pipe name。 
mkfifo $tmpfile    #Create a pipe. 
exec 4<>$tmpfile   #Create file tag 4 to operate the pipeline in read and write mode.$tmpfile
rm $tmpfile        #Clears the created pipeline file.
# Create a corresponding number of placeholders for concurrent threads. 
{ 
for (( i = 1;i<=${thread};i++ )) 
do 
echo;                
done 
} >&4                

#First, obtain the files in the level-1 path.
for file in $input_folder/*_1.f*.gz 
do
    if [ -f "$file" ]  #Variable is double quoted to identify an empty string.
    then
        read	 
        {
        file_id_func 
        echo "Working on "$file_id
        mkdir $output_folder/$file_id
        i=$file                                   
        I=$input_folder/$file_id"_2."$file_right
        o=$output_folder/$file_id/$file_id"_1.fq.clean.gz"
        O=$output_folder/$file_id/$file_id"_2.fq.clean.gz"
        h=$output_folder/$file_id/$file_id".filter.report.html"
        j=$output_folder/$file_id/$file_id".filter.report.json"
        fastp_function 
        echo >&4 
        }& 
        sleep 5s 
    fi
done <&4                   

#Get the files in the secondary path (folder).
for folder in `ls $input_folder` 
do
    if [ -d "$input_folder/$folder" ]
    then
        for file in $input_folder/$folder/*_1.f*.gz 
        do
            if [ -f "$file" ]
            then
                read	 
                {
                file_id_func 
                
                echo "Working on "$file_id
                mkdir $output_folder/$file_id
                i=$file                                   
                I=$input_folder/$folder/$file_id"_2."$file_right
                o=$output_folder/$file_id/$file_id"_1.fq.clean.gz"
                O=$output_folder/$file_id/$file_id"_2.fq.clean.gz"
                h=$output_folder/$file_id/$file_id".filter.report.html"
                j=$output_folder/$file_id/$file_id".filter.report.json"
                fastp_function 
                echo >&4 
                }& 
                sleep 5s 
            fi            
        done
    fi
done <&4                   #Specify fd4 as the standard input for the entire FOR.

wait                       #Wait for all background tasks started in this shell script to complete. 
exec 4>&-                  #Pipe close. 
echo "All done!"
