// Generated by CoffeeScript 1.7.1
(function() {
  var Dgroupe, root,
    __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  root = typeof window !== "undefined" && window !== null ? window : global;

  Dgroupe = root.Dgroupe;

  Dgroupe.Views.Pagination = (function(_super) {
    __extends(Pagination, _super);

    function Pagination() {
      this.changePage = __bind(this.changePage, this);
      return Pagination.__super__.constructor.apply(this, arguments);
    }

    Pagination.prototype.className = 'pageNavi delayedFadeIn';

    Pagination.prototype.tagName = 'ul';

    Pagination.prototype.events = {
      'click li:not(.dots)': 'changePage'
    };

    Pagination.prototype.initialize = function(options) {
      var _ref, _ref1;
      this.collection = options.collection;
      this.url = (_ref = options.url) != null ? _ref : this.collection.url;
      this.updateRoutes = (_ref1 = options.updateRoutes) != null ? _ref1 : true;
      this.listenTo(this.collection, 'reset', this.render);
      if ($('#' + this.id)[0] != null) {
        this.setElement('#' + this.id);
        this.pageQ = parseInt(this.$el.data('pageQuantity'));
        return this.render();
      }
    };

    Pagination.prototype.getCurrentPage = function() {
      var currentRoute, lastIndex, page, urlSegments;
      currentRoute = root.removeTrailingSlash(window.location.pathname);
      urlSegments = currentRoute.split('/');
      lastIndex = urlSegments.length - 1;
      page = parseInt(urlSegments[lastIndex]);
      if (!_.isNaN(page)) {
        return page;
      } else {
        return 1;
      }
    };

    Pagination.prototype.updatePage = function() {
      this.collection.fetchPage(this.currentPageNum);
      this.updateRoute();
      return this;
    };

    Pagination.prototype.updateRoute = function() {
      var route;
      if (this.updateRoutes) {
        route = this.url + '/' + this.currentPageNum;
        Backbone.history.navigate(route);
      }
      return this;
    };

    Pagination.prototype.changePage = function(e) {
      this.$('.navBtns').removeClass('selectedNav');
      this.currentPageNum = parseInt($(e.currentTarget).text(), 10);
      this.updatePage();
      $(e.currentTarget).addClass('selectedNav');
      return this;
    };

    Pagination.prototype.render = function() {
      var btnsLimit, halfLimit, leftHalf, liItem, maxRange, minRange, nodes, num, rightHalf, selectedPage, skipped, x, _i, _j, _k, _ref;
      if (this.currentPageNum == null) {
        this.currentPageNum = this.getCurrentPage();
      }
      if (this.pageQ == null) {
        this.pageQ = this.collection.pageQ;
      }
      if ((this.pageQ != null) && this.pageQ > 1) {
        nodes = [];
        btnsLimit = 4;
        selectedPage = this.currentPageNum;
        halfLimit = btnsLimit / 2;
        leftHalf = Math.ceil(halfLimit);
        rightHalf = btnsLimit - leftHalf;
        for (x = _i = leftHalf; leftHalf <= 0 ? _i <= 0 : _i >= 0; x = leftHalf <= 0 ? ++_i : --_i) {
          if (selectedPage - x <= 0) {
            leftHalf--;
            rightHalf++;
          }
        }
        for (x = _j = rightHalf; rightHalf <= 0 ? _j <= 0 : _j >= 0; x = rightHalf <= 0 ? ++_j : --_j) {
          if (selectedPage + x >= this.pageQ) {
            leftHalf++;
            rightHalf--;
          }
        }
        minRange = selectedPage - leftHalf;
        maxRange = selectedPage + rightHalf;
        skipped = false;
        for (num = _k = 1, _ref = this.pageQ; 1 <= _ref ? _k <= _ref : _k >= _ref; num = 1 <= _ref ? ++_k : --_k) {
          if (num === 1 || (minRange <= num && num <= maxRange) || num === this.pageQ) {
            liItem = new Dgroupe.Views.NaviItem({
              pageNum: num,
              className: num === selectedPage ? 'navBtns pageBtn selectedNav' : 'navBtns pageBtn',
              parentInstance: this
            });
            skipped = false;
          } else {
            if (!skipped) {
              liItem = new Dgroupe.Views.NaviItem({
                pageNum: '...',
                className: 'navBtns dots'
              });
              skipped = true;
            }
          }
          nodes.push(liItem.render().el);
        }
        this.$el.html(nodes);
        this.delegateEvents();
      }
      return this;
    };

    return Pagination;

  })(Backbone.View);

  Dgroupe.Views.NaviItem = (function(_super) {
    __extends(NaviItem, _super);

    function NaviItem() {
      return NaviItem.__super__.constructor.apply(this, arguments);
    }

    NaviItem.prototype.tagName = 'li';

    NaviItem.prototype.className = 'navBtns';

    NaviItem.prototype.initialize = function(options) {
      return this.pageNum = options.pageNum;
    };

    NaviItem.prototype.render = function() {
      this.$el.text(this.pageNum);
      return this;
    };

    return NaviItem;

  })(Backbone.View);

  Dgroupe.Views.ReturnToListBtn = (function(_super) {
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
      this.listView.fetchCollection(this.listView.page, true);
      this.$el.addClass('hidden');
      return this.nav.$el.removeClass('hidden');
    };

    return ReturnToListBtn;

  })(Backbone.View);

}).call(this);

//# sourceMappingURL=pagination.map
