#!/usr/bin/perl
  
use warnings;
use strict;

use utf8;
use Text::Unidecode qw(unidecode);

use File::Find;
use File::Slurper qw/read_text write_text/;
use File::Spec;

my $indir = "./api-output/ChiLit"; #Change for ChiLit/AAW [corpus-by-corpus treatment because 19C and DNov already contain &amp in CLiC 2.0.3]

# see http://ucrel.lancs.ac.uk/claws/format.html

our( %special ) = qw(
    £   &pound;
    &   &amp;
    <   &lt;
    >   &gt;
    [   &lsqb;
    ]   &rsqb;
    `   &bquo;
);

sub text_to_sudo_ascii {
    # we we have been chdir()ed to the dir
    my $filename = $_;
    return 1 if (-d $filename);
    return 1 unless ( $filename =~ m/\.txt$/ );

    my $text = read_text($filename);

    $text =~ s/([£&<>\[\]`])/$special{$1}/g;
    # everything else
    $text = unidecode($text);

    write_text(File::Spec->catfile($filename), $text) ;
}

find(\&text_to_sudo_ascii, $indir);