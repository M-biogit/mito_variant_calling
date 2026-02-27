#  Mitochondrial Short Variant Discovery
##  Project Results (from vep_rep.pdf)

**652 Variants ** Idenified→ **413 PASS** (63%)

| Variant type | Number |
|-------------|--------|
| Missense | 123 |
| Synonymous | 89 |
| Stop gained | 45 |

![Results](report/vep_rep.pdf)

[![GATK Best Practices](https://img.shields.io/badge/GATK-Best%20Practices-blue.svg)](https://gatk.broadinstitute.org/hc/en-us/articles/4403870837275)

**End-to-end pipeline** To discover SNVs/Indels Mitochondria with **GATK Mutect2** + **VEP annotation**.

##  Results
| Metric | Value |
|--------|-------|
| Total Variants | **652** |
| PASS Variants | **413** (63%) |
| MT Genes Affected | **37** |
| SIFT Deleterious | 91 |
| PolyPhen Damaging | 83 |

## Quick Start
```bash
git clone https://github.com/YOUR_USERNAME/mito_variant_calling
chmod +x mito_pipeline.sh
./mito_pipeline.sh /path/to/fastq

##  Tools
| Tool | Version |
|------|---------|
| [GATK](https://gatk.broadinstitute.org) | 4.6.1.0 |
| [BWA](http://bio-bwa.sourceforge.net) | 0.7.17 |
| [VEP](https://www.ensembl.org/info/docs/tools/vep/index.html) | 113.0 |
| Samtools | 1.19.2 |

##  Report
[Full Analysis Report (PDF)](report/vep_rep.pdf)
