root = window ? global
Dgroupe = root.Dgroupe

class Dgroupe.Routers.Router extends Backbone.Router
  routes:
    '(/)' : 'home'
    'redes(/)': 'social'
    'noticia/:entrySlug(/)': 'singleNews'
    'noticias(/)': 'news'
    'contacto(/)': 'contact'
    'portafolio/canal-on(/:slide)(/)': 'onSection'
    'portafolio/canal-musical(/:slide)(/)': 'musicSection'
    'portafolio/canal-corporativo(/:slide)(/)': 'corpSection'
    'portafolio/canal-eventos(/:slide)(/)': 'eventsSection'

  initialize: ->
    console.log 'App Initialize'
    @setAppRoutesOBjs()
    @setAppInstances()

  setAppRoutesOBjs: ->

    # Paths to prepend to each of the routes in slideRoutes
    portflRoot = 'portafolio/canal-'
    onPath     = portflRoot + 'on/'
    musicPath  = portflRoot + 'musical/'
    corpPath =   portflRoot + 'corporativo/'
    eventPath =  portflRoot + 'eventos/'

    # Route names for each slider, based on the order the slides are placed on each slider
    @onSlides = ['kukaramakara', 'lussac', 'sixxtina', 'delaire']
    @musicSlides = ['fotos', 'videos', 'djs', 'calendario']
    @corpSlides = ['fotos', 'videos']
    @eventsSlides = ['fotos', 'videos']

    # When a manual slide is made on any of these sliders, an update to the url will be made based on the
    # current index of the slided slider :) and the corresponding index of the @slideRoutes property array.
    @slideRoutes =
      mainSlider : ['', 'redes', 'noticias']
      onSectionSldr: onPath + path for path in @onSlides
      musicSectionSldr : musicPath + path for path in @musicSlides
      eventsSectionSldr: eventPath + path for path in @eventsSlides
      corpSectionSldr: corpPath + path for path in @corpSlides

  setAppInstances: ->

    # Views Instances

    #Top Navigation Bar
    @mainNav = new Dgroupe.Views.navigation

    # News
    @newsCollection = new Dgroupe.Collections.News
    @newsLayout = new Dgroupe.Views.Layout( el: '#newsWrapper' )

    @newsView = new Dgroupe.Views.News
      itemViewClass: Dgroupe.Views.NewsEntry
      collection: @newsCollection

    @newsNavi = new Dgroupe.Views.Pagination
      collection: @newsCollection
      id: 'newsNavi'
      url: 'noticias'

    @newsLayout.show([@newsView, @newsNavi])

    # Contact
    @contact = new Dgroupe.Views.contact

    # Loader
    @mainLoader = new Dgroupe.Views.MainLoader

    # Galleries

    # On Galleries
    for galleryName in ['kukaramakara', 'lussac', 'sixttina', 'delaire']
      imgGalleryId = "#{galleryName}Gal"
      videoGalleryId = "#{galleryName}VideoGal"
      new Dgroupe.Views.SlimGallery( id: imgGalleryId )
      new Dgroupe.Views.SlimGallery( id: videoGalleryId, mode: 'iframe' )


    galleries = {
      'music' : 'canal-musical',
      'corp'  : 'canal-corporativo',
      'events': 'canal-eventos'
    }

    gallerieCollections = []

    for own galleryName, wpPostTerm of galleries
      imgGalleryId = "#{galleryName}Gal"
      imgGalleryNaviId = "#{imgGalleryId}Navi"
      videoGalleryId = "#{galleryName}VideoGal"

      gallerieCollections[galleryName] = new Dgroupe.Collections.Gallery( urlQuery: "?from=#{wpPostTerm}")

      console.log 'galleryName', galleryName
      console.log 'gallerieCollections', gallerieCollections[galleryName]
      new Dgroupe.Views.Gallery
        collection: gallerieCollections[galleryName]
        id: imgGalleryId

      new Dgroupe.Views.Pagination
        id: imgGalleryNaviId
        collection: gallerieCollections[galleryName]
        updateRoutes: no

      new Dgroupe.Views.SlimGallery( id: videoGalleryId, mode: 'iframe' )

    # Lightbox

    lightBox = new Dgroupe.Views.Lightbox

    # Event Listeners

    $sections = $('body > section:not(#homeSection)')
    $sections.mouseenter (e)=>
      $currentSection = $(e.currentTarget)
      sectionName = $currentSection.data('slug')
      path = '/' + if sectionName isnt undefined then sectionName else ''
      @updateRouteNav(path)

    ###$('#mainSlider .slider').on 'mouseenter', '>li', (e)=>
      index = $(e.currentTarget).index()
      path = @slideRoutes.mainSlider[index]
      console.log 'path is ' + path
      @updateRouteNav(path)###

    # Event listener for all sliders, when one slides it will
    # trigger a url update using the navigate from backbone
    $(document).bind 'onSlide', (e, index, sliderId)=>

      if @slideRoutes[sliderId][index] isnt 'undefined'
        @.navigate('#' + @slideRoutes[sliderId][index]);
        @mainNav.findCurrentRoute(@slideRoutes[sliderId][index])
      null

  navigateOnLoad: ->
    route = Backbone.history.fragment
    @navigate(route, yes)
    @mainNav.findCurrentRoute(route)

  updateRouteNav: (route)->
    @navigate(route, no)
    @mainNav.findCurrentRoute(route)

  # Method to scroll up/down to a given position in px or to the
  # offset of an element which id matches the current route
  scrollTo: (scrollPos, itemToSkip)->

    # In case that scrollPos is a url and not a direct vertical position, we extract the corresponding element id
    # from the path, by skiping any path specified(only one) in the second argument
    if scrollPos is Backbone.history.fragment
      pathFragments = scrollPos.split('/').reverse() # We want to start looping in the array fragments from the end

      for postRoute in pathFragments

        # We check that the current element of the array (postRoute) is neither empty (caused by a trailing slash)
        # or the item that we want to skip, when we find it, thats our element id.
        if(postRoute isnt itemToSkip and postRoute isnt '')
          break

      postRoute = Backbone.history.fragment

      targetEl = $("[data-slug='#{postRoute}']")
      navBarOffset = 125

      try
        scrollPos = targetEl.offset().top - navBarOffset
      catch e
        if postRoute is ''
          console.error "targetId can't be empty, verify you are passing the correct arguments and there is no trailing slash in the url"
        else
          console.error "data-slug:'#{postRoute}' seems like an invalid data attribute or there is no such element in the dom \n #{e.message}"


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
        root.sliders[slidersKey].slideTo(index)
      catch e
        console.error 'There are no slides defined in the App for this slider. \n' + e.message
    else
      console.warn('navigateSection was called with a null slide argument')

    null

  home:->
    @scrollTo(0, null)
    root.sliders.main.slideTo('first')
    @mainNav.findCurrentRoute('/')
    this

  social:->
    @scrollTo(0, null)
    root.sliders.main.slideTo(1)
    @mainNav.findCurrentRoute('/redes')
    this

  news:->
    @scrollTo(0, null)
    root.sliders.main.slideTo('last')
    @mainNav.findCurrentRoute('/noticias')
    console.log '@newsView', @newsView
    if @newsView.closed?
      @newsView = new Dgroupe.Views.News
        itemViewClass: Dgroupe.Views.NewsEntry
        collection: @newsCollection
      @newsLayout.show([@newsView, @newsNavi])

    this

  singleNews: (permalink)->
    @scrollTo(0, null)

    root.sliders.main
    .config('emmitEvents', no)
    .slideTo('last')
    .config('emmitEvents', yes)

    singleEntry = new Dgroupe.Views.SingleEntry( model: new Dgroupe.Models.SingleEntry )
    @newsLayout.show([singleEntry])

    this

  onSection: (slide)->
    @navigateSection(slide, 'on')

  musicSection: (slide)->
    @navigateSection(slide, 'music')

  corpSection: (slide)->
    @navigateSection(slide, 'corp')

  eventsSection: (slide)->
    @navigateSection(slide, 'events')

  contact:->
    @scrollTo(Backbone.history.fragment, null)
    this


$ =>

  root.app = new Dgroupe.Routers.Router()


  Backbone.history.start
    pushState: true
    root: Dgroupe.helpers.baseFolder


$(window).load ->

  #Once the page is loaded with a route diferent than home, slide/scroll to the corresponding section
  root.app.navigateOnLoad()

# Refactor
$('a.route, .portfolioBtn').click (e)->
  e.preventDefault()
  linkTarget = $(this).attr('href')
  Backbone.history.navigate(linkTarget, true)

# Fb Window behavior - Please refactor into Backbone views

$('.fbIcon').click (e)->
  e.stopPropagation()
  e.preventDefault()
  parent = $(this).closest('.socialBlock')
  hiddenEl = $(parent).find('.hidden')
  if hiddenEl?
    hiddenEl.removeClass('hidden')

###$('.closeBtn').click ->
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
  innerHeight:346###
