Abandoned Tube Stations Map
===========================

Live interactive:

http://blogs.ft.com/ftdata/2013/01/10/london-underground-superlatives-the-oldest-the-largest/

This is a very simple Leaflet-powered, tile-based map. It comprises:

* A layer of tiles (PNG images)
* No SVG layers (the dots on the map are part of the PNG tiles)
* Just Leaflet's default zoom control, plus a custom `div` in the top-right (for the key/legend), and a custom attribution note


How it was made
===============

**Use TileMill to get an MBTiles file:**

Import various data sources into TileMill as data layers. TileMill understands several formats. In this case:

* the general geographical layers (streets, forest/parks, city names, etc) came from Shapefiles containing the latest OpenStreetMap data, which are available from [this site](http://download.geofabrik.de/),
* the "abandoned tube stations" points layer came from a KML file, which Kate made using Google Maps,
* for the "current tube stations" layer, I manually copied the table from [here on OSM's wiki](http://wiki.openstreetmap.org/wiki/List_of_London_Underground_stations) into Google Spreadsheets, exported it as a CSV, and imported this into TileMill.

Use the Carto (`.mss`) language to style these layers.

Export an MBTiles file from TileMill – this is one big archive file that contains all the tiles.

**Extract the MBTiles file into actual PNGs:**

Use the command-line tool [mb-util](https://github.com/mapbox/mbutil) to extract the MBTiles file into thousands of PNGs:

    mb-util <PATH_TO_MBTILES_FILE> <OUTPUT_PATH>

(The output folder will be created – e.g. if you use `~/Desktop/tilez` as the `<OUTPUT_PATH>`, mb-util will create a folder called `tilez` on your desktop, and fill it with subfolders full of thousands of tiles.)

**Upload that folder full of tiles to a server**

**Point the front-end at those tiles:**

In `app/scripts/main.js`, you can just set `config.tilesBaseUrl` to whatever the base URL for that folder is (including a trailing slash), e.g. `http://interactivegraphics.ft-static.com/maps/abandoned-tube-stations/0.1/`.


Developing the front end
========================

Install [Yeoman](http://yeoman.io/).

Open a terminal and navigate to this directory, then you can use Yeoman to do stuff:

* `yeoman server` to serve it up locally on your machine, or
* `yeoman build` to build a version suitable for deploying – this makes a folder called `dist`, which is compiled and minified.

The front-end is just a simple HTML page with a `<div id="map"></div>` on it. It pulls in the Leaflet library (from Leaflet's CDN) and runs `main.js`, which does this:

* Tells Leaflet to set up a map on the `div#map`
* Tells Leaflet to add a 'Tile Layer', using our base tiles URL, and a bit of HTML to go in the attribution note
* Creates a legend (key) `div`, and tells Leaflet to add this as a 'Control' in the top-right

(The zoom control is already there by default.)
