use v6.d;
sub ($source-cache, $mode-cache, Bool $full-render,  $source-root, $mode-root, %options) {
    for $source-cache.sources -> $k {
        next unless $k ~~ / ^ (.+) ('/Language/' | '/Type/' | '/Programs/' | '/Native/' ) (.+) $/;
        $source-cache.add($k, :alias($0 ~ $1.lc ~ $2));
    }
}