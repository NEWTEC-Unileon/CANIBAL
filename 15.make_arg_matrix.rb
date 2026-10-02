
if ARGV[0]==nil
puts ""
puts ".........................................................................."
puts "... Sorry! you forgot to add the folder name which contains blastn files ..."
puts "...          try again adding this information, please                 ..."
puts ".........................................................................."
puts ""
exit
elsif ARGV[0]=~/\//
`ls "#{ARGV[0]}"* > list_arg.txt`
else 
`ls "#{ARGV[0]}"/* > list_arg.txt`
end

l=''
l << `wc -l list_arg.txt`
l=l.split("\s")[0]
m=0

sample=''

hfam={}
genes=[]
hgenes={}
hgen={}
gg=File.open("gene_list.txt").each_line do |line|
line.chomp!
#Beta-lactam     blaOXA-161_1_GQ202693
cols=line.split("\t")
hfam[cols[1]]=cols[0]
hgen[cols[1]]=cols[1].split("_")[0]
genes << cols[1]
end
gg.close

puts hgen

samples=[]
hsamples={}
ll=File.open("list_arg.txt").each_line do |line|
line.chomp!
if line =~ /\/blastn_(.*)\.txt/
samples << $1
end
end
ll.close

#puts samples
#puts genes.length()
#genes=genes.uniq
#puts genes.length()
genes.each_index{|a| hgenes[genes[a]]=a}
samples.each_index{|b| hsamples[samples[b]]=b}
matrix=Array.new(genes.length()){|i| Array.new(samples.length()) {|x| 0}}

#puts samples
gene=''
aa=File.open("list_arg.txt").each_line do |file|
file.chomp!
if file =~ /\/blastn_(.*)\.txt/
sample=$1
m+=1
#puts m
#puts sample
end
puts "...processing sample #{sample} (#{m}/#{l})"
        bb=File.open("#{file}").each_line do |line|
 	line.chomp!
	cols=line.split("\t")
	gene=cols[1]
#	if cols[3].to_i > 100 and cols[11].to_i > 200 #at least 100bp aligned and bit-score > 200
#        if cols[12].to_f > 1000 and 100*cols[3].to_f/cols[13].to_f > 80
#puts "#{sample}\t#{gene}"
#puts hgenes[gene]
#puts sample
	matrix[hgenes[gene]][hsamples[sample]]+=1
#	end
   end
   bb.close
end
aa.close

matfile=File.new("matrix_ResFinder.txt","w")


mm=-1
matfile.print "Antibiotic_Family\tGene\tHit"
samples.each {|i| matfile.print "\t#{i}"}
matfile.print "\n"
matrix.each {|i| mm+=1
matfile.print "#{hfam[genes[mm]]}\t#{hgen[genes[mm]]}\t#{genes[mm]}"
i.each {|x| matfile.print "\t#{x}"}
matfile.print "\n"}



