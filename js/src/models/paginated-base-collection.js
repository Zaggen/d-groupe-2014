// Generated by CoffeeScript 1.7.1
(function() {
  var Dgroupe, root,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  root = typeof window !== "undefined" && window !== null ? window : global;

  Dgroupe = root.Dgroupe;

  Dgroupe.Collections.Paginated = (function(_super) {
    __extends(Paginated, _super);

    function Paginated() {
      return Paginated.__super__.constructor.apply(this, arguments);
    }

    Paginated.prototype.fetchPage = function(page, callback) {
      if (page == null) {
        page = 1;
      }
      console.log('fetching page collection', page);
      $.event.trigger({
        type: 'showLoader'
      });
      return this.fetch({
        reset: true,
        data: {
          page: page
        },
        success: (function(_this) {
          return function(collection, response) {
            $.event.trigger({
              type: 'hideLoader'
            });
            if (callback) {
              callback(collection, response);
            }
            return true;
          };
        })(this),
        error: function(collection, response) {
          console.log('Error while fetching the collection');
          console.log(response);
          return false;
        }
      }, this);
    };

    return Paginated;

  })(Backbone.Collection);

}).call(this);

//# sourceMappingURL=paginated-base-collection.map
