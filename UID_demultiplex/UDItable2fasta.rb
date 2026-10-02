
aa=File.open("UDI_codes_v2.txt").each_line do |line|
line.chomp!
#        i5 Index        i5 Index        i7 Index
#UDI001  CGACCATT        AATGGTCG        GCCTATCA
if line =~ /^UDI/
col=line.split("\t")
puts ">#{col[0]}A"
puts "\^#{col[1]}"
puts ">#{col[0]}B"
puts "^#{col[2]}"
puts ">#{col[0]}C"
puts "^#{col[3]}"
=begin
puts ">#{col[0]}A1"
puts "TATACTTACAC#{col[1]}"
puts ">#{col[0]}B1"
puts "TATACTTACAC#{col[2]}"
puts ">#{col[0]}C1"
puts "TATACTTACAC#{col[3]}"
puts ">#{col[0]}A2"
puts "ACGGCATACGAGAT#{col[1]}"
puts ">#{col[0]}B2"
puts "ACGGCATACGAGAT#{col[2]}"
puts ">#{col[0]}C2"
puts "ACGGCATACGAGAT#{col[3]}"
=end
end
end
aa.close

