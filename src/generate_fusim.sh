
if [ ! -f ${REF_STORAGE_DIR}/refFlat.txt ]; then
  wget -O ${REF_STORAGE_DIR}/refFlat.txt.gz http://hgdownload.cse.ucsc.edu/goldenPath/hg38/database/refFlat.txt
  gunzip ${REF_STORAGE_DIR}/refFlat.txt.gz
fi

if [ ! -f ${REF_STORAGE_DIR}/hg38_chroma.fa ]; then
  wget -O ${REF_STORAGE_DIR}/hg38.chromFa.tar.gz ftp://hgdownload.cse.ucsc.edu/goldenPath/hg38/bigZips/hg38.chromFa.tar.gz
  tar -xzf ${REF_STORAGE_DIR}/hg38.chromFa.tar.gz
  cat ${REF_STORAGE_DIR}/chr*.fa > hg38_chroma.fa
  samtools faidx ${REF_STORAGE_DIR}/hg38_chroma.fa
fi

java -jar /bin/fusim-0.2.2/fusim.jar \
  --gene-model=${REF_STORAGE_DIR}/refFlat.txt \
  --fusions=${NFUSIONS} \
  --reference=${REF_STORAGE_DIR}/hg38_chroma.fa \
  --fasta-output=${FUSIM_FASTA_FILE} \
  --text-output=${FUSIM_TXT_FILE}

cat ${TRANSCIPT_LIMITED_FILE} ${FUSIM_FASTA_FILE} > ${FUSION_TRANSCRIPTOME}

Rscript create_fusim_ref.R ${FUSIM_TXT_FILE} ${FUSIM_REF_FILE}
