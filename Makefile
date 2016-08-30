################################################################
## ngseasy Makefile
## Version 1.0
## Author: Stephen Newhouse (stephen.j.newhouse@gmail.com)
################################################################
## Usage
################################################################
#
#    make all && sudo make install
#
# ...or...
#
#    make INSTALLDIR="/CUSTOM/PATH" all && sudo make install
#
################################################################

################################################################
## Edit this to reflect version if ya need
VERSION=1.0-r001
WHOAMI=$(shell whoami)
NGSUSER=$(WHOAMI)
WGETOPTS="--no-clobber"

################################################################
## This is where we will make ngs_projects and download metadata to etc etc
## Edit this if you want to install all somewhere else
# eg:
# make INSTALLDIR="/medida/scratch" all
#
INSTALLDIR=/home/$(USER)

################################################################
## Current working dir
DIR=$(shell pwd)

################################################################
## Install bin path - edit at will
## TARGET_BIN=/usr/local/bin
## changed to move bin to user folder. no need for sudo with install
TARGET_BIN=$(INSTALLDIR)

################################################################
## relative path to ngseasy scripts
SRC=./bin

################################################################
# Intsalling all or parts...
################################################################

## Basic install  no annotation data bases or manual build tools
all:	ngsprojectdir dockerimages testdata b37 hg19

## install scripts to target bin eg sudo make install

