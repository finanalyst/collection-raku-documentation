# Collection-based Raku Documentation
>Creates a Collection of Rakudoc (aka POD6) sources, default starts a local web-site powered by Cro.


----
## Table of Contents
[License](#license)  
[Installation](#installation)  
[Raku-Doc](#raku-doc)  

----
# LICENSE

Artist 2.0

This Module provides a local website available via a browser at localhost:3000 of the Raku documentation. The Module uses Collection and Raku::Pod::Render to link all the Rakudoc (aka Pod6) files together. The Cro app and HTML output files are created using the Website mode, but other modes can be created. For more information about creating different modes, and for an explanation about how to create Websites from other content sources, see [ContentCollection](ContentCollection.md).

# Installation
```
zef install Collection::RakuDocs
```
This installs the `Collection` (and other) dependencies and the `Raku-Docs` executable. These in turn install the the other main distributions, `Cro` and `Raku::Pod::Render`. By default `Raku::Pod::Render` does not install the highlighter automatically because `node.js` and `npm` are required. So these will be needed and then install the highlighter, as described in the `Raku::Pod::Render` README.md file. This should be as simple as installing `node.js` and `npm` (eg., for a Debian based system, but there are other ways)

```
sudo apt install npm nodejs
```
Then the following should be possible

```
raku-pod-render-install-highlighter
```
# Raku-Doc
On a Linux based distributions, `Raku-Doc` depends on `git` and `unrar`, which typically are installed by default, to get and unpack other files.

Under Linux, in a terminal, the following will lead to the installation of a local copy of Raku docs and start a Cro app that will make the HTML documentation available in a browser at `localhost:3000`, and produce a progress status bar for the longer stages.

```
mkdir ~/My-Local-Raku-Documentation
cd My-Local-Raku-Documentation
Raku-Doc
```
Calling `Raku-Doc` without any other options implies the mode **Website** with default options. Other modes (see the `Collection` README for more information about **mode**) are planned, such as EPUB and PDF.

```
Raku-Doc --modes
```
will show which modes are available.

Other modes can be added, as is described in the `Collection` documentation. The configuration files in `Website` can be modified, for example to change the port at which the browser can locate the documentation.

If it is desired to change the default Collection configuration before any long processes start, such as caching or rendering,

```
Raku-Doc Init
```
will just initiate the directory and then stop, at which point the options can be changed, then run `Raku-Doc` again.

The Raku Documentation source files are regularly updated. The **Website** mode is configured to pull the latest versions of the source files into the Collection whenever `Raku-Doc` is run, which then updates the cache for any sources that have changed, and then re-render all the html files that are affected. These stages are automatically called by running Raku-Doc with the config defaults given.

`Raku-Doc` can be called with other options, which are passed to the `collect` sub in `Collection`. In addition, the options can be changed in the `Website` config files. The `Collection` documentation contains a description of all the options. Some of them are:

Briefly, the options are:

> **no-status**  
Caching and rendering can take time, so a progress bar is provided for the terminal. By setting C<no-status> on the command line or in the Website config files, no status bar is shown.
> **no-refresh**  
This prevents C<Raku-Doc> (actually C<Collection::collect>) from getting new changes to the documentation sources, and so no changes will be made to the cache.
> **recompile**  
By default, only source files that have changed are cached. This option deletes the source cache, forcing all source files to be recompiled.
> **no-rerender**  
Even if there are changes to source files, the output html files are not re-rendered.
> **full-render**  
Even if there only some or no changes to the source files, all the files in the cache will be rendered again. The same effect can be achieved by deleting the C<Website/html> directory.







----
Rendered from README at 2021-01-25T14:37:35Z