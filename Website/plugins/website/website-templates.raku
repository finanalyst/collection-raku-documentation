%(
    website => sub (%prm, %tml) {
        given %prm<make> {
            when 'glossary' { %tml<ws-glossary>(%prm, %tml) }
            when 'footnotes' { %tml<ws-footnotes>(%prm, %tml) }
            default { %tml<ws-toc>(%prm, %tml) }
        }
    },
    ws-toc => sub (%prm,%tml) {
        "\n" ~ '<div class="ws-toc-container">' ~ "\n"
                ~ '<div class="ws-toc-caption">' ~ %prm<contents>.cache ~ '</div>' ~ "\n"
                ~ '<div class="ws-toc-file-heading">Web page</div>' ~ "\n"
                ~ '<div class="ws-toc-heading">Chapter headings</div>' ~ "\n"
                ~ %prm<website><ws-toc>.cache.sort.map({
            my $fn = .key;
            '<div class="ws-toc-file">'
                    ~ .key ~ '</div>' ~ "\n"
                    ~ .value.map({
                "<div class=\"ws-toc-head-{
                    $_<level> }\">\<a href=\"{
                    $fn }.html#{
                    $_<target> }\">{
                    $_<text> }\</a></div>\n"
            })
        })
                ~ '</div>'
    },
    ws-glossary => sub (%prm,%tml) {
        my $id = 'src-id">';
        $id = (%prm<id> ~ '">') if %prm<id>;
        '<div class="ws-glossary-container">' ~ "\n"
            ~ '<div class="ws-glossary-caption">' ~ %prm<contents> ~ '</div>'
            ~ '<input class="ws-glossary-search" data-id="' ~ $id ~ ' type="text" placeholder="Search index ...">'
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
                        ~ '</div><div class="ws-glossary-place ' ~ $id
                        ~ [~] .value.map({
                            '<a href="' ~ $fn ~ '.html#'
                            ~ %tml<escaped>($_<target>)
                            ~ '">'
                            ~ ($_<place>.defined ?? $_<place> !! '')
                            ~ "</a>\n"
                    }) ~ "</div>\n"
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
)