# Overview of pre-processing steps for CLAWS and USAS taggers

The following three pre-processing steps were taken to prepare the CLiC output for tagging with the CLAWS and USAS taggers. 

1. Add spaces around hyphens 

The USAS tagger does not understand double hyphens (dashes) in the middle of words - or rather combines them as a single token. So we added spaces around double hyphens following this procedure (using TextWrangler):

* Find double hyphens (dashes) attached to the beginning of a word, replace with space after the double hyphen

find: --(?=\w)
replace with: --SPACE

* Find double hyphens (dashes) attached to the end of a word, replace with space before the double hyphen

find: (?<=\w)--
replace with: SPACE--


2. Replace special characters with Perl

Special characters were replaced according to the [CLAWS Input / Output Format Guidelines](http://ucrel.lancs.ac.uk/claws/format.html). For the newer CLiC corpora, ChiLit and AAW, all special characters were replaced according to [this Perl script](perl-script_ChiLit_AAW.pl). The older CLiC corpora, 19C and DNov, of CLiC v2.0.3, as of corpus version 2a3a120 contain "&amp", therefore "&" was not replaced, but [this Perl script](perl-script_DNov_19C.pl) was used.


3. Wrap files with <text></text> 

Files were wrapped with <text></text> to comply with the [CLAWS Input / Output Format Guidelines](http://ucrel.lancs.ac.uk/claws/format.html), following these steps on a terminal:

 * Loop through files to add <text> to the beginning of the files:

FILES="./*/*/*"

for f in $FILES
do
    echo '<text>' | cat - $f > temp && mv temp $f
done

* Loop through files to add </text> to the end of the files:

FILES="./*/*/*"

for f in $FILES
do
    echo "</text>" >> $f
done

[This procedure was adapted from https://stackoverflow.com/a/16266394 and https://askubuntu.com/questions/21555/command-to-append-line-to-a-text-file-without-opening-an-editor]