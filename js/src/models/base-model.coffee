root = window ? global
Dgroupe = root.Dgroupe

class Dgroupe.Models.Base extends Backbone.Model

  fetch: ->
    $.event.trigger( type: 'showLoader' )
    super.success(
      _.delay(
        ->
          $.event.trigger( type: 'hideLoader' )
      ,550)
    )