root = window ? global
Dgroupe = root.Dgroupe

class Dgroupe.Collections.Paginated extends Backbone.Collection

  fetchPage: (page = 1, callback)->
    console.log 'fetching page collection', page
    $.event.trigger( type: 'showLoader' )
    @fetch
      reset: yes
      data:
        page: page
      success: (collection, response)=>
        $.event.trigger( type: 'hideLoader' )
        if callback then callback(collection, response)
        true

      error: (collection, response)->
        console.log 'Error while fetching the collection'
        console.log response
        false

      this