root = window ? global

$ = root.jQuery

root.template = (id)->
  _.template( $('#' + id).html() )


# Used to filter each ajax json request for the backbone models
baseFolder = window.location.pathname.replace('/','').split('/')[0] # Also used as the backbone history root
rootUrl = window.location.protocol + "//" + window.location.host + "/" + baseFolder;
$.ajaxPrefilter (options)->
  options.url = rootUrl + options.url
  false


class root.App
  @Models: {}
  @Collections: {}
  @Views: {}
  @Routers: {}

#Models

class App.Models.News extends Backbone.Model
  defaults:
    title: 'Lorem'
    date: '2 Abril 2014'
    content: 'Lorem ipsum dolor'
    imgSrc: 'imgs/lorem.jpg'

#Collections

class App.Collections.News extends Backbone.Collection
  model: App.Models.News
  url: '/noticias'

# Views

class App.Views.NewsCollection extends Backbone.View
  tagName: 'ul'
  id: 'newsFeed'

  initialize: ->
    @collection.bind('change', @updateView)
    @collection.bind('add', @yeldAdd)
    @fetchCollection(1)

  updateView: =>
    console.log 'I changed'
    @render().el

  yeldAdd: =>
    console.log 'add was made'
  #console.log @render().el

  fetchCollection: (page = 1, fetchCurrent = false)->
    @$el.addClass('pointEightOpcty')

    if(@page isnt page or fetchCurrent is true)
      @collection.fetch
        data: page: page
        success: =>
          @render()
        error: (collection, response)->
          console.log 'error while fetching the news collection'
          console.log response
        complete: =>
          $('body').css 'cursor','default'
          @$el.removeClass('pointEightOpcty')

      @page = page
    else
      $('body').css 'cursor','default'

  render: ->
    $parent = $('#newsWrapper')
    $parent.empty()
    @$el.empty()

    nodes = []

    @collection.each (news)=>
      newsView = new App.Views.News model: news
      newsView.delegateEvents()
      nodes.push newsView.render().el
    @$el.append nodes
    $parent.append(@el)
    this

class App.Views.News extends Backbone.View
  tagName: 'li'
  className: 'entry'

  events:
    'click': 'showFullEntry'

  showFullEntry: (e)=>
    e.preventDefault()
    e.stopPropagation()
    fullNews = new App.Views.fullNews model: @model
    $('#newsWrapper').html(fullNews.render().el)

  template: template('newsEntries')

  #template: _.template("<strong><%= title %></strong> (<%= date %>) - <%= content %>


  render: ->
    @$el.html @template @model.toJSON()
    this

class App.Views.fullNews extends Backbone.View
  tagName: 'article'
  className: 'fullEntry'

  template: template('fullEntry')

  render: ->
    @$el.html @template @model.toJSON()
    backToListBtn.$el.removeClass('hidden')
    newsNavi.$el.addClass('hidden')
    this

# Pagination

class App.Views.pagination extends  Backbone.View
  className: '.pageNavi',
  el: '#newsNavi'

  initialize: ->
    @pageQ = 3
    @render()

  getPageQ: ->


  render: ->
    # Renders the pagination list e.g : prev - 1 - 2 - 3 ... 8 - last (Not fully implemented yet)
    nodes = []

    for num in [1..@pageQ]
      pageNum = new App.Views.pageBtn
        pageNum : num
        className: if num is 1 then 'navBtns selectedNav' else 'navBtns'
      nodes.push pageNum.render().el
    @$el.html nodes


class App.Views.pageBtn extends Backbone.View
  tagName: 'li'
  events:
    'click': 'changePage'

  initialize: (options)->
    @pageNum = options.pageNum

  changePage: (e)->
    @$navBtns = $('.navBtns')
    @crntPage = $(e.currentTarget).index() + 1;
    $('body').css 'cursor','wait'
    console.log @$navBtns[0]
    @$navBtns.removeClass('selectedNav')
    @$el.addClass('selectedNav')
    newsViewCollection.fetchCollection(@crntPage)

  render: ->
    console.log @pageNum
    @$el.children().detach()
    @$el.append @pageNum
    this.$el.children().detach()
    this

class App.Views.ReturnToListBtn extends Backbone.View
  initialize: (options)->
    @listView = options.listView
    @el = options.el
    @nav = options.nav

  events:
    'click': 'backToList'

  backToList: =>
    console.log @listView.page
    @listView.fetchCollection(@listView.page, yes)
    @$el.addClass('hidden')
    @nav.$el.removeClass('hidden')



news = new App.Models.News
newsCollection = new  App.Collections.News
newsViewCollection = new App.Views.NewsCollection  collection: newsCollection

newsNavi = new App.Views.pagination
backToListBtn = new App.Views.ReturnToListBtn {
  listView: newsViewCollection
  el: '#backToNewsList'
  nav: newsNavi
}
###
$('.pageNavi li').click (e)->
  page = $(this).index() + 1;
  $('body').css 'cursor','wait'
  newsViewCollection.fetchCollection(page)
  newsCollection.at(0).set
    title: 'yikes'
    date: '2 Mayo 2014'
    content: 'The content has changed so much since you were here'
    imgSrc: 'imgs/news-dummy2.jpg'
