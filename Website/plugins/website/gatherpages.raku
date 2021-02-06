sub ($pr, %processed) {
    my $ws = $pr.get-data('website');
    $ws<ws-toc> =
            %( |gather for %processed.kv -> $fn, $podf {
                take $fn => $podf.raw-toc});
    $ws<ws-glossary> =
            %( |gather for %processed.kv -> $fn, $podf {
                take $fn => $podf.raw-glossary
                    if $podf.raw-glossary.keys
            });
    $ws<ws-footnotes> =
            %( |gather for %processed.kv -> $fn, $podf {
                take $fn => $podf.raw-footnotes
                    if $podf.raw-footnotes.elems
            });
}