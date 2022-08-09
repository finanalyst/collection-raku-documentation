%( 
 jq-lib => sub (%prm, %tml) {
'<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>' 
},
js => sub (%prm, %tml) {'<script src="https://unpkg.com/leaflet@1.8.0/dist/leaflet.js"
integrity="sha512-BB3hKbKWOc9Ez/TAwyWxNXeoV9c1v6FIeYiBieIWkpLjauysF18NzgR1MBNBXf8/KABdlkX68nAhlwcDFLGPCQ=="
crossorigin=""
></script>'
~ '<script src="/assets/scripts/ws-filter-scripts.js"></script>'
~ '<script src="/assets/scripts/filter-script.js"></script>'
~ '<script src="/assets/scripts/leaflet-providers.js"></script>'
},
)
