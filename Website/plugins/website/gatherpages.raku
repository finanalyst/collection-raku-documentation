sub ($pr, %processed) {
    for <toc footnotes glossary meta> -> $component {
        #%data contains keys for each source and sub-keys for each page component
        # what is required is to make the structure pointed to by raw-component available
        # to a collection structure with sub-keys of filenames
        $pr.add-data("collection-$component",
                %( |gather for %processed.keys {
                    take $_ => %processed{$_}{"raw-$component"} }) )
    }
}