use PrettyDump;
sub (%processed, @plugins-used, $processedpod --> Pair ) {
    #%.links{$entry}<target location>
    my @report = 'Link report', ;
    for %processed.kv -> $fn, $podf {
        next unless $podf.links and +$podf.links.keys;
        @report.append: "$fn contains links";
        for $podf.links.kv -> $entry, (:$target, :$location, :$link) {
            @report.append: "\t｢$link｣ points to a(n) $location target at ｢$target｣"
        }
    }
    @report.append: "\n\nPlugin report";
    for @plugins-used {
        @report.append: "Plugins used at ｢{ .key }｣ milestone:";
        @report.append( "\tNone" ) unless .value.elems;
        for .value.list -> (:key($plug), :value(%params)) {
            @report.append("\t｢$plug｣ called with: " ~ pretty-dump( %params).subst(/\n/,"\n\t\t",:g));
        }
    }
    @report.append("\n\nTemplates report");
    for %processed.kv -> $fn, $podf {
        next unless $podf.templates-used;
        @report.append("｢$fn｣ used:");
        # decreasing sort by number of times used
        for $podf.templates-used.sort(- *.value) -> (:key($tmp), :value($times) ) {
            @report.append("\t$tmp: $times times(s)")
        }
    }
    'link-plugin-report.txt' => @report.join("\n")
}