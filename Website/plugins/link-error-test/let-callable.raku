#!/usr/bin/env perl6
use LibCurl::HTTP;
use PrettyDump;

sub ($pr, %processed) {
    my regex htmlcode { \% <[0..9 A..F]>**2 }; # only defined for Upper case
    my %errors = <no-file unknown remote no-target> Z=> {}, {}, {}, {};
    my %links;
    my %targets;
    sub failed-targets( $file, Str $target) {
        # straight check
        return () if $target eq any( %targets{ $file }.list );
        return ($target,) unless $target ~~ / <htmlcode> /;
        # so target has delimited chars
        my $new = $target.trans( < %20  %24  %26  %28  %29  %2A  %2B  %2F  %3C  %3E  %3F  %40  %5E   %80      %85        %88       %98      %A6  %BB  %C2  %E2  > =>
                                 [ ' ', '$', '&', '(', ')', '*', '+', '/', '<', '>', '?', '@', '^', '&#128;', '&#133;', '&#136;', '&#152;', '¦', '»', 'Â', 'â'] );
        return () if $new eq any( %targets{ $file }.list );
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
                push @remote-links, [$fn, .value<target>, .value<link> ]
            }
            else {
                take $_
            }
        });
        #format of podf/targets array of target ids
        %targets{"/$fn"} = [$podf.targets.keys];
    }
    # start requesting HTTP responses as soon as possible.
    my $num = @remote-links.elems;
    my $tail = $num ~ ' links  ';
    my $rev = "\b" x $tail.chars;
    my $head = 'Waiting for internet responses on ';
    print  $head ~ $tail;
    my $http = LibCurl::HTTP.new;
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
        next if ?(+$resp); # any numerical response code indicates http link is live
        next if ( $resp ~~ / \:\s(\d\d\d) / and +$0 != 404 ); # failures with non 404 ok as well.
        %errors<remote>{$fn}.push(%( :$url, :$resp, :$link ));
    }
    say "\b" x $head.chars ~ $rev ~ "Collected responses on { @remote-links.elems } links";
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