root = window ? global # no need for node.js global in a slider but w/e
root.sliders = {}
$ = root.jQuery

class Slider
  constructor:(@sliderId, config = {})->
    $ = window.jQuery

    @$sliderViewport   = $('#' + sliderId)
    @$slider           = $ @$sliderViewport.children('.slider')
    @$sliderItems      = $ @$slider.children('li')
    @$sliderPrevBtn    = $ @$sliderViewport.children('.prevBtn')
    @$sliderNextBtn    = $ @$sliderViewport.children('.nextBtn')
    if config.navigatorInParent?
      @$sliderNavBtns    = $ @$sliderViewport.parent().find('.navigator a')
    else
      @$sliderNavBtns    = $ @$sliderViewport.children('.navigator').children()


    @viewPortWidth = @$sliderViewport.width()
    @elementsQ = @$sliderItems.length
    @sliderWidth = @elementsQ * 100
    sliderItemWidth = 100 / @elementsQ
    @rightLimit = (@viewPortWidth * @elementsQ) - @viewPortWidth #
    @$slider.css 'width', "#{@sliderWidth}%"
    @$sliderItems.css 'width', "#{sliderItemWidth}%"

    @settings =
      viewportMaxWidth:  config.viewportMaxWidth ? 1000
      viewportMaxHeight: config.viewportMaxHeight ? 500
      slideShow:         config.slideShow ? yes
      stopOnHover:       config.stopOnHover ? yes
      cycle:             config.cycle ? yes
      navigator:         config.navigator ? no
      navigatorEvents:   config.navigatorEvents ? no
      autoHideBtns:      config.autoHideBtns ? yes ## not implemented
      duration:          config.duration ? 1000
      emmitEvents:       config.emmitEvents ? no
      draggable:         config.draggable ? yes


    @index = 0
    @slideToPos = 0
    @draggedEl = null
    @hasLimitClass = false

    ## Listeners

    @$sliderPrevBtn.click (e)=>
      e.stopPropagation()
      @slideTo('prev')

    @$sliderNextBtn.click (e)=>
      e.stopPropagation()
      @slideTo('next')

    # Navigator Bullets

    @$sliderNavBtns.mousedown (e)=>
      e.stopPropagation()
      index = $(e.currentTarget).index()
      #@slideTo(index)

    ## Drag
    if @settings.draggable
      @$sliderViewport.mousedown (e)=>
        e.stopPropagation()
        e.preventDefault()
        @dragStart(e)

      # Removes mousemove ev when the mouse is up anywhere in
      # the doc using the ev target stored in the mousedow ev
      # if @dragStartX means the current object called by the handler
      # did not started the mousedown event so we skip it

      $(document).mouseup (e)=>
        e.stopPropagation()
        e.preventDefault()
        @dragEnd(e)


  dragStart: (e)->
    $el = $ e.currentTarget
    @dragStartX = e.pageX
    startX = e.pageX
    @draggedEl = e.currentTarget
    @slideToPos = @$slider.position().left
    #unless @slideToPos is 0
     # console.log "slideToPos:#{@slideToPos}"
    @$slider.stop()

    $el.on 'mousemove', (ev)=>

     # console.log "slideToPos:#{@slideToPos}"

      offsetX = startX - ev.pageX # Difference between the new mouse x pos and the previus one

      startX = ev.pageX

      @slideToPos -= offsetX

      # Refactor below asap

      if @slideToPos >= 0
        @slideToPos = 0
        @isOutBounds = yes
        @dragStartX = startX
        unless @hasLimitClass
         @$sliderViewport.addClass('onLeftLimit')
         @hasLimitClass = yes

      else if @slideToPos <= -@rightLimit
        @slideToPos = -@rightLimit
        @isOutBounds = yes
        @dragStartX = startX
        unless @hasLimitClass
          @$sliderViewport.addClass('onRightLimit')
          @hasLimitClass = yes

      @$slider.css('left', @slideToPos + 'px')
      @isOutBounds = no
      ###
      We should use a better way to move the elements around, using forced gpu calcs
      @$slider.css({
        '-webkit-transform': "translate3d(#{@slideToPos}%, 0px, 0px) perspective(2000px)"
      })
      ###
      null

  dragEnd: (e)->
    unless not @draggedEl? or @clicked
      if @hasLimitClass
         @$sliderViewport.removeClass('onLeftLimit onRightLimit')
         @hasLimitClass = no

      offsetX = @dragStartX - e.pageX
      #console.log 'offsetX:' + offsetX
      offsetPercentage = Math.abs (offsetX / @viewPortWidth)
      minToAction = 0.1 # The user must have dragged the slider at least 10% to move it
      #console.log "offsetPercentage #{offsetPercentage}"
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

      console.log "tempIndex:" + tempIndex
      @slideTo(tempIndex)
      # if it goes beyond a certain percentage we use slideTo to move
      # to the next slide or we use it to center up the current one
      console.log 'mouse is up'
      #console.log "The total offsetPercentage is #{offsetPercentage}"
      $(@draggedEl).off('mousemove')
      @draggedEl = null
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
    @slideToPos = -1 * (@index * 100)
    if(@settings.navigator)
      console.log @$sliderNavBtns.get(0)
      @$sliderNavBtns.removeClass 'selected'
      $(@$sliderNavBtns[@index]).addClass 'selected'

    @$slider.stop().animate({'left': @slideToPos + '%'}, @settings.duration)
    if(@settings.emmitEvents)
      $.event.trigger('onSlide', [@index, @sliderId]);


    ###
    @$slider.stop().css({
      '-webkit-transform': "translate3d(#{@slideToPos}%, 0px, 0px) perspective(2000px)"
    })
    ###

$ ->
  # Home Slider -> Contains the frame sliders
  sliders.main = new Slider 'mainSlider',
    autoHideBtns: yes
    emmitEvents: yes
  # Home Frames Sliders
  sliders.canalOn = new Slider 'frameMusicSldr', {}
  sliders.canalMusical = new Slider 'frameOnSldr', {}
  sliders.canalCorp = new Slider 'frameCorpSldr', {}
  sliders.eventos = new Slider 'frameEventsSldr', {}
  # Sections Sliders
  sliders.onSection = new Slider 'onSectionSldr' ,
    emmitEvents: yes
    navigator: yes
    navigatorInParent: yes
    navigatorEvents: no

  sliders.musicSection = new Slider 'musicSectionSldr' ,
      emmitEvents: yes
      navigator: yes
      navigatorInParent: yes
      navigatorEvents: no


  sliders.eventSection = new Slider 'eventSectionSldr' ,
    emmitEvents: yes
    navigator: yes
    navigatorInParent: yes
    navigatorEvents: no


  sliders.corpSection = new Slider 'corpSectionSldr' ,
    emmitEvents: yes
    navigator: yes
    navigatorInParent: yes
    navigatorEvents: no

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