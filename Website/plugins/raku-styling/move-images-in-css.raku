#!/usr/bin/env raku
use v6.d;

sub ($pp, %options ) {
    my @move-to-dest;
    for < Camelia-faded.svg pencil.svg > -> $fn {
        # array of triplets. 'to','myself', 'from'
        @move-to-dest.push( (
            "assets/images/$fn",  # file name as it appears in css
            'myself', # look in own plugin directory
            "images/$fn", ) # filename as it appears in this directory
        );
    }
    @move-to-dest
}