root = window ? global

$ = root.jQuery

root.template = (id)->
  _.template( $('#' + id).html() )

root.removeTrailingSlash = (route)->
  index = route.length - 1
  if route.charAt(index) is '/'
    route = route.substring(0, index)
  else
    route


# Used to filter each ajax json request for the backbone models
baseFolder = window.location.pathname.replace('/','').split('/')[0] # Also used as the backbone history root
rootUrl = window.location.protocol + "//" + window.location.host + "/" + baseFolder;
$.ajaxPrefilter (options)->
  options.url = rootUrl + options.url
  false


class root.Dgroupe
  @Models: {}
  @Collections: {}
  @Views: {}
  @Routers: {}

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

# Views

# News Views

class Dgroupe.Views.NewsCollection extends Backbone.View
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
    console.log 'fetching colecion'
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
      newsView = new Dgroupe.Views.News model: news
      newsView.delegateEvents()
      nodes.push newsView.render().el
    @$el.append nodes
    $parent.append(@el)
    this

class Dgroupe.Views.News extends Backbone.View
  tagName: 'li'
  className: 'entry'

  events:
    'click': 'showFullEntry'

  showFullEntry: (e)=>
    e.preventDefault()
    e.stopPropagation()
    fullNews = new Dgroupe.Views.fullNews model: @model
    $('#newsWrapper').html(fullNews.render().el)

  template: template('newsEntries')

  #template: _.template("<strong><%= title %></strong> (<%= date %>) - <%= content %>


  render: ->
    @$el.html @template @model.toJSON()
    this

class Dgroupe.Views.fullNews extends Backbone.View
  tagName: 'article'
  className: 'fullEntry'

  template: template('fullEntry')

  render: ->
    @$el.html @template @model.toJSON()
    App.backToListBtn.$el.removeClass('hidden')
    App.newsNavi.$el.addClass('hidden')
    this

# Navigation View

class Dgroupe.Views.navigation extends Backbone.View
  el: '#NavBar'

  initialize: ->
    @$navItems = @$el.find('a')
    @currentRoute = ''

  events:
    'click a': 'navHandler'

  navHandler: (e)=>
    e.stopPropagation()
    e.preventDefault()
    $currentTarget = $(e.currentTarget)
    linkTarget = $currentTarget.attr('href')
    @navigate(linkTarget, $currentTarget)

  navigate: (linkTarget, $currentTarget) =>
    @markAsSelected($currentTarget)
    try
      App.navigate(linkTarget, true)
      @currentRoute = linkTarget
    catch e
      throw new Error('This method needs a router instance defined named "app"')

  markAsSelected: ($el)=>
    selectedClass = 'current_page_item'

    $closestUl = $el.closest('ul')

    if $closestUl.hasClass 'subLvl'
      $closestUl.closest('.mainLvl').addClass(selectedClass)
    else
      $('.mainLvl').removeClass(selectedClass)

    @$navItems.removeClass(selectedClass)
    $el.addClass(selectedClass)

  findCurrentRoute: (route)->
    console.log 'called find route ->' + route
    index = 0
    for el in @$navItems
      elLink = $(el).attr('href')
      console.log elLink
      if elLink.indexOf(route) isnt -1
        break
      else
        index++

    @markAsSelected $(@$navItems[index])

# Pagination View

# Pagination View

class Dgroupe.Views.pagination extends  Backbone.View
  className: '.pageNavi',
  el: '#newsNavi'

  initialize: ->
    @pageQ = parseInt @$el.attr('data-page-quantity')
    @setCurrentPageNum(1)

  setCurrentPageNum:(currentPageNum) ->
    @currentPageNum = parseInt(currentPageNum)
    @render()

  render: ->
    # Renders the pagination list e.g : prev - 1 - 2 - 3 ... 8 - last (Not fully implemented yet)
    nodes = []
    btnsLimit = 4
    selectedPage = @currentPageNum
    halfLimit = btnsLimit / 2
    leftHalf = Math.ceil(halfLimit)
    rightHalf = btnsLimit - leftHalf

    for x in [leftHalf..0]
      if selectedPage - x <= 0
        leftHalf--
        rightHalf++

    for x in [rightHalf..0]
      if selectedPage + x >= @pageQ
        leftHalf++
        rightHalf--


    minRange = selectedPage - leftHalf
    maxRange = selectedPage + rightHalf
    skipped = no


    for num in [1..@pageQ]
      if num is 1 or minRange <= num <= maxRange or num is @pageQ
        liItem = new Dgroupe.Views.pageBtn
          pageNum : num
          className: if num is selectedPage then 'navBtns selectedNav' else 'navBtns'
        skipped = no
      else
        if not skipped
          liItem = new Dgroupe.Views.naviItem
            pageNum: '...'
            className: 'navBtns dots'

          skipped = yes


      nodes.push liItem.render().el
    @$el.html nodes

class Dgroupe.Views.naviItem extends Backbone.View
  tagName: 'li'
  className: 'navBtns'

  initialize: (options)->
    @pageNum = options.pageNum

  render: ->
    @$el.text @pageNum
    this



