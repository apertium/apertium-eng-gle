#!/usr/bin/perl

use warnings;
use strict;
use utf8;

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");

my $pardef = '';
while(<>) {

    if(/<pardef n="([^"]*)">/) {
        $pardef = $1;
    }
    if(/<\/pardef>/) {
        print;
        print "<pardef n=\"${pardef}__len\">\n  <e><par n=\"$pardef\"/><p><l/><r><s n=\"len\"/></p></e>\n</pardef>\n";
        print "<pardef n=\"${pardef}__ecl\">\n  <e><par n=\"$pardef\"/><p><l/><r><s n=\"ecl\"/></p></e>\n";
        $pardef = '';
    }
    print;
    if(/<e lm="([^"]*)"><i>([A-ZÁÉÍÓÚa-záéíóú])([^<]*)<\/i><par n="([^"]*)"\/><\/e>/) {
        my $lm = $1;
        my $first = $2;
        my $rest = $3;
        my $par = $4;
        if ($first =~ /[bBcCdDfFgGmMpPsStT]/) {
            print "<e lm=\"$lm\"><par n=\"${first}__len\"/><i>$rest</i><par n=\"${par}__len\"/></e>\n";
        } else {
            print "<e lm=\"$lm\"><i>${first}${rest}</i><par n=\"${par}__len\"/></e>\n";
        }
        if ($first =~ /[bBcCdDfFgGpPtTaAeEiIoOuUáÁéÉíÍóÓúÚ]/) {
            print "<e lm=\"$lm\"><par n=\"${first}__ecl\"/><i>$rest</i><par n=\"${par}__ecl\"/></e>\n";
        } else {
            print "<e lm=\"$lm\"><i>${first}${rest}</i><par n=\"${par}__ecl\"/></e>\n";
        }
    }
}
