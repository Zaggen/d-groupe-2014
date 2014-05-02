root = window ? global
Dgroupe = root.Dgroupe

#Models

class Dgroupe.Models.News extends Backbone.Model
  defaults:
    title: 'Lorem'
    date: '2 Abril 2014'
    content: 'Lorem ipsum dolor'
    imgSrc: 'imgs/lorem.jpg'

#Collections

class Dgroupe.Collections.News extends Backbone.Collection
  model: Dgroupe.Models.News
  url: '/news-feed'