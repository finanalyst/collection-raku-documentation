use v6.d;
my $camelia-svg = 'Camelia.svg'.IO.slurp;
my $camelia-ico = 'camelia-ico.bin'.IO.slurp;
my $faded-camelia-svg = 'Camelia-faded.svg'.IO.slurp;

%(
    'camelia-img' => sub ( %prm, %tml ) { $camelia-svg },
    'favicon' => sub ( %prm, %tml ) {
        "\n<link" ~ ' href="data:image/x-icon;base64,' ~ $camelia-ico ~ '" rel="icon" type="image/x-icon"' ~ "/>\n"
    },
    'camelia' => sub (%prm, %tml ) {
        '<div class="' ~ ( %prm<class> // 'camelia') ~ '">'
                ~ $camelia-svg ~
                ~ "</div>\n"
    },
    'fadedcamelia' => sub (%prm, %tml ) {
        '<div class="' ~ ( %prm<class> // 'camelia') ~ '">'
                ~ $faded-camelia-svg ~
                ~ "</div>\n"
    },
    'cameliashadow' => sub (%prm, %tml ) {
        '<img src="assets/images/camelia-404.png" class="' ~ ( %prm<class> // 'camelia') ~ '">'
    },
)