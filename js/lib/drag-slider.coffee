root = window ? global # no need for node.js global in a slider but w/e
root.sliders = {}
$ = root.jQuery
DEBUG = false

class Slider
  constructor:(@sliderId, config = {})->
    $ = window.jQuery

    @settings =
      #viewportMaxWidth:  config.viewportMaxWidth ? 1000
      #viewportMaxHeight: config.viewportMaxHeight ? 500
      #slideShow:         config.slideShow ? yes # Not implemented yet
      #stopOnHover:       config.stopOnHover ? yes # Not implemented yet
      cycle:              config.cycle ? yes # Not implemented yet
      navigator:          config.navigator ? yes
      navigatorEvents:    config.navigatorEvents ? no
      #autoHideBtns:      config.autoHideBtns ? yes # Not implemented yet
      duration:           config.duration ? 1 # In seconds
      emmitEvents:        config.emmitEvents ? no
      draggable:          config.draggable ? yes
      centerImages:       config.centerImages ? yes
      navigatorInParent:  config.navigatorInParent ? no
      preventLinksOnDrag: config.allowLinks ? no

    #jQuery Objects
    @$sliderViewport   = $('#' + sliderId)
    @$slider           = $ @$sliderViewport.children('.slider')
    @$sliderItems      = $ @$slider.children('li')
    @$sliderPrevBtn    = $ @$sliderViewport.children('.prevBtn')
    @$sliderNextBtn    = $ @$sliderViewport.children('.nextBtn')

    @startSlider()

  config: (property, value)->
    @settings[property] = value
    this

  startSlider: ->
    @setSlider()

    if @elementsQ > 1
      @setListeners()
    else
      @disableBtns()

  setSlider: ->
    @viewPortWidth = @$sliderViewport.width()
    @elementsQ = @$sliderItems.length
    @sliderWidth = @elementsQ * 100
    @percentageStep = sliderItemWidth = 100 / @elementsQ
    @rightLimit = (@viewPortWidth * @elementsQ) - @viewPortWidth #
    @$sliderItems.css 'width', "#{sliderItemWidth}%"

    @$slider.css
      'width': "#{@sliderWidth}%"
      'transition-duration': "#{@settings.duration}s"

    # In order to prevent any other link event handler to activate first we find the childrens and use those to
    # stop and Immediate Propagation of the event
    if @settings.preventLinksOnDrag
      @$sliderLinks ?= @$sliderItems.children().children()

    if @settings.navigatorInParent
      @$sliderNavBtns  ?= $ @$sliderViewport.parent().find('.navigator a')
    else
      @$sliderNavBtns  ?= $ @$sliderViewport.children('.navigator').children()

    #if not @$sliderNavBtns? then @addNavigator()

    #Slider sizing variables and settings
    @index = 0
    @slideToPos = 0
    @draggedEl = null
    @hasLimitClass = false
    this

  setListeners: ->
    @$sliderPrevBtn.click (e)=>
      e.stopPropagation()
      @slideTo('prev')

    @$sliderNextBtn.click (e)=>
      e.stopPropagation()
      @slideTo('next')

    # Navigator Bullets

    ###
    Disabled for dgroupe, was causing a bug, so this a dirt hack, later should be refactored.
    @$sliderNavBtns.mousedown (e)=>
      e.stopPropagation()
      index = $(e.currentTarget).index()
      @slideTo(index)
    ###

    # Drag
    if @settings.draggable
      @$sliderViewport.on 'click a', (e)=>
        e.preventDefault()
        e.stopPropagation()

      @$sliderViewport.find('a').on 'mousedown', (e)=>
        console.log('currentTarget', e.currentTarget)
        @linkTarget = $(e.currentTarget).attr('href')
        if @settings.preventLinksOnDrag
          Backbone.history.navigate(@linkTarget, true)
          @linkTarget = null

      @$sliderViewport.on 'mousedown :not(.prevBtn)', (e)=>
        console.log 'mousedown'
        e.stopPropagation()
        e.preventDefault()
        @draggedEl = e.currentTarget
        @dragStart(e.pageX)
        null

      @$sliderViewport.on 'touchstart', (e)=>
        e = e.originalEvent
        x = e.touches[0].pageX
        @draggedEl = e.currentTarget
        @dragStart(x, 'touchmove')
        null

      # Removes mousemove ev when the mouse is up anywhere in
      # the doc using the ev target stored in the mousedow ev
      # if @dragStartX means the current object called by the handler
      # did not started the mousedown event so we skip it

      $(document).on 'mouseup',(e)=>
        e.stopPropagation()
        e.preventDefault()
        @dragEnd(e.pageX)

      @$sliderViewport.on 'touchend',(e)=>
        #not working
        console.log 'e.originalEvent', e.originalEvent
        x = e.originalEvent.touches[0].pageX
        @dragEnd(x)

    $( window ).resize =>
      setTimeout =>
        @setSlider()
      , 1

  this

  disableBtns: ->
    @$sliderPrevBtn.css('opacity', 0.2)
    @$sliderNextBtn.css('opacity', 0.2)
    this

  dragStart: (startX, inputEvent = 'mousemove')->
    $el = $ @draggedEl
    @dragStartX = startX
    slideToPos = @$slider.position().left
    dragPos = (slideToPos / @viewPortWidth) * 100


    @$slider.css
      'transition-duration': '0s' # We are doing direct manipulation, no need for transitions here

    $el.on inputEvent, (ev)=>
      ev = ev.originalEvent
      x = if inputEvent is 'mousemove' then ev.pageX else ev.touches[0].pageX
      @dragg(startX, x, slideToPos)


  dragg: (startX, currentX, slideToPos) =>
    offsetX = startX - currentX # Difference between the new mouse x pos and the previus one
    slideToPos -= offsetX

    # Refactor below asap

    if slideToPos >= 0
      slideToPos = 0
      @isOutBounds = yes
      @dragStartX = currentX

      unless @hasLimitClass
        @$sliderViewport.addClass('onLeftLimit')
        @hasLimitClass = yes

    else if slideToPos <= -@rightLimit
      slideToPos = -@rightLimit
      @isOutBounds = yes
      @dragStartX = currentX

      unless @hasLimitClass
        @$sliderViewport.addClass('onRightLimit')
        @hasLimitClass = yes

    dragPos = (slideToPos / @viewPortWidth) * 100
    dragPos = dragPos * (@percentageStep / 100)

    @$slider.css('transform', "translate3d(#{dragPos}%, 0, 0)")
    @isOutBounds = no

    null

  dragEnd: (currentX)->
    if @draggedEl or @clicked #not working, always null :S
      console.log 'drag end event fired for ' + @sliderId
      console.log @draggedEl
      if @hasLimitClass
        @$sliderViewport.removeClass('onLeftLimit onRightLimit')
        @hasLimitClass = no

      offsetX = @dragStartX - currentX
      offsetPercentage = Math.abs (offsetX / @viewPortWidth)
      minToAction = 0.1 # The user must have dragged the slider at least 10% to move it
      if offsetPercentage < minToAction then offsetPercentage = 0

      if offsetX > 0 and not @isOutBounds

        ## Dragued-> right
        console.log "Dragued-> right"
        tempIndex = @index + Math.ceil(offsetPercentage)
      else if offsetX < 0 and not @isOutBounds

        ## Dragued-> left
        console.log "Dragued-> left"
        tempIndex = @index - Math.ceil(offsetPercentage)
      else

        ## Didn't move, or at least not much
        console.log "Didn't move, or at least not much"
        tempIndex = @index
        if @linkTarget?
          console.log 'Navigating to the previously clicked link', @linkTarget
          Backbone.history.navigate(@linkTarget, true)
          @linkTarget = null

      console.log "tempIndex:" + tempIndex
      @slideTo(tempIndex)

      # if it goes beyond a certain percentage we use slideTo to move
      # to the next slide or we use it to center up the current one
      $(@draggedEl).off('mousemove')

      #if not @settings.preventLinksOnDrag
      @draggedEl = null

      console.log @draggedEl
      false

  ###
  # Moves the slider to the prev, next, or an specific position based on the command argument
  # @param {string}|{integer} command
  # @return {void}
  ###

  slideTo: (command)->
    @clicked = null
    console.log 'slideTo Called with argument:' + command
    switch command
      when 'next'
        @index++
      when 'prev'
        @index--
      when 'first'
        @index = 0
      when 'last'
        @index = @elementsQ - 1
      else
        if isFinite(command)
          @index = command
        else
          err = 'Please provide a valid command for the slider [prev,next or a valid index]'
          console.error err
          return false


    lastIndx = (@elementsQ - 1)
    if @index > lastIndx
      if @settings.cycle
        @index = 0
      else
        @index = lastIndx
        return false
    else if @index < 0
      if @settings.cycle
        @index = lastIndx
      else
        @index = 0
        return false

    console.log 'index:' + @index
    slideToPos = -1 * (@index * @percentageStep)
    if(@settings.navigator)
      @$sliderNavBtns.removeClass 'selected'
      $(@$sliderNavBtns[@index]).addClass 'selected'

    @$slider.css
      'transform': "translate3d(#{slideToPos}%, 0, 0)"
      'transition-duration': "#{@settings.duration}s"

    if(@settings.emmitEvents)
      $.event.trigger('onSlide', [@index, @sliderId]);

    this


