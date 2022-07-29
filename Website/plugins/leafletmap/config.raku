%(
    :render,
    :template-raku<leaflet-templates.raku>,
    :custom-raku<leaflet-blocks.raku>,
    :css-link( q:to/CSS/ ),
        href="https://unpkg.com/leaflet@1.7.1/dist/leaflet.css"
        integrity="sha512-xodZBNTC5n17Xt2atTPuE1HxjVMSvLVW9ocqUKLsCC5CXdbqCmblAshOMAS6/keqq/sMZMZ19scR4PsZChSR7A=="
        crossorigin=""
        CSS
    :js-link( q:to/JS/),
        src="https://unpkg.com/leaflet@1.7.1/dist/leaflet.js"
        integrity="sha512-XQoYMqMTK8LvdxXYG3nZ448hOEQiglfqkJs1NOQV44cWnUrBc8PkAOcXy20w0vlaXaVUearIOBhiXZ5V3ynxwA=="
        crossorigin=""
        JS
    :js-script<leaflet-providers.js>,
    :id<collection-map-id>, # default can be changed by :id in block
    :lat(51.502576), # default can be change by :lat in block
    :long(-3.181823), # default can be changed by :long in block
);
