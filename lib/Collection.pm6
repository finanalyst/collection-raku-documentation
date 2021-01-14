use v6.*;
use Terminal::Spinners;
use Collection::Exceptions;
use Pod::From::Cache;
use ProcessedPod;
use PrettyDump;

unit module Collection;

proto sub collect(|) is export {*}

sub refresh(:$no-status, :$recompile, :$no-refresh --> Pod::From::Cache ) {
    # ==== Set options =======
    # both recompule and no-refresh are set in mode-level configurations, so only appear in collect called in a mode call.
    my %config = get-config(:required< no-status cache sources source-obtain source-refresh mode >);
    my Bool $no-st = $no-status // %config<no-status>;

    rm-cache(%config<cache>) if $recompile;
    #removing the cache forces a recompilation

    # recompile may be needed for existing, unrefreshed sources, so recompile != !no-refresh
    unless $no-refresh or ! %config<source-refresh> {
        my $proc = run %config<source-refresh>.list, :err, :out;
        my $proc-rv = $proc.err.get;
        exit note $proc-rv if $proc-rv;
    }
    Pod::From::Cache.new(
            :doc-source(%config<sources>),
            :cache-path(%config<cache>),
            :progress($no-st ?? Nil !! &counter));
}

multi sub collect(:$no-refresh, :$recompile, :$no-status, :$no-rerender, :$full-render) {
    my $mode = get-config(:required('mode', ))<mode>;
    collect($mode, :$no-refresh, :$recompile, :$no-status, :$no-rerender, :$full-render)
}

