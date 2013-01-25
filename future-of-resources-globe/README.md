Resource Globe
==============

The graphic is live at [ft.com/resource-globe](http://www.ft.com/resource-globe).

The actual iframed URL is: http://interactivegraphics.ft-static.com/features/2012-11-27_futureResources/live/

Notes
-----

* There is a [bug in Webkit](https://bugs.webkit.org/show_bug.cgi?id=78980) which causes you to get hundreds of `Error: Problem parsing d=""` logs in the console as you drag the globe around. Each country is a `path` element, and its `d` attribute describes its points. If the country is 'behind' the globe, its `d` attribute is empty. Webkit's SVG renderer thinks this is an error, so it appears in the console. In fact the spec [explicitly allows](http://www.w3.org/TR/SVG/paths.html#PathDataBNF) this – an empty `d` attribute just means "don't draw anything here" (which, fortunately, is exactly how Webkit handles its error).


Development
-----------

You will need to [install Yeoman](http://yeoman.io/installation.html) first, then `cd` into this project's directory.

Then run:

    yeoman server

This will serve up a local version of the site at `http://localhost:3501/` (and it should even open it in your web browser automatically). It also injects a JavaScript snippet that will magically reload the page whenever you modify a source file within `app`.

Building and deploying
----------------------

When you want to build, quit out of Yeoman's server (`ctrl+c`) if it's running, then run:

    yeoman build

This will generate a folder called `dist`, which is the built version.

It's probably worth checking that this built version works correctly before you deploy it. You can use Yeoman's server to serve up the `dist` folder, like this:

    yeoman server:dist

(In this case, Yeoman's server is just a simple static file server; it won't inject the LiveReload snippet.)

If everything is OK, quit the server with `ctrl+c`, then rename the `dist` folder to `live` and use this to replace `/features/2012-11-27_futureResources/live/` on the Interactive server.
