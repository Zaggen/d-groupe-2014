// Generated by CoffeeScript 1.7.1
(function() {
  var Dgroupe, root,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  root = typeof window !== "undefined" && window !== null ? window : global;

  Dgroupe = root.Dgroupe;

  Dgroupe.Routers.Router = (function(_super) {
    __extends(Router, _super);

    function Router() {
      return Router.__super__.constructor.apply(this, arguments);
    }

    Router.prototype.routes = {
      '(/)': 'home',
      'redes(/)': 'social',
      'noticias(/)': 'news',
      'contacto(/)': 'contact',
      'portafolio/on(/:slide)(/)': 'onSection',
      'portafolio/musical(/:slide)(/)': 'musicSection',
      'portafolio/corporativo(/:slide)(/)': 'corpSection',
      'portafolio/eventos(/:slide)(/)': 'eventsSection'
    };

    Router.prototype.initialize = function() {
      console.log('App Initialize');
      this.setAppRoutesOBjs();
      return this.setAppInstances();
    };

    Router.prototype.setAppRoutesOBjs = function() {
      var corpPath, eventPath, musicPath, onPath, path, portflRoot;
      portflRoot = 'portafolio/';
      onPath = portflRoot + 'on/';
      musicPath = portflRoot + 'musical/';
      corpPath = portflRoot + 'corporativo/';
      eventPath = portflRoot + 'eventos/';
      this.onSlides = ['kukaramakara', 'lussac', 'sixxtina', 'delaire'];
      this.musicSlides = ['fotos', 'videos', 'djs', 'calendario'];
      this.corpSlides = ['fotos', 'videos'];
      this.eventSlides = ['fotos', 'videos'];
      return this.slideRoutes = {
        mainSlider: ['', 'redes', 'noticias'],
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
    };

    Router.prototype.setAppInstances = function() {
      var $sections;
      this.news = new Dgroupe.Models.News;
      this.newsCollection = new Dgroupe.Collections.News;
      this.mainNav = new Dgroupe.Views.navigation;
      this.newsViewCollection = new Dgroupe.Views.NewsCollection({
        collection: this.newsCollection
      });
      this.newsNavi = new Dgroupe.Views.pagination({
        el: '#newsNavi',
        collectionView: this.newsViewCollection
      });
      this.backToListBtn = new Dgroupe.Views.ReturnToListBtn({
        listView: this.newsViewCollection,
        el: '#backToNewsList',
        nav: this.newsNavi
      });
      this.contact = new Dgroupe.Views.contact;
      this.musicGalNavi = new Dgroupe.Views.pagination({
        el: '#musicGalNavi',
        collectionView: this.newsViewCollection
      });
      $sections = $('body > section:not(#homeSection)');
      $sections.mouseenter((function(_this) {
        return function(e) {
          var $currentSection, path, sectionName;
          $currentSection = $(e.currentTarget);
          sectionName = $currentSection.attr('id');
          path = '/' + (sectionName !== void 0 ? sectionName : '');
          return _this.updateRouteNav(path);
        };
      })(this));
      return $(document).bind('onSlide', (function(_this) {
        return function(e, index, sliderId) {
          if (_this.slideRoutes[sliderId][index] !== 'undefined') {
            _this.navigate('#' + _this.slideRoutes[sliderId][index]);
            _this.mainNav.findCurrentRoute(_this.slideRoutes[sliderId][index]);
          }
          return null;
        };
      })(this));
    };

    Router.prototype.navigateOnLoad = function() {
      var linkTarget;
      linkTarget = window.location.pathname.replace('/' + Dgroupe.helpers.baseFolder, '').replace('/', '');
      linkTarget = root.removeTrailingSlash(linkTarget);
      this.navigate('/');
      this.navigate(linkTarget, true);
      return this.mainNav.findCurrentRoute(linkTarget);
    };

    Router.prototype.updateRouteNav = function(route) {
      this.navigate(route, false);
      return this.mainNav.findCurrentRoute(route);
    };

    Router.prototype.scrollTo = function(scrollPos, itemToSkip) {
      var e, navBarOffset, pathFragments, targetEl, targetId, _i, _len;
      if (scrollPos === Backbone.history.fragment) {
        pathFragments = scrollPos.split('/').reverse();
        for (_i = 0, _len = pathFragments.length; _i < _len; _i++) {
          targetId = pathFragments[_i];
          if (targetId !== itemToSkip && targetId !== '') {
            break;
          }
        }
        targetEl = $('#' + targetId);
        navBarOffset = 125;
        try {
          scrollPos = targetEl.offset().top - navBarOffset;
        } catch (_error) {
          e = _error;
          if (targetId === '') {
            console.error("targetId can't be empty, verify you are passing the correct arguments and there is no trailing slash in the url");
          } else {
            console.error("'#" + targetId + "' seems like an invalid id or there is no such element in the dom \n " + e.message);
          }
        }
      }
      $('html,body').stop().animate({
        scrollTop: scrollPos
      }, 800);
      return null;
    };

    Router.prototype.navigateSection = function(slide, prefix) {
      var e, index, routeKey, slidersKey;
      this.scrollTo(Backbone.history.fragment, slide);
      if (slide != null) {
        try {
          routeKey = "" + prefix + "Slides";
          slidersKey = "" + prefix + "Section";
          index = this[routeKey].indexOf(slide);
          root.sliders[slidersKey].slideTo(index);
        } catch (_error) {
          e = _error;
          console.error('There are no slides defined in the App for this slider. \n' + e.message);
        }
      } else {
        console.warn('navigateSection was called with a null slide argument');
      }
      return null;
    };

    Router.prototype.home = function() {
      this.scrollTo(0);
      root.sliders.main.slideTo('first');
      this.mainNav.findCurrentRoute('/');
      return null;
    };

    Router.prototype.social = function() {
      this.scrollTo(0);
      root.sliders.main.slideTo(1);
      this.mainNav.findCurrentRoute('/redes');
      return null;
    };

    Router.prototype.news = function() {
      this.scrollTo(0);
      root.sliders.main.slideTo('last');
      this.mainNav.findCurrentRoute('/noticias');
      return null;
    };

    Router.prototype.onSection = function(slide) {
      return this.navigateSection(slide, 'on');
    };

    Router.prototype.musicSection = function(slide) {
      return this.navigateSection(slide, 'music');
    };

    Router.prototype.corpSection = function(slide) {
      return this.navigateSection(slide, 'corp');
    };

    Router.prototype.eventsSection = function(slide) {
      return this.navigateSection(slide, 'event');
    };

    Router.prototype.contact = function() {
      this.scrollTo(Backbone.history.fragment);
      return null;
    };

    return Router;

  })(Backbone.Router);

  $((function(_this) {
    return function() {
      root.App = new Dgroupe.Routers.Router();
      return Backbone.history.start({
        pushState: true,
        root: Dgroupe.helpers.baseFolder
      });
    };
  })(this));

  $(window).load(function() {
    return App.navigateOnLoad();
  });

  $('a.route, .portfolioBtn').click(function(e) {
    var linkTarget;
    e.preventDefault();
    linkTarget = $(this).attr('href');
    return App.navigate(linkTarget, true);
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

//# sourceMappingURL=app.map
