// Generated by CoffeeScript 1.7.1
(function() {
  var Dgroupe, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  root = typeof window !== "undefined" && window !== null ? window : global;

  Dgroupe = root.Dgroupe;

  Dgroupe.Views.Gallery = (function(_super) {
    __extends(Gallery, _super);

    function Gallery() {
      this.lightboxHandler = __bind(this.lightboxHandler, this);
      return Gallery.__super__.constructor.apply(this, arguments);
    }

    Gallery.prototype.template = root.template('galleryTemplate');

    Gallery.prototype.tagName = 'div';

    Gallery.prototype.className = 'grid';

    Gallery.prototype.events = {
      'click img': 'lightboxHandler'
    };

    Gallery.prototype.initialize = function() {
      console.log('this', this);
      Gallery.__super__.initialize.apply(this, arguments);
      if ($('#' + this.id) != null) {
        this.setElement('#' + this.id);
        return this.populateGalImgs();
      }
    };

    Gallery.prototype.lightboxHandler = function(e) {
      var index;
      e.preventDefault();
      this.setLightBox();
      index = parseInt($(e.currentTarget).data('index'));
      console.log('opening lightbox with index', index);
      return this.openLightBox(index);
    };

    Gallery.prototype.setLightBox = function() {
      this.getAllGalItems();
      return $.event.trigger({
        type: 'setLightbox',
        collection: this.galleryImgs
      });
    };

    Gallery.prototype.openLightBox = function(index) {
      return $.event.trigger({
        type: 'showLightBox',
        modelIndex: index
      });
    };

    Gallery.prototype.populateGalImgs = function() {
      var galleryImgs;
      console.log('populating collection gallery for view');
      galleryImgs = [];
      this.$('a').each(function() {
        var $link, json;
        json = {};
        $link = $(this);
        json.title = $link.attr('title');
        json.fullImg = $link.attr('href');
        json.thumbnail = $link.find('img').attr('src');
        return galleryImgs.push(json);
      });
      return this.galleryImgs = new Backbone.Collection(galleryImgs);
    };

    Gallery.prototype.getAllGalItems = function() {
      var galleryImgs;
      if (this.galleryImgs == null) {
        galleryImgs = [];
        this.collection.each(function(item) {
          var imgs;
          imgs = item.toJSON().galleryItems;
          return imgs.forEach(function(imgArr) {
            return galleryImgs = galleryImgs.concat(imgArr);
          });
        });
        console.log('galleryItems', galleryImgs);
        return this.galleryImgs = new Backbone.Collection(galleryImgs);
      }
    };

    Gallery.prototype.render = function() {
      this.galleryImgs = null;
      console.log(this.el);
      if (_.isEmpty(this.collection.models)) {
        console.log('collection is empty, fetching it now');
        this.collection.fetchPage(1);
      } else {
        console.log('collection fetched, now rendering');
        this.$el.html(this.template({
          gallery: this.collection.toJSON()
        }));
      }
      this.delegateEvents();
      return this;
    };

    return Gallery;

  })(Dgroupe.Views.CollectionView);

}).call(this);

//# sourceMappingURL=gallery.map
