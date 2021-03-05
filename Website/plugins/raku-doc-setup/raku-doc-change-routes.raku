use v6.d;
sub ($source-cache, $mode-cache, Bool $full-render,  $source-root, $mode-root) {
    for $source-cache.sources -> $k {
        next unless $k ~~ / ^ (.+) ('/Language/' | '/Type/' | '/Programs/') (.+) $/;
        $source-cache.add($k, :alias($0 ~ $1.lc ~ $2));
    }
}