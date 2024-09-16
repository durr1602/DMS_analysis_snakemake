# Snakemake workflow: configuration

## Technical configuration

The main file containing config parameters to actually run the snakemake pipeline is [here](config.v8+.yaml). Theoretically, this file does not need to be modified too much, and flags added to the snakemake command line will supersede the default values specified in the file.

## Project-specific files

A few files should be provided to properly analyze your data.

### Sequencing data

Please provide the raw reads (forward and reverse) of your DMS sequencing data in the `resources/reads` folder. The file names should be featured in the layout (see section below).

### Layout

Please provide a csv-formatted layout of your samples. The file should be named `layout.csv` and be located in the `config/project_files` folder. Here is [an example](project_files/layout.csv). The file should contain the following columns:
- Sample_name: the unique identifier for each of your samples. The sample name does not need to contain information about the timepoint or replicate, since these correspond to other columns
- R1_file: base name of the fastq file for forward (R1) reads (can be gzipped), including extension
- R2_file: base name of the fastq file for reverse (R2) reads (can be gzipped), including extension
- N_forward: the 5'-3' DNA sequence corresponding to the fixed region upstream of the mutated sequence
- N_reverse: the 5'-3' DNA sequence corresponding to the fixed region 5' of the mutated sequence on the reverse strand
- Pos_start: starting position in the protein sequence. If you've mutated several regions/fragments in a coding gene, this position should refer to the full-length protein sequence
- Mutated_seq: the unique identifier for the mutated DNA sequence, should be the same for all samples in which the same sequence was mutated
- Replicate: e.g. "R1"
- Timepoint: "T0", "T1", etc. Intermediate timepoints are optional.

Finally, additional columns should be added by the user to specify what makes this sample unique. These are referred to as "sample attributes" and could correspond to the genetic background, the fragment/region of the gene if it applies, the drug used for selection, etc. In summary, a "sample" is any unique combination of sample attributes + Replicate + Timepoint and should be associated to 2 fastq files, for the forward and reverse reads, respectively. Sample attributes = attributes related to Mutated_seq + optional attributes.

### WT DNA sequences

Please provide a tsv-formatted list of WT DNA sequences. The file should be named `wt_seq.tsv` and be located in the `config/project_files` folder. Here is [an example](project_files/wt_seq.tsv). The file should contain **exactly** the two following columns:
- Mutated_seq: all possible values for the Mutated_seq flag from the layout
- WT_seq: corresponding WT DNA sequence

### Number of mitotic generations

Please provide an excel file containing the number of mitotic generations. The file should be named `nbgen.xlsx` and be located in the `config/project_files` folder. Here is [an example](project_files/nbgen.xlsx). The file should contain **exactly** the following columns: one for each of your sample attributes + Replicate + Timepoint and finally "Nb_gen" that will contain the number of mitotic generations.

### Codon table

To prevent any typing mistake, the genetic code is imported from a [CoCoPUTs](https://dnahive.fda.gov/dna.cgi?cmd=codon_usage&id=537&mode=cocoputs) table (which also features codon frequencies, although the workflow does not make use of this). [The one provided](project_files/ScerevisiaeTAXID559292_Cocoputs_codon_table.csv) corresponds to *Saccharomyces cerevisiae* TAXID 559292. Please edit the [Snakefile](../workflow/Snakefile) if you ever need to specify a different genetic code.