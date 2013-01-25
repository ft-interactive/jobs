window.FTI = {
  config: {
    # Globe stuff
    max_scale: 850
    min_scale: 300
    mousewheel_zoom_speed: 20

    # Other stuff
    enable_fullscreen: 1 # for easy disabling, should it turn out to be buggy
    unsupported_html:
      """
      <div class="info-box">
        <p>Sorry, your web browser cannot display this interactive graphic.</p>
        <p>Please visit this page using the latest version of any of the following browsers:</p>
        <ul>
          <li><a href="http://www.google.com/chrome" target="_BLANK">Chrome</a>
          <li><a href="http://www.firefox.com/" target="_BLANK">Firefox</a>
          <li><a href="http://www.apple.com/safari" target="_BLANK">Safari</a>
          <li><a href="http://www.opera.com/" target="_BLANK">Opera</a>
          <li><a href="http://www.microsoft.com/ie" target="_BLANK">Internet Explorer</a>
        </ul>
      </div>
      """
  }

  # These deferreds will all need to be resolved before the page contents are revealed.
  deferreds: {
    globe_ready: $.Deferred() # will be manually resolved by the globe module
    data_loaded: $.ajax 'data/trades.json',
      dataType: 'json'
      success: (data) -> FTI.data = data
    geodata_ready: $.ajax "data/world-countries.json",
      dataType: 'json'
      success: (data) -> FTI.geodata = data
    data_prepared: $.Deferred() # will be manually resolved by the sidebar module
  }

  revealLoadedPage: ->
    $('#overlay').fadeOut(800)

  init: ->
    if FTI.isBrowserSupported()
      # When all the FTI.deferreds are resolved, unhide the page
      deferreds_array = []
      deferreds_array.push value for own key, value of FTI.deferreds
      $.when.apply( $, deferreds_array ).then FTI.revealLoadedPage

      FTI.setUpFullscreenButton()
      FTI.setUpGlobe()
      FTI.setUpSidebar()

    else
      $('#overlay').append FTI.config.unsupported_html
}

# Run the init on DOM ready (ie. after all scripts have been evaluated)
$(FTI.init)
