# FTI.initaliseLayout and FTI.fixLayout are for setting up and adjusting the size of the globe area, to ensure it always takes up all available space.

$window         = $ window
$middle_section = null
$main_inner     = null
header_height   = null
footer_height   = null

FTI.initaliseLayout = ->
  $middle_section = $ '#ig-middle'
  $main_inner     = $ '#main-inner'
  header_height   = $('#ig-header').outerHeight()
  footer_height   = $('#ig-footer').outerHeight()

  svg = document.getElementById '#the-svg'

  #HACK
  header_height = 0

  # Run the fixLayout function once, then whenever the window is resized (throttled to 10/second)
  FTI.fixLayout()
  $window.on 'resize', FTI.fixLayout #$.throttle(100, false, FTI.fixLayout)

FTI.fixLayout = ->
  # Determine height and width of middle section
  height = $window.innerHeight() - header_height - footer_height
  # width = 

  # Make the middle section the right size

  $middle_section.height( height )

  # Make the SVG the right size
  # svg.setAttribute 'width', 

  # Update the globe
  globe = FTI.globe
  globe.fixLayout() if globe

#############################################################################
# Make the pop-out sources box work
#############################################################################

$ ->
  $('#sources-credits').click ->
    $(this).toggleClass 'expanded'
