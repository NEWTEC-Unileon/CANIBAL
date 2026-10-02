
#`source /home/josecobo/miniconda3/etc/profile.d/conda.sh`
#conda activate gridion
folder=''

if ARGV[0]==nil
puts "\n---- You forgot to indicate the raw-reads folder!!!\n\n"
exit
end
if Dir.exist?("#{ARGV[0]}")==false
puts "\n---- The folder #{ARGV[0]} does not exists\n\n"
exit
else
folder=ARGV[0].gsub("/","")
puts "\n---- The folder #{folder} has been found\n\n"
end

if File.exists?('sample_info.txt')==false
puts "\n---- The file 'sample_info.txt' is missed\n\n"
exit
end

`cut -f 1,2 sample_info.txt | uniq > sample_info_flowcells.txt`
`mkdir -p 01.porechop_reads`
sample=''
aa=File.open("sample_info_flowcells.txt").each_line do |file|
file.chomp!
#N01	barcode01	sample01
col=file.split("\t")
#path="#{folder}/#{col[0]}/#{col[1]}/"
path="#{folder}/#{col[0]}/fastq_pass/#{col[1]}/"
`ls #{path} > temp.txt`
`mkdir 01.porechop_reads/#{col[0]}_#{col[1]}`
`parallel -j 8 -a temp.txt porechop -i #{path}/{} -o 01.porechop_reads/#{col[0]}_#{col[1]}/{} --threads 16`
end
aa.close
