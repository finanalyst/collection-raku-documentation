%(
    website => sub (%prm, %tml) {
        given %prm<make> {
            when 'glossary' { %tml<ws-glossary>(%prm, %tml) }
            when 'footnotes' { %tml<ws-footnotes>(%prm, %tml) }
            default { %tml<ws-toc>(%prm, %tml) }
        }
    },
    ws-toc => sub (%prm,%tml) {
        '<div class="ws-toc-container"><div class="ws-toc-caption">'
                ~ %prm<contents> ~ '</div>'
                ~ %prm<website><ws-toc>.sort.map({
            my $fn = .key;
            '<div class="ws-toc-file">'
                    ~ .key ~ '</div>'
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
        '<div class="ws-glossary-container">' ~ "\n"
            ~ '<div class="ws-glossary-caption">'~ %prm<contents> ~ '</div>'
            ~ '<div class="ws-glossary-defn header">Term explained</div>'
            ~ '<div class="ws-glossary-file header">Source file</div>'
            ~ '<div class="ws-glossary-place header">In section</div>'
            ~ %prm<website><ws-glossary>.sort.map({
                '<div class="ws-glossary-defn">'
                    ~ .key ~ '</div>'
                    ~ .value.sort.map({
                        my $fn = .key;
                        '<div class="ws-glossary-file">'
                        ~ $fn
                        ~ '</div>'
                        ~ [~] .value.map({
                            '<div class="ws-glossary-place"><a href="' ~ $fn ~ '.html#'
                            ~ %tml<escaped>($_<target>)
                            ~ '">'
                            ~ ($_<place>.defined ?? $_<place> !! '')
                            ~ "</a></div>\n"
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
)