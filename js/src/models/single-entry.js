// Generated by CoffeeScript 1.7.1
(function() {
  var Dgroupe, root,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  root = typeof window !== "undefined" && window !== null ? window : global;

  Dgroupe = root.Dgroupe;

  Dgroupe.Models.SingleEntry = (function(_super) {
    __extends(SingleEntry, _super);

    function SingleEntry() {
      return SingleEntry.__super__.constructor.apply(this, arguments);
    }

    SingleEntry.prototype.fetch = function() {
      this.url = '/' + Backbone.history.fragment;
      console.log('@url', this.url);
      SingleEntry.__super__.fetch.apply(this, arguments);
      return true;
    };

    return SingleEntry;

  })(Dgroupe.Models.Base);

}).call(this);

//# sourceMappingURL=single-entry.map
