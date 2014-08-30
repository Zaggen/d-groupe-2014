root = window ? root
Dgroupe = root.Dgroupe

class Dgroupe.Views.MainLoader extends Backbone.View
  className: 'progress'
  id: 'mainLoader'

  initialize: ->
    if $('#' + @id)[0]?
      @setElement('#' + @id)

    @hideClass = 'hidden'
    $(document).on('showLoader', @show)
    $(document).on('hideLoader', @hide)
    @render()

  show: =>
    console.log 'showing loader'
    @$el.removeClass(@hideClass)

  hide: =>
    console.log 'hiding loader'
    @$el.addClass(@hideClass)