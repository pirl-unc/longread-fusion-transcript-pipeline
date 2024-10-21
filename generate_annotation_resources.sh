
if [ ! -f ${DNA_REFERENCE_GEN} ]; then
  wget -O ${DNA_REFERENCE_GEN}.gz https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_38/GRCh38.primary_assembly.genome.fa.gz
  gunzip -d ${DNA_REFERENCE_GEN}.gz
fi

if [ ! -f ${DNA_REFERENCE_ENS} ]; then
  wget -O ${DNA_REFERENCE_ENS}.gz http://ftp.ensembl.org/pub/release-105/fasta/homo_sapiens/dna/Homo_sapiens.GRCh38.dna.primary_assembly.fa.gz
  gunzip -d ${DNA_REFERENCE_ENS}.gz
fi

if [ ! -f ${CDNA_REFERENCE} ]; then
  #wget -O ${CDNA_REFERENCE}.gz http://ftp.ensembl.org/pub/release-105/fasta/homo_sapiens/cdna/Homo_sapiens.GRCh38.cdna.all.fa.gz
  wget -O ${CDNA_REFERENCE}.gz https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_38/gencode.v38.transcripts.fa.gz
  gunzip -d ${CDNA_REFERENCE}.gz
fi

if [ ! -f ${GTF_REFERENCE} ]; then
  #wget -O ${GTF_REFERENCE}.gz http://ftp.ensembl.org/pub/release-105/gtf/homo_sapiens/Homo_sapiens.GRCh38.105.gtf.gz
  wget -O ${GTF_REFERENCE}.gz https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/release_38/gencode.v38.annotation.gtf.gz
  gunzip -d ${GTF_REFERENCE}.gz
fi

if [ ! -f ${GENOMIC_SUPER_DUPS} ]; then
  wget -O ${GENOMIC_SUPER_DUPS}.gz ftp://hgdownload.soe.ucsc.edu/goldenPath/hg38/database/genomicSuperDups.txt.gz
  gunzip -d ${GENOMIC_SUPER_DUPS}.gz
fi

if [ ! -f ${TRANSCRIPT_LIMITED_FILE} ]; then
  Rscript generate_breakpoints.R ${GTF_REFERENCE_ENS} ${CDNA_REFERENCE_ENS} ${TRANSCRIPT_LIMITED_FILE} ${TRANSCRIPT_LIMIT}
fi
