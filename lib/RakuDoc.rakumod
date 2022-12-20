use v6.d;
use RakuConfig;
use Collection;
use File::Directory::Tree;
use Collection::RefreshPlugins;

unit module Collection::RakuDoc;

constant COLLECTION = %?RESOURCES<raku-collection.zip>;

multi sub MAIN('Update') is export {
    say "Updating the Raku Documentation collection in ｢~/{ $*CWD.relative($*HOME) }｣";
    'raku-collection.zip'.IO.unlink if 'raku-collection.zip'.IO ~~ :e & :f;
    my $rv = run(<
        wget -q
        https://raw.githubusercontent.com/finanalyst/raku-documentation-site-dev/master/raku-collection.zip
    >);
    (exit note 'Could not download Website Collection files') if $rv.exitcode;
    my $unzip = run( 'unzip', '-ou' , 'raku-collection.zip', :err );
    my $unzip-err = $unzip.err.slurp(:close);
    (exit note("unzip error when unpacking Raku collection files. Error is:" ~ $unzip-err))
        if $unzip-err;
    'raku-collection.zip'.IO.unlink;
    refresh;
}

multi sub MAIN('Init') is export {
    say "Initialising a Raku Documentation collection in ｢~/{ $*CWD.relative($*HOME) }｣";
    exit note qq:to/NOTE/ if + $*CWD.dir;
        The directory ｢~/{$*CWD.relative($*HOME)}｣ is not empty. Aborting. Try ｢Raku-Doc Refresh｣ instead.
        NOTE

    'raku-collection.zip'.IO.unlink if 'raku-collection.zip'.IO ~~ :e & :f;
    my $rv = run(<
        wget -q
        https://raw.githubusercontent.com/finanalyst/raku-documentation-site-dev/master/raku-collection.zip
    >);
    (exit note 'Could not download Website Collection files') if $rv.exitcode;
    my $unzip = run( 'unzip', 'raku-collection.zip', :err );
    my $unzip-err = $unzip.err.slurp(:close);
    (exit note("unzip error when unpacking Raku collection files. Error is:" ~ $unzip-err))
        if $unzip-err;
    'raku-collection.zip'.IO.unlink;
    refresh;
    my %config = get-config;
    say qq:to/USE/;
        Raku Documentation Collection has now been initialised.
        The default configuration file "config.raku" for the Collection
        will clone the Raku Documentation repository into ｢{ %config<source-obtain> }｣
        in this directory. The cloning will only take place on the next use of
        Raku-Doc.

        To prevent or change this default, the configuration file "config.raku"
        in this directory must be edited.
        If there is a local version of the Raku Documentation documents,
        point the "source-obtain" and "source-refresh" keys to the correct location.

        Run "Raku-Doc" without options to generate Documentation files.

        Viewing the documentation in the browser requires Cro::WebApp (see README).
        View documentation files in browser at url 'localhost:30000'.

        The README file contains more information about possible options
        USE
}
multi sub MAIN(|c) {
    exit note 'No config file is present. Please run ｢Raku-Doc \'Init\'｣ first'
        unless 'config.raku'.IO.f;
    refresh(|c);
    collect(|c)
}