###


# Routes and Navigation


class App.Routers.Router extends Backbone.Router
  routes:
    '' : 'home'
    'redes': 'social'
    'noticias': 'news'
    'contacto': 'contact'
    'portafolio/on(/:slide)': 'onSection'
    'portafolio/musical(/:slide)': 'musicSection'
    'portafolio/corporativo(/:slide)': 'corpSection'
    'portafolio/eventos(/:slide)': 'eventsSection'

  initialize: ->

    # Paths to prepend to each of the routes in slideRoutes
    portflRoot = 'portafolio/'
    onPath     = portflRoot + 'on/'
    musicPath  = portflRoot + 'musical/'
    corpPath =   portflRoot + 'corporativo/'
    eventPath =  portflRoot + 'eventos/'

    # Route names for each slider, based on the order the slides are placed on each slider
    @onSlides = ['kukaramakara', 'lussac', 'sixxtina', 'delaire']
    @musicSlides = ['fotos', 'videos', 'djs', 'calendario']
    @corpSlides = ['fotos', 'videos', 'calendario', 'contacto']
    @eventSlides = ['fotos', 'videos', 'calendario', 'contacto']

    # When a manual slide is made on any of these sliders, an update to the url will be made based on the
    # current index of the slided slider :) and the corresponding index of the @slideRoutes property array.
    @slideRoutes =
      mainSlider : ['#', 'redes', 'noticias']
      onSectionSldr: onPath + path for path in @onSlides
      musicSectionSldr : musicPath + path for path in @musicSlides
      eventSectionSldr: eventPath + path for path in @eventSlides
      corpSectionSldr: corpPath + path for path in @corpSlides

    # Event listener for all sliders, when one slides it will
    # trigger a url update using the navigate from backbone
    $(document).bind 'onSlide', (e, index, sliderId)=>

      console.log "sliderId: #{sliderId}"
      console.log "index: #{index}"

      if @slideRoutes[sliderId][index] isnt 'undefined'
        @.navigate('#' + @slideRoutes[sliderId][index]);
      null

  # Method to scroll up/down to a given position in px or to the
  # offset of an element which id matches the current route
  scrollTo: (scrollPos, removeFromFragment)->

    if scrollPos is Backbone.history.fragment

      if typeof removeFromFragment isnt 'undefined' and removeFromFragment?
        scrollPos = scrollPos.replace("/#{removeFromFragment}", '')

      targetId = scrollPos.split('/').pop()
      targetEl = $('#' + targetId)
      scrollPos = targetEl.offset().top - 125

    $('html,body').stop().animate({
      scrollTop: scrollPos
    }, 800)

    null


router = new App.Routers.Router();

navigateSection = (slide, prefix)->
  router.scrollTo(Backbone.history.fragment, slide)

  if slide?
    try

      #Move the slider to the index setted in the router prefix+'Slides'
      routeKey = "#{prefix}Slides"
      slidersKey = "#{prefix}Section"
      index = router[routeKey].indexOf(slide)
      console.log 'index is ' + index
      root.sliders[slidersKey].slideTo(index)
    catch e
      console.error 'There are no slides defined in the router for this slider. \n' + e.message
  #
  null

$ =>
  router.on 'route:home' , ->
    router.scrollTo(0)
    root.sliders.main.slideTo('first')
    null

  router.on 'route:news' , ->
    router.scrollTo(0)
    root.sliders.main.slideTo('last')
    null

  router.on 'route:social' , ->
    router.scrollTo(0)
    root.sliders.main.slideTo(1)
    null

  router.on 'route:onSection' , (slide)->
    navigateSection(slide, 'on')

  router.on 'route:musicSection' , (slide)->
    navigateSection(slide, 'music')

  router.on 'route:corpSection' , (slide)->
    navigateSection(slide, 'corp')

  router.on 'route:eventsSection' , (slide)->
    navigateSection(slide, 'event')

  router.on 'route:contact' , ->
    router.scrollTo(Backbone.history.fragment)
    null

Backbone.history.start
  pushState: true
  root: baseFolder # Change to the basefolder on production

# Fb Window behavior - Please refactor into Backbone views

$('a.route, .portfolioBtn').click (e)->
  e.stopPropagation()
  e.preventDefault()
  linkTarget = $(this).attr('href')
  console.log linkTarget
  router.navigate(linkTarget, true)

$('.fbIcon').click (e)->
  e.stopPropagation()
  e.preventDefault()
  parent = $(this).closest('.socialBlock')
  hiddenEl = $(parent).find('.hidden')
  if hiddenEl?
    hiddenEl.removeClass('hidden')

$('.closeBtn').click ->
  parent = $(this).closest('.socialBlock')
  $(parent).find('.fbBlock').addClass('hidden')

$('a.gal').has('img').colorbox
  maxWidth: '90%'
  maxHeight: '90%'
  rel:'on'

$('a.musicGal').has('img').colorbox
  maxWidth: '90%'
  maxHeight: '90%'
  rel:'musiGal'

$('a.ytGal').has('img').colorbox
  maxWidth: '90%'
  maxHeight: '90%'
  iframe: yes
  innerWidth:540
  innerHeight:346