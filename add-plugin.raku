#!/usr/bin/env perl6
use RakuConfig;

sub MAIN(Str:D $plug, :$mile = 'render') {
my %config;
try {
    %config = get-config(:path<configs>);
    CATCH {
        default { exit note .Str }
    }
}
exit (note "%config<plugins> does not exist") unless %config<plugins>.IO.d;
my $path = "%config<plugins>/$plug";
$path.IO.mkdir;
"$path/README.pod6".IO.spurt(qq:to/TEMP/);
        \=begin pod
        \=TITLE $plug is plugin for Collection

        The plugin is for the $mile milestone

        \=head1 Custom blocks

        \=head1 Templates

        \=end pod
        TEMP

    if $mile eq 'render' {
        "$path/config.raku".IO.spurt(q:to/TEMP/);
            %(
                :render,
                :template-raku(),
                :custom-raku(),
            )
            TEMP
    }
    else {
        "$path/config.raku".IO.spurt(qq:to/TEMP/);
            %(
                :{ $mile }<{$mile}-callable.raku>,
            )
            TEMP
        my $sub;
        given $mile {
            when 'setup' {
                "$_\-callable.raku".IO.spurt(q:to/TEMP/);
                use v6.d;
                sub ( $source-cache, $mode-cache, Bool $full-render,  $source-root, $mode-root ) {
                    # return nothing
                }
                TEMP
            }
        }
    }

}