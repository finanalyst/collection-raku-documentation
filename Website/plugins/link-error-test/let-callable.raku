#!/usr/bin/env perl6
use LibCurl::HTTP;
use PrettyDump;

sub ($pr, %processed) {
    my regex htmlcode {
        \% <[0..9 A..F]> ** 2
    };
    my regex x-htmlcode {
        '%E2' <htmlcode> <htmlcode>
    }
    # only defined for Upper case
    my %errors = <no-file unknown remote no-target> Z=> {}, {}, {}, {};
    my %links;
    my %targets;
    my %config = EVALFILE 'config.raku';
    sub failed-targets($file, Str $target) {
        # straight check
        return () if $target eq any(%targets{$file}.list);
        return ($target,) unless $target ~~ / <htmlcode> /;
        # first check for xhtml
        my $new;
        if $target ~~ / <x-htmlcode> / {
            =comment these are the four codes found in Raku documentation
                %E2%80%A6 \u2026 …
                %E2%88%98 \u2218 ∘
                %E2%88%85 \u2205 ∅
                %E2%80%93 \u2213 ∓

            $new = $target.trans( <%E2%80%A6 %E2%88%98 %E2%88%85 %E2%88%85 >
                             => [ '…',       '∘',      '∅',      '∓']       )
        }
        else {
            # so target has delimited chars
            $new = $target
                    .trans(< %20  %24  %26  %28  %29  %2A  %2B  %2F  %3C  %3E  %3F  %40  %5E   %A6  %BB  %C2  %E2  > =>
                            [' ', '$', '&', '(', ')', '*', '+', '/', '<', '>', '?', '@', '^', '¦', '»', 'Â', 'â']);
        }
        return () if $new eq any(%targets{$file}.list);
        return ($target, $new)
    }
    my SetHash $files .= new;
    my SetHash $missing .= new;
    my @remote-links;
    for %processed.kv -> $fn, $podf {
        # not all files have links, but may be targets, so store filenames
        $files{"/$fn"}++;
        # format of podf.links Str entry -> :location :target
        # entry is not needed, but keeps the pair together
        # filter out remote schemas
        %links{$fn} = %(gather for $podf.links {
            if .value<location> eq 'external' {
                push @remote-links, [$fn, .value<target>, .value<link>]
            }
            else {
                take $_
            }
        });
        #format of podf/targets array of target ids
        %targets{"/$fn"} = [$podf.targets.keys];
    }
    # External tests
    unless %config<no-remote>:exists and %config<no-remote> {
        my $num = @remote-links.elems;
        my $tail = $num ~ ' links  ';
        my $rev = "\b" x $tail.chars;
        my $head = 'Waiting for internet responses on ';
        print  $head ~ $tail;
        my $http = LibCurl::HTTP.new;
        my $start = now;
        for @remote-links -> ($fn, $url, $link) {
            my $resp;
            try {
                $resp = $http.HEAD($url).perform.response-code;
            }
            if $! {
                $resp = $http.error;
            }
            $tail = --$num ~ ' links  ';
            print $rev ~ $tail;
            $rev = "\b" x $tail.chars;
            next if ?(+$resp);
            # any numerical response code indicates http link is live
            next if ($resp ~~ / \:\s(\d\d\d) / and +$0 != 404);
            # failures with non 404 ok as well.
            %errors<remote>{$fn}.push(%( :$url, :$resp, :$link));
        }
        say "\b" x $head.chars ~ $rev ~ "Collected responses on { @remote-links.elems } links in { now - $start } secs";
    }
    # all data collected
    for %links.kv -> $fn, %spec {
        for %spec.kv -> $link, %registered {
            given %registered<location> {
                when 'local' {
                    if %registered<target> ~~ / ^ <-[#]>+ $ / {
                        # filter out local schema without #
                        my $file = ~$/;
                        next if $files{$file};
                        # not missing
                        next if $missing{$file};
                        # already registered as missing
                        $missing{$file}++;
                        %errors<no-file>{$fn}.push(%(
                            :$file,
                            link => %registered<link>
                        ))
                    }
                    elsif %registered<target> ~~ / ^ (<-[#]>+) '#' (.+) $ / {
                        my $file = ~$0;
                        next if $missing{$file};
                        # already registered as missing
                        unless $files{$file} {
                            $missing{$file}++;
                            %errors<no-file>{$fn}.push(%(
                                :$file,
                                link => %registered<link>
                            ));
                            next
                        }
                        my $target = ~$1;
                        # file exists, but is target listed for that file
                        my @failed = failed-targets($file, $target);
                        next unless @failed.elems;
                        %errors<no-target>{$fn}.push(%(
                            :$file,
                            targets => @failed,
                            link => %registered<link>
                        ))
                    }
                    # otherwise no action for matches
                }
                when 'internal' and %registered<target> ~~ / ^ <-[#]>+ $ / {
                    my $target = ~$/;
                    my @failed = failed-targets("/$fn", $target);
                    next unless @failed.elems;
                    %errors<no-target>{$fn}.push(%(
                        file => $fn,
                        targets => @failed,
                        link => %registered<link>
                    ))
                }
                default {
                    %errors<unknown>{$fn}.push(%(
                        link => %registered<link>,
                        url => %registered<target>
                    ))
                }
            }
        }
    }
    $pr.add-data('linkerrortest', %errors);
    []
}