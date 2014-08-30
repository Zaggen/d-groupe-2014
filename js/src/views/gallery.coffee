root = window ? global
Dgroupe = root.Dgroupe

class Dgroupe.Views.Gallery extends Dgroupe.Views.CollectionView
  template: root.template('galleryTemplate')
  tagName: 'div'
  className: 'grid'
  events:
    'click img' : 'lightboxHandler'

  initialize: ->
    console.log 'this', this
    super
    if $('#' + @id)?
      @setElement('#' + @id)
      @populateGalImgs()

  lightboxHandler:(e)=>
    e.preventDefault()
    @setLightBox()

    index = parseInt $(e.currentTarget).data('index')
    console.log 'opening lightbox with index', index
    @openLightBox(index)

  setLightBox: ->
    @getAllGalItems()
    $.event.trigger({
      type: 'setLightbox'
      collection: @galleryImgs
    })

  openLightBox: (index)->
    $.event.trigger({
      type: 'showLightBox'
      modelIndex: index
    })

  populateGalImgs: ->
    console.log 'populating collection gallery for view'
    galleryImgs = []
    @$('a').each ->
      json = {}
      $link = $(this)
      json.title = $link.attr('title')
      json.fullImg = $link.attr('href')
      json.thumbnail = $link.find('img').attr('src')
      galleryImgs.push(json)

    @galleryImgs = new Backbone.Collection(galleryImgs)

  # This collection will be used by the lightbox, since it expects an array like collection
  # containing only the images data, and the collection used in this view uses a lot more data
  # check the model related to this view for further reference
  getAllGalItems: ->
    unless @galleryImgs?
      galleryImgs = [];
      @collection.each (item)->
        imgs = item.toJSON().galleryItems
        imgs.forEach (imgArr)->
          galleryImgs = galleryImgs.concat(imgArr)

      console.log 'galleryItems', galleryImgs

      @galleryImgs = new Backbone.Collection(galleryImgs)

  render: ->
    @galleryImgs = null
    console.log @el
    if _.isEmpty(@collection.models)
      console.log 'collection is empty, fetching it now'
      @collection.fetchPage(1)
    else
      console.log 'collection fetched, now rendering'
      @$el.html @template(gallery: @collection.toJSON())

    @delegateEvents()
    this