root = window ? global
Dgroupe = root.Dgroupe

#Models

class Dgroupe.Models.News extends Backbone.Model
  defaults:
    title: 'Lorem'
    date: '2 Abril 2014'
    excerpt: 'Lorem ipsum...'
    thumbnail: 'imgs/lorem-small.jpg'
    permalink: 'permalink'

#Collections

class Dgroupe.Collections.News extends Dgroupe.Collections.Paginated
  model: Dgroupe.Models.News
  url: '/news-feed'