
`ls 05.demultiplexed_results/fasta/ | sed "s/.fna//g" > list_samples.txt`
`mkdir 05.demultiplexed_results/fasta_1000bp` 
out=File.new("blastn_1000bp_80cov.txt","w")

aa=File.open("list_samples.txt").each_line do |file|
file.chomp!
temp=File.new("temp.txt","w")
puts "---- extranting reads from #{file}"
	bb=File.open("05.demultiplexed_results/blastn/blastn_#{file}.txt").each_line do |line|
	line.chomp!
#03d295a5-c53e-4042-a8fa-7a3941d110f3    tet(39)_1_KT346360      100.000 134     0       0       84      217     980     1113    1.06e-66        248     266  1122
	col=line.split("\t")
        if col[12].to_f > 1000 and 100*col[3].to_f/col[13].to_f > 80
        out.puts "#{file}\t#{line}"
        temp.puts col[0]
        end
        end
        bb.close
temp.close
`seqtk subseq 05.demultiplexed_results/fasta/#{file}.fna temp.txt > 05.demultiplexed_results/fasta_1000bp/#{file}.fna`
end
aa.close

#`for x in $(ls 05.demultiplexed_results/fasta_1000bp/ | sed "s/.fna//g"); do echo ${x}; cat 05.demultiplexed_results/fasta_1000bp/${x}.fna | sed "s/>/>${x}_/g" >> all_1000bp_reads.fna; done`

