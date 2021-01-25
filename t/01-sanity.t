use Test;
plan 2;

constant AUTHOR = ?%*ENV<AUTHOR_TESTING>;

use-ok 'Collection::RakuDocumentation';

if AUTHOR {
    require Test::META <&meta-ok>;
    meta-ok(:relaxed-name);
}
else {
    skip-rest "Skipping author test";
}

done-testing;
