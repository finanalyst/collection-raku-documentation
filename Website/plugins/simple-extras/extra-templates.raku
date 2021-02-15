#
#some extra templates that seemed useful
use v6.d;
%(
    hr => sub (%prm, %tml) {
        if %prm<class>:exists { '<hr class="' ~ %prm<class> ~ '"/>' }
        else { '<hr/>' }
    },
);

