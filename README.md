# spader
 WebExtension maker's toolkit.
 
# Features
* Quickly generate skeleton projects.
* Use Ruby (ERB) and SCSS templates to target multiple web browsers from one source directory.
* Automate the download of third party libraries to ensure bit-perfect copies are submitted to extension galleries for review.
* Package your extension for distribution.

# Developer Guidance
Testing the code without building: ruby -Ilib bin/spader

# Rendering
Spader provides a Rails-esque views/partials rendering pipeline for HTML, JS, and CSS templates.  All of these filetypes support embedded Ruby via ERB, and CSS files are also run through a SASS parser *after* ERB.

Views are in the respective html/js/scss directories, and do not begin with an underscore.  These are all rendered during the build process.  Partials are in the same directories but begin with underscores, and are not rendered unless included (via SASS "@import" or Ruby "render()").