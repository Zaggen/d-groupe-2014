root = window ? global
Dgroupe = root.Dgroupe

# Pagination View

class Dgroupe.Views.Lightbox extends Backbone.View
  className: 'lightBox hidden'
  id: 'lightBox'
  events:
    'click .closeBtn, .overlay': 'hide'
    'click .prevBtn': 'prev'
    'click .nextBtn': 'next'

  initialize: ->
    console.log 'a new lightbox has been instanciated', this
    @hideClass = 'hidden'
    @currentIndex = 0
    $(document).on('setLightbox', @set)
    $(document).on('showLightBox',@show)
    @closed = yes

    # If the element is present on the DOM there is no need to render the view, we just attach the el to it
    if $('#' + @id)?
      console.log "setting el to #lightBox"
      @setElement('#' + @id)
    else
      @render()

    @setKeyBinding()
    @setResizeHandler()
    this


  setResizeHandler: ->
    @resized = no
    $(window).on 'resize', =>
      @resized = yes
      if @imgSize?
        @resizeWindow(@imgSize.width, @imgSize.height, no)
    this

  setKeyBinding: ->
    $(document).keydown (e)=>
      unless @closed
        if(e.which is 37)
          @prev()
        else if(e.which is 39)
          @next()

  set: (options)=>
    console.log 'collection about to be set'
    unless @collection is options.collection
      @collection = options.collection
      @settings =
        mode: options.mode ? 'images' # Could be iframes for embedded video iframes
        cycle: options.cycle ? yes

      if _.isEmpty(@collection.models)
        console.warn 'Collection is empty'

  show: (e)=>
    @currentIndex = e.modelIndex
    console.log 'showing current index:', @currentIndex
    @$el.removeClass(@hideClass)
    model = @collection.at(@currentIndex).toJSON()
    @loadContent( model, yes )
    @closed = no

  hide: ->
    @$el.addClass(@hideClass)
    @resizeWindow(0, 0, yes)
    @$content.empty()
    @imgSize = null
    @closed = yes

  hideLoader: ->
    @$progressLoader ?= @$el.find('.progress')
    @$progressLoader.addClass(@hideClass)

  showLoader: ->
    @$progressLoader ?= @$el.find('.progress')
    @$progressLoader.removeClass(@hideClass)

  prev: ()->
    # Only decrease the index when its greater than 0
    # or set to the last model in the collection when cycle is on
    if @currentIndex isnt 0
      @currentIndex--
    else
      if @settings.cycle
        @currentIndex = @collection.length - 1


    model = @collection.at(@currentIndex).toJSON()
    @loadContent(model)

  next: ()->
    # Only increase the index when its less than the collection size(-1)
    # or set back to the first model when cycle is on
    if @currentIndex  < @collection.length - 1
      @currentIndex++
    else
      if @settings.cycle
        @currentIndex = 0

    model = @collection.at(@currentIndex).toJSON()
    @loadContent(model)

  loadContent: (modelObj, addTransition = no)->
    if @settings.mode is 'images'
      @loadImage(modelObj, addTransition)
    else # @settings.mode is 'iframe'
      @loadIframe(modelObj, addTransition)

  loadImage: (modelObj, addTransition = no)->
    # Loads the img as an obj, and when is fully load places it on the figure container and then
    # resizes the lightbox window
    console.log 'load image'
    @showLoader()
    @$content ?= @$el.find('#lightboxContent')
    img = new Image()
    $img = $(img)

    $img.one 'load', =>

      @imgSize =
        width : img.width
        height: img.height

      @$content.html(img)
      @resizeWindow(@imgSize.width, @imgSize.height, addTransition)
      @hideLoader()
      @preloadNextImage()

    $img.one 'error', ->
      console.log 'error, img not found'

    img.src = modelObj.fullImg

    # Triggers load event when the image is cached and not actually loaded from server
    if img.complete then $img.load()

  preloadNextImage: ->
    if @currentIndex  < @collection.length - 1
      index = @currentIndex + 1
    else
      if @settings.cycle
        index = 0

    modelObj = @collection.at(index).toJSON()
    img = new Image()
    img.src = modelObj.fullImg

  loadIframe: (modelObj, addTransition = no)->
    @$content ?= @$el.find('#lightboxContent')
    @showLoader()
    iframeW = 600
    iframeH = 390
    $iframe = $('<iframe />')
    .attr('src', modelObj.embedUrl)
    .css
        width:  iframeW
        height: iframeH

    @$content.html($iframe)
    @resizeWindow(iframeW, iframeH)

    # Check if iframe is already loaded, else attach @hideLoader to the load event
    if $iframe.get(0).complete
      @hideLoader()
    else
      $iframe.load =>
        @hideLoader()



  resizeWindow: (width, height, addTransition = no)->
    console.log 'reziseWindow called with the following args: w:' + width + ', h:' + height
    @$lightBoxWindow ?= @$el.find('.window')

    if @resized or not @limits?
      @setLimits()
      @resized = no

    if(width > @limits.width or height > @limits.height)
      wMultiplier = @limits.width / width
      hMultiplier = @limits.height / height
      multiplier = if wMultiplier < hMultiplier then wMultiplier else hMultiplier
      console.log 'multiplier', multiplier
      width *= multiplier
      height *= multiplier

    top = height / 2
    left = width / 2

    if addTransition
      @$lightBoxWindow.addClass('transitionAll')
    else
      @$lightBoxWindow.removeClass('transitionAll')

    console.log 'resizing to ' + width

    @$lightBoxWindow.css
      width: "#{width}px"
      height: "#{height}px"
      margin: "-#{top}px 0 0 -#{left}px"

    @resized = no
    this

  setLimits: =>
    console.log 'setting limits'
    percentLimint = 0.8
    @limits =
      width : @$el.outerWidth() * percentLimint
      height : @$el.outerHeight() * percentLimint
    console.log '@limits', @limits

  close:->
    $(document).off('showLightBox', @show)
    super

  render: ->
    @$el.html @template()
    this