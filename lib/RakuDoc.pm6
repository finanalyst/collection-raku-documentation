use v6.d;
use RakuConfig;
use Collection;

unit module Collection::RakuDocumentation;

constant CONFIG = %?RESOURCES<config.raku>;
constant WEBSITE = %?RESOURCES<website.rar>;

multi sub MAIN('Init', Bool :$force-install = False, *%c ) is export {
    say "Initialising a Raku Documentation collection in ｢~/{ $*CWD.relative($*HOME) }｣";
    exit note "The directory ｢~/{$*CWD.relative($*HOME)}｣ is not empty. Aborting.\n To over-ride this test use --force-install."
        if + $*CWD.dir and ! $force-install;
    'config.raku'.IO.spurt: CONFIG.slurp;
    my $proc = Proc::Async.new( 'unrar', 'x', ~WEBSITE);
    my $proc-rv;
    $proc.stdout.tap( -> $d { } );
    $proc.stderr.tap( -> $v { $proc-rv = $v } );
    await $proc.start;
    exit note "unrar error when unpacking Website files. Error is:" ~ $proc-rv
        if $proc-rv;
    say q:to/USE/;
        Collection is initialised. Run Raku-Doc without options to generate Documentation files.
        View documentation files in browser at url 'localhost:30000'.
        The README file contains more information about possible options
        USE
}
multi sub MAIN(|c) {
    exit note 'No config file is present. Please run ｢Raku-Doc \'Init\'｣ first'
        unless 'config.raku'.IO.f;
    collect(|c)
}

