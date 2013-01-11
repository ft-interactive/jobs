/*global L:true*/

;(function() {
  'use strict' ;
  var map, parseBounds, config, backgroundLayer, legendControl ;

  // Configuartion for this particular map
  config = {
    bounds    : [ -2, 51, 1, 52.5], // w,s,e,n
    center    : [51.6586, -0.4702],
    zoom      : 9,
    maxZoom   : 13,
    minZoom   : 9,
    tilesBaseUrl: 'http://interactivegraphics.ft-static.com/maps/abandoned-tube-stations/0.4/'
  } ;

  // Function to convert from a TileMill-style 'bounds' string/array to a fancy Leaflet LatLngBounds object
  parseBounds = function (bounds) {
    var a  = ( typeof bounds === 'string' ? bounds.split(',') : bounds ),
        w  = a[0],
        s  = a[1],
        e  = a[2],
        n  = a[3],
        sw = new L.LatLng(parseFloat(s), parseFloat(w)),
        ne = new L.LatLng(parseFloat(n), parseFloat(e)) ;
    return new L.LatLngBounds(sw, ne) ;
  } ;

  // Set up the Leaflet map (on the element with id "map")
  map = new L.Map('map', {
    center    : config.center,
    maxBounds : parseBounds( config.bounds ),
    zoom      : config.zoom,
    maxZoom   : config.maxZoom,
    minZoom   : config.minZoom
  }) ;

  // Add the background layer and attribution
  backgroundLayer = new L.TileLayer(
    config.tilesBaseUrl + '{z}/{x}/{y}.png',
    {}
  ) ;
  map
    .addLayer(backgroundLayer, true)
    .attributionControl
      .setPrefix('') // removes "Powered by Leaflet"
      .addAttribution('Source: FT Research &mdash; Map data &copy; <a href="http://www.openstreetmap.org/">OpenStreetMap</a> &mdash; Powered by <a href="http://leafletjs.com/">Leaflet</a>') ;

  // Add a legend
  legendControl = new L.Control({
    position: 'topright'
  }) ;
  legendControl.onAdd = function() {
    var div = document.createElement('div') ;
    div.id = 'legend' ;
    div.innerHTML = '<div><span class="abandoned-stn"></span>Closed</div>' + '<div><span class="active-stn"></span>Active</div>' ;
    return div ;
  } ;
  legendControl.addTo(map) ;

})();
