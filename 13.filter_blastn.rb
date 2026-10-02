
`mkdir -p 04.blastn_filtered`
`mkdir -p 04.ARG_fasta`
`ls 03.blastn_resfinder | cut -f 1 -d "." > list.txt`
#03.blastn_resfinder/*.txt
#02.reads_fasta/*.fna

n=''
m=''
t=''
aa=File.open("list.txt").each_line do |file|
file.chomp!
sample=file#.split("\.")[0]
#d645c6c2-2243-4495-9b6d-a205cfb8478b   qnrB19_1_EU432277       92.496  653     29      16      228     868     1       645     0.0     917     1098    645
n=0
m=0
temp=File.new("temp.txt","w")
out=File.new("04.blastn_filtered/#{file}.txt","w")
puts file
	bb=File.open("03.blastn_resfinder/#{file}.txt").each_line do |line|
	line.chomp!
#	m+=1
	col=line.split("\t")
#ver que columna ocupa e  longitud de la secuencia objeto (qlength) y la longitud del alineamiento (length) y dividir length entre qlentgh OJO empezar a contar en col 0
#	puts col[13].to_f/col[3].to_f
#	if col[3].to_f > 50 and 100*col[3].to_f/col[13].to_f > 80
	#if 100*col[3].to_f/col[13].to_f > 80
	if col[3].to_f>100
	out.puts line
	temp.puts col[0]
#	n+=1
	end
	end
	bb.close
temp.close
out.close
`seqtk subseq 02.reads_fasta/#{file}.fna temp.txt > 04.ARG_fasta/#{file}.fna`
puts sample
#puts n
#t=n.to_f*100/m.to_f
#puts t
end
aa.close
