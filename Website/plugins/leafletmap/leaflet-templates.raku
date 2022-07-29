#!/usr/bin/env perl6
%(
    leafletmap => sub (%prm, %tml) {
        my $id = %prm<id> // %prm<leafletmap><id> // 'collection-leaflet-map';
        my $lat = %prm<lat> // 51.505;
        my $long = %prm<long> // -0.09;
        qq:to/MAP/
            <div
            id="$id"
            style="height: { %prm<height> // '100px' };"
            >
            </div>
            <script>
                var mymap = L.map('{ $id }').setView([{ $lat }, { $long }], 13);
                L.tileLayer.provider('Esri.WorldImagery').addTo(mymap);
            </script>
            MAP
    },
    marker => sub (%prm, %tml) {
        ''
    },
)