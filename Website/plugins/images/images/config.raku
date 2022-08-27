#!/usr/bin/env perl6
%(
    :render<image-helper.raku>,
    :template-raku<image-templates.raku>,
    :custom-raku<image-blocks.raku>,
    :css<image-styling.css>,
    :transfer<image-collector.raku>,
);
