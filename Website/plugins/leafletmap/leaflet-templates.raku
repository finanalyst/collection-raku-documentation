#!/usr/bin/env perl6
%(
    leafletmap => sub (%prm, %tml) {
        my $id = %prm<id> // %prm<leafletmap><id> // 'collection-leaflet-map';
        my $var-name = 'v' ~ $id.trans('-' => '_');
        my $lat = %prm<lat> // %prm<leafletmap><lat> // 51.48160;
        my $long = %prm<long> // %prm<leafletmap><long> // -3.18070;
        my $zoom = %prm<zoom> // %prm<leafletmap><zoom> // 16;
        my $height = %prm<height> // %prm<leafletmap><height> // '200px';
        my $width = %prm<width>; # should do this in CSS, but sometimes ...
        my $provider = %prm<provider> // %prm<leafletmap><provider> // 'OpenStreetMap';
        my $apikey = %prm<leafletmap><api-key> // ''; # only put secret info in config file
        qq:to/MAP/;
            <div
            id="$id"
            style="height: { $height // '200px' }; { "width: $width;" if $width }"
            >
            </div>
            <script>
                var $var-name = L.map('$id').setView([$lat, $long], $zoom);
                  L.tileLayer.provider('$provider' { ', { apikey: \'' ~ $apikey ~ '\' }' if $apikey }).addTo($var-name);
            </script>
        MAP
    },
    leafmarker => sub (%prm, %tml) {
        my $map-id = 'v' ~ (%prm<map-id> // %prm<leafletmap><id> // 'collection-leaflet-map').trans('-' => '_');
        my $lat = %prm<lat>;
        my $long = %prm<long>;
        my $icon;
        my $name;
        with %prm<fa-icon> {
            $name = [~](('a'..'z').pick(9)); # random variable name
            $icon = qq:to/ICO/
                const $name = L.divIcon(\{
                    html: '<span class="fa $_"></span>',
                    iconSize: [20, 20],
                    className: 'myDivIcon'
                });
                ICO
        }
        my $popup = %prm<popup>;
        my $title = %prm<title>;
        qq:to/MARKER/;
        <script>
        { $icon if $icon }

        L.marker(\[$lat, $long], \{ {
            ("icon: $name" if $icon)
            ~ (',' if ($icon and $title))
            ~ ("title: '$title'" if $title)
        } }).addTo($map-id)
        { ".bindPopup('$popup')" if $popup }
        </script>
        MARKER
    },
)