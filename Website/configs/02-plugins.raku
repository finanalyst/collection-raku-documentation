%(
    no-code-escape => True, # must use this when using highlighter
    plugins => 'plugins',
    plugins-required => %(
        :setup(),
        :render<website gather-css>,
        :report<test-link-report>,
        :compilation<website>,
        :completion<cro-app>,
    )
)