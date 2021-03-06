// Generated by CoffeeScript 1.7.1
(function() {
  var $, baseFolder, root;

  root = typeof window !== "undefined" && window !== null ? window : global;

  $ = root.jQuery;

  root.template = function(id) {
    return Handlebars.compile($('#' + id).html());
  };

  root.removeTrailingSlash = function(route) {
    var index;
    index = route.length - 1;
    if (route.charAt(index) === '/') {
      return route = route.substring(0, index);
    } else {
      return route;
    }
  };

  baseFolder = window.location.pathname.replace('/', '').split('/')[0];

  root.Dgroupe = (function() {
    function Dgroupe() {}

    Dgroupe.Models = {};

    Dgroupe.Collections = {};

    Dgroupe.Views = {};

    Dgroupe.Routers = {};

    Dgroupe.helpers = {
      baseFolder: baseFolder,
      rootUrl: window.location.protocol + "//" + window.location.host + "/" + baseFolder
    };

    return Dgroupe;

  })();

  root.Backbone.View.prototype.close = function() {
    var _ref;
    this.remove();
    if ((_ref = this.model) != null) {
      _ref.unbind();
    }
    this.stopListening();
    return this.closed = true;
  };

}).call(this);

//# sourceMappingURL=init.map