install:
	@echo "Installing ngseasy scripts to system..."
	chmod 775 $(SRC)/* && \
	mkdir $(INSTALLDIR)/bin && \
	cp -rv $(SRC)/* $(TARGET_BIN)/bin/

## fix permissions. run - sudo make NGSUSER="ec2-user" fixuser
fixuser:
	chown $(NGSUSER):$(NGSUSER) $(INSTALLDIR)

uninstall:
	rm -fv $(TARGET_BIN)/ngseasy* && rm -fv $(TARGET_BIN)/ngseasy

updatescripts:
	git pull && rm -fv $(TARGET_BIN)/ngseasy* && rm -fv $(TARGET_BIN)/ngseasy && chmod -R 775 $(SRC)/ && cp -v $(SRC)/ngseasy* $(TARGET_BIN)/

update:
	git pull

## Make Top level project directories
ngsprojectdir:
	@echo "Make Top level project directories"
	mkdir -v -p $(INSTALLDIR)/ngs_projects && \
	mkdir -v -p $(INSTALLDIR)/ngs_projects/raw_fastq && \
	mkdir -v -p $(INSTALLDIR)/ngs_projects/config_files && \
	mkdir -v -p $(INSTALLDIR)/ngs_projects/run_logs && \
	mkdir -v -p $(INSTALLDIR)/ngs_projects/ngseasy_resources && \
	mkdir -v -p $(HOME)/ngseasy_logs && \
	mkdir -v -p $(HOME)/ngseasy_tmp

purgengsprojectsdir:
	rm -rfv $(INSTALLDIR)/ngs_projects

## Get all docker images

dockerimages:
	@echo "Get all NGSeasy docker images"
	docker pull compbio/ngseasy-base:$(VERSION) && \
	docker pull compbio/ngseasy-fastqc:$(VERSION) && \
	docker pull compbio/ngseasy-trimmomatic:$(VERSION) && \
	docker pull compbio/ngseasy-snap:$(VERSION) && \
	docker pull compbio/ngseasy-bwa:$(VERSION) && \
	docker pull compbio/ngseasy-bowtie2:$(VERSION) && \
	docker pull compbio/ngseasy-stampy:$(VERSION) && \
	docker pull compbio/ngseasy-picardtools:$(VERSION) && \
	docker pull compbio/ngseasy-freebayes:$(VERSION) && \
	docker pull compbio/ngseasy-platypus:$(VERSION) && \
	docker pull compbio/ngseasy-glia:$(VERSION) && \
	docker pull compbio/ngseasy-delly:$(VERSION) && \
	docker pull compbio/ngseasy-lumpy:$(VERSION) && \
	docker pull compbio/ngseasy-bcbiovar:$(VERSION) && \
	docker pull compbio/ngseasy-cnmops:$(VERSION) && \
	docker pull compbio/ngseasy-mhmm:$(VERSION) && \
	docker pull compbio/ngseasy-exomedepth:$(VERSION) && \
	docker pull compbio/ngseasy-slope:$(VERSION)

baseimage:
	docker pull compbio/ngseasy-base:$(VERSION)

fastqc: baseimage
	docker pull compbio/ngseasy-fastqc:$(VERSION)

trimmomatic: baseimage
	docker pull compbio/ngseasy-trimmomatic:$(VERSION)

bwa: baseimage
	docker pull compbio/ngseasy-bwa:$(VERSION)

bowtie2: baseimage
	docker pull compbio/ngseasy-bowtie2:$(VERSION)

snap: baseimage
	docker pull compbio/ngseasy-snap:$(VERSION)

stampy: bwa baseimage
	docker pull compbio/ngseasy-stampy:$(VERSION)

picardtools: baseimage
	docker pull compbio/ngseasy-picardtools:$(VERSION)

freebayes: baseimage
	docker pull compbio/ngseasy-freebayes:$(VERSION)

platypus: baseimage
	docker pull compbio/ngseasy-platypus:$(VERSION)

delly: baseimage
	docker pull compbio/ngseasy-delly:$(VERSION)

lumpy: baseimage
	docker pull compbio/ngseasy-lumpy:$(VERSION)

bcbiovar:
	docker pull compbio/ngseasy-bcbiovar:$(VERSION)

cnmops: baseimage
	docker pull compbio/ngseasy-cnmops:$(VERSION)

mhmm: baseimage
	docker pull compbio/ngseasy-mhmm:$(VERSION)

exomedepth: baseimage
	docker pull compbio/ngseasy-exomedepth:$(VERSION)

slope: baseimage
	docker pull compbio/ngseasy-slope:$(VERSION)

glia: baseimage
	docker pull compbio/ngseasy-glia:$(VERSION)

# b37 Genomes indexed and resources

b37:
	@echo "Get b37 Genomes indexed and resources"
	cd $(INSTALLDIR)/ngs_projects/ngseasy_resources && \
	mkdir -p reference_genomes_b37 && \
	cd $(INSTALLDIR)/ngs_projects/ngseasy_resources/reference_genomes_b37 && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/1000G_omni2.5.b37.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/1000G_omni2.5.b37.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/1000G_phase1.indels.b37.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/1000G_phase1.indels.b37.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/1000G_phase1.snps.high_confidence.b37.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/1000G_phase1.snps.high_confidence.b37.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/CEUTrio.HiSeq.WGS.b37.NA12878.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/CEUTrio.HiSeq.WGS.b37.NA12878.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/CEUTrio.HiSeq.WGS.b37.bestPractices.b37.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/CEUTrio.HiSeq.WGS.b37.bestPractices.b37.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/Genome && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/GenomeIndex && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/GenomeIndexHash && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/LCR_hg19_rmsk.bed && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/Mills_and_1000G_gold_standard.indels.b37.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/Mills_and_1000G_gold_standard.indels.b37.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/NA12878.HiSeq.WGS.bwa.cleaned.raw.subset.b37.sites.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/NA12878.HiSeq.WGS.bwa.cleaned.raw.subset.b37.sites.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/NA12878.HiSeq.WGS.bwa.cleaned.raw.subset.b37.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/NA12878.HiSeq.WGS.bwa.cleaned.raw.subset.b37.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/NA12878.knowledgebase.snapshot.20131119.b37.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/NA12878.knowledgebase.snapshot.20131119.b37.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/OverflowTable && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/S03723314_Regions.bed && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/S06588914_Regions_trimmed.bed && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/SeqCap_EZ_Exome_v3_capture.bed && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/SeqCap_EZ_Exome_v3_primary.bed && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/b37.genome && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/contaminant_list.fa && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/dbsnp_138.b37.excluding_sites_after_129.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/dbsnp_138.b37.excluding_sites_after_129.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/dbsnp_138.b37.recab && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/dbsnp_138.b37.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/dbsnp_138.b37.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/hapmap_3.3.b37.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/hapmap_3.3.b37.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/human_g1k_v37.1.bt2 && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/human_g1k_v37.2.bt2 && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/human_g1k_v37.3.bt2 && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/human_g1k_v37.4.bt2 && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/human_g1k_v37.chrom_lengths && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/human_g1k_v37.fasta && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/human_g1k_v37.fasta.amb && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/human_g1k_v37.fasta.ann && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/human_g1k_v37.fasta.bwt && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/human_g1k_v37.fasta.fai && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/human_g1k_v37.fasta.pac && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/human_g1k_v37.fasta.sa && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/human_g1k_v37.novoindex && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/human_g1k_v37.rev.1.bt2 && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/human_g1k_v37.rev.2.bt2 && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/human_g1k_v37.sthash && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/human_g1k_v37.stidx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/human_g1k_v37_0.5Kwindows.bed && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/human_g1k_v37_1Kwindows.bed && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/nexterarapidcapture_exome_targetedregions_v1.2.bed && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/nexterarapidcapture_expandedexome_targetedregions.bed && \
	chmod -R 775 $(INSTALLDIR)/ngs_projects/ngseasy_resources/reference_genomes_b37/

# hg19 Genomes idexed and resources

hg19:
	@echo "Get hg19 Genomes indexed and resources"
	cd $(INSTALLDIR)/ngs_projects/ngseasy_resources && \
	mkdir -p reference_genomes_hg19 && \
	cd $(INSTALLDIR)/ngs_projects/ngseasy_resources/reference_genomes_hg19 && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/1000G_omni2.5.hg19.sites.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/1000G_omni2.5.hg19.sites.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/1000G_phase1.indels.hg19.sites.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/1000G_phase1.indels.hg19.sites.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/1000G_phase1.snps.high_confidence.hg19.sites.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/1000G_phase1.snps.high_confidence.hg19.sites.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/CEUTrio.HiSeq.WGS.b37.bestPractices.hg19.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/CEUTrio.HiSeq.WGS.b37.bestPractices.hg19.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/Genome && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/GenomeIndex && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/GenomeIndexHash && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf.gz && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf.gz.tbi && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/Mills_and_1000G_gold_standard.indels.hg19.sites.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/NA12878.HiSeq.WGS.bwa.cleaned.raw.subset.hg19.sites.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/NA12878.HiSeq.WGS.bwa.cleaned.raw.subset.hg19.sites.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/NA12878.HiSeq.WGS.bwa.cleaned.raw.subset.hg19.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/NA12878.HiSeq.WGS.bwa.cleaned.raw.subset.hg19.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/NA12878.knowledgebase.snapshot.20131119.hg19.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/NA12878.knowledgebase.snapshot.20131119.hg19.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/OverflowTable && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/contaminant_list.fa && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/dbsnp_138.hg19.excluding_sites_after_129.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/dbsnp_138.hg19.excluding_sites_after_129.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/dbsnp_138.hg19.recab && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/dbsnp_138.hg19.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/dbsnp_138.hg19.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/get_hg19.sh && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/get_hg19_others.sh && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/hapmap_3.3.hg19.sites.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/hapmap_3.3.hg19.sites.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/hg19.genome && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/index_bowtie.sh && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/index_bwa.sh && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/index_novo.sh && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/index_snap.sh && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/index_stampy.sh && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/ucsc.hg19-bs.umfa && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/ucsc.hg19.1.bt2 && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/ucsc.hg19.2.bt2 && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/ucsc.hg19.3.bt2 && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/ucsc.hg19.4.bt2 && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/ucsc.hg19.dict && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/ucsc.hg19.fai && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/ucsc.hg19.fasta && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/ucsc.hg19.fasta.amb && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/ucsc.hg19.fasta.ann && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/ucsc.hg19.fasta.bwt && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/ucsc.hg19.fasta.fai && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/ucsc.hg19.fasta.fai.gz && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/ucsc.hg19.fasta.gz && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/ucsc.hg19.fasta.novoindex && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/ucsc.hg19.fasta.pac && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/ucsc.hg19.fasta.sa && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/ucsc.hg19.rev.1.bt2 && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/ucsc.hg19.rev.2.bt2 && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/ucsc.hg19.sthash && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hg19/ucsc.hg19.stidx && \
	chmod -R 775 $(INSTALLDIR)/ngs_projects/ngseasy_resources/reference_genomes_hg19/

## hs37d5
hs37d5:
	@echo "Get hs37d5 Genomes indexed and resources"
	cd $(INSTALLDIR)/ngs_projects/ngseasy_resources && \
	mkdir -p reference_genomes_hs37d5 && \
	cd $(INSTALLDIR)/ngs_projects/ngseasy_resources/reference_genomes_hs37d5 && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/1000G_omni2.5.b37.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/1000G_omni2.5.b37.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/1000G_phase1.indels.b37.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/1000G_phase1.indels.b37.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/1000G_phase1.snps.high_confidence.b37.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/1000G_phase1.snps.high_confidence.b37.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/CEUTrio.HiSeq.WGS.b37.bestPractices.b37.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/CEUTrio.HiSeq.WGS.b37.bestPractices.b37.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/CEUTrio.HiSeq.WGS.b37.NA12878.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/CEUTrio.HiSeq.WGS.b37.NA12878.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/contaminant_list.fa && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/dbsnp_138.b37.excluding_sites_after_129.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/dbsnp_138.b37.excluding_sites_after_129.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/dbsnp_138.b37.recab && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/dbsnp_138.b37.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/dbsnp_138.b37.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/Genome && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/GenomeIndex && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/GenomeIndexHash && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/hapmap_3.3.b37.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/hapmap_3.3.b37.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/hs37d5.1.bt2 && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/hs37d5.2.bt2 && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/hs37d5.3.bt2 && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/hs37d5.4.bt2 && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/hs37d5.fasta && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/hs37d5.fasta.amb && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/hs37d5.fasta.ann && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/hs37d5.fasta.bwt && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/hs37d5.fasta.fai && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/hs37d5.fasta.novoindex && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/hs37d5.fasta.pac && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/hs37d5.fasta.sa && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/hs37d5.rev.1.bt2 && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/hs37d5.rev.2.bt2 && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/hs37d5.sthash && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/hs37d5.stidx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/human_g1k_v37_0.5Kwindows.bed && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/human_g1k_v37_1Kwindows.bed && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/LCR_hg19_rmsk.bed && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/Mills_and_1000G_gold_standard.indels.b37.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/Mills_and_1000G_gold_standard.indels.b37.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/NA12878.HiSeq.WGS.bwa.cleaned.raw.subset.b37.sites.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/NA12878.HiSeq.WGS.bwa.cleaned.raw.subset.b37.sites.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/NA12878.HiSeq.WGS.bwa.cleaned.raw.subset.b37.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/NA12878.HiSeq.WGS.bwa.cleaned.raw.subset.b37.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/NA12878.knowledgebase.snapshot.20131119.b37.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/NA12878.knowledgebase.snapshot.20131119.b37.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/nexterarapidcapture_exome_targetedregions_v1.2.bed && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/nexterarapidcapture_expandedexome_targetedregions.bed && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/OverflowTable && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/S03723314_Regions.bed && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/S06588914_Regions_trimmed.bed && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/SeqCap_EZ_Exome_v3_capture.bed && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_hs37d5/SeqCap_EZ_Exome_v3_primary.bed && \
	chmod -R 775 $(INSTALLDIR)/ngs_projects/ngseasy_resources/reference_genomes_hs37d5/

##  Test data and stick it in raw_fastq


testdata: ngsprojectdir
	@echo "Get Test data and stick it in raw_fastq"
	cd $(INSTALLDIR)/ngs_projects/raw_fastq && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/fastq_test_data/ && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/fastq_test_data/illumina.100bp.pe.wex.150x_1.fastq.gz && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/fastq_test_data/illumina.100bp.pe.wex.150x_2.fastq.gz && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/fastq_test_data/illumina.100bp.pe.wex.30x_1.fastq.gz && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/fastq_test_data/illumina.100bp.pe.wex.30x_2.fastq.gz && \
	chmod -R 775 $(INSTALLDIR)/ngs_projects/raw_fastq/ && \
	cd $(INSTALLDIR)/ngs_projects/config_files && \
	cp -v $(DIR)/test/ngseasy_test.config.tsv $(INSTALLDIR)/ngs_projects/config_files/ && \
	chmod -R 775 $(INSTALLDIR)/ngs_projects/config_files/
##	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/fastq_test_data/NA12878D_HiSeqX_R1.fastq.gz && \
##	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/fastq_test_data/NA12878D_HiSeqX_R2.fastq.gz && \

## Manual Builds
gatk:
	cd $(DIR)/containerized/ngs_docker_debian/ngs_variant_annotators/ngseasy_gatk && \
	docker build --rm=true compbio/ngseasy-gatk:$(VERSION) .

novoalign:
	cd $(DIR)/containerized/ngs_docker_debian/ngs_variant_annotators/ngseasy_novoalin && \
	docker build --rm=true compbio/ngseasy-novoalign:$(VERSION) .

vep:
	cd $(DIR)/containerized/ngs_docker_debian/ngs_variant_annotators/ngseasy_vep && \
	docker build --rm=true compbio/ngseasy-vep:$(VERSION) .

snpeff:
	cd $(DIR)/containerized/ngs_docker_debian/ngs_variant_annotators/ngseasy_snpeff && \
	docker build --rm=true compbio/ngseasy-snpeff:$(VERSION) .

annovar:
	cd $(DIR)/containerized/ngs_docker_debian/ngs_variant_annotators/ngseasy_annovar && \
	docker build --rm=true compbio/ngseasy-annovar:$(VERSION) .

annovardb:
	docker run \
	--volume $(INSTALLDIR)/ngs_projects/annovardb/:/home/annovardb \
	--name get_annovardb \
	--rm=true \
	-i -t compbio/ngseasy-annovar:$(VERSION) \
	 /bin/bash -c \
	"/bin/bash /usr/local/pipeline/annovar/get_annovar_gene_databases.sh && \bin/bash /usr/local/pipeline/annovar/get_annovar_databases.sh"

## Cleanups
clean:
	rm -f -v $(TARGET_BIN)/ngseas* && \
	rm -f -v $(TARGET_BIN)/ensembl****yaml

purgeall:
	rm -f -v $(TARGET_BIN)/ngseas* && \
	rm -f -v $(TARGET_BIN)/ensembl****yaml && \
	docker kill \$(shell docker ps -a | awk '(print $$1)') && \
	docker rm -f \$(shell docker ps -a | awk '(print $$1)') && \
	docker rmi -f \$(shell docker images -a |  grep compbio | awk '(print $$3)')

purgegenomes:
	rm -rfv $(INSTALLDIR)/ngs_resources/reference_genomes_b37 && \
	rm -rfv $(INSTALLDIR)/ngs_resources/reference_genomes_hg19

############################################################################
## bwa only b37 resources
bwab37indexes: ngsprojectdir
	@echo "Getting bwa b37 resources"
	cd $(INSTALLDIR)/ngs_resources/reference_genomes_b37 && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/1000G_omni2.5.b37.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/1000G_omni2.5.b37.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/1000G_phase1.indels.b37.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/1000G_phase1.indels.b37.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/1000G_phase1.snps.high_confidence.b37.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/1000G_phase1.snps.high_confidence.b37.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/CEUTrio.HiSeq.WGS.b37.NA12878.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/CEUTrio.HiSeq.WGS.b37.NA12878.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/CEUTrio.HiSeq.WGS.b37.bestPractices.b37.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/CEUTrio.HiSeq.WGS.b37.bestPractices.b37.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/Mills_and_1000G_gold_standard.indels.b37.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/Mills_and_1000G_gold_standard.indels.b37.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/NA12878.HiSeq.WGS.bwa.cleaned.raw.subset.b37.sites.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/NA12878.HiSeq.WGS.bwa.cleaned.raw.subset.b37.sites.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/NA12878.HiSeq.WGS.bwa.cleaned.raw.subset.b37.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/NA12878.HiSeq.WGS.bwa.cleaned.raw.subset.b37.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/NA12878.knowledgebase.snapshot.20131119.b37.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/NA12878.knowledgebase.snapshot.20131119.b37.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/contaminant_list.fa && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/dbsnp_138.b37.excluding_sites_after_129.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/dbsnp_138.b37.excluding_sites_after_129.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/dbsnp_138.b37.recab && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/dbsnp_138.b37.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/dbsnp_138.b37.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/hapmap_3.3.b37.vcf && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/hapmap_3.3.b37.vcf.idx && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/human_g1k_v37.chrom_lengths && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/human_g1k_v37.fasta && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/human_g1k_v37.fasta.amb && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/human_g1k_v37.fasta.ann && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/human_g1k_v37.fasta.bwt && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/human_g1k_v37.fasta.fai && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/human_g1k_v37.fasta.pac && \
	wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/human_g1k_v37.fasta.sa && \
	chmod -R 775 $(INSTALLDIR)/ngs_projects/ngseasy_resources/reference_genomes_b37/

############################################################################
## novoalign only b37 resources
novoalignb37indexes: ngsprojectdir
		@echo "Getting novoalign b37 resources"
		cd $(INSTALLDIR)/ngs_resources/reference_genomes_b37 && \
		wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/1000G_omni2.5.b37.vcf && \
		wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/1000G_omni2.5.b37.vcf.idx && \
		wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/1000G_phase1.indels.b37.vcf && \
		wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/1000G_phase1.indels.b37.vcf.idx && \
		wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/1000G_phase1.snps.high_confidence.b37.vcf && \
		wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/1000G_phase1.snps.high_confidence.b37.vcf.idx && \
		wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/CEUTrio.HiSeq.WGS.b37.NA12878.vcf && \
		wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/CEUTrio.HiSeq.WGS.b37.NA12878.vcf.idx && \
		wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/CEUTrio.HiSeq.WGS.b37.bestPractices.b37.vcf && \
		wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/CEUTrio.HiSeq.WGS.b37.bestPractices.b37.vcf.idx && \
		wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/Mills_and_1000G_gold_standard.indels.b37.vcf && \
		wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/Mills_and_1000G_gold_standard.indels.b37.vcf.idx && \
		wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/NA12878.HiSeq.WGS.bwa.cleaned.raw.subset.b37.sites.vcf && \
		wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/NA12878.HiSeq.WGS.bwa.cleaned.raw.subset.b37.sites.vcf.idx && \
		wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/NA12878.HiSeq.WGS.bwa.cleaned.raw.subset.b37.vcf && \
		wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/NA12878.HiSeq.WGS.bwa.cleaned.raw.subset.b37.vcf.idx && \
		wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/NA12878.knowledgebase.snapshot.20131119.b37.vcf && \
		wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/NA12878.knowledgebase.snapshot.20131119.b37.vcf.idx && \
		wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/contaminant_list.fa && \
		wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/dbsnp_138.b37.excluding_sites_after_129.vcf && \
		wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/dbsnp_138.b37.excluding_sites_after_129.vcf.idx && \
		wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/dbsnp_138.b37.recab && \
		wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/dbsnp_138.b37.vcf && \
		wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/dbsnp_138.b37.vcf.idx && \
		wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/hapmap_3.3.b37.vcf && \
		wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/hapmap_3.3.b37.vcf.idx && \
		wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/human_g1k_v37.chrom_lengths && \
		wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/human_g1k_v37.fasta && \
		wget $(WGETOPTS) https://s3-eu-west-1.amazonaws.com/ngseasy.data/reference_genomes_b37/human_g1k_v37.novoindex && \
		chmod -R 775 $(INSTALLDIR)/ngs_projects/ngseasy_resources/reference_genomes_b37/

############################################################################
## Make sep chroms
#chrb37:
#	cd $(INSTALLDIR)/ngs_projects/reference_genomes_b37 && \
#	mkdir chroms && \
#	cd chroms && \
#	awk 'BEGIN { CHROM="" } { if ($$1~"^>") CHROM=substr($$1,2); print $$0 > CHROM".fasta" }' ${INSTALLDIR}/ngs_projects/reference_genomes_b37/human_g1k_v37.fasta

#chrhg19:
#	cd $(INSTALLDIR)/ngs_projects/reference_genomes_hg19 && \
#	mkdir chroms && \
#	cd chroms && \
#	awk 'BEGIN { CHROM="" } { if ($$1~"^>") CHROM=substr($$1,2); print $$0 > CHROM".fasta" }' ${INSTALLDIR}/ngs_projects/reference_genomes_hg19/ucsc.hg19.fasta
