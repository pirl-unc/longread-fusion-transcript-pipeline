
FASTA_NAME=Homo_sapiens.cdna.gtf_limited.fa

if [ ! -f Homo_sapiens.GRCh38.105.gtf ]; then
  wget http://ftp.ensembl.org/pub/release-105/gtf/homo_sapiens/Homo_sapiens.GRCh38.105.gtf.gz
  gunzip -d Homo_sapiens.GRCh38.105.gtf.gz
fi

if [ ! -f Homo_sapiens.GRCh38.cdna.all.fa ]; then
  wget http://ftp.ensembl.org/pub/release-105/fasta/homo_sapiens/cdna/Homo_sapiens.GRCh38.cdna.all.fa.gz
  gunzip -d Homo_sapiens.GRCh38.cdna.all.fa.gz
fi

Rscript generate_breakpoints.R Homo_sapiens.GRCh38.105.gtf Homo_sapiens.GRCh38.cdna.all.fa ${FASTA_NAME}
