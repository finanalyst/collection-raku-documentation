use v6.d;
sub ($pr, %processed, %options --> Array ) {
    "css-templates.raku".IO.unlink;
    []
}