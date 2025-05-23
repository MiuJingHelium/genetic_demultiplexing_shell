import sys
# I modified the script a bit to recieve command line args
stage_dir = sys.argv[1]
bulk_vcf = stage_dir + 'souporcell_merged_sorted_vcf.vcf'
out_vcf = stage_dir + 'only_unique_snp.vcf'

intersect_file='souporcell/only_unique_snp.tsv'
list_chr_pos = list()
with open(intersect_file) as f:
    for line in f:
        subline = line.split('\t')[0:2]
        subline[1] = subline[1].replace('\n','')
        list_chr_pos.append(subline)


outF = open(out_vcf , 'w')
with open(bulk_vcf) as f:
    for line in f:
        chr_pos = line.split('\t')[0:2]
        if chr_pos in list_chr_pos:
            outF.write(line)
outF.close()
