#
#some extra templates that seemed useful
use v6.*;
%(
    hr => sub (%prm, %tml) {
        if %prm<class>:exists { '<hr class="' ~ %prm<class> ~ '"/>' }
        else { '<hr/>' }
    },
);

