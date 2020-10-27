# spader
WebExtension maker's toolkit and framework.  The concept is simple: all of the main web browsers have standardized on the WebExtension framework, but each browser can have different levels and/or methods of support for the framework.  With Spader, you write an extension once and compile it for each browser.

Tthere is really no magic here.  Spader just runs your source files through ERB and SassC, allowing you to create dynamic templates that are rendered for each browser.  HTML, Javascript, and CSS files all benefit from this Ruby-based pre-processing.  In addition, CSS files are compiled by SassC, ensuring you will be able to use and customize most modern UI frameworks.
 
# Features
* Quickly generate skeleton projects.
* Use Ruby (ERB) and SCSS templates to target multiple web browsers from one source directory.
* Automate the download of third party libraries to ensure bit-perfect copies are submitted to extension galleries for review.
* Package your extension for distribution.

# Developer Guidance
Testing the code without building and installing the gem: `ruby -Ilib bin/spader`

# Rendering
Spader provides a Rails-esque views/partials rendering pipeline for HTML, JS, and CSS templates.  All of these filetypes support embedded Ruby via ERB, and CSS files are also run through a SASS compiler *after* ERB.

Views are in the respective html/js/scss directories, and do not begin with an underscore.  These are all rendered automatically during the build process.  Partials are in the same directories but begin with underscores, and are not rendered unless included (via SASS "@import" or Ruby "render()").

# Commands
Generate a new project: `spader generate <project_path>`

Build a project: `spader build <project_path> [options]`
  * `-e ENVIRONMENT`, `--environment=ENVIRONMENT`
  * `-b BROWSERS`, `--browsers=BROWSERS`
  * `-v VERSION`, `--version=VERSION`
  * `--zip`