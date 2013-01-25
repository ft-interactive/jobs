# SETTINGS
BUTTON_TEXT_WHEN_NOT_FULLSCREEN = 'Fullscreen'
BUTTON_TEXT_WHEN_FULLSCREEN = 'Exit fullscreen'

FTI.setUpFullscreenButton = ->
  if Modernizr.fullscreen and parseInt(FTI.config.enable_fullscreen,10) == 1
    
    FTI.$fullscreen_button = $('<div id="fullscreen-button">Fullscreen</div>')

    FTI.isFullScreen = ->
      # Check for whether we're currently fullscreen
      return (
        (document.fullScreenElement && document.fullScreenElement != null) or
        (!document.mozFullScreenElement && !document.webkitFullScreenElement && !document.webkitIsFullScreen)
      )

    FTI.updateFullScreenButton = ->
      # Update button text and style
      if FTI.isFullScreen()
        FTI.$fullscreen_button.text(BUTTON_TEXT_WHEN_FULLSCREEN).addClass 'on'
      else
        FTI.$fullscreen_button.text(BUTTON_TEXT_WHEN_NOT_FULLSCREEN).removeClass 'on'

    # Make the fullscreen button work
    $ ->
      # console.log 'doing fullscreen', FTI.$fullscreen_button[0]

      FTI.$fullscreen_button.appendTo('#ig-middle').on 'click', ->

        body = $('body')[0]

        # Toggle fullscreen
        if FTI.isFullScreen()
          if body.requestFullScreen
            body.requestFullScreen()
          else if body.mozRequestFullScreen
            body.mozRequestFullScreen()
          else if body.webkitRequestFullScreen
            body.webkitRequestFullScreen Element.ALLOW_KEYBOARD_INPUT
        else
          if document.cancelFullScreen
            document.cancelFullScreen()
          else if document.mozCancelFullScreen
            document.mozCancelFullScreen()
          else if document.webkitCancelFullScreen
            document.webkitCancelFullScreen()

        # Update the button - BUGGY, disable
        # FTI.updateFullScreenButton()

    # Also update the button text & style when the change happens for another reason, e.g. Esc key
    # $(document).on 'mozfullscreenchange webkitfullscreenchange fullscreenchange', ->
    #   FTI.updateFullScreenButton()
