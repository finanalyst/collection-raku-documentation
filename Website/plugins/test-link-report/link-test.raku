sub (%processed, @plugins-used, --> Pair ) {
    #%.links{$entry}<target location>
    my @report = 'Link report', ;
    for %processed.kv -> $fn, $podf {
        next unless $podf.links and +$podf.links.keys;
        @report.append: "$fn contains links";
        for $podf.links.kv -> $entry, (:$target, :$location) {
            @report.append: "\t$location target is: $target"
        }
    }
    @report.append: "\n\nPlugin report";
    for @plugins-used {
        @report.append: "Plugins used at ｢{ .key }｣ milestone:";
        for .value.kv -> $plug, %params {
            @report.append: "\t｢$plug｣ called with: ", %params.gist;
        }
    }
    @report.append("\n\nTemplates report");
    for %processed.kv -> $fn, $podf {
        next unless $podf.templates-used;
        @report.append("$fn used\n" ~ $podf.templates-used.raku);
    }
    'link-plugin-report.txt' => @report.join("\n")
}