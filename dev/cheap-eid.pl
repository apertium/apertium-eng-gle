#!/usr/bin/perl

use warnings;
use strict;
use utf8;
use Data::Dumper;
use Storable 'dclone';

binmode STDIN, ":utf8";
binmode STDOUT, ":utf8";

my %posmap = (
    'a.' => 'adj',
    's.' => 'n',
    'Pr.n.' => 'np',
    'int.' => 'ij',
    'adv.' => 'adv',
    'v.i.' => 'vblex',
    'v.tr.' => 'vblex',
);

my $header =<<__END__;
<?xml version="1.0" encoding="UTF-8"?>
<dictionary>
  <alphabet></alphabet>
  <sdefs>
    <sdef n="n"/>
    <sdef n="np"/>
    <sdef n="m"/>
    <sdef n="f"/>
    <sdef n="sg"/>
    <sdef n="pl"/>
    <sdef n="adj"/>
    <sdef n="adv"/>
    <sdef n="vblex"/>
    <sdef n="ij"/>
  </sdefs>
  <section id="main" type="standard">
__END__

print $header;

while(<>) {
    if(m!<entry><title xml:space="preserve"><src>([^<]*)</src>, <label>([^<]*)</label> +<trg>([^<]*)</trg>\.</title></entry>!) {
        doentry({'src' => $1, 'pos' => $2, 'trg' => $3});
    } elsif(m!<entry><title xml:space="preserve"><src>([^<]*)</src>, <label>([^<]*)</label> +<trg>([^<]*)<label>([mf])</label></trg>\.</title></entry>!) {
        doentry({'src' => $1, 'pos' => $2, 'trg' => $3, 'gen' => $4});
    } elsif(m!<entry><title xml:space="preserve"><src>([^<]*)</src>, <label>([^<]*)</label> +<label>([^<]*)</label>:? +<trg>([^<]*)</trg>\.</title></entry>!) {
        doentry({'src' => $1, 'pos' => $2, 'trg' => $4, 'label' => $3});
    } else {
#        print FILTERED $_;
    }
}

print "  </section>\n";
print "</dictionary>\n";

sub doentry {
    my $item = shift;

    $$item{'trg'} =~ s/^\([^)]*\) ?//;
    $$item{'trg'} =~ s/ ?\([^)]*\)$//;
    $$item{'trg'} =~ s/ ?\([^)]*\)$//;
    $$item{'trg'} =~ s/ *$//;

    for my $pos (split(/(?: ?&amp; ?|, ?)/, $$item{'pos'})) {
        my $single = dclone $item;
        $$single{'pos'} = $pos;
        # skip verbs with a comma or parens
        next if($posmap{$pos} eq 'vblex' && ($$item{'trg'} =~ /[,)]/));
        my $first = 1;
        for my $trg (split(/, ?/, $$item{'trg'})) {
            $$single{'first'} = $first;
            $$single{'trg'} = $trg;
            writeentry($single);
            if($first == 1) {
                $first = 0;
            }
        }
    }
}

sub writeentry {
    my $entry = shift;

    my $src = $$entry{'src'};
    my $trg = (lc($src) eq $src) ? lc($$entry{'trg'}) : $$entry{'trg'};
    my $posorig = $$entry{'pos'};
    my $pos = $posmap{$posorig};

    print "    <e";
    if($$entry{'first'} == 0) {
        print " r=\"RL\"";
    }
    if(exists $$entry{'label'}) {
        print " v=\"" . $$entry{'label'} . "\"";
    }
    print "><p><l>$src<s n=\"$pos\"/></l><r>$trg<s n=\"$pos\"/>";
    if(exists $$entry{'gen'}) {
        print "<s n=\"" . $$entry{'gen'} . '"/>';
    }
    print "</r></p></e>\n";
}
