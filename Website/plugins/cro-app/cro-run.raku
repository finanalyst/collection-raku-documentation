use Cro::HTTP::Router;
use Cro::HTTP::Server;
use Cro::HTTP::Log::File;

sub ( $destination, $landing, $ext, %config, %options ) {
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
    say "Serving $landing on %config<host>\:%config<port>" unless %options<no-status>;
    $http.start;
    react {
        whenever signal(SIGINT) {
            say "Shutting down..." unless %options<no-status>;
            $http.stop;
            done;
        }
    }
}