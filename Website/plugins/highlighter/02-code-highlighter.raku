use v6.*;
#| custom getter for atom-highlight
multi method highlight-code( --> Bool ) {
    $!highlight-code
}

#| custom setter/getter for highlight-code to use default highlighter
#| highlight sub will return a Str highlighted as if Str contains Raku code
#| Uses Samantha McVie's atom-highlighter
#| Raku-Pod-Render places this at <user-home>.local/share/raku-pod-render/highlights
#| or <user-home>.raku-pod-render/highlights
multi method highlight-code( Bool $new-state --> Bool ) {
    return $new-state if $new-state == $!highlight-code;
    if $new-state {
        # Toggle from off to on
        $!atom-highlights-path = set-highlight-basedir without $!atom-highlights-path;
        if test-highlighter( $!atom-highlights-path ) {
            $!highlight-code = True;
            $!atom-highlighter = Proc::Async.new(
                    "{ $!atom-highlights-path }/node_modules/coffeescript/bin/coffee",
                    "{ $!atom-highlights-path }/highlight-filename-from-stdin.coffee", :r, :w)
            without $!atom-highlighter;
            $!highlighter-supply = $!atom-highlighter.stdout.lines
            without $!highlighter-supply;
            # set up the highlighter closure
            $.no-code-escape = True;
            &.highlight = -> $frag {
                return $frag unless $frag ~~ Str:D;
                $!atom-highlighter.start unless $!atom-highlighter.started;

                my ($tmp_fname, $tmp_io) = tempfile;
                # the =comment is needed to trigger the atom highlighter when the code isn't unambiguously Raku
                $tmp_io.spurt: "=comment\n\n" ~ $frag, :close;
                my $promise = Promise.new;
                my $tap = $!highlighter-supply.tap( -> $json {
                    my $parsed-json = from-json($json);
                    if $parsed-json<file> eq $tmp_fname {
                        $promise.keep($parsed-json<html>);
                        $tap.close();
                    }
                } );
                $!atom-highlighter.say($tmp_fname);
                await $promise;
                # get highlighted text remove raku trigger =comment
                $promise.result.subst(/ '<div' ~ '</div>' .+? /,'',:x(2) )
            }
        }
        else { $!highlight-code = False }
    }
    else {
        #toggle from on to off
        # restore default code
        &.highlight = -> $frag { $frag };
        $!highlight-code = False;
        $.no-code-escape = False;
    }
    # return state
    $!highlight-code
}

sub set-highlight-basedir( --> Str ) {
    my $basedir = $*HOME;
    my $hilite-path = "$basedir/.local/lib".IO.d
            ?? "$basedir/.local/lib/raku-pod-render/highlights".IO.mkdir
            !! "$basedir/.raku-pod-render/highlights".IO.mkdir;
    exit 1 unless ~$hilite-path;
    ~$hilite-path
}
sub test-highlighter( Str $hilite-path --> Bool ) {
    ?("$hilite-path/package-lock.json".IO.f and "$hilite-path/atom-language-perl6".IO.d)
}

%(
    'block-code' => sub ( %prm, %tml ) {
        my $contents = %prm<contents>;
        if $.highlight-code {
            # a highlighter will add its own classes to the <pre> container
            $.highlight.( $contents )
        }
        else {
            '<pre class="pod-block-code">'
                    ~ ($contents // '')
                    ~ '</pre>'
        }
    }
)