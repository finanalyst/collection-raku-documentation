sub ( $pp, %options ) {
    my Bool $loadjq-lib = False;
    my @js;
    my @js-bottom;
    my %own-config = EVALFILE 'config.raku';
    for $pp.plugin-datakeys -> $plug {
        next if $plug eq 'js-collator' ;
        my $data = $pp.get-data($plug);
        next unless $data ~~ Associative;
        if $data<js-script>:exists and $data<js-script> ~~ Str:D {
            @js.push( ($data<js-script>, $plug ) )
        }
        elsif $data<js-link>:exists and $data<js-link> ~~ Str:D {
            @js.push( ($data<js-link>, '' ) )
        }
        elsif $data<js-bottom>:exists and $data<js-bottom> ~~ Str:D {
            @js-bottom.push(( $data<js-bottom>, $plug ));
        }
        elsif $data<jquery>:exists and $data<jquery> ~~ Str:D {
            @js.push(( $data<jquery>, $plug ));
            $loadjq-lib = True
        }
        elsif $data<jquery-link>:exists and $data<jquery-link> ~~ Str:D {
            @js.push( ($data<jquery-link>, '' ) );
            $loadjq-lib = True
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
                ~ '\'<script src="'
                ~ ( $plug ?? '/assets/scripts/' !! '' )
                ~ $file
                ~ "\"\>\</script>'\n";
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