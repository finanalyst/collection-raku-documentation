use v6.*;
my $camelia-svg = 'Camelia.svg'.IO.slurp;
my $css-text = '<style>' ~ 'pod.css'.IO.slurp ~ '</style>';
my $camelia-ico = 'camelia-ico.bin'.IO.slurp;

%(
    'camelia-img' => sub ( %prm, %tml ) { $camelia-svg },
    'css-text' => sub ( %prm, %tml ) { $css-text },
    'favicon' => sub ( %prm, %tml ) {
        '<link href="data:image/x-icon;base64,' ~ $camelia-ico ~ '" rel="icon" type="image/x-icon" />'
    },
)