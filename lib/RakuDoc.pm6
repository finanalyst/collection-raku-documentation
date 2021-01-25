use v6.*;
use RakuConfig;
use Collection;

unit module Collection::RakuDocumentation;

constant CONFIG = %?RESOURCES<config.raku>;
constant WEBSITE = %?RESOURCES<website.rar>;

multi sub MAIN(|c) is export {
    unless 'config.raku'.IO.f {
        exit note "The directory ｢~/{$*CWD.relative($*HOME)}｣ has no config file, but it is not empty. Aborting"
        if + $*CWD.dir;
        say "Initialising collection in ｢~/{ $*CWD.relative($*HOME) }｣";
        'config.raku'.IO.spurt: CONFIG.slurp;
        my $proc = run 'unrar', 'x', ~WEBSITE, :err, :out;
        my $proc-rv = $proc.err.get;
        exit note "unrar error when unpacking Website files. Error is:" ~ $proc-rv
        if $proc-rv;
        say 'Initialised'
    }
    collect( |c ) unless |c ~~ 'Init';
}

