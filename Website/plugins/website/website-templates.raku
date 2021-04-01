%(
    website => sub (%prm, %tml) {
        given %prm<make> {
            when 'glossary' { %tml<ws-glossary>(%prm, %tml) }
            when 'footnotes' { %tml<ws-footnotes>(%prm, %tml) }
            when 'toc-glossary' { %tml<ws-combined>(%prm, %tml) }
            default { %tml<ws-toc>(%prm, %tml) }
        }
    },
    ws-toc => sub (%prm,%tml) {
        my Bool $ns = %prm<no-search> // False;
        my $id = 'src-id">'; # id MUST be on the end of a definition
        $id = (%prm<id> ~ '">') if %prm<id>;
        $id = 'no-search">' if $ns;
        "\n" ~ '<div class="ws-toc-container">' ~ "\n"
            ~ '<div class="ws-toc-caption">' ~ %prm<contents>.cache ~ '</div>' ~ "\n"
            ~ ($ns ?? '' !! ('<input class="ws-toc-search" type="text" placeholder="Search headings ..." data-id="' ~ $id))
            ~ '<div class="ws-toc-file-heading">Web page</div>' ~ "\n"
            ~ '<div class="ws-toc-heading">Chapter headings</div>' ~ "\n"
            ~ %prm<website><ws-toc>.cache.sort.map({
            my $fn = .key;
            '<div class="ws-toc-file ' ~ $id
                    ~ .key ~ '</div>' ~ "\n"
                    ~ .value.map({
                "<a href=\"{
                    $fn }.html#{
                    $_<target> }\" class=\"ws-toc-head-{
                    $_<level> } {$id}{$_<text> }\</a>\n"
            })
        })
        ~ '</div>'
    },
    ws-glossary => sub (%prm,%tml) {
        my Bool $ns = %prm<no-search> // False;
        my $id = 'src-id">'; # id MUST be on the end of a definition
        $id = (%prm<id> ~ '">') if %prm<id>;
        $id = 'no-search">' if $ns;
        "\n" ~ '<div class="ws-glossary-container">' ~ "\n"
            ~ '<div class="ws-glossary-caption">' ~ %prm<contents> ~ '</div>' ~ "\n"
            ~ ($ns ?? '' !! ('<input class="ws-glossary-search" type="text" placeholder="Search index ..." data-id="' ~ $id))
            ~ '<div class="ws-glossary-defn header">Term explained</div>'
            ~ '<div class="ws-glossary-file header">Source file</div>'
            ~ '<div class="ws-glossary-place header">In section</div>'
            ~ %prm<website><ws-glossary>.cache.sort.map({
                '<div class="ws-glossary-defn ' ~ $id
                    ~ .key ~ '</div>'
                    ~ .value.sort.map({
                        my $fn = .key;
                        '<div class="ws-glossary-file ' ~ $id
                        ~ $fn
                        ~ '</div>'
                        ~ [~] .value.map({
                            '<a href="' ~ $fn ~ '.html#'
                            ~ %tml<escaped>($_<target>)
                            ~ '" class="ws-glossary-place ' ~ $id
                            ~ ($_<place>.defined ?? $_<place> !! '')
                            ~ "</a>\n"
                    })
                })
            })
        ~ '</div>'
    },
    ws-footnotes => sub (%prm,%tml) {
        '<div class="ws-footnote-container"><div class="ws-footnote-caption">'
            ~ %prm<contents> ~ '</div>'
            ~ %prm<website><ws-footnotes>.sort.map({
            my $fn = .key;
            '<div class="ws-footnote-file">'
                ~ .key ~ '</div>'
                ~ .value.map({
                    '<div class="ws-footnote">'
                    ~ '<span class="ws-footnote-number">' ~ ( $_<fnNumber> // '' ) ~ '</span>'
                    ~ ($_<text> // '')
                    ~ '<a class="ws-footnote-linkback" href="' ~ $fn ~ '.html#'
                    ~ %tml<escaped>($_<retTarget>)
                    ~ '"> « Back »</a>'
                    ~ '</div>'
                })
            })
        ~ '</div>'
    },
    ws-combined => sub (%prm,%tml) {
        my Bool $ns = %prm<no-search> // False;
        my $id = 'src-id">'; # id MUST be on the end of a definition
        $id = (%prm<id> ~ '">') if %prm<id>;
        $id = 'no-search">' if $ns;
        "\n" ~ '<div class="ws-combined">'
        ~ ($ns ?? '' !! ('<input class="ws-combined-search" type="text" placeholder="Search headings ..." data-id="' ~ $id))
        ~ '<div class="ws-toc-container">' ~ "\n"
                ~ '<div class="ws-toc-caption">' ~ (%prm<toc-caption> // '') ~ '</div>' ~ "\n"
                ~ '<div class="ws-toc-file-heading">Web page (clickable)</div>' ~ "\n"
                ~ '<div class="ws-toc-heading">Chapter headings (clickable)</div>' ~ "\n"
                ~ %prm<website><ws-toc>.cache.sort.map({
            my $fn = .key;
            '<div class="ws-toc-file ' ~ $id
                    ~ "<a href=\"$fn\.html\">$fn\</a>" ~ '</div>' ~ "\n"
                    ~ .value.map({
                "<a href=\"{
                    $fn }.html#{
                    $_<target> }\" class=\"ws-toc-head-{
                    $_<level> } { $id }{$_<text> }\</a>\n"
            })
        })
        ~ '</div>'
        ~ '<div class="ws-glossary-container">' ~ "\n"
                ~ '<div class="ws-glossary-caption">' ~ (%prm<glossary-caption> // '') ~ '</div>' ~ "\n"
                ~ '<div class="ws-glossary-defn header">Term explained (not clickable)</div>'
                ~ '<div class="ws-glossary-file header">Source file (clickable)</div>'
                ~ '<div class="ws-glossary-place header">In section (clickable)</div>'
                ~ %prm<website><ws-glossary>.cache.sort.map({
            '<div class="ws-glossary-defn ' ~ $id
                    ~ .key ~ '</div>'
                    ~ .value.sort.map({
                my $fn = .key;
                '<div class="ws-glossary-file ' ~ $id
                        ~ "<a href=\"$fn\.html\">$fn\</a>"
                        ~ '</div>'
                        ~ [~] .value.map({
                        '<a href="' ~ $fn ~ '.html#'
                            ~ %tml<escaped>($_<target>)
                            ~ '" class="ws-glossary-place ' ~ $id
                            ~ ($_<place>.defined ?? $_<place> !! '')
                            ~ "</a>\n"
                })
            })
        })
        ~ "</div>\n</div>"
    },
)