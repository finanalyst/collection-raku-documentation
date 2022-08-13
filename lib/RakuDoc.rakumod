use v6.d;
use RakuConfig;
use Collection;
use File::Directory::Tree;

unit module Collection::RakuDoc;

constant CONFIG = %?RESOURCES<config.raku>;
constant WEBSITE = %?RESOURCES<website.zip>;
constant ASSETS = %?RESOURCES<assets.zip>;

multi sub MAIN('Refresh', *%c ) is export {
    say "Refreshing an existing Raku Documentation collection in ｢~/{ $*CWD.relative($*HOME) }｣";
    my $request = "Which resource needs refreshing? (C)onfig file, (W)ebsite, (A)ssets, (E)verything: ";
    my $which = prompt "(enter) to cancel. $request";
    exit unless $which;
    ($which = prompt("Only C W A E are acceptible responses\n$request") ) until $which ~~ any(<C W A E c w a e>);
    my $proc;
    my $proc-rv;
    given $which {
        when any(<C E c e>) {
            'config.raku'.IO.unlink;
            'config.raku'.IO.spurt: CONFIG.slurp;
            proceed
        }
        when any(<W E w e>) {
            rmtree 'Website';
            $proc = Proc::Async.new('unzip', ~WEBSITE);
            $proc.stdout.tap(-> $d {});
            $proc.stderr.tap(-> $v { $proc-rv = $v });
            await $proc.start;
            exit note "unzip error when unpacking Website files. Error is:" ~ $proc-rv
            if $proc-rv;
            proceed
            }
        when any(<A E a e>) {
            rmtree 'Assets';
            $proc-rv = Nil;
            $proc = Proc::Async.new('unzip', ~ASSETS);
            $proc.stdout.tap(-> $d {});
            $proc.stderr.tap(-> $v { $proc-rv = $v });
            await $proc.start;
            exit note "unzip error when unpacking Asset files. Error is:" ~ $proc-rv
            if $proc-rv;
        }
    }
}

multi sub MAIN('Init', *%c ) is export {
    say "Initialising a Raku Documentation collection in ｢~/{ $*CWD.relative($*HOME) }｣";

    exit note qq:to/NOTE/ if + $*CWD.dir;
        The directory ｢~/{$*CWD.relative($*HOME)}｣ is not empty. Aborting. Try ｢Raku-Doc Refresh｣ instead.
        NOTE

    'config.raku'.IO.spurt: CONFIG.slurp;
    my $proc = Proc::Async.new( 'unzip', ~WEBSITE);
    my $proc-rv;
    $proc.stdout.tap( -> $d { } );
    $proc.stderr.tap( -> $v { $proc-rv = $v } );
    await $proc.start;
    exit note "unzip error when unpacking Website files. Error is:" ~ $proc-rv
        if $proc-rv;
    $proc-rv = Nil;
    $proc = Proc::Async.new( 'unzip', ~ASSETS);
    $proc.stdout.tap( -> $d { } );
    $proc.stderr.tap( -> $v { $proc-rv = $v } );
    await $proc.start;
    exit note "unzip error when unpacking Asset files. Error is:" ~ $proc-rv
    if $proc-rv;
    say q:to/USE/;
        Raku Documentation Collection has now been initialised.
        The configuration file "config.raku" in this directory must be edited.
        The simplest method is to comment out the ":source-obtain()" and ":source-refresh()" keys
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

