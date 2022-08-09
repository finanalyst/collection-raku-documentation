#!/usr/bin/env perl6
%(
    :render<js-collator.raku>,
    :jquery-lib<https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js>,
    :template-raku<js-templates.raku>, # Will be written by js-collator
    :custom-raku(), # no custom blocks
)