# Reference accession numbers.
ACC=AF086833

# Create the directory for reference file.
mkdir -p refs

# The name of the reference.
REF=refs/${ACC}.fa

# The name of the BAM file
BAM=align.bam

# Obtain the reference genome.
efetch -db nuccore -format fasta -id $ACC > $REF

# Create a bwa index for the reference.
bwa index $REF

# Create a samtools index for the reference.
samtools faidx $REF

# Simulate reads from the reference file.
dwgsim $REF simulated

# This is the data naming generated by dwgsim.
R1=simulated.bwa.read1.fastq
R2=simulated.bwa.read2.fastq

#
# Generate the alignment from the data simulated above.
#
bwa mem $REF $R1 $R2 | samtools sort > $BAM

# Index the BAM file
samtools index $BAM

# Compute the genotypes from the alignment file.
bcftools mpileup -Ovu -f $REF $BAM > genotypes.vcf

# Call the variants from the genotypes.
bcftools call -vc -Ov genotypes.vcf > observed-mutations.vcf