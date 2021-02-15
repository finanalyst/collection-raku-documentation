%(
    no-code-escape => True, # must use this when using highlighter
    plugins => 'plugins',
    plugins-required => %(
        :setup(),
        :render<raku-styling website camelia simple-extras listfiles gather-css>,
        :report<test-link-report>,
        :compilation<website listfiles>,
        :completion<cro-app>,
    )
)