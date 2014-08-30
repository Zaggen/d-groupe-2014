root = window ? global
Dgroupe = root.Dgroupe

class Dgroupe.Models.SingleEntry extends Dgroupe.Models.Base

  fetch: ->
    @url = '/' + Backbone.history.fragment
    console.log '@url', @url
    super
    true