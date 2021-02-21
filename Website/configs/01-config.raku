%(
    :!no-refresh, # do not call the refresh step after the first run
    :!recompile, # if true, force a recompilation of the source files when refresh is called
    :!full-render, # force rendering of all output files
    :!no-report, # do not make a report - default is False, but set True
    :!no-completion, # we want the Cro app to start
    :mode-sources<structure-sources>, # content for the website structure
    :mode-cache<structure-cache>, # cache for the above
    :mode-ignore(), # no files to ignore
    :mode-obtain(), # not a remote repository
    :mode-refresh(), # ditto
    :!collection-info, # show milestone data
    :mode-extensions<rakudoc pod6>, # only use these for content
    :destination<../html>, # where the html files will be sent relative to Mode directory
    :asset-out-path<assets>, # where the image assets will be sent relative to destination
    :landing-place<index>, # the first file
    :report-path<reports>,
    :output-ext<html>,
    :templates<templates>,
    completion-options => %(
        :port<30000>,
        :host<0.0.0.0>,
    ),
)