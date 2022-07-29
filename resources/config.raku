use v6.d;
%(
    :cache<doc-cache>, # location relative to collection root of cached Pod
    :sources<raku-docs/doc>, # location of sources
    #| the array of strings sent to the OS by run to obtain sources, eg git clone
    #| assumes CWD set to the directory of collection
    :source-obtain(),
    #:source-obtain<git clone https://github.com/Raku/doc.git raku-docs/>,
    #| the array of strings run to refresh the sources, eg. git pull
    #| assumes CWD set to the directory of sources
    :source-refresh(),
    #:source-refresh<git -C raku-docs/ pull>,
    :!no-status, # show progress
    :mode<Website>, # the default mode, which must exist
    :ignore< 404 HomePage >,
    :extensions< rakudoc pod pod6 raku p6 pm pm6 rakumod >,
    :asset-basename<assets>,
    :asset-paths( %( # type of asset is key, then metadata for that type
        image => %(
            :directory<images>,
            :extensions<png jpeg jpeg svg mp4 webm gif>,
        ),
    )),
)