use v6.d;
use ProcessedPod;
%(
# the following are extra for HTML files and are needed by the render (class) method
# in the source-wrap template.
    'escaped' => sub ( $s ) {
        if $s and $s ne ''
        { $s.trans(qw｢ <    >    &     " ｣ => qw｢ &lt; &gt; &amp; &quot; ｣) }
        else { '' }
    },
    'raw' => sub ( %prm, %tml ) { (%prm<contents> // '') },
    'camelia-img' => sub ( %prm, %tml ) { "\n<camelia />" }, #placeholder
    'camelia-faded' => sub ( %prm, %tml ) { "\n<camelia-faded />" }, #placeholder
    'favicon' => sub ( %prm, %tml ) { "\n<meta>NoIcon</meta>" }, #placeholder
    'css' => sub ( %prm, %tml ) { '' }, #placeholder
    'jq-lib' => sub ( %prm, %tml ) { '' }, #placeholder
    'js' => sub ( %prm, %tml ) { '' }, #placeholder
    'jq' => sub ( %prm, %tml ) { '' }, #placeholder
    'js-bottom' => sub ( %prm, %tml ) { '' }, #placeholder
    'search' => sub ( %prm, %tml ) { '<a href=search.html>Search page</a>' }, #placeholder
    'block-code' => sub ( %prm, %tml ) {
        '<pre class="pod-block-code">'
            ~ (%prm<contents> // '')
            ~ '</pre>'
    },
    'comment' => sub ( %prm, %tml ) { '<!-- ' ~ (%prm<contents> // '') ~ ' -->' },
    'declarator' => sub ( %prm, %tml ) {
        '<a name="' ~ %tml<escaped>(%prm<target> // '')
            ~ '"></a><article><code class="pod-code-inline">'
            ~ ( %prm<code> // '') ~ '</code>' ~ (%prm<contents> // '') ~ '</article>'
    },
    'dlist-start' => sub ( %prm, %tml ) { "<dl>\n" },
    'defn' => sub ( %prm, %tml ) {
        '<dt>'
            ~ %tml<escaped>(%prm<term> // '')
            ~ '</dt><dd>'
            ~ (%prm<contents> // '')
        ~ '</dd>'
    },
    'dlist-end' => sub ( %prm, %tml ) { "\n</dl>" },
    'format-b' => gen-closure-template('strong'),
    'format-c' => gen-closure-template('code'),
    'format-i' => gen-closure-template('em'),
    'format-k' => gen-closure-template('kbd'),
    'format-r' => gen-closure-template('var'),
    'format-t' => gen-closure-template('samp'),
    'format-u' => gen-closure-template('u'),
    'para' => gen-closure-template('p'),
    'format-l' => sub ( %prm, %tml ) {
        # transform a local file with an internal target
        my $trg = %prm<target>;
        if %prm<local> {
            if $trg ~~ / (<-[#]>+) '#' (.+) $ / {
                $trg = "$0\.html\#$1";
            }
            else {
                $trg ~= '.html'
            }
        }
        elsif %prm<internal> {
            $trg = "#$trg"
        }

        '<a href="'
            ~ $trg
            ~ '"'
            ~ ( %prm<class> ?? (' class="' ~ %prm<class> ~ '"') !! '')
            ~ '>'
            ~ (%prm<contents> // '')
            ~ '</a>'
    },
    'format-n' => sub ( %prm, %tml ) {
        '<sup class="content-footnote"><a name="'
                ~ %tml<escaped>(%prm<retTarget>)
                ~ '" href="#' ~ %tml<escaped>(%prm<fnTarget>)
                ~ '">[' ~ %tml<escaped>(%prm<fnNumber>)
                ~ "]</a></sup>\n"
    },
    'format-p' => sub ( %prm, %tml ) {
        '<div><pre>'
                ~ (%prm<contents> // '').=trans(['<pre>', '</pre>'] => ['&lt;pre&gt;', '&lt;/pre&gt;'])
                ~ "</pre></div>\n"
    },
    'format-x' => sub ( %prm, %tml ) {
        '<a name="' ~ (%prm<target> // '') ~ '"></a>'
                ~ ( ( %prm<text>.defined and %prm<text> ne '' ) ?? '<span class="glossary-entry">' ~ %prm<text> ~ '</span>' !! '')
    },
    'heading' => sub ( %prm, %tml ) {
        '<h' ~ (%prm<level> // '1')
            ~ ' id="'
            ~ %tml<escaped>(%prm<target>)
            ~ '"><a href="#'
            ~ %tml<escaped>(%prm<top>)
            ~ '" class="u" title="go to top of document">'
            ~ (( %prm<text>.defined && %prm<text> ne '') ?? %prm<text> !! '')
            ~ '</a></h'
            ~ (%prm<level> // '1')
            ~ ">\n"
    },
    'image' => sub ( %prm, %tml ) { '<img src="' ~ (%prm<src> // 'path/to/image') ~ '"'
            ~ ' width="' ~ (%prm<width> // '100px') ~ '"'
            ~ ' height="' ~ (%prm<height> // 'auto') ~ '"'
            ~ ' alt="' ~ (%prm<alt> // 'XXXXX') ~ '"'
            ~ ( %prm<class>:exists ?? (' class"' ~ %prm<class>  ~ '"') !! '' )
            ~ ( %prm<id>:exists ?? (' class"' ~ %prm<id>  ~ '"') !! '' )
            ~ '>'
    },
    'item' => sub ( %prm, %tml ) {
        '<li' ~ ( %prm<class> ?? (' class="' ~ %prm<class> ~ '"') !! '' ) ~ '>'
        ~ (%prm<contents> // '')
        ~ "</li>\n"
    },
    'list' => sub ( %prm, %tml ) {
        "<ul>\n"
                ~ %prm<items>.join
                ~ "</ul>\n"
    },
    'named' => sub ( %prm, %tml ) {
        "<section>\n<h"
                ~ (%prm<level> // '1') ~ ' id="'
                ~ %tml<escaped>(%prm<target>) ~ '"><a href="#'
                ~ %tml<escaped>(%prm<top> // '')
                ~ '" class="u" title="go to top of document">'
                ~ (( %prm<name>.defined && %prm<name> ne '' ) ?? %prm<name> !! '')
                ~ '</a></h' ~ (%prm<level> // '1') ~ ">\n"
                ~ (%prm<contents> // '')
                ~ (%prm<tail> // '')
                ~ "\n</section>\n"
    },
    'output' => sub ( %prm, %tml ) { '<pre class="pod-output">' ~ (%prm<contents> // '') ~ '</pre>' },
    'pod' => sub ( %prm, %tml ) {
        '<section name="'
                ~ %tml<escaped>(%prm<name> // '') ~ '">'
                ~ (%prm<contents> // '')
                ~ (%prm<tail> // '')
                ~ '</section>'
    },
    'table' => sub ( %prm, %tml ) {
        '<table class="pod-table'
                ~ ( ( %prm<class>.defined and %prm<class> ne '' ) ?? (' ' ~ %tml<escaped>(%prm<class>)) !! '')
                ~ '">'
                ~ ( ( %prm<caption>.defined and %prm<caption> ne '' ) ?? ('<caption>' ~ %prm<caption> ~ '</caption>') !! '')
                ~ ( ( %prm<headers>.defined and %prm<headers> ne '' ) ??
        ("\t<thead>\n"
                ~ [~] %prm<headers>.map({ "\t\t<tr><th>" ~ .<cells>.join('</th><th>') ~ "</th></tr>\n"})
                        ~ "\t</thead>"
        ) !! '')
                ~ "\t<tbody>\n"
                ~ ( ( %prm<rows>.defined and %prm<rows> ne '' ) ??
        [~] %prm<rows>.map({ "\t\t<tr><td>" ~ .<cells>.join('</td><td>') ~ "</td></tr>\n" })
        !! '')
                ~ "\t</tbody>\n"
                ~ "</table>\n"
    },
    'top-of-page' => sub ( %prm, %tml ) {
        if %prm<title-target>:exists and %prm<title-target> ne '' {
            '<div id="' ~ %tml<escaped>(%prm<title-target>) ~ '" class="top-of-page"></div>'
        }
        else { '' }
    },
    'title' => sub ( %prm, %tml) {
        if %prm<title>:exists and %prm<title> ne '' {
            '<h1 class="title"'
                    ~ ((%prm<title-target>:exists and %prm<title-target> ne '')
                    ?? ' id="' ~ %tml<escaped>(%prm<title-target>) !! '' ) ~ '">'
                    ~ %prm<title> ~ '</h1>'
        }
        else { '' }
    },
    'subtitle' => sub ( %prm, %tml ) {
        if %prm<subtitle>:exists and %prm<subtitle> ne '' {
            '<div class="subtitle">' ~ %prm<subtitle> ~ '</div>' }
        else { '' }
    },
    'source-wrap' => sub ( %prm, %tml ) {
        "<!doctype html>\n"
                ~ '<html lang="' ~ ( ( %prm<lang>.defined and %prm<lang> ne '' ) ?? %tml<escaped>(%prm<lang>) !! 'en') ~ "\">\n"
                ~ %tml<head-block>(%prm, %tml)
                ~ "\t<body class=\"pod\">\n"
                ~ %tml<header>(%prm, %tml)
                ~ '<div class="pod-content">'
                ~ ( (%prm<toc> or %prm<glossary>) ?? '<nav>' !! '')
                ~ (%prm<toc> // '')
                ~ (%prm<glossary> // '')
                ~ ( (%prm<toc> or %prm<glossary>) ?? '</nav>' !! '')
                ~ %tml<top-of-page>(%prm, %tml)
                ~ %tml<subtitle>(%prm, %tml)
                ~ '<div class="pod-body">'
                ~ (%prm<body> // '')
                ~ "\t\t</div>\n"
                ~ '</div>'
                ~ (%prm<footnotes> // '')
                ~ %tml<footer>(%prm, %tml)
                ~ %tml<js-bottom>({},{})
                ~ "\n\t</body>\n</html>\n"
    },
    'footnotes' => sub ( %prm, %tml ) {
        with %prm<notes> {
            if .elems {
            "<div id=\"_Footnotes\" class=\"footnotes\">\n"
                ~ [~] .map({ '<div class="footnote" id="' ~ %tml<escaped>($_<fnTarget>) ~ '">'
                    ~ ('<span class="footnote-number">' ~ ( $_<fnNumber> // '' ) ~ '</span>')
                    ~ ($_<text> // '')
                    ~ '<a class="footnote-linkback" href="#'
                    ~ %tml<escaped>($_<retTarget>)
                    ~ "\"> « Back »</a></div>\n"
                })
                ~ "\n</div>\n"
            }
            else { '' }
        }
        else { '' }
    },
    'glossary' => sub ( %prm, %tml ) {
        if %prm<glossary>.defined and %prm<glossary>.keys {
            '<div id="_Glossary" class="glossary">' ~ "\n"
                    ~ '<div class="glossary-caption">Glossary</div>' ~ "\n"
                    ~ '<div class="glossary-defn header">Term explained</div><div class="glossary-place header">In section</div>'
                    ~ [~] %prm<glossary>.map({
                        '<div class="glossary-defn">'
                        ~ ($_<text> // '')
                        ~ '</div>'
                        ~ [~] $_<refs>.map({
                            '<div class="glossary-place"><a href="#'
                                    ~ %tml<escaped>($_<target>)
                                    ~ '">'
                                    ~ ($_<place>.defined ?? $_<place> !! '')
                                    ~ "</a></div>\n"
                        })
                    })
                    ~ "</div>\n"
        }
        else { '' }
    },
    'meta' => sub ( %prm, %tml ) {
        with %prm<meta> {
            [~] %prm<meta>.map({
                '<meta name="' ~ %tml<escaped>( .<name> )
                        ~ '" value="' ~ %tml<escaped>( .<value> )
                        ~ "\" />\n"
            })
        }
        else { '' }
    },
    'toc' => sub ( %prm, %tml ) {
        if %prm<toc>.defined and %prm<toc>.keys {
            "<div id=\"_TOC\"><table>\n<caption>Table of Contents</caption>\n"
                    ~ [~] %prm<toc>.map({
                '<tr class="toc-level-' ~ .<level> ~ '">'
                        ~ '<td class="toc-text"><a href="#'
                        ~ %tml<escaped>( .<target> )
                        ~ '">'
                        ~ %tml<escaped>(  $_<text> // '' )
                        ~ "</a></td></tr>\n"
            })
                    ~ "</table></div>\n"
        }
        else { '' }
    },
    'head-block' => sub ( %prm, %tml ) {
        "\<head>\n"
                ~ '<title>' ~ %tml<escaped>(%prm<title>) ~ "\</title>\n"
                ~ '<meta charset="UTF-8" />' ~ "\n"
                ~ %tml<favicon>({},{})
                ~ (%prm<metadata> // '')
                ~ %tml<jq-lib>({},{})
                ~ %tml<js>({},{})
                ~ %tml<css>({},{})
                ~ "\</head>\n"
    },
    'header' => sub ( %prm,%tml) {
        "\n<header>\n"
                ~ '<div class="home" ><a href="/index.html">' ~ %tml<camelia-img>(%prm, %tml) ~ '</a></div>'
                ~ '<div class="page-title">' ~ %prm<title> ~ "</div>\n"
                ~ '<a class="error-report" href="/error-report.html">Error Report</a>'
                ~ '<a class="extra" href="/collection-examples.html">Collection examples</a>'
                ~ '<div class="menu">' ~ "\n"
                ~ '<a href="https://raku.org"><div class="menu-item">Raku homepage</div></a>'
                ~ '<a href="/language.html"><div class="menu-item">Language</div></a>'
                ~ '<a href="/search.html"><div class="menu-item">Search Site</div></a>'
                ~ '<a href="/types.html"><div class="menu-item">Types</div></a>'
                ~ '<a href="/programs.html"><div class="menu-item">Programs</div></a>'
                ~ "</div></header>\n"
    },
    'footer' => sub ( %prm, %tml ) {
        '<footer><div>Rendered from <span class="path">'
                ~ (( %prm<path>.defined && %prm<path> ne '') ?? %tml<escaped>(%prm<path>) !! '')
                ~ '</span></div>'
                ~ '<!-- filename = ' ~ %prm<name> ~ '-->'
                ~ '<div>at <span class="time">'
                ~ (( %prm<renderedtime>.defined && %prm<path> ne '') ?? %tml<escaped>(%prm<renderedtime>) !! 'a moment before time began!?')
                ~ '</span></div>'
                ~ '</footer>'
    },
)