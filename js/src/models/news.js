// Generated by CoffeeScript 1.7.1
(function() {
  var Dgroupe, root,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  root = typeof window !== "undefined" && window !== null ? window : global;

  Dgroupe = root.Dgroupe;

  Dgroupe.Models.News = (function(_super) {
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

  Dgroupe.Collections.News = (function(_super) {
    __extends(News, _super);

    function News() {
      return News.__super__.constructor.apply(this, arguments);
    }

    News.prototype.model = Dgroupe.Models.News;

    News.prototype.url = '/news-feed';

    return News;

  })(Backbone.Collection);

}).call(this);

//# sourceMappingURL=news.map
