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

# News Views

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

    console.log @collection.toJSON()

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

# Navigation Views

class App.Views.navigation extends Backbone.View
  el: '#NavBar'

  initialize: ->



# Pagination Views

class App.Views.pagination extends  Backbone.View
  className: '.pageNavi',
  el: '#newsNavi'

  initialize: ->
    @pageQ = @$el.children().length
    @render()


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

mainNav = new App.Views.navigation
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
    '(/)' : 'home'
    'redes(/)': 'social'
    'noticias(/)': 'news'
    'contacto(/)': 'contact'
    'portafolio/on(/:slide)(/)': 'onSection'
    'portafolio/musical(/:slide)(/)': 'musicSection'
    'portafolio/corporativo(/:slide)(/)': 'corpSection'
    'portafolio/eventos(/:slide)(/)': 'eventsSection'

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

  navigateOnLoad: ->

    # Since we are using wp for this project, any other page than index will redirect to home,
    # we want to scroll to the desired location after that http redirect. Backbone doesn't
    # allow to trigger functions associated with a route is the path is the same, so we first
    # change the route to the home, which is always visible, and then we trigger our navigate
    linkTarget = window.location.pathname.replace('/' + baseFolder, '')
    console.log 'linkTarget: ' + linkTarget
    @navigate('/')
    @navigate(linkTarget, yes)

  # Method to scroll up/down to a given position in px or to the
  # offset of an element which id matches the current route
  scrollTo: (scrollPos, itemToSkip)->

    # In case that scrollPos is a url and not a direct vertical position, we extract the corresponding element id
    # from the path, by skiping any path specified(only one) in the second argument
    if scrollPos is Backbone.history.fragment
      pathFragments = scrollPos.split('/').reverse() # We want to start looping in the array fragments from the end

      for targetId in pathFragments

        # We check that the current element of the array (targetId) is neither empty (caused by a trailing slash)
        # or the item that we want to skip, when we find it, thats our element id.
        if(targetId isnt itemToSkip and targetId isnt '')
          break

      targetEl = $('#' + targetId)
      navBarOffset = 125

      try
        scrollPos = targetEl.offset().top - navBarOffset
      catch e
        if targetId is ''
          console.error "targetId can't be empty, verify you are passing the correct arguments and there is no trailing slash in the url"
        else
           console.error "'##{targetId}' seems like an invalid id or there is no such element in the dom \n #{e.message}"


    $('html,body').stop().animate({
      scrollTop: scrollPos
    }, 800)

    null

  # First Scrolls the page to the required section, based on the current route and the slide name
  # Then Moves the slider to the index setted in the router prefix+'Slides'
  navigateSection: (slide, prefix)->

    @scrollTo(Backbone.history.fragment, slide)

    if slide?

      try
        routeKey = "#{prefix}Slides"
        slidersKey = "#{prefix}Section"
        index = @[routeKey].indexOf(slide)
        console.log 'index is ' + index
        root.sliders[slidersKey].slideTo(index)
      catch e
        console.error 'There are no slides defined in the router for this slider. \n' + e.message
    else
      console.warn('navigateSection was called with a null slide argument')

    null


router = new App.Routers.Router();


Backbone.history.start
  pushState: true
  root: baseFolder # Change to the basefolder on production

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
    router.navigateSection(slide, 'on')

  router.on 'route:musicSection' , (slide)->
    router.navigateSection(slide, 'music')

  router.on 'route:corpSection' , (slide)->
    router.navigateSection(slide, 'corp')

  router.on 'route:eventsSection' , (slide)->
    router.navigateSection(slide, 'event')

  router.on 'route:contact' , ->
    router.scrollTo(Backbone.history.fragment)
    null

$(window).load ->

  #Once the page is loaded with a route diferent than home, slide/scroll to the corresponding section
  router.navigateOnLoad()


# Fb Window behavior - Please refactor into Backbone views

$('a.route, .portfolioBtn').click (e)->
  e.stopPropagation()
  e.preventDefault()
  linkTarget = $(this).attr('href')
  console.log 'linkTarget: ' + linkTarget
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