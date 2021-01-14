use v6.*;
our $camelia-svg = %?RESOURCES<Camelia.svg>.slurp;
our $css-text = '<style>' ~ %?RESOURCES<pod.css>.slurp ~ '</style>';
our $camelia-ico = %?RESOURCES<camelia-ico.bin>.slurp;

%(
    'camelia-img' => sub ( %prm, %tml ) { $camelia-svg },
    'css-text' => sub ( %prm, %tml ) { $css-text },
    'favicon' => sub ( %prm, %tml ) {
        '<link href="data:image/x-icon;base64,' ~ $camelia-ico ~ '" rel="icon" type="image/x-icon" />'
    },
)