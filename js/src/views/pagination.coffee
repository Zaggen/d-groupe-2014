root = window ? global
Dgroupe = root.Dgroupe

# Pagination View

class Dgroupe.Views.pagination extends  Backbone.View
  className: '.pageNavi',
  tagName: 'ul'

  initialize: (options)->
    @feed = options.collectionView
    @pageQ = parseInt @$el.attr('data-page-quantity')
    @setCurrentPageNum(1)

  setCurrentPageNum:(currentPageNum) ->
    @currentPageNum = parseInt(currentPageNum)
    @render()

  updatePage: (currentPageNum) ->
    @setCurrentPageNum(currentPageNum)
    @feed.fetchCollection(currentPageNum)

  render: ->
    # Renders the pagination list e.g : 1 - 2 - 3 ... 8
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
          parentInstance: this
        skipped = no
      else
        if not skipped
          liItem = new Dgroupe.Views.naviItem
            pageNum: '...'
            className: 'navBtns dots'

          skipped = yes


      nodes.push liItem.render().el
    @$el.html nodes
    this

class Dgroupe.Views.naviItem extends Backbone.View
  tagName: 'li'
  className: 'navBtns'

  initialize: (options)->
    @pageNum = options.pageNum

  render: ->
    @$el.text @pageNum
    this



class Dgroupe.Views.pageBtn extends Dgroupe.Views.naviItem
  events:
    'click': 'changePage'

  initialize: (options)->
    super
    @navi = options.parentInstance

  changePage: (e)->
    @$navBtns = $('.navBtns')
    @crntPage = $(e.currentTarget).text()
    $('body').css 'cursor','wait'

    @navi.updatePage(@crntPage)



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
