
mkdir -p 02.reads_fasta
for i in $(ls 01.porechop_reads/); do echo "....merging into fasta the ${i} folder"; 
for x in $(ls 01.porechop_reads/${i}/); do seqtk seq -a 01.porechop_reads/${i}/${x} | cut -f 1 -d " " >> 02.reads_fasta/${i}.fna; done; done
