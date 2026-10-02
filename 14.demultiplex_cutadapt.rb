
#UID_demultiplex
#adapter1.fasta
#adapter2.fasta
#UDIcodes_2ndround.fasta
#UDIcodes.fasta

`ls 04.ARG_fasta/ | sed "s/.fna//g"> list.txt`
`mkdir -p 05.demultiplexed`
`mkdir -p 05.demultiplexed_results`
`mkdir -p 05.demultiplexed_results/fasta`
`mkdir -p 05.demultiplexed_results/list`
`mkdir -p 05.demultiplexed_results/blastn`


puts "----> Remember and check that UDIs have 3 digits (i.e. UDI089 instead of UDI89"

if ARGV[0]==nil
puts
puts "---> You need to indicate the flowcell-barcode-sample-UID file"
puts 
exit
end

#mainfile=ARGV[0]
flowcell=''
barcode=''
sample=''
uid=''
hsample={}
=begin
aa=File.open(ARGV[0]).each_line do |line|
line.chomp!
col=line.split("\t")
hsample["#{col[0]}_#{col[1]}_#{col[3]}"]=col[2]
end
puts hsample
=end

uidlist=[]
bb=File.open("list.txt").each_line do |file|
file.chomp!
##N02_barcode04.fna
puts file
if file =~ /^(N\d\d)\_(barcode\d\d)/
flowcell=$1
barcode=$2
uidlist=[]
hsample={}
	cc=File.open(ARGV[0]).each_line do |line|	#sample_info.txt
	line.chomp!
	#N01     barcode01       I001    UDI073
	col=line.split("\t")
	if col[0]==flowcell and col[1]==barcode
	uidlist << col[3]
	hsample[col[3]]=col[2]
	end
	end
	cc.close
puts uidlist
puts hsample
end

puts "... runing cutadapt for demultiplexing in #{file}"
`cutadapt -j 64 -g file:UID_demultiplex/adapter1.fasta --rc -e 0.2 --action trim -o 05.demultiplexed/temp_{name}.fasta 04.ARG_fasta/#{file}.fna`
#`cutadapt -j 64 -g file:UID_demultiplex/adapter1.fasta --rc -e 0.3 --action trim -o 05.demultiplexed/temp_{name}.fasta 04.ARG_fasta/#{file}.fna`
`cat 05.demultiplexed/temp_* > 05.demultiplexed/clean1.fasta`
`rm 05.demultiplexed/temp_*`
`cutadapt -j 64 -g file:UID_demultiplex/UDIcodes.fasta --rc -e 0.2  --action trim -o 05.demultiplexed/{name}.fasta 05.demultiplexed/clean1.fasta`
#`cutadapt -j 64 -g file:UID_demultiplex/UDIcodes.fasta --rc -e 0.3  --action trim -o 05.demultiplexed/{name}.fasta 05.demultiplexed/clean1.fasta`
# the A.fasta termination is to put together the A, B and C variants of the UDI code
`for x in $(ls 05.demultiplexed/*A.fasta | sed "s/A.fasta//g" | cut -f 2 -d "/"); do echo ${x}; cat 05.demultiplexed/${x}* > 05.demultiplexed/merged_${x}.fna; done`
`rm 05.demultiplexed/*fasta`

	for x in uidlist
	puts "... moving #{x} into 05.demultiplexed_results/#{hsample[x]}"
	`mv 05.demultiplexed/merged_#{x}.fna 05.demultiplexed_results/fasta/#{hsample[x]}.fna`
	`grep ">" 05.demultiplexed_results/fasta/#{hsample[x]}.fna | sed "s/>//g" | cut -f 1 -d " "  > 05.demultiplexed_results/list/list_#{hsample[x]}.txt`
puts flowcell
puts barcode
	`grep -f 05.demultiplexed_results/list/list_#{hsample[x]}.txt 04.blastn_filtered/#{flowcell}_#{barcode}.txt > 05.demultiplexed_results/blastn/blastn_#{hsample[x]}.txt`
	end
end
bb.close
