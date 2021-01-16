%(
    :!no-refresh, # do not call the refresh step after the first run
    :!recompile, # if true, force a recompilation of the source files when refresh is called
    :!no-rerender, # do not rerender output files
    :!full-render, # force rendering of all output files
    templates => 'templates',
    app-path => 'app',
    app-port => '3000',
    destination => 'html',
    output-ext => 'html',
    app-root => 'index',

)