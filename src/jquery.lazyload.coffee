#  Project:     Caffeinated-Img-Load
#  Description: A JQuery Plugin similar to lazy load. 
#  Author:      Jacob Johansen
#  License:     Licensed under the MIT license:
#                 http://www.opensource.org/licenses/mit-license.php
#

# the semi-colon before function invocation is a safety net against concatenated
# scripts and/or other plugins which may not be closed properly.
``
# Note that when compiling with coffeescript, the plugin is wrapped in another
# anonymous function. We do not need to pass in undefined as well, since
# coffeescript uses (void 0) instead.
(($, window, document) ->
  # window and document are passed through as local variables rather than globals
  # as this (slightly) quickens the resolution process and can be more efficiently
  # minified (especially when both are regularly referenced in your plugin).

  # Create the defaults once
  pluginName = 'lazyload'

  defaults = 
    threshold: 0
    failure_limit: 0 # not currently implimented
    event: "scroll"
    effect: "show"
    data_attribute: "original"
    skip_invisible: true
    appear: null # not currently implimented
    load: null   # not currently implimented
    container: null

  # The actual plugin constructor
  class Plugin
    constructor: (@element, options) ->
      # jQuery has an extend method which merges the contents of two or
      # more objects, storing the result in the first object. The first object
      # is generally empty as we don't want to alter the default options for
      # future instances of the plugin
      @$element = $(element)
      @options = $.extend {}, defaults, options
      @options.container ?= window
      @_defaults = defaults
      @_name = pluginName
      @init()
      @update()
    init: ->
      # Place initialization logic here
      # You already have access to the DOM element and the options via the instance,
      # e.g., this.element and this.options
      if @options.container is undefined or @options.container is null
        @$container = $(window)
      else
        @$container = $(@options.container)

      @element.loaded = false

      if @options.event.indexOf("scroll") is 0
        @$container.on @options.event, null, null, =>
          $.data(@element,"plugin_#{pluginName}").update()
      else
        @$element.on @options.event, null, null, =>
          if not @element.loaded
            @$element.trigger "appear"

      $(window).on "resize", null, null, =>
        $.data(@element,"plugin_#{pluginName}").update()
      
      @$element.one "appear", =>
        @$element
          .on "load", null, null, =>
            @$element
              .hide()
              .attr("src", @$element.data(@options.data_attribute))[@options.effect](@options.effect_speed)
              .off()
            @element.loaded = true
          .attr "src", @$element.data @options.data_attribute

    update: ->
      counter = 0
      if @options.skip_invisible and not @$element.is ":visible"
        return
      if(@abovethetop() or @leftofbegin())
        return
      else if not @bellowthefold() and not @rightoffold()
        @$element.trigger "appear"

    bellowthefold: ->
      fold = 0

      if @$container.is $(window)
        fold = @$container.height() + @$container.scrollTop()
      else
        fold = @$container.offset().top + @$container.height()
      
      return fold <= @$element.offset().top - @options.threshold
    
    rightoffold: ->
      fold = 0

      if @$container.is $(window)
        fold = @$container.width() + @$container.scrollLeft()
      else
        fold = @$container.offset().left + @$container.width()
      
      return fold <= @$element.offset().left - @options.threshold

    abovethetop: ->
      fold = 0

      if @$container.is $(window)
        fold = @$container.scrollTop()
      else
        fold = @$container.offset().top
      
      return fold >= @$element.offset().top + @options.threshold + @$element.height()

    leftofbegin: ->  
      fold = 0

      if @$container.is $(window)
        fold = @$container.scrollLeft()
      else
        fold = @$container.offset().left
      
      return fold >= @$element.offset().left + @options.threshold + @$element.width()

    inviewport: ->
      return not @rightoffold() and not @rightoffold() and
      not @bellowthefold() and not @abovethetop()

  # A really lightweight plugin wrapper around the constructor,
  # preventing against multiple instantiations
  $.fn[pluginName] = (options) ->
    for item in @
      if !$.data(item, "plugin_#{pluginName}")
        $.data(item, "plugin_#{pluginName}", new Plugin(item, options))
)(jQuery, window, document)