(function() {
  ;
  (function($, window, document) {
    var Plugin, defaults, pluginName;
    pluginName = 'lazyload';
    defaults = {
      threshold: 0,
      failure_limit: 0,
      event: "scroll",
      effect: "show",
      data_attribute: "original",
      skip_invisible: true,
      appear: null,
      load: null,
      container: null
    };
    Plugin = (function() {

      function Plugin(element, options) {
        var _base;
        this.element = element;
        this.$element = $(element);
        this.options = $.extend({}, defaults, options);
        if ((_base = this.options).container == null) _base.container = window;
        this._defaults = defaults;
        this._name = pluginName;
        this.init();
        this.update();
      }

      Plugin.prototype.init = function() {
        var _this = this;
        if (this.options.container === void 0 || this.options.container === null) {
          this.$container = $(window);
        } else {
          this.$container = $(this.options.container);
        }
        this.element.loaded = false;
        if (this.options.event.indexOf("scroll") === 0) {
          this.$container.on(this.options.event, null, null, function() {
            return $.data(_this.element, "plugin_" + pluginName).update();
          });
        } else {
          this.$element.on(this.options.event, null, null, function() {
            if (!_this.element.loaded) return _this.$element.trigger("appear");
          });
        }
        $(window).on("resize", null, null, function() {
          return $.data(_this.element, "plugin_" + pluginName).update();
        });
        return this.$element.one("appear", function() {
          return _this.$element.on("load", null, null, function() {
            _this.$element.hide().attr("src", _this.$element.data(_this.options.data_attribute))[_this.options.effect](_this.options.effect_speed).off();
            return _this.element.loaded = true;
          }).attr("src", _this.$element.data(_this.options.data_attribute));
        });
      };

      Plugin.prototype.update = function() {
        var counter;
        counter = 0;
        if (this.options.skip_invisible && !this.$element.is(":visible")) return;
        if (this.abovethetop() || this.leftofbegin()) {} else if (!this.bellowthefold() && !this.rightoffold()) {
          return this.$element.trigger("appear");
        }
      };

      Plugin.prototype.bellowthefold = function() {
        var fold;
        fold = 0;
        if (this.$container.is($(window))) {
          fold = this.$container.height() + this.$container.scrollTop();
        } else {
          fold = this.$container.offset().top + this.$container.height();
        }
        return fold <= this.$element.offset().top - this.options.threshold;
      };

      Plugin.prototype.rightoffold = function() {
        var fold;
        fold = 0;
        if (this.$container.is($(window))) {
          fold = this.$container.width() + this.$container.scrollLeft();
        } else {
          fold = this.$container.offset().left + this.$container.width();
        }
        return fold <= this.$element.offset().left - this.options.threshold;
      };

      Plugin.prototype.abovethetop = function() {
        var fold;
        fold = 0;
        if (this.$container.is($(window))) {
          fold = this.$container.scrollTop();
        } else {
          fold = this.$container.offset().top;
        }
        return fold >= this.$element.offset().top + this.options.threshold + this.$element.height();
      };

      Plugin.prototype.leftofbegin = function() {
        var fold;
        fold = 0;
        if (this.$container.is($(window))) {
          fold = this.$container.scrollLeft();
        } else {
          fold = this.$container.offset().left;
        }
        return fold >= this.$element.offset().left + this.options.threshold + this.$element.width();
      };

      Plugin.prototype.inviewport = function() {
        return !this.rightoffold() && !this.rightoffold() && !this.bellowthefold() && !this.abovethetop();
      };

      return Plugin;

    })();
    return $.fn[pluginName] = function(options) {
      var item, _i, _len, _results;
      _results = [];
      for (_i = 0, _len = this.length; _i < _len; _i++) {
        item = this[_i];
        if (!$.data(item, "plugin_" + pluginName)) {
          _results.push($.data(item, "plugin_" + pluginName, new Plugin(item, options)));
        } else {
          _results.push(void 0);
        }
      }
      return _results;
    };
  })(jQuery, window, document);

}).call(this);
