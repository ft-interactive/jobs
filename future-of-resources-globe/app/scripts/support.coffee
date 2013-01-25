required_features = [
  'inlinesvg'
  'svgclippaths'
  'borderradius'
]

FTI.isBrowserSupported = ->
  for feature in required_features
    if not Modernizr[feature]
      if not Modernizr[feature]? then throw 'Unknown feature detection: '+feature
      return false
  return true

# Unavoidable browser sniff for old versions of Firefox, which have trouble with the ocean gradient SVG background (FF4+ supports SVG BGs normally, but for some reason this one comes out plain black, so we add a class for use as a CSS hook, in similar style to Modernizr).
ua = navigator.userAgent
pos = ua.indexOf 'Firefox/'
if pos > -1
  version = parseInt( ua.substring(pos+8) )
  if version < 16
    $ -> $('html').addClass 'dodgysvgbackgrounds'
