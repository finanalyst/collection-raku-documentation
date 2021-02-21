sub ( $pp ) {
    my $mnger = $pp.get-data('image-manager');
    $pp.add-data('image', $mnger);
    %() # return empty list of pairs, required of render plugins
}