
%(
    website => sub (%prm, %tml) { %tml<ws-toc>(%prm, %tml) },
    ws-toc => sub (%prm,%tml) {
        return (%prm<contents> // 'No data') unless %prm<website-toc>;
        '<div class="website-toc"><div class="website-toc-caption">'
        ~ %prm<contents> ~ '</div>'
        ~ %prm<website-toc-data>.sort.map( {
            my $fn = .key;
            '<div class="website-toc-file">'
            ~ .key ~ '</div>'
            ~ .value.map( {
                "<div class=\"toc-head-{
                    $_<level> }\">\<a href=\"{
                    $fn }/{
                    $_<target> }\">{
                    $_<text> }\</a></div>\n"
            } )
        })
        ~ '</div>'
    },
)