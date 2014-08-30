root = window ? global
Dgroupe = root.Dgroupe

# Full Entry View
class Dgroupe.Views.SingleEntry extends Dgroupe.Views.BaseContent
  template: root.template('fullEntryTemplate')
  tagName: 'article'
  className: 'fullEntry'
  id: 'singleEntry'

  events:
    'click a': 'backToNews'

  initialize: ->
    super
    if $('#' + @id)[0]?
      @setElement('#' + @id)

  backToNews: (e)->
    e.preventDefault()
    e.stopPropagation()
    route = $(e.currentTarget).attr('href')
    Backbone.history.navigate(route, yes)