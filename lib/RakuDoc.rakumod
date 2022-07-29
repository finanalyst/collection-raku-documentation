use v6.d;
use RakuConfig;
use Collection;

unit module Collection::RakuDoc;

constant CONFIG = %?RESOURCES<config.raku>;
constant WEBSITE = %?RESOURCES<website.rar>;
constant ASSETS = %?RESOURCES<assets.zip>;

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
    $proc = Proc::Async.new( 'unzip', 'x', ~ASSETS);
    my $proc-rv;
    $proc.stdout.tap( -> $d { } );
    $proc.stderr.tap( -> $v { $proc-rv = $v } );
    await $proc.start;
    exit note "unzip error when unpacking Asset files. Error is:" ~ $proc-rv
    if $proc-rv;
    say q:to/USE/;
        Raku Documentation Collection has now been initialised.
        The configuration file "config.raku" in this directory must be edited.
        The simplest method is to comment ou the ":source-obtain()" and ":source-refresh()" keys
        by prefixing the lines containing the keys with #, and then
        removing the # from the lines below.
        If there is a local version of the Raku Documentation documents,
        point the source-obtain and source-refresh keys to the correct location.
        Run Raku-Doc without options to generate Documentation files.
        Viewing the documentation in the browser requires Cro::WebApp (see README).
        View documentation files in browser at url 'localhost:30000'.
        The README file contains more information about possible options
        USE
}
multi sub MAIN(|c) {
    exit note 'No config file is present. Please run ｢Raku-Doc \'Init\'｣ first'
        unless 'config.raku'.IO.f;
    collect(|c)
}