class Dgroupe.Views.pageBtn extends Dgroupe.Views.naviItem
  tagName: 'li'
  events:
    'click': 'changePage'

  changePage: (e)->
    @$navBtns = $('.navBtns')
    @crntPage = $(e.currentTarget).text()
    $('body').css 'cursor','wait'
    App.newsViewCollection.fetchCollection(@crntPage)
    App.newsNavi.setCurrentPageNum(@crntPage)


class Dgroupe.Views.ReturnToListBtn extends Backbone.View
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

# Contact Form View

class Dgroupe.Views.contact extends Backbone.View
  el: '#mainContact'

  initialize: ->
    @$alert =  $ @$el.parent().find('.alert')

  events:
    'submit': 'contactHandler'

  contactHandler: (e)=>
    e.preventDefault()
    @sendForm @$el.serialize()

  sendForm: (data)->
    $.ajax
      type: "POST"
      url: @$el.attr( 'action' )
      data: data

      success: ( response )=>
        @$el.before @setMsgAlert(response)
        if response.status is 'success'
          @$el.addClass 'setOpacityTenPercent'
          @$el.find('#contactSubmit').remove()

      error: =>
        msgObj =
          status: 'failed'
          title: 'Error de conexión'
          description: 'Hubo un problema al intenta enviar tu mensaje, intentalo mas tarde'

        @$el.before @setMsgAlert(msgObj)

  setMsgAlert: (response)->
    console.log response
    alertClass = 'alert ' + if response.status is 'success' then 'alertSuccess' else 'alertDanger'
    @$alert
      .removeClass()
      .addClass(alertClass)
      .html('<strong>' + response.title + '</strong> ' + response.description)




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

    # Models/Collections Instances
    @news = new Dgroupe.Models.News
    @newsCollection = new  Dgroupe.Collections.News

    # Views Instances
    @mainNav = new Dgroupe.Views.navigation

    @newsViewCollection = new Dgroupe.Views.NewsCollection  collection: @newsCollection
    @newsNavi = new Dgroupe.Views.pagination
    @backToListBtn = new Dgroupe.Views.ReturnToListBtn
      listView: @newsViewCollection
      el: '#backToNewsList'
      nav: @newsNavi
    @contact = new Dgroupe.Views.contact

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
      console.log "sliderId: #{sliderId}"
      console.log "index: #{index}"
      console.log '@slideRoutes[sliderId][index] ' + @slideRoutes[sliderId][index]
      if @slideRoutes[sliderId][index] isnt 'undefined'
        @.navigate('#' + @slideRoutes[sliderId][index]);
        @mainNav.findCurrentRoute(@slideRoutes[sliderId][index])
      null

  navigateOnLoad: ->

    # Since we are using wp for this project, any other page than index will redirect to home,
    # we want to scroll to the desired location after that http redirect. Backbone doesn't
    # allow to trigger functions associated with a route is the path is the same, so we first
    # change the route to the home, which is always visible, and then we trigger our navigate
    linkTarget = window.location.pathname.replace('/' + baseFolder, '').replace('/', '')
    linkTarget = root.removeTrailingSlash(linkTarget)
    console.log 'linkTarget: ' + linkTarget
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
        console.log 'index is ' + index
        root.sliders[slidersKey].slideTo(index)
      catch e
        console.error 'There are no slides defined in the App for this slider. \n' + e.message
    else
      console.warn('navigateSection was called with a null slide argument')

    null


App = new Dgroupe.Routers.Router();


Backbone.history.start
  pushState: true
  root: baseFolder # Change to the basefolder on production

$ =>

  App.on 'route:home' , ->
    App.scrollTo(0)
    root.sliders.main.slideTo('first')
    App.mainNav.findCurrentRoute('/')
    null

  App.on 'route:social' , ->
    App.scrollTo(0)
    root.sliders.main.slideTo(1)
    App.mainNav.findCurrentRoute('/redes')
    null

  App.on 'route:news' , ->
    App.scrollTo(0)
    root.sliders.main.slideTo('last')
    App.mainNav.findCurrentRoute('/noticias')
    null

  App.on 'route:onSection' , (slide)->
    App.navigateSection(slide, 'on')

  App.on 'route:musicSection' , (slide)->
    App.navigateSection(slide, 'music')

  App.on 'route:corpSection' , (slide)->
    App.navigateSection(slide, 'corp')

  App.on 'route:eventsSection' , (slide)->
    App.navigateSection(slide, 'event')

  App.on 'route:contact' , ->
    App.scrollTo(Backbone.history.fragment)
    null

$(window).load ->

  #Once the page is loaded with a route diferent than home, slide/scroll to the corresponding section
  App.navigateOnLoad()

# Refactor
$('a.route, .portfolioBtn').click (e)->
  e.preventDefault()
  linkTarget = $(this).attr('href')
  console.log 'linkTarget: ' + linkTarget
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