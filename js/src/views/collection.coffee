root = window ? global
Dgroupe = root.Dgroupe

class Dgroupe.Views.ColectionView extends  Backbone.View
  initialize: ->
    @collection.bind('change', @updateView)
    @fetchCollection(1)

  setloadingState: (state)->
    fadeClass = 'halfFade'
    if state is 'start'
      @$el.addClass(fadeClass)
    else if state is 'end'
      $('body').css 'cursor','default'
      @$el.removeClass(fadeClass)
    else
      console.warn state + 'Is not a valid state for seTloadingState'

  updateView: =>
    @render().el

  fetchCollection: (page = 1, fetchCurrent = false)->
    @setloadingState('start')

    if(@page isnt page or fetchCurrent is true)
      @page = page
      @collection.fetch
        data:
          page: page
        success: =>
          @render()
        error: (collection, response)->
          console.log 'Error while fetching the collection'
          console.log response
        complete: =>
          @setloadingState('end')

    else
      @setloadingState('end')