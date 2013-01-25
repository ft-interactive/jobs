# This module controls the tooltip that appears when you hover over a trade line.

$document = $(document)
$window = $(window) 
$tooltip = $('<div id="tooltip" />').hide()

$ -> $tooltip.appendTo 'body'

hide_timeout = null
current_width = null
viewport_width = null

onMove = (event) ->
  FTI.tooltip.position event.pageX, event.pageY

FTI.tooltip = {
  setData: (data) ->
    if FTI.state.port_type is 'exports'
      $headline = $ "<h3>#{data.exporter} <span class='to-arrow'>→</span> #{data.importer}</h3>"
    else
      $headline = $ "<h3>#{data.importer} <span class='from-arrow'>←</span> #{data.exporter}</h3>"
    $headline.addClass 'tooltip-headline'
    
    # Work out the natural width of the headline (by temporarily attaching to the DOM)
    headline_width = $headline.css(
      position: 'absolute'
      left: '-5000px'
      display: 'inline'
    ).appendTo('body').width()
    $headline.detach().attr('style', '')

    $tooltip
      .css(
        width: (headline_width + 18) + 'px'
      )
      .empty()
      .append($headline)
      .append( "<p>#{FTI.util.getStyledPrice(data.value)}</p>" )

    # Note current width of box (needed by the position method)
    current_width = $tooltip.outerWidth()

    this

  show: ->
    clearTimeout hide_timeout if hide_timeout
    $tooltip.css display: 'inline'
    $document.on mousemove: onMove
    viewport_width = $window.innerWidth()
    this

  hide: ->
    hide_timeout = setTimeout( ->
      $tooltip.css display: 'none'
      $document.off mousemove: onMove
    , 200)
    this

  position: (x, y) ->
    # Offset from the mouse a bit
    x += 20
    y += 20

    # Prevent it from being clipped off the right of the viewport
    if x + current_width > viewport_width
      x = viewport_width - current_width

    # Update the position
    $tooltip.css(
      left: x+'px'
      top: y+'px'
    )

    this
}
