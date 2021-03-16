use v6.d;

my @remote-responses;
my %errors;
my $fn = 'open-file-test';

for "$fn\.txt".IO.lines -> $ln {
    my $proc = Proc::Async.new('curl', '-I', '-s', "$ln");
    @remote-responses.push: [$fn,$ln,$proc.Supply.first.Promise];
    $proc.start;
}

await Promise.allof(@remote-responses>>.[2]);
for @remote-responses {
    my $resp = .[2].result;
    say $_[0],' ', $_[1],' ', $resp;
    with $resp {
        $resp = .comb(/ \d\d\d /)[0];
    }
    else {
        $resp = 'Could not find host'
    }
    next if ( ?(+$resp ) and $resp != 404 );
    %errors<remote>{ .[0] }.push( .[1] => $resp)
}

my %tmp = %(
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
);

my $rv = %tmp<linkerrortest>.( {:linkerrortest( %errors )} , {} );
"$fn.html".IO.spurt(qq:to/HTML/);
    <html>
        <head>
            <link rel="stylesheet" href="let-styling.css">
        </head>
        <body>
           $rv
        </body>
    </html>
    HTML

use Cro::HTTP::Router;
use Cro::HTTP::Server;
use Cro::HTTP::Log::File;

my ( $destination, $landing, $ext, %config ) = ( '.', $fn, 'html', { :host<localhost>, :port(30000) } );
my $app = route {
    get -> *@path {
        static "$destination", @path,:indexes( "$landing\.$ext", );
    }
}
my Cro::Service $http = Cro::HTTP::Server.new(
        http => <1.1>,
        host => %config<host> // 'localhost',
        port => %config<port> // 30000,
        application => $app,
        after => [
            Cro::HTTP::Log::File.new(logs => $*OUT, errors => $*ERR)
        ]
        );
say "Serving $landing on %config<host>\:%config<port>";
$http.start;
react {
    whenever signal(SIGINT) {
        say "Shutting down...";
        $http.stop;
        done;
    }
}