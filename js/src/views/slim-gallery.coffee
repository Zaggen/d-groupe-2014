root = window ? global
Dgroupe = root.Dgroupe

class Dgroupe.Views.SlimGallery extends Backbone.View
  tagName: 'div'
  className: 'grid'
  events:
    'click img' : 'lightboxHandler'

  initialize: (options)->
    @mode = options.mode ? 'images'
    if $('#' + @id)?
      @setElement('#' + @id)
      @populateGalItems()


  lightboxHandler:(e)=>
    e.preventDefault()
    @setLightBox()
    index = parseInt $(e.currentTarget).data('index')
    @openLightBox(index)

  setLightBox: ->
    $.event.trigger({
      type: 'setLightbox'
      mode: @mode
      collection: @galleryItems
    })

  openLightBox: (index)->
    $.event.trigger({
      type: 'showLightBox'
      modelIndex: index
    })

  populateGalItems: ->
    linkTargetKey = if @mode is 'images' then 'fullImg' else 'embedUrl'
    galleryItems = []
    @$('a').each ->
      json = {}
      $link = $(this)
      json.title = $link.attr('title')
      json[linkTargetKey] = $link.attr('href')
      json.thumbnail = $link.find('img').attr('src')
      galleryItems.push(json)

    @galleryItems = new Backbone.Collection(galleryItems)

  # This collection will be used by the lightbox, since it expects an array like collection
  # containing only the images data, and the collection used in this view uses a lot more data
  # check the model related to this view for further reference
