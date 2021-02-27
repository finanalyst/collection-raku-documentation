#!/usr/bin/env perl6
%(
    filterlines => sub (%prm, %tml) {
        "\n" ~ '<input id="' ~ ( %prm<id> or 'RakuSearchLine') ~ '" type="text" placeholder="Search...">'
            ~ "\n" ~ '<div id="_search_selector" style="display: none;">'
            ~ (%prm<selector> // '#RakuSearchContent *') ~ '</div>'
            ~ "\n" ~ '<div id="RakuSearchContent">'
            ~ "\n" ~ %prm<contents>
            ~ "\n" ~ '</div>'
    },
)