$ ->
  # Home Slider -> Contains the frame sliders
  window.sliders.main = new Slider 'mainSlider',
    autoHideBtns: yes
    emmitEvents: on
  # Home Frames Sliders
  for frameName in ['frameMusicSldr', 'frameOnSldr', 'frameCorpSldr', 'frameEventsSldr']
    new Slider frameName, {}

  # Sections Sliders
  for sectionName in ['on', 'music', 'events', 'corp']
    sectionName += 'Section'
    sliderName = "#{sectionName}Sldr"
    window.sliders[sectionName] = new Slider sliderName ,
      emmitEvents: on
      navigator: yes
      navigatorInParent: yes
      navigatorEvents: no

  for djHouse in ['kukaramakara', 'lussac', 'sixttina', 'delaire', 'lussac']
    sliderId = "#{djHouse}DjSlider"
    new Slider sliderId,
      emmitEvents: off
      autoHideBtns: yes
      draggable: no

  $('.socialBlock').click (e)->
    e.stopPropagation()

  # Since the slider handlers will preventDefault behavior like
  # user-select, we counter effect this by preventing propagation
  # of the event call when triggered on the elements that we want
  # to allow selections. mousedown will allow this, and clicking
  # allows to cancel the selection, so both must be added.

  $('#newsWrapper, .socialBlock, .pageNavi').on
    click: (e)->
      e.stopPropagation()
    mousedown: (e)->
      e.stopPropagation()