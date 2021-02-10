
sub ( $pp ) {
    my $css = '';
    for $pp.plugin-datakeys {
        my $data = $pp.get-data($_);
        next unless $data ~~ Associative and $data<css>:exists and $data<css> ~~ Str:D;
        my $file = ($data<path> ~ '/' ~ $data<css>).IO;
        $css ~= "\n" ~ $file.slurp;
    }
    # remove lines with .css.map as the scss sources are not copied to be served
    $css.subst-mutate(/ \n \N+? '.css.map' .+? $$/,'',:g);

    my $fn = $pp.get-data('mode-name') ~ '.css';
    $fn.IO.spurt($css);
    # now generate the templates file
    'templates.raku'.IO.spurt( qq:to /TMPL/ );
        \%(
            css \=> sub (\%prm, \%tml) \{
                "\\n" ~ '<link rel="stylesheet" href="/assets/css/$fn">'
            \},
        )
        TMPL
    %( "assets/css/$fn" => $fn )
}