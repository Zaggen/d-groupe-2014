// Generated by CoffeeScript 1.7.1
(function() {
  var $, backToListBtn, baseFolder, navigateSection, news, newsCollection, newsNavi, newsViewCollection, root, rootUrl, router,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  root = typeof window !== "undefined" && window !== null ? window : global;

  $ = root.jQuery;

  root.template = function(id) {
    return _.template($('#' + id).html());
  };

  baseFolder = window.location.pathname.replace('/', '').split('/')[0];

  rootUrl = window.location.protocol + "//" + window.location.host + "/" + baseFolder;

  $.ajaxPrefilter(function(options) {
    options.url = rootUrl + options.url;
    return false;
  });

  root.App = (function() {
    function App() {}

    App.Models = {};

    App.Collections = {};

    App.Views = {};

    App.Routers = {};

    return App;

  })();

  App.Models.News = (function(_super) {
    __extends(News, _super);

    function News() {
      return News.__super__.constructor.apply(this, arguments);
    }

    News.prototype.defaults = {
      title: 'Lorem',
      date: '2 Abril 2014',
      content: 'Lorem ipsum dolor',
      imgSrc: 'imgs/lorem.jpg'
    };

    return News;

  })(Backbone.Model);

  App.Collections.News = (function(_super) {
    __extends(News, _super);

    function News() {
      return News.__super__.constructor.apply(this, arguments);
    }

    News.prototype.model = App.Models.News;

    News.prototype.url = '/noticias';

    return News;

  })(Backbone.Collection);

  App.Views.NewsCollection = (function(_super) {
    __extends(NewsCollection, _super);

    function NewsCollection() {
      this.yeldAdd = __bind(this.yeldAdd, this);
      this.updateView = __bind(this.updateView, this);
      return NewsCollection.__super__.constructor.apply(this, arguments);
    }

    NewsCollection.prototype.tagName = 'ul';

    NewsCollection.prototype.id = 'newsFeed';

    NewsCollection.prototype.initialize = function() {
      this.collection.bind('change', this.updateView);
      this.collection.bind('add', this.yeldAdd);
      return this.fetchCollection(1);
    };

    NewsCollection.prototype.updateView = function() {
      console.log('I changed');
      return this.render().el;
    };

    NewsCollection.prototype.yeldAdd = function() {
      return console.log('add was made');
    };

    NewsCollection.prototype.fetchCollection = function(page, fetchCurrent) {
      if (page == null) {
        page = 1;
      }
      if (fetchCurrent == null) {
        fetchCurrent = false;
      }
      this.$el.addClass('pointEightOpcty');
      if (this.page !== page || fetchCurrent === true) {
        this.collection.fetch({
          data: {
            page: page
          },
          success: (function(_this) {
            return function() {
              return _this.render();
            };
          })(this),
          error: function(collection, response) {
            console.log('error while fetching the news collection');
            return console.log(response);
          },
          complete: (function(_this) {
            return function() {
              $('body').css('cursor', 'default');
              return _this.$el.removeClass('pointEightOpcty');
            };
          })(this)
        });
        return this.page = page;
      } else {
        return $('body').css('cursor', 'default');
      }
    };

    NewsCollection.prototype.render = function() {
      var $parent, nodes;
      $parent = $('#newsWrapper');
      $parent.empty();
      this.$el.empty();
      nodes = [];
      this.collection.each((function(_this) {
        return function(news) {
          var newsView;
          newsView = new App.Views.News({
            model: news
          });
          newsView.delegateEvents();
          return nodes.push(newsView.render().el);
        };
      })(this));
      this.$el.append(nodes);
      $parent.append(this.el);
      return this;
    };

    return NewsCollection;

  })(Backbone.View);

  App.Views.News = (function(_super) {
    __extends(News, _super);

    function News() {
      this.showFullEntry = __bind(this.showFullEntry, this);
      return News.__super__.constructor.apply(this, arguments);
    }

    News.prototype.tagName = 'li';

    News.prototype.className = 'entry';

    News.prototype.events = {
      'click': 'showFullEntry'
    };

    News.prototype.showFullEntry = function(e) {
      var fullNews;
      e.preventDefault();
      e.stopPropagation();
      fullNews = new App.Views.fullNews({
        model: this.model
      });
      return $('#newsWrapper').html(fullNews.render().el);
    };

    News.prototype.template = template('newsEntries');

    News.prototype.render = function() {
      this.$el.html(this.template(this.model.toJSON()));
      return this;
    };

    return News;

  })(Backbone.View);

  App.Views.fullNews = (function(_super) {
    __extends(fullNews, _super);

    function fullNews() {
      return fullNews.__super__.constructor.apply(this, arguments);
    }

    fullNews.prototype.tagName = 'article';

    fullNews.prototype.className = 'fullEntry';

    fullNews.prototype.template = template('fullEntry');

    fullNews.prototype.render = function() {
      this.$el.html(this.template(this.model.toJSON()));
      backToListBtn.$el.removeClass('hidden');
      newsNavi.$el.addClass('hidden');
      return this;
    };

    return fullNews;

  })(Backbone.View);

  App.Views.pagination = (function(_super) {
    __extends(pagination, _super);

    function pagination() {
      return pagination.__super__.constructor.apply(this, arguments);
    }

    pagination.prototype.className = '.pageNavi';

    pagination.prototype.el = '#newsNavi';

    pagination.prototype.initialize = function() {
      this.pageQ = 3;
      return this.render();
    };

    pagination.prototype.getPageQ = function() {};

    pagination.prototype.render = function() {
      var nodes, num, pageNum, _i, _ref;
      nodes = [];
      for (num = _i = 1, _ref = this.pageQ; 1 <= _ref ? _i <= _ref : _i >= _ref; num = 1 <= _ref ? ++_i : --_i) {
        pageNum = new App.Views.pageBtn({
          pageNum: num,
          className: num === 1 ? 'navBtns selectedNav' : 'navBtns'
        });
        nodes.push(pageNum.render().el);
      }
      return this.$el.html(nodes);
    };

    return pagination;

  })(Backbone.View);

  App.Views.pageBtn = (function(_super) {
    __extends(pageBtn, _super);

    function pageBtn() {
      return pageBtn.__super__.constructor.apply(this, arguments);
    }

    pageBtn.prototype.tagName = 'li';

    pageBtn.prototype.events = {
      'click': 'changePage'
    };

    pageBtn.prototype.initialize = function(options) {
      return this.pageNum = options.pageNum;
    };

    pageBtn.prototype.changePage = function(e) {
      this.$navBtns = $('.navBtns');
      this.crntPage = $(e.currentTarget).index() + 1;
      $('body').css('cursor', 'wait');
      console.log(this.$navBtns[0]);
      this.$navBtns.removeClass('selectedNav');
      this.$el.addClass('selectedNav');
      return newsViewCollection.fetchCollection(this.crntPage);
    };

    pageBtn.prototype.render = function() {
      console.log(this.pageNum);
      this.$el.children().detach();
      this.$el.append(this.pageNum);
      this.$el.children().detach();
      return this;
    };

    return pageBtn;

  })(Backbone.View);

  App.Views.ReturnToListBtn = (function(_super) {
    __extends(ReturnToListBtn, _super);

    function ReturnToListBtn() {
      this.backToList = __bind(this.backToList, this);
      return ReturnToListBtn.__super__.constructor.apply(this, arguments);
    }

    ReturnToListBtn.prototype.initialize = function(options) {
      this.listView = options.listView;
      this.el = options.el;
      return this.nav = options.nav;
    };

    ReturnToListBtn.prototype.events = {
      'click': 'backToList'
    };

    ReturnToListBtn.prototype.backToList = function() {
      console.log(this.listView.page);
      this.listView.fetchCollection(this.listView.page, true);
      this.$el.addClass('hidden');
      return this.nav.$el.removeClass('hidden');
    };

    return ReturnToListBtn;

  })(Backbone.View);

  news = new App.Models.News;

  newsCollection = new App.Collections.News;

  newsViewCollection = new App.Views.NewsCollection({
    collection: newsCollection
  });

  newsNavi = new App.Views.pagination;

  backToListBtn = new App.Views.ReturnToListBtn({
    listView: newsViewCollection,
    el: '#backToNewsList',
    nav: newsNavi
  });


  /*
  $('.pageNavi li').click (e)->
    page = $(this).index() + 1;
    $('body').css 'cursor','wait'
    newsViewCollection.fetchCollection(page)
    newsCollection.at(0).set
      title: 'yikes'
      date: '2 Mayo 2014'
      content: 'The content has changed so much since you were here'
      imgSrc: 'imgs/news-dummy2.jpg'
   */

  App.Routers.Router = (function(_super) {
    __extends(Router, _super);

    function Router() {
      return Router.__super__.constructor.apply(this, arguments);
    }

    Router.prototype.routes = {
      '': 'home',
      'redes': 'social',
      'noticias': 'news',
      'contacto': 'contact',
      'portafolio/on(/:slide)': 'onSection',
      'portafolio/musical(/:slide)': 'musicSection',
      'portafolio/corporativo(/:slide)': 'corpSection',
      'portafolio/eventos(/:slide)': 'eventsSection'
    };

    Router.prototype.initialize = function() {
      var corpPath, eventPath, musicPath, onPath, path, portflRoot;
      portflRoot = 'portafolio/';
      onPath = portflRoot + 'on/';
      musicPath = portflRoot + 'musical/';
      corpPath = portflRoot + 'corporativo/';
      eventPath = portflRoot + 'eventos/';
      this.onSlides = ['kukaramakara', 'lussac', 'sixxtina', 'delaire'];
      this.musicSlides = ['fotos', 'videos', 'djs', 'calendario'];
      this.corpSlides = ['fotos', 'videos', 'calendario', 'contacto'];
      this.eventSlides = ['fotos', 'videos', 'calendario', 'contacto'];
      this.slideRoutes = {
        mainSlider: ['#', 'redes', 'noticias'],
        onSectionSldr: (function() {
          var _i, _len, _ref, _results;
          _ref = this.onSlides;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            path = _ref[_i];
            _results.push(onPath + path);
          }
          return _results;
        }).call(this),
        musicSectionSldr: (function() {
          var _i, _len, _ref, _results;
          _ref = this.musicSlides;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            path = _ref[_i];
            _results.push(musicPath + path);
          }
          return _results;
        }).call(this),
        eventSectionSldr: (function() {
          var _i, _len, _ref, _results;
          _ref = this.eventSlides;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            path = _ref[_i];
            _results.push(eventPath + path);
          }
          return _results;
        }).call(this),
        corpSectionSldr: (function() {
          var _i, _len, _ref, _results;
          _ref = this.corpSlides;
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            path = _ref[_i];
            _results.push(corpPath + path);
          }
          return _results;
        }).call(this)
      };
      return $(document).bind('onSlide', (function(_this) {
        return function(e, index, sliderId) {
          console.log("sliderId: " + sliderId);
          console.log("index: " + index);
          if (_this.slideRoutes[sliderId][index] !== 'undefined') {
            _this.navigate('#' + _this.slideRoutes[sliderId][index]);
          }
          return null;
        };
      })(this));
    };

    Router.prototype.scrollTo = function(scrollPos, removeFromFragment) {
      var targetEl, targetId;
      if (scrollPos === Backbone.history.fragment) {
        if (typeof removeFromFragment !== 'undefined' && (removeFromFragment != null)) {
          scrollPos = scrollPos.replace("/" + removeFromFragment, '');
        }
        targetId = scrollPos.split('/').pop();
        targetEl = $('#' + targetId);
        scrollPos = targetEl.offset().top - 125;
      }
      $('html,body').stop().animate({
        scrollTop: scrollPos
      }, 800);
      return null;
    };

    return Router;

  })(Backbone.Router);

  router = new App.Routers.Router();

  navigateSection = function(slide, prefix) {
    var e, index, routeKey, slidersKey;
    router.scrollTo(Backbone.history.fragment, slide);
    if (slide != null) {
      try {
        routeKey = "" + prefix + "Slides";
        slidersKey = "" + prefix + "Section";
        index = router[routeKey].indexOf(slide);
        console.log('index is ' + index);
        root.sliders[slidersKey].slideTo(index);
      } catch (_error) {
        e = _error;
        console.error('There are no slides defined in the router for this slider. \n' + e.message);
      }
    }
    return null;
  };

  $((function(_this) {
    return function() {
      router.on('route:home', function() {
        router.scrollTo(0);
        root.sliders.main.slideTo('first');
        return null;
      });
      router.on('route:news', function() {
        router.scrollTo(0);
        root.sliders.main.slideTo('last');
        return null;
      });
      router.on('route:social', function() {
        router.scrollTo(0);
        root.sliders.main.slideTo(1);
        return null;
      });
      router.on('route:onSection', function(slide) {
        return navigateSection(slide, 'on');
      });
      router.on('route:musicSection', function(slide) {
        return navigateSection(slide, 'music');
      });
      router.on('route:corpSection', function(slide) {
        return navigateSection(slide, 'corp');
      });
      router.on('route:eventsSection', function(slide) {
        return navigateSection(slide, 'event');
      });
      return router.on('route:contact', function() {
        router.scrollTo(Backbone.history.fragment);
        return null;
      });
    };
  })(this));

  Backbone.history.start({
    pushState: true,
    root: baseFolder
  });

  $('a.route, .portfolioBtn').click(function(e) {
    var linkTarget;
    e.stopPropagation();
    e.preventDefault();
    linkTarget = $(this).attr('href');
    console.log(linkTarget);
    return router.navigate(linkTarget, true);
  });

  $('.fbIcon').click(function(e) {
    var hiddenEl, parent;
    e.stopPropagation();
    e.preventDefault();
    parent = $(this).closest('.socialBlock');
    hiddenEl = $(parent).find('.hidden');
    if (hiddenEl != null) {
      return hiddenEl.removeClass('hidden');
    }
  });

  $('.closeBtn').click(function() {
    var parent;
    parent = $(this).closest('.socialBlock');
    return $(parent).find('.fbBlock').addClass('hidden');
  });

  $('a.gal').has('img').colorbox({
    maxWidth: '90%',
    maxHeight: '90%',
    rel: 'on'
  });

  $('a.musicGal').has('img').colorbox({
    maxWidth: '90%',
    maxHeight: '90%',
    rel: 'musiGal'
  });

  $('a.ytGal').has('img').colorbox({
    maxWidth: '90%',
    maxHeight: '90%',
    iframe: true,
    innerWidth: 540,
    innerHeight: 346
  });

}).call(this);

//# sourceMappingURL=d-groupe.map