multi sub collect(Str $mode, :$no-refresh, :$recompile, :$no-status, :$no-rerender, :$full-render) {
    return refresh(:$no-refresh, :$no-status, :$no-rerender, :$full-render)
        if $mode eq 'Refresh';
    exit note "$mode is not a direct sub-directory of the oollection"
        unless "$*CWD/$mode".IO.d and $mode ~~ / ^ [\w | '-' | '_']+ $ /;
    my %config = get-config(:required< no-status mode>);
    %config  ,= get-config(:path("$mode/config"), :required< no-refresh recompile no-rerender full-render plugins>);

    my $noreren = $no-rerender // %config<no-rerender>;
    my $fullren = $full-render // %config<full-render>;
    # verify output directory exists, and set to fill.
    unless "$*CWD/$mode/%config<destination>".IO.d {
        "$*CWD/$mode/%config<destination>".IO.mkdir;
        $fullren = True;
    }

    my $cache = refresh(
        :$no-status,
        :recompile($recompile // %config<recompile>),
        :no-refresh($no-refresh // %config<no-refresh>)
    );

    unless $noreren {
        # Prepare the renderer
        # get the template names
        my @templates = "$*CWD/$mode/templates".IO.dir(test => / '.raku' /).sort;
        exit note "There must be templates in ｢~/{ "$*CWD/$mode/templates".IO.relative($*HOME) }｣:"
            unless +@templates;
        my ProcessedPod $pr .= new;
        $pr.templates(~@templates[0]);
        for @templates[1 .. *- 1] { $pr.modify-templates(~$_) }
        # add plugins if any
        for %config<plugins>.list -> %pl {
            $pr.add-plugin(%pl<name>, :path(%pl<path>), :name-space(%pl<name-space>))
        }
        my @files = $fullren ?? $cache.sources.list !! $cache.list-files.list;
        my %processed;
        counter(:start(+@files), :header('Rendering files'));
        # sort files so that longer come later, meaning sub-directories appear after parents
        # when creating the sub-directory
        for @files.sort -> $fn {
            counter(:dec);
            my $short = $fn.IO.extension('').Str.subst( / ^ $(%config<sources>) \/ /,'');
            with "$mode/%config<destination>/$short".IO.dirname {
                .IO.mkdir unless .IO.d
            }
            with $pr {
                .name = $fn;
                .process-pod($cache.pod($fn));
                .file-wrap(:filename("$mode/%config<destination>/$short"), :ext(%config<output-ext>));
                %processed{ $fn } = .emit-and-renew-processed-state;
            }
        }
    }
}

#| :path is relative to Collection directory,
#| if given, should be a directory containing .raku files
#| :required are the keys needed in a config after all .raku files are evaluated
#| at least one config key should be required.
#| this sub is used to get template files as well
sub get-config(:$path = 'config.raku', :@required!, --> Hash)
        is export {
    state %config;
    state $prev-path;
    return %config if $prev-path and $path eq $prev-path and %config.keys (>=) @required;

    $prev-path = $path;
    %config = Empty;
    if $path eq 'config.raku' {
        X::Collection::NoFiles.new(:path('Collection root'), :comment($path)).throw
        unless 'config.raku'.IO.f;
        %config = EVALFILE $path;
        CATCH {
            default {
                X::Collection::BadConfig.new(:$path, :response(.gist)).throw
            }
        }
    }
    elsif "$*CWD/$path".IO.d {
        my @files = "$*CWD/$path".IO.dir(test => / '.raku' /).sort>>.Str;
        X::Collection::NoFiles.new(:$path, :comment('config files')).throw
        unless +@files;
        for @files -> $file {
            my %partial = EVALFILE "$file";
            CATCH {
                default {
                    X::Collection::BadConfig.new(:path($path.subst(/ ^ "$*CWD" '/' /, '')), :response(.gist)).throw
                }
            }
            my @overlap = (%config.keys (&) %partial.keys).keys;
            X::Collection::OverwriteKey
                    .new(:path($path.subst(/ ^ "$*CWD" '/' /, '')), :@overlap)
                    .throw
            if +@overlap;
            %config  ,= %partial
            # merge partial into config

        }
    }
    X::Collection::MissingKeys.new(:missing((@required (-) %config.keys).keys.flat)).throw
        unless %config.keys (>=) @required;
    # the keys on the RHS above are required in %config. To throw here, the templates supplied are not
    # a superset of the required keys.
    %config
}

sub counter(:$start, :$dec, :$header = 'Caching files ' ) {
    state $hash-bar = Bar.new(:type<bar>);
    state $inc;
    state $done;
    if $start {
        $inc = 1 / $start * 100;
        $done = 0;
        say $header;
        $hash-bar.show: 0
    }
    if $dec {
        $done += $inc;
        $hash-bar.show: $done;
    }
}

sub compile-dump($ds --> Str) {
    my $pretty = PrettyDump.new;
    my $pair-code = -> PrettyDump $pretty, $ds, Int:D :$depth = 0 --> Str {
        [~]
        $ds.key,
        ' => ',
        $pretty.dump: $ds.value, :depth(0)

    };
    my $hash-code = -> PrettyDump $pretty, $ds, Int:D :$depth = 0 --> Str {
        my $longest-key = $ds.keys.max: *.chars;
        my $template = "%-{ 2 + $depth + 1 + $longest-key.chars }s => %s";

        my $str = do {
            if @($ds).keys {
                my $separator = [~] $pretty.pre-separator-spacing, ',', $pretty.post-separator-spacing;
                [~]
                $pretty.pre-item-spacing,
                join($separator,
                        grep { $_ ~~ Str:D },
                                map {
                                    /^ \t* '｢' .*? '｣' \h+ '=>' \h+/
                                            ??
                                            sprintf($template, .split: / \h+ '=>' \h+  /, 2)
                                            !!
                                            $_
                                },
                                        map { $pretty.dump: $_, :depth($depth + 1) }, $ds.pairs
                ),
                $pretty.post-item-spacing;
            }
            else {
                $pretty.intra-group-spacing;
            }
        }

        "\%($str)"
    }
    my $match-code = -> PrettyDump $pretty, $ds, Int:D :$depth = 0 --> Str {
        $pretty.Match($ds, :start</>, :end</>)
    };
    my $array-code = -> PrettyDump $pretty, $ds, Int:D :$depth = 0 --> Str {
        $pretty.Array($ds, :start<[>)
    };
    my $list-code = -> PrettyDump $pretty, $ds, Int:D :$depth = 0 --> Str {
        $pretty.List($ds, :start<(>)
    };

    $pretty.add-handler: 'Pair', $pair-code;
    $pretty.add-handler: 'Hash', $hash-code;
    $pretty.add-handler: 'Array', $array-code;
    $pretty.add-handler: 'Match', $match-code;
    $pretty.add-handler: 'List', $list-code;
    $pretty.dump: $ds
}