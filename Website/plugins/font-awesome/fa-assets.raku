
sub ( $pp ) {
    # need to move fonts in directory to asset file
    my $dir = 'fonts';
    my %move-to-dest;
    for $dir.IO.dir -> $fn {
        %move-to-dest{"assets/$fn"} = "$fn"
    }
    %move-to-dest
}