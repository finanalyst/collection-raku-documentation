sub ($pr, %processed, %options) {
    my $ws = $pr.get-data('website');
    # TOC by sorted file, then by header, sub-header, etc, in order of header appearance
    $ws<ws-toc> =
            %( |gather for %processed.kv -> $fn, $podf {
                take $fn => $podf.raw-toc}).sort;
    # Glossary, By term explained (sorted), then by file (sorted), then location
    # Where same term in different files, then merged into same term, assumes one term explained once per file, but may have
    # multiple locations in file. %processed structure is hash(filename) -> hash(term) -> array(location)
    # glossary -> hash(term) -> hash(file) -> array(location)
    my %terms;
    for %processed.kv -> $fn, $podf {
        for $podf.raw-glossary.kv -> $term, $location {
            %terms{$term}{$fn} = $location
        }
    };
    $ws<ws-glossary> = %terms;
    $ws<ws-footnotes> =
            %( |gather for %processed.kv -> $fn, $podf {
                take $fn => $podf.raw-footnotes
                    if $podf.raw-footnotes.elems
            });
}