#!/usr/bin/env perl6
use LibCurl::HTTP;
use Text::Diff::Sift4;
use PrettyDump;

sub ($pr, %processed) {
    my %errors = <no-file unknown remote no-target> Z=> {}, {}, {}, {};
    my %links;
    my %targets;
    sub is-target($in-file, $target) {
        my @tars = %targets{$in-file};
        return False if $target ~~ any(@tars);
        my @cands = @tars.grep({ sift4($target, $_) < 4 });
        @tars.elems ?? @tars.join(',') !! 'None'
    }
    my SetHash $files .= new;
    my SetHash $missing .= new;
    my @remote-responses;
    for %processed.kv -> $fn, $podf {
        # not all files have links, but may be targets, so store filenames
        $files{$fn}++;
        # format of podf.links Str entry -> :location :target
        # entry is not needed, but keeps the pair together
        # filter out remote schemas
        %links{$fn} = %(gather for $podf.links {
            if .value<location> eq 'external' {
                push @remote-responses, start {
                    my $http = LibCurl::HTTP.new;
                    my $rv;
                    try {
                        $rv = [$fn, .value<target>, $http.HEAD(.value<target>).perform.response-code];
                    }
                    if $! {
                        $rv = [$fn, .value<target> , $!.message];
                    }
                    $rv
                }
            }
            else {
                take $_
            }
        });
        #format of podf/targets array of target ids
        %targets{$fn} = [$podf.targets.keys];
    }
    # all data collected
    # filter out local schema without #
    for %links.kv -> $fn, %spec {
        # not interested in key of %spec
        for %spec.values -> %registered {
            given %registered<location> {
                when 'local' {
                    if %registered<target> ~~ / ^ <-[#]>+ $ / {
                        my $file = $0;
                        next if $files{$file};
                        # not missing
                        next if $missing{$file};
                        # already registered as missing
                        $missing{$file}++;
                        %errors<no-file>{$fn}.append($file)
                    }
                    elsif %registered<target> ~~ / ^ (<-[#]>+) '#' (.+) $ / {
                        my $file = $0;
                        next if $missing{$file};
                        # already registered as missing
                        unless $files{$file} {
                            $missing{$file}++;
                            %errors<no-file>{$fn}.append($file);
                            next
                        }
                        my $target = $1;
                        unless my $near = is-target($file, $target) {
                            %errors<no-target>{$fn}.push($target => $near)
                        }
                    }
                    # otherwise no action for matches
                }
                when 'internal' and %registered<target> ~~ / ^ '#' (.+) $ / {
                    my $target = $0;
                    if my $near = is-target($fn, $target) {
                        %errors<no-target>{$fn}.push($target => $near)
                    }
                }
                default {
                    %errors<unknown>{$fn}.append(%registered<target>)
                }
            }
        }
    }
    await Promise.allof(@remote-responses);
    for @remote-responses>>.result {
        next if ( +.[2] and .[2] < 400);
        %errors<remote>{ .[0] }.push( .[1] => .[2])
    }
    $pr.add-data('linkerrortest', %errors);
    []
}