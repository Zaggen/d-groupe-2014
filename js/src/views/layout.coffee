root = window ? global
Dgroupe = root.Dgroupe

class Dgroupe.Views.Layout extends Backbone.View

  initialize: ->
    @fadeInClass = 'fastFadeIn'
    @fadeOutClass = 'fastFadeOut'
    @firstLoad = yes
    @oldViews = []

  fadeOut: ()->
    @$el.removeClass(@fadeInClass)
        .addClass(@fadeOutClass)

  fadeIn: (region)->
    @$el.removeClass(@fadeOutClass)
        .addClass(@fadeInClass)

  closeOldViews: ()->
    console.log 'Views to be closed', @oldViews
    for view in @oldViews
      view.close()

  ###
  # Takes an array containing one or more view instance as argument, adds a fadeOut fx to hide the current content
  # then it renders each view instance from the array and extracts its node element (el) and pushes it into an array
  # that is later (after the fadeIn completes) added as the html content of the layoutView
  ###
  show: (views)->
    console.log 'Ready to show these views:', views
    if not @firstLoad
      # Based on the .fastFadeIn and .fastFadeOut duration, changes
      # must be made in the css classes and here to alter the delay
      delay = 500
      @fadeOut()
      viewNodes = []
      for view in views
        node =  view.render().el
        viewNodes.push(node)

      # We wait until the fadeOut is complete to clean the regions and append our new views
      _.delay(
        _.bind ->
          @closeOldViews()
          console.log 'Done closing views, now we call html() with the new nodes->', viewNodes
          @$el.html(viewNodes)
          @fadeIn()
          @oldViews = views
        , this
        delay)
    else
      console.log 'But is the first load so we do nothing'
      @oldViews = views
      @firstLoad = no

    this