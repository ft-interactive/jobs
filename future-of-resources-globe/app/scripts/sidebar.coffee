# This module was rushed and is a mess. Lots of inconsistencies. Needs total rewrite. 

FTI.setUpSidebar = ->
  
  THE_YEAR = '2010' # for now

  FTI.state = {
    port_type: null
    country: null
    commodity: null
  }

  FTI.stateChanged = (->) # noop for now

  realStateChanged = -> # FTI.stateChanged will be set to this when ready
    # console.log 'STATE CHANGED'

    porters = 
      FTI.state.commodity[(if FTI.state.port_type is 'exports' then 'top_exporters' else 'top_importers')]
    
    country = _.find porters, (country) ->
      country.country == FTI.state.country

    if (country)
      ports = country.ports
      trades = []
      for port in ports
        if FTI.state.port_type is 'exports'
          trade = {
            exporter: FTI.state.country
            importer: port.country
          }
        else
          trade = {
            importer: FTI.state.country
            exporter: port.country
          }
        trade.share = (port.value / (country.total_exported || country.total_imported))

        trade.value = port.value

        trades.push trade


      FTI.globe.setArcsData(trades).refresh()

      # ALSO set up the table
      ( ->

        if FTI.state.port_type is 'exports'
          first_header = 'Import client'
          third_header_tooltip = '% of total exported by '+FTI.state.country
          share_note = 'This import as a percentage of #{FTI.state.country}\'s total #{FTI.state.port_type} export.'
          label = 'Imports'
          explanation = "Leading importers of #{FTI.state.commodity.name.toLowerCase()} from #{FTI.state.country}, 2010"
        else
          first_header = 'Supplier'
          third_header_tooltip = '% of total imported by '+FTI.state.country
          label = 'Exports'
          explanation = "Leading exporters of #{FTI.state.commodity.name.toLowerCase()} to #{FTI.state.country}, 2010"

        $ports_table = $('<div class="fake-table">').append(
          """
          <h3>#{FTI.state.country}</h3>
          <p class="explanation">#{explanation}</p>
          <p class="header-row">
            Country
            <span>#{label}</span>
          </p>
          """
        )

        i = -1
        for port in ports
          i++

          # console.log 'port', port
          name = port.country

          # HACK
          switch name
            when 'Southern African Customs Union'
              name = '<abbr title="Southern African Customs Union">SACU</abbr>'
            when 'Switzerland (incl. Liechtenstein)'
              name = 'Switzerland &amp; Liechtenstein'

          percentage = Math.round( (port.value / (country.total_exported || country.total_imported)) * 100 ) + '%'
          
          value_html = FTI.util.getStyledPrice port.value

          $port_table_row = $ "<p>#{name} <span>#{value_html}</span></p>"
          $ports_table.append(
            $port_table_row
          )

          trades[i].$port_table_row = $port_table_row

        $('#ports-table').hide().empty().append(
          $ports_table
        ).fadeIn(400)

      )()



  $commodity_select = null

  FTI.deferreds.data_loaded.done -> $ ->
    # console.log 'Data loaded', FTI.data

    # Convenience vars
    data = FTI.data
    commodities = data.commodities

    # Cache jQuery elements
    $commodity_select = $ '#commodity-select'

    # Set initial port type
    # FTI.state.port_type = $('#port-type-options')
    #   .find('input[name=port-type]:checked')
    #   .val()
    # Update when checked
    $('input[name=port-type]').on(
      change: ->
        if $(this).is(':checked')
          $('body').addClass('switching-port-type')
          FTI.state.port_type = $(this).val()
          $('body')
            .removeClass('viewing-exports viewing-imports')
            .addClass('viewing-'+FTI.state.port_type)
          $commodity_select.trigger('change')
          setTimeout( ->
            $('body').removeClass('switching-port-type')
          , 500)
    ).filter(':checked').trigger('change')


    # Make a quick lookup hash of commodities by name
    commodities_by_name = {}
    commodities_by_name[c.name] = c for c in commodities
    # console.log 'commodities_by_name', commodities_by_name

    # Add commodity options to select box
    for commodity in commodities
      # console.log 'looping commodity', commodity
      $option = $('<option/>')
        .text(commodity.name)
        .val(commodity.name)
        .appendTo( $commodity_select )

    # Dropkick it up (stupidly, I have to manually trigger the change)
    $commodity_select.dropkick(
      change: (value, label) ->
        $commodity_select
        #   .find("option[value='#{value}']")
        #   .select()
        # .parent()
          .trigger('change')
    )


    # Do stuff when commodity selection changes
    $commodity_select.on(
      change: (e) ->

        $('#ports-table').hide()

        FTI.state.commodity = selected_commodity = commodities_by_name[ $commodity_select.val() ]
        # console.log 'selected_commodity', selected_commodity

        if FTI.state.port_type is 'exports'
          key_name = 'top_exporters'
        else
          key_name = 'top_importers'

        top_porters = selected_commodity[key_name] ;
        # console.log 'top_porters', top_porters

        # Populate the sidebar countries list with the top porters
        if FTI.state.port_type is 'exports'
          label = 'Total exported, 2010'
        else
          label = 'Total imported, 2010'
        $sidebar_ul = $('<ul/>').append("<li class='header-row'>Country <span>#{label}</span></li>")

        for porter in top_porters
          # console.log 'porter', porter
          value = FTI.util.getStyledPrice (porter.total_exported || porter.total_imported)
          $li = $("<li class='country-row'>#{porter.country} <span>#{value}</span></li>")
            .data('country_name', porter.country)
          $sidebar_ul.append $li
          $li.on
            click: ->
              if $(this).hasClass 'active-country' then return
              $('.active-country').removeClass('active-country')
              $(this).addClass 'active-country'
              FTI.state.country = $(this).data('country_name')
              FTI.stateChanged()


        str1 = FTI.state.commodity.name.toLowerCase().replace(/s$/, '')
        str2 = (if FTI.state.port_type is 'exports' then 'exporters' else 'importers')
        $('#leading-porters')
          .empty()
          .css('opacity', 0)
          .append(
            "<h3>Leading #{str1} #{str2}</h3>"
          )
          .append($sidebar_ul)
          .animate({opacity:1}, 300, ->
            # click the first country
            $sidebar_ul.children().eq(1).click()
          )
    )
    
    # Signal that the sidebar is ready
    FTI.deferreds.data_prepared.resolve()

    # When the globe is ready, show data
    FTI.deferreds.globe_ready.done ->

      # Update the stateChanged function to a real one
      FTI.stateChanged = realStateChanged
      
      $commodity_select.trigger('change')

      exporter_centre = FTI.globe.country_centres['Chile'] # FOR NOW
      # console.log 'centre', exporter_centre
      # FTI.globe.setOrigin( exporter_centre[0], exporter_centre[1] ).refresh()
