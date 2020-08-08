#!/usr/bin/env perl6
use v6.d;

sub MAIN(Str $action? = 'default',
         Str :$documentation = '/home/richard/development/raku-alternative-documentation/raku-documentation') {
    my @configs = configs();
    unless +@configs {
        exit note "$documentation must be a directory with read/write/execute permissions" unless $documentation
                .IO ~~ :d & :rwx;
        &*chdir($documentation);
        @configs = configs();
        exit note "There must be at least one *.collection.cfg file in the directory" unless +@configs;
    }
    say 'ok';
    say $/;
    say @configs;

}
#| determine whether there are any collection.cfg files in directory
sub configs(--> Seq) {
    dir(:test(/ <ident>+ '.collection.cfg' $ /)).map({ .basename.subst('.collection.cfg','')})
}
