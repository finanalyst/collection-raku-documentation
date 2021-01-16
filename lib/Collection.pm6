use v6.*;
use Terminal::Spinners;
use RakuConfig;
use Pod::From::Cache;
use ProcessedPod;

unit module Collection;

proto sub collect(|) is export {*}

sub refresh(:$no-status, :$recompile, :$no-refresh --> Pod::From::Cache ) {
    # ==== Set options =======
    # both recompile and no-refresh are set in mode-level configurations, so only appear in collect called in a mode call.
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
        for @templates[1 .. *- 1] { $pr.modify-templates(~$_, :path("$mode/templates")) }
        # add plugins if any
        for %config<plugins>.kv -> $plug, %conf {
            %conf<path> = "$mode/plugins/" ~ ( %conf<path> // $plug );
            $pr.add-plugin($plug, |%conf)
            # Since the configuration matches what the add-plugin method expects as named parameters
        }
        $pr.no-code-escape = %config<no-code-escape> if %config<no-code-escape>:exists;

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
