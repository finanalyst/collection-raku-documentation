#!/usr/bin/env perl6
use PrettyDump;
%(
    linkerrortest => sub (%prm, %tml) {
        my $data = %prm<linkerrortest>;
        # structure: no-file|no-target|unknown|remote
        my %titles = <no-file no-target unknown remote >
                Z=> 'Links to missing files', 'Links to Bad Interior Targets',
                    'Unknown target schema', 'Bad response code from remote site';
        my $rv = '';
        for $data.kv -> $type, %object {
            next unless %object.elems;
            $rv ~= '<h2>' ~ %titles{$type} ~ "</h2>\n";
            for %object.kv -> $fn, $resp {
                when $type eq any(<no-file unknown>) {
                    $rv ~= '<div class="let-file">' ~ $fn;
                    for $resp.list {
                        $rv ~= '<div class="let-links">'
                            ~ %tml<escaped>($_)
                            ~ '</div>'
                    }
                    $rv ~= "</div>\n";
                }
                when $type eq any(<no-target remote>) {
                    $rv ~= '<div class="let-file">' ~ $fn;
                    for $resp.list {
                        $rv ~= '<div class="let-links">'
                            ~ %tml<escaped>( .key )
                                ~ '<div class="let-response ' ~ ( (?(+ .value) and .value < 400) ?? 'ok' !! '') ~ '">'
                                ~ .value
                                ~ ' <a class="live-link" href="' ~ .key ~ '">Live link</a>'
                                ~ "</div></div>\n"
                    }
                    $rv ~= "</div>\n";
                }
            }
        }
        $rv
    },
)