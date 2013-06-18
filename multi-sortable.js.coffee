(($) ->
  $.widget "ui.multiSortable", $.ui.sortable,
    version: "0.0.1"
    ready: false
    options:
      appendTo: "parent"
      axis: false
      bondAt: null
      connectWith: false
      containment: false
      cursor: "auto"
      cursorAt: false
      dropOnEmpty: true
      forcePlaceholderSize: false
      forceHelperSize: false
      grid: false
      handle: false
      helper: "original"
      items: "> *"
      opacity: false
      placeholder: false
      revert: false
      scroll: true
      scrollSensitivity: 100
      scrollSpeed: 50
      scope: "default"
      tolerance: "intersect"
      zIndex: 1000
      multipleSelectKey: "shiftKey"
      multipleSelectTrigger: "> *"
      multipleSelectClass: "ui-selected"
      activate: null
      beforeStop: null
      change: null
      deactivate: null
      out: null
      over: null
      receive: null
      remove: null
      sort: null
      start: null
      stop: null
      update: null

    _create: ->
      options = @options
      @offset = @element.offset()
      @containerCache = {}
      @refresh()
      @_bindClick options
      @_bindStart options
      @_bindStop options
      @element.sortable options
      @_handleAjax options
      @_disableSort()
      @_enableSort()

    destroy: ->
      @_destroy()
      @element.off "sortstart.#{@widgetName}"
      @element.off "sortstop.#{@widgetName}"
      @element.off "sortreceive.#{@widgetName}"
      $(document).off "keydown.#{@widgetName}"
      $(document).off "keyup.#{@widgetName}"
      $(document).off "selectstart.#{@widgetName}"
      i = @items.length - 1
      while i >= 0
        @items[i].item.removeData "#{@widgetName}-item"
        i--
      this

    _setOption: (option, value) ->
      $.Widget::_setOption.apply this, arguments

    _bindClick: (options) ->
      @element.find(options.multipleSelectTrigger).off "click.#{@widgetName}"
      @element.find(options.multipleSelectTrigger).on "click.#{@widgetName}", (event) ->
        if event[options.multipleSelectKey]
          $(@).toggleClass options.multipleSelectClass
        else
          $("." + options.multipleSelectClass).removeClass options.multipleSelectClass

    _bindStart: (options) ->
      @element.on "sortstart.#{@widgetName}", (event, ui) ->
        others = $("." + options.multipleSelectClass + ":not(.ui-sortable-placeholder)").not(ui.item)
        ui.item.removeData 'others-sorted'
        if others.length > 0
          ui.item.data('others-sorted', others)
          ui.item.prepend "<span class='selected_count'>#{others.length+1}</span>"
          others.hide()

    _bindStop: (options) ->
      @element.on "sortstop.#{@widgetName}", (event, ui) ->
        selected = ui.item.data 'others-sorted'
        ui.item.removeClass(options.multipleSelectClass)
        if selected
          ui.item.after selected
          selected.show()
          selected.removeClass options.multipleSelectClass
          ui.item.find('.selected_count').remove()

    _handleAjax: (options) ->
      $(document).ajaxComplete (e) =>
        @_bindClick(options)

    _disableSort: ->
      $(document).on "keydown.#{@widgetName}", (e) =>
        @element.sortable('disable') if e.shiftKey
        $(document).on "selectstart.#{@widgetName}", (e) ->
          e.preventDefault()

    _enableSort: ->
      $(document).on "keyup.#{@widgetName}", (e) =>
        @element.sortable('enable') if e.keyCode is 16

) jQuery
