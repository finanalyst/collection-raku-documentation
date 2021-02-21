#!/usr/bin/env perl6
%(
    filterlines => sub (%prm, %tml) {
        '<input id="RakuSearchLine" type="text" placeholder="Search...">'
        ~ "\n" ~ '<div id="RakuSearchContent">'
        ~ "\n" ~ %prm<contents>
        ~ "\n" ~ '</div>'
    },
)