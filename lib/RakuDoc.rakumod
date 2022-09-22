use v6.d;
use RakuConfig;
use Collection;
use File::Directory::Tree;
use Collection::RefreshPlugins;

unit module Collection::RakuDoc;

constant COLLECTION = %?RESOURCES<raku-collection.zip>;

multi sub MAIN('Init') is export {
    say "Initialising a Raku Documentation collection in ｢~/{ $*CWD.relative($*HOME) }｣";
    exit note qq:to/NOTE/ if + $*CWD.dir;
        The directory ｢~/{$*CWD.relative($*HOME)}｣ is not empty. Aborting. Try ｢Raku-Doc Refresh｣ instead.
        NOTE

    my $unzip = run( 'unzip', ~COLLECTION, :err );
    my $unzip-err = $unzip.err.slurp(:close);
    exit note "unzip error when unpacking Raku collection files. Error is:" ~ $unzip-err
        if $unzip-err;
    refresh;
    say q:to/USE/;
        Raku Documentation Collection has now been initialised.
        The default configuration file "config.raku" for the Collection
        will clone the Raku Documentation repository into '_local_raku_docs'
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
    refresh;
    collect(|c)
}

