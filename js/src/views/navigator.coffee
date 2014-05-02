root = window ? global
Dgroupe = root.Dgroupe

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
    index = 0
    for el in @$navItems
      elLink = $(el).attr('href')
      if elLink.indexOf(route) isnt -1
        break
      else
        index++

    @markAsSelected $(@$navItems[index])