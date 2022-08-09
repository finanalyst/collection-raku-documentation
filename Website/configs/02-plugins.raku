%(
    no-code-escape => True, # must use this when using highlighter
    plugins => 'plugins',
    plugins-required => %(
        :setup<raku-doc-setup>,
        :render<
            raku-styling website camelia simple-extras listfiles images font-awesome filterlines
            leafletmap
            link-error-test
            gather-js-jq gather-css
        >,
        :report<images link-plugin-assets-report>,
        :compilation<website listfiles link-error-test>,
        :completion<cro-app>,
    ),
)