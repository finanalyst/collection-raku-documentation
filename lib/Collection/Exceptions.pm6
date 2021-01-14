use v6.*;

class X::Collection::NoFiles is Exception {
    has $!path;
    has $!comment;
    method message { "｢$!path｣ must contain $!comment" }
}
class X::Collection::MissingKeys is Exception {
    has @.missing;
    method message {
        "The following keys were expected, but not found:"
        ~ @!missing.gist
    }
}
class X::Collection::BadConfig is Exception {
    has $.path;
    has $.response;
    method message { "｢$!path｣ did not evaluate correctly with ｢$!response｣"}
}
class X::Collection::OverwriteKey is Exception {
    has $.path;
    has @.overlap;
    method message { "｢$!path｣ has keys which over-write the existing: " ~ @!overlap.gist }
}