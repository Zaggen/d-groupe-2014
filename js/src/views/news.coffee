root = window ? global
Dgroupe = root.Dgroupe

# News Views

class Dgroupe.Views.News extends Dgroupe.Views.CollectionView
  tagName: 'ul'
  className: 'grid'
  id: 'newsFeed'

  events:
    'click a': 'showFullEntry'

  initialize:(options)->
    super
    if $('#' + @id)[0]?
      @setElement('#' + @id)

  showFullEntry: (e)=>
    e.preventDefault()
    e.stopPropagation()
    $targetLink = $(e.currentTarget).attr('href')
    Backbone.history.navigate($targetLink, yes)
    null


class Dgroupe.Views.NewsEntry extends Backbone.View
  tagName: 'li'
  className: 'grid entry'
  template: template('newsEntryTemplate')

  render: ->
    @$el.html( @template @model.toJSON() )
    this