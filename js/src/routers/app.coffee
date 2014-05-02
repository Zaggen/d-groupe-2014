root = window ? global
Dgroupe = root.Dgroupe

class Dgroupe.Routers.Router extends Backbone.Router
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
    console.log 'App Initialize'
    @setAppRoutesOBjs()
    @setAppInstances()

  setAppRoutesOBjs: ->

    # Paths to prepend to each of the routes in slideRoutes
    portflRoot = 'portafolio/'
    onPath     = portflRoot + 'on/'
    musicPath  = portflRoot + 'musical/'
    corpPath =   portflRoot + 'corporativo/'
    eventPath =  portflRoot + 'eventos/'

    # Route names for each slider, based on the order the slides are placed on each slider
    @onSlides = ['kukaramakara', 'lussac', 'sixxtina', 'delaire']
    @musicSlides = ['fotos', 'videos', 'djs', 'calendario']
    @corpSlides = ['fotos', 'videos']
    @eventSlides = ['fotos', 'videos']

    # When a manual slide is made on any of these sliders, an update to the url will be made based on the
    # current index of the slided slider :) and the corresponding index of the @slideRoutes property array.
    @slideRoutes =
      mainSlider : ['', 'redes', 'noticias']
      onSectionSldr: onPath + path for path in @onSlides
      musicSectionSldr : musicPath + path for path in @musicSlides
      eventSectionSldr: eventPath + path for path in @eventSlides
      corpSectionSldr: corpPath + path for path in @corpSlides

  setAppInstances: ->

    # Models/Collections Instances
    @news = new Dgroupe.Models.News
    @newsCollection = new  Dgroupe.Collections.News

    # Views Instances
    @mainNav = new Dgroupe.Views.navigation

    @newsViewCollection = new Dgroupe.Views.NewsCollection(collection: @newsCollection)
    @newsNavi = new Dgroupe.Views.pagination
      el: '#newsNavi'
      collectionView: @newsViewCollection

    @backToListBtn = new Dgroupe.Views.ReturnToListBtn
      listView: @newsViewCollection
      el: '#backToNewsList'
      nav: @newsNavi

    @contact = new Dgroupe.Views.contact

    @musicGalNavi = new Dgroupe.Views.pagination
      el: '#musicGalNavi'
      collectionView: @newsViewCollection

    # Event Listeners

    $sections = $('body > section:not(#homeSection)')
    $sections.mouseenter (e)=>
      $currentSection = $(e.currentTarget)
      sectionName = $currentSection.attr('id')
      path = '/' + if sectionName isnt undefined then sectionName else ''
      @updateRouteNav(path)

    # Event listener for all sliders, when one slides it will
    # trigger a url update using the navigate from backbone
    $(document).bind 'onSlide', (e, index, sliderId)=>

      if @slideRoutes[sliderId][index] isnt 'undefined'
        @.navigate('#' + @slideRoutes[sliderId][index]);
        @mainNav.findCurrentRoute(@slideRoutes[sliderId][index])
      null

  navigateOnLoad: ->

    # Since we are using wp for this project, any other page than index will redirect to home,
    # we want to scroll to the desired location after that http redirect. Backbone doesn't
    # allow to trigger functions associated with a route is the path is the same, so we first
    # change the route to the home, which is always visible, and then we trigger our navigate
    linkTarget = window.location.pathname.replace('/' + Dgroupe.helpers.baseFolder, '').replace('/', '')
    linkTarget = root.removeTrailingSlash(linkTarget)
    @navigate('/')
    @navigate(linkTarget, yes)
    @mainNav.findCurrentRoute(linkTarget)


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
        root.sliders[slidersKey].slideTo(index)
      catch e
        console.error 'There are no slides defined in the App for this slider. \n' + e.message
    else
      console.warn('navigateSection was called with a null slide argument')

    null

  home:->
    @scrollTo(0)
    root.sliders.main.slideTo('first')
    @.mainNav.findCurrentRoute('/')
    null

  social:->
    @scrollTo(0)
    root.sliders.main.slideTo(1)
    @mainNav.findCurrentRoute('/redes')
    null

  news:->
    @scrollTo(0)
    root.sliders.main.slideTo('last')
    @mainNav.findCurrentRoute('/noticias')
    null

  onSection: (slide)->
    @navigateSection(slide, 'on')

  musicSection: (slide)->
    @navigateSection(slide, 'music')

  corpSection: (slide)->
    @navigateSection(slide, 'corp')

  eventsSection: (slide)->
    @navigateSection(slide, 'event')

  contact:->
    @scrollTo(Backbone.history.fragment)
    null



$ =>

  root.App = new Dgroupe.Routers.Router();

  Backbone.history.start
    pushState: true
    root: Dgroupe.helpers.baseFolder

$(window).load ->

  #Once the page is loaded with a route diferent than home, slide/scroll to the corresponding section
  App.navigateOnLoad()

# Refactor
$('a.route, .portfolioBtn').click (e)->
  e.preventDefault()
  linkTarget = $(this).attr('href')
  App.navigate(linkTarget, true)

# Fb Window behavior - Please refactor into Backbone views

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
