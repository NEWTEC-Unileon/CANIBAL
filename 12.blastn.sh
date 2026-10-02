mkdir -p 03.blastn_resfinder
for x in $(ls 02.reads_fasta | cut -f 1 -d "."); do echo ".... runing blastn on sample ${x}"; 
blastn -db /datos/DATABASES/ResFinder_20250402/resfinder20250402 -perc_identity 80 -query 02.reads_fasta/${x}.fna -out 03.blastn_resfinder/${x}.txt -outfmt '6 std qlen slen' -max_target_seqs 1 -culling_limit 1 -num_threads 16; done
