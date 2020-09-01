This directory provides data and code that has fed into a chapter for the proceedings volume of the ["Phraseology and Stylistics of Literary Language" conference](https://www.romanistik.phil.fau.de/tagung-phraseorom-call-for-papers-eng/) (Friedrich Alexander-Universität, Erlangen-Nürnberg, Erlangen, 13 – 15 March 2019). The conference was organised as part of the Franco-German ANR-DFG research project ["PhraseoRom"](https://phraseorom.univ-grenoble-alpes.fr/). 

The notes below provide some guidance for the files and subdirectories in this repository:

# Corpora

We processed all the coherently sampled corpora from the [CLiC web app](https://clic.bham.ac.uk/), version 2.0.3 (DNov – Dickens's Novels, 19C – 19th Century Reference Corpus, ChiLit – 19th Century Children's Literature Corpus and AAW – African American Writers 1892-1912 Corpus). Although the AAW corpus was initially retrieved and tagged along with the others, it was not included in the actual analysis of the study, because it was not relevant for the research question that was concerned with patterns of eye language in 19th-century British fiction.


## Retrieval of data from CLiC

The API retrieval was carried out by Mike Allaway (University of Birmingham Research Software Group) with [this API client script](clic-api-client.py). Data was retrieved from the following subsets of the corpora (see above for the overview of corpora): 'quote' (text within quotation marks), 'nonquote' (text outside quotation marks), 'longsus' (long suspensions) and 'shortsus' (short suspensions). The 'shortsus' subset was retrieved for completeness, but was not included in the analysis for this paper (because the text in short suspensions is generally too short for eye language).


## Pre-processing for the CLAWS and USAS taggers

These raw texts retrieved from CLiC have then been pre-processed in preparation for the CLAWS and USAS taggers; see the [overview of the processing steps](pre-processing.md). The current [api-output directory](api-output) shows the files after simple pre-processing. 


## Semantic tagging with the CLAWS and USAS taggers

The files were tagged with the (unversioned) CLAWS POS tagger and USAS semantic tagger, which Paul Rayson (Lancaster University) kindly provided to Viola Wiegand on 21 December 2017. The taggers are not publicly available, so we cannot share them here, but you can test the taggers on small files via the [CLAWS](http://ucrel.lancs.ac.uk/claws/) and [USAS](http://ucrel.lancs.ac.uk/usas/) websites and tag larger files via Rayson's [Wmatrix](http://ucrel.lancs.ac.uk/wmatrix/) tool or contacting Paul Rayson for offline tagging services. The tagging was carried out by James Carpenter (University of Birmingham Research Software Group). 

The [sem-tagging directory](sem-tagging/) contains the [README](sem-tagging/README.md) for the tagging procedure along with other required files for tagging via the University of Birmingham's BlueBEAR system. The sem-tagged files (ending in .sem) can be found in the [api-output-sem-tagged/](api-output-sem-tagged/) directory. To save space, the intermediate files (ending in .c7, .c7.errors, .c7.supp) are not committed. 


## Creation of corp_text objects 

In a final step before the analysis, the semantically tagged files were converted to the .rds "corp_text" format that is required by the CorporaCoCo package. The code for this conversion is given in [corp_text_objects.Rmd](corp_text_objects.Rmd). The corp_text objects are stored in the [api-output-sem-tagged](api-output-sem-tagged) directory, arranged by corpus and corpus subset (see the files ending in `_corp_text_objects`).


# Results

For the collocation comparison, we used [CorporaCoCo (v1.2-0-beta.0)](https://github.com/birmingham-ccr/CorporaCoCo/releases/tag/v1.2-0-beta.0). The code and results of the CorporaCoCo comparison are arranged by corpus and comparison (quotes vs. non-quotes and quotes vs. long suspensions) in the top level of this directory. The analysis was run with the .Rmd files. The results are available from the .md files that are linked below.

1. DNov
  * [DNov quotes vs. non-quotes](DNov_quotes_non-quotes.md)
  * [DNov quotes vs. long suspensions](DNov_quotes_long_sus.md)

2. 19C
  * [19C quotes vs. non-quotes](19C_quotes_non-quotes.md)
  * [19C quotes vs. long suspensions](19C_quotes_long_sus.md)
  
3. ChiLit
  * [ChiLit quotes vs. non-quotes](ChiLit_quotes_non-quotes.md)
  * [ChiLit quotes vs. long suspensions](ChiLit_quotes_long_sus.md)

4. AAW (not analysed in the study)
  * [AAW quotes vs. non-quotes](AAW_quotes_non-quotes.md)
  * [AAW quotes vs. long suspensions](AAW_quotes_long_sus.md)


# Acknowledgments

We thank Paul Rayson of the UCREL team at Lancaster for providing offline versions of the USAS and CLAWS taggers, and Mike Allaway and James Carpenter from the Research Software Group, part of Advanced Research Computing at the University of Birmingham, for their assistance with the data retrieval and processing. See https://www.birmingham.ac.uk/bear-software for more details on the Research Software Group.
