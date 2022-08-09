%(
    :render,
    :template-raku<leaflet-templates.raku>,
    :custom-raku<leaflet-blocks.raku>,
    :css-link( q:to/CSS/ ),
        href="https://unpkg.com/leaflet@1.8.0/dist/leaflet.css"
        integrity="sha512-hoalWLoI8r4UszCkZ5kL8vayOGVae1oxXe/2A4AO6J9+580uKHDO3JdHb7NzwwzK5xr/Fs0W40kiNHxM9vyTtQ=="
        crossorigin=""
        CSS
    :js-link(q:to/JS/),
        src="https://unpkg.com/leaflet@1.8.0/dist/leaflet.js"
        integrity="sha512-BB3hKbKWOc9Ez/TAwyWxNXeoV9c1v6FIeYiBieIWkpLjauysF18NzgR1MBNBXf8/KABdlkX68nAhlwcDFLGPCQ=="
        crossorigin=""
        JS
    :js-script(['leaflet-providers.js',1]),
    :id<collection-map-id>, # default can be changed by :id in block
    :lat(51.48160), # default can be change by :lat in block
    :long(-3.18070), # default can be changed by :long in block
    :zoom(16), # default can be changed by :long in block
    :provider<OpenStreetMap>,
#    :api-key<????>, # api-key obtained after registration
);
