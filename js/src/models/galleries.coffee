root = window ? global
Dgroupe = root.Dgroupe

#Models

class Dgroupe.Models.GalleryImg extends Backbone.Model
  defaults:
    title: 'Image'
    thumbnail: 'src path'
    fullImg: 'src path'

#Collections

class Dgroupe.Collections.Gallery extends Backbone.Collection
  model: Dgroupe.Models.GalleryImg
  url: '/json-gallery'