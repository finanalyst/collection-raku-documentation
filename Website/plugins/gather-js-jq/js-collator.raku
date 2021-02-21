#!/usr/bin/env perl6
sub ( $pp ) {
    # change the placeholders in the templates
    # Initially assume only jquery scripts
    # TODO add other scripts and links

    my Bool $loadjq-lib = True;
    my $scripts = '';
    #    my @links;
    #    my @adds;
    my %own-config = EVALFILE 'config.raku';
    for $pp.plugin-datakeys {
        next if $_ eq 'js-collator' ;
        my $data = $pp.get-data($_);
        next unless $data ~~ Associative;
        if $data<jquery>:exists and $data<jquery> ~~ Str:D {
            my $file = ($data<path> ~ '/' ~ $data<jquery>).IO;
            $scripts ~= "\n<script>\n" ~ $file.slurp ~ "\n</script>\n"
        }
        #        elsif $data<css-link>:exists and $data<css-link> ~~ Str:D {
        #            @links.append($data<css-link>)
        #        }
        #        elsif $data<add-css>:exists and $data<add-css> ~~ Str:D {
        #            @adds.append(%(:path($data<path>), :file($data<add-css>)))
        #        }
    }
    #    return {} unless $css or +@adds or +@links;
    my $template = "\%( \n ";
    $template ~= 'jq-lib => sub (%prm, %tml) {'
        ~ "\n\'\<script src=\"" ~ %own-config<jquery-lib> ~ '"></script>' ~ "\' },\n"
        if $loadjq-lib;
    my %move-dest;
    if $scripts {
        $template ~= 'jq => sub (%prm, %tml) {' ~ "\n"
                ~ '\'' ~ $scripts ~ "\'},\n"
    }
    #    for @adds {
    #        say '"\n" ~ ' ~ "'<link rel=\"stylesheet\" href=\"/assets/css/{ $_.<file> }\">'";
    #        $template ~= "\n" ~ '"\n" ~ ' ~ "'<link rel=\"stylesheet\" href=\"/assets/css/{ $_.<file> }\">'";
    #        ($_.<path> ~ '/' ~ $_.<file>).IO.copy($_.<file>);
    #        %move-dest{'assets/css/' ~ $_.<file>} = $_.<file>
    #    }
    #    for @links {
    #        $template ~= "\n" ~ '"\n" ~ ' ~ "'<link rel=\"stylesheet\" href=\"$_\" >'";
    #    }
    $template ~= ')';
    "js-templates.raku".IO.spurt: $template;
    %move-dest
}