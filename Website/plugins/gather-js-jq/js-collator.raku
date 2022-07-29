sub ( $pp, %options ) {
    my Bool $loadjq-lib = False;
    my @js;
    my @js-bottom;
    my %own-config = EVALFILE 'config.raku';
    for $pp.plugin-datakeys -> $plug {
        next if $plug eq 'js-collator' ;
        my $data = $pp.get-data($plug);
        next unless $data ~~ Associative;
        for $data.keys {
            when $_ ~~ 'js-script' and $data{$_} ~~ Str:D {
                @js.push( ($data{$_}, $plug ) )
            }
            when $_ ~~ 'js-link' and $data{$_} ~~ Str:D {
                @js.push( ($data{$_}, '' ) )
            }
            when $_ ~~ 'js-bottom' and $data{$_} ~~ Str:D {
                @js-bottom.push(( $data{$_}, $plug ));
            }
            when $_ ~~ 'jquery' and $data{$_} ~~ Str:D {
                @js.push(( $data{$_}, $plug ));
                $loadjq-lib = True
            }
            when $_ ~~ 'jquery-link' and $data{$_} ~~ Str:D {
                @js.push( ($data{$_}, '' ) );
                $loadjq-lib = True
            }
        }
    }
    my $template = "\%( \n "; # empty list emitted if not jq/js
    $template ~= 'jq-lib => sub (%prm, %tml) {'
        ~ "\n\'\<script src=\"" ~ %own-config<jquery-lib> ~ '"></script>' ~ "\' \n},\n"
        if $loadjq-lib;
    my @move-dest;
    my $elem;
    for @js -> ($file, $plug ){
        FIRST {
            $template ~= 'js => sub (%prm, %tml) {' ;
            $elem = 0;
        }
        LAST {
            $template ~= "}\n"
        }
        $template ~= ( $elem ?? '~ ' !! '' )
                ~ '\'<script '
                ~ ( $plug ?? 'src="/assets/scripts/' !! '' )
                ~ $file
                ~ ( $plug ?? '"' !! '' )
                ~ ">\</script>'\n";
        ++$elem;
        @move-dest.push( ("assets/scripts/$file" , $plug, $file ) )
            if $plug
    }
    for @js-bottom -> ($file, $plug ){
        FIRST {
            $template ~= 'js-bottom => sub (%prm, %tml) {' ;
            $elem = 0;
        }
        LAST {
            $template ~= "}\n"
        }
        $template ~= ( $elem ?? '~ ' !! '' ) ~ '\'<script src="/assets/scripts/' ~ $file ~ "\"\>\</script>'\n";
        ++$elem;
        @move-dest.push( ("assets/scripts/$file" , $plug, $file ) )
    }
    $template ~= ")\n";
    "js-templates.raku".IO.spurt($template);
    @move-dest
}