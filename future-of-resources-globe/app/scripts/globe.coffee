getRandomInt = (min, max) ->
  return Math.floor(Math.random() * (max - min + 1)) + min

clamp = (num, min, max) ->
  if (min < num)
    if (num < max)
      return num
    return max
  return min

$main_inner = null
main_inner = null

FTI.setUpGlobe = ->

  main_inner = document.getElementById 'main-inner'
  $main_inner = $ main_inner

  # Create the SVG canvas
  svg = d3.select('#the-svg')

  # FTI.globe_shape = d3.select('#globe-shape')
  FTI.globe_clipping_circle = d3.select('#globe-clipping-circle')

  # Get hold of d3 tools
  xy = d3.geo.azimuthal().scale(200).mode("orthographic")

  circle = d3.geo.greatCircle()
  path = d3.geo.path()
  projectPath = path.projection(xy)

  getGreatArc = d3.geo.greatArc()

  # Localise some config vars for convenience
  config = FTI.config
  min_scale = config.min_scale
  max_scale = config.max_scale

  # Create our `globe` API namespace, for interacting with the globe from within this script and elsewhere.
  FTI.globe = globe = {
    all_country_paths: {}

    svg_element: svg[0][0]

    transitionOrigin: (target_lon, target_lat, duration=200, callback) ->
      if FTI.disable_animation
        @setOrigin(target_lon, target_lat, true).refresh()
        callback() if callback
        return this

      [original_lon, original_lat] = xy.origin()

      lon_delta = target_lon - original_lon
      lat_delta = target_lat - original_lat

      start = Date.now()

      step = (timestamp) ->
        progress = timestamp - start

        if ( progress < duration )
          proportion = progress/duration
          new_lon = original_lon + (lon_delta * proportion)
          new_lat = original_lat + (lat_delta * proportion)

          globe.setOrigin(new_lon, new_lat).refresh(true)

          requestAnimationFrame(step)

        else
          globe.setOrigin(target_lon, target_lat).refresh(true)
          callback() if callback
      
      requestAnimationFrame(step)

    setScale: (value) ->
      xy.scale value
      this

    adjustScale: (change) ->
      # Determine the new target scale
      new_scale = xy.scale() + change
      # Constrain if necessary
      if new_scale < min_scale then new_scale = min_scale
      else if new_scale > max_scale then new_scale = max_scale
      # Update the scale
      xy.scale( new_scale )
      this

    setTranslate: (x, y) ->
      translate = xy.translate()
      translate[0] = x if x?
      translate[1] = y if y?
      xy.translate translate
      this

    setOrigin: (lon, lat) ->
      origin = xy.origin()
      origin[0] = lon if lon?
      origin[1] = lat if lat?
      xy.origin origin
      circle.origin origin
      this

    refresh: (fast=false, update_overlays=false) ->

      unless fast
        # Get the current translate values from the projection
        [globe_x, globe_y] = xy.translate()
        scale = xy.scale()

        # Refresh the 'globe shape' (which gets reused as the circle) - CHROME BUG :(
        FTI.globe_clipping_circle
          .attr('cx', globe_x)
          .attr('cy', globe_y)
          .attr('r', scale)

        radius = scale
        diameter = (radius * 2)

        FTI.$bg_circle_div.css
          width: diameter + 'px'
          height: diameter + 'px'
          left: (($main_inner.width() - diameter) / 2)  + 'px'
          top: (($main_inner.height() - diameter) / 2)  + 'px'

      # Refresh countries
      countries_paths = globe.countries_group.selectAll("path")
      countries_paths.attr "d", (d) ->
        projectPath(circle.clip(d)) || '' # a null value (no path points) needs to be converted to a string for IE, or IE won't update the attribute at all

      # Refresh arcs
      arcs_paths = @arcs_group.selectAll('path')
      arcs_paths.attr 'd', (data) ->
        great_arc = getGreatArc(data)
        clipped_great_arc = circle.clip(great_arc)
        projectPath(clipped_great_arc)

      # Refresh arc overlays
      @refreshArcOverlays() #if update_overlays

      # Return for chaining
      this

    refreshArcOverlays: ->
      # For speed, the data passed to each path element in the arc-overlay-paths group is actually just the corresponding path from the other group. So the overlay one can simply copy the `d` attribute from the original one.
      @arc_overlays_group.selectAll('path')
        .attr('d', (arc) ->
          arc.getAttribute('d')
        )
        .attr('stroke-width', (arc) ->
          clamp(arc.getAttribute('stroke-width'), 8, 100)
        )

    fixLayout: ->
      # This is the globe's version of fix layout. There is also an app-wide version (which calls this one, after fixing the layout of the SVG container).

      # Work out the SVG dimensions to get an appropriate scale
      svg_width = main_inner.offsetWidth
      svg_height = main_inner.offsetHeight
      max_size    = Math.min svg_width, svg_height
      translate_x = (svg_width - 0) / 2
      translate_y = (svg_height - 0) / 2
      scale       = max_size / 2.2 # seems about right

      # Scale the globe to fit
      globe
        .setTranslate( translate_x, translate_y )
        .setScale( scale )
        .refresh()

      # Also update the svg itself
      svg_element = globe.svg_element
      svg_element.setAttribute('width', svg_width)
      svg_element.setAttribute('height', svg_height)

    getCountryCentroid: (name) ->
      centroid = globe.country_centres[ name ]
      if !centroid?
        console.log 'Warning: No centroid found for ' + name
        # Just pick a coordinate from its outline (TODO: find out how to compute an actual centroid based on the outline)
        for feature in FTI.geodata.features
          if feature.properties.name is name
            arr = feature.geometry.coordinates
            loop
              arr = arr[0]
              # console.log 'arr', arr
              break if (
                arr.length is 2 &&
                typeof arr[0] is 'number' &&
                typeof arr[1] is 'number'
              )
            centroid = arr
            break
      if !centroid?
        console.log 'Warning: No country found for ', name
        centroid = [
          -0.1062,
          51.5171
        ]
      globe.country_centres[ name ] = centroid
      centroid

    removeCountryClasses: ->
      d3.selectAll('.exporter, .importer, .focused-porter').attr('class', '')

    setCountryClass: (country_name, class_name) ->
      d3.select(globe.all_country_paths[country_name]).attr('class', class_name)
    
    offsetOriginSlightly: (origin) ->
      new_lat = origin[1] + 10
      new_lon = origin[0] + 10
      [
        new_lon
        new_lat
      ]

    setArcsData: (data) ->
      globe.removeCountryClasses()

      for trade in data
        trade.source = globe.getCountryCentroid trade.exporter
        trade.target = globe.getCountryCentroid trade.importer
        globe.setCountryClass trade.exporter, 'exporter'
        globe.setCountryClass trade.importer, 'importer'

      array_of_arc_paths = []

      @arcs_group
        .selectAll( 'path' )
        .data( data )
        .enter()
        .append('path')
        .each( ->
          array_of_arc_paths.push this
        )
        .attr('stroke-width', (d) ->
          amount = d.share * 60
          clamp(amount, 2, 30)
        )

      # Also make a group of arc OVERLAY paths (copies of the other paths, for listening for mouseovers)
      @arc_overlays_group
        .selectAll( 'path' )
        .data( array_of_arc_paths ) # each overlay arc path's data is the actual corresponding arc path element
        .enter()
        .append('path')
        .each( (arc) ->
          $(this).on
            mouseover: (event) ->
              unless FTI.drag_active
                arc.setAttribute('class', 'hovered')
                FTI.tooltip
                  .position(event.pageX, event.pageY)
                  .setData(arc.__data__)
                  .show()
                # Highlight the port row
                arc.__data__.$port_table_row.addClass 'active'

            mouseout: (event) ->
              arc.setAttribute('class', '')
              FTI.tooltip.hide()
              # Unhighlight the port row
              arc.__data__.$port_table_row.removeClass 'active'
        )

      # Transition to the centroid
      if data.length
        if FTI.state.port_type is 'exports'
          new_origin = @getCountryCentroid trade.exporter
        else
          new_origin = @getCountryCentroid trade.importer
        
        new_origin = @offsetOriginSlightly(new_origin)

        [new_origin_lon, new_origin_lat] = new_origin
        @transitionOrigin new_origin_lon, new_origin_lat, 700

      this
  }

  # When we have the geodata, render the globe
  FTI.deferreds.geodata_ready.done ->

    # Get the background circle div
    FTI.$bg_circle_div = $ '#background-circle'

    # Make an SVG group element (<g>) to hold all the country paths
    globe.countries_group = countries_group = svg
      .append( 'g' )
      .attr('id', 'countries-group')
      .attr('clip-path', 'url(#globe-clipper)')
    
    globe.country_centres = country_centres = {}
    for country in FTI.geodata.features
      if country.properties.centre
        country_centres[country.properties.name] = country.properties.centre

    # Create all the country paths, with their data attached
    countries_group
      .selectAll( "path" )
      .data( FTI.geodata.features )
      .enter()
      .append( "path" )
      .each( (d) ->
        # Add this element to our list of all of them
        FTI.globe.all_country_paths[d.properties.name] = this
      )
      .attr("d", (d) ->
        projectPath circle.clip(d)
      )
      .attr('data-name', (d) ->
        d.properties.name
      )
      # .append( "title" )
      # .text( (d) ->
      #   d.properties.name
      # )

    # Initialise the arcs group (empty at first)
    FTI.globe.arcs_group = arcs_group = svg.append("g")
    arcs_group
      .attr("id", 'arcs-group')
      .attr('clip-path', 'url(#globe-clipper)')
    # console.log "arcs!", arcs_group

    # And a group for the overlay arcs (the hovering ones)
    FTI.globe.arc_overlays_group = arc_overlays_group = svg.append("g")
      .attr("id", 'arc-overlays-group')
      .attr('clip-path', 'url(#globe-clipper)')

    # Initialise with empty data set for now (necessary?)
    # globe.setArcsData( [] )

    # Sort out the size/position of the globe and layout in general
    FTI.initaliseLayout()

    # Signal to the boot script that the globe is now rendered
    FTI.deferreds.globe_ready.resolve()

  if FTI.disable_animation
    return

  # Make globe spin when dragged
  (->
    FTI.drag_active = false
    mouse_x_start   = null
    mouse_y_start   = null
    origin_x_start  = null
    origin_y_start  = null
    drag_slowness = 6 # higher is slower

    dragStart = (event) ->
      if event.which == 1
        event.preventDefault()
        mouse_x_start = event.pageX
        mouse_y_start = event.pageY
        [origin_x_start, origin_y_start] = xy.origin()
        FTI.drag_active = true
        $('body').addClass 'drag-active'

    dragMove = (event) ->
      # console.log 'event.which', event.which
      if event.which == 0
        dragEnd()
        return
      if FTI.drag_active
        mouse_x = event.pageX
        mouse_y = event.pageY
        new_origin = [
          origin_x_start + ((mouse_x_start - mouse_x) / drag_slowness)
          origin_y_start - ((mouse_y_start - mouse_y) / drag_slowness)
        ]
        xy.origin new_origin
        circle.origin new_origin
        globe.refresh(true)

    dragEnd = () ->
      if FTI.drag_active
        $('body').removeClass 'drag-active'
        FTI.drag_active = false

    $main_inner.on
      mousedown: dragStart
    $(window).on
      mousemove: dragMove
      mouseup: dragEnd
  )()

  
  # Make arrow keys move globe around.
  # NB: this is a really stupid and complex way to do it. Needs rewriting.
  (->
    repeat_delay = 0
    currently_pressed = false
    pressed_keys = {}
    start_time = null
    speed = 15

    last_timestamp = null
    stepKeys = (timestamp) ->
      # progress = timestamp - start_time
      # console.log 'progress', progress, pressed_keys

      time_delta = timestamp - last_timestamp
      last_timestamp = timestamp
      
      x_adjust = 0
      y_adjust = 0
      still_pressed = false
      for own keyCode of pressed_keys
        switch keyCode
          when '37' then x_adjust++
          when '38' then y_adjust--
          when '39' then x_adjust--
          when '40' then y_adjust++
        still_pressed = true

      x_adjust *= speed
      y_adjust *= speed

      [current_origin_x, current_origin_y] = xy.origin()

      globe.transitionOrigin(
        current_origin_x + x_adjust,
        current_origin_y + y_adjust,
        time_delta + 20
      )
      setTimeout stepKeys, 60 if still_pressed

    $(window).on
      keydown: (event) ->
        # console.log 'keydown', event
        keyCode = event.keyCode
        switch keyCode
          when 37, 38, 39, 40 # any arrow key (LURD)
            pressed_keys[keyCode] = true
            if not currently_pressed
              currently_pressed = true
              last_timestamp = Date.now()
              setTimeout stepKeys, 60
            event.preventDefault()

      keyup: (event) ->
        if currently_pressed
          keyCode = event.keyCode
          switch keyCode
            when 37, 38, 39, 40
              delete pressed_keys[keyCode] if pressed_keys[keyCode]
              still_pressed = false
              for own k of pressed_keys
                still_pressed = true
                break
              if not still_pressed
                currently_pressed = false
      blur: (event) ->
        currently_pressed = false
        pressed_keys = {}
    )()


  # Make mousewheel zoom the globe
  $main_inner.mousewheel (event, delta, deltaX, deltaY) ->
    event.preventDefault()
    new_scale = deltaY * config.mousewheel_zoom_speed
    globe
      .adjustScale( new_scale )
      .refresh()
