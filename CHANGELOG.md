# Changelog

----
----
## Table of Contents
[2021-01-22 Spin off Collection into its own Module](#2021-01-22-spin-off-collection-into-its-own-module)  
[2021-01-25 Change name to reflect Collection hierarchy](#2021-01-25-change-name-to-reflect-collection-hierarchy)  
[2021-02-06 HTML Rendering working fully](#2021-02-06-html-rendering-working-fully)  
[2021-02-21 v0.5](#2021-02-21-v05)  
[2021-02-21 v0.6](#2021-02-21-v06)  
[2021-02-27 v0.7](#2021-02-27-v07)  

----
# 2021-01-22 Spin off Collection into its own Module
*  the intention was always for Raku-Alt-Documentation to be the first collection, but not the last.

*  This module now has a small initialisation file and binary to start it

*  The focus in this module will be on plugins, templates, and Website source files

# 2021-01-25 Change name to reflect Collection hierarchy
*  Renamed various files/entities to reflect new names

*  Shortened README, removing most option/plugin/stage information to Collection docs.

# 2021-02-06 HTML Rendering working fully
*  Glossary TOC Footnote generated for whole site using Website block

*  Major work on Collection to get plugins to work consistently

# 2021-02-21 v0.5
*  Added plugin to manage images

*  Added plugin for FontAwesome

*  Changed header to have link to a Collections example page (instead of webchat)

*  Started work on gather-css to add and link css. Flaws encountered, TODO

*  Added search button header. leads to page under construction.

# 2021-02-21 v0.6
*  added qjuery manager

*  filterlines jquery plugin

*  additions to main collection content

# 2021-02-27 v0.7


*  Raku::Pod::Render enhanced so gist on PodFile can be inspected

*  Raku::Pod::Render's test-templates rewritten to allow for three Test-Template tests

*  test suite added to Website mode that will be generic to Collection.

*  tests check mode configuration and keys

*  tests check completeness of templates (in principle, all templates can be specified - see PodRender - to test validity of the template keys that have been written). So far only minimum template specs are validated

*  tests check for presence and correctness of all plugins, and whether plugins in the plugins-needed hash match the requirements. (TODO, test the signatures of the callables to see if they match the milestone needs)

*  all plugins must now have a config.raku and a README.pod6

*  progress made on the Search page functionality

*  searchability is now inherent in the website TOC/Glossary output structures.





----
Rendered from CHANGELOG at 2021-02-27T21:59:18Z