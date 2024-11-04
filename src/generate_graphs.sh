N_TRANSCRIPTS=("canoncical") #REPLACE_N_TRANSCRIPTS
REPLICATES=10 #REPLACE_REPLICATES
COVERAGE=(3 10 30 50 100) #REPLACE_COVERAGE
QUALITY=("95,100,4") #REPLACE_QUALITY
TECH=("pacbio2021" "nanopore2023") #REPLACE_TECH
READ_LENGTHS=(150) #REPLACE_READ_LENGTHS
					MIN_OVERLAP_LEN=100 # REPLACE_MIN_OVERLAP_LEN
					BIN_SIZE=50 # REPLACE_BIN_SIZE
MIN_MAP_LENGTH=100 #REPLACE_MIN_MAP_LENGTH
GENION_MIN_SUPPORT=2 #REPLACE_GENION_MIN_SUPPORT

print_array() {
array=("$@")
#printf -v tmp '%s, ' "${array[@]}"
#printf -v out '%s\n' "${tmp%, }"
printf -v one %s "${array[0]}"
printf -v two ',%s' "${array[@]:1}"
printf -v three '\n'
echo "${one}${two}${three}"
}

#print_array $COVERAGE

N_TRANSCRIPTS=`IFS=':';echo "${N_TRANSCRIPTS[*]// /:}";IFS=$' \t\n'`
COVERAGE=`IFS=':';echo "${COVERAGE[*]// /:}";IFS=$' \t\n'`
QUALITY=`IFS=':';echo "${QUALITY[*]// /:}";IFS=$' \t\n'`
TECH=`IFS=':';echo "${TECH[*]// /:}";IFS=$' \t\n'`
READ_LENGTHS=`IFS=':';echo "${READ_LENGTHS[*]// /:}";IFS=$' \t\n'`

#echo $N_TRANSCRIPTS
#echo $COVERAGE
#echo $QUALITY
#echo $TECH
#echo $READ_LENGTHS

Rscript $DOCKER_SRC/combined_graphs.R ${FUSIM_REF_FILE} ${GENION_STORAGE_DIR} ${JAFFAL_STORAGE_DIR} ${LONGGF_STORAGE_DIR} ${FUSIONSEEKER_STORAGE_DIR} ${ARRIBA_STORAGE_DIR} ${STARFUSION_STORAGE_DIR} ${PBFUSION_STORAGE_DIR} ${GRAPHS_STORAGE_DIR} ${N_TRANSCRIPTS} ${COVERAGE} ${QUALITY} ${TECH} ${REPLICATES} ${READ_LENGTHS}
