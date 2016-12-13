#!/usr/bin/perl
# Copyright (c) 2015-2016 Trinity College, Dublin
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

use warnings;
use strict;
use utf8;
use Data::Dumper;
use Storable 'dclone';

binmode STDIN, ":utf8";
binmode STDOUT, ":utf8";

my %posmap = (
    'a.' => 'adj',
    'a' => 'adj',
    's.' => 'n',
    's' => 'n',
    'Pr.n.' => 'np',
    'int.' => 'ij',
    'adv.' => 'adv',
    'v.i.' => 'vblex',
    'v.tr.' => 'vblex',
    'ind. tr.' => 'vblex',
    'ind.tr.' => 'vblex',
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
    # Yup, twice. srsly
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
