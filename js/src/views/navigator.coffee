root = window ? global
Dgroupe = root.Dgroupe

# Navigation View

class Dgroupe.Views.navigation extends Backbone.View
  el: '#mainNav'

  events:
    'mousedown a:not(.current_page_item)': 'navHandler'
    'click a': 'preventDefault'
    'click header, li:not(.mainLvl)': 'toggleNavBar'
    'click .mainLvl': 'scrollTop'

  initialize: ->
    @$navList = $( @$el.children('ul') )
    @$navItems = @$navList.children('li')
    @$navLinks = @$navItems.find('a')
    @currentRoute = ''
    @mobileClosed = yes
    @widthToTriggerMobile = 851
    @setResizeHandler()
    @setNavListHeight()


  setResizeHandler: ->
    $(window).on 'resize', =>
      @setNavListHeight()
    this

  isMobileActive: ->
    if window.innerWidth < @widthToTriggerMobile then yes else no

  setNavListHeight: ->
    if @isMobileActive()
      @listHeight ?= $( @$navItems.get(0) ).outerHeight() * @$navItems.filter(':not(.hideInMobile)').length
      aviableHeight = window.innerHeight
      newHeight = if aviableHeight > @listHeight then @listHeight else aviableHeight
      newHeight = "#{newHeight}px"
    else
      newHeight = 'auto'
      if not @mobileClosed
        @closeMobileMenu()

    @$navList.css("height", newHeight)


  # The actual logic fires on mousedown to save some miliseconds, but we still prevent the default click behavior
  preventDefault: (e)->
    e.preventDefault()

  navHandler: (e)=>
    e.stopPropagation()
    e.preventDefault()
    $currentTarget = $(e.currentTarget)
    linkTarget = $currentTarget.attr('href')
    @navigate(linkTarget, $currentTarget)

  navigate: (linkTarget, $currentTarget) =>
    @markAsSelected($currentTarget)
    Backbone.history.navigate(linkTarget, trigger: yes)

  markAsSelected: ($el)=>
    selectedClass = 'current_page_item'
    @$navLinks.removeClass(selectedClass)
    $el.addClass(selectedClass)

  findCurrentRoute: (route)->
    index = 0
    for el in @$navLinks
      elLink = $(el).attr('href')
      if elLink.indexOf(route) isnt -1
        break
      else
        index++

    @markAsSelected $(@$navLinks[index])

  toggleNavBar: (e)=>
    e.stopPropagation()
    if @isMobileActive()
      if @mobileClosed
        @openMobileMenu()
      else
        @closeMobileMenu()

  openMobileMenu: ->
    @$el.addClass('openMenu')
    @mobileClosed = no

  closeMobileMenu: ->
    @$el.removeClass('openMenu')
    @mobileClosed = yes

  scrollTop: =>
    @$navList.stop().animate
      scrollTop: @listHeight
    ,800