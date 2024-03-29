# Changelog
>For the Collection-Raku-Documentation module


## Table of Contents
[2021-01-22 Spin off Collection into its own Module](#2021-01-22-spin-off-collection-into-its-own-module)  
[2021-01-25 Change name to reflect Collection hierarchy](#2021-01-25-change-name-to-reflect-collection-hierarchy)  
[2021-02-06 HTML Rendering working fully](#2021-02-06-html-rendering-working-fully)  
[2021-02-21 v0.5](#2021-02-21-v05)  
[2021-02-21 v0.6](#2021-02-21-v06)  
[2021-02-27 v0.7](#2021-02-27-v07)  
[2021-03-1 v0.8](#2021-03-1-v08)  
[2021-03-02 v0.8.1](#2021-03-02-v081)  
[2021-03-5 v0.8.2](#2021-03-5-v082)  
[2021-03-11 v0.8.3](#2021-03-11-v083)  
[2021-03-30 v0.8.4](#2021-03-30-v084)  
[2021-04-01 v0.8.5](#2021-04-01-v085)  
[2021-o4-02 v0.8.6](#2021-o4-02-v086)  
[2021-04-04 v0.9.0](#2021-04-04-v090)  
[2022-07-29 v0.10.0](#2022-07-29-v0100)  
[2022-07-29 v0.10.1](#2022-07-29-v0101)  
[2022-07-29 v0.10.2](#2022-07-29-v0102)  
[2022-07-29 v0.10.3](#2022-07-29-v0103)  
[2022-07-29 v0.10.4](#2022-07-29-v0104)  
[2022-07-29 v0.10.5](#2022-07-29-v0105)  
[2022-07-31 v0.10.6](#2022-07-31-v0106)  
[2022-08-09 v0.10.7](#2022-08-09-v0107)  
[2022-08-09 v0.11.0](#2022-08-09-v0110)  
[2022-08-11 v0.11.1](#2022-08-11-v0111)  
[2022-08-11 v0.11.2](#2022-08-11-v0112)  
[2022-08-13 v0.11.3](#2022-08-13-v0113)  
[2022-08-13 v0.11.4](#2022-08-13-v0114)  
[2022-09-21 v0.12.0](#2022-09-21-v0120)  
[2022-09-24 v0.12.1](#2022-09-24-v0121)  
[2022-11-13 v0.12.2](#2022-11-13-v0122)  
[2023-01-14 v0.12.3](#2023-01-14-v0123)  

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

# 2021-03-1 v0.8
*  Working version of Search page

*  altered page header

*  added placeholder to FilterFile plugin

# 2021-03-02 v0.8.1
*  change README.pod6

*  Don't configure to automatically clone Raku docs

*  prepare for addition to Ecosystem.

# 2021-03-5 v0.8.2
*  fixed many 404 because

	*  Raku names content and html directories differently

	*  the template was not rendering local files correctly

	*  Raku::Pod::Render was treating local files as external

# 2021-03-11 v0.8.3
*  added error page to main header

*  new plugin checks all links and creates error page where there is missing content

# 2021-03-30 v0.8.4
*  new link-error-test plugin, checks for 404s and intra-collection link/anchor existence

*  improve styling of error report

*  correct doc-change-route to correct Language->language etc.

*  improve default styling

*  remove TOC and Index tabs from header.

# 2021-04-01 v0.8.5
*  improved link-error-test to detect %E2%xx$xx strings. These are three byte utf8. Only four used in Raku documentation

*  improved Search page so that returning to page keeps the search state

*  improved Search page so that Documents are also clickable, not just the parts that are found.

*  added report milestone plugin to images, which looks at all plugins for :images key, and marks image files as used

*  added asset report to link-plugin-asset report plugin

*  added new Camelia blocks to provide image for homepage and 404 page.

*  added faded camelia to background of pod files

*  reworked minimum templates to handle pod content and page content.

*  got link-error-test to sort files, and added links to files where there are problems.

# 2021-o4-02 v0.8.6
*  improvements to link-error-test

*  glossary/index items are placed below floating page header

# 2021-04-04 v0.9.0
*  change to match new Collection version, enforce observance of no-status in plugins

*  remove dependency on Cro, change README to show how to install Cro::HTTP and enable the Cro App plugin

*  add a leaflet map plugin

# 2022-07-29 v0.10.0
*  change to match Collection 0.8.2

*  Cro App plugin re-enabled, but there is a try require test for Cro::HTTP, so it will exit with a note to install Cro::HTTP if the Distribution is not installed.

# 2022-07-29 v0.10.1
*  bump v

# 2022-07-29 v0.10.2
*  remove extraneous my $proc-rv

# 2022-07-29 v0.10.3
*  replace unrar with unzip

*  clearup --force-install logic

# 2022-07-29 v0.10.4
*  more unzip stuff

*  remove --force-install stuff

# 2022-07-29 v0.10.5
*  improve let plugin

*  fix META6.json

# 2022-07-31 v0.10.6
*  add *.rakudoc to Website plugin tests

# 2022-08-09 v0.10.7
*  revert to github Ecosystem as fez not accepting the Module

*  LeafletMap plugin working

*  ordering added to gather-js to ensure scripts can be loaded in correct order

*  updated Collection examples page

*  moved trial/ directory to Collection-Plugins

# 2022-08-09 v0.11.0
*  remove all old structure source files from website.zip

# 2022-08-11 v0.11.1
*  add 'Refresh' instruction to Raku-Doc

# 2022-08-11 v0.11.2
*  new GraphViz plugin

# 2022-08-13 v0.11.3
*  remove Raku-Doc from provides

# 2022-08-13 v0.11.4
*  remove unnecessary code line

# 2022-09-21 v0.12.0
*  refactor to use new plugin management tools

*  include raku docs clone into local_raku_docs by default

*  rewrite Raku-Doc to use Collection::refresh

*  moved all Collection files, eg. Website mode, to new repo. Only website.zip here

*  Website mode downloaded from repository, then unzipped

# 2022-09-24 v0.12.1
*  fix Meta6 problem

# 2022-11-13 v0.12.2
*  pass options from RakuDoc to refresh

# 2023-01-14 v0.12.3


*  add information about OgdenWebb mode

*  refactor Init and Refresh a bit

*  explicitly allow for another mode





----
Rendered from CHANGELOG at 2023-01-14T10:59:40Z