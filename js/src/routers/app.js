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
      'noticia/:entrySlug(/)': 'singleNews',
      'noticias(/)': 'news',
      'contacto(/)': 'contact',
      'portafolio/canal-on(/:slide)(/)': 'onSection',
      'portafolio/canal-musical(/:slide)(/)': 'musicSection',
      'portafolio/canal-corporativo(/:slide)(/)': 'corpSection',
      'portafolio/canal-eventos(/:slide)(/)': 'eventsSection'
    };

    Router.prototype.initialize = function() {
      console.log('App Initialize');
      this.setAppRoutesOBjs();
      return this.setAppInstances();
    };

    Router.prototype.setAppRoutesOBjs = function() {
      var corpPath, eventPath, musicPath, onPath, path, portflRoot;
      portflRoot = 'portafolio/canal-';
      onPath = portflRoot + 'on/';
      musicPath = portflRoot + 'musical/';
      corpPath = portflRoot + 'corporativo/';
      eventPath = portflRoot + 'eventos/';
      this.onSlides = ['kukaramakara', 'lussac', 'sixxtina', 'delaire'];
      this.musicSlides = ['fotos', 'videos', 'djs', 'calendario'];
      this.corpSlides = ['fotos', 'videos'];
      this.eventsSlides = ['fotos', 'videos'];
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
        eventsSectionSldr: (function() {
          var _i, _len, _ref, _results;
          _ref = this.eventsSlides;
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
      var $sections, gallerieCollections, galleries, galleryName, imgGalleryId, imgGalleryNaviId, lightBox, videoGalleryId, wpPostTerm, _i, _len, _ref;
      this.mainNav = new Dgroupe.Views.navigation;
      this.newsCollection = new Dgroupe.Collections.News;
      this.newsLayout = new Dgroupe.Views.Layout({
        el: '#newsWrapper'
      });
      this.newsView = new Dgroupe.Views.News({
        itemViewClass: Dgroupe.Views.NewsEntry,
        collection: this.newsCollection
      });
      this.newsNavi = new Dgroupe.Views.Pagination({
        collection: this.newsCollection,
        id: 'newsNavi',
        url: 'noticias'
      });
      this.newsLayout.show([this.newsView, this.newsNavi]);
      this.contact = new Dgroupe.Views.contact;
      this.mainLoader = new Dgroupe.Views.MainLoader;
      _ref = ['kukaramakara', 'lussac', 'sixttina', 'delaire'];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        galleryName = _ref[_i];
        imgGalleryId = "" + galleryName + "Gal";
        videoGalleryId = "" + galleryName + "VideoGal";
        new Dgroupe.Views.SlimGallery({
          id: imgGalleryId
        });
        new Dgroupe.Views.SlimGallery({
          id: videoGalleryId,
          mode: 'iframe'
        });
      }
      galleries = {
        'music': 'canal-musical',
        'corp': 'canal-corporativo',
        'events': 'canal-eventos'
      };
      gallerieCollections = [];
      for (galleryName in galleries) {
        if (!__hasProp.call(galleries, galleryName)) continue;
        wpPostTerm = galleries[galleryName];
        imgGalleryId = "" + galleryName + "Gal";
        imgGalleryNaviId = "" + imgGalleryId + "Navi";
        videoGalleryId = "" + galleryName + "VideoGal";
        gallerieCollections[galleryName] = new Dgroupe.Collections.Gallery({
          urlQuery: "?from=" + wpPostTerm
        });
        console.log('galleryName', galleryName);
        console.log('gallerieCollections', gallerieCollections[galleryName]);
        new Dgroupe.Views.Gallery({
          collection: gallerieCollections[galleryName],
          id: imgGalleryId
        });
        new Dgroupe.Views.Pagination({
          id: imgGalleryNaviId,
          collection: gallerieCollections[galleryName],
          updateRoutes: false
        });
        new Dgroupe.Views.SlimGallery({
          id: videoGalleryId,
          mode: 'iframe'
        });
      }
      lightBox = new Dgroupe.Views.Lightbox;
      $sections = $('body > section:not(#homeSection)');
      $sections.mouseenter((function(_this) {
        return function(e) {
          var $currentSection, path, sectionName;
          $currentSection = $(e.currentTarget);
          sectionName = $currentSection.data('slug');
          path = '/' + (sectionName !== void 0 ? sectionName : '');
          return _this.updateRouteNav(path);
        };
      })(this));

      /*$('#mainSlider .slider').on 'mouseenter', '>li', (e)=>
        index = $(e.currentTarget).index()
        path = @slideRoutes.mainSlider[index]
        console.log 'path is ' + path
        @updateRouteNav(path)
       */
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
      var route;
      route = Backbone.history.fragment;
      this.navigate(route, true);
      return this.mainNav.findCurrentRoute(route);
    };

    Router.prototype.updateRouteNav = function(route) {
      this.navigate(route, false);
      return this.mainNav.findCurrentRoute(route);
    };

    Router.prototype.scrollTo = function(scrollPos, itemToSkip) {
      var e, navBarOffset, pathFragments, postRoute, targetEl, _i, _len;
      if (scrollPos === Backbone.history.fragment) {
        pathFragments = scrollPos.split('/').reverse();
        for (_i = 0, _len = pathFragments.length; _i < _len; _i++) {
          postRoute = pathFragments[_i];
          if (postRoute !== itemToSkip && postRoute !== '') {
            break;
          }
        }
        postRoute = Backbone.history.fragment;
        targetEl = $("[data-slug='" + postRoute + "']");
        navBarOffset = 125;
        try {
          scrollPos = targetEl.offset().top - navBarOffset;
        } catch (_error) {
          e = _error;
          if (postRoute === '') {
            console.error("targetId can't be empty, verify you are passing the correct arguments and there is no trailing slash in the url");
          } else {
            console.error("data-slug:'" + postRoute + "' seems like an invalid data attribute or there is no such element in the dom \n " + e.message);
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
      this.scrollTo(0, null);
      root.sliders.main.slideTo('first');
      this.mainNav.findCurrentRoute('/');
      return this;
    };

    Router.prototype.social = function() {
      this.scrollTo(0, null);
      root.sliders.main.slideTo(1);
      this.mainNav.findCurrentRoute('/redes');
      return this;
    };

    Router.prototype.news = function() {
      this.scrollTo(0, null);
      root.sliders.main.slideTo('last');
      this.mainNav.findCurrentRoute('/noticias');
      console.log('@newsView', this.newsView);
      if (this.newsView.closed != null) {
        this.newsView = new Dgroupe.Views.News({
          itemViewClass: Dgroupe.Views.NewsEntry,
          collection: this.newsCollection
        });
        this.newsLayout.show([this.newsView, this.newsNavi]);
      }
      return this;
    };

    Router.prototype.singleNews = function(permalink) {
      var singleEntry;
      this.scrollTo(0, null);
      root.sliders.main.config('emmitEvents', false).slideTo('last').config('emmitEvents', true);
      singleEntry = new Dgroupe.Views.SingleEntry({
        model: new Dgroupe.Models.SingleEntry
      });
      this.newsLayout.show([singleEntry]);
      return this;
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
      return this.navigateSection(slide, 'events');
    };

    Router.prototype.contact = function() {
      this.scrollTo(Backbone.history.fragment, null);
      return this;
    };

    return Router;

  })(Backbone.Router);

  $((function(_this) {
    return function() {
      root.app = new Dgroupe.Routers.Router();
      return Backbone.history.start({
        pushState: true,
        root: Dgroupe.helpers.baseFolder
      });
    };
  })(this));

  $(window).load(function() {
    return root.app.navigateOnLoad();
  });

  $('a.route, .portfolioBtn').click(function(e) {
    var linkTarget;
    e.preventDefault();
    linkTarget = $(this).attr('href');
    return Backbone.history.navigate(linkTarget, true);
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


  /*$('.closeBtn').click ->
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
   */

}).call(this);

//# sourceMappingURL=app.map