// Generated by CoffeeScript 1.7.1
(function() {
  var Dgroupe, root,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  root = typeof window !== "undefined" && window !== null ? window : global;

  Dgroupe = root.Dgroupe;

  Dgroupe.Models.Base = (function(_super) {
    __extends(Base, _super);

    function Base() {
      return Base.__super__.constructor.apply(this, arguments);
    }

    Base.prototype.fetch = function() {
      $.event.trigger({
        type: 'showLoader'
      });
      return Base.__super__.fetch.apply(this, arguments).success(_.delay(function() {
        return $.event.trigger({
          type: 'hideLoader'
        });
      }, 550));
    };

    return Base;

  })(Backbone.Model);

}).call(this);

//# sourceMappingURL=base-model.map
