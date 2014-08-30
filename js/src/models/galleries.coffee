root = window ? global
Dgroupe = root.Dgroupe

#Models

class Dgroupe.Models.GalleryImg extends Backbone.Model
  defaults:
      title : 'Gallery Title',
      galleryItems:[
        {
          title: 'Image title'
          thumbnail: 'src path'
          fullImg: 'src path'
        },
        {
          title: 'Image title'
          thumbnail: 'src path'
          fullImg: 'src path'
        }
      ]

#Collections
class Dgroupe.Collections.Gallery extends Dgroupe.Collections.Paginated
  model: Dgroupe.Models.GalleryImg
  url: '/json-gallery'

  initialize: (options)->
    @url = @url + (options?.urlQuery ? '')
    console.log '@url', @url

  parse: (response, options)->
    console.log 'parsing response', response
    @pageQ = response.pageQ
    response.galleries