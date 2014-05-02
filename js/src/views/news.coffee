root = window ? global
Dgroupe = root.Dgroupe

# News Views

class Dgroupe.Views.NewsCollection extends Dgroupe.Views.ColectionView
  tagName: 'ul'
  id: 'newsFeed'
  className: 'feed'

  render: ->
    $parent = $('#newsWrapper')
    $parent.empty()
    @$el.empty()

    nodes = []

    console.log @collection.toJSON()

    @collection.each (news)=>
      newsView = new Dgroupe.Views.News model: news
      newsView.delegateEvents()
      nodes.push newsView.render().el
    @$el.append nodes
    $parent.append(@el)
    this

class Dgroupe.Views.News extends Backbone.View
  tagName: 'li'
  className: 'entry'

  events:
    'click': 'showFullEntry'

  showFullEntry: (e)=>
    e.preventDefault()
    e.stopPropagation()
    fullNews = new Dgroupe.Views.fullNews model: @model
    $('#newsWrapper').html(fullNews.render().el)

  template: template('newsEntries')

  render: ->
    @$el.html @template @model.toJSON()
    this



class Dgroupe.Views.fullNews extends Backbone.View
  tagName: 'article'
  className: 'fullEntry'

  template: template('fullEntry')

  render: ->
    @$el.html @template @model.toJSON()
    App.backToListBtn.$el.removeClass('hidden')
    App.newsNavi.$el.addClass('hidden')
    this