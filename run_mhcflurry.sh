
mhcflurry-downloads fetch

mhcflurry-predict-scan peptide_fragments.fa \
	--alleles H-2-DB H-2-KD \
	--threshold-affinity 100 \
	--peptide-lengths 8-11 \
	--backend tensorflow-cpu \
	--out mhcflurry_predictions.csv
