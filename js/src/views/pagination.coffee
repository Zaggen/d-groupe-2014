root = window ? global
Dgroupe = root.Dgroupe

# Pagination View

class Dgroupe.Views.Pagination extends  Backbone.View
  className: 'pageNavi delayedFadeIn',
  tagName: 'ul',
  events:
    'click li:not(.dots)': 'changePage'

  initialize: (options)->

    @collection = options.collection
    @url = options.url ? @collection.url
    @updateRoutes = options.updateRoutes ? yes
    @listenTo(@collection, 'reset', @render)
    if $('#' + @id)[0]?
      @setElement('#' + @id)
      @pageQ = parseInt( @$el.data('pageQuantity') )
      @render()


  getCurrentPage: ->
    currentRoute = root.removeTrailingSlash(window.location.pathname)
    urlSegments = currentRoute.split('/')
    lastIndex = urlSegments.length - 1
    page = parseInt(urlSegments[lastIndex])
    return if not _.isNaN(page) then page else 1

  updatePage: ->
    @collection.fetchPage(@currentPageNum)
    @updateRoute()
    this

  updateRoute: ->
    if @updateRoutes
      route = @url + '/' + @currentPageNum;
      Backbone.history.navigate(route)
    this

  changePage: (e)=>
    @$('.navBtns').removeClass('selectedNav')
    @currentPageNum = parseInt( $(e.currentTarget).text() , 10)
    @updatePage()
    $(e.currentTarget).addClass('selectedNav')
    this

  render: ->
    @currentPageNum ?= @getCurrentPage()
    @pageQ ?= @collection.pageQ
    if @pageQ? and @pageQ > 1
      # Renders the pagination list e.g : 1 - 2 - 3 ... 8 , probably should be refactored into smaller methods
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
          liItem = new Dgroupe.Views.NaviItem
            pageNum : num
            className: if num is selectedPage then 'navBtns pageBtn selectedNav' else 'navBtns pageBtn'
            parentInstance: this
          skipped = no
        else
          if not skipped
            liItem = new Dgroupe.Views.NaviItem
              pageNum: '...'
              className: 'navBtns dots'

            skipped = yes

        nodes.push liItem.render().el

      @$el.html nodes
      @delegateEvents();
    this



class Dgroupe.Views.NaviItem extends Backbone.View
  tagName: 'li'
  className: 'navBtns'

  initialize: (options)->
    @pageNum = options.pageNum

  render: ->
    @$el.text @pageNum
    this

# Return to News List Btn


class Dgroupe.Views.ReturnToListBtn extends Backbone.View
  initialize: (options)->
    @listView = options.listView
    @el = options.el
    @nav = options.nav

  events:
    'click': 'backToList'

  backToList: =>
    @listView.fetchCollection(@listView.page, yes)
    @$el.addClass('hidden')
    @nav.$el.removeClass('hidden')
