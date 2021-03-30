use v6.d;
use LibCurl::HTTP;
use PrettyDump;

my @remote-responses;
my %errors;
my $fn = 'link-plugin-report';
my $doc;
my $ref;
my @inputs;
my $count = 0;

for "$fn\.txt".IO.lines -> $ln {
    if $ln ~~ / ^ (\S+) \s .+ $ / {
        $doc = ~$0;
        next
    }
    elsif $ln ~~ / ^ \s+ 'external target is: ' (.+) $ / {
        $ref = ~$0;
    }
    else { next }
    say "at $?LINE doc $doc ref $ref ";
    push @inputs, %( $doc => $ref);
    push @remote-responses, start {
        my $http = LibCurl::HTTP.new;
        my $rv;
        try {
            $rv = $http.HEAD(@inputs[*- 1].value).perform.response-code;
        }
        if $! {
            $rv = $http.error;
        }
        say "at $?LINE doc { @inputs[*- 1].key } ref { @inputs[ *-1] } rv $rv";
        $rv
    };
}
$doc = $ref = Nil;

say "Waiting for internet response";
await Promise.allof(@remote-responses);
say "After await, took { now - INIT { now } } secs";
for @remote-responses.kv -> $n, $prom {
    my $resp = $prom.result;
    #    next if ?(+$resp); # any numerical response code indicates http link is live
    #    next if ( $resp ~~ / \:\s(\d\d\d) / and $0 != 404 ); # failures with non 404 ok as well.
    %errors<remote>{@inputs[$n].key}.push(@inputs[$n].value => $resp)
}
'test-store'.IO.spurt: pretty-dump(%errors);
#my %tmp = %(
#    linkerrortest => sub (%prm, %tml) {
#        my $data = %prm<linkerrortest>;
#        # structure: no-file|no-target|unknown|remote
#        my %titles = <no-file no-target unknown remote >
#                Z=> 'Links to missing files', 'Links to Bad Interior Targets',
#                    'Unknown target schema', 'Bad response code from remote site';
#        my $rv = '';
#        for $data.kv -> $type, %object {
#            next unless %object.elems;
#            $rv ~= '<h2>' ~ %titles{$type} ~ "</h2>\n";
#            for %object.kv -> $fn, $resp {
#                when $type eq any(<no-file unknown>) {
#                    $rv ~= '<div class="let-file">' ~ $fn;
#                    for $resp.list {
#                        $rv ~= '<div class="let-links">'
#                                ~ %tml<escaped>($_)
#                                ~ '</div>'
#                    }
#                    $rv ~= "</div>\n";
#                }
#                when $type eq any(<no-target remote>) {
#                    $rv ~= '<div class="let-file">' ~ $fn;
#                    for $resp.list {
#                        $rv ~= '<div class="let-links">'
#                                ~ %tml<escaped>( .key )
#                                ~ '<div class="let-response ' ~ ( (?(+ .value) and .value < 400) ?? 'ok' !! '') ~ '">'
#                                ~ .value
#                                ~ ' <a class="live-link" href="' ~ .key ~ '">Live link</a>'
#                                ~ "</div></div>\n"
#                    }
#                    $rv ~= "</div>\n";
#                }
#            }
#        }
#        $rv
#    },
#);
#
#my $rv = %tmp<linkerrortest>.( {:linkerrortest( %errors )} , {} );
#"$fn.html".IO.spurt(qq:to/HTML/);
#    <html>
#        <head>
#            <link rel="stylesheet" href="let-styling.css">
#        </head>
#        <body>
#           $rv
#        </body>
#    </html>
#    HTML
#use Cro::HTTP::Router;
#use Cro::HTTP::Server;
#use Cro::HTTP::Log::File;
#
#my ( $destination, $landing, $ext, %config ) = ( '.', $fn, 'html', { :host<localhost>, :port(30000) } );
#my $app = route {
#    get -> *@path {
#        static "$destination", @path,:indexes( "$landing\.$ext", );
#    }
#}
#my Cro::Service $http = Cro::HTTP::Server.new(
#        http => <1.1>,
#        host => %config<host> // 'localhost',
#        port => %config<port> // 30000,
#        application => $app,
#        after => [
#            Cro::HTTP::Log::File.new(logs => $*OUT, errors => $*ERR)
#        ]
#        );
#say "Serving $landing on %config<host>\:%config<port>";
#$http.start;
#react {
#    whenever signal(SIGINT) {
#        say "Shutting down...";
#        $http.stop;
#        done;
#    }
#}