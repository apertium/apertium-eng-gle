#!/usr/bin/perl

use warnings;
use strict;
use utf8;

binmode(STDIN, ":utf8");
binmode(STDOUT, ":utf8");

my $par = 'John__np';
while(<>) {
    chomp;
    my $first = substr($_, 0, 1);
    my $second = substr($_, 1, 1);
    if ($first eq lc($first)) {
        $first = uc($first);
    }
    my $rest = substr($_, 1);
    my $lm = $first . $rest;
    print "<e lm=\"$lm\"><i>$lm</i><par n=\"${par}__np\"/></e>\n";
        if ($first =~ /[BCDFGMPSTK]/ && $second ne 'h') {
            print "<e lm=\"$lm\"><par n=\"${first}__len\"/><i>$rest</i><par n=\"${par}__len\"/></e>\n";
        } else {
            print "<e lm=\"$lm\"><i>${lm}</i><par n=\"${par}__len\"/></e>\n";
        }
        if ($first =~ /[BCDFGPTAEIOUÁÉÍÓÚK]/) {
            print "<e lm=\"$lm\"><par n=\"${first}__ecl\"/><i>$rest</i><par n=\"${par}__ecl\"/></e>\n";
        } else {
            print "<e lm=\"$lm\"><i>${first}${rest}</i><par n=\"${par}__ecl\"/></e>\n";
        }

}
