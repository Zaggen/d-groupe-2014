root = window ? global
Dgroupe = root.Dgroupe

class Dgroupe.Views.CollectionView extends Backbone.View
  initialize: (options)->
    @listenTo(@collection, 'sync', @render)
    @itemViewClass = options.itemViewClass
    @hideClass = 'hidden'

  renderCollectionNodes: ->
    nodes = []
    @collection.each (itemModel)=>
      itemView = new @itemViewClass( model:itemModel )
      itemView.delegateEvents()
      nodes.push itemView.render().el
    nodes

  hideLoader: ->
    console.log 'hiding loader'
    @$progressLoader ?= @$el.find('.progress')
    console.log @$progressLoader
    @$progressLoader.addClass(@hideClass)

  showLoader: ->
    console.log 'showing loader'
    @$progressLoader ?= @$el.find('.progress')
    console.log @$progressLoader
    @$progressLoader.removeClass(@hideClass)

  render: =>
    if _.isEmpty(@collection.models)
      console.log 'collection is empty, fetching it now'
      @collection.fetchPage(1)
    else
      console.log 'collection fetched, now rendering'
      nodes = @renderCollectionNodes()
      @$el.html(nodes)

    @delegateEvents();
    this

class Dgroupe.Views.CompositeView extends Dgroupe.Views.CollectionView

  initialize: (options)->
    super
    @querySelector = options.querySelector ? 'ul'

  render: ->
    @$el.html @template()
    if _.isEmpty(@collection.models)
      console.log 'collection is empty, fetching it now'
      @collection.fetchPage(1)
    else
      console.log 'collection fetched, now rendering'
      collectionView = @$el.find(@querySelector)
      nodes = @renderCollectionNodes()
      collectionView.html(nodes)

    @delegateEvents();
    this