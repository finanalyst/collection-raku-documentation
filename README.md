# Collection-based Raku Documentation
> **Description** Collects the Raku Documentation's content sources existing in github repo, creates output suitable for a running with Cro.

> **Author** Richard Hainsworth, aka finanalyst


----
----
## Table of Contents
[Installation](#installation)  
[Raku-Doc](#raku-doc)  
[Problems](#problems)  
[Plugins](#plugins)  
[Docker](#docker)  

----
This Module provides a local website available via a browser at localhost:3000 of the Raku documentation. The Module uses Collection and Raku::Pod::Render to link all the Rakudoc (aka Pod6) files together. The Cro app and HTML output files are created using the Website mode, but other modes can be created. For more information about creating different modes, and for an explanation about how to create Websites from other content sources, see [Collection](https://github.com/finanalyst/collection).

# Installation
```
zef install Collection-Raku-Documentation
```
This installs the `Collection` (and other) dependencies and the `Raku-Docs` executable. These in turn install the the other main distributions, `Cro` and `Raku::Pod::Render`. By default `Raku::Pod::Render` does not install the highlighter automatically because `node.js` and `npm` are required. So these will be needed and then install the highlighter, as described in the `Raku::Pod::Render` README.md file. Then the following should be possible

```
raku-pod-render-install-highlighter
```
# Raku-Doc
On a Linux based distributions, `Raku-Doc` depends on `git` and `unrar`, which typically are installed by default, to get and unpack other files.

Under Linux, in a terminal, the following will lead to the installation of a local copy of Raku docs and start a Cro app that will make the HTML documentation available in a browser at `localhost:30000`, and produce a progress status bar for the longer stages.

```
mkdir ~/My-Local-Raku-Documentation
cd My-Local-Raku-Documentation
Raku-Doc Init
```
This sets up the Collection directory, and installs the dependencies.

It does not clone a copy of the `Raku/doc` repository because an existing version may be available on the system.

Consequently, the user needs to clone the Raku docs repository using something like `git clone https://github.com/Raku/doc.git raku-docs`. Then the path used can be put into the config.raku file in the `sources-refresh` key. Once the raku-docs are ready, the INIT stage is complete.

For example, to render the full Raku Docs, the following would work, where `raku-local` is a local directory.

```
- raku-local
    - raku-docs
    - Website
    config.raku
```
After the `Init` stage, calling `Raku-Doc` without any other options implies the mode **Website** with default options. Other modes (see the `Collection` README for more information about **mode**) are planned, such as EPUB and PDF.

The configuration files in `Website` can be modified, for example to change the port at which the browser can locate the documentation.

The Raku Documentation source files are regularly updated. The **Website** mode is configured to pull the latest versions of the source files into the Collection whenever `Raku-Doc` is run, which then updates the cache for any sources that have changed, and then re-render all the html files that are affected. These stages are automatically called by running Raku-Doc with the config defaults given.

`Raku-Doc` can be called with other options, which are passed to the `collect` sub in `Collection`. In addition, the options can be changed in the `Website` config files. The `Collection` documentation contains a description of all the options. Some of them are:

Briefly, the options are:

*  **no-status**

Caching and rendering can take time, so a progress bar is provided for the terminal. By setting `no-status` on the command line or in the Website config files, no status bar is shown.

*  **no-refresh**

This prevents `Raku-Doc` (actually `Collection::collect`) from getting new changes to the documentation sources, and so no changes will be made to the cache.

*  **recompile**

By default, only source files that have changed are cached. This option deletes the source cache, forcing all source files to be recompiled.

*  **full-render**

Even if there only some or no changes to the source files, all the files in the cache will be rendered again. The same effect can be achieved by deleting the `Website/html` directory.

*  **collection-info**

Turns on tracing for Collection. Reports when milestones passed, and the plugins at each milestone.

# Problems
Collection is still being actively developed.

*  When running `Raku-Doc` with a `sources-refresh` key set to a git pull stanza, Raku-Doc teminates after a git pull. Workaround: run `Raku-Doc` again.

*  The aim is to only update HTML files that have changed. However, the time taken to reload cached html is slower than to generate them ad novo. So it is best to run `Raku-Doc --full-render` each time. Caching of Pod6 files, however, works well.

# Plugins
This distribution contains a number of Collection plugins that are intended to be more generic than just for Raku-Documentation-Collection.

There is also a test facility, so `cd Website ;; prove -re 'raku -I.' t` will run tests on the Website mode.

Another testing facility is the executable `test-plugins` in the repository, but not yet added as a resource. It is used in the Website directory and runs the plugin tests.

# Docker
A docker image (`finanalyst/collection-raku`) is available that already has everything installed. It is intended for running on a server but where copies of the `Website` directory and `config.raku` files in this distribution and a clone of the Rau/doc repository exists in a directory called `raku-doc` are present on the server.

The aim of the docker image is to reduce the hassle of installing `Cro`, `Raku::Pod::Render`, `node.js` and `npm` and installing the highlighter. The Raku/doc repository is regularly updated and quite large, so putting it in the container seems less performant. Keeping `Website` available for change allows for the configuration options to be changed, and for new plugins to be added.

The final HTML is served by `Cro` on port 30000, but this can be configured in `Website/configs/01-config.raku`.

The intention is for the image to be used as follows (assuming docker is installed):

```
sudo docker pull finanalyst/collection-raku

sudo docker run -d -p 30000:30000 -v /home/web/raku-docs:raku-docs -v /home/web/Website:Website --rm finanalyst/collection-raku
```
`/home/web/raku-docs` is the path to a clone of the Raku-docs repository created with `git clone https://github.com/Raku/doc.git raku-docs`.

`/home/web/Website` is the path to a the Website directory created by running `Raku-Doc Init` from this distribution. Keeping the Website directory out side the docker image allows for local tweaking of the configuration and plugin files. The `config.raku` in the docker images, which defines where Collection will look for files, expects the Raku pod files at `raku-docs/docs` and the Website mode directory at `Website`. The html is generated in `Website/html`, so outside the docker container.

The docker image will run a `git pull` on raku-docs, render those html files that have changed, then serve the results at 30000. Naturally, the port can be changed using `docker` say to 18080 as

```
sudo docker run -d -p 18080:30000  -v /home/web/raku-docs:raku-docs -v /home/web/Website:Website --rm finanalyst/collection-raku
```
**LICENSE** Artistic-2.0







----
Rendered from README at 2021-03-02T10:37:52Z