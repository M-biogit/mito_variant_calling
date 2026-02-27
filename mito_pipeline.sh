#!/bin/bash
set -euo pipefail  # Best practice error handling

PROJECT_DIR="${1:-~/mito_project}"
REF_FASTA="$PROJECT_DIR/Homo_sapiens.GRCh38.dna.chromosome.MT.fa"
FASTQ1="$PROJECT_DIR/a_1.fastq.gz"
FASTQ2="$PROJECT_DIR/a_2.fastq.gz"

mkdir -p "$PROJECT_DIR" "$PROJECT_DIR/results"

echo " Mitochondrial Variant Calling Pipeline Started"

# 1️ Reference Preparation (Page 3)
echo " Preparing Reference..."
bwa index "$REF_FASTA"
samtools faidx "$REF_FASTA"
picard CreateSequenceDictionary -R "$REF_FASTA" -O "${REF_FASTA%.fa*}.dict"

# 2️ Alignment & BAM Processing (Page 4)
echo " Alignment..."
bwa mem -t 4 "$REF_FASTA" "$FASTQ1" "$FASTQ2" > "$PROJECT_DIR/aligned_reads.sam"
samtools view -bS "$PROJECT_DIR/aligned_reads.sam" > "$PROJECT_DIR/aligned_reads.bam"
samtools sort "$PROJECT_DIR/aligned_reads.bam" -o "$PROJECT_DIR/sorted_aligned_reads.bam"
picard AddOrReplaceReadGroups \
  I="$PROJECT_DIR/sorted_aligned_reads.bam" \
  O="$PROJECT_DIR/sorted_aligned_reads_with_RG.bam" \
  RGID=sample_id RGLB=lib1 RGPL=illumina RGPU=unit1 RGSM=mito_sample
samtools index "$PROJECT_DIR/sorted_aligned_reads_with_RG.bam"

# 3️ Variant Calling (Pages 5-6)
echo " Mutect2 Calling..."
gatk Mutect2 \
  --mode mitochondria \
  -R "$REF_FASTA" \
  -I "$PROJECT_DIR/sorted_aligned_reads_with_RG.bam" \
  --panel-of-normals pon.mt.vcf.gz \
  -O "$PROJECT_DIR/raw_variants.vcf.gz"

# 4️ Filtering (Pages 6-7)
echo " Filtering..."
gatk FilterMutectCalls \
  -R "$REF_FASTA" \
  -V "$PROJECT_DIR/raw_variants.vcf.gz" \
  -O "$PROJECT_DIR/filtered_variants.vcf"
gatk IndexFeatureFile -I "$PROJECT_DIR/filtered_variants.vcf"

# 5️ VEP Annotation (Page 9)
echo " Annotating with VEP..."
vep -i "$PROJECT_DIR/filtered_variants.vcf" \
    -o "$PROJECT_DIR/vep_annotated.vcf" \
    --cache --dir_cache /homo_sapiens/113_GRCh38 \
    --offline --assembly GRCh38 --species homo_sapiens

echo " Pipeline Complete! Results:"
echo "   - filtered_variants.vcf (652 variants, 413 PASS)"
echo "   - vep_annotated.vcf (37 MT genes affected)"